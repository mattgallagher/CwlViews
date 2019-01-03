//
//  CwlInitialSubsequent.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct InitialSubsequent<Value> {
	public let initial: Value?
	public let subsequent: SignalCapture<Value>?
	
	init<Interface: SignalInterface>(signal: Interface) where Interface.OutputValue == Value {
		let capture = signal.capture()
		let values = capture.values
		self.init(initial: values.last, subsequent: capture)
	}
	
	init(initial: Value? = nil, subsequent: SignalCapture<Value>? = nil) {
		self.initial = initial
		self.subsequent = subsequent
	}
	
	public func resume() -> Signal<Value>? {
		return subsequent?.resume()
	}
	
	public func apply<I: AnyObject>(_ instance: I, handler: @escaping (I, Value) -> Void) -> Lifetime? {
		return resume().flatMap { $0.apply(instance, handler: handler) }
	}
	
	public func apply<I: AnyObject, Storage: AnyObject>(_ instance: I, _ storage: Storage, handler: @escaping (I, Storage, Value) -> Void) -> Lifetime? {
		return resume().flatMap { $0.apply(instance, storage, handler: handler) }
	}
}
