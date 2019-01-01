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

public class PageViewController<PageData>: Binder, PageViewControllerConvertible {
	public typealias Instance = UIPageViewController
	public typealias Inherited = ViewController
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiPageViewController() -> Instance { return instance() }
	
	enum Binding: PageViewControllerBinding {
		public typealias PageDataType = PageData
		
		public typealias EnclosingBinder = PageViewController
		public static func pageViewControllerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.
		case transitionStyle(Constant<UIPageViewController.TransitionStyle>)
		case navigationOrientation(Constant<UIPageViewController.NavigationOrientation>)
		case spineLocation(Constant<UIPageViewController.SpineLocation>)
		case pageSpacing(Constant<CGFloat>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case pageData(Dynamic<SetAnimatable<[PageData], UIPageViewController.NavigationDirection>>)
		case isDoubleSided(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case constructPage((PageData) -> ViewControllerConvertible)
		case willTransitionTo(([UIViewController]) -> Void)
		case didFinishAnimating((Bool, [UIViewController], Bool) -> Void)
		case spineLocationFor((UIInterfaceOrientation) -> UIPageViewController.SpineLocation)
		case supportedInterfaceOrientations(() -> UIInterfaceOrientationMask)
		case interfaceOrientationForPresentation(() -> UIInterfaceOrientation)
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = PageViewController
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
		
		var transitionStyle = UIPageViewController.TransitionStyle.scroll
		var navigationOrientation = UIPageViewController.NavigationOrientation.horizontal
		var spineLocation = UIPageViewController.SpineLocation.min
		var pageSpacing = CGFloat(0)
		var pageConstructor: ((PageData) -> ViewControllerConvertible)?
		
		mutating func prepareBinding(_ binding: PageViewController<PageData>.Binding) {
			switch binding {
			case .constructPage(let x): pageConstructor = x
			case .transitionStyle(let x): transitionStyle = x.value
			case .navigationOrientation(let x): navigationOrientation = x.value
			case .spineLocation(let x): spineLocation = x.value
			case .pageSpacing(let x): pageSpacing = x.value
			case .inheritedBinding(let x): return inherited.prepareBinding(x)
			case .willTransitionTo(let x): delegate().addHandler(x, #selector(UIPageViewControllerDelegate.pageViewController(_:willTransitionTo:)))
			case .didFinishAnimating(let x): delegate().addHandler(x, #selector(UIPageViewControllerDelegate.pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)))
			case .spineLocationFor(let x): delegate().addHandler(x, #selector(UIPageViewControllerDelegate.pageViewController(_:spineLocationFor:)))
			case .supportedInterfaceOrientations(let x): delegate().addHandler(x, #selector(UIPageViewControllerDelegate.pageViewControllerSupportedInterfaceOrientations(_:)))
			case .interfaceOrientationForPresentation(let x): delegate().addHandler(x, #selector(UIPageViewControllerDelegate.pageViewControllerPreferredInterfaceOrientationForPresentation(_:)))
			default: break
			}
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			case .pageData(let x):
				return x.apply(instance, storage) { i, s, v in
					s.changePageData(v.value, in: i, animation: v.animation)
				}
			case .isDoubleSided(let x): return x.apply(instance) { i, s, v in i.isDoubleSided = v }
			case .constructPage: return nil
			case .transitionStyle: return nil
			case .navigationOrientation: return nil
			case .spineLocation: return nil
			case .pageSpacing: return nil
			case .willTransitionTo: return nil
			case .didFinishAnimating: return nil
			case .spineLocationFor: return nil
			case .supportedInterfaceOrientations: return nil
			case .interfaceOrientationForPresentation: return nil
			}
		}
	}

	open class Storage: ViewController.Storage, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
		public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
			if let i = index(of: viewController) {
				return self.viewController(at: i - 1)
			}
			return nil
		}
		
		public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
			if let i = index(of: viewController) {
				return self.viewController(at: i + 1)
			}
			return nil
		}
		
		open var pageData: [PageData] = []
		open var activeViewControllers: [(Int, Weak<UIViewController>)] = []
		open var pageConstructor: ((PageData) -> ViewControllerConvertible)?
		
		open func changePageData(_ newPageData: [PageData], in pvc: UIPageViewController, animation: UIPageViewController.NavigationDirection?) {
			let indexes = pvc.viewControllers?.compactMap { self.index(of: $0) }.sorted() ?? (newPageData.isEmpty ? [] : [0])
			pageData = newPageData
			activeViewControllers.removeAll()
			let newViewControllers = indexes.compactMap { self.viewController(at: $0) }
			pvc.setViewControllers(newViewControllers, direction: animation ?? .forward, animated: animation != nil, completion: nil)
		}
		
		open func viewController(at: Int) -> UIViewController? {
			guard let binding = pageConstructor, pageData.indices.contains(at) else { return nil }
			var i = 0
			var match: UIViewController? = nil
			while i < activeViewControllers.count {
				let tuple = activeViewControllers[i]
				if let vc = tuple.1.value {
					if tuple.0 == at {
						match = vc
					}
					i += 1
				} else {
					activeViewControllers.remove(at: i)
				}
			}
			if let m = match {
				return m
			}
			let vc = binding(pageData[at]).uiViewController()
			activeViewControllers.append((at, Weak(vc)))
			return vc
		}
		
		open func index(of: UIViewController) -> Int? {
			var i = 0
			var match: Int? = nil
			while i < activeViewControllers.count {
				let tuple = activeViewControllers[i]
				if let vc = tuple.1.value {
					if vc === of {
						match = tuple.0
					}
					i += 1
				} else {
					activeViewControllers.remove(at: i)
				}
			}
			return match
		}
	}

	open class Delegate: DynamicDelegate, UIPageViewControllerDelegate {
		public required override init() {
			super.init()
		}
		
		open func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
			handler(ofType: (([UIViewController]) -> Void).self)!(pendingViewControllers)
		}
		
		open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
			handler(ofType: ((Bool, [UIViewController], Bool) -> Void).self)!(finished, previousViewControllers, completed)
		}
		
		open func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
			return handler(ofType: ((UIInterfaceOrientation) -> UIPageViewController.SpineLocation).self)!(orientation)
		}
		
		open func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
			return handler(ofType: (() -> UIInterfaceOrientationMask).self)!()
		}
		
		open func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
			return handler(ofType: (() -> UIInterfaceOrientation).self)!()
		}
	}
}

extension BindingName where Binding: PageViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` by copying them to here and using the following Xcode-style regex:
	// Find:    case ([^\(]+)\((.+)\)$
	// Replace: public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.$1(v)) }) }
	public static var transitionStyle: BindingName<Constant<UIPageViewController.TransitionStyle>, Binding> { return BindingName<Constant<UIPageViewController.TransitionStyle>, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.transitionStyle(v)) }) }
	public static var navigationOrientation: BindingName<Constant<UIPageViewController.NavigationOrientation>, Binding> { return BindingName<Constant<UIPageViewController.NavigationOrientation>, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.navigationOrientation(v)) }) }
	public static var spineLocation: BindingName<Constant<UIPageViewController.SpineLocation>, Binding> { return BindingName<Constant<UIPageViewController.SpineLocation>, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.spineLocation(v)) }) }
	public static var pageSpacing: BindingName<Constant<CGFloat>, Binding> { return BindingName<Constant<CGFloat>, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.pageSpacing(v)) }) }
	public static var pageData: BindingName<Dynamic<SetAnimatable<[Binding.PageDataType], UIPageViewController.NavigationDirection>>, Binding> { return BindingName<Dynamic<SetAnimatable<[Binding.PageDataType], UIPageViewController.NavigationDirection>>, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.pageData(v)) }) }
	public static var isDoubleSided: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.isDoubleSided(v)) }) }
	public static var constructPage: BindingName<(Binding.PageDataType) -> ViewControllerConvertible, Binding> { return BindingName<(Binding.PageDataType) -> ViewControllerConvertible, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.constructPage(v)) }) }
	public static var willTransitionTo: BindingName<([UIViewController]) -> Void, Binding> { return BindingName<([UIViewController]) -> Void, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.willTransitionTo(v)) }) }
	public static var didFinishAnimating: BindingName<(Bool, [UIViewController], Bool) -> Void, Binding> { return BindingName<(Bool, [UIViewController], Bool) -> Void, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.didFinishAnimating(v)) }) }
	public static var spineLocationFor: BindingName<(UIInterfaceOrientation) -> UIPageViewController.SpineLocation, Binding> { return BindingName<(UIInterfaceOrientation) -> UIPageViewController.SpineLocation, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.spineLocationFor(v)) }) }
	public static var supportedInterfaceOrientations: BindingName<() -> UIInterfaceOrientationMask, Binding> { return BindingName<() -> UIInterfaceOrientationMask, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.supportedInterfaceOrientations(v)) }) }
	public static var interfaceOrientationForPresentation: BindingName<() -> UIInterfaceOrientation, Binding> { return BindingName<() -> UIInterfaceOrientation, Binding>({ v in .pageViewControllerBinding(PageViewController.Binding.interfaceOrientationForPresentation(v)) }) }
}

public protocol PageViewControllerConvertible: ViewControllerConvertible {
	func uiPageViewController() -> UIPageViewController
}
extension PageViewControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiPageViewController() }
}
extension PageViewController.Instance: PageViewControllerConvertible {
	public func uiPageViewController() -> UIPageViewController { return self }
}

public protocol PageViewControllerBinding: ViewControllerBinding {
	associatedtype PageDataType
	static func pageViewControllerBinding(_ binding: PageViewController<PageDataType>.Binding) -> Self
}
extension PageViewControllerBinding {
	public static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return pageViewControllerBinding(.inheritedBinding(binding))
	}
}

#endif
