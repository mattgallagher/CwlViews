//
//  CwlLayer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 11/1/16.
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

// MARK: - Binder Part 1: Binder
public class Layer: Binder, LayerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Layer {
	enum Binding: LayerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		@available(macOS 10.13, *) @available(iOS, unavailable)
		case constraints(Dynamic<[CAConstraint]>)

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case display((CALayer) -> Void)
		case draw((CALayer, CGContext) -> Void)
	}

	#if os(macOS)
		typealias CAConstraint = QuartzCore.CAConstraint
	#else
		typealias CAConstraint = ()
	#endif
}

// MARK: - Binder Part 3: Preparer
public extension Layer {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = Layer.Binding
		public typealias Inherited = BackingLayer.Preparer
		public typealias Instance = CALayer
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Layer.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .display(let x): delegate().addHandler(x, #selector(CALayerDelegate.display(_:)))
		case .draw(let x): delegate().addHandler(x, #selector(CALayerDelegate.draw(_:in:)))
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .constraints(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.constraints = v }
			#else
				return nil
			#endif

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .display: return nil
		case .draw: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Layer.Preparer {
	open class Storage: BackingLayer.Preparer.Storage, CALayerDelegate {}
	
	open class Delegate: DynamicDelegate, CALayerDelegate {
		open func display(_ layer: CALayer) {
			handler(ofType: ((CALayer) -> Void).self)(layer)
		}
		
		@objc(drawLayer:inContext:) open func draw(_ layer: CALayer, in ctx: CGContext) {
			handler(ofType: ((CALayer, CGContext) -> Void).self)(layer, ctx)
		}
		
		open func layoutSublayers(of layer: CALayer) {
			handler(ofType: ((CALayer) -> Void).self)(layer)
		}
		
		open func action(for layer: CALayer, forKey event: String) -> CAAction? {
			return handler(ofType: ((CALayer, String) -> CAAction?).self)(layer, event)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: LayerBinding {
	public typealias LayerName<V> = BindingName<V, Layer.Binding, Binding>
	private typealias B = Layer.Binding
	private static func name<V>(_ source: @escaping (V) -> Layer.Binding) -> LayerName<V> {
		return LayerName<V>(source: source, downcast: Binding.layerBinding)
	}
}
public extension BindingName where Binding: LayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: LayerName<$2> { return .name(B.$1) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	@available(macOS 10.13, *) @available(iOS, unavailable)
	static var constraints: LayerName<Dynamic<[Layer.CAConstraint]>> { return .name(B.constraints) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var display: LayerName<(CALayer) -> Void> { return .name(B.display) }
	static var draw: LayerName<(CALayer, CGContext) -> Void> { return .name(B.draw) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol LayerConvertible {
	func caLayer() -> Layer.Instance
}
extension CALayer: LayerConvertible, HasDelegate, DefaultConstructable {
	public func caLayer() -> Layer.Instance { return self }
}
public extension Layer {
	 func caLayer() -> Layer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol LayerBinding: BackingLayerBinding {
	static func layerBinding(_ binding: Layer.Binding) -> Self
}
public extension LayerBinding {
	static func backingLayerBinding(_ binding: BackingLayer.Binding) -> Self {
		return layerBinding(.inheritedBinding(binding))
	}
}
public extension Layer.Binding {
	public typealias Preparer = Layer.Preparer
	static func layerBinding(_ binding: Layer.Binding) -> Layer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
