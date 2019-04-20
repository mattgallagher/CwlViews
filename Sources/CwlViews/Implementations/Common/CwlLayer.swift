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
		case actions(Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>)
		case affineTransform(Dynamic<CGAffineTransform>)
		case anchorPoint(Dynamic<CGPoint>)
		case anchorPointZ(Dynamic<CGFloat>)
		case backgroundColor(Dynamic<CGColor>)
		case borderColor(Dynamic<CGColor>)
		case borderWidth(Dynamic<CGFloat>)
		case bounds(Dynamic<CGRect>)
		case contents(Dynamic<Any?>)
		case contentsCenter(Dynamic<CGRect>)
		case contentsGravity(Dynamic<CALayerContentsGravity>)
		case contentsRect(Dynamic<CGRect>)
		case contentsScale(Dynamic<CGFloat>)
		case cornerRadius(Dynamic<CGFloat>)
		case drawsAsynchronously(Dynamic<Bool>)
		case edgeAntialiasingMask(Dynamic<CAEdgeAntialiasingMask>)
		case frame(Dynamic<CGRect>)
		case isDoubleSided(Dynamic<Bool>)
		case isGeometryFlipped(Dynamic<Bool>)
		case isHidden(Dynamic<Bool>)
		case isOpaque(Dynamic<Bool>)
		case magnificationFilter(Dynamic<CALayerContentsFilter>)
		case mask(Dynamic<LayerConvertible?>)
		case masksToBounds(Dynamic<Bool>)
		case minificationFilter(Dynamic<CALayerContentsFilter>)
		case minificationFilterBias(Dynamic<Float>)
		case name(Dynamic<String>)
		case needsDisplayOnBoundsChange(Dynamic<Bool>)
		case opacity(Dynamic<Float>)
		case position(Dynamic<CGPoint>)
		case rasterizationScale(Dynamic<CGFloat>)
		case shadowColor(Dynamic<CGColor?>)
		case shadowOffset(Dynamic<CGSize>)
		case shadowOpacity(Dynamic<Float>)
		case shadowPath(Dynamic<CGPath?>)
		case shadowRadius(Dynamic<CGFloat>)
		case shouldRasterize(Dynamic<Bool>)
		case style(Dynamic<[AnyHashable: Any]>)
		case sublayers(Dynamic<[LayerConvertible]>)
		case sublayerTransform(Dynamic<CATransform3D>)
		case transform(Dynamic<CATransform3D>)
		case zPosition(Dynamic<CGFloat>)

		@available(macOS 10.13, *) @available(iOS, unavailable) case autoresizingMask(Dynamic<CAAutoresizingMask>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case backgroundFilters(Dynamic<[CIFilter]?>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case compositingFilter(Dynamic<CIFilter?>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case constraints(Dynamic<[CAConstraint]>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case filters(Dynamic<[CIFilter]?>)

		//	2. Signal bindings are performed on the object after construction.
		case addAnimation(Signal<AnimationForKey>)
		case needsDisplay(Signal<Void>)
		case needsDisplayInRect(Signal<CGRect>)
		case removeAllAnimations(Signal<Void>)
		case removeAnimationForKey(Signal<String>)
		case scrollRectToVisible(Signal<CGRect>)

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case display((CALayer) -> Void)
		case draw((CALayer, CGContext) -> Void)
		case layoutSublayers((CALayer) -> Void)
		case willDraw((CALayer) -> Void)
	}

	#if os(macOS)
		typealias CAAutoresizingMask = QuartzCore.CAAutoresizingMask
		typealias CIFilter = QuartzCore.CIFilter
		typealias CAConstraint = QuartzCore.CAConstraint
	#else
		typealias CAConstraint = ()
		typealias CAAutoresizingMask = ()
		typealias CIFilter = ()
	#endif
}

// MARK: - Binder Part 3: Preparer
public extension Layer {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = Layer.Binding
		public typealias Inherited = BinderBase
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
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .display(let x): delegate().addMultiHandler1(x, #selector(CALayerDelegate.display(_:)))
		case .draw(let x): delegate().addMultiHandler2(x, #selector(CALayerDelegate.draw(_:in:)))
		case .willDraw(let x): delegate().addMultiHandler1(x, #selector(CALayerDelegate.layerWillDraw(_:)))
		case .layoutSublayers(let x): delegate().addMultiHandler1(x, #selector(CALayerDelegate.layoutSublayers(of:)))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .actions(let x):
			return x.apply(instance, storage) { i, s, v in
				var actions = i.actions ?? [String: CAAction]()
				for (key, input) in v {
					if let i = input {
						actions[key] = s
						storage.layerActions[key] = i
					} else {
						actions[key] = NSNull()
						s.layerActions.removeValue(forKey: key)
					}
				}
				i.actions = actions
			}
		case .affineTransform(let x): return x.apply(instance) { i, v in i.setAffineTransform(v) }
		case .anchorPoint(let x): return x.apply(instance) { i, v in i.anchorPoint = v }
		case .anchorPointZ(let x): return x.apply(instance) { i, v in i.anchorPointZ = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .borderColor(let x): return x.apply(instance) { i, v in i.borderColor = v }
		case .borderWidth(let x): return x.apply(instance) { i, v in i.borderWidth = v }
		case .bounds(let x): return x.apply(instance) { i, v in i.bounds = v }
		case .contents(let x): return x.apply(instance) { i, v in i.contents = v }
		case .contentsCenter(let x): return x.apply(instance) { i, v in i.contentsCenter = v }
		case .contentsGravity(let x): return x.apply(instance) { i, v in i.contentsGravity = v }
		case .contentsRect(let x): return x.apply(instance) { i, v in i.contentsRect = v }
		case .contentsScale(let x): return x.apply(instance) { i, v in i.contentsScale = v }
		case .cornerRadius(let x): return x.apply(instance) { i, v in i.cornerRadius = v }
		case .drawsAsynchronously(let x): return x.apply(instance) { i, v in i.drawsAsynchronously = v }
		case .edgeAntialiasingMask(let x): return x.apply(instance) { i, v in i.edgeAntialiasingMask = v }
		case .frame(let x): return x.apply(instance) { i, v in i.frame = v }
		case .isDoubleSided(let x): return x.apply(instance) { i, v in i.isDoubleSided = v }
		case .isGeometryFlipped(let x): return x.apply(instance) { i, v in i.isGeometryFlipped = v }
		case .isHidden(let x): return x.apply(instance) { i, v in i.isHidden = v }
		case .isOpaque(let x): return x.apply(instance) { i, v in i.isOpaque = v }
		case .magnificationFilter(let x): return x.apply(instance) { i, v in i.magnificationFilter = v }
		case .mask(let x): return x.apply(instance) { i, v in i.mask = v?.caLayer() }
		case .masksToBounds(let x): return x.apply(instance) { i, v in i.masksToBounds = v }
		case .minificationFilter(let x): return x.apply(instance) { i, v in i.minificationFilter = v }
		case .minificationFilterBias(let x): return x.apply(instance) { i, v in i.minificationFilterBias = v }
		case .name(let x): return x.apply(instance) { i,v in i.name = v }
		case .needsDisplayOnBoundsChange(let x): return x.apply(instance) { i, v in i.needsDisplayOnBoundsChange = v }
		case .opacity(let x): return x.apply(instance) { i, v in i.opacity = v }
		case .position(let x): return x.apply(instance) { i, v in i.position = v }
		case .rasterizationScale(let x): return x.apply(instance) { i, v in i.rasterizationScale = v }
		case .shadowColor(let x): return x.apply(instance) { i, v in i.shadowColor = v }
		case .shadowOffset(let x): return x.apply(instance) { i, v in i.shadowOffset = v }
		case .shadowOpacity(let x): return x.apply(instance) { i, v in i.shadowOpacity = v }
		case .shadowPath(let x): return x.apply(instance) { i, v in i.shadowPath = v }
		case .shadowRadius(let x): return x.apply(instance) { i, v in i.shadowRadius = v }
		case .shouldRasterize(let x): return x.apply(instance) { i, v in i.shouldRasterize = v }
		case .style(let x): return x.apply(instance) { i,v in i.style = v }
		case .sublayers(let x): return x.apply(instance) { i, v in i.sublayers = v.map { $0.caLayer() } }
		case .sublayerTransform(let x): return x.apply(instance) { i, v in i.sublayerTransform = v }
		case .transform(let x): return x.apply(instance) { i, v in i.transform = v }
		case .zPosition(let x): return x.apply(instance) { i, v in i.zPosition = v }
		
		case .autoresizingMask(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.autoresizingMask = v }
			#else
				return nil
			#endif
		case .backgroundFilters(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.backgroundFilters = v }
			#else
				return nil
			#endif
		case .compositingFilter(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.compositingFilter = v }
			#else
				return nil
			#endif
		case .constraints(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.constraints = v }
			#else
				return nil
			#endif
		case .filters(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.filters = v }
			#else
				return nil
			#endif

		//	2. Signal bindings are performed on the object after construction.
		case .addAnimation(let x): return x.apply(instance) { i, v in i.addAnimationForKey(v) }
		case .needsDisplay(let x): return x.apply(instance) { i, v in i.setNeedsDisplay() }
		case .needsDisplayInRect(let x): return x.apply(instance) { i, v in i.setNeedsDisplay(v) }
		case .removeAllAnimations(let x): return x.apply(instance) { i, v in i.removeAllAnimations() }
		case .removeAnimationForKey(let x): return x.apply(instance) { i, v in i.removeAnimation(forKey: v) }
		case .scrollRectToVisible(let x): return x.apply(instance) { i, v in i.scrollRectToVisible(v) }

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .display: return nil
		case .draw: return nil
		case .layoutSublayers: return nil
		case .willDraw: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Layer.Preparer {
	open class Storage: AssociatedBinderStorage, CAAction, CALayerDelegate {
		// LayerBinderStorage implementation
		open var layerActions = [String: SignalInput<[AnyHashable: Any]?>]()
		@objc open func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable: Any]?) {
			_ = layerActions[event]?.send(value: dict)
		}

		open func action(for layer: CALayer, forKey event: String) -> CAAction? {
			return layerActions[event] != nil ? self : nil
		}
	}
	
	open class Delegate: DynamicDelegate, CALayerDelegate {
		open func layerWillDraw(_ layer: CALayer) {
			multiHandler(layer)
		}
		
		open func display(_ layer: CALayer) {
			multiHandler(layer)
		}
		
		@objc(drawLayer:inContext:) open func draw(_ layer: CALayer, in ctx: CGContext) {
			multiHandler(layer, ctx)
		}
		
		open func layoutSublayers(of layer: CALayer) {
			multiHandler(layer)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: LayerBinding {
	public typealias LayerName<V> = BindingName<V, Layer.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> Layer.Binding) -> LayerName<V> {
		return LayerName<V>(source: source, downcast: Binding.layerBinding)
	}
}
public extension BindingName where Binding: LayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: LayerName<$2> { return .name(Layer.Binding.$1) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var actions: LayerName<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>> { return .name(Layer.Binding.actions) }
	static var affineTransform: LayerName<Dynamic<CGAffineTransform>> { return .name(Layer.Binding.affineTransform) }
	static var anchorPoint: LayerName<Dynamic<CGPoint>> { return .name(Layer.Binding.anchorPoint) }
	static var anchorPointZ: LayerName<Dynamic<CGFloat>> { return .name(Layer.Binding.anchorPointZ) }
	static var backgroundColor: LayerName<Dynamic<CGColor>> { return .name(Layer.Binding.backgroundColor) }
	static var borderColor: LayerName<Dynamic<CGColor>> { return .name(Layer.Binding.borderColor) }
	static var borderWidth: LayerName<Dynamic<CGFloat>> { return .name(Layer.Binding.borderWidth) }
	static var bounds: LayerName<Dynamic<CGRect>> { return .name(Layer.Binding.bounds) }
	static var contents: LayerName<Dynamic<Any?>> { return .name(Layer.Binding.contents) }
	static var contentsCenter: LayerName<Dynamic<CGRect>> { return .name(Layer.Binding.contentsCenter) }
	static var contentsGravity: LayerName<Dynamic<CALayerContentsGravity>> { return .name(Layer.Binding.contentsGravity) }
	static var contentsRect: LayerName<Dynamic<CGRect>> { return .name(Layer.Binding.contentsRect) }
	static var contentsScale: LayerName<Dynamic<CGFloat>> { return .name(Layer.Binding.contentsScale) }
	static var cornerRadius: LayerName<Dynamic<CGFloat>> { return .name(Layer.Binding.cornerRadius) }
	static var drawsAsynchronously: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.drawsAsynchronously) }
	static var edgeAntialiasingMask: LayerName<Dynamic<CAEdgeAntialiasingMask>> { return .name(Layer.Binding.edgeAntialiasingMask) }
	static var frame: LayerName<Dynamic<CGRect>> { return .name(Layer.Binding.frame) }
	static var isDoubleSided: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.isDoubleSided) }
	static var isGeometryFlipped: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.isGeometryFlipped) }
	static var isHidden: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.isHidden) }
	static var isOpaque: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.isOpaque) }
	static var magnificationFilter: LayerName<Dynamic<CALayerContentsFilter>> { return .name(Layer.Binding.magnificationFilter) }
	static var mask: LayerName<Dynamic<LayerConvertible?>> { return .name(Layer.Binding.mask) }
	static var masksToBounds: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.masksToBounds) }
	static var minificationFilter: LayerName<Dynamic<CALayerContentsFilter>> { return .name(Layer.Binding.minificationFilter) }
	static var minificationFilterBias: LayerName<Dynamic<Float>> { return .name(Layer.Binding.minificationFilterBias) }
	static var name: LayerName<Dynamic<String>> { return .name(Layer.Binding.name) }
	static var needsDisplayOnBoundsChange: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.needsDisplayOnBoundsChange) }
	static var opacity: LayerName<Dynamic<Float>> { return .name(Layer.Binding.opacity) }
	static var position: LayerName<Dynamic<CGPoint>> { return .name(Layer.Binding.position) }
	static var rasterizationScale: LayerName<Dynamic<CGFloat>> { return .name(Layer.Binding.rasterizationScale) }
	static var shadowColor: LayerName<Dynamic<CGColor?>> { return .name(Layer.Binding.shadowColor) }
	static var shadowOffset: LayerName<Dynamic<CGSize>> { return .name(Layer.Binding.shadowOffset) }
	static var shadowOpacity: LayerName<Dynamic<Float>> { return .name(Layer.Binding.shadowOpacity) }
	static var shadowPath: LayerName<Dynamic<CGPath?>> { return .name(Layer.Binding.shadowPath) }
	static var shadowRadius: LayerName<Dynamic<CGFloat>> { return .name(Layer.Binding.shadowRadius) }
	static var shouldRasterize: LayerName<Dynamic<Bool>> { return .name(Layer.Binding.shouldRasterize) }
	static var style: LayerName<Dynamic<[AnyHashable: Any]>> { return .name(Layer.Binding.style) }
	static var sublayers: LayerName<Dynamic<[LayerConvertible]>> { return .name(Layer.Binding.sublayers) }
	static var sublayerTransform: LayerName<Dynamic<CATransform3D>> { return .name(Layer.Binding.sublayerTransform) }
	static var transform: LayerName<Dynamic<CATransform3D>> { return .name(Layer.Binding.transform) }
	static var zPosition: LayerName<Dynamic<CGFloat>> { return .name(Layer.Binding.zPosition) }
	
	@available(macOS 10.13, *) @available(iOS, unavailable) static var autoresizingMask: LayerName<Dynamic<Layer.CAAutoresizingMask>> { return .name(Layer.Binding.autoresizingMask) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var backgroundFilters: LayerName<Dynamic<[Layer.CIFilter]?>> { return .name(Layer.Binding.backgroundFilters) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var compositingFilter: LayerName<Dynamic<Layer.CIFilter?>> { return .name(Layer.Binding.compositingFilter) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var constraints: LayerName<Dynamic<[Layer.CAConstraint]>> { return .name(Layer.Binding.constraints) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var filters: LayerName<Dynamic<[Layer.CIFilter]?>> { return .name(Layer.Binding.filters) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var addAnimation: LayerName<Signal<AnimationForKey>> { return .name(Layer.Binding.addAnimation) }
	static var needsDisplay: LayerName<Signal<Void>> { return .name(Layer.Binding.needsDisplay) }
	static var needsDisplayInRect: LayerName<Signal<CGRect>> { return .name(Layer.Binding.needsDisplayInRect) }
	static var removeAllAnimations: LayerName<Signal<Void>> { return .name(Layer.Binding.removeAllAnimations) }
	static var removeAnimationForKey: LayerName<Signal<String>> { return .name(Layer.Binding.removeAnimationForKey) }
	static var scrollRectToVisible: LayerName<Signal<CGRect>> { return .name(Layer.Binding.scrollRectToVisible) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var display: LayerName<(CALayer) -> Void> { return .name(Layer.Binding.display) }
	static var draw: LayerName<(CALayer, CGContext) -> Void> { return .name(Layer.Binding.draw) }
	static var layoutSublayers: LayerName<(CALayer) -> Void> { return .name(Layer.Binding.layoutSublayers) }
	static var willDraw: LayerName<(CALayer) -> Void> { return .name(Layer.Binding.willDraw) }
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
public protocol LayerBinding: BinderBaseBinding {
	static func layerBinding(_ binding: Layer.Binding) -> Self
}
public extension LayerBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return layerBinding(.inheritedBinding(binding))
	}
}
public extension Layer.Binding {
	typealias Preparer = Layer.Preparer
	static func layerBinding(_ binding: Layer.Binding) -> Layer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct AnimationForKey {
	public let animation: CAAnimation
	public let key: String?
	
	public init(animation: CAAnimation, forKey: String? = nil) {
		self.animation = animation
		self.key = forKey
	}
	
	public static var fade: AnimationForKey {
		let t = CATransition()
		t.type = CATransitionType.fade
		
		// NOTE: fade animations are always applied under key kCATransition so it's pointless trying to set a key
		return AnimationForKey(animation: t, forKey: nil)
	}
	
	public enum Direction {
		case left, right, top, bottom
		func transition(ofType: CATransitionType, forKey: String? = nil) -> AnimationForKey {
			let t = CATransition()
			t.type = ofType
			switch self {
			case .left: t.subtype = CATransitionSubtype.fromLeft
			case .right: t.subtype = CATransitionSubtype.fromRight
			case .top: t.subtype = CATransitionSubtype.fromTop
			case .bottom: t.subtype = CATransitionSubtype.fromBottom
			}
			return AnimationForKey(animation: t, forKey: forKey)
		}
	}
	
	public static func moveIn(from: Direction, forKey: String? = nil) -> AnimationForKey {
		return from.transition(ofType: CATransitionType.moveIn, forKey: forKey)
	}
	
	public static func push(from: Direction, forKey: String? = nil) -> AnimationForKey {
		return from.transition(ofType: CATransitionType.push, forKey: forKey)
	}
	
	public static func reveal(from: Direction, forKey: String? = nil) -> AnimationForKey {
		return from.transition(ofType: CATransitionType.reveal, forKey: forKey)
	}
}

public extension CALayer {
	func addAnimationForKey(_ animationForKey: AnimationForKey) {
		add(animationForKey.animation, forKey: animationForKey.key)
	}
}
