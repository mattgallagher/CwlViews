//
//  CwlRotationGestureRecognizer_macOS.swift
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

public class RotationGestureRecognizer: Binder, RotationGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension RotationGestureRecognizer {
	enum Binding: RotationGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case rotationInRadians(Dynamic<CGFloat>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension RotationGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = RotationGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = NSRotationGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension RotationGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .rotationInRadians(let x): return x.apply(instance) { i, v in i.rotation = v }
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension RotationGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: RotationGestureRecognizerBinding {
	public typealias RotationGestureRecognizerName<V> = BindingName<V, RotationGestureRecognizer.Binding, Binding>
	private typealias B = RotationGestureRecognizer.Binding
	private static func name<V>(_ source: @escaping (V) -> RotationGestureRecognizer.Binding) -> RotationGestureRecognizerName<V> {
		return RotationGestureRecognizerName<V>(source: source, downcast: Binding.rotationGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: RotationGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: RotationGestureRecognizerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var rotationInRadians: RotationGestureRecognizerName<Dynamic<CGFloat>> { return .name(B.rotationInRadians) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol RotationGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsRotationGestureRecognizer() -> RotationGestureRecognizer.Instance
}
extension RotationGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsRotationGestureRecognizer() }
}
extension NSRotationGestureRecognizer: RotationGestureRecognizerConvertible {
	public func nsRotationGestureRecognizer() -> RotationGestureRecognizer.Instance { return self }
}
public extension RotationGestureRecognizer {
	func nsRotationGestureRecognizer() -> RotationGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol RotationGestureRecognizerBinding: GestureRecognizerBinding {
	static func rotationGestureRecognizerBinding(_ binding: RotationGestureRecognizer.Binding) -> Self
}
public extension RotationGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return rotationGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension RotationGestureRecognizer.Binding {
	public typealias Preparer = RotationGestureRecognizer.Preparer
	static func rotationGestureRecognizerBinding(_ binding: RotationGestureRecognizer.Binding) -> RotationGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
