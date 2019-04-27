//
//  CwlNavigationController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/16.
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

extension BindingParser where Downcast: NavigationControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, NavigationController.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asNavigationControllerBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var navigationBar: BindingParser<Constant<NavigationBar>, NavigationController.Binding, Downcast> { return .init(extract: { if case .navigationBar(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var hidesBarsOnSwipe: BindingParser<Dynamic<Bool>, NavigationController.Binding, Downcast> { return .init(extract: { if case .hidesBarsOnSwipe(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var hidesBarsOnTap: BindingParser<Dynamic<Bool>, NavigationController.Binding, Downcast> { return .init(extract: { if case .hidesBarsOnTap(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var hidesBarsWhenKeyboardAppears: BindingParser<Dynamic<Bool>, NavigationController.Binding, Downcast> { return .init(extract: { if case .hidesBarsWhenKeyboardAppears(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var hidesBarsWhenVerticallyCompact: BindingParser<Dynamic<Bool>, NavigationController.Binding, Downcast> { return .init(extract: { if case .hidesBarsWhenVerticallyCompact(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var isNavigationBarHidden: BindingParser<Dynamic<SetOrAnimate<Bool>>, NavigationController.Binding, Downcast> { return .init(extract: { if case .isNavigationBarHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var isToolbarHidden: BindingParser<Dynamic<SetOrAnimate<Bool>>, NavigationController.Binding, Downcast> { return .init(extract: { if case .isToolbarHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var stack: BindingParser<Dynamic<StackMutation<ViewControllerConvertible>>, NavigationController.Binding, Downcast> { return .init(extract: { if case .stack(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var poppedToCount: BindingParser<SignalInput<Int>, NavigationController.Binding, Downcast> { return .init(extract: { if case .poppedToCount(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var animationController: BindingParser<(_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?, NavigationController.Binding, Downcast> { return .init(extract: { if case .animationController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var interactionController: BindingParser<(_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, NavigationController.Binding, Downcast> { return .init(extract: { if case .interactionController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var preferredInterfaceOrientation: BindingParser<(_ navigationController: UINavigationController) -> UIInterfaceOrientation, NavigationController.Binding, Downcast> { return .init(extract: { if case .preferredInterfaceOrientation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var supportedInterfaceOrientations: BindingParser<(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask, NavigationController.Binding, Downcast> { return .init(extract: { if case .supportedInterfaceOrientations(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var didShow: BindingParser<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void, NavigationController.Binding, Downcast> { return .init(extract: { if case .didShow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
	public static var willShow: BindingParser<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void, NavigationController.Binding, Downcast> { return .init(extract: { if case .willShow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asNavigationControllerBinding() }) }
}

#endif
