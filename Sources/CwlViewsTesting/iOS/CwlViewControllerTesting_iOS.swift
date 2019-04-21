//
//  CwlViewController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/13.
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

extension BindingParser where Binding == ViewController.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var navigationItem: BindingParser<Constant<NavigationItem>, Binding> { return BindingParser<Constant<NavigationItem>, Binding>(parse: { binding -> Optional<Constant<NavigationItem>> in if case .navigationItem(let x) = binding { return x } else { return nil } }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var additionalSafeAreaInsets: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .additionalSafeAreaInsets(let x) = binding { return x } else { return nil } }) }
	public static var children: BindingParser<Dynamic<[ViewControllerConvertible]>, Binding> { return BindingParser<Dynamic<[ViewControllerConvertible]>, Binding>(parse: { binding -> Optional<Dynamic<[ViewControllerConvertible]>> in if case .children(let x) = binding { return x } else { return nil } }) }
	public static var definesPresentationContext: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .definesPresentationContext(let x) = binding { return x } else { return nil } }) }
	public static var edgesForExtendedLayout: BindingParser<Dynamic<UIRectEdge>, Binding> { return BindingParser<Dynamic<UIRectEdge>, Binding>(parse: { binding -> Optional<Dynamic<UIRectEdge>> in if case .edgesForExtendedLayout(let x) = binding { return x } else { return nil } }) }
	public static var extendedLayoutIncludesOpaqueBars: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .extendedLayoutIncludesOpaqueBars(let x) = binding { return x } else { return nil } }) }
	public static var hidesBottomBarWhenPushed: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hidesBottomBarWhenPushed(let x) = binding { return x } else { return nil } }) }
	public static var isEditing: BindingParser<Signal<SetOrAnimate<Bool>>, Binding> { return BindingParser<Signal<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Signal<SetOrAnimate<Bool>>> in if case .isEditing(let x) = binding { return x } else { return nil } }) }
	public static var isModalInPopover: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isModalInPopover(let x) = binding { return x } else { return nil } }) }
	public static var modalPresentationCapturesStatusBarAppearance: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .modalPresentationCapturesStatusBarAppearance(let x) = binding { return x } else { return nil } }) }
	public static var modalPresentationStyle: BindingParser<Dynamic<UIModalPresentationStyle>, Binding> { return BindingParser<Dynamic<UIModalPresentationStyle>, Binding>(parse: { binding -> Optional<Dynamic<UIModalPresentationStyle>> in if case .modalPresentationStyle(let x) = binding { return x } else { return nil } }) }
	public static var modalTransitionStyle: BindingParser<Dynamic<UIModalTransitionStyle>, Binding> { return BindingParser<Dynamic<UIModalTransitionStyle>, Binding>(parse: { binding -> Optional<Dynamic<UIModalTransitionStyle>> in if case .modalTransitionStyle(let x) = binding { return x } else { return nil } }) }
	public static var preferredContentSize: BindingParser<Dynamic<CGSize>, Binding> { return BindingParser<Dynamic<CGSize>, Binding>(parse: { binding -> Optional<Dynamic<CGSize>> in if case .preferredContentSize(let x) = binding { return x } else { return nil } }) }
	public static var providesPresentationContextTransitionStyle: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .providesPresentationContextTransitionStyle(let x) = binding { return x } else { return nil } }) }
	public static var restorationClass: BindingParser<Dynamic<UIViewControllerRestoration.Type?>, Binding> { return BindingParser<Dynamic<UIViewControllerRestoration.Type?>, Binding>(parse: { binding -> Optional<Dynamic<UIViewControllerRestoration.Type?>> in if case .restorationClass(let x) = binding { return x } else { return nil } }) }
	public static var restorationIdentifier: BindingParser<Dynamic<String?>, Binding> { return BindingParser<Dynamic<String?>, Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .restorationIdentifier(let x) = binding { return x } else { return nil } }) }
	public static var tabBarItem: BindingParser<Dynamic<TabBarItemConvertible>, Binding> { return BindingParser<Dynamic<TabBarItemConvertible>, Binding>(parse: { binding -> Optional<Dynamic<TabBarItemConvertible>> in if case .tabBarItem(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .title(let x) = binding { return x } else { return nil } }) }
	public static var toolbarItems: BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> in if case .toolbarItems(let x) = binding { return x } else { return nil } }) }
	public static var transitioningDelegate: BindingParser<Dynamic<UIViewControllerTransitioningDelegate>, Binding> { return BindingParser<Dynamic<UIViewControllerTransitioningDelegate>, Binding>(parse: { binding -> Optional<Dynamic<UIViewControllerTransitioningDelegate>> in if case .transitioningDelegate(let x) = binding { return x } else { return nil } }) }
	public static var view: BindingParser<Dynamic<ViewConvertible>, Binding> { return BindingParser<Dynamic<ViewConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible>> in if case .view(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var present: BindingParser<Signal<Animatable<ModalPresentation?, ()>>, Binding> { return BindingParser<Signal<Animatable<ModalPresentation?, ()>>, Binding>(parse: { binding -> Optional<Signal<Animatable<ModalPresentation?, ()>>> in if case .present(let x) = binding { return x } else { return nil } }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var childrenLayout: BindingParser<([UIView]) -> Layout, Binding> { return BindingParser<([UIView]) -> Layout, Binding>(parse: { binding -> Optional<([UIView]) -> Layout> in if case .childrenLayout(let x) = binding { return x } else { return nil } }) }
}

#endif
