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

extension BindingParser where Binding == NavigationController.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var navigationBar: BindingParser<Constant<NavigationBar>, Binding> { return BindingParser<Constant<NavigationBar>, Binding>(parse: { binding -> Optional<Constant<NavigationBar>> in if case .navigationBar(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var hidesBarsOnSwipe: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hidesBarsOnSwipe(let x) = binding { return x } else { return nil } }) }
	public static var hidesBarsOnTap: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hidesBarsOnTap(let x) = binding { return x } else { return nil } }) }
	public static var hidesBarsWhenKeyboardAppears: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hidesBarsWhenKeyboardAppears(let x) = binding { return x } else { return nil } }) }
	public static var hidesBarsWhenVerticallyCompact: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hidesBarsWhenVerticallyCompact(let x) = binding { return x } else { return nil } }) }
	public static var isNavigationBarHidden: BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Bool>>> in if case .isNavigationBarHidden(let x) = binding { return x } else { return nil } }) }
	public static var isToolbarHidden: BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Bool>>> in if case .isToolbarHidden(let x) = binding { return x } else { return nil } }) }
	public static var stack: BindingParser<Dynamic<StackMutation<ViewControllerConvertible>>, Binding> { return BindingParser<Dynamic<StackMutation<ViewControllerConvertible>>, Binding>(parse: { binding -> Optional<Dynamic<StackMutation<ViewControllerConvertible>>> in if case .stack(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var poppedToCount: BindingParser<SignalInput<Int>, Binding> { return BindingParser<SignalInput<Int>, Binding>(parse: { binding -> Optional<SignalInput<Int>> in if case .poppedToCount(let x) = binding { return x } else { return nil } }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var animationController: BindingParser<(_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?, Binding> { return BindingParser<(_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?, Binding>(parse: { binding -> Optional<(_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?> in if case .animationController(let x) = binding { return x } else { return nil } }) }
	public static var interactionController: BindingParser<(_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, Binding> { return BindingParser<(_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, Binding>(parse: { binding -> Optional<(_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?> in if case .interactionController(let x) = binding { return x } else { return nil } }) }
	public static var preferredInterfaceOrientation: BindingParser<(_ navigationController: UINavigationController) -> UIInterfaceOrientation, Binding> { return BindingParser<(_ navigationController: UINavigationController) -> UIInterfaceOrientation, Binding>(parse: { binding -> Optional<(_ navigationController: UINavigationController) -> UIInterfaceOrientation> in if case .preferredInterfaceOrientation(let x) = binding { return x } else { return nil } }) }
	public static var supportedInterfaceOrientations: BindingParser<(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask, Binding> { return BindingParser<(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask, Binding>(parse: { binding -> Optional<(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask> in if case .supportedInterfaceOrientations(let x) = binding { return x } else { return nil } }) }
	public static var didShow: BindingParser<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void, Binding> { return BindingParser<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void, Binding>(parse: { binding -> Optional<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void> in if case .didShow(let x) = binding { return x } else { return nil } }) }
	public static var willShow: BindingParser<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void, Binding> { return BindingParser<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void, Binding>(parse: { binding -> Optional<(_ navigationController: UINavigationController, _ viewController: UIViewController, _ animated: Bool) -> Void> in if case .willShow(let x) = binding { return x } else { return nil } }) }
}

#endif
