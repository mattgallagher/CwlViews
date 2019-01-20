//
//  CwlVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct VarState<Value: Codable>: Codable, AdapterState {
	public enum Message {
		case set(Value)
		case update(Value)
		case notify(Value)
	}
	public typealias DefaultMessage = Value
	public typealias Notification = Value
	
	public let value: Value
	public init(value: Value) {
		self.value = value
	}
	
	public static func message(from: Value) -> VarState<Value>.Message {
		return .set(from)
	}
	
	public func reduce(message: Message, feedback: SignalMultiInput<Message>) -> Output {
		switch message {
		case .set(let v): return Output(state: VarState<Value>(value: v), notification: v)
		case .update(let v): return Output(state: VarState<Value>(value: v), notification: nil)
		case .notify(let v): return Output(state: self, notification: v)
		}
	}
	
	public func resume() -> Notification? {
		return value
	}
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output? {
		switch message {
		case .set(let v): return Output(state: VarState<Value>(value: v), notification: v)
		case .update(let v): return Output(state: VarState<Value>(value: v), notification: nil)
		case .notify: return nil
		}
	}
}

public typealias Var<Value: Codable> = Adapter<VarState<Value>>

public extension Adapter {
	init<Value>(_ value: Value) where VarState<Value> == State {
		self.init(initial: VarState<Value>(value: value))
	}
}

extension Adapter {
	public func updatingInput<Value>() -> SignalInput<Value> where State.Message == VarState<Value>.Message {
		return Input().map { .update($0) }.bind(to: message)
	}

	public func notifyingInput<Value>() -> SignalInput<Value> where State.Message == VarState<Value>.Message {
		return Input().map { .notify($0) }.bind(to: message)
	}
}
