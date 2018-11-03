//
//  CwlMagnificationGestureRecognizer.swift
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

public class MagnificationGestureRecognizer: ConstructingBinder, MagnificationGestureRecognizerConvertible {
	public typealias Instance = NSMagnificationGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsMagnificationGestureRecognizer() -> Instance { return instance() }
	
	public enum Binding: MagnificationGestureRecognizerBinding {
		public typealias EnclosingBinder = MagnificationGestureRecognizer
		public static func magnificationGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case magnification(Dynamic<CGFloat>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = MagnificationGestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .magnification(let x): return x.apply(instance, storage) { i, s, v in i.magnification = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = GestureRecognizer.Storage
}

extension BindingName where Binding: MagnificationGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .magnificationGestureRecognizerBinding(MagnificationGestureRecognizer.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var magnification: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .magnificationGestureRecognizerBinding(MagnificationGestureRecognizer.Binding.magnification(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol MagnificationGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsMagnificationGestureRecognizer() -> MagnificationGestureRecognizer.Instance
}
extension MagnificationGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsMagnificationGestureRecognizer() }
}
extension MagnificationGestureRecognizer.Instance: MagnificationGestureRecognizerConvertible {
	public func nsMagnificationGestureRecognizer() -> MagnificationGestureRecognizer.Instance { return self }
}

public protocol MagnificationGestureRecognizerBinding: GestureRecognizerBinding {
	static func magnificationGestureRecognizerBinding(_ binding: MagnificationGestureRecognizer.Binding) -> Self
}
extension MagnificationGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return magnificationGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
