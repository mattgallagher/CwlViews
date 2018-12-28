//
//  CwlDynamic.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/23.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any purpose with or without
//  fee is hereby granted, provided that the above copyright notice and this permission notice
//  appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
//  SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
//  AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
//  NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
//  OF THIS SOFTWARE.
//

/// A simple wrapper around a value used to identify "static" bindings (bindings which are applied only at construction time)
public struct Constant<Value> {
	public typealias ValueType = Value
	public let value: Value
	public init(_ value: Value) {
		self.value = value
	}
	public static func constant(_ value: Value) -> Constant<Value> {
		return Constant<Value>(value)
	}
}

/// An either type for a value or a signal emitting values of that type. Used for "value" bindings (bindings which set a property on the underlying instance)
public enum Dynamic<Value> {
	public typealias ValueType = Value
	case constant(Value)
	case dynamic(Signal<Value>)
	
	/// Gets the initial (i.e. used in the constructor) value from the `Dynamic`
	public func initialSubsequent() -> InitialSubsequent<Value> {
		switch self {
		case .constant(let v):
			return InitialSubsequent<Value>(initial: v)
		case .dynamic(let signal):
			let sc = signal.capture()
			return InitialSubsequent<Value>(initial: sc.currentValue, subsequent: sc)
		}
	}
	
	// Gets the subsequent (i.e. after construction) values from the `Dynamic`
	public func apply<I: AnyObject, B: AnyObject>(_ instance: I, _ storage: B, _ onError: Value? = nil, handler: @escaping (I, B, Value) -> Void) -> Lifetime? {
		switch self {
		case .constant(let v):
			handler(instance, storage, v)
			return nil
		case .dynamic(let signal):
			return signal.apply(instance, storage, onError, handler: handler)
		}
	}
	
	// Gets the subsequent (i.e. after construction) values from the `Dynamic`
	public func apply<I: AnyObject>(_ instance: I, handler: @escaping (I, Value) -> Void) -> Lifetime? {
		switch self {
		case .constant(let v):
			handler(instance, v)
			return nil
		case .dynamic(let signal):
			return signal.apply(instance, handler: handler)
		}
	}
}

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
}

extension Signal {
	public func apply<I: AnyObject, B: AnyObject>(_ instance: I, _ storage: B, _ onError: OutputValue? = nil, handler: @escaping (I, B, OutputValue) -> Void) -> Lifetime? {
		return signal.subscribe(context: .main) { [unowned instance, unowned storage] r in
			switch (r, onError) {
			case (.success(let v), _): handler(instance, storage, v)
			case (.failure, .some(let v)): handler(instance, storage, v)
			case (.failure, .none): break
			}
		}
	}

	public func apply<I: AnyObject>(_ instance: I, handler: @escaping (I, OutputValue) -> Void) -> Lifetime? {
		return signal.subscribeValues(context: .main) { [unowned instance] v in handler(instance, v) }
	}
}

extension SignalCapture {
	public func apply<I: AnyObject, B: AnyObject>(_ instance: I, _ storage: B, handler: @escaping (I, B, OutputValue) -> Void) -> Lifetime? {
		return subscribeValues(context: .main) { [unowned instance, unowned storage] v in
			handler(instance, storage, v)
		}
	}
}
