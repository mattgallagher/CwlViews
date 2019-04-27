//
//  CwlTabBarController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/03/08.
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

// MARK: - Binder Part 1: Binder
extension BindingParser where Downcast: TabBarControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTabBarControllerBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var tabBar: BindingParser<Constant<TabBar<Downcast.ItemIdentifierType>>, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .tabBar(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var customizableItems: BindingParser<Dynamic<Set<Downcast.ItemIdentifierType>>, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .customizableItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var items: BindingParser<Dynamic<SetOrAnimate<[Downcast.ItemIdentifierType]>>, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .items(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var selectItem: BindingParser<Signal<Downcast.ItemIdentifierType>, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var animationControllerForTransition: BindingParser<(UITabBarController, UIViewController, Downcast.ItemIdentifierType, UIViewController, Downcast.ItemIdentifierType) -> UIViewControllerAnimatedTransitioning?, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .animationControllerForTransition(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var didEndCustomizing: BindingParser<(UITabBarController, [UIViewController], [Downcast.ItemIdentifierType], Bool) -> Void, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .didEndCustomizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var didSelect: BindingParser<(UITabBarController, UIViewController, Downcast.ItemIdentifierType) -> Void, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .didSelect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var interactionControllerForAnimation: BindingParser<(UITabBarController, UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .interactionControllerForAnimation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var preferredInterfaceOrientationForPresentation: BindingParser<(UITabBarController) -> UIInterfaceOrientation, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .preferredInterfaceOrientationForPresentation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var shouldSelect: BindingParser<(UITabBarController, UIViewController, Downcast.ItemIdentifierType) -> Bool, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .shouldSelect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var supportedInterfaceOrientations: BindingParser<(UITabBarController) -> UIInterfaceOrientationMask, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .supportedInterfaceOrientations(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var tabConstructor: BindingParser<(Downcast.ItemIdentifierType) -> ViewControllerConvertible, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .tabConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var willBeginCustomizing: BindingParser<(UITabBarController, [UIViewController], [Downcast.ItemIdentifierType]) -> Void, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .willBeginCustomizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
	public static var willEndCustomizing: BindingParser<(UITabBarController, [UIViewController], [Downcast.ItemIdentifierType], Bool) -> Void, TabBarController<Downcast.ItemIdentifierType>.Binding, Downcast> { return .init(extract: { if case .willEndCustomizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarControllerBinding() }) }
}

#endif
