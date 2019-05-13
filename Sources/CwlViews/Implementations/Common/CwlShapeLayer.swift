//
//  CwlShapeLayer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 11/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class ShapeLayer: Binder, ShapeLayerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ShapeLayer {
	enum Binding: ShapeLayerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case fillColor(Dynamic<CGColor?>)
		case fillRule(Dynamic<CAShapeLayerFillRule>)
		case lineCap(Dynamic<CAShapeLayerLineCap>)
		case lineDashPattern(Dynamic<[NSNumber]?>)
		case lineDashPhase(Dynamic<CGFloat>)
		case lineJoin(Dynamic<CAShapeLayerLineJoin>)
		case lineWidth(Dynamic<CGFloat>)
		case miterLimit(Dynamic<CGFloat>)
		case path(Dynamic<CGPath>)
		case strokeColor(Dynamic<CGColor?>)
		case strokeEnd(Dynamic<CGFloat>)
		case strokeStart(Dynamic<CGFloat>)
		
		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ShapeLayer {
	struct Preparer: BinderDelegateDerived {
		public typealias Binding = ShapeLayer.Binding
		public typealias Delegate = Inherited.Delegate
		public typealias Inherited = Layer.Preparer
		public typealias Instance = CAShapeLayer
		
		public var inherited = Inherited()
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
public extension ShapeLayer.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		case .fillColor(let x): return x.apply(instance) { i, v in i.fillColor = v }
		case .fillRule(let x): return x.apply(instance) { i, v in i.fillRule = v }
		case .lineCap(let x): return x.apply(instance) { i, v in i.lineCap = v }
		case .lineDashPattern(let x): return x.apply(instance) { i, v in i.lineDashPattern = v }
		case .lineDashPhase(let x): return x.apply(instance) { i, v in i.lineDashPhase = v }
		case .lineJoin(let x): return x.apply(instance) { i, v in i.lineJoin = v }
		case .lineWidth(let x): return x.apply(instance) { i, v in i.lineWidth = v }
		case .miterLimit(let x): return x.apply(instance) { i, v in i.miterLimit = v }
		case .path(let x): return x.apply(instance) { i, v in i.path = v }
		case .strokeColor(let x): return x.apply(instance) { i, v in i.strokeColor = v }
		case .strokeEnd(let x): return x.apply(instance) { i, v in i.strokeEnd = v }
		case .strokeStart(let x): return x.apply(instance) { i, v in i.strokeStart = v }
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ShapeLayer.Preparer {
	public typealias Storage = Layer.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ShapeLayerBinding {
	public typealias ShapeLayerName<V> = BindingName<V, ShapeLayer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> ShapeLayer.Binding) -> ShapeLayerName<V> {
		return ShapeLayerName<V>(source: source, downcast: Binding.shapeLayerBinding)
	}
}
public extension BindingName where Binding: ShapeLayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ShapeLayerName<$2> { return .name(ShapeLayer.Binding.$1) }
	static var fillColor: ShapeLayerName<Dynamic<CGColor?>> { return .name(ShapeLayer.Binding.fillColor) }
	static var fillRule: ShapeLayerName<Dynamic<CAShapeLayerFillRule>> { return .name(ShapeLayer.Binding.fillRule) }
	static var lineCap: ShapeLayerName<Dynamic<CAShapeLayerLineCap>> { return .name(ShapeLayer.Binding.lineCap) }
	static var lineDashPattern: ShapeLayerName<Dynamic<[NSNumber]?>> { return .name(ShapeLayer.Binding.lineDashPattern) }
	static var lineDashPhase: ShapeLayerName<Dynamic<CGFloat>> { return .name(ShapeLayer.Binding.lineDashPhase) }
	static var lineJoin: ShapeLayerName<Dynamic<CAShapeLayerLineJoin>> { return .name(ShapeLayer.Binding.lineJoin) }
	static var lineWidth: ShapeLayerName<Dynamic<CGFloat>> { return .name(ShapeLayer.Binding.lineWidth) }
	static var miterLimit: ShapeLayerName<Dynamic<CGFloat>> { return .name(ShapeLayer.Binding.miterLimit) }
	static var path: ShapeLayerName<Dynamic<CGPath>> { return .name(ShapeLayer.Binding.path) }
	static var strokeColor: ShapeLayerName<Dynamic<CGColor?>> { return .name(ShapeLayer.Binding.strokeColor) }
	static var strokeEnd: ShapeLayerName<Dynamic<CGFloat>> { return .name(ShapeLayer.Binding.strokeEnd) }
	static var strokeStart: ShapeLayerName<Dynamic<CGFloat>> { return .name(ShapeLayer.Binding.strokeStart) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ShapeLayerConvertible: LayerConvertible {
	func caShapeLayer() -> ShapeLayer.Instance
}
extension ShapeLayerConvertible {
	public func caLayer() -> Layer.Instance { return caShapeLayer() }
}
extension CAShapeLayer: ShapeLayerConvertible {
	public func caShapeLayer() -> ShapeLayer.Instance { return self }
}
public extension ShapeLayer {
	func caShapeLayer() -> ShapeLayer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ShapeLayerBinding: LayerBinding {
	static func shapeLayerBinding(_ binding: ShapeLayer.Binding) -> Self
	func asShapeLayerBinding() -> ShapeLayer.Binding?
}
public extension ShapeLayerBinding {
	static func layerBinding(_ binding: Layer.Binding) -> Self {
		return shapeLayerBinding(.inheritedBinding(binding))
	}
}
public extension ShapeLayerBinding where Preparer.Inherited.Binding: ShapeLayerBinding {
	func asShapeLayerBinding() -> ShapeLayer.Binding? {
		return asInheritedBinding()?.asShapeLayerBinding()
	}
}
public extension ShapeLayer.Binding {
	typealias Preparer = ShapeLayer.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asShapeLayerBinding() -> ShapeLayer.Binding? { return self }
	static func shapeLayerBinding(_ binding: ShapeLayer.Binding) -> ShapeLayer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
