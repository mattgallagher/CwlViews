//
//  CwlBackingLayer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 19/10/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

import QuartzCore

// MARK: - Binder Part 1: Binder
public class BackingLayer: Binder {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension BackingLayer {
	enum Binding: BackingLayerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case actions(Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>)
		case affineTransform(Dynamic<CGAffineTransform>)
		case anchorPoint(Dynamic<CGPoint>)
		case anchorPointZ(Dynamic<CGFloat>)
		case backgroundColor(Dynamic<CGColor?>)
		case borderColor(Dynamic<CGColor?>)
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
	}

	#if os(macOS)
		typealias CAAutoresizingMask = QuartzCore.CAAutoresizingMask
		typealias CIFilter = QuartzCore.CIFilter
	#else
		typealias CAAutoresizingMask = ()
		typealias CIFilter = ()
	#endif
}

// MARK: - Binder Part 3: Preparer
public extension BackingLayer {
	struct Preparer: BinderEmbedder {
		public typealias Binding = BackingLayer.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = CALayer
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension BackingLayer.Preparer {
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
		case .filters(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.filters = v }
			#else
				return nil
			#endif

		//	2. Signal bindings are performed on the object after construction.
		case .addAnimation(let x): return x.apply(instance) { i, v in
			i.add(v.animation, forKey: v.key)
		}
		case .needsDisplay(let x): return x.apply(instance) { i, v in i.setNeedsDisplay() }
		case .needsDisplayInRect(let x): return x.apply(instance) { i, v in i.setNeedsDisplay(v) }
		case .removeAllAnimations(let x): return x.apply(instance) { i, v in i.removeAllAnimations() }
		case .removeAnimationForKey(let x): return x.apply(instance) { i, v in i.removeAnimation(forKey: v) }
		case .scrollRectToVisible(let x): return x.apply(instance) { i, v in i.scrollRectToVisible(v) }
			
		//	3. Action bindings are triggered by the object after construction.
			
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension BackingLayer.Preparer {
	open class Storage: EmbeddedObjectStorage, CAAction {
		// LayerBinderStorage implementation
		open var layerActions = [String: SignalInput<[AnyHashable: Any]?>]()
		@objc open func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable: Any]?) {
			_ = layerActions[event]?.send(value: dict)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: BackingLayerBinding {
	public typealias BackingLayerName<V> = BindingName<V, BackingLayer.Binding, Binding>
	private typealias B = BackingLayer.Binding
	private static func name<V>(_ source: @escaping (V) -> BackingLayer.Binding) -> BackingLayerName<V> {
		return BackingLayerName<V>(source: source, downcast: Binding.backingLayerBinding)
	}
}
public extension BindingName where Binding: BackingLayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: BackingLayerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var actions: BackingLayerName<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>> { return .name(B.actions) }
	static var affineTransform: BackingLayerName<Dynamic<CGAffineTransform>> { return .name(B.affineTransform) }
	static var anchorPoint: BackingLayerName<Dynamic<CGPoint>> { return .name(B.anchorPoint) }
	static var anchorPointZ: BackingLayerName<Dynamic<CGFloat>> { return .name(B.anchorPointZ) }
	static var backgroundColor: BackingLayerName<Dynamic<CGColor?>> { return .name(B.backgroundColor) }
	static var borderColor: BackingLayerName<Dynamic<CGColor?>> { return .name(B.borderColor) }
	static var borderWidth: BackingLayerName<Dynamic<CGFloat>> { return .name(B.borderWidth) }
	static var bounds: BackingLayerName<Dynamic<CGRect>> { return .name(B.bounds) }
	static var contents: BackingLayerName<Dynamic<Any?>> { return .name(B.contents) }
	static var contentsCenter: BackingLayerName<Dynamic<CGRect>> { return .name(B.contentsCenter) }
	static var contentsGravity: BackingLayerName<Dynamic<CALayerContentsGravity>> { return .name(B.contentsGravity) }
	static var contentsRect: BackingLayerName<Dynamic<CGRect>> { return .name(B.contentsRect) }
	static var contentsScale: BackingLayerName<Dynamic<CGFloat>> { return .name(B.contentsScale) }
	static var cornerRadius: BackingLayerName<Dynamic<CGFloat>> { return .name(B.cornerRadius) }
	static var drawsAsynchronously: BackingLayerName<Dynamic<Bool>> { return .name(B.drawsAsynchronously) }
	static var edgeAntialiasingMask: BackingLayerName<Dynamic<CAEdgeAntialiasingMask>> { return .name(B.edgeAntialiasingMask) }
	static var frame: BackingLayerName<Dynamic<CGRect>> { return .name(B.frame) }
	static var isDoubleSided: BackingLayerName<Dynamic<Bool>> { return .name(B.isDoubleSided) }
	static var isGeometryFlipped: BackingLayerName<Dynamic<Bool>> { return .name(B.isGeometryFlipped) }
	static var isHidden: BackingLayerName<Dynamic<Bool>> { return .name(B.isHidden) }
	static var isOpaque: BackingLayerName<Dynamic<Bool>> { return .name(B.isOpaque) }
	static var magnificationFilter: BackingLayerName<Dynamic<CALayerContentsFilter>> { return .name(B.magnificationFilter) }
	static var mask: BackingLayerName<Dynamic<LayerConvertible?>> { return .name(B.mask) }
	static var masksToBounds: BackingLayerName<Dynamic<Bool>> { return .name(B.masksToBounds) }
	static var minificationFilter: BackingLayerName<Dynamic<CALayerContentsFilter>> { return .name(B.minificationFilter) }
	static var minificationFilterBias: BackingLayerName<Dynamic<Float>> { return .name(B.minificationFilterBias) }
	static var name: BackingLayerName<Dynamic<String>> { return .name(B.name) }
	static var needsDisplayOnBoundsChange: BackingLayerName<Dynamic<Bool>> { return .name(B.needsDisplayOnBoundsChange) }
	static var opacity: BackingLayerName<Dynamic<Float>> { return .name(B.opacity) }
	static var position: BackingLayerName<Dynamic<CGPoint>> { return .name(B.position) }
	static var rasterizationScale: BackingLayerName<Dynamic<CGFloat>> { return .name(B.rasterizationScale) }
	static var shadowColor: BackingLayerName<Dynamic<CGColor?>> { return .name(B.shadowColor) }
	static var shadowOffset: BackingLayerName<Dynamic<CGSize>> { return .name(B.shadowOffset) }
	static var shadowOpacity: BackingLayerName<Dynamic<Float>> { return .name(B.shadowOpacity) }
	static var shadowPath: BackingLayerName<Dynamic<CGPath?>> { return .name(B.shadowPath) }
	static var shadowRadius: BackingLayerName<Dynamic<CGFloat>> { return .name(B.shadowRadius) }
	static var shouldRasterize: BackingLayerName<Dynamic<Bool>> { return .name(B.shouldRasterize) }
	static var style: BackingLayerName<Dynamic<[AnyHashable: Any]>> { return .name(B.style) }
	static var sublayers: BackingLayerName<Dynamic<[LayerConvertible]>> { return .name(B.sublayers) }
	static var sublayerTransform: BackingLayerName<Dynamic<CATransform3D>> { return .name(B.sublayerTransform) }
	static var transform: BackingLayerName<Dynamic<CATransform3D>> { return .name(B.transform) }
	static var zPosition: BackingLayerName<Dynamic<CGFloat>> { return .name(B.zPosition) }
	
	@available(macOS 10.13, *) @available(iOS, unavailable) static var autoresizingMask: BackingLayerName<Dynamic<BackingLayer.CAAutoresizingMask>> { return .name(B.autoresizingMask) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var backgroundFilters: BackingLayerName<Dynamic<[BackingLayer.CIFilter]?>> { return .name(B.backgroundFilters) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var compositingFilter: BackingLayerName<Dynamic<BackingLayer.CIFilter?>> { return .name(B.compositingFilter) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var filters: BackingLayerName<Dynamic<[BackingLayer.CIFilter]?>> { return .name(B.filters) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var addAnimation: BackingLayerName<Signal<AnimationForKey>> { return .name(B.addAnimation) }
	static var needsDisplay: BackingLayerName<Signal<Void>> { return .name(B.needsDisplay) }
	static var needsDisplayInRect: BackingLayerName<Signal<CGRect>> { return .name(B.needsDisplayInRect) }
	static var removeAllAnimations: BackingLayerName<Signal<Void>> { return .name(B.removeAllAnimations) }
	static var removeAnimationForKey: BackingLayerName<Signal<String>> { return .name(B.removeAnimationForKey) }
	static var scrollRectToVisible: BackingLayerName<Signal<CGRect>> { return .name(B.scrollRectToVisible) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)

// MARK: - Binder Part 8: Downcast protocols
public protocol BackingLayerBinding: BinderBaseBinding {
	static func backingLayerBinding(_ binding: BackingLayer.Binding) -> Self
}
public extension BackingLayerBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return backingLayerBinding(.inheritedBinding(binding))
	}
}
public extension BackingLayer.Binding {
	typealias Preparer = BackingLayer.Preparer
	static func backingLayerBinding(_ binding: BackingLayer.Binding) -> BackingLayer.Binding {
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
		
		// NOTE: fade animations are always applied under key kCATransition so it's pointeless trying to set a key
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
