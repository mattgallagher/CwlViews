//
//  CwlVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public enum VarChange<Value> {
	case set(Value)
	case update(Value)
	case notify(Value)
}

public struct VarBehavior<Value: Codable>: StateAdapterBehavior {
	public typealias State = Value
	public typealias Message = VarChange<Value>
	public typealias Notification = Value
	public typealias PersistentState = Value
	
	public static func reduce(state: inout State, message: Message) -> Notification? {
		switch message {
		case .set(let v):
			state = v
			return v
		case .update(let v):
			state = v
			return nil
		case .notify(let v):
			return v
		}
	}
	
	public static func resume(state: State) -> Notification? {
		return state
	}
	
	public static func initialize(message: Message) -> (Value?, Value?) {
		switch message {
		case .set(let v): return (v, v)
		case .update(let v): return (v, nil)
		case .notify(let v): return (nil, v)
		}
	}
}

public struct Var<Value: Codable>: StateContainer, SignalInputInterface, SignalInterface {
	public typealias OutputValue = Value
	public typealias InputValue = Value
	
	public let adapter: StateAdapter<VarBehavior<Value>>
	
	public var input: SignalInput<Value> { return Input().map { .set($0) }.bind(to: adapter.input) }
	public var signal: Signal<Value> { return adapter.signal }
	
	public init(_ initialValue: Value) {
		adapter = StateAdapter(initialValue)
	}
	public var updatingInput: SignalInput<Value> {
		return Input().map { .update($0) }.bind(to: adapter.input)
	}
	
	public var notifyingInput: SignalInput<Value> {
		return Input().map { .notify($0) }.bind(to: adapter.input)
	}
	
	public func saveToCoder(_ coder: NSCoder) {
		coder.encodeLatest(from: adapter.stateSignal)
	}
	
	public func restoreFromCoder(_ coder: NSCoder) {
		coder.decodeSend(to: input)
	}
	
	public var persistentValueChanged: Signal<Void> {
		return adapter.persistentValueChanged
	}
	
	public func logJson(prefix: String = "") -> SignalOutput<Var<Value>> {
		return persistentValueChanged.map { _ in
			self
		}.startWith(self).logJson(prefix: prefix)
	}
	
	public var childValues: [StateContainer] {
		return adapter.childValues
	}
	
	public func encode(to encoder: Encoder) throws {
		var c = encoder.singleValueContainer()
		try c.encode(adapter)
	}
	
	public init(from decoder: Decoder) throws {
		let c = try decoder.singleValueContainer()
		self.adapter = try c.decode(StateAdapter<VarBehavior<Value>>.self)
	}
}
