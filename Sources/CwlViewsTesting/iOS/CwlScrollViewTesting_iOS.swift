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

extension BindingParser where Downcast: ScrollViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ScrollView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asScrollViewBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var panGestureRecognizerStyles: BindingParser<Constant<PanGestureRecognizer>, ScrollView.Binding, Downcast> { return .init(extract: { if case .panGestureRecognizerStyles(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var pinchGestureRecognizerStyles: BindingParser<Constant<PinchGestureRecognizer>, ScrollView.Binding, Downcast> { return .init(extract: { if case .pinchGestureRecognizerStyles(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var alwaysBounceHorizontal: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .alwaysBounceHorizontal(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var alwaysBounceVertical: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .alwaysBounceVertical(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var bounces: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .bounces(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var bouncesZoom: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .bouncesZoom(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var canCancelContentTouches: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .canCancelContentTouches(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var contentInset: BindingParser<Dynamic<UIEdgeInsets>, ScrollView.Binding, Downcast> { return .init(extract: { if case .contentInset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var contentInsetAdjustmentBehavior: BindingParser<Dynamic<UIScrollView.ContentInsetAdjustmentBehavior>, ScrollView.Binding, Downcast> { return .init(extract: { if case .contentInsetAdjustmentBehavior(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var contentOffset: BindingParser<Dynamic<SetOrAnimate<CGPoint>>, ScrollView.Binding, Downcast> { return .init(extract: { if case .contentOffset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var contentSize: BindingParser<Dynamic<CGSize>, ScrollView.Binding, Downcast> { return .init(extract: { if case .contentSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var decelerationRate: BindingParser<Dynamic<UIScrollView.DecelerationRate>, ScrollView.Binding, Downcast> { return .init(extract: { if case .decelerationRate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var delaysContentTouches: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .delaysContentTouches(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var indicatorStyle: BindingParser<Dynamic<UIScrollView.IndicatorStyle>, ScrollView.Binding, Downcast> { return .init(extract: { if case .indicatorStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var isDirectionalLockEnabled: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .isDirectionalLockEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var isPagingEnabled: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .isPagingEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var isScrollEnabled: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .isScrollEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var maximumZoomScale: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .maximumZoomScale(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var minimumZoomScale: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .minimumZoomScale(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var refreshControl: BindingParser<Dynamic<UIRefreshControl?>, ScrollView.Binding, Downcast> { return .init(extract: { if case .refreshControl(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollIndicatorInsets: BindingParser<Dynamic<UIEdgeInsets>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollIndicatorInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollsToTop: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollsToTop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var showsHorizontalScrollIndicator: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .showsHorizontalScrollIndicator(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var showsVerticalScrollIndicator: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .showsVerticalScrollIndicator(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var zoomScale: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .zoomScale(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var flashScrollIndicators: BindingParser<Signal<Void>, ScrollView.Binding, Downcast> { return .init(extract: { if case .flashScrollIndicators(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollRectToVisible: BindingParser<Signal<(rect: CGRect, animated: Bool)>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollRectToVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var zoom: BindingParser<Signal<(rect: CGRect, animated: Bool)>, ScrollView.Binding, Downcast> { return .init(extract: { if case .zoom(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var userDidScroll: BindingParser<SignalInput<CGPoint>, ScrollView.Binding, Downcast> { return .init(extract: { if case .userDidScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didEndDecelerating: BindingParser<(UIScrollView) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .didEndDecelerating(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didEndDragging: BindingParser<(UIScrollView, Bool) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .didEndDragging(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didEndScrollingAnimation: BindingParser<(UIScrollView) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .didEndScrollingAnimation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didEndZooming: BindingParser<(UIScrollView, UIView?, CGFloat) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .didEndZooming(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didScroll: BindingParser<(UIScrollView, CGPoint) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .didScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didScrollToTop: BindingParser<(UIScrollView) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .didScrollToTop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didZoom: BindingParser<(UIScrollView) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .didZoom(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var shouldScrollToTop: BindingParser<(_ scrollView: UIScrollView) -> Bool, ScrollView.Binding, Downcast> { return .init(extract: { if case .shouldScrollToTop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var viewForZooming: BindingParser<(_ scrollView: UIScrollView) -> UIView?, ScrollView.Binding, Downcast> { return .init(extract: { if case .viewForZooming(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var willBeginDecelerating: BindingParser<(UIScrollView) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .willBeginDecelerating(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var willBeginDragging: BindingParser<(UIScrollView) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .willBeginDragging(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var willBeginZooming: BindingParser<(UIScrollView, UIView?) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .willBeginZooming(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var willEndDragging: BindingParser<(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void, ScrollView.Binding, Downcast> { return .init(extract: { if case .willEndDragging(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
}

#endif
