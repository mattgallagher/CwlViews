//
//  CwlGradientLayer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/03.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class GradientLayer: Binder, GradientLayerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension GradientLayer {
	enum Binding: GradientLayerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case colors(Dynamic<[CGColor]>)
		case locations(Dynamic<[CGFloat]>)
		case endPoint(Dynamic<CGPoint>)
		case startPoint(Dynamic<CGPoint>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension GradientLayer {
	struct Preparer: BinderDelegateDerived {
		public typealias Binding = GradientLayer.Binding
		public typealias Delegate = Inherited.Delegate
		public typealias Inherited = Layer.Preparer
		public typealias Instance = CAGradientLayer
		
		public var inherited: Inherited
		public init(delegateClass: Delegate.Type) {
			inherited = Inherited(delegateClass: delegateClass)
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension GradientLayer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .colors(let x): return x.apply(instance) { i, v in i.colors = v }
		case .locations(let x): return x.apply(instance) { i, v in i.locations = v.map { NSNumber(value: Double($0)) } }
		case .endPoint(let x): return x.apply(instance) { i, v in i.endPoint = v }
		case .startPoint(let x): return x.apply(instance) { i, v in i.startPoint = v }

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension GradientLayer.Preparer {
	public typealias Storage = Layer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: GradientLayerBinding {
	public typealias GradientLayerName<V> = BindingName<V, GradientLayer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> GradientLayer.Binding) -> GradientLayerName<V> {
		return GradientLayerName<V>(source: source, downcast: Binding.gradientLayerBinding)
	}
}
public extension BindingName where Binding: GradientLayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: GradientLayerName<$2> { return .name(GradientLayer.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var colors: GradientLayerName<Dynamic<[CGColor]>> { return .name(GradientLayer.Binding.colors) }
	static var locations: GradientLayerName<Dynamic<[CGFloat]>> { return .name(GradientLayer.Binding.locations) }
	static var endPoint: GradientLayerName<Dynamic<CGPoint>> { return .name(GradientLayer.Binding.endPoint) }
	static var startPoint: GradientLayerName<Dynamic<CGPoint>> { return .name(GradientLayer.Binding.startPoint) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol GradientLayerConvertible: LayerConvertible {
	func caGradientLayer() -> GradientLayer.Instance
}
public extension GradientLayerConvertible {
	func caLayer() -> Layer.Instance { return caGradientLayer() }
}
extension CAGradientLayer: GradientLayerConvertible {
	public func caGradientLayer() -> GradientLayer.Instance { return self }
}
public extension GradientLayer {
	func caGradientLayer() -> GradientLayer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol GradientLayerBinding: LayerBinding {
	static func gradientLayerBinding(_ binding: GradientLayer.Binding) -> Self
}
public extension GradientLayerBinding {
	static func layerBinding(_ binding: Layer.Binding) -> Self {
		return gradientLayerBinding(.inheritedBinding(binding))
	}
}
public extension GradientLayer.Binding {
	typealias Preparer = GradientLayer.Preparer
	static func gradientLayerBinding(_ binding: GradientLayer.Binding) -> GradientLayer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
