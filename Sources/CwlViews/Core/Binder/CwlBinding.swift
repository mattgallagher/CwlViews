//
//  CwlBinding.swift
//  CwlViews
//
//  Created by Matt Gallagher on 29/12/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

import Foundation

public protocol Binding {
	associatedtype Preparer: BinderPreparer
}

extension Binding {
	public static func compositeName<Value, Param, Intermediate>(value: @escaping (Value) -> Param, binding: @escaping (Param) -> Intermediate, downcast: @escaping (Intermediate) -> Self) -> BindingName<Value, Intermediate, Self> {
		return BindingName<Value, Intermediate, Self>(
			source: { v in binding(value(v)) },
			downcast: downcast
		)
	}
	
	public static func keyPathActionName<Instance, Value, Intermediate>(_ keyPath: KeyPath<Instance, Value>, _ binding: @escaping (TargetAction) -> Intermediate, _ downcast: @escaping (Intermediate) -> Self) -> BindingName<SignalInput<Value>, Intermediate, Self> {
		return compositeName(
			value: { input in
				TargetAction.singleTarget(
					Input<Any?>().map { v in (v as! Instance)[keyPath: keyPath] }.bind(to: input)
				)
			},
			binding: binding,
			downcast: downcast
		)
	}
	
	public static func mappedInputName<Value, Mapped, Intermediate>(map: @escaping (Value) -> Mapped, binding: @escaping (SignalInput<Value>) -> Intermediate, downcast: @escaping (Intermediate) -> Self) -> BindingName<SignalInput<Mapped>, Intermediate, Self> {
		return compositeName(
			value: { Input<Value>().map(map).bind(to: $0) },
			binding: binding,
			downcast: downcast
		)
	}
	
	public static func mappedWrappedInputName<Value, Mapped, Param, Intermediate>(map: @escaping (Value) -> Mapped, wrap: @escaping (SignalInput<Value>) -> Param, binding: @escaping (Param) -> Intermediate, downcast: @escaping (Intermediate) -> Self) -> BindingName<SignalInput<Mapped>, Intermediate, Self> {
		return compositeName(
			value: { wrap(Input<Value>().map(map).bind(to: $0)) },
			binding: binding,
			downcast: downcast
		)
	}
}
