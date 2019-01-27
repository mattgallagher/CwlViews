//
//  CwlTempVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct TempValue<Value>: NonPersistentAdapterState {
	public typealias Message = Value
	public typealias Notification = Value
	
	let temporaryValue: Value
	init(temporaryValue: Value) {
		self.temporaryValue = temporaryValue
	}
	
	public func reduce(message: Value, feedback: SignalMultiInput<Message>) -> Output {
		return Output(state: TempValue(temporaryValue: message), notification: message)
	}
	
	public func resume() -> Notification? {
		return temporaryValue
	}
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output? {
		return Output(state: TempValue(temporaryValue: message), notification: message)
	}
}

public typealias TempVar<Value> = Adapter<TempValue<Value>>

public extension Adapter {
	init<Value>(_ value: Value) where TempValue<Value> == State {
		self.init(adapterState: TempValue<Value>(temporaryValue: value))
	}
}
