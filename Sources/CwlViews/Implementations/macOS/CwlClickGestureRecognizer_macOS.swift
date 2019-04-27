//
//  CwlClickGestureRecognizer_macOS.swift
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
public class ClickGestureRecognizer: Binder, ClickGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ClickGestureRecognizer {
	enum Binding: ClickGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case buttonMask(Dynamic<Int>)
		case numberOfClicksRequired(Dynamic<Int>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ClickGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = ClickGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = NSClickGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ClickGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .buttonMask(let x): return x.apply(instance) { i, v in i.buttonMask = v }
		case .numberOfClicksRequired(let x): return x.apply(instance) { i, v in i.numberOfClicksRequired = v }
			
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ClickGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ClickGestureRecognizerBinding {
	public typealias ClickGestureRecognizerName<V> = BindingName<V, ClickGestureRecognizer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> ClickGestureRecognizer.Binding) -> ClickGestureRecognizerName<V> {
		return ClickGestureRecognizerName<V>(source: source, downcast: Binding.clickGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: ClickGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ClickGestureRecognizerName<$2> { return .name(ClickGestureRecognizer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var buttonMask: ClickGestureRecognizerName<Dynamic<Int>> { return .name(ClickGestureRecognizer.Binding.buttonMask) }
	static var numberOfClicksRequired: ClickGestureRecognizerName<Dynamic<Int>> { return .name(ClickGestureRecognizer.Binding.numberOfClicksRequired) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ClickGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsClickGestureRecognizer() -> ClickGestureRecognizer.Instance
}
extension ClickGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsClickGestureRecognizer() }
}
extension NSClickGestureRecognizer: ClickGestureRecognizerConvertible {
	public func nsClickGestureRecognizer() -> ClickGestureRecognizer.Instance { return self }
}
public extension ClickGestureRecognizer {
	func nsClickGestureRecognizer() -> ClickGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ClickGestureRecognizerBinding: GestureRecognizerBinding {
	static func clickGestureRecognizerBinding(_ binding: ClickGestureRecognizer.Binding) -> Self
	func asClickGestureRecognizerBinding() -> ClickGestureRecognizer.Binding?
}
public extension ClickGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return clickGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension ClickGestureRecognizerBinding where Preparer.Inherited.Binding: ClickGestureRecognizerBinding {
	func asClickGestureRecognizerBinding() -> ClickGestureRecognizer.Binding? {
		return asInheritedBinding()?.asClickGestureRecognizerBinding()
	}
}
public extension ClickGestureRecognizer.Binding {
	typealias Preparer = ClickGestureRecognizer.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asClickGestureRecognizerBinding() -> ClickGestureRecognizer.Binding? { return self }
	static func clickGestureRecognizerBinding(_ binding: ClickGestureRecognizer.Binding) -> ClickGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
