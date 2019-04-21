//
//  CwlSplitViewController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/03.
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

extension BindingParser where Binding == SplitViewController.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var backgroundView: BindingParser<Constant<View>, Binding> { return BindingParser<Constant<View>, Binding>(parse: { binding -> Optional<Constant<View>> in if case .backgroundView(let x) = binding { return x } else { return nil } }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var maximumPrimaryColumnWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .maximumPrimaryColumnWidth(let x) = binding { return x } else { return nil } }) }
	public static var minimumPrimaryColumnWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .minimumPrimaryColumnWidth(let x) = binding { return x } else { return nil } }) }
	public static var preferredDisplayMode: BindingParser<Dynamic<UISplitViewController.DisplayMode>, Binding> { return BindingParser<Dynamic<UISplitViewController.DisplayMode>, Binding>(parse: { binding -> Optional<Dynamic<UISplitViewController.DisplayMode>> in if case .preferredDisplayMode(let x) = binding { return x } else { return nil } }) }
	public static var preferredPrimaryColumnWidthFraction: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .preferredPrimaryColumnWidthFraction(let x) = binding { return x } else { return nil } }) }
	public static var presentsWithGesture: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .presentsWithGesture(let x) = binding { return x } else { return nil } }) }
	public static var primaryViewController: BindingParser<Dynamic<ViewControllerConvertible>, Binding> { return BindingParser<Dynamic<ViewControllerConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ViewControllerConvertible>> in if case .primaryViewController(let x) = binding { return x } else { return nil } }) }
	public static var secondaryViewController: BindingParser<Dynamic<ViewControllerConvertible>, Binding> { return BindingParser<Dynamic<ViewControllerConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ViewControllerConvertible>> in if case .secondaryViewController(let x) = binding { return x } else { return nil } }) }
	public static var shouldShowSecondary: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .shouldShowSecondary(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.
	public static var dismissedSecondary: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .dismissedSecondary(let x) = binding { return x } else { return nil } }) }
	public static var displayModeButton: BindingParser<SignalInput<BarButtonItemConvertible?>, Binding> { return BindingParser<SignalInput<BarButtonItemConvertible?>, Binding>(parse: { binding -> Optional<SignalInput<BarButtonItemConvertible?>> in if case .displayModeButton(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var collapseSecondary: BindingParser<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool, Binding> { return BindingParser<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool, Binding>(parse: { binding -> Optional<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool> in if case .collapseSecondary(let x) = binding { return x } else { return nil } }) }
	public static var preferredInterfaceOrientation: BindingParser<(UISplitViewController) -> UIInterfaceOrientation, Binding> { return BindingParser<(UISplitViewController) -> UIInterfaceOrientation, Binding>(parse: { binding -> Optional<(UISplitViewController) -> UIInterfaceOrientation> in if case .preferredInterfaceOrientation(let x) = binding { return x } else { return nil } }) }
	public static var primaryViewControllerForCollapsing: BindingParser<(UISplitViewController) -> UIViewController?, Binding> { return BindingParser<(UISplitViewController) -> UIViewController?, Binding>(parse: { binding -> Optional<(UISplitViewController) -> UIViewController?> in if case .primaryViewControllerForCollapsing(let x) = binding { return x } else { return nil } }) }
	public static var primaryViewControllerForExpanding: BindingParser<(UISplitViewController) -> UIViewController?, Binding> { return BindingParser<(UISplitViewController) -> UIViewController?, Binding>(parse: { binding -> Optional<(UISplitViewController) -> UIViewController?> in if case .primaryViewControllerForExpanding(let x) = binding { return x } else { return nil } }) }
	public static var separateSecondary: BindingParser<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?, Binding> { return BindingParser<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?, Binding>(parse: { binding -> Optional<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?> in if case .separateSecondary(let x) = binding { return x } else { return nil } }) }
	public static var showPrimaryViewController: BindingParser<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding> { return BindingParser<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding>(parse: { binding -> Optional<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool> in if case .showPrimaryViewController(let x) = binding { return x } else { return nil } }) }
	public static var showSecondaryViewController: BindingParser<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding> { return BindingParser<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding>(parse: { binding -> Optional<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool> in if case .showSecondaryViewController(let x) = binding { return x } else { return nil } }) }
	public static var supportedInterfaceOrientations: BindingParser<(UISplitViewController) -> UIInterfaceOrientationMask, Binding> { return BindingParser<(UISplitViewController) -> UIInterfaceOrientationMask, Binding>(parse: { binding -> Optional<(UISplitViewController) -> UIInterfaceOrientationMask> in if case .supportedInterfaceOrientations(let x) = binding { return x } else { return nil } }) }
	public static var targetDisplayModeForAction: BindingParser<(UISplitViewController) -> UISplitViewController.DisplayMode, Binding> { return BindingParser<(UISplitViewController) -> UISplitViewController.DisplayMode, Binding>(parse: { binding -> Optional<(UISplitViewController) -> UISplitViewController.DisplayMode> in if case .targetDisplayModeForAction(let x) = binding { return x } else { return nil } }) }
	public static var willChangeDisplayMode: BindingParser<(UISplitViewController, UISplitViewController.DisplayMode) -> Void, Binding> { return BindingParser<(UISplitViewController, UISplitViewController.DisplayMode) -> Void, Binding>(parse: { binding -> Optional<(UISplitViewController, UISplitViewController.DisplayMode) -> Void> in if case .willChangeDisplayMode(let x) = binding { return x } else { return nil } }) }
}

#endif
