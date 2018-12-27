//
//  CwlTapGestureRecognizer_iOS.swift
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

#if os(iOS)

public class TapGestureRecognizer: Binder, TapGestureRecognizerConvertible {
	public typealias Instance = UITapGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiTapGestureRecognizer() -> Instance { return instance() }
	
	enum Binding: TapGestureRecognizerBinding {
		public typealias EnclosingBinder = TapGestureRecognizer
		public static func tapGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case numberOfTapsRequired(Dynamic<Int>)
		case numberOfTouchesRequired(Dynamic<Int>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = TapGestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .numberOfTapsRequired(let x): return x.apply(instance) { i, v in i.numberOfTapsRequired = v }
			case .numberOfTouchesRequired(let x): return x.apply(instance) { i, v in i.numberOfTouchesRequired = v }
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = GestureRecognizer.Storage
}

extension BindingName where Binding: TapGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tapGestureRecognizerBinding(TapGestureRecognizer.Binding.$1(v)) }) }
	public static var numberOfTapsRequired: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .tapGestureRecognizerBinding(TapGestureRecognizer.Binding.numberOfTapsRequired(v)) }) }
	public static var numberOfTouchesRequired: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .tapGestureRecognizerBinding(TapGestureRecognizer.Binding.numberOfTouchesRequired(v)) }) }
}

public protocol TapGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiTapGestureRecognizer() -> TapGestureRecognizer.Instance
}
extension TapGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiTapGestureRecognizer() }
}
extension TapGestureRecognizer.Instance: TapGestureRecognizerConvertible {
	public func uiTapGestureRecognizer() -> TapGestureRecognizer.Instance { return self }
}

public protocol TapGestureRecognizerBinding: GestureRecognizerBinding {
	static func tapGestureRecognizerBinding(_ binding: TapGestureRecognizer.Binding) -> Self
}
extension TapGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return tapGestureRecognizerBinding(.inheritedBinding(binding))
	}
}

#endif
