//
//  CwlPanGestureRecognizer_macOS.swift
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

public class PanGestureRecognizer: ConstructingBinder, PanGestureRecognizerConvertible {
	public typealias Instance = NSPanGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsPanGestureRecognizer() -> Instance { return instance() }
	
	public enum Binding: PanGestureRecognizerBinding {
		public typealias EnclosingBinder = PanGestureRecognizer
		public static func panGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case buttonMask(Dynamic<Int>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = PanGestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .buttonMask(let x): return x.apply(instance, storage) { i, s, v in i.buttonMask = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = GestureRecognizer.Storage
}

extension BindingName where Binding: PanGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .panGestureRecognizerBinding(PanGestureRecognizer.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var buttonMask: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .panGestureRecognizerBinding(PanGestureRecognizer.Binding.buttonMask(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol PanGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsPanGestureRecognizer() -> PanGestureRecognizer.Instance
}
extension PanGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsPanGestureRecognizer() }
}
extension PanGestureRecognizer.Instance: PanGestureRecognizerConvertible {
	public func nsPanGestureRecognizer() -> PanGestureRecognizer.Instance { return self }
}

public protocol PanGestureRecognizerBinding: GestureRecognizerBinding {
	static func panGestureRecognizerBinding(_ binding: PanGestureRecognizer.Binding) -> Self
}
extension PanGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return panGestureRecognizerBinding(.inheritedBinding(binding))
	}
}

#endif
