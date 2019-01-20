//
//  CwlAdapter.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/08/09.
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

public struct Adapter<State: AdapterState>: StateContainer, SignalInputInterface, SignalInterface {
	public typealias OutputValue = State.Notification
	public typealias InputValue = State.Message
	private enum Keys: CodingKey { case `var` }
	
	private let executionContext = State.executionContext
	public let multiInput: SignalMultiInput<State.Message>
	public var input: SignalInput<State.Message> { return multiInput }
	
	public let combinedSignal: SignalMulti<State.Output>
	public var signal: Signal<State.Notification> {
		return combinedSignal.compactMapActivation(select: .first, context: executionContext, activation: { $0.state.resume() }, remainder: { $0.notification })
	}
	
	private init(content: State.Output?) {
		let (i, sig) = Signal<State.Message>.multiChannel().tuple
		multiInput = i
		let initializer = { (message: State.Message) throws -> State.Output? in
			try State.initialize(message: message, feedback: i)
		}
		combinedSignal = sig.reduce(context: executionContext, initializer: initializer) { (content: State.Output, message: State.Message) throws -> State.Output in
			try content.state.reduce(message: message, feedback: i)
		}
	}
	
	public init(from decoder: Decoder) throws {
		if State.PersistentValue.self == NonPersistentAdapterState.self {
			self.init()
			return
		}
		
		// Decoding must:
		// * Use keyed container
		// * Call `decode`, not `decodeIfPresent`
		// * Catch errors from the `decode` (using try? and optional unwrapping is insufficient)
		// Unless I've missed something, this specific pattern appears to be necessary to correctly decode potentially optional `RB.PersistentState` without *knowing* whether it is defined as an optional – but also handle a situation where it might not be present at all.
		let c = try decoder.container(keyedBy: Keys.self)
		let p = try c.decode(State.PersistentValue.self, forKey: .var)
		self.init(content: State.Output(state: State(persistentValue: p), notification: nil))
	}
	
	public init(initial: State? = nil) {
		self.init(content: initial.map { State.Output(state: $0, notification: nil) })
	}
	
	public func encode(to encoder: Encoder) throws {
		if State.PersistentValue.self != NonPersistentAdapterState.self, let s = stateSignal.peek() {
			var c = encoder.container(keyedBy: Keys.self)
			try c.encode(s.persistentValue, forKey: .var)
		}
	}
	
	public func cancel() {
		if State.self is StateContainer.Type, let value = stateSignal.peek(), var sc = value as? StateContainer {
			sc.cancel()
		}
		input.cancel()
	}
	
	public var childValues: [StateContainer] {
		if State.self is StateContainer.Type, let value = stateSignal.peek(), let sc = value as? StateContainer {
			return sc.childValues
		}
		return []
	}
	
	public var persistentValueChanged: Signal<Void> {
		// No persistent value
		if State.PersistentValue.self == Void.self {
			return Signal<Void>.preclosed()
		}
		
		// Persistent value without child persistent value. Emit post-activation changes
		if !(State.self is StateContainer.Type) {
			return stateSignal.map { _ in () }.dropActivation()
		}
		
		// Persistent value with child persistent values. FlatMap over all child changes. NOTE: since the child will not emit its initial value, we must start with one.
		return combinedSignal.flatMapLatest { (content: State.Output) -> Signal<Void> in
			guard let state = content.state as? StateContainer else { return .preclosed(()) }
			return state.persistentValueChanged.startWith(())
		}.dropActivation()
	}
	
}
