//
//  CwlAdapterState.swift
//  CwlViews
//
//  Created by Matt Gallagher on 13/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public protocol AdapterState {
	associatedtype Message
	associatedtype Notification
	associatedtype PersistentValue: Codable = NonPersistentAdapterState
	
	typealias Output = (state: Self, notification: Notification?)
	
	static var executionContext: Exec { get }
	
	static func initialize(message: Message, feedback: SignalMultiInput<Message>) throws -> Output?
	func reduce(message: Message, feedback: SignalMultiInput<Message>) throws -> Output
	func resume() -> Notification?
	
	init(persistentValue: PersistentValue)
	var persistentValue: PersistentValue { get }
}

public extension AdapterState {
	static var executionContext: Exec { return .direct }
}

public extension AdapterState where PersistentValue == NonPersistentAdapterState {
	init(persistentValue: PersistentValue) {
		fatalError("init(persistentValue:) must not be called on AdapterState when PersistentValue == NonPersistentAdapterState")
	}
	var persistentValue: PersistentValue {
		fatalError("getter:persistentValue must not be called on AdapterState when PersistentValue == NonPersistentAdapterState")
	}
}

public struct NonPersistentAdapterState: Codable {}
