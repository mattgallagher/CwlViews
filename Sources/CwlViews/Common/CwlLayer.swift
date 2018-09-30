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

public class Layer: ConstructingBinder, LayerConvertible {
	public typealias Instance = CALayer
	public typealias Inherited = BackingLayer

	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public var cgLayer: Instance { return instance() }
	
	public enum Binding: LayerBinding {
		public typealias EnclosingBinder = Layer
		public static func layerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)

		//	1. Value bindings may be applied at construction and may subsequently change.
		#if os(macOS)
			case constraints(Dynamic<[CAConstraint]>)
		#else
			@available(*, unavailable)
			case constraints(())
		#endif

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case display((CALayer) -> Void)
		case draw((CALayer, CGContext) -> Void)
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Layer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {
			self.init(delegateClass: InternalDelegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: InternalDelegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: InternalDelegate.Type
		var possibleDelegate: InternalDelegate? = nil
		mutating func delegate() -> InternalDelegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .display(let x):
				let s = #selector(CALayerDelegate.display(_:))
				delegate().addSelector(s).display = x
			case .draw(let x):
				let s = #selector(CALayerDelegate.draw(_:in:))
				delegate().addSelector(s).drawLayer = x
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			// Don't steal the delegate from the view if already set
			if possibleDelegate != nil {
				precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
				storage.dynamicDelegate = possibleDelegate
				instance.delegate = storage
			}
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .constraints(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.constraints = v }
				#else
					return nil
				#endif
			case .display: return nil
			case .draw: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: BackingLayer.Storage, CALayerDelegate {}

	open class InternalDelegate: DynamicDelegate, CALayerDelegate {
		public required override init() {
			super.init()
		}
		
		open var display: ((CALayer) -> Void)?
		open func display(_ layer: CALayer) {
			return display!(layer)
		}
		
		open var drawLayer: ((CALayer, CGContext) -> Void)?
		@objc(drawLayer:inContext:) open func draw(_ layer: CALayer, in ctx: CGContext) {
			return drawLayer!(layer, ctx)
		}
		
		open var layoutSublayers: ((CALayer) -> Void)?
		open func layoutSublayers(of layer: CALayer) {
			return layoutSublayers!(layer)
		}
		
		open var action: ((CALayer, String) -> CAAction?)?
		open func action(for layer: CALayer, forKey event: String) -> CAAction? {
			return action!(layer, event)
		}
	}
}

extension BindingName where Binding: LayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .layerBinding(Layer.Binding.$1(v)) }) }
	#if os(macOS)
		public static var constraints: BindingName<Dynamic<[CAConstraint]>, Binding> { return BindingName<Dynamic<[CAConstraint]>, Binding>({ v in .layerBinding(Layer.Binding.constraints(v)) }) }
	#endif
	public static var display: BindingName<(CALayer) -> Void, Binding> { return BindingName<(CALayer) -> Void, Binding>({ v in .layerBinding(Layer.Binding.display(v)) }) }
	public static var draw: BindingName<(CALayer, CGContext) -> Void, Binding> { return BindingName<(CALayer, CGContext) -> Void, Binding>({ v in .layerBinding(Layer.Binding.draw(v)) }) }
}

public protocol LayerConvertible {
	var cgLayer: Layer.Instance { get }
}
extension Layer.Instance: LayerConvertible {
	public var cgLayer: Layer.Instance { return self }
}

public protocol LayerBinding: BackingLayerBinding {
	static func layerBinding(_ binding: Layer.Binding) -> Self
}

extension LayerBinding {
	public static func backingLayerBinding(_ binding: BackingLayer.Binding) -> Self {
		return layerBinding(.inheritedBinding(binding))
	}
}
