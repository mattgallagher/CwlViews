//
//  CwlBinding.swift
//  CwlViews
//
//  Created by Matt Gallagher on 29/12/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import Foundation

public protocol Binding {
	associatedtype Preparer: BinderPreparer
}

extension Binding {
	public static func compositeName<Value, Param, Intermediate>(source: @escaping (Value) -> Param, translate: @escaping (Param) -> Intermediate, downcast: @escaping (Intermediate) -> Self) -> BindingName<Value, Intermediate, Self> {
		return BindingName<Value, Intermediate, Self>(
			source: { v in translate(source(v)) },
			downcast: downcast
		)
	}
	
	public static func keyPathActionName<Instance, Value, Intermediate>(_ keyPath: KeyPath<Instance, Value>, _ constructor: @escaping (TargetAction) -> Intermediate, _ downcast: @escaping (Intermediate) -> Self) -> BindingName<SignalInput<Value>, Intermediate, Self> {
		return compositeName(
			source: { (value: SignalInput<Value>) -> TargetAction in
				TargetAction.singleTarget(
					Input<Any?>()
						.map { c -> Value in (c as! Instance)[keyPath: keyPath] }
						.bind(to: value)
				)
		},
			translate: constructor,
			downcast: downcast
		)
	}
	
	public static func mappedInputName<Value, Mapped, Intermediate>(_ valueToMapped: @escaping (Value) -> Mapped, _ constructor: @escaping (SignalInput<Value>) -> Intermediate, _ downcast: @escaping (Intermediate) -> Self) -> BindingName<SignalInput<Mapped>, Intermediate, Self> {
		return compositeName(
			source: { (input: SignalInput<Mapped>) -> SignalInput<Value> in
				Input<Value>()
					.map(processor: valueToMapped)
					.bind(to: input)
		},
			translate: constructor,
			downcast: downcast
		)
	}
}
