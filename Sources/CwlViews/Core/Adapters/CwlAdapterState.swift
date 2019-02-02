//
//  CwlAdapterState.swift
//  CwlViews
//
//  Created by Matt Gallagher on 13/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public protocol AdapterState: Codable {
	associatedtype Message
	associatedtype DefaultMessage = Message
	associatedtype Notification
	
	typealias Output = (state: Self, notification: Notification?)
	
	static var defaultContext: (Exec, Bool) { get }

	static func message(from: DefaultMessage) -> Message
	static func initialize(message: Message, feedback: SignalMultiInput<Message>) throws -> Output?

	var instanceContext: (Exec, Bool) { get }

	func reduce(message: Message, feedback: SignalMultiInput<Message>) throws -> Output
	func resume() -> Notification?
}

public extension AdapterState {
	static var defaultContext: (Exec, Bool) {
		return (.direct, false)
	}
	
	var instanceContext: (Exec, Bool) {
		return Self.defaultContext
	}
	
	static func initialize(message: Message, feedback: SignalMultiInput<Message>) throws -> Output? {
		return nil
	}
	
	func resume() -> Notification? {
		return nil
	}
}

public extension AdapterState where DefaultMessage == Message {
	static func message(from: DefaultMessage) -> Message {
		return from
	}
}

public protocol NonPersistentAdapterState: AdapterState {}

public extension NonPersistentAdapterState {
	public init(from decoder: Decoder) throws {
		fatalError("A non-persistent adapter cannot be decoded.")
	}
	
	public func encode(to encoder: Encoder) throws {
	}
}

public protocol SingleValueAdapterState: AdapterState {
	associatedtype PersistentValue: Codable
	init(value: PersistentValue)
	var value: PersistentValue { get }
}

public extension SingleValueAdapterState {
	public init(from decoder: Decoder) throws {
		let c = try decoder.singleValueContainer()
		let p = try c.decode(PersistentValue.self)
		self.init(value: p)
	}
	
	public func encode(to encoder: Encoder) throws {
		var c = encoder.singleValueContainer()
		try c.encode(value)
	}
}
