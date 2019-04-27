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

extension BindingParser where Downcast: ViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ViewController.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asViewControllerBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var navigationItem: BindingParser<Constant<NavigationItem>, ViewController.Binding, Downcast> { return .init(extract: { if case .navigationItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var additionalSafeAreaInsets: BindingParser<Dynamic<UIEdgeInsets>, ViewController.Binding, Downcast> { return .init(extract: { if case .additionalSafeAreaInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var children: BindingParser<Dynamic<[ViewControllerConvertible]>, ViewController.Binding, Downcast> { return .init(extract: { if case .children(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var definesPresentationContext: BindingParser<Dynamic<Bool>, ViewController.Binding, Downcast> { return .init(extract: { if case .definesPresentationContext(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var edgesForExtendedLayout: BindingParser<Dynamic<UIRectEdge>, ViewController.Binding, Downcast> { return .init(extract: { if case .edgesForExtendedLayout(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var extendedLayoutIncludesOpaqueBars: BindingParser<Dynamic<Bool>, ViewController.Binding, Downcast> { return .init(extract: { if case .extendedLayoutIncludesOpaqueBars(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var hidesBottomBarWhenPushed: BindingParser<Dynamic<Bool>, ViewController.Binding, Downcast> { return .init(extract: { if case .hidesBottomBarWhenPushed(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var isEditing: BindingParser<Signal<SetOrAnimate<Bool>>, ViewController.Binding, Downcast> { return .init(extract: { if case .isEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var isModalInPopover: BindingParser<Dynamic<Bool>, ViewController.Binding, Downcast> { return .init(extract: { if case .isModalInPopover(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var modalPresentationCapturesStatusBarAppearance: BindingParser<Dynamic<Bool>, ViewController.Binding, Downcast> { return .init(extract: { if case .modalPresentationCapturesStatusBarAppearance(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var modalPresentationStyle: BindingParser<Dynamic<UIModalPresentationStyle>, ViewController.Binding, Downcast> { return .init(extract: { if case .modalPresentationStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var modalTransitionStyle: BindingParser<Dynamic<UIModalTransitionStyle>, ViewController.Binding, Downcast> { return .init(extract: { if case .modalTransitionStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var preferredContentSize: BindingParser<Dynamic<CGSize>, ViewController.Binding, Downcast> { return .init(extract: { if case .preferredContentSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var providesPresentationContextTransitionStyle: BindingParser<Dynamic<Bool>, ViewController.Binding, Downcast> { return .init(extract: { if case .providesPresentationContextTransitionStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var restorationClass: BindingParser<Dynamic<UIViewControllerRestoration.Type?>, ViewController.Binding, Downcast> { return .init(extract: { if case .restorationClass(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var restorationIdentifier: BindingParser<Dynamic<String?>, ViewController.Binding, Downcast> { return .init(extract: { if case .restorationIdentifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var tabBarItem: BindingParser<Dynamic<TabBarItemConvertible>, ViewController.Binding, Downcast> { return .init(extract: { if case .tabBarItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var title: BindingParser<Dynamic<String>, ViewController.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var toolbarItems: BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, ViewController.Binding, Downcast> { return .init(extract: { if case .toolbarItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var transitioningDelegate: BindingParser<Dynamic<UIViewControllerTransitioningDelegate>, ViewController.Binding, Downcast> { return .init(extract: { if case .transitioningDelegate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	public static var view: BindingParser<Dynamic<ViewConvertible>, ViewController.Binding, Downcast> { return .init(extract: { if case .view(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var present: BindingParser<Signal<Animatable<ModalPresentation?, ()>>, ViewController.Binding, Downcast> { return .init(extract: { if case .present(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var childrenLayout: BindingParser<([UIView]) -> Layout, ViewController.Binding, Downcast> { return .init(extract: { if case .childrenLayout(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewControllerBinding() }) }
}

#endif
