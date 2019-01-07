//
//  CwlVariable.swift
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

public struct NonPersistentStateAdapterState: Codable, Error {}

public protocol StateAdapterBehavior {
	associatedtype State
	associatedtype Message
	associatedtype Notification
	associatedtype PersistentState: Codable = NonPersistentStateAdapterState
	
	static func reduce(state: inout State, message: Message) -> Notification?
	static func resume(state: State) -> Notification?
	static func initialize(message: Message) -> (State?, Notification?)
	static func persistentState(_ state: State) -> PersistentState
	static func stateFromPersistentState(_ state: PersistentState) throws -> State
}

extension StateAdapterBehavior where PersistentState == NonPersistentStateAdapterState {
	public static func childValues(_ state: State) -> [StateContainer]? {
		return nil
	}
	
	public static func persistentState(_ state: State) -> PersistentState {
		return NonPersistentStateAdapterState()
	}
	
	public static func stateFromPersistentState(_ state: PersistentState) throws -> State {
		throw NonPersistentStateAdapterState()
	}
}

extension StateAdapterBehavior where PersistentState == State {
	public static func persistentState(_ state: State) -> PersistentState {
		return state
	}
	
	public static func stateFromPersistentState(_ state: PersistentState) throws -> State {
		return state
	}
}

public struct StateAdapter<RB: StateAdapterBehavior>: StateContainer, SignalInputInterface, SignalInterface {
	public typealias OutputValue = RB.Notification
	public typealias InputValue = RB.Message
	
	private enum Content {
		case none
		case state(RB.State)
		case notification(RB.State?, RB.Notification?)
	}
	
	private let channel: SignalChannel<SignalMultiInput<RB.Message>, SignalMulti<Content>>
	
	public var input: SignalInput<RB.Message> { return channel.input }
	public var signal: Signal<RB.Notification> { return channel.signal.compactMap {
		switch $0 {
		case .none: return nil
		case .state(let s): return RB.resume(state: s)
		case .notification(_, let n): return n
		}
	} }
	
	private init(initialState: Content) {
		channel = Signal<RB.Message>.multiChannel().reduce(initialState: initialState) { (content: Content, message: RB.Message) -> Content in
			switch content {
			case .none, .notification(.none, _):
				let (possibleState, notification) = RB.initialize(message: message)
				return .notification(possibleState, notification)
			case .state(var s):
				let n = RB.reduce(state: &s, message: message)
				return .notification(s, n)
			case .notification(.some(var s), _):
				let n = RB.reduce(state: &s, message: message)
				return .notification(s, n)
			}
		}
	}
	
	public init(_ initialValue: RB.State) {
		self.init(initialState: Content.state(initialValue))
	}
	
	public init() {
		self.init(initialState: Content.none)
	}
	
	public func cancel() {
		if RB.State.self is StateContainer.Type, let value = stateSignal.peek(), var sc = value as? StateContainer {
			sc.cancel()
		}
		input.cancel()
	}
	
	public var childValues: [StateContainer] {
		if RB.State.self is StateContainer.Type, let value = stateSignal.peek(), let sc = value as? StateContainer {
			return sc.childValues
		}
		return []
	}

	public var stateSignal: Signal<RB.State> {
		return channel.signal.compactMap { (content: Content) -> RB.State? in
			switch content {
			case .none, .notification(nil, _): return nil
			case .state(let s): return s
			case .notification(.some(let s), _): return s
			}
		}
	}
	
	public var persistentValueChanged: Signal<Void> {
		if RB.PersistentState.self == NonPersistentStateAdapterState.self {
			return Signal<Void>.preclosed()
		}
		
		if !(RB.State.self is StateContainer.Type) {
			return stateSignal.map { _ in () }.dropActivation()
		}
		
		return channel.signal.flatMapLatest { (content: Content) -> Signal<Void> in
			switch content {
			case .state(let s):
				return (s as? StateContainer)?.persistentValueChanged ?? Signal<Void>.preclosed()
			case .notification(let s as StateContainer, _):
				return s.persistentValueChanged.startWith(())
			default: return Signal<Void>.preclosed()
			}
		}.dropActivation()
	}
	
	enum Keys: CodingKey { case `var` }
	
	public func encode(to encoder: Encoder) throws {
		if RB.PersistentState.self != NonPersistentStateAdapterState.self, let s = stateSignal.peek() {
			var c = encoder.container(keyedBy: Keys.self)
			try c.encode(RB.persistentState(s), forKey: .var)
		}
	}
	
	public init(from decoder: Decoder) throws {
		if RB.PersistentState.self == NonPersistentStateAdapterState.self {
			self.init()
			return
		}
		
		// Decoding must:
		// * Use keyed container
		// * Call `decode`, not `decodeIfPresent`
		// * Catch errors from the `decode` (using try? and optional unwrapping is insufficient)
		// Unless I've missed something, this specific pattern appears to be necessary to correctly decode potentially optional `RB.PersistentState` without *knowing* whether it is defined as an optional – but also handle a situation where it might not be present at all.
		let c = try decoder.container(keyedBy: Keys.self)
		let state = try c.decode(RB.PersistentState.self, forKey: .var)
		try self.init(RB.stateFromPersistentState(state))
	}
}
