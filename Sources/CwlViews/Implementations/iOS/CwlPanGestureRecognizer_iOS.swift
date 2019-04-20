//
//  CwlPanGestureRecognizer_macOS.swift
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
public class PanGestureRecognizer: Binder, PanGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension PanGestureRecognizer {
	enum Binding: PanGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case maximumNumberOfTouches(Dynamic<Int>)
		case minimumNumberOfTouches(Dynamic<Int>)
		case translation(Dynamic<CGPoint>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension PanGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = PanGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = UIPanGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension PanGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .maximumNumberOfTouches(let x): return x.apply(instance) { i, v in i.maximumNumberOfTouches = v }
		case .minimumNumberOfTouches(let x): return x.apply(instance) { i, v in i.minimumNumberOfTouches = v }
		case .translation(let x): return x.apply(instance) { i, v in i.setTranslation(v, in: nil) }
			
		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PanGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: PanGestureRecognizerBinding {
	public typealias PanGestureRecognizerName<V> = BindingName<V, PanGestureRecognizer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> PanGestureRecognizer.Binding) -> PanGestureRecognizerName<V> {
		return PanGestureRecognizerName<V>(source: source, downcast: Binding.panGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: PanGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: PanGestureRecognizerName<$2> { return .name(PanGestureRecognizer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var maximumNumberOfTouches: PanGestureRecognizerName<Dynamic<Int>> { return .name(PanGestureRecognizer.Binding.maximumNumberOfTouches) }
	static var minimumNumberOfTouches: PanGestureRecognizerName<Dynamic<Int>> { return .name(PanGestureRecognizer.Binding.minimumNumberOfTouches) }
	static var translation: PanGestureRecognizerName<Dynamic<CGPoint>> { return .name(PanGestureRecognizer.Binding.translation) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol PanGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiPanGestureRecognizer() -> PanGestureRecognizer.Instance
}
extension PanGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiPanGestureRecognizer() }
}
extension UIPanGestureRecognizer: PanGestureRecognizerConvertible {
	public func uiPanGestureRecognizer() -> PanGestureRecognizer.Instance { return self }
}
public extension PanGestureRecognizer {
	func uiPanGestureRecognizer() -> PanGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol PanGestureRecognizerBinding: GestureRecognizerBinding {
	static func panGestureRecognizerBinding(_ binding: PanGestureRecognizer.Binding) -> Self
}
public extension PanGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return panGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension PanGestureRecognizer.Binding {
	typealias Preparer = PanGestureRecognizer.Preparer
	static func panGestureRecognizerBinding(_ binding: PanGestureRecognizer.Binding) -> PanGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
