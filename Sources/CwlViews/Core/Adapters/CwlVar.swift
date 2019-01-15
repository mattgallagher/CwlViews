//
//  CwlVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct VarState<Value: Codable>: AdapterState {
	public enum Message {
		case set(Value)
		case update(Value)
		case notify(Value)
	}
	public typealias Notification = Value
	public typealias PersistentValue = Value
	
	public let persistentValue: Value
	public init(persistentValue: Value) {
		self.persistentValue = persistentValue
	}
	
	public func reduce(message: Message, feedback: SignalMultiInput<Message>) -> Output {
		switch message {
		case .set(let v): return Output(state: VarState<Value>(persistentValue: v), notification: v)
		case .update(let v): return Output(state: VarState<Value>(persistentValue: v), notification: nil)
		case .notify(let v): return Output(state: self, notification: v)
		}
	}
	
	public func resume() -> Notification? {
		return persistentValue
	}
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output {
		switch message {
		case .set(let v): return Output(state: VarState<Value>(persistentValue: v), notification: v)
		case .update(let v): return Output(state: VarState<Value>(persistentValue: v), notification: nil)
		case .notify: return Output(state: nil, notification: nil)
		}
	}
}

public typealias Var<Value: Codable> = Adapter<VarState<Value>>

extension Adapter {
	public func updatingInput<Value>() -> SignalInput<Value> where State.Message == VarState<Value>.Message {
		return Input().map { .update($0) }.bind(to: input)
	}

	public func notifyingInput<Value>() -> SignalInput<Value> where State.Message == VarState<Value>.Message {
		return Input().map { .notify($0) }.bind(to: input)
	}
}
