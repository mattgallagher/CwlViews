//
//  CwlSwipeGestureRecognizer_macOS.swift
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class SwipeGestureRecognizer: Binder, SwipeGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension SwipeGestureRecognizer {
	enum Binding: SwipeGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case direction(Dynamic<UISwipeGestureRecognizer.Direction>)
		case numberOfTouchesRequired(Dynamic<Int>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension SwipeGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = SwipeGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = UISwipeGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension SwipeGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .direction(let x): return x.apply(instance) { i, v in i.direction = v }
		case .numberOfTouchesRequired(let x): return x.apply(instance) { i, v in i.numberOfTouchesRequired = v }
			
		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SwipeGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SwipeGestureRecognizerBinding {
	public typealias SwipeGestureRecognizerName<V> = BindingName<V, SwipeGestureRecognizer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> SwipeGestureRecognizer.Binding) -> SwipeGestureRecognizerName<V> {
		return SwipeGestureRecognizerName<V>(source: source, downcast: Binding.swipeGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: SwipeGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SwipeGestureRecognizerName<$2> { return .name(SwipeGestureRecognizer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var direction: SwipeGestureRecognizerName<Dynamic<UISwipeGestureRecognizer.Direction>> { return .name(SwipeGestureRecognizer.Binding.direction) }
	static var numberOfTouchesRequired: SwipeGestureRecognizerName<Dynamic<Int>> { return .name(SwipeGestureRecognizer.Binding.numberOfTouchesRequired) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SwipeGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiSwipeGestureRecognizer() -> SwipeGestureRecognizer.Instance
}
extension SwipeGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiSwipeGestureRecognizer() }
}
extension UISwipeGestureRecognizer: SwipeGestureRecognizerConvertible {
	public func uiSwipeGestureRecognizer() -> SwipeGestureRecognizer.Instance { return self }
}
public extension SwipeGestureRecognizer {
	func uiSwipeGestureRecognizer() -> SwipeGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SwipeGestureRecognizerBinding: GestureRecognizerBinding {
	static func swipeGestureRecognizerBinding(_ binding: SwipeGestureRecognizer.Binding) -> Self
}
public extension SwipeGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return swipeGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension SwipeGestureRecognizer.Binding {
	typealias Preparer = SwipeGestureRecognizer.Preparer
	static func swipeGestureRecognizerBinding(_ binding: SwipeGestureRecognizer.Binding) -> SwipeGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
