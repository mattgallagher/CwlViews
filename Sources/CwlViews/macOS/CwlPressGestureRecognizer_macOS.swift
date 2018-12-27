//
//  CwlPressGestureRecognizer_macOS.swift
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

#if os(macOS)

public class PressGestureRecognizer: Binder, PressGestureRecognizerConvertible {
	public typealias Instance = NSPressGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsPressGestureRecognizer() -> Instance { return instance() }
	
	enum Binding: PressGestureRecognizerBinding {
		public typealias EnclosingBinder = PressGestureRecognizer
		public static func pressGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case buttonMask(Dynamic<Int>)
		case minimumPressDuration(Dynamic<TimeInterval>)
		case allowableMovement(Dynamic<CGFloat>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = PressGestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .buttonMask(let x): return x.apply(instance) { i, v in i.buttonMask = v }
			case .minimumPressDuration(let x): return x.apply(instance) { i, v in i.minimumPressDuration = v }
			case .allowableMovement(let x): return x.apply(instance) { i, v in i.allowableMovement = v }
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = GestureRecognizer.Storage
}

extension BindingName where Binding: PressGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .pressGestureRecognizerBinding(PressGestureRecognizer.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var buttonMask: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .pressGestureRecognizerBinding(PressGestureRecognizer.Binding.buttonMask(v)) }) }
	public static var minimumPressDuration: BindingName<Dynamic<TimeInterval>, Binding> { return BindingName<Dynamic<TimeInterval>, Binding>({ v in .pressGestureRecognizerBinding(PressGestureRecognizer.Binding.minimumPressDuration(v)) }) }
	public static var allowableMovement: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .pressGestureRecognizerBinding(PressGestureRecognizer.Binding.allowableMovement(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol PressGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsPressGestureRecognizer() -> PressGestureRecognizer.Instance
}
extension PressGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsPressGestureRecognizer() }
}
extension PressGestureRecognizer.Instance: PressGestureRecognizerConvertible {
	public func nsPressGestureRecognizer() -> PressGestureRecognizer.Instance { return self }
}

public protocol PressGestureRecognizerBinding: GestureRecognizerBinding {
	static func pressGestureRecognizerBinding(_ binding: PressGestureRecognizer.Binding) -> Self
}
extension PressGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return pressGestureRecognizerBinding(.inheritedBinding(binding))
	}
}

#endif
