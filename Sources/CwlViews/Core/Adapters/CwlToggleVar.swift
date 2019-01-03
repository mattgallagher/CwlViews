//
//  CwlToggleVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct ToggleBehavior: StateAdapterBehavior {
	public typealias State = Bool
	public typealias Message = ()
	public typealias Notification = Bool
	public typealias PersistentState = Bool
	
	public static func reducer(state: inout State, message: Message) -> Notification? {
		state = !state
		return state
	}
	
	public static func resume(state: State) -> Notification? {
		return state
	}
	
	public static func initialize(message: Message) -> (State?, State?) {
		return (false, false)
	}
}

public typealias ToggleVar = StateAdapter<ToggleBehavior>
