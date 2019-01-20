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

public struct Adapter<State: AdapterState>: CodableContainer, SignalInputInterface, SignalInterface {
	public typealias OutputValue = State.Notification
	public typealias InputValue = State.DefaultMessage
	private enum Keys: CodingKey { case `var` }
	
	private let executionContext = State.executionContext
	public let multiInput: SignalMultiInput<State.Message>
	public var input: SignalInput<State.DefaultMessage> {
		if let i = multiInput as? SignalInput<State.DefaultMessage>  {
			return i
		} else {
			return Input<State.DefaultMessage>().map(State.message).bind(to: multiInput)
		}
	}
	public var message: SignalInput<State.Message> {
		return multiInput
	}
	
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
	
	public init(initial: State? = nil) {
		self.init(content: initial.map { State.Output(state: $0, notification: nil) })
	}
	
	public func cancel() {
		if State.self is CodableContainer.Type, let value = stateSignal.peek(), var sc = value as? CodableContainer {
			sc.cancel()
		}
		input.cancel()
	}
	
}

extension Adapter {
	public init(from decoder: Decoder) throws {
		self.init()
	}
	public func encode(to encoder: Encoder) throws {
	}
	public var codableValueChanged: Signal<Void> {
		return Signal<Void>.preclosed()
	}
	
	public var childCodableContainers: [CodableContainer] {
		return []
	}
}

extension Adapter where State: Codable {
	public init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: Keys.self)
		let p = try c.decode(State.self, forKey: .var)
		self.init(content: State.Output(state: p, notification: nil))
	}
	public func encode(to encoder: Encoder) throws {
		if let s = stateSignal.peek() {
			var c = encoder.container(keyedBy: Keys.self)
			try c.encode(s, forKey: .var)
		}
	}
	public var childCodableContainers: [CodableContainer] {
		if State.self is CodableContainer.Type, let value = stateSignal.peek(), let sc = value as? CodableContainer {
			return sc.childCodableContainers
		}
		return []
	}
	public var codableValueChanged: Signal<Void> {
		// Persistent value without child persistent value. Emit post-activation changes
		if !(State.self is CodableContainer.Type) {
			return stateSignal.map { _ in () }.dropActivation()
		}
		
		// Persistent value with child persistent values. FlatMap over all child changes. NOTE: since the child will not emit its initial value, we must start with one.
		return combinedSignal.flatMapLatest { (content: State.Output) -> Signal<Void> in
			guard let state = content.state as? CodableContainer else { return .preclosed(()) }
			return state.codableValueChanged.startWith(())
		}.dropActivation()
	}
}
