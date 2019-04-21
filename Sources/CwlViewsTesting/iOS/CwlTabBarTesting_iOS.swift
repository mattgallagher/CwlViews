//
//  CwlTabBar_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Binding: TabBarBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<$2, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<UIImage?>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UIImage?>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .backgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UIBarStyle>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UIBarStyle>> in if case .barStyle(let x) = binding { return x } else { return nil } }) }
	public static var barTintColor: BindingParser<Dynamic<UIColor>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UIColor>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UIColor>> in if case .barTintColor(let x) = binding { return x } else { return nil } }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<Bool>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isTranslucent(let x) = binding { return x } else { return nil } }) }
	public static var itemPositioning: BindingParser<Dynamic<UITabBar.ItemPositioning>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UITabBar.ItemPositioning>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UITabBar.ItemPositioning>> in if case .itemPositioning(let x) = binding { return x } else { return nil } }) }
	public static var items: BindingParser<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>> in if case .items(let x) = binding { return x } else { return nil } }) }
	public static var itemSpacing: BindingParser<Dynamic<CGFloat>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<CGFloat>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .itemSpacing(let x) = binding { return x } else { return nil } }) }
	public static var itemWidth: BindingParser<Dynamic<CGFloat>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<CGFloat>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .itemWidth(let x) = binding { return x } else { return nil } }) }
	public static var selectionIndicatorImage: BindingParser<Dynamic<UIImage?>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UIImage?>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .selectionIndicatorImage(let x) = binding { return x } else { return nil } }) }
	public static var shadowImage: BindingParser<Dynamic<UIImage?>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UIImage?>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .shadowImage(let x) = binding { return x } else { return nil } }) }
	public static var tintColor: BindingParser<Dynamic<UIColor>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UIColor>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UIColor>> in if case .tintColor(let x) = binding { return x } else { return nil } }) }
	public static var unselectedItemTintColor: BindingParser<Dynamic<UIColor>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<UIColor>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<UIColor>> in if case .unselectedItemTintColor(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var customizingItems: BindingParser<Signal<SetOrAnimate<[Binding.ItemIdentifierType]?>>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Signal<SetOrAnimate<[Binding.ItemIdentifierType]?>>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Signal<SetOrAnimate<[Binding.ItemIdentifierType]?>>> in if case .customizingItems(let x) = binding { return x } else { return nil } }) }
	public static var selectItem: BindingParser<Signal<Binding.ItemIdentifierType>, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<Signal<Binding.ItemIdentifierType>, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Signal<Binding.ItemIdentifierType>> in if case .selectItem(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didBeginCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType]) -> Void, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType]) -> Void, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType]) -> Void> in if case .didBeginCustomizing(let x) = binding { return x } else { return nil } }) }
	public static var didEndCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType], Bool) -> Void, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType], Bool) -> Void, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType], Bool) -> Void> in if case .didEndCustomizing(let x) = binding { return x } else { return nil } }) }
	public static var didSelectItem: BindingParser<(UITabBar, UITabBarItem, Binding.ItemIdentifierType) -> Void, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBar, UITabBarItem, Binding.ItemIdentifierType) -> Void, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBar, UITabBarItem, Binding.ItemIdentifierType) -> Void> in if case .didSelectItem(let x) = binding { return x } else { return nil } }) }
	public static var itemConstructor: BindingParser<(Binding.ItemIdentifierType) -> TabBarItemConvertible, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<(Binding.ItemIdentifierType) -> TabBarItemConvertible, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(Binding.ItemIdentifierType) -> TabBarItemConvertible> in if case .itemConstructor(let x) = binding { return x } else { return nil } }) }
	public static var willBeginCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType]) -> Void, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType]) -> Void, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType]) -> Void> in if case .willBeginCustomizing(let x) = binding { return x } else { return nil } }) }
	public static var willEndCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType], Bool) -> Void, TabBar<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType], Bool) -> Void, TabBar<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBar, [UITabBarItem], [Binding.ItemIdentifierType], Bool) -> Void> in if case .willEndCustomizing(let x) = binding { return x } else { return nil } }) }
}

#endif
