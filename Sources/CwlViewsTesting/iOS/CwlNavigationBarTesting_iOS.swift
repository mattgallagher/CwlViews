//
//  CwlNavigationBar_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/15.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

#if os(iOS)

extension BindingParser where Downcast: NavigationBarBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, NavigationBar.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asNavigationBarBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .backgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var backIndicatorImage: BindingParser<Dynamic<UIImage?>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .backIndicatorImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var backIndicatorTransitionMaskImage: BindingParser<Dynamic<UIImage?>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .backIndicatorTransitionMaskImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .barStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var barTintColor: BindingParser<Dynamic<UIColor?>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .barTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .isTranslucent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var items: BindingParser<Dynamic<StackMutation<NavigationItemConvertible>>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .items(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var shadowImage: BindingParser<Dynamic<UIImage?>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .shadowImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var tintColor: BindingParser<Dynamic<UIColor?>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var titleTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .titleTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var titleVerticalPositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, NavigationBar.Binding, Downcast> { return .init(extract: { if case .titleVerticalPositionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didPop: BindingParser<(UINavigationBar, UINavigationItem) -> Void, NavigationBar.Binding, Downcast> { return .init(extract: { if case .didPop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var didPush: BindingParser<(UINavigationBar, UINavigationItem) -> Void, NavigationBar.Binding, Downcast> { return .init(extract: { if case .didPush(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var position: BindingParser<(UIBarPositioning) -> UIBarPosition, NavigationBar.Binding, Downcast> { return .init(extract: { if case .position(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var shouldPop: BindingParser<(UINavigationBar, UINavigationItem) -> Bool, NavigationBar.Binding, Downcast> { return .init(extract: { if case .shouldPop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
	public static var shouldPush: BindingParser<(UINavigationBar, UINavigationItem) -> Bool, NavigationBar.Binding, Downcast> { return .init(extract: { if case .shouldPush(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationBarBinding() }) }
}

#endif
