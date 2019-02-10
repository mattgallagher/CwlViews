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

// MARK: - Binder Part 1: Binder
public class PressGestureRecognizer: Binder, PressGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension PressGestureRecognizer {
	enum Binding: PressGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowableMovement(Dynamic<CGFloat>)
		case buttonMask(Dynamic<Int>)
		case minimumPressDuration(Dynamic<TimeInterval>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension PressGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = PressGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = NSPressGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension PressGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowableMovement(let x): return x.apply(instance) { i, v in i.allowableMovement = v }
		case .buttonMask(let x): return x.apply(instance) { i, v in i.buttonMask = v }
		case .minimumPressDuration(let x): return x.apply(instance) { i, v in i.minimumPressDuration = v }
			
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PressGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: PressGestureRecognizerBinding {
	public typealias PressGestureRecognizerName<V> = BindingName<V, PressGestureRecognizer.Binding, Binding>
	private typealias B = PressGestureRecognizer.Binding
	private static func name<V>(_ source: @escaping (V) -> PressGestureRecognizer.Binding) -> PressGestureRecognizerName<V> {
		return PressGestureRecognizerName<V>(source: source, downcast: Binding.pressGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: PressGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: PressGestureRecognizerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowableMovement: PressGestureRecognizerName<Dynamic<CGFloat>> { return .name(B.allowableMovement) }
	static var buttonMask: PressGestureRecognizerName<Dynamic<Int>> { return .name(B.buttonMask) }
	static var minimumPressDuration: PressGestureRecognizerName<Dynamic<TimeInterval>> { return .name(B.minimumPressDuration) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol PressGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsPressGestureRecognizer() -> PressGestureRecognizer.Instance
}
extension PressGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsPressGestureRecognizer() }
}
extension NSPressGestureRecognizer: PressGestureRecognizerConvertible {
	public func nsPressGestureRecognizer() -> PressGestureRecognizer.Instance { return self }
}
public extension PressGestureRecognizer {
	func nsPressGestureRecognizer() -> PressGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol PressGestureRecognizerBinding: GestureRecognizerBinding {
	static func pressGestureRecognizerBinding(_ binding: PressGestureRecognizer.Binding) -> Self
}
public extension PressGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return pressGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension PressGestureRecognizer.Binding {
	typealias Preparer = PressGestureRecognizer.Preparer
	static func pressGestureRecognizerBinding(_ binding: PressGestureRecognizer.Binding) -> PressGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
