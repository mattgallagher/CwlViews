//
//  CwlScreenEdgePanGestureRecognizer_macOS.swift
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
public class ScreenEdgePanGestureRecognizer: Binder, ScreenEdgePanGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ScreenEdgePanGestureRecognizer {
	enum Binding: ScreenEdgePanGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case edges(Dynamic<UIRectEdge>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ScreenEdgePanGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = ScreenEdgePanGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = UIScreenEdgePanGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ScreenEdgePanGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .edges(let x): return x.apply(instance) { i, v in i.edges = v }
			
		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ScreenEdgePanGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ScreenEdgePanGestureRecognizerBinding {
	public typealias ScreenEdgePanGestureRecognizerName<V> = BindingName<V, ScreenEdgePanGestureRecognizer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> ScreenEdgePanGestureRecognizer.Binding) -> ScreenEdgePanGestureRecognizerName<V> {
		return ScreenEdgePanGestureRecognizerName<V>(source: source, downcast: Binding.screenEdgePanGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: ScreenEdgePanGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ScreenEdgePanGestureRecognizerName<$2> { return .name(ScreenEdgePanGestureRecognizer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var edges: ScreenEdgePanGestureRecognizerName<Dynamic<UIRectEdge>> { return .name(ScreenEdgePanGestureRecognizer.Binding.edges) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ScreenEdgePanGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiScreenEdgePanGestureRecognizer() -> ScreenEdgePanGestureRecognizer.Instance
}
extension ScreenEdgePanGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiScreenEdgePanGestureRecognizer() }
}
extension UIScreenEdgePanGestureRecognizer: ScreenEdgePanGestureRecognizerConvertible {
	public func uiScreenEdgePanGestureRecognizer() -> ScreenEdgePanGestureRecognizer.Instance { return self }
}
public extension ScreenEdgePanGestureRecognizer {
	func uiScreenEdgePanGestureRecognizer() -> ScreenEdgePanGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ScreenEdgePanGestureRecognizerBinding: GestureRecognizerBinding {
	static func screenEdgePanGestureRecognizerBinding(_ binding: ScreenEdgePanGestureRecognizer.Binding) -> Self
	func asScreenEdgePanGestureRecognizerBinding() -> ScreenEdgePanGestureRecognizer.Binding?
}
public extension ScreenEdgePanGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return screenEdgePanGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension ScreenEdgePanGestureRecognizerBinding where Preparer.Inherited.Binding: ScreenEdgePanGestureRecognizerBinding {
	func asScreenEdgePanGestureRecognizerBinding() -> ScreenEdgePanGestureRecognizer.Binding? {
		return asInheritedBinding()?.asScreenEdgePanGestureRecognizerBinding()
	}
}
public extension ScreenEdgePanGestureRecognizer.Binding {
	typealias Preparer = ScreenEdgePanGestureRecognizer.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asScreenEdgePanGestureRecognizerBinding() -> ScreenEdgePanGestureRecognizer.Binding? { return self }
	static func screenEdgePanGestureRecognizerBinding(_ binding: ScreenEdgePanGestureRecognizer.Binding) -> ScreenEdgePanGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
