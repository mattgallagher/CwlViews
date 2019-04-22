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

public struct ModelState<Wrapped, M, N>: AdapterState {
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
	
	public init(async: Bool = false, initial: Wrapped, resumer: @escaping (_ model: Wrapped) -> Notification? = { _ in nil }, reducer: @escaping (_ model: inout Wrapped, _ message: Message, _ feedback: SignalMultiInput<Message>) throws -> Notification?) {
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


public extension Adapter {
	func sync<Wrapped, R, M, N>(_ processor: (Wrapped) throws -> R) throws -> R where ModelState<Wrapped, M, N> == State {
		// Don't `peek` inside the `invokeSync` since that would require re-entering the `executionContext`.
		let wrapped = try combinedSignal.capture().get().state.wrapped
		return try executionContext.invokeSync { return try processor(wrapped) }
	}
	
	func slice<Wrapped, Processed, M, N>(resume: N? = nil, _ processor: @escaping (Wrapped, N) throws -> Signal<Processed>.Next) -> Signal<Processed> where ModelState<Wrapped, M, N> == State {
		let s: Signal<State.Output>
		if let r = resume {
			s = combinedSignal.compactMapLatestActivation(context: executionContext) { ($0.state, r) }
		} else {
			s = combinedSignal
		}
		return s.transform(context: executionContext) { result in
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
	
	func slice<Value, Wrapped, Processed, M, N>(initial: Value, resume: N? = nil, _ processor: @escaping (inout Value, Wrapped, N) throws -> Signal<Processed>.Next) -> Signal<Processed> where ModelState<Wrapped, M, N> == State {
		let s: Signal<State.Output>
		if let r = resume {
			s = combinedSignal.compactMapLatestActivation(context: executionContext) { ($0.state, r) }
		} else {
			s = combinedSignal
		}
		return s.transform(initialState: initial, context: executionContext) { value, result in
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

	func logJson<Wrapped, M, N, Value>(keyPath: KeyPath<Wrapped, Value>, prefix: String = "", formatting: JSONEncoder.OutputFormatting = .prettyPrinted) -> Lifetime where State == ModelState<Wrapped, M, N>, Value: Encodable {
		return combinedSignal.subscribeValues(context: executionContext) { (state, _) in
			let enc = JSONEncoder()
			enc.outputFormatting = formatting
			if let data = try? enc.encode(state.wrapped[keyPath: keyPath]), let string = String(data: data, encoding: .utf8) {
				print("\(prefix)\(string)")
			}
		}
	}
}
