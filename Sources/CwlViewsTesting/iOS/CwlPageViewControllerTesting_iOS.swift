//
//  CwlPageViewController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/03/24.
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

extension BindingParser where Downcast: PageViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asPageViewControllerBinding() }) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	public static var navigationOrientation: BindingParser<Constant<UIPageViewController.NavigationOrientation>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .navigationOrientation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var pageSpacing: BindingParser<Constant<CGFloat>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .pageSpacing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var spineLocation: BindingParser<Constant<UIPageViewController.SpineLocation>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .spineLocation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var transitionStyle: BindingParser<Constant<UIPageViewController.TransitionStyle>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .transitionStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isDoubleSided: BindingParser<Dynamic<Bool>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .isDoubleSided(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var pageData: BindingParser<Dynamic<Animatable<[Downcast.PageDataType], UIPageViewController.NavigationDirection>>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .pageData(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var changeCurrentPage: BindingParser<Signal<Animatable<Int, UIPageViewController.NavigationDirection>>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .changeCurrentPage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var pageChanged: BindingParser<SignalInput<(index: Int, data: Downcast.PageDataType)>, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .pageChanged(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var constructPage: BindingParser<(Downcast.PageDataType) -> ViewControllerConvertible, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .constructPage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var didFinishAnimating: BindingParser<(UIPageViewController, Bool, [UIViewController], Bool) -> Void, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .didFinishAnimating(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var interfaceOrientationForPresentation: BindingParser<(UIPageViewController) -> UIInterfaceOrientation, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .interfaceOrientationForPresentation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var spineLocationFor: BindingParser<(UIPageViewController, UIInterfaceOrientation) -> UIPageViewController.SpineLocation, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .spineLocationFor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var supportedInterfaceOrientations: BindingParser<(UIPageViewController) -> UIInterfaceOrientationMask, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .supportedInterfaceOrientations(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
	public static var willTransitionTo: BindingParser<(UIPageViewController, [UIViewController]) -> Void, PageViewController<Downcast.PageDataType>.Binding, Downcast> { return .init(extract: { if case .willTransitionTo(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPageViewControllerBinding() }) }
}

#endif
