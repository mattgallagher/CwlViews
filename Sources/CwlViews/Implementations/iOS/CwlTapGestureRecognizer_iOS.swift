//
//  CwlTapGestureRecognizer_macOS.swift
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
public class TapGestureRecognizer: Binder, TapGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TapGestureRecognizer {
	enum Binding: TapGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case numberOfTapsRequired(Dynamic<Int>)
		case numberOfTouchesRequired(Dynamic<Int>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension TapGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = TapGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = UITapGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TapGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
			//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .numberOfTapsRequired(let x): return x.apply(instance) { i, v in i.numberOfTapsRequired = v }
		case .numberOfTouchesRequired(let x): return x.apply(instance) { i, v in i.numberOfTouchesRequired = v }
			
			// 2. Signal bindings are performed on the object after construction.
			
			// 3. Action bindings are triggered by the object after construction.
			
			// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TapGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TapGestureRecognizerBinding {
	public typealias TapGestureRecognizerName<V> = BindingName<V, TapGestureRecognizer.Binding, Binding>
	private typealias B = TapGestureRecognizer.Binding
	private static func name<V>(_ source: @escaping (V) -> TapGestureRecognizer.Binding) -> TapGestureRecognizerName<V> {
		return TapGestureRecognizerName<V>(source: source, downcast: Binding.tapGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: TapGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TapGestureRecognizerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var numberOfTapsRequired: TapGestureRecognizerName<Dynamic<Int>> { return .name(B.numberOfTapsRequired) }
	static var numberOfTouchesRequired: TapGestureRecognizerName<Dynamic<Int>> { return .name(B.numberOfTouchesRequired) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TapGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiTapGestureRecognizer() -> TapGestureRecognizer.Instance
}
extension TapGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiTapGestureRecognizer() }
}
extension UITapGestureRecognizer: TapGestureRecognizerConvertible {
	public func uiTapGestureRecognizer() -> TapGestureRecognizer.Instance { return self }
}
public extension TapGestureRecognizer {
	func uiTapGestureRecognizer() -> TapGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TapGestureRecognizerBinding: GestureRecognizerBinding {
	static func tapGestureRecognizerBinding(_ binding: TapGestureRecognizer.Binding) -> Self
}
public extension TapGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return tapGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension TapGestureRecognizer.Binding {
	typealias Preparer = TapGestureRecognizer.Preparer
	static func tapGestureRecognizerBinding(_ binding: TapGestureRecognizer.Binding) -> TapGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
