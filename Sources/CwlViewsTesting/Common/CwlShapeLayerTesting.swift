//
//  CwlShapeLayer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 11/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

extension BindingParser where Downcast: ShapeLayerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asShapeLayerBinding() }) }

	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var fillColor: BindingParser<Dynamic<CGColor?>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .fillColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var fillRule: BindingParser<Dynamic<CAShapeLayerFillRule>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .fillRule(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var lineCap: BindingParser<Dynamic<CAShapeLayerLineCap>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .lineCap(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var lineDashPattern: BindingParser<Dynamic<[NSNumber]?>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .lineDashPattern(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var lineDashPhase: BindingParser<Dynamic<CGFloat>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .lineDashPhase(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var lineJoin: BindingParser<Dynamic<CAShapeLayerLineJoin>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .lineJoin(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var lineWidth: BindingParser<Dynamic<CGFloat>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .lineWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var miterLimit: BindingParser<Dynamic<CGFloat>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .miterLimit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var path: BindingParser<Dynamic<CGPath>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .path(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var strokeColor: BindingParser<Dynamic<CGColor?>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .strokeColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var strokeEnd: BindingParser<Dynamic<CGFloat>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .strokeEnd(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	public static var strokeStart: BindingParser<Dynamic<CGFloat>, ShapeLayer.Binding, Downcast> { return .init(extract: { if case .strokeStart(let x) = $0 { return x } else { return nil } }, upcast: { $0.asShapeLayerBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}
