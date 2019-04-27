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

extension BindingParser where Downcast: LayerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Layer.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asLayerBinding() }) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var actions: BindingParser<Dynamic<[String: SignalInput<[AnyHashable: Any]?>?]>, Layer.Binding, Downcast> { return .init(extract: { if case .actions(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var affineTransform: BindingParser<Dynamic<CGAffineTransform>, Layer.Binding, Downcast> { return .init(extract: { if case .affineTransform(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var anchorPoint: BindingParser<Dynamic<CGPoint>, Layer.Binding, Downcast> { return .init(extract: { if case .anchorPoint(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var anchorPointZ: BindingParser<Dynamic<CGFloat>, Layer.Binding, Downcast> { return .init(extract: { if case .anchorPointZ(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var backgroundColor: BindingParser<Dynamic<CGColor>, Layer.Binding, Downcast> { return .init(extract: { if case .backgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var borderColor: BindingParser<Dynamic<CGColor>, Layer.Binding, Downcast> { return .init(extract: { if case .borderColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var borderWidth: BindingParser<Dynamic<CGFloat>, Layer.Binding, Downcast> { return .init(extract: { if case .borderWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var bounds: BindingParser<Dynamic<CGRect>, Layer.Binding, Downcast> { return .init(extract: { if case .bounds(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var contents: BindingParser<Dynamic<Any?>, Layer.Binding, Downcast> { return .init(extract: { if case .contents(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var contentsCenter: BindingParser<Dynamic<CGRect>, Layer.Binding, Downcast> { return .init(extract: { if case .contentsCenter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var contentsGravity: BindingParser<Dynamic<CALayerContentsGravity>, Layer.Binding, Downcast> { return .init(extract: { if case .contentsGravity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var contentsRect: BindingParser<Dynamic<CGRect>, Layer.Binding, Downcast> { return .init(extract: { if case .contentsRect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var contentsScale: BindingParser<Dynamic<CGFloat>, Layer.Binding, Downcast> { return .init(extract: { if case .contentsScale(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var cornerRadius: BindingParser<Dynamic<CGFloat>, Layer.Binding, Downcast> { return .init(extract: { if case .cornerRadius(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var drawsAsynchronously: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .drawsAsynchronously(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var edgeAntialiasingMask: BindingParser<Dynamic<CAEdgeAntialiasingMask>, Layer.Binding, Downcast> { return .init(extract: { if case .edgeAntialiasingMask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var frame: BindingParser<Dynamic<CGRect>, Layer.Binding, Downcast> { return .init(extract: { if case .frame(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var isDoubleSided: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .isDoubleSided(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var isGeometryFlipped: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .isGeometryFlipped(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .isHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var isOpaque: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .isOpaque(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var magnificationFilter: BindingParser<Dynamic<CALayerContentsFilter>, Layer.Binding, Downcast> { return .init(extract: { if case .magnificationFilter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var mask: BindingParser<Dynamic<LayerConvertible?>, Layer.Binding, Downcast> { return .init(extract: { if case .mask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var masksToBounds: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .masksToBounds(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var minificationFilter: BindingParser<Dynamic<CALayerContentsFilter>, Layer.Binding, Downcast> { return .init(extract: { if case .minificationFilter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var minificationFilterBias: BindingParser<Dynamic<Float>, Layer.Binding, Downcast> { return .init(extract: { if case .minificationFilterBias(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var name: BindingParser<Dynamic<String>, Layer.Binding, Downcast> { return .init(extract: { if case .name(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var needsDisplayOnBoundsChange: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .needsDisplayOnBoundsChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var opacity: BindingParser<Dynamic<Float>, Layer.Binding, Downcast> { return .init(extract: { if case .opacity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var position: BindingParser<Dynamic<CGPoint>, Layer.Binding, Downcast> { return .init(extract: { if case .position(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var rasterizationScale: BindingParser<Dynamic<CGFloat>, Layer.Binding, Downcast> { return .init(extract: { if case .rasterizationScale(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var shadowColor: BindingParser<Dynamic<CGColor?>, Layer.Binding, Downcast> { return .init(extract: { if case .shadowColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var shadowOffset: BindingParser<Dynamic<CGSize>, Layer.Binding, Downcast> { return .init(extract: { if case .shadowOffset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var shadowOpacity: BindingParser<Dynamic<Float>, Layer.Binding, Downcast> { return .init(extract: { if case .shadowOpacity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var shadowPath: BindingParser<Dynamic<CGPath?>, Layer.Binding, Downcast> { return .init(extract: { if case .shadowPath(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var shadowRadius: BindingParser<Dynamic<CGFloat>, Layer.Binding, Downcast> { return .init(extract: { if case .shadowRadius(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var shouldRasterize: BindingParser<Dynamic<Bool>, Layer.Binding, Downcast> { return .init(extract: { if case .shouldRasterize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var style: BindingParser<Dynamic<[AnyHashable: Any]>, Layer.Binding, Downcast> { return .init(extract: { if case .style(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var sublayers: BindingParser<Dynamic<[LayerConvertible]>, Layer.Binding, Downcast> { return .init(extract: { if case .sublayers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var sublayerTransform: BindingParser<Dynamic<CATransform3D>, Layer.Binding, Downcast> { return .init(extract: { if case .sublayerTransform(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var transform: BindingParser<Dynamic<CATransform3D>, Layer.Binding, Downcast> { return .init(extract: { if case .transform(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var zPosition: BindingParser<Dynamic<CGFloat>, Layer.Binding, Downcast> { return .init(extract: { if case .zPosition(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var autoresizingMask: BindingParser<Dynamic<Layer.CAAutoresizingMask>, Layer.Binding, Downcast> { return .init(extract: { if case .autoresizingMask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var backgroundFilters: BindingParser<Dynamic<[Layer.CIFilter]?>, Layer.Binding, Downcast> { return .init(extract: { if case .backgroundFilters(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var compositingFilter: BindingParser<Dynamic<Layer.CIFilter?>, Layer.Binding, Downcast> { return .init(extract: { if case .compositingFilter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var constraints: BindingParser<Dynamic<[Layer.CAConstraint]>, Layer.Binding, Downcast> { return .init(extract: { if case .constraints(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var filters: BindingParser<Dynamic<[Layer.CIFilter]?>, Layer.Binding, Downcast> { return .init(extract: { if case .filters(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var addAnimation: BindingParser<Signal<AnimationForKey>, Layer.Binding, Downcast> { return .init(extract: { if case .addAnimation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var needsDisplay: BindingParser<Signal<Void>, Layer.Binding, Downcast> { return .init(extract: { if case .needsDisplay(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var needsDisplayInRect: BindingParser<Signal<CGRect>, Layer.Binding, Downcast> { return .init(extract: { if case .needsDisplayInRect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var removeAllAnimations: BindingParser<Signal<Void>, Layer.Binding, Downcast> { return .init(extract: { if case .removeAllAnimations(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var removeAnimationForKey: BindingParser<Signal<String>, Layer.Binding, Downcast> { return .init(extract: { if case .removeAnimationForKey(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var scrollRectToVisible: BindingParser<Signal<CGRect>, Layer.Binding, Downcast> { return .init(extract: { if case .scrollRectToVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var display: BindingParser<(CALayer) -> Void, Layer.Binding, Downcast> { return .init(extract: { if case .display(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var draw: BindingParser<(CALayer, CGContext) -> Void, Layer.Binding, Downcast> { return .init(extract: { if case .draw(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var layoutSublayers: BindingParser<(CALayer) -> Void, Layer.Binding, Downcast> { return .init(extract: { if case .layoutSublayers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
	public static var willDraw: BindingParser<(CALayer) -> Void, Layer.Binding, Downcast> { return .init(extract: { if case .willDraw(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLayerBinding() }) }
}
