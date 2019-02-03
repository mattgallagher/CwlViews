//
//  CwlModelState.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/24.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any purpose with or without
//  fee is hereby granted, provided that the above copyright notice and this permission notice
//  appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
//  SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
//  AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
//  NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
//  OF THIS SOFTWARE.
//

public struct ModelState<Wrapped, M, N>: NonPersistentAdapterState {
	public typealias Message = M
	public typealias Notification = N
	public let instanceContext: (Exec, Bool) 
	
	let reducer: (_ model: inout Wrapped, _ message: Message, _ feedback: SignalMultiInput<Message>) throws -> Notification?
	let resumer: (_ model: Wrapped) -> Notification?
	let wrapped: Wrapped
	
	init(previous: ModelState<Wrapped, M, N>, nextWrapped: Wrapped) {
		self.instanceContext = previous.instanceContext
		self.reducer = previous.reducer
		self.resumer = previous.resumer
		self.wrapped = nextWrapped
	}
	
	public init(async: Bool = false, initial: Wrapped, resumer: @escaping (_ model: Wrapped) -> Notification? = { _ in nil }, reducer: @escaping (_ model: inout Wrapped, _ message: Message, _ feedback: SignalMultiInput<Message>) throws -> Notification) {
		self.instanceContext = (Exec.syncQueue(), async)
		self.reducer = reducer
		self.resumer = resumer
		self.wrapped = initial
	}

	public func reduce(message: Message, feedback: SignalMultiInput<Message>) throws -> (state: ModelState<Wrapped, Message, Notification>, notification: N?) {
		var nextWrapped = wrapped
		let n = try reducer(&nextWrapped, message, feedback)
		return (ModelState<Wrapped, M, N>(previous: self, nextWrapped: nextWrapped), n)
	}
	
	public func resume() -> Notification? {
		return resumer(wrapped)
	}
}

extension Adapter {
	func slice<Wrapped, Processed, M, N>(resume: N?, _ processor: @escaping (Wrapped, N) throws -> Signal<Processed>.Next) -> Signal<Processed> where ModelState<Wrapped, M, N> == State {
		let s = combinedSignal.compactMapActivation(select: .last, context: executionContext, activation: { tuple in resume.map { (tuple.state, $0) } }, remainder: { $0 })
		return combinedSignal.transform(context: executionContext) { result in
			switch result {
			case .failure(let e): return .end(e)
			case .success(_, nil): return .none
			case .success(let wrapped, .some(let notification)):
				do {
					return try processor(wrapped.wrapped, notification)
				} catch {
					return .error(error)
				}
			}
		}
	}
	
	func slice<Value, Wrapped, Processed, M, N>(initial: Value, _ processor: @escaping (inout Value, Wrapped, N) throws -> Signal<Processed>.Next) -> Signal<Processed> where ModelState<Wrapped, M, N> == State {
		return combinedSignal.transform(initialState: initial, context: executionContext) { value, result in
			switch result {
			case .failure(let e): return .end(e)
			case .success(_, nil): return .none
			case .success(let wrapped, .some(let notification)):
				do {
					return try processor(&value, wrapped.wrapped, notification)
				} catch {
					return .error(error)
				}
			}
		}
	}
}
