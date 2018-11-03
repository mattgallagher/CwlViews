//
//  CwlPanGestureRecognizer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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

public class PanGestureRecognizer: ConstructingBinder, PanGestureRecognizerConvertible {
	public typealias Instance = UIPanGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiPanGestureRecognizer() -> Instance { return instance() }
	
	public enum Binding: PanGestureRecognizerBinding {
		public typealias EnclosingBinder = PanGestureRecognizer
		public static func panGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case maximumNumberOfTouches(Dynamic<Int>)
		case minimumNumberOfTouches(Dynamic<Int>)
		case translation(Dynamic<CGPoint>)
		
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
			case .maximumNumberOfTouches(let x): return x.apply(instance, storage) { i, s, v in i.maximumNumberOfTouches = v }
			case .minimumNumberOfTouches(let x): return x.apply(instance, storage) { i, s, v in i.minimumNumberOfTouches = v }
			case .translation(let x): return x.apply(instance, storage) { i, s, v in i.setTranslation(v, in: nil) }
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
	public static var maximumNumberOfTouches: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .panGestureRecognizerBinding(PanGestureRecognizer.Binding.maximumNumberOfTouches(v)) }) }
	public static var minimumNumberOfTouches: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .panGestureRecognizerBinding(PanGestureRecognizer.Binding.minimumNumberOfTouches(v)) }) }
	public static var translation: BindingName<Dynamic<CGPoint>, Binding> { return BindingName<Dynamic<CGPoint>, Binding>({ v in .panGestureRecognizerBinding(PanGestureRecognizer.Binding.translation(v)) }) }
}

public protocol PanGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiPanGestureRecognizer() -> PanGestureRecognizer.Instance
}
extension PanGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiPanGestureRecognizer() }
}
extension PanGestureRecognizer.Instance: PanGestureRecognizerConvertible {
	public func uiPanGestureRecognizer() -> PanGestureRecognizer.Instance { return self }
}

public protocol PanGestureRecognizerBinding: GestureRecognizerBinding {
	static func panGestureRecognizerBinding(_ binding: PanGestureRecognizer.Binding) -> Self
}
extension PanGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return panGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
