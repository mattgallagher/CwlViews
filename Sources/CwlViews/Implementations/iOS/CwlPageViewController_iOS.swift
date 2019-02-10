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

// MARK: - Binder Part 1: Binder
public class PageViewController<PageData>: Binder, PageViewControllerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension PageViewController {
	enum Binding: PageViewControllerBinding {
		public typealias PageDataType = PageData
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.
		case navigationOrientation(Constant<UIPageViewController.NavigationOrientation>)
		case pageSpacing(Constant<CGFloat>)
		case spineLocation(Constant<UIPageViewController.SpineLocation>)
		case transitionStyle(Constant<UIPageViewController.TransitionStyle>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case isDoubleSided(Dynamic<Bool>)
		case pageData(Dynamic<SetAnimatable<[PageData], UIPageViewController.NavigationDirection>>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case constructPage((PageData) -> ViewControllerConvertible)
		case didFinishAnimating((Bool, [UIViewController], Bool) -> Void)
		case interfaceOrientationForPresentation(() -> UIInterfaceOrientation)
		case spineLocationFor((UIInterfaceOrientation) -> UIPageViewController.SpineLocation)
		case supportedInterfaceOrientations(() -> UIInterfaceOrientationMask)
		case willTransitionTo(([UIViewController]) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension PageViewController {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = PageViewController.Binding
		public typealias Inherited = ViewController.Preparer
		public typealias Instance = UIPageViewController
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var transitionStyle = UIPageViewController.TransitionStyle.scroll
		var navigationOrientation = UIPageViewController.NavigationOrientation.horizontal
		var spineLocation = UIPageViewController.SpineLocation.min
		var pageSpacing = CGFloat(0)
		var pageConstructor: ((PageData) -> ViewControllerConvertible)?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension PageViewController.Preparer {
	mutating func prepareBinding(_ binding: PageViewController<PageData>.Binding) {
		switch binding {
		case .inheritedBinding(let x): return inherited.prepareBinding(x)
		
		case .constructPage(let x): pageConstructor = x
		case .transitionStyle(let x): transitionStyle = x.value
		case .navigationOrientation(let x): navigationOrientation = x.value
		case .spineLocation(let x): spineLocation = x.value
		case .pageSpacing(let x): pageSpacing = x.value
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
		
		// 0. Static bindings are applied at construction and are subsequently immutable.
		case .navigationOrientation: return nil
		case .pageSpacing: return nil
		case .spineLocation: return nil
		case .transitionStyle: return nil

		// 1. Value bindings may be applied at construction and may subsequently change.
		case .isDoubleSided(let x): return x.apply(instance) { i, v in i.isDoubleSided = v }
		case .pageData(let x):
			return x.apply(instance, storage) { i, s, v in
				s.changePageData(v.value, in: i, animation: v.animation)
			}

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .constructPage: return nil
		case .didFinishAnimating: return nil
		case .interfaceOrientationForPresentation: return nil
		case .spineLocationFor: return nil
		case .supportedInterfaceOrientations: return nil
		case .willTransitionTo: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PageViewController.Preparer {
	open class Storage: ViewController.Preparer.Storage, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
		open var activeViewControllers: [(Int, Weak<UIViewController>)] = []
		open var pageConstructor: ((PageData) -> ViewControllerConvertible)?
		open var pageData: [PageData] = []
		
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

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: PageViewControllerBinding {
	public typealias PageViewControllerName<V> = BindingName<V, PageViewController<Binding.PageDataType>.Binding, Binding>
	private typealias B = PageViewController<Binding.PageDataType>.Binding
	private static func name<V>(_ source: @escaping (V) -> PageViewController<Binding.PageDataType>.Binding) -> PageViewControllerName<V> {
		return PageViewControllerName<V>(source: source, downcast: Binding.pageViewControllerBinding)
	}
}
public extension BindingName where Binding: PageViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: PageViewControllerName<$2> { return .name(B.$1) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	static var navigationOrientation: PageViewControllerName<Constant<UIPageViewController.NavigationOrientation>> { return .name(B.navigationOrientation) }
	static var pageSpacing: PageViewControllerName<Constant<CGFloat>> { return .name(B.pageSpacing) }
	static var spineLocation: PageViewControllerName<Constant<UIPageViewController.SpineLocation>> { return .name(B.spineLocation) }
	static var transitionStyle: PageViewControllerName<Constant<UIPageViewController.TransitionStyle>> { return .name(B.transitionStyle) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var isDoubleSided: PageViewControllerName<Dynamic<Bool>> { return .name(B.isDoubleSided) }
	static var pageData: PageViewControllerName<Dynamic<SetAnimatable<[Binding.PageDataType], UIPageViewController.NavigationDirection>>> { return .name(B.pageData) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var constructPage: PageViewControllerName<(Binding.PageDataType) -> ViewControllerConvertible> { return .name(B.constructPage) }
	static var didFinishAnimating: PageViewControllerName<(Bool, [UIViewController], Bool) -> Void> { return .name(B.didFinishAnimating) }
	static var interfaceOrientationForPresentation: PageViewControllerName<() -> UIInterfaceOrientation> { return .name(B.interfaceOrientationForPresentation) }
	static var spineLocationFor: PageViewControllerName<(UIInterfaceOrientation) -> UIPageViewController.SpineLocation> { return .name(B.spineLocationFor) }
	static var supportedInterfaceOrientations: PageViewControllerName<() -> UIInterfaceOrientationMask> { return .name(B.supportedInterfaceOrientations) }
	static var willTransitionTo: PageViewControllerName<([UIViewController]) -> Void> { return .name(B.willTransitionTo) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol PageViewControllerConvertible: ViewControllerConvertible {
	func uiPageViewController() -> UIPageViewController
}
extension PageViewControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiPageViewController() }
}
extension UIPageViewController: PageViewControllerConvertible, HasDelegate {
	public func uiPageViewController() -> UIPageViewController { return self }
}
public extension PageViewController {
	func uiPageViewController() -> UIPageViewController { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol PageViewControllerBinding: ViewControllerBinding {
	associatedtype PageDataType
	static func pageViewControllerBinding(_ binding: PageViewController<PageDataType>.Binding) -> Self
}
public extension PageViewControllerBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return pageViewControllerBinding(PageViewController<PageDataType>.Binding.inheritedBinding(binding))
	}
}
public extension PageViewController.Binding {
	typealias Preparer = PageViewController.Preparer
	static func pageViewControllerBinding(_ binding: PageViewController<PageDataType>.Binding) -> PageViewController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
