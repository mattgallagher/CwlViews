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

extension BindingParser where Binding == NavigationBar.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>> in if case .backgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var backIndicatorImage: BindingParser<Dynamic<UIImage?>, Binding> { return BindingParser<Dynamic<UIImage?>, Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .backIndicatorImage(let x) = binding { return x } else { return nil } }) }
	public static var backIndicatorTransitionMaskImage: BindingParser<Dynamic<UIImage?>, Binding> { return BindingParser<Dynamic<UIImage?>, Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .backIndicatorTransitionMaskImage(let x) = binding { return x } else { return nil } }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, Binding> { return BindingParser<Dynamic<UIBarStyle>, Binding>(parse: { binding -> Optional<Dynamic<UIBarStyle>> in if case .barStyle(let x) = binding { return x } else { return nil } }) }
	public static var barTintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .barTintColor(let x) = binding { return x } else { return nil } }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isTranslucent(let x) = binding { return x } else { return nil } }) }
	public static var items: BindingParser<Dynamic<StackMutation<NavigationItemConvertible>>, Binding> { return BindingParser<Dynamic<StackMutation<NavigationItemConvertible>>, Binding>(parse: { binding -> Optional<Dynamic<StackMutation<NavigationItemConvertible>>> in if case .items(let x) = binding { return x } else { return nil } }) }
	public static var shadowImage: BindingParser<Dynamic<UIImage?>, Binding> { return BindingParser<Dynamic<UIImage?>, Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .shadowImage(let x) = binding { return x } else { return nil } }) }
	public static var tintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .tintColor(let x) = binding { return x } else { return nil } }) }
	public static var titleTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding>(parse: { binding -> Optional<Dynamic<[NSAttributedString.Key: Any]>> in if case .titleTextAttributes(let x) = binding { return x } else { return nil } }) }
	public static var titleVerticalPositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>> in if case .titleVerticalPositionAdjustment(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didPop: BindingParser<(UINavigationBar, UINavigationItem) -> Void, Binding> { return BindingParser<(UINavigationBar, UINavigationItem) -> Void, Binding>(parse: { binding -> Optional<(UINavigationBar, UINavigationItem) -> Void> in if case .didPop(let x) = binding { return x } else { return nil } }) }
	public static var didPush: BindingParser<(UINavigationBar, UINavigationItem) -> Void, Binding> { return BindingParser<(UINavigationBar, UINavigationItem) -> Void, Binding>(parse: { binding -> Optional<(UINavigationBar, UINavigationItem) -> Void> in if case .didPush(let x) = binding { return x } else { return nil } }) }
	public static var position: BindingParser<(UIBarPositioning) -> UIBarPosition, Binding> { return BindingParser<(UIBarPositioning) -> UIBarPosition, Binding>(parse: { binding -> Optional<(UIBarPositioning) -> UIBarPosition> in if case .position(let x) = binding { return x } else { return nil } }) }
	public static var shouldPop: BindingParser<(UINavigationBar, UINavigationItem) -> Bool, Binding> { return BindingParser<(UINavigationBar, UINavigationItem) -> Bool, Binding>(parse: { binding -> Optional<(UINavigationBar, UINavigationItem) -> Bool> in if case .shouldPop(let x) = binding { return x } else { return nil } }) }
	public static var shouldPush: BindingParser<(UINavigationBar, UINavigationItem) -> Bool, Binding> { return BindingParser<(UINavigationBar, UINavigationItem) -> Bool, Binding>(parse: { binding -> Optional<(UINavigationBar, UINavigationItem) -> Bool> in if case .shouldPush(let x) = binding { return x } else { return nil } }) }
}

#endif
