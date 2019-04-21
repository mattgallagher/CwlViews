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

extension BindingParser where Binding == Layer.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var actions: BindingParser<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>, Binding> { return BindingParser<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>, Binding>(parse: { binding -> Optional<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>> in if case .actions(let x) = binding { return x } else { return nil } }) }
	public static var affineTransform: BindingParser<Dynamic<CGAffineTransform>, Binding> { return BindingParser<Dynamic<CGAffineTransform>, Binding>(parse: { binding -> Optional<Dynamic<CGAffineTransform>> in if case .affineTransform(let x) = binding { return x } else { return nil } }) }
	public static var anchorPoint: BindingParser<Dynamic<CGPoint>, Binding> { return BindingParser<Dynamic<CGPoint>, Binding>(parse: { binding -> Optional<Dynamic<CGPoint>> in if case .anchorPoint(let x) = binding { return x } else { return nil } }) }
	public static var anchorPointZ: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .anchorPointZ(let x) = binding { return x } else { return nil } }) }
	public static var backgroundColor: BindingParser<Dynamic<CGColor>, Binding> { return BindingParser<Dynamic<CGColor>, Binding>(parse: { binding -> Optional<Dynamic<CGColor>> in if case .backgroundColor(let x) = binding { return x } else { return nil } }) }
	public static var borderColor: BindingParser<Dynamic<CGColor>, Binding> { return BindingParser<Dynamic<CGColor>, Binding>(parse: { binding -> Optional<Dynamic<CGColor>> in if case .borderColor(let x) = binding { return x } else { return nil } }) }
	public static var borderWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .borderWidth(let x) = binding { return x } else { return nil } }) }
	public static var bounds: BindingParser<Dynamic<CGRect>, Binding> { return BindingParser<Dynamic<CGRect>, Binding>(parse: { binding -> Optional<Dynamic<CGRect>> in if case .bounds(let x) = binding { return x } else { return nil } }) }
	public static var contents: BindingParser<Dynamic<Any?>, Binding> { return BindingParser<Dynamic<Any?>, Binding>(parse: { binding -> Optional<Dynamic<Any?>> in if case .contents(let x) = binding { return x } else { return nil } }) }
	public static var contentsCenter: BindingParser<Dynamic<CGRect>, Binding> { return BindingParser<Dynamic<CGRect>, Binding>(parse: { binding -> Optional<Dynamic<CGRect>> in if case .contentsCenter(let x) = binding { return x } else { return nil } }) }
	public static var contentsGravity: BindingParser<Dynamic<CALayerContentsGravity>, Binding> { return BindingParser<Dynamic<CALayerContentsGravity>, Binding>(parse: { binding -> Optional<Dynamic<CALayerContentsGravity>> in if case .contentsGravity(let x) = binding { return x } else { return nil } }) }
	public static var contentsRect: BindingParser<Dynamic<CGRect>, Binding> { return BindingParser<Dynamic<CGRect>, Binding>(parse: { binding -> Optional<Dynamic<CGRect>> in if case .contentsRect(let x) = binding { return x } else { return nil } }) }
	public static var contentsScale: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .contentsScale(let x) = binding { return x } else { return nil } }) }
	public static var cornerRadius: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .cornerRadius(let x) = binding { return x } else { return nil } }) }
	public static var drawsAsynchronously: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .drawsAsynchronously(let x) = binding { return x } else { return nil } }) }
	public static var edgeAntialiasingMask: BindingParser<Dynamic<CAEdgeAntialiasingMask>, Binding> { return BindingParser<Dynamic<CAEdgeAntialiasingMask>, Binding>(parse: { binding -> Optional<Dynamic<CAEdgeAntialiasingMask>> in if case .edgeAntialiasingMask(let x) = binding { return x } else { return nil } }) }
	public static var frame: BindingParser<Dynamic<CGRect>, Binding> { return BindingParser<Dynamic<CGRect>, Binding>(parse: { binding -> Optional<Dynamic<CGRect>> in if case .frame(let x) = binding { return x } else { return nil } }) }
	public static var isDoubleSided: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isDoubleSided(let x) = binding { return x } else { return nil } }) }
	public static var isGeometryFlipped: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isGeometryFlipped(let x) = binding { return x } else { return nil } }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isHidden(let x) = binding { return x } else { return nil } }) }
	public static var isOpaque: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isOpaque(let x) = binding { return x } else { return nil } }) }
	public static var magnificationFilter: BindingParser<Dynamic<CALayerContentsFilter>, Binding> { return BindingParser<Dynamic<CALayerContentsFilter>, Binding>(parse: { binding -> Optional<Dynamic<CALayerContentsFilter>> in if case .magnificationFilter(let x) = binding { return x } else { return nil } }) }
	public static var mask: BindingParser<Dynamic<LayerConvertible?>, Binding> { return BindingParser<Dynamic<LayerConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<LayerConvertible?>> in if case .mask(let x) = binding { return x } else { return nil } }) }
	public static var masksToBounds: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .masksToBounds(let x) = binding { return x } else { return nil } }) }
	public static var minificationFilter: BindingParser<Dynamic<CALayerContentsFilter>, Binding> { return BindingParser<Dynamic<CALayerContentsFilter>, Binding>(parse: { binding -> Optional<Dynamic<CALayerContentsFilter>> in if case .minificationFilter(let x) = binding { return x } else { return nil } }) }
	public static var minificationFilterBias: BindingParser<Dynamic<Float>, Binding> { return BindingParser<Dynamic<Float>, Binding>(parse: { binding -> Optional<Dynamic<Float>> in if case .minificationFilterBias(let x) = binding { return x } else { return nil } }) }
	public static var name: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .name(let x) = binding { return x } else { return nil } }) }
	public static var needsDisplayOnBoundsChange: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .needsDisplayOnBoundsChange(let x) = binding { return x } else { return nil } }) }
	public static var opacity: BindingParser<Dynamic<Float>, Binding> { return BindingParser<Dynamic<Float>, Binding>(parse: { binding -> Optional<Dynamic<Float>> in if case .opacity(let x) = binding { return x } else { return nil } }) }
	public static var position: BindingParser<Dynamic<CGPoint>, Binding> { return BindingParser<Dynamic<CGPoint>, Binding>(parse: { binding -> Optional<Dynamic<CGPoint>> in if case .position(let x) = binding { return x } else { return nil } }) }
	public static var rasterizationScale: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .rasterizationScale(let x) = binding { return x } else { return nil } }) }
	public static var shadowColor: BindingParser<Dynamic<CGColor?>, Binding> { return BindingParser<Dynamic<CGColor?>, Binding>(parse: { binding -> Optional<Dynamic<CGColor?>> in if case .shadowColor(let x) = binding { return x } else { return nil } }) }
	public static var shadowOffset: BindingParser<Dynamic<CGSize>, Binding> { return BindingParser<Dynamic<CGSize>, Binding>(parse: { binding -> Optional<Dynamic<CGSize>> in if case .shadowOffset(let x) = binding { return x } else { return nil } }) }
	public static var shadowOpacity: BindingParser<Dynamic<Float>, Binding> { return BindingParser<Dynamic<Float>, Binding>(parse: { binding -> Optional<Dynamic<Float>> in if case .shadowOpacity(let x) = binding { return x } else { return nil } }) }
	public static var shadowPath: BindingParser<Dynamic<CGPath?>, Binding> { return BindingParser<Dynamic<CGPath?>, Binding>(parse: { binding -> Optional<Dynamic<CGPath?>> in if case .shadowPath(let x) = binding { return x } else { return nil } }) }
	public static var shadowRadius: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .shadowRadius(let x) = binding { return x } else { return nil } }) }
	public static var shouldRasterize: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .shouldRasterize(let x) = binding { return x } else { return nil } }) }
	public static var style: BindingParser<Dynamic<[AnyHashable: Any]>, Binding> { return BindingParser<Dynamic<[AnyHashable: Any]>, Binding>(parse: { binding -> Optional<Dynamic<[AnyHashable: Any]>> in if case .style(let x) = binding { return x } else { return nil } }) }
	public static var sublayers: BindingParser<Dynamic<[LayerConvertible]>, Binding> { return BindingParser<Dynamic<[LayerConvertible]>, Binding>(parse: { binding -> Optional<Dynamic<[LayerConvertible]>> in if case .sublayers(let x) = binding { return x } else { return nil } }) }
	public static var sublayerTransform: BindingParser<Dynamic<CATransform3D>, Binding> { return BindingParser<Dynamic<CATransform3D>, Binding>(parse: { binding -> Optional<Dynamic<CATransform3D>> in if case .sublayerTransform(let x) = binding { return x } else { return nil } }) }
	public static var transform: BindingParser<Dynamic<CATransform3D>, Binding> { return BindingParser<Dynamic<CATransform3D>, Binding>(parse: { binding -> Optional<Dynamic<CATransform3D>> in if case .transform(let x) = binding { return x } else { return nil } }) }
	public static var zPosition: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .zPosition(let x) = binding { return x } else { return nil } }) }

	@available(macOS 10.13, *) @available(iOS, unavailable) public static var autoresizingMask: BindingParser<Dynamic<Layer.CAAutoresizingMask>, Binding> { return BindingParser<Dynamic<Layer.CAAutoresizingMask>, Binding>(parse: { binding -> Optional<Dynamic<Layer.CAAutoresizingMask>> in if case .autoresizingMask(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var backgroundFilters: BindingParser<Dynamic<[Layer.CIFilter]?>, Binding> { return BindingParser<Dynamic<[Layer.CIFilter]?>, Binding>(parse: { binding -> Optional<Dynamic<[Layer.CIFilter]?>> in if case .backgroundFilters(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var compositingFilter: BindingParser<Dynamic<Layer.CIFilter?>, Binding> { return BindingParser<Dynamic<Layer.CIFilter?>, Binding>(parse: { binding -> Optional<Dynamic<Layer.CIFilter?>> in if case .compositingFilter(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var constraints: BindingParser<Dynamic<[Layer.CAConstraint]>, Binding> { return BindingParser<Dynamic<[Layer.CAConstraint]>, Binding>(parse: { binding -> Optional<Dynamic<[Layer.CAConstraint]>> in if case .constraints(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var filters: BindingParser<Dynamic<[Layer.CIFilter]?>, Binding> { return BindingParser<Dynamic<[Layer.CIFilter]?>, Binding>(parse: { binding -> Optional<Dynamic<[Layer.CIFilter]?>> in if case .filters(let x) = binding { return x } else { return nil } }) }

	//	2. Signal bindings are performed on the object after construction.
	public static var addAnimation: BindingParser<Signal<AnimationForKey>, Binding> { return BindingParser<Signal<AnimationForKey>, Binding>(parse: { binding -> Optional<Signal<AnimationForKey>> in if case .addAnimation(let x) = binding { return x } else { return nil } }) }
	public static var needsDisplay: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .needsDisplay(let x) = binding { return x } else { return nil } }) }
	public static var needsDisplayInRect: BindingParser<Signal<CGRect>, Binding> { return BindingParser<Signal<CGRect>, Binding>(parse: { binding -> Optional<Signal<CGRect>> in if case .needsDisplayInRect(let x) = binding { return x } else { return nil } }) }
	public static var removeAllAnimations: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .removeAllAnimations(let x) = binding { return x } else { return nil } }) }
	public static var removeAnimationForKey: BindingParser<Signal<String>, Binding> { return BindingParser<Signal<String>, Binding>(parse: { binding -> Optional<Signal<String>> in if case .removeAnimationForKey(let x) = binding { return x } else { return nil } }) }
	public static var scrollRectToVisible: BindingParser<Signal<CGRect>, Binding> { return BindingParser<Signal<CGRect>, Binding>(parse: { binding -> Optional<Signal<CGRect>> in if case .scrollRectToVisible(let x) = binding { return x } else { return nil } }) }

	//	3. Action bindings are triggered by the object after construction.

	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var display: BindingParser<(CALayer) -> Void, Binding> { return BindingParser<(CALayer) -> Void, Binding>(parse: { binding -> Optional<(CALayer) -> Void> in if case .display(let x) = binding { return x } else { return nil } }) }
	public static var draw: BindingParser<(CALayer, CGContext) -> Void, Binding> { return BindingParser<(CALayer, CGContext) -> Void, Binding>(parse: { binding -> Optional<(CALayer, CGContext) -> Void> in if case .draw(let x) = binding { return x } else { return nil } }) }
	public static var layoutSublayers: BindingParser<(CALayer) -> Void, Binding> { return BindingParser<(CALayer) -> Void, Binding>(parse: { binding -> Optional<(CALayer) -> Void> in if case .layoutSublayers(let x) = binding { return x } else { return nil } }) }
	public static var willDraw: BindingParser<(CALayer) -> Void, Binding> { return BindingParser<(CALayer) -> Void, Binding>(parse: { binding -> Optional<(CALayer) -> Void> in if case .willDraw(let x) = binding { return x } else { return nil } }) }
}
