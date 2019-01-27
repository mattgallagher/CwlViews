//
//  CwlToggleVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct ToggleValue: SingleValueAdapterState {
	public typealias Message = Void
	public typealias Notification = Bool
	
	public let value: Bool
	public init(value: Bool) {
		self.value = value
	}
	
	public func reduce(message: Void, feedback: SignalMultiInput<Message>) -> Output {
		return Output(state: ToggleValue(value: !value), notification: !value)
	}
	
	public func resume() -> Notification? { return value }
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output? {
		return nil
	}
}

public typealias ToggleVar = Adapter<ToggleValue>

public extension Adapter where State == ToggleValue {
	init(_ value: Bool) {
		self.init(adapterState: ToggleValue(value: value))
	}
}
