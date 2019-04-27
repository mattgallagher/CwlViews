//
//  CwlPinchGestureRecognizer_macOS.swift
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
public class PinchGestureRecognizer: Binder, PinchGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension PinchGestureRecognizer {
	enum Binding: PinchGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case scale(Dynamic<CGFloat>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension PinchGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = PinchGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = UIPinchGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension PinchGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .scale(let x): return x.apply(instance) { i, v in i.scale = v }
			
		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PinchGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: PinchGestureRecognizerBinding {
	public typealias PinchGestureRecognizerName<V> = BindingName<V, PinchGestureRecognizer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> PinchGestureRecognizer.Binding) -> PinchGestureRecognizerName<V> {
		return PinchGestureRecognizerName<V>(source: source, downcast: Binding.pinchGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: PinchGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: PinchGestureRecognizerName<$2> { return .name(PinchGestureRecognizer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var scale: PinchGestureRecognizerName<Dynamic<CGFloat>> { return .name(PinchGestureRecognizer.Binding.scale) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol PinchGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiPinchGestureRecognizer() -> PinchGestureRecognizer.Instance
}
extension PinchGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiPinchGestureRecognizer() }
}
extension UIPinchGestureRecognizer: PinchGestureRecognizerConvertible {
	public func uiPinchGestureRecognizer() -> PinchGestureRecognizer.Instance { return self }
}
public extension PinchGestureRecognizer {
	func uiPinchGestureRecognizer() -> PinchGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol PinchGestureRecognizerBinding: GestureRecognizerBinding {
	static func pinchGestureRecognizerBinding(_ binding: PinchGestureRecognizer.Binding) -> Self
	func asPinchGestureRecognizerBinding() -> PinchGestureRecognizer.Binding?
}
public extension PinchGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return pinchGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension PinchGestureRecognizerBinding where Preparer.Inherited.Binding: PinchGestureRecognizerBinding {
	func asPinchGestureRecognizerBinding() -> PinchGestureRecognizer.Binding? {
		return asInheritedBinding()?.asPinchGestureRecognizerBinding()
	}
}
public extension PinchGestureRecognizer.Binding {
	typealias Preparer = PinchGestureRecognizer.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asPinchGestureRecognizerBinding() -> PinchGestureRecognizer.Binding? { return self }
	static func pinchGestureRecognizerBinding(_ binding: PinchGestureRecognizer.Binding) -> PinchGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
