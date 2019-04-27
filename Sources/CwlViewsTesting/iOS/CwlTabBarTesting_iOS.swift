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

extension BindingParser where Downcast: TabBarBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTabBarBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<UIImage?>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .backgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .barStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var barTintColor: BindingParser<Dynamic<UIColor>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .barTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .isTranslucent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var itemPositioning: BindingParser<Dynamic<UITabBar.ItemPositioning>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .itemPositioning(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var items: BindingParser<Dynamic<SetOrAnimate<[Downcast.ItemIdentifierType]>>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .items(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var itemSpacing: BindingParser<Dynamic<CGFloat>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .itemSpacing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var itemWidth: BindingParser<Dynamic<CGFloat>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .itemWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var selectionIndicatorImage: BindingParser<Dynamic<UIImage?>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectionIndicatorImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var shadowImage: BindingParser<Dynamic<UIImage?>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .shadowImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var tintColor: BindingParser<Dynamic<UIColor>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var unselectedItemTintColor: BindingParser<Dynamic<UIColor>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .unselectedItemTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var customizingItems: BindingParser<Signal<SetOrAnimate<[Downcast.ItemIdentifierType]?>>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .customizingItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var selectItem: BindingParser<Signal<Downcast.ItemIdentifierType>, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didBeginCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Downcast.ItemIdentifierType]) -> Void, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .didBeginCustomizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var didEndCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Downcast.ItemIdentifierType], Bool) -> Void, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .didEndCustomizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var didSelectItem: BindingParser<(UITabBar, UITabBarItem, Downcast.ItemIdentifierType) -> Void, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .didSelectItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var itemConstructor: BindingParser<(Downcast.ItemIdentifierType) -> TabBarItemConvertible, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .itemConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var willBeginCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Downcast.ItemIdentifierType]) -> Void, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .willBeginCustomizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
	public static var willEndCustomizing: BindingParser<(UITabBar, [UITabBarItem], [Downcast.ItemIdentifierType], Bool) -> Void, TabBar<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .willEndCustomizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarBinding() }) }
}

#endif
