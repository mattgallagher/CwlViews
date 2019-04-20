//
//  CwlMagnificationGestureRecognizer_macOS.swift
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
public class MagnificationGestureRecognizer: Binder, MagnificationGestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension MagnificationGestureRecognizer {
	enum Binding: MagnificationGestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case magnification(Dynamic<CGFloat>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension MagnificationGestureRecognizer {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = MagnificationGestureRecognizer.Binding
		public typealias Inherited = GestureRecognizer.Preparer
		public typealias Instance = NSMagnificationGestureRecognizer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension MagnificationGestureRecognizer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .magnification(let x): return x.apply(instance) { i, v in i.magnification = v }
			
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension MagnificationGestureRecognizer.Preparer {
	public typealias Storage = GestureRecognizer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: MagnificationGestureRecognizerBinding {
	public typealias MagnificationGestureRecognizerName<V> = BindingName<V, MagnificationGestureRecognizer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> MagnificationGestureRecognizer.Binding) -> MagnificationGestureRecognizerName<V> {
		return MagnificationGestureRecognizerName<V>(source: source, downcast: Binding.magnificationGestureRecognizerBinding)
	}
}
public extension BindingName where Binding: MagnificationGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: MagnificationGestureRecognizerName<$2> { return .name(MagnificationGestureRecognizer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var magnification: MagnificationGestureRecognizerName<Dynamic<CGFloat>> { return .name(MagnificationGestureRecognizer.Binding.magnification) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol MagnificationGestureRecognizerConvertible: GestureRecognizerConvertible {
	func nsMagnificationGestureRecognizer() -> MagnificationGestureRecognizer.Instance
}
extension MagnificationGestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return nsMagnificationGestureRecognizer() }
}
extension NSMagnificationGestureRecognizer: MagnificationGestureRecognizerConvertible {
	public func nsMagnificationGestureRecognizer() -> MagnificationGestureRecognizer.Instance { return self }
}
public extension MagnificationGestureRecognizer {
	func nsMagnificationGestureRecognizer() -> MagnificationGestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol MagnificationGestureRecognizerBinding: GestureRecognizerBinding {
	static func magnificationGestureRecognizerBinding(_ binding: MagnificationGestureRecognizer.Binding) -> Self
}
public extension MagnificationGestureRecognizerBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return magnificationGestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension MagnificationGestureRecognizer.Binding {
	typealias Preparer = MagnificationGestureRecognizer.Preparer
	static func magnificationGestureRecognizerBinding(_ binding: MagnificationGestureRecognizer.Binding) -> MagnificationGestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
