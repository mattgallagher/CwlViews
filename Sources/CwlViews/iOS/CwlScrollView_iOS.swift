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

public class ScrollView: Binder, ScrollViewConvertible {
	public typealias Instance = UIScrollView
	public typealias Inherited = View
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiScrollView() -> Instance { return instance() }
	
	enum Binding: ScrollViewBinding {
		public typealias EnclosingBinder = ScrollView
		public static func scrollViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case panGestureRecognizerStyles(Constant<PanGestureRecognizer>)
		case pinchGestureRecognizerStyles(Constant<PinchGestureRecognizer>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case contentOffset(Dynamic<SetOrAnimate<CGPoint>>)
		case contentSize(Dynamic<CGSize>)
		case contentInset(Dynamic<UIEdgeInsets>)
		case contentInsetAdjustmentBehavior(Dynamic<UIScrollView.ContentInsetAdjustmentBehavior>)
		case isScrollEnabled(Dynamic<Bool>)
		case isDirectionalLockEnabled(Dynamic<Bool>)
		case scrollsToTop(Dynamic<Bool>)
		case isPagingEnabled(Dynamic<Bool>)
		case bounces(Dynamic<Bool>)
		case alwaysBounceVertical(Dynamic<Bool>)
		case alwaysBounceHorizontal(Dynamic<Bool>)
		case canCancelContentTouches(Dynamic<Bool>)
		case delaysContentTouches(Dynamic<Bool>)
		case decelerationRate(Dynamic<UIScrollView.DecelerationRate>)
		case indicatorStyle(Dynamic<UIScrollView.IndicatorStyle>)
		case scrollIndicatorInsets(Dynamic<UIEdgeInsets>)
		case showsHorizontalScrollIndicator(Dynamic<Bool>)
		case showsVerticalScrollIndicator(Dynamic<Bool>)
		case zoomScale(Dynamic<CGFloat>)
		case maximumZoomScale(Dynamic<CGFloat>)
		case minimumZoomScale(Dynamic<CGFloat>)
		case bouncesZoom(Dynamic<Bool>)
		@available(iOS 10.0, *) case refreshControl(Dynamic<UIRefreshControl?>)
		
		// 2. Signal bindings are performed on the object after construction.
		case scrollRectToVisible(Signal<(rect: CGRect, animated: Bool)>)
		case zoom(Signal<(rect: CGRect, animated: Bool)>)
		case flashScrollIndicators(Signal<Void>)
		
		// 3. Action bindings are triggered by the object after construction.
		case userDidScroll(SignalInput<CGPoint>)
		case didScroll(SignalInput<CGPoint>)
		case didZoom(SignalInput<CGFloat>)
		case willBeginDragging(SignalInput<CGPoint>)
		case didEndDragging(SignalInput<(CGPoint, Bool)>)
		case didScrollToTop(SignalInput<Void>)
		case willBeginDecelerating(SignalInput<Void>)
		case didEndDecelerating(SignalInput<CGPoint>)
		case willBeginZooming(SignalInput<CGFloat>)
		case didEndZooming(SignalInput<CGFloat>)
		case didEndScrollingAnimation(SignalInput<CGPoint>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case willEndDragging((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)
		case shouldScrollToTop((_ scrollView: UIScrollView) -> Bool)
		case viewForZooming((_ scrollView: UIScrollView) -> UIView?)
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = ScrollView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var dynamicDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = dynamicDelegate {
				return d
			} else {
				let d = delegateClass.init()
				dynamicDelegate = d
				return d
			}
		}
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .userDidScroll(let x):
				let s1 = #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:))
				let s2 = #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:))
				let s3 = #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:))
				delegate().addSelector(s1).userDidScroll = x
				_ = delegate().addSelector(s2)
				_ = delegate().addSelector(s3)
			case .didScroll(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidScroll(_:)))
			case .didZoom(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidZoom(_:)))
			case .willBeginDragging(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:)))
			case .didEndDragging(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
			case .didScrollToTop(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:)))
			case .willBeginDecelerating(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:)))
			case .didEndDecelerating(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))
			case .willBeginZooming(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillBeginZooming(_:with:)))
			case .didEndZooming(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:)))
			case .didEndScrollingAnimation(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation(_:)))
			case .willEndDragging(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
			case .shouldScrollToTop(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewShouldScrollToTop(_:)))
			case .viewForZooming(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.viewForZooming(in:)))
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}
		
		public func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = dynamicDelegate
			if storage.inUse {
				instance.delegate = storage
			}
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .panGestureRecognizerStyles(let x):
				x.value.applyBindings(to: instance.panGestureRecognizer)
				return nil
			case .pinchGestureRecognizerStyles(let x):
				if let pgr = instance.pinchGestureRecognizer {
					x.value.applyBindings(to: pgr)
				}
				return nil
			case .contentOffset(let x): return x.apply(instance) { i, v in i.setContentOffset(v.value, animated: v.isAnimated) }
			case .contentSize(let x): return x.apply(instance) { i, v in i.contentSize = v }
			case .contentInset(let x): return x.apply(instance) { i, v in i.contentInset = v }
			case .contentInsetAdjustmentBehavior(let x): return x.apply(instance) { i, v in i.contentInsetAdjustmentBehavior = v }
			case .isScrollEnabled(let x): return x.apply(instance) { i, v in i.isScrollEnabled = v }
			case .isDirectionalLockEnabled(let x): return x.apply(instance) { i, v in i.isDirectionalLockEnabled = v }
			case .scrollsToTop(let x): return x.apply(instance) { i, v in i.scrollsToTop = v }
			case .isPagingEnabled(let x): return x.apply(instance) { i, v in i.isPagingEnabled = v }
			case .bounces(let x): return x.apply(instance) { i, v in i.bounces = v }
			case .alwaysBounceVertical(let x): return x.apply(instance) { i, v in i.alwaysBounceVertical = v }
			case .alwaysBounceHorizontal(let x): return x.apply(instance) { i, v in i.alwaysBounceHorizontal = v }
			case .canCancelContentTouches(let x): return x.apply(instance) { i, v in i.canCancelContentTouches = v }
			case .delaysContentTouches(let x): return x.apply(instance) { i, v in i.delaysContentTouches = v }
			case .decelerationRate(let x): return x.apply(instance) { i, v in i.decelerationRate = v }
			case .indicatorStyle(let x): return x.apply(instance) { i, v in i.indicatorStyle = v }
			case .scrollIndicatorInsets(let x): return x.apply(instance) { i, v in i.scrollIndicatorInsets = v }
			case .showsHorizontalScrollIndicator(let x): return x.apply(instance) { i, v in i.showsHorizontalScrollIndicator = v }
			case .showsVerticalScrollIndicator(let x): return x.apply(instance) { i, v in i.showsVerticalScrollIndicator = v }
			case .zoomScale(let x): return x.apply(instance) { i, v in i.zoomScale = v }
			case .maximumZoomScale(let x): return x.apply(instance) { i, v in i.maximumZoomScale = v }
			case .minimumZoomScale(let x): return x.apply(instance) { i, v in i.minimumZoomScale = v }
			case .bouncesZoom(let x): return x.apply(instance) { i, v in i.bouncesZoom = v }
			case .refreshControl(let x):
				return x.apply(instance) { i, v in
					if #available(iOS 10.0, *) {
						i.refreshControl = v
					}
				}
			case .scrollRectToVisible(let x): return x.apply(instance) { i, v in i.scrollRectToVisible(v.rect, animated: v.animated) }
			case .zoom(let x): return x.apply(instance) { i, v in i.zoom(to: v.rect, animated: v.animated) }
			case .flashScrollIndicators(let x): return x.apply(instance) { i, v in i.flashScrollIndicators() }
			case .userDidScroll: return nil
			case .didScroll: return nil
			case .didZoom: return nil
			case .willBeginDragging: return nil
			case .didEndDragging: return nil
			case .didScrollToTop: return nil
			case .willBeginDecelerating: return nil
			case .didEndDecelerating: return nil
			case .willBeginZooming: return nil
			case .didEndZooming: return nil
			case .didEndScrollingAnimation: return nil
			case .willEndDragging: return nil
			case .shouldScrollToTop: return nil
			case .viewForZooming: return nil
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	open class Storage: View.Preparer.Storage, UIScrollViewDelegate {}
	
	open class Delegate: DynamicDelegate, UIScrollViewDelegate {
		public required override init() {
			super.init()
		}
		
		open var userDidScroll: SignalInput<CGPoint>?
		
		open var didEndDragging: SignalInput<(CGPoint, Bool)>?
		open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
			if !decelerate {
				userDidScroll?.send(value: scrollView.contentOffset)
			}
			didEndDragging?.send(value: (scrollView.contentOffset, decelerate))
		}
		
		open var didScrollToTop: SignalInput<Void>?
		open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
			userDidScroll?.send(value: scrollView.contentOffset)
			didScrollToTop!.send(value: ())
		}
		
		open var didEndDecelerating: SignalInput<CGPoint>?
		open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
			userDidScroll?.send(value: scrollView.contentOffset)
			didEndDecelerating?.send(value: scrollView.contentOffset)
		}
		
		open var didScroll: SignalInput<CGPoint>?
		open func scrollViewDidScroll(_ scrollView: UIScrollView) {
			didScroll?.send(value: scrollView.contentOffset)
		}
		
		open var didZoom: SignalInput<CGFloat>?
		open func scrollViewDidZoom(_ scrollView: UIScrollView) {
			didZoom!.send(value: scrollView.zoomScale)
		}
		
		open var willBeginDragging: SignalInput<CGPoint>?
		open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
			willBeginDragging!.send(value: scrollView.contentOffset)
		}
		
		open var willBeginDecelerating: SignalInput<Void>?
		open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
			willBeginDecelerating!.send(value: ())
		}
		
		open var willBeginZooming: SignalInput<CGFloat>?
		open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
			willBeginZooming!.send(value: scrollView.contentScaleFactor)
		}
		
		open var didEndZooming: SignalInput<CGFloat>?
		open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
			didEndZooming!.send(value: scale)
		}
		
		open var didEndScrollingAnimation: SignalInput<CGPoint>?
		open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
			didEndScrollingAnimation!.send(value: scrollView.contentOffset)
		}
		
		open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
			handler(ofType: ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void).self)(scrollView, velocity, targetContentOffset)
		}
		
		open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
			return handler(ofType: ((_ scrollView: UIScrollView) -> Bool).self)(scrollView)
		}
		
		open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
			return handler(ofType: ((_ scrollView: UIScrollView) -> UIView?).self)(scrollView)
		}
	}
}

extension BindingName where Binding: ScrollViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .scrollViewBinding(ScrollView.Binding.$1(v)) }) }
	public static var panGestureRecognizerStyles: BindingName<Constant<PanGestureRecognizer>, Binding> { return BindingName<Constant<PanGestureRecognizer>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.panGestureRecognizerStyles(v)) }) }
	public static var pinchGestureRecognizerStyles: BindingName<Constant<PinchGestureRecognizer>, Binding> { return BindingName<Constant<PinchGestureRecognizer>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.pinchGestureRecognizerStyles(v)) }) }
	public static var contentOffset: BindingName<Dynamic<SetOrAnimate<CGPoint>>, Binding> { return BindingName<Dynamic<SetOrAnimate<CGPoint>>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.contentOffset(v)) }) }
	public static var contentSize: BindingName<Dynamic<CGSize>, Binding> { return BindingName<Dynamic<CGSize>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.contentSize(v)) }) }
	public static var contentInset: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.contentInset(v)) }) }
	public static var isScrollEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.isScrollEnabled(v)) }) }
	public static var isDirectionalLockEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.isDirectionalLockEnabled(v)) }) }
	public static var scrollsToTop: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollsToTop(v)) }) }
	public static var isPagingEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.isPagingEnabled(v)) }) }
	public static var bounces: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.bounces(v)) }) }
	public static var alwaysBounceVertical: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.alwaysBounceVertical(v)) }) }
	public static var alwaysBounceHorizontal: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.alwaysBounceHorizontal(v)) }) }
	public static var canCancelContentTouches: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.canCancelContentTouches(v)) }) }
	public static var delaysContentTouches: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.delaysContentTouches(v)) }) }
	public static var decelerationRate: BindingName<Dynamic<UIScrollView.DecelerationRate>, Binding> { return BindingName<Dynamic<UIScrollView.DecelerationRate>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.decelerationRate(v)) }) }
	public static var indicatorStyle: BindingName<Dynamic<UIScrollView.IndicatorStyle>, Binding> { return BindingName<Dynamic<UIScrollView.IndicatorStyle>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.indicatorStyle(v)) }) }
	public static var scrollIndicatorInsets: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollIndicatorInsets(v)) }) }
	public static var showsHorizontalScrollIndicator: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.showsHorizontalScrollIndicator(v)) }) }
	public static var showsVerticalScrollIndicator: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.showsVerticalScrollIndicator(v)) }) }
	public static var zoomScale: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.zoomScale(v)) }) }
	public static var maximumZoomScale: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.maximumZoomScale(v)) }) }
	public static var minimumZoomScale: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.minimumZoomScale(v)) }) }
	public static var bouncesZoom: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.bouncesZoom(v)) }) }
	@available(iOS 10.0, *) public static var refreshControl: BindingName<Dynamic<UIRefreshControl?>, Binding> { return BindingName<Dynamic<UIRefreshControl?>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.refreshControl(v)) }) }
	public static var scrollRectToVisible: BindingName<Signal<(rect: CGRect, animated: Bool)>, Binding> { return BindingName<Signal<(rect: CGRect, animated: Bool)>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollRectToVisible(v)) }) }
	public static var zoom: BindingName<Signal<(rect: CGRect, animated: Bool)>, Binding> { return BindingName<Signal<(rect: CGRect, animated: Bool)>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.zoom(v)) }) }
	public static var flashScrollIndicators: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.flashScrollIndicators(v)) }) }
	public static var userDidScroll: BindingName<SignalInput<CGPoint>, Binding> { return BindingName<SignalInput<CGPoint>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.userDidScroll(v)) }) }
	public static var didScroll: BindingName<SignalInput<CGPoint>, Binding> { return BindingName<SignalInput<CGPoint>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didScroll(v)) }) }
	public static var didZoom: BindingName<SignalInput<CGFloat>, Binding> { return BindingName<SignalInput<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didZoom(v)) }) }
	public static var willBeginDragging: BindingName<SignalInput<CGPoint>, Binding> { return BindingName<SignalInput<CGPoint>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.willBeginDragging(v)) }) }
	public static var didEndDragging: BindingName<SignalInput<(CGPoint, Bool)>, Binding> { return BindingName<SignalInput<(CGPoint, Bool)>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didEndDragging(v)) }) }
	public static var didScrollToTop: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didScrollToTop(v)) }) }
	public static var willBeginDecelerating: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.willBeginDecelerating(v)) }) }
	public static var didEndDecelerating: BindingName<SignalInput<CGPoint>, Binding> { return BindingName<SignalInput<CGPoint>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didEndDecelerating(v)) }) }
	public static var willBeginZooming: BindingName<SignalInput<CGFloat>, Binding> { return BindingName<SignalInput<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.willBeginZooming(v)) }) }
	public static var didEndZooming: BindingName<SignalInput<CGFloat>, Binding> { return BindingName<SignalInput<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didEndZooming(v)) }) }
	public static var didEndScrollingAnimation: BindingName<SignalInput<CGPoint>, Binding> { return BindingName<SignalInput<CGPoint>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didEndScrollingAnimation(v)) }) }
	public static var willEndDragging: BindingName<(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void, Binding> { return BindingName<(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void, Binding>({ v in .scrollViewBinding(ScrollView.Binding.willEndDragging(v)) }) }
	public static var shouldScrollToTop: BindingName<(_ scrollView: UIScrollView) -> Bool, Binding> { return BindingName<(_ scrollView: UIScrollView) -> Bool, Binding>({ v in .scrollViewBinding(ScrollView.Binding.shouldScrollToTop(v)) }) }
	public static var viewForZooming: BindingName<(_ scrollView: UIScrollView) -> UIView?, Binding> { return BindingName<(_ scrollView: UIScrollView) -> UIView?, Binding>({ v in .scrollViewBinding(ScrollView.Binding.viewForZooming(v)) }) }
}

public protocol ScrollViewConvertible: ViewConvertible {
	func uiScrollView() -> ScrollView.Instance
}
extension ScrollViewConvertible {
	public func uiView() -> View.Instance { return uiScrollView() }
}
extension ScrollView.Instance: ScrollViewConvertible {
	public func uiScrollView() -> ScrollView.Instance { return self }
}

public protocol ScrollViewBinding: ViewBinding {
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self
}
extension ScrollViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return scrollViewBinding(.inheritedBinding(binding))
	}
}

#endif
