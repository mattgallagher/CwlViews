//
//  CwlScrollView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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

extension BindingParser where Binding == ScrollView.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var panGestureRecognizerStyles: BindingParser<Constant<PanGestureRecognizer>, Binding> { return BindingParser<Constant<PanGestureRecognizer>, Binding>(parse: { binding -> Optional<Constant<PanGestureRecognizer>> in if case .panGestureRecognizerStyles(let x) = binding { return x } else { return nil } }) }
	public static var pinchGestureRecognizerStyles: BindingParser<Constant<PinchGestureRecognizer>, Binding> { return BindingParser<Constant<PinchGestureRecognizer>, Binding>(parse: { binding -> Optional<Constant<PinchGestureRecognizer>> in if case .pinchGestureRecognizerStyles(let x) = binding { return x } else { return nil } }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var alwaysBounceHorizontal: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .alwaysBounceHorizontal(let x) = binding { return x } else { return nil } }) }
	public static var alwaysBounceVertical: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .alwaysBounceVertical(let x) = binding { return x } else { return nil } }) }
	public static var bounces: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .bounces(let x) = binding { return x } else { return nil } }) }
	public static var bouncesZoom: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .bouncesZoom(let x) = binding { return x } else { return nil } }) }
	public static var canCancelContentTouches: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .canCancelContentTouches(let x) = binding { return x } else { return nil } }) }
	public static var contentInset: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .contentInset(let x) = binding { return x } else { return nil } }) }
	public static var contentInsetAdjustmentBehavior: BindingParser<Dynamic<UIScrollView.ContentInsetAdjustmentBehavior>, Binding> { return BindingParser<Dynamic<UIScrollView.ContentInsetAdjustmentBehavior>, Binding>(parse: { binding -> Optional<Dynamic<UIScrollView.ContentInsetAdjustmentBehavior>> in if case .contentInsetAdjustmentBehavior(let x) = binding { return x } else { return nil } }) }
	public static var contentOffset: BindingParser<Dynamic<SetOrAnimate<CGPoint>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<CGPoint>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<CGPoint>>> in if case .contentOffset(let x) = binding { return x } else { return nil } }) }
	public static var contentSize: BindingParser<Dynamic<CGSize>, Binding> { return BindingParser<Dynamic<CGSize>, Binding>(parse: { binding -> Optional<Dynamic<CGSize>> in if case .contentSize(let x) = binding { return x } else { return nil } }) }
	public static var decelerationRate: BindingParser<Dynamic<UIScrollView.DecelerationRate>, Binding> { return BindingParser<Dynamic<UIScrollView.DecelerationRate>, Binding>(parse: { binding -> Optional<Dynamic<UIScrollView.DecelerationRate>> in if case .decelerationRate(let x) = binding { return x } else { return nil } }) }
	public static var delaysContentTouches: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .delaysContentTouches(let x) = binding { return x } else { return nil } }) }
	public static var indicatorStyle: BindingParser<Dynamic<UIScrollView.IndicatorStyle>, Binding> { return BindingParser<Dynamic<UIScrollView.IndicatorStyle>, Binding>(parse: { binding -> Optional<Dynamic<UIScrollView.IndicatorStyle>> in if case .indicatorStyle(let x) = binding { return x } else { return nil } }) }
	public static var isDirectionalLockEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isDirectionalLockEnabled(let x) = binding { return x } else { return nil } }) }
	public static var isPagingEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isPagingEnabled(let x) = binding { return x } else { return nil } }) }
	public static var isScrollEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isScrollEnabled(let x) = binding { return x } else { return nil } }) }
	public static var maximumZoomScale: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .maximumZoomScale(let x) = binding { return x } else { return nil } }) }
	public static var minimumZoomScale: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .minimumZoomScale(let x) = binding { return x } else { return nil } }) }
	public static var refreshControl: BindingParser<Dynamic<UIRefreshControl?>, Binding> { return BindingParser<Dynamic<UIRefreshControl?>, Binding>(parse: { binding -> Optional<Dynamic<UIRefreshControl?>> in if case .refreshControl(let x) = binding { return x } else { return nil } }) }
	public static var scrollIndicatorInsets: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .scrollIndicatorInsets(let x) = binding { return x } else { return nil } }) }
	public static var scrollsToTop: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .scrollsToTop(let x) = binding { return x } else { return nil } }) }
	public static var showsHorizontalScrollIndicator: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsHorizontalScrollIndicator(let x) = binding { return x } else { return nil } }) }
	public static var showsVerticalScrollIndicator: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsVerticalScrollIndicator(let x) = binding { return x } else { return nil } }) }
	public static var zoomScale: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .zoomScale(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var flashScrollIndicators: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .flashScrollIndicators(let x) = binding { return x } else { return nil } }) }
	public static var scrollRectToVisible: BindingParser<Signal<(rect: CGRect, animated: Bool)>, Binding> { return BindingParser<Signal<(rect: CGRect, animated: Bool)>, Binding>(parse: { binding -> Optional<Signal<(rect: CGRect, animated: Bool)>> in if case .scrollRectToVisible(let x) = binding { return x } else { return nil } }) }
	public static var zoom: BindingParser<Signal<(rect: CGRect, animated: Bool)>, Binding> { return BindingParser<Signal<(rect: CGRect, animated: Bool)>, Binding>(parse: { binding -> Optional<Signal<(rect: CGRect, animated: Bool)>> in if case .zoom(let x) = binding { return x } else { return nil } }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var userDidScroll: BindingParser<SignalInput<CGPoint>, Binding> { return BindingParser<SignalInput<CGPoint>, Binding>(parse: { binding -> Optional<SignalInput<CGPoint>> in if case .userDidScroll(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didEndDecelerating: BindingParser<(UIScrollView) -> Void, Binding> { return BindingParser<(UIScrollView) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView) -> Void> in if case .didEndDecelerating(let x) = binding { return x } else { return nil } }) }
	public static var didEndDragging: BindingParser<(UIScrollView, Bool) -> Void, Binding> { return BindingParser<(UIScrollView, Bool) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView, Bool) -> Void> in if case .didEndDragging(let x) = binding { return x } else { return nil } }) }
	public static var didEndScrollingAnimation: BindingParser<(UIScrollView) -> Void, Binding> { return BindingParser<(UIScrollView) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView) -> Void> in if case .didEndScrollingAnimation(let x) = binding { return x } else { return nil } }) }
	public static var didEndZooming: BindingParser<(UIScrollView, UIView?, CGFloat) -> Void, Binding> { return BindingParser<(UIScrollView, UIView?, CGFloat) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView, UIView?, CGFloat) -> Void> in if case .didEndZooming(let x) = binding { return x } else { return nil } }) }
	public static var didScroll: BindingParser<(UIScrollView, CGPoint) -> Void, Binding> { return BindingParser<(UIScrollView, CGPoint) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView, CGPoint) -> Void> in if case .didScroll(let x) = binding { return x } else { return nil } }) }
	public static var didScrollToTop: BindingParser<(UIScrollView) -> Void, Binding> { return BindingParser<(UIScrollView) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView) -> Void> in if case .didScrollToTop(let x) = binding { return x } else { return nil } }) }
	public static var didZoom: BindingParser<(UIScrollView) -> Void, Binding> { return BindingParser<(UIScrollView) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView) -> Void> in if case .didZoom(let x) = binding { return x } else { return nil } }) }
	public static var shouldScrollToTop: BindingParser<(_ scrollView: UIScrollView) -> Bool, Binding> { return BindingParser<(_ scrollView: UIScrollView) -> Bool, Binding>(parse: { binding -> Optional<(_ scrollView: UIScrollView) -> Bool> in if case .shouldScrollToTop(let x) = binding { return x } else { return nil } }) }
	public static var viewForZooming: BindingParser<(_ scrollView: UIScrollView) -> UIView?, Binding> { return BindingParser<(_ scrollView: UIScrollView) -> UIView?, Binding>(parse: { binding -> Optional<(_ scrollView: UIScrollView) -> UIView?> in if case .viewForZooming(let x) = binding { return x } else { return nil } }) }
	public static var willBeginDecelerating: BindingParser<(UIScrollView) -> Void, Binding> { return BindingParser<(UIScrollView) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView) -> Void> in if case .willBeginDecelerating(let x) = binding { return x } else { return nil } }) }
	public static var willBeginDragging: BindingParser<(UIScrollView) -> Void, Binding> { return BindingParser<(UIScrollView) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView) -> Void> in if case .willBeginDragging(let x) = binding { return x } else { return nil } }) }
	public static var willBeginZooming: BindingParser<(UIScrollView, UIView?) -> Void, Binding> { return BindingParser<(UIScrollView, UIView?) -> Void, Binding>(parse: { binding -> Optional<(UIScrollView, UIView?) -> Void> in if case .willBeginZooming(let x) = binding { return x } else { return nil } }) }
	public static var willEndDragging: BindingParser<(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void, Binding> { return BindingParser<(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void, Binding>(parse: { binding -> Optional<(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void> in if case .willEndDragging(let x) = binding { return x } else { return nil } }) }
}

#endif
