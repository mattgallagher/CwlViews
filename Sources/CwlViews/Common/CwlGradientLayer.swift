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

public class GradientLayer: ConstructingBinder, GradientLayerConvertible {
	public typealias Instance = CAGradientLayer
	public typealias Inherited = Layer
	
	public var state: BinderState<Instance, BinderSubclassParameters<Instance, Binding>>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiGradientLayer() -> Instance { return instance() }

	public enum Binding: GradientLayerBinding {
		public typealias EnclosingBinder = GradientLayer
		public static func gradientLayerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case colors(Dynamic<[CGColor]>)
		case locations(Dynamic<[CGFloat]>)
		case endPoint(Dynamic<CGPoint>)
		case startPoint(Dynamic<CGPoint>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = GradientLayer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .colors(let x): return x.apply(instance, storage) { i, s, v in i.colors = v }
			case .locations(let x): return x.apply(instance, storage) { i, s, v in i.locations = v.map { NSNumber(value: Double($0)) } }
			case .endPoint(let x): return x.apply(instance, storage) { i, s, v in i.endPoint = v }
			case .startPoint(let x): return x.apply(instance, storage) { i, s, v in i.startPoint = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = Layer.Storage
}

extension BindingName where Binding: GradientLayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .gradientLayerBinding(GradientLayer.Binding.$1(v)) }) }
	public static var colors: BindingName<Dynamic<[CGColor]>, Binding> { return BindingName<Dynamic<[CGColor]>, Binding>({ v in .gradientLayerBinding(GradientLayer.Binding.colors(v)) }) }
	public static var locations: BindingName<Dynamic<[CGFloat]>, Binding> { return BindingName<Dynamic<[CGFloat]>, Binding>({ v in .gradientLayerBinding(GradientLayer.Binding.locations(v)) }) }
	public static var endPoint: BindingName<Dynamic<CGPoint>, Binding> { return BindingName<Dynamic<CGPoint>, Binding>({ v in .gradientLayerBinding(GradientLayer.Binding.endPoint(v)) }) }
	public static var startPoint: BindingName<Dynamic<CGPoint>, Binding> { return BindingName<Dynamic<CGPoint>, Binding>({ v in .gradientLayerBinding(GradientLayer.Binding.startPoint(v)) }) }
}

public protocol GradientLayerConvertible: LayerConvertible {
	func uiGradientLayer() -> GradientLayer.Instance
}
extension GradientLayerConvertible {
	public var cgLayer: Layer.Instance { return uiGradientLayer() }
}
extension GradientLayer.Instance: GradientLayerConvertible {
	public func uiGradientLayer() -> GradientLayer.Instance { return self }
}

public protocol GradientLayerBinding: LayerBinding {
	static func gradientLayerBinding(_ binding: GradientLayer.Binding) -> Self
}

extension GradientLayerBinding {
	public static func layerBinding(_ binding: Layer.Binding) -> Self {
		return gradientLayerBinding(.inheritedBinding(binding))
	}
}
