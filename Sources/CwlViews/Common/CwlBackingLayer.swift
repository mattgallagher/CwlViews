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

public class BackingLayer: Binder {
	public typealias Instance = CALayer
	public typealias Inherited = BaseBinder

	public var state: BinderState<Instance, BindingsOnlyParameters<Binding>>
	public required init(state: BinderState<Instance, BindingsOnlyParameters<Binding>>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	
	public enum Binding: BackingLayerBinding {
		public typealias EnclosingBinder = BackingLayer
		public static func backingLayerBinding(_ binding: BackingLayer.Binding) -> BackingLayer.Binding { return binding }
		
		case inheritedBinding(Inherited.Binding)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case affineTransform(Dynamic<CGAffineTransform>)
		case anchorPoint(Dynamic<CGPoint>)
		case anchorPointZ(Dynamic<CGFloat>)
		case actions(Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>)
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
		case isDoubleSided(Dynamic<Bool>)
		case drawsAsynchronously(Dynamic<Bool>)
		case edgeAntialiasingMask(Dynamic<CAEdgeAntialiasingMask>)
		case frame(Dynamic<CGRect>)
		case isGeometryFlipped(Dynamic<Bool>)
		case isHidden(Dynamic<Bool>)
		case magnificationFilter(Dynamic<CALayerContentsFilter>)
		case masksToBounds(Dynamic<Bool>)
		case minificationFilter(Dynamic<CALayerContentsFilter>)
		case minificationFilterBias(Dynamic<Float>)
		case name(Dynamic<String>)
		case needsDisplayOnBoundsChange(Dynamic<Bool>)
		case opacity(Dynamic<Float>)
		case isOpaque(Dynamic<Bool>)
		case position(Dynamic<CGPoint>)
		case rasterizationScale(Dynamic<CGFloat>)
		case shadowColor(Dynamic<CGColor?>)
		case shadowOffset(Dynamic<CGSize>)
		case shadowOpacity(Dynamic<Float>)
		case shadowPath(Dynamic<CGPath?>)
		case shadowRadius(Dynamic<CGFloat>)
		case shouldRasterize(Dynamic<Bool>)
		case style(Dynamic<[AnyHashable: Any]>)
		case sublayerTransform(Dynamic<CATransform3D>)
		case transform(Dynamic<CATransform3D>)
		case zPosition(Dynamic<CGFloat>)
		case mask(Dynamic<LayerConvertible?>)
		case sublayers(Dynamic<[LayerConvertible]>)
		
		#if os(macOS)
			case autoresizingMask(Dynamic<CAAutoresizingMask>)
			case backgroundFilters(Dynamic<[CIFilter]?>)
			case compositingFilter(Dynamic<CIFilter?>)
			case filters(Dynamic<[CIFilter]?>)
		#else
			@available(*, unavailable)
			case autoresizingMask(())
			@available(*, unavailable)
			case backgroundFilters(())
			@available(*, unavailable)
			case compositingFilter(())
			@available(*, unavailable)
			case filters(())
		#endif
		
		//	2. Signal bindings are performed on the object after construction.
		case addAnimation(Signal<AnimationForKey>)
		case needsDisplay(Signal<Void>)
		case needsDisplayInRect(Signal<CGRect>)
		case removeAllAnimations(Signal<String>)
		case removeAnimationForKey(Signal<String>)
		case scrollRectToVisible(Signal<CGRect>)
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: StoragePreparer {
		public typealias EnclosingBinder = BackingLayer
		public var linkedPreparer = EnclosingBinder.Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .autoresizingMask(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.autoresizingMask = v }
				#else
					return nil
				#endif
			case .backgroundFilters(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.backgroundFilters = v }
				#else
					return nil
				#endif
			case .compositingFilter(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.compositingFilter = v }
				#else
					return nil
				#endif
			case .filters(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.filters = v }
				#else
					return nil
				#endif
			case .sublayers(let x):
				return x.apply(instance, storage) { i, s, v in
					i.sublayers = v.map { $0.cgLayer }
				}
			case .affineTransform(let x): return x.apply(instance, storage) { i, s, v in i.setAffineTransform(v) }
			case .anchorPoint(let x): return x.apply(instance, storage) { i, s, v in i.anchorPoint = v }
			case .anchorPointZ(let x): return x.apply(instance, storage) { i, s, v in i.anchorPointZ = v }
			case .backgroundColor(let x): return x.apply(instance, storage) { i, s, v in i.backgroundColor = v }
			case .borderColor(let x): return x.apply(instance, storage) { i, s, v in i.borderColor = v }
			case .borderWidth(let x): return x.apply(instance, storage) { i, s, v in i.borderWidth = v }
			case .bounds(let x): return x.apply(instance, storage) { i, s, v in i.bounds = v }
			case .contents(let x): return x.apply(instance, storage) { i, s, v in i.contents = v }
			case .contentsCenter(let x): return x.apply(instance, storage) { i, s, v in i.contentsCenter = v }
			case .contentsGravity(let x): return x.apply(instance, storage) { i, s, v in i.contentsGravity = v }
			case .contentsRect(let x): return x.apply(instance, storage) { i, s, v in i.contentsRect = v }
			case .contentsScale(let x): return x.apply(instance, storage) { i, s, v in i.contentsScale = v }
			case .cornerRadius(let x): return x.apply(instance, storage) { i, s, v in i.cornerRadius = v }
			case .isDoubleSided(let x): return x.apply(instance, storage) { i, s, v in i.isDoubleSided = v }
			case .drawsAsynchronously(let x): return x.apply(instance, storage) { i, s, v in i.drawsAsynchronously = v }
			case .edgeAntialiasingMask(let x): return x.apply(instance, storage) { i, s, v in i.edgeAntialiasingMask = v }
			case .frame(let x): return x.apply(instance, storage) { i, s, v in i.frame = v }
			case .isGeometryFlipped(let x): return x.apply(instance, storage) { i, s, v in i.isGeometryFlipped = v }
			case .isHidden(let x): return x.apply(instance, storage) { i, s, v in i.isHidden = v }
			case .magnificationFilter(let x): return x.apply(instance, storage) { i, s, v in i.magnificationFilter = v }
			case .masksToBounds(let x): return x.apply(instance, storage) { i, s, v in i.masksToBounds = v }
			case .minificationFilter(let x): return x.apply(instance, storage) { i, s, v in i.minificationFilter = v }
			case .minificationFilterBias(let x): return x.apply(instance, storage) { i, s, v in i.minificationFilterBias = v }
			case .name(let x): return x.apply(instance, storage) { i, s, v in i.name = v }
			case .needsDisplayOnBoundsChange(let x): return x.apply(instance, storage) { i, s, v in i.needsDisplayOnBoundsChange = v }
			case .opacity(let x): return x.apply(instance, storage) { i, s, v in i.opacity = v }
			case .isOpaque(let x): return x.apply(instance, storage) { i, s, v in i.isOpaque = v }
			case .position(let x): return x.apply(instance, storage) { i, s, v in i.position = v }
			case .rasterizationScale(let x): return x.apply(instance, storage) { i, s, v in i.rasterizationScale = v }
			case .shadowColor(let x): return x.apply(instance, storage) { i, s, v in i.shadowColor = v }
			case .shadowOffset(let x): return x.apply(instance, storage) { i, s, v in i.shadowOffset = v }
			case .shadowOpacity(let x): return x.apply(instance, storage) { i, s, v in i.shadowOpacity = v }
			case .shadowPath(let x): return x.apply(instance, storage) { i, s, v in i.shadowPath = v }
			case .shadowRadius(let x): return x.apply(instance, storage) { i, s, v in i.shadowRadius = v }
			case .shouldRasterize(let x): return x.apply(instance, storage) { i, s, v in i.shouldRasterize = v }
			case .style(let x): return x.apply(instance, storage) { i, s, v in i.style = v }
			case .sublayerTransform(let x): return x.apply(instance, storage) { i, s, v in i.sublayerTransform = v }
			case .transform(let x): return x.apply(instance, storage) { i, s, v in i.transform = v }
			case .zPosition(let x): return x.apply(instance, storage) { i, s, v in i.zPosition = v }
			case .addAnimation(let x): return x.apply(instance, storage) { i, s, v in i.add(v.animation, forKey: v.key) }
			case .needsDisplay(let x): return x.apply(instance, storage) { i, s, v in i.setNeedsDisplay() }
			case .needsDisplayInRect(let x): return x.apply(instance, storage) { i, s, v in i.setNeedsDisplay(v) }
			case .removeAllAnimations(let x): return x.apply(instance, storage) { i, s, v in i.removeAllAnimations() }
			case .removeAnimationForKey(let x): return x.apply(instance, storage) { i, s, v in i.removeAnimation(forKey: v) }
			case .scrollRectToVisible(let x): return x.apply(instance, storage) { i, s, v in i.scrollRectToVisible(v) }
			case .actions(let x):
				return x.apply(instance, storage) { i, s, v in
					var actions = i.actions ?? [String: CAAction]()
					for (key, input) in v {
						if let i = input {
							actions[key] = storage
							storage.layerActions[key] = i
						} else {
							actions[key] = NSNull()
							storage.layerActions.removeValue(forKey: key)
						}
					}
					i.actions = actions
				}
			case .mask(let x):
				return x.apply(instance, storage) { i, s, v in
					i.mask = v?.cgLayer
				}
			case .inheritedBinding(let s):
				return linkedPreparer.applyBinding(s, instance: (), storage: ())
			}
		}
	}
	
	open class Storage: ObjectBinderStorage, CAAction {
		open override var inUse: Bool {
			return super.inUse || !layerActions.isEmpty
		}
		
		// LayerBinderStorage implementation
		open var layerActions = [String: SignalInput<[AnyHashable: Any]?>]()
		@objc open func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable: Any]?) {
			_ = layerActions[event]?.send(value: dict)
		}
	}
}

extension BindingName where Binding: BackingLayerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.$1(v)) }) }
	public static var affineTransform: BindingName<Dynamic<CGAffineTransform>, Binding> { return BindingName<Dynamic<CGAffineTransform>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.affineTransform(v)) }) }
	public static var anchorPoint: BindingName<Dynamic<CGPoint>, Binding> { return BindingName<Dynamic<CGPoint>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.anchorPoint(v)) }) }
	public static var anchorPointZ: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.anchorPointZ(v)) }) }
	public static var actions: BindingName<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>, Binding> { return BindingName<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.actions(v)) }) }
	public static var backgroundColor: BindingName<Dynamic<CGColor?>, Binding> { return BindingName<Dynamic<CGColor?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.backgroundColor(v)) }) }
	public static var borderColor: BindingName<Dynamic<CGColor?>, Binding> { return BindingName<Dynamic<CGColor?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.borderColor(v)) }) }
	public static var borderWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.borderWidth(v)) }) }
	public static var bounds: BindingName<Dynamic<CGRect>, Binding> { return BindingName<Dynamic<CGRect>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.bounds(v)) }) }
	public static var contents: BindingName<Dynamic<Any?>, Binding> { return BindingName<Dynamic<Any?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.contents(v)) }) }
	public static var contentsCenter: BindingName<Dynamic<CGRect>, Binding> { return BindingName<Dynamic<CGRect>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.contentsCenter(v)) }) }
	public static var contentsGravity: BindingName<Dynamic<CALayerContentsGravity>, Binding> { return BindingName<Dynamic<CALayerContentsGravity>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.contentsGravity(v)) }) }
	public static var contentsRect: BindingName<Dynamic<CGRect>, Binding> { return BindingName<Dynamic<CGRect>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.contentsRect(v)) }) }
	public static var contentsScale: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.contentsScale(v)) }) }
	public static var cornerRadius: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.cornerRadius(v)) }) }
	public static var isDoubleSided: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.isDoubleSided(v)) }) }
	public static var drawsAsynchronously: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.drawsAsynchronously(v)) }) }
	public static var edgeAntialiasingMask: BindingName<Dynamic<CAEdgeAntialiasingMask>, Binding> { return BindingName<Dynamic<CAEdgeAntialiasingMask>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.edgeAntialiasingMask(v)) }) }
	public static var frame: BindingName<Dynamic<CGRect>, Binding> { return BindingName<Dynamic<CGRect>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.frame(v)) }) }
	public static var isGeometryFlipped: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.isGeometryFlipped(v)) }) }
	public static var isHidden: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.isHidden(v)) }) }
	public static var magnificationFilter: BindingName<Dynamic<CALayerContentsFilter>, Binding> { return BindingName<Dynamic<CALayerContentsFilter>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.magnificationFilter(v)) }) }
	public static var masksToBounds: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.masksToBounds(v)) }) }
	public static var minificationFilter: BindingName<Dynamic<CALayerContentsFilter>, Binding> { return BindingName<Dynamic<CALayerContentsFilter>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.minificationFilter(v)) }) }
	public static var minificationFilterBias: BindingName<Dynamic<Float>, Binding> { return BindingName<Dynamic<Float>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.minificationFilterBias(v)) }) }
	public static var name: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.name(v)) }) }
	public static var needsDisplayOnBoundsChange: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.needsDisplayOnBoundsChange(v)) }) }
	public static var opacity: BindingName<Dynamic<Float>, Binding> { return BindingName<Dynamic<Float>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.opacity(v)) }) }
	public static var isOpaque: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.isOpaque(v)) }) }
	public static var position: BindingName<Dynamic<CGPoint>, Binding> { return BindingName<Dynamic<CGPoint>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.position(v)) }) }
	public static var rasterizationScale: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.rasterizationScale(v)) }) }
	public static var shadowColor: BindingName<Dynamic<CGColor?>, Binding> { return BindingName<Dynamic<CGColor?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.shadowColor(v)) }) }
	public static var shadowOffset: BindingName<Dynamic<CGSize>, Binding> { return BindingName<Dynamic<CGSize>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.shadowOffset(v)) }) }
	public static var shadowOpacity: BindingName<Dynamic<Float>, Binding> { return BindingName<Dynamic<Float>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.shadowOpacity(v)) }) }
	public static var shadowPath: BindingName<Dynamic<CGPath?>, Binding> { return BindingName<Dynamic<CGPath?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.shadowPath(v)) }) }
	public static var shadowRadius: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.shadowRadius(v)) }) }
	public static var shouldRasterize: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.shouldRasterize(v)) }) }
	public static var style: BindingName<Dynamic<[AnyHashable: Any]>, Binding> { return BindingName<Dynamic<[AnyHashable: Any]>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.style(v)) }) }
	public static var sublayerTransform: BindingName<Dynamic<CATransform3D>, Binding> { return BindingName<Dynamic<CATransform3D>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.sublayerTransform(v)) }) }
	public static var transform: BindingName<Dynamic<CATransform3D>, Binding> { return BindingName<Dynamic<CATransform3D>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.transform(v)) }) }
	public static var zPosition: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.zPosition(v)) }) }
	public static var mask: BindingName<Dynamic<LayerConvertible?>, Binding> { return BindingName<Dynamic<LayerConvertible?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.mask(v)) }) }
	public static var sublayers: BindingName<Dynamic<[LayerConvertible]>, Binding> { return BindingName<Dynamic<[LayerConvertible]>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.sublayers(v)) }) }
	#if os(macOS)
		public static var autoresizingMask: BindingName<Dynamic<CAAutoresizingMask>, Binding> { return BindingName<Dynamic<CAAutoresizingMask>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.autoresizingMask(v)) }) }
		public static var backgroundFilters: BindingName<Dynamic<[CIFilter]?>, Binding> { return BindingName<Dynamic<[CIFilter]?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.backgroundFilters(v)) }) }
		public static var compositingFilter: BindingName<Dynamic<CIFilter?>, Binding> { return BindingName<Dynamic<CIFilter?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.compositingFilter(v)) }) }
		public static var filters: BindingName<Dynamic<[CIFilter]?>, Binding> { return BindingName<Dynamic<[CIFilter]?>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.filters(v)) }) }
	#endif
	public static var addAnimation: BindingName<Signal<AnimationForKey>, Binding> { return BindingName<Signal<AnimationForKey>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.addAnimation(v)) }) }
	public static var needsDisplay: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.needsDisplay(v)) }) }
	public static var needsDisplayInRect: BindingName<Signal<CGRect>, Binding> { return BindingName<Signal<CGRect>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.needsDisplayInRect(v)) }) }
	public static var removeAllAnimations: BindingName<Signal<String>, Binding> { return BindingName<Signal<String>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.removeAllAnimations(v)) }) }
	public static var removeAnimationForKey: BindingName<Signal<String>, Binding> { return BindingName<Signal<String>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.removeAnimationForKey(v)) }) }
	public static var scrollRectToVisible: BindingName<Signal<CGRect>, Binding> { return BindingName<Signal<CGRect>, Binding>({ v in .backingLayerBinding(BackingLayer.Binding.scrollRectToVisible(v)) }) }
}

public protocol BackingLayerBinding: BaseBinding {
	static func backingLayerBinding(_ binding: BackingLayer.Binding) -> Self
}

extension BackingLayerBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return backingLayerBinding(.inheritedBinding(binding))
	}
}

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
		return AnimationForKey(animation: t)
	}
	
	public enum Direction {
		case left
		case right
		case top
		case bottom
		
		func transition(ofType: CATransitionType) -> AnimationForKey {
			let t = CATransition()
			t.type = ofType
			switch self {
			case .left: t.subtype = CATransitionSubtype.fromLeft
			case .right: t.subtype = CATransitionSubtype.fromRight
			case .top: t.subtype = CATransitionSubtype.fromTop
			case .bottom: t.subtype = CATransitionSubtype.fromBottom
			}
			return AnimationForKey(animation: t)
		}
	}
	
	public static func moveIn(from: Direction) -> AnimationForKey {
		return from.transition(ofType: CATransitionType.moveIn)
	}
	
	public static func push(from: Direction) -> AnimationForKey {
		return from.transition(ofType: CATransitionType.push)
	}
	
	public static func reveal(from: Direction) -> AnimationForKey {
		return from.transition(ofType: CATransitionType.reveal)
	}
}
