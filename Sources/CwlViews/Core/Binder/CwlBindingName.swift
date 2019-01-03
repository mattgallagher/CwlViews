//
//  CwlBindingName.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/12/20.
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

infix operator --: AssignmentPrecedence
infix operator <--: AssignmentPrecedence
infix operator -->: AssignmentPrecedence

public struct BindingName<Value, Source, Binding> {
	public var source: (Value) -> Source
	public var downcast: (Source) -> Binding
	public init(source: @escaping (Value) -> Source, downcast: @escaping (Source) -> Binding) {
		self.source = source
		self.downcast = downcast
	}
	public func binding(with value: Value) -> Binding {
		return downcast(source(value))
	}
}

public extension BindingName {
	/// Build a signal binding (invocations on the instance after construction) from a name and a signal
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func <--<Interface: SignalInterface>(name: BindingName<Value, Source, Binding>, value: Interface) -> Binding where Signal<Interface.OutputValue> == Value {
		return name.binding(with: value.signal)
	}

	/// Build a value binding (property changes on the instance) from a name and a signal (values over time)
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func <--<Interface: SignalInterface>(name: BindingName<Value, Source, Binding>, value: Interface) -> Binding where Dynamic<Interface.OutputValue> == Value {
		return name.binding(with: Dynamic<Interface.OutputValue>.dynamic(value.signal))
	}

	/// Build an action binding (callbacks triggered by the instance) from a name and a signal input.
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --><InputInterface: SignalInputInterface>(name: BindingName<Value, Source, Binding>, value: InputInterface) -> Binding where SignalInput<InputInterface.InputValue> == Value {
		return name.binding(with: value.input)
	}

	/// Build a static binding (construction-only property) from a name and a constant value
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<A>(name: BindingName<Value, Source, Binding>, value: A) -> Binding where Constant<A> == Value {
		return name.binding(with: Value.constant(value))
	}

	/// Build a value binding (property changes on the instance) from a name and a constant value
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<A>(name: BindingName<Value, Source, Binding>, value: A) -> Binding where Dynamic<A> == Value {
		return name.binding(with: Dynamic<A>.constant(value))
	}

	/// Build a delegate binding (synchronous callback) from a name and function with no parameters
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<R>(name: BindingName<Value, Source, Binding>, value: @escaping () -> R) -> Binding where Value == () -> R {
		return name.binding(with: value)
	}

	/// Build a delegate binding (synchronous callback) from a name and function with one parameter
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<A, R>(name: BindingName<Value, Source, Binding>, value: @escaping (A) -> R) -> Binding where Value == (A) -> R {
		return name.binding(with: value)
	}

	/// Build a delegate binding (synchronous callback) from a name and function with two parameters
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<A, B, R>(name: BindingName<Value, Source, Binding>, value: @escaping (A, B) -> R) -> Binding where Value == (A, B) -> R {
		return name.binding(with: value)
	}

	/// Build a delegate binding (synchronous callback) from a name and function with three parameters
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<A, B, C, R>(name: BindingName<Value, Source, Binding>, value: @escaping (A, B, C) -> R) -> Binding where Value == (A, B, C) -> R {
		return name.binding(with: value)
	}

	/// Build a delegate binding (synchronous callback) from a name and function with four parameters
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<A, B, C, D, R>(name: BindingName<Value, Source, Binding>, value: @escaping (A, B, C, D) -> R) -> Binding where Value == (A, B, C, D) -> R {
		return name.binding(with: value)
	}

	/// Build a delegate binding (synchronous callback) from a name and function with five parameters
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --<A, B, C, D, E, R>(name: BindingName<Value, Source, Binding>, value: @escaping (A, B, C, D, E) -> R) -> Binding where Value == (A, B, C, D, E) -> R {
		return name.binding(with: value)
	}
}

public extension BindingName where Value == TargetAction {
	/// Build an `TargetAction` binding (callbacks triggered by the instance) from a name and a signal input.
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --><InputInterface: SignalInputInterface>(name: BindingName<TargetAction, Source, Binding>, value: InputInterface) -> Binding where InputInterface.InputValue == Any? {
		return name.binding(with: .singleTarget(value.input))
	}
	
	/// Build a first-responder `TargetAction` binding (callbacks triggered by the instance) from a name and a selector.
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func -->(name: BindingName<TargetAction, Source, Binding>, value: Selector) -> Binding {
		return name.binding(with: TargetAction.firstResponder(value))
	}
}
