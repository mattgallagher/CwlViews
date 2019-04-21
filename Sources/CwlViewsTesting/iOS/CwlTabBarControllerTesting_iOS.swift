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
extension BindingParser where Binding: TabBarControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<$2, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var tabBar: BindingParser<Constant<TabBar<Binding.ItemIdentifierType>>, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<Constant<TabBar<Binding.ItemIdentifierType>>, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Constant<TabBar<Binding.ItemIdentifierType>>> in if case .tabBar(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var customizableItems: BindingParser<Dynamic<Set<Binding.ItemIdentifierType>>, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<Set<Binding.ItemIdentifierType>>, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<Set<Binding.ItemIdentifierType>>> in if case .customizableItems(let x) = binding { return x } else { return nil } }) }
	public static var items: BindingParser<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>> in if case .items(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var selectItem: BindingParser<Signal<Binding.ItemIdentifierType>, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<Signal<Binding.ItemIdentifierType>, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<Signal<Binding.ItemIdentifierType>> in if case .selectItem(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var animationControllerForTransition: BindingParser<(UITabBarController, UIViewController, Binding.ItemIdentifierType, UIViewController, Binding.ItemIdentifierType) -> UIViewControllerAnimatedTransitioning?, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController, UIViewController, Binding.ItemIdentifierType, UIViewController, Binding.ItemIdentifierType) -> UIViewControllerAnimatedTransitioning?, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController, UIViewController, Binding.ItemIdentifierType, UIViewController, Binding.ItemIdentifierType) -> UIViewControllerAnimatedTransitioning?> in if case .animationControllerForTransition(let x) = binding { return x } else { return nil } }) }
	public static var didEndCustomizing: BindingParser<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void> in if case .didEndCustomizing(let x) = binding { return x } else { return nil } }) }
	public static var didSelect: BindingParser<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Void> in if case .didSelect(let x) = binding { return x } else { return nil } }) }
	public static var interactionControllerForAnimation: BindingParser<(UITabBarController, UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController, UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController, UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?> in if case .interactionControllerForAnimation(let x) = binding { return x } else { return nil } }) }
	public static var preferredInterfaceOrientationForPresentation: BindingParser<(UITabBarController) -> UIInterfaceOrientation, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController) -> UIInterfaceOrientation, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController) -> UIInterfaceOrientation> in if case .preferredInterfaceOrientationForPresentation(let x) = binding { return x } else { return nil } }) }
	public static var shouldSelect: BindingParser<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Bool, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Bool, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Bool> in if case .shouldSelect(let x) = binding { return x } else { return nil } }) }
	public static var supportedInterfaceOrientations: BindingParser<(UITabBarController) -> UIInterfaceOrientationMask, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController) -> UIInterfaceOrientationMask, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController) -> UIInterfaceOrientationMask> in if case .supportedInterfaceOrientations(let x) = binding { return x } else { return nil } }) }
	public static var tabConstructor: BindingParser<(Binding.ItemIdentifierType) -> ViewControllerConvertible, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(Binding.ItemIdentifierType) -> ViewControllerConvertible, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(Binding.ItemIdentifierType) -> ViewControllerConvertible> in if case .tabConstructor(let x) = binding { return x } else { return nil } }) }
	public static var willBeginCustomizing: BindingParser<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType]) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType]) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType]) -> Void> in if case .willBeginCustomizing(let x) = binding { return x } else { return nil } }) }
	public static var willEndCustomizing: BindingParser<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding> { return BindingParser<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void, TabBarController<Binding.ItemIdentifierType>.Binding>(parse: { binding -> Optional<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void> in if case .willEndCustomizing(let x) = binding { return x } else { return nil } }) }
}

#endif
