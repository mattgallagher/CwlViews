//
//  CwlToggleVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct ToggleValue: AdapterState {
	public typealias Message = Void
	public typealias Notification = Bool
	public typealias PersistentValue = Bool
	
	public let persistentValue: Bool
	public init(persistentValue: Bool) {
		self.persistentValue = persistentValue
	}
	
	public func reduce(message: Void, feedback: SignalMultiInput<Message>) -> Output {
		return Output(state: ToggleValue(persistentValue: !persistentValue), notification: !persistentValue)
	}
	
	public func resume() -> Notification? { return persistentValue }
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output {
		return Output(nil, nil)
	}
}

public typealias ToggleVar<Value> = Adapter<ToggleValue>
