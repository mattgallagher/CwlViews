//
//  CwlLongPressGestureRecognizer_macOS.swift
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
public class LongPressGestureRecognizer: Binder, LongPressGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension LongPressGestureRecognizer {
	enum Binding: LongPressGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowableMovement(Dynamic<CGFloat>)
		case minimumPressDuration(Dynamic<CFTimeInterval>)
		case numberOfTapsRequired(Dynamic<Int>)
		case numberOfTouchesRequired(Dynamic<Int>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension LongPressGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = LongPressGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = UILongPressGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension LongPressGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowableMovement(let x): return x.apply(instance) { i, v in i.allowableMovement = v }
		case .minimumPressDuration(let x): return x.apply(instance) { i, v in i.minimumPressDuration = v }
		case .numberOfTapsRequired(let x): return x.apply(instance) { i, v in i.numberOfTapsRequired = v }
		case .numberOfTouchesRequired(let x): return x.apply(instance) { i, v in i.numberOfTouchesRequired = v }
			
		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension LongPressGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: LongPressGestureRecognizerBinding {
	public typealias LongPressGestureRecognizerName<V> = BindingName<V, LongPressGestureRecognizer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> LongPressGestureRecognizer.Binding) -> LongPressGestureRecognizerName<V> {
		return LongPressGestureRecognizerName<V>(source: source, downcast: Binding.longPressGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: LongPressGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: LongPressGestureRecognizerName<$2> { return .name(LongPressGestureRecognizer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowableMovement: LongPressGestureRecognizerName<Dynamic<CGFloat>> { return .name(LongPressGestureRecognizer.Binding.allowableMovement) }
	static var minimumPressDuration: LongPressGestureRecognizerName<Dynamic<CFTimeInterval>> { return .name(LongPressGestureRecognizer.Binding.minimumPressDuration) }
	static var numberOfTapsRequired: LongPressGestureRecognizerName<Dynamic<Int>> { return .name(LongPressGestureRecognizer.Binding.numberOfTapsRequired) }
	static var numberOfTouchesRequired: LongPressGestureRecognizerName<Dynamic<Int>> { return .name(LongPressGestureRecognizer.Binding.numberOfTouchesRequired) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol LongPressGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiLongPressGestureRecognizer() -> LongPressGestureRecognizer.Instance
}
extension LongPressGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiLongPressGestureRecognizer() }
}
extension UILongPressGestureRecognizer: LongPressGestureRecognizerConvertible {
	public func uiLongPressGestureRecognizer() -> LongPressGestureRecognizer.Instance { return self }
}
public extension LongPressGestureRecognizer {
	func uiLongPressGestureRecognizer() -> LongPressGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol LongPressGestureRecognizerBinding: GestureRecognizerBinding {
	static func longPressGestureRecognizerBinding(_ binding: LongPressGestureRecognizer.Binding) -> Self
	func asLongPressGestureRecognizerBinding() -> LongPressGestureRecognizer.Binding?
}
public extension LongPressGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return longPressGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension LongPressGestureRecognizerBinding where Preparer.Inherited.Binding: LongPressGestureRecognizerBinding {
	func asLongPressGestureRecognizerBinding() -> LongPressGestureRecognizer.Binding? {
		return asInheritedBinding()?.asLongPressGestureRecognizerBinding()
	}
}
public extension LongPressGestureRecognizer.Binding {
	typealias Preparer = LongPressGestureRecognizer.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asLongPressGestureRecognizerBinding() -> LongPressGestureRecognizer.Binding? { return self }
	static func longPressGestureRecognizerBinding(_ binding: LongPressGestureRecognizer.Binding) -> LongPressGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
