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

extension BindingParser where Binding: PageViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<$2, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	public static var navigationOrientation: BindingParser<Constant<UIPageViewController.NavigationOrientation>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<Constant<UIPageViewController.NavigationOrientation>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<Constant<UIPageViewController.NavigationOrientation>> in if case .navigationOrientation(let x) = binding { return x } else { return nil } }) }
	public static var pageSpacing: BindingParser<Constant<CGFloat>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<Constant<CGFloat>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<Constant<CGFloat>> in if case .pageSpacing(let x) = binding { return x } else { return nil } }) }
	public static var spineLocation: BindingParser<Constant<UIPageViewController.SpineLocation>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<Constant<UIPageViewController.SpineLocation>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<Constant<UIPageViewController.SpineLocation>> in if case .spineLocation(let x) = binding { return x } else { return nil } }) }
	public static var transitionStyle: BindingParser<Constant<UIPageViewController.TransitionStyle>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<Constant<UIPageViewController.TransitionStyle>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<Constant<UIPageViewController.TransitionStyle>> in if case .transitionStyle(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isDoubleSided: BindingParser<Dynamic<Bool>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<Dynamic<Bool>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isDoubleSided(let x) = binding { return x } else { return nil } }) }
	public static var pageData: BindingParser<Dynamic<Animatable<[Binding.PageDataType], UIPageViewController.NavigationDirection>>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<Dynamic<Animatable<[Binding.PageDataType], UIPageViewController.NavigationDirection>>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<Dynamic<Animatable<[Binding.PageDataType], UIPageViewController.NavigationDirection>>> in if case .pageData(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var changeCurrentPage: BindingParser<Signal<Animatable<Int, UIPageViewController.NavigationDirection>>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<Signal<Animatable<Int, UIPageViewController.NavigationDirection>>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<Signal<Animatable<Int, UIPageViewController.NavigationDirection>>> in if case .changeCurrentPage(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.
	public static var pageChanged: BindingParser<SignalInput<(index: Int, data: Binding.PageDataType)>, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<SignalInput<(index: Int, data: Binding.PageDataType)>, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<SignalInput<(index: Int, data: Binding.PageDataType)>> in if case .pageChanged(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var constructPage: BindingParser<(Binding.PageDataType) -> ViewControllerConvertible, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<(Binding.PageDataType) -> ViewControllerConvertible, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<(Binding.PageDataType) -> ViewControllerConvertible> in if case .constructPage(let x) = binding { return x } else { return nil } }) }
	public static var didFinishAnimating: BindingParser<(UIPageViewController, Bool, [UIViewController], Bool) -> Void, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<(UIPageViewController, Bool, [UIViewController], Bool) -> Void, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<(UIPageViewController, Bool, [UIViewController], Bool) -> Void> in if case .didFinishAnimating(let x) = binding { return x } else { return nil } }) }
	public static var interfaceOrientationForPresentation: BindingParser<(UIPageViewController) -> UIInterfaceOrientation, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<(UIPageViewController) -> UIInterfaceOrientation, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<(UIPageViewController) -> UIInterfaceOrientation> in if case .interfaceOrientationForPresentation(let x) = binding { return x } else { return nil } }) }
	public static var spineLocationFor: BindingParser<(UIPageViewController, UIInterfaceOrientation) -> UIPageViewController.SpineLocation, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<(UIPageViewController, UIInterfaceOrientation) -> UIPageViewController.SpineLocation, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<(UIPageViewController, UIInterfaceOrientation) -> UIPageViewController.SpineLocation> in if case .spineLocationFor(let x) = binding { return x } else { return nil } }) }
	public static var supportedInterfaceOrientations: BindingParser<(UIPageViewController) -> UIInterfaceOrientationMask, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<(UIPageViewController) -> UIInterfaceOrientationMask, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<(UIPageViewController) -> UIInterfaceOrientationMask> in if case .supportedInterfaceOrientations(let x) = binding { return x } else { return nil } }) }
	public static var willTransitionTo: BindingParser<(UIPageViewController, [UIViewController]) -> Void, PageViewController<Binding.PageDataType>.Binding> { return BindingParser<(UIPageViewController, [UIViewController]) -> Void, PageViewController<Binding.PageDataType>.Binding>(parse: { binding -> Optional<(UIPageViewController, [UIViewController]) -> Void> in if case .willTransitionTo(let x) = binding { return x } else { return nil } }) }
}

#endif
