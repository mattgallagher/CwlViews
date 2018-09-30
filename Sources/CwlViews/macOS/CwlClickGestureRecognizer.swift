//
//  CwlClickGestureRecognizer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 11/3/16.
//  Copyright © 2016 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

public class ClickGestureRecognizer: ConstructingBinder, ClickGestureRecognizerConvertible {
	public typealias Instance = NSClickGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsClickGestureRecognizer() -> Instance { return instance() }
	
	public enum Binding: ClickGestureRecognizerBinding {
		public typealias EnclosingBinder = ClickGestureRecognizer
		public static func clickGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case buttonMask(Dynamic<Int>)
		case numberOfClicksRequired(Dynamic<Int>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = ClickGestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}

		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .buttonMask(let x): return x.apply(instance, storage) { i, s, v in i.buttonMask = v }
			case .numberOfClicksRequired(let x): return x.apply(instance, storage) { i, s, v in i.numberOfClicksRequired = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = GestureRecognizer.Storage
}

extension BindingName where Binding: ClickGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .clickGestureRecognizerBinding(ClickGestureRecognizer.Binding.$1(v)) }) }
 
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var buttonMask: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .clickGestureRecognizerBinding(ClickGestureRecognizer.Binding.buttonMask(v)) }) }
	public static var numberOfClicksRequired: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .clickGestureRecognizerBinding(ClickGestureRecognizer.Binding.numberOfClicksRequired(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol ClickGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsClickGestureRecognizer() -> ClickGestureRecognizer.Instance
}
extension ClickGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsClickGestureRecognizer() }
}
extension ClickGestureRecognizer.Instance: ClickGestureRecognizerConvertible {
	public func nsClickGestureRecognizer() -> ClickGestureRecognizer.Instance { return self }
}

public protocol ClickGestureRecognizerBinding: GestureRecognizerBinding {
	static func clickGestureRecognizerBinding(_ binding: ClickGestureRecognizer.Binding) -> Self
}
extension ClickGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return clickGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
