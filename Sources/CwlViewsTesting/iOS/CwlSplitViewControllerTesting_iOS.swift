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

extension BindingParser where Downcast: SplitViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, SplitViewController.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asSplitViewControllerBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var backgroundView: BindingParser<Constant<View>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .backgroundView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var maximumPrimaryColumnWidth: BindingParser<Dynamic<CGFloat>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .maximumPrimaryColumnWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var minimumPrimaryColumnWidth: BindingParser<Dynamic<CGFloat>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .minimumPrimaryColumnWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var preferredDisplayMode: BindingParser<Dynamic<UISplitViewController.DisplayMode>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .preferredDisplayMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var preferredPrimaryColumnWidthFraction: BindingParser<Dynamic<CGFloat>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .preferredPrimaryColumnWidthFraction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var presentsWithGesture: BindingParser<Dynamic<Bool>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .presentsWithGesture(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var primaryViewController: BindingParser<Dynamic<ViewControllerConvertible>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .primaryViewController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var secondaryViewController: BindingParser<Dynamic<ViewControllerConvertible>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .secondaryViewController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var shouldShowSecondary: BindingParser<Dynamic<Bool>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .shouldShowSecondary(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var dismissedSecondary: BindingParser<SignalInput<Void>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .dismissedSecondary(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var displayModeButton: BindingParser<SignalInput<BarButtonItemConvertible?>, SplitViewController.Binding, Downcast> { return .init(extract: { if case .displayModeButton(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var collapseSecondary: BindingParser<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool, SplitViewController.Binding, Downcast> { return .init(extract: { if case .collapseSecondary(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var preferredInterfaceOrientation: BindingParser<(UISplitViewController) -> UIInterfaceOrientation, SplitViewController.Binding, Downcast> { return .init(extract: { if case .preferredInterfaceOrientation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var primaryViewControllerForCollapsing: BindingParser<(UISplitViewController) -> UIViewController?, SplitViewController.Binding, Downcast> { return .init(extract: { if case .primaryViewControllerForCollapsing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var primaryViewControllerForExpanding: BindingParser<(UISplitViewController) -> UIViewController?, SplitViewController.Binding, Downcast> { return .init(extract: { if case .primaryViewControllerForExpanding(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var separateSecondary: BindingParser<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?, SplitViewController.Binding, Downcast> { return .init(extract: { if case .separateSecondary(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var showPrimaryViewController: BindingParser<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, SplitViewController.Binding, Downcast> { return .init(extract: { if case .showPrimaryViewController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var showSecondaryViewController: BindingParser<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, SplitViewController.Binding, Downcast> { return .init(extract: { if case .showSecondaryViewController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var supportedInterfaceOrientations: BindingParser<(UISplitViewController) -> UIInterfaceOrientationMask, SplitViewController.Binding, Downcast> { return .init(extract: { if case .supportedInterfaceOrientations(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var targetDisplayModeForAction: BindingParser<(UISplitViewController) -> UISplitViewController.DisplayMode, SplitViewController.Binding, Downcast> { return .init(extract: { if case .targetDisplayModeForAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
	public static var willChangeDisplayMode: BindingParser<(UISplitViewController, UISplitViewController.DisplayMode) -> Void, SplitViewController.Binding, Downcast> { return .init(extract: { if case .willChangeDisplayMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewControllerBinding() }) }
}

#endif
