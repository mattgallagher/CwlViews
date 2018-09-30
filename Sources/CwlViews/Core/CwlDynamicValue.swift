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
	
	/// Gets the initial (i.e. used in the constructor) value from the `Dynamic`
	public func captureValues() -> [Value] {
		switch self {
		case .constant(let v): return [v]
		case .dynamic(let signal): return signal.capture().values
		}
	}
	
	/// Converts this `Dynamic` into a signal by returning the `.dynamic` signal or returning the `.constant` wrapped in a signal.
	public func signal() -> Signal<Value> {
		switch self {
		case .constant(let v): return Signal<Value>.preclosed(v)
		case .dynamic(let signal): return signal
		}
	}
	
	// Gets the subsequent (i.e. after construction) values from the `Dynamic`
	public func apply<I: AnyObject, B: BinderStorage>(_ instance: I, _ storage: B, _ onError: Value? = nil, handler: @escaping (I, B, Value) -> Void) -> Cancellable? {
		switch self {
		case .constant(let v):
			handler(instance, storage, v)
			return nil
		case .dynamic(let signal):
			return signal.subscribe(context: .main) { [weak instance, weak storage] r in
				guard let i = instance, let s = storage else { return }
				switch (r, onError) {
				case (.success(let v), _): handler(i, s, v)
				case (.failure, .some(let v)): handler(i, s, v)
				case (.failure, .none): break
				}
			}
		}
	}
}

public struct InitialSubsequent<Value> {
	private var capturedValue: Value?
	var shouldResend: Bool
	let subsequent: SignalCapture<Value>?
	
	init(initial: Value? = nil, shouldResend: Bool = true, subsequent: SignalCapture<Value>? = nil) {
		self.capturedValue = initial
		self.shouldResend = shouldResend
		self.subsequent = subsequent
	}
	
	public mutating func initial() -> Value? {
		let c = capturedValue
		capturedValue = nil
		shouldResend = false
		return c
	}

	public func resume() -> Signal<Value>? {
		if let s = subsequent {
			return s.resume(resend: shouldResend)
		} else if shouldResend, let i = capturedValue {
			return Signal<Value>.preclosed(i)
		}
		return nil
	}
}

extension Signal {
	public func apply<I: AnyObject, B: BinderStorage>(_ instance: I?, _ storage: B?, handler: @escaping (I, B, OutputValue) -> Void) -> Cancellable? {
		return subscribeValues(context: .main) { [weak instance, weak storage] v in
			guard let i = instance, let s = storage else { return }
			handler(i, s, v)
		}
	}
}

extension SignalCapture {
	public func apply<I: AnyObject, B: BinderStorage>(_ instance: I, _ storage: B, handler: @escaping (I, B, OutputValue) -> Void) -> Cancellable? {
		return subscribeValues(context: .main) { [weak instance, weak storage] v in
			guard let i = instance, let s = storage else { return }
			handler(i, s, v)
		}
	}
}

extension SignalInterface {
	public func adhocBinding<Subclass: AnyObject>(toType: Subclass.Type, using: @escaping (Subclass, OutputValue) -> Void) -> (AnyObject) -> Cancellable? {
		return { (instance: AnyObject) -> Cancellable? in
			return self.signal.subscribeValues(context: .main) { [weak instance] value in
				if let i = instance as? Subclass {
					using(i, value)
				}
			}
		}
	}
}
