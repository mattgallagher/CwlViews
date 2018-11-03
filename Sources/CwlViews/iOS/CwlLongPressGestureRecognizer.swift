//
//  CwlLongPressGestureRecognizer.swift
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

public class LongPressGestureRecognizer: ConstructingBinder, LongPressGestureRecognizerConvertible {
	public typealias Instance = UILongPressGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiLongPressGestureRecognizer() -> Instance { return instance() }
	
	public enum Binding: LongPressGestureRecognizerBinding {
		public typealias EnclosingBinder = LongPressGestureRecognizer
		public static func longPressGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case minimumPressDuration(Dynamic<CFTimeInterval>)
		case numberOfTouchesRequired(Dynamic<Int>)
		case numberOfTapsRequired(Dynamic<Int>)
		case allowableMovement(Dynamic<CGFloat>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = LongPressGestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .minimumPressDuration(let x): return x.apply(instance, storage) { i, s, v in i.minimumPressDuration = v }
			case .numberOfTouchesRequired(let x): return x.apply(instance, storage) { i, s, v in i.numberOfTouchesRequired = v }
			case .numberOfTapsRequired(let x): return x.apply(instance, storage) { i, s, v in i.numberOfTapsRequired = v }
			case .allowableMovement(let x): return x.apply(instance, storage) { i, s, v in i.allowableMovement = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = GestureRecognizer.Storage
}

extension BindingName where Binding: LongPressGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .longPressGestureRecognizerBinding(LongPressGestureRecognizer.Binding.$1(v)) }) }
	public static var minimumPressDuration: BindingName<Dynamic<CFTimeInterval>, Binding> { return BindingName<Dynamic<CFTimeInterval>, Binding>({ v in .longPressGestureRecognizerBinding(LongPressGestureRecognizer.Binding.minimumPressDuration(v)) }) }
	public static var numberOfTouchesRequired: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .longPressGestureRecognizerBinding(LongPressGestureRecognizer.Binding.numberOfTouchesRequired(v)) }) }
	public static var numberOfTapsRequired: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .longPressGestureRecognizerBinding(LongPressGestureRecognizer.Binding.numberOfTapsRequired(v)) }) }
	public static var allowableMovement: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .longPressGestureRecognizerBinding(LongPressGestureRecognizer.Binding.allowableMovement(v)) }) }
}

public protocol LongPressGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiLongPressGestureRecognizer() -> LongPressGestureRecognizer.Instance
}
extension LongPressGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiLongPressGestureRecognizer() }
}
extension LongPressGestureRecognizer.Instance: LongPressGestureRecognizerConvertible {
	public func uiLongPressGestureRecognizer() -> LongPressGestureRecognizer.Instance { return self }
}

public protocol LongPressGestureRecognizerBinding: GestureRecognizerBinding {
	static func longPressGestureRecognizerBinding(_ binding: LongPressGestureRecognizer.Binding) -> Self
}

extension LongPressGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return longPressGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
