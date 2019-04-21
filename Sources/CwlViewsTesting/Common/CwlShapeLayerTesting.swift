//
//  CwlShapeLayer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 11/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

extension BindingParser where Binding == ShapeLayer.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }

	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var fillColor: BindingParser<Dynamic<CGColor?>, Binding> { return BindingParser<Dynamic<CGColor?>, Binding>(parse: { binding -> Optional<Dynamic<CGColor?>> in if case .fillColor(let x) = binding { return x } else { return nil } }) }
	public static var fillRule: BindingParser<Dynamic<CAShapeLayerFillRule>, Binding> { return BindingParser<Dynamic<CAShapeLayerFillRule>, Binding>(parse: { binding -> Optional<Dynamic<CAShapeLayerFillRule>> in if case .fillRule(let x) = binding { return x } else { return nil } }) }
	public static var lineCap: BindingParser<Dynamic<CAShapeLayerLineCap>, Binding> { return BindingParser<Dynamic<CAShapeLayerLineCap>, Binding>(parse: { binding -> Optional<Dynamic<CAShapeLayerLineCap>> in if case .lineCap(let x) = binding { return x } else { return nil } }) }
	public static var lineDashPattern: BindingParser<Dynamic<[NSNumber]?>, Binding> { return BindingParser<Dynamic<[NSNumber]?>, Binding>(parse: { binding -> Optional<Dynamic<[NSNumber]?>> in if case .lineDashPattern(let x) = binding { return x } else { return nil } }) }
	public static var lineDashPhase: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .lineDashPhase(let x) = binding { return x } else { return nil } }) }
	public static var lineJoin: BindingParser<Dynamic<CAShapeLayerLineJoin>, Binding> { return BindingParser<Dynamic<CAShapeLayerLineJoin>, Binding>(parse: { binding -> Optional<Dynamic<CAShapeLayerLineJoin>> in if case .lineJoin(let x) = binding { return x } else { return nil } }) }
	public static var lineWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .lineWidth(let x) = binding { return x } else { return nil } }) }
	public static var miterLimit: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .miterLimit(let x) = binding { return x } else { return nil } }) }
	public static var path: BindingParser<Dynamic<CGPath>, Binding> { return BindingParser<Dynamic<CGPath>, Binding>(parse: { binding -> Optional<Dynamic<CGPath>> in if case .path(let x) = binding { return x } else { return nil } }) }
	public static var strokeColor: BindingParser<Dynamic<CGColor?>, Binding> { return BindingParser<Dynamic<CGColor?>, Binding>(parse: { binding -> Optional<Dynamic<CGColor?>> in if case .strokeColor(let x) = binding { return x } else { return nil } }) }
	public static var strokeEnd: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .strokeEnd(let x) = binding { return x } else { return nil } }) }
	public static var strokeStart: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .strokeStart(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}
