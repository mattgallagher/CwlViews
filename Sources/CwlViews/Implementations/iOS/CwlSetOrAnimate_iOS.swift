//
//  CwlSetOrAnimate_iOS.swift
//  CwlViews_iOS
//
//  Created by Matt Gallagher on 2017/08/11.
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

/// A value abstraction of the arguments to some AppKit/UIKit methods with a `setValue(_:,animated:)` structure.
public struct Animatable<Value, AnimationType> {
	public let value: Value
	public let animation: AnimationType?
	
	public static func set(_ value: Value) -> Animatable<Value, AnimationType> {
		return Animatable<Value, AnimationType>(value: value, animation: nil)
	}
	public static func animate(_ value: Value, animation: AnimationType) -> Animatable<Value, AnimationType> {
		return Animatable<Value, AnimationType>(value: value, animation: animation)
	}
	
	var isAnimated: Bool {
		return animation != nil
	}
}

public typealias SetOrAnimate<Value> = Animatable<Value, ()>

extension Animatable where AnimationType == () {
	public static func animate(_ value: Value) -> Animatable<Value, AnimationType> {
		return Animatable<Value, AnimationType>(value: value, animation: ())
	}
}

public extension BindingName {
	static func --<A, AnimationType>(name: BindingName<Value, Source, Binding>, value: A) -> Binding where Dynamic<Animatable<A, AnimationType>> == Value {
		return name.binding(with: Value.constant(.set(value)))
	}
	
}

extension Animatable: ExpressibleByArrayLiteral where Value: ExpressibleByArrayLiteral, Value: RangeReplaceableCollection, Value.ArrayLiteralElement == Value.Element {
	public typealias ArrayLiteralElement = Value.ArrayLiteralElement
	public init(arrayLiteral elements: Value.ArrayLiteralElement...) {
		var value: Value = []
		value.append(contentsOf: elements)
		self = .set(value)
	}
}

extension SignalInterface {
	public func animate(_ choice: AnimationChoice = .subsequent) -> Signal<Animatable<OutputValue, ()>> {
		return map(initialState: false) { (alreadyReceived: inout Bool, value: OutputValue) in
			if alreadyReceived || choice == .always {
				return .animate(value)
			} else {
				if choice == .subsequent {
					alreadyReceived = true
				}
				return .set(value)
			}
		}
	}
}
