//
//  CwlTempVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct TempBehavior<Value>: StateAdapterBehavior {
	public typealias State = Value
	public typealias Message = Value
	public typealias Notification = Value
	
	public static func reducer(state: inout State, message: Message) -> Notification? {
		state = message
		return state
	}
	
	public static func resume(state: State) -> Notification? {
		return state
	}
	
	public static func initialize(message: Message) -> (Value?, Value?) {
		return (message, message)
	}
}

public typealias TempVar<Value> = StateAdapter<TempBehavior<Value>>
