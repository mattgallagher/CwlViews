//
//  CwlSignalUtilities.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/04/29.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct Callback<Value, CallbackValue> {
	public let value: Value
	public let callback: SignalInput<CallbackValue>?
	
	public init(_ value: Value, _ callback: SignalInput<CallbackValue>? = nil) {
		self.value = value
		self.callback = callback
	}
}

extension Signal {
	public func callbackBind<CallbackInputInterface: SignalInputInterface>(to callback: CallbackInputInterface) -> Signal<Callback<OutputValue, CallbackInputInterface.InputValue>> {
		return map { value in Callback(value, callback.input) }
	}

	public func ignoreCallback<CallbackValue>() -> Signal<Callback<OutputValue, CallbackValue>> {
		return map { value in Callback(value, nil) }
	}
}
