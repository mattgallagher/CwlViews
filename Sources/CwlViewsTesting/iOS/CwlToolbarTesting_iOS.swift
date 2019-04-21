//
//  CwlToolbar_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)

extension BindingParser where Binding == Toolbar.Binding {
	// You can easily convert the `Binding` cases 'to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>> in if case .backgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, Binding> { return BindingParser<Dynamic<UIBarStyle>, Binding>(parse: { binding -> Optional<Dynamic<UIBarStyle>> in if case .barStyle(let x) = binding { return x } else { return nil } }) }
	public static var barTintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .barTintColor(let x) = binding { return x } else { return nil } }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isTranslucent(let x) = binding { return x } else { return nil } }) }
	public static var items: BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> in if case .items(let x) = binding { return x } else { return nil } }) }
	public static var shadowImage: BindingParser<Dynamic<ScopedValues<UIBarPosition, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIBarPosition, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIBarPosition, UIImage?>>> in if case .shadowImage(let x) = binding { return x } else { return nil } }) }
	public static var tintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .tintColor(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var position: BindingParser<(UIBarPositioning) -> UIBarPosition, Binding> { return BindingParser<(UIBarPositioning) -> UIBarPosition, Binding>(parse: { binding -> Optional<(UIBarPositioning) -> UIBarPosition> in if case .position(let x) = binding { return x } else { return nil } }) }
}

#endif
