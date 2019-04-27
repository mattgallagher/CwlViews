//
//  CwlToolbar_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)

extension BindingParser where Downcast: ToolbarBinding {
	// You can easily convert the `Binding` cases 'to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Toolbar.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asToolbarBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Toolbar.Binding, Downcast> { return .init(extract: { if case .backgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, Toolbar.Binding, Downcast> { return .init(extract: { if case .barStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var barTintColor: BindingParser<Dynamic<UIColor?>, Toolbar.Binding, Downcast> { return .init(extract: { if case .barTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, Toolbar.Binding, Downcast> { return .init(extract: { if case .isTranslucent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var items: BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Toolbar.Binding, Downcast> { return .init(extract: { if case .items(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var shadowImage: BindingParser<Dynamic<ScopedValues<UIBarPosition, UIImage?>>, Toolbar.Binding, Downcast> { return .init(extract: { if case .shadowImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var tintColor: BindingParser<Dynamic<UIColor?>, Toolbar.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var position: BindingParser<(UIBarPositioning) -> UIBarPosition, Toolbar.Binding, Downcast> { return .init(extract: { if case .position(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
}

#endif
