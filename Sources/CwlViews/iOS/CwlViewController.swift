//
//  CwlViewController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/13.
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

public class ViewController: ConstructingBinder, ViewControllerConvertible {
	public typealias Instance = UIViewController
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiViewController() -> Instance { return instance() }
	
	public enum Binding: ViewControllerBinding {
		public typealias EnclosingBinder = ViewController
		public static func viewControllerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case navigationItem(Constant<NavigationItem>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case view(Dynamic<ViewConvertible>)
		case title(Dynamic<String>)
		case preferredContentSize(Dynamic<CGSize>)
		case modalPresentationStyle(Dynamic<UIModalPresentationStyle>)
		case modalTransitionStyle(Dynamic<UIModalTransitionStyle>)
		case isModalInPopover(Dynamic<Bool>)
		case definesPresentationContext(Dynamic<Bool>)
		case providesPresentationContextTransitionStyle(Dynamic<Bool>)
		case transitioningDelegate(Dynamic<UIViewControllerTransitioningDelegate>)
		case edgesForExtendedLayout(Dynamic<UIRectEdge>)
		case extendedLayoutIncludesOpaqueBars(Dynamic<Bool>)
		case restorationIdentifier(Dynamic<String?>)
		case restorationClass(Dynamic<UIViewControllerRestoration.Type?>)
		case modalPresentationCapturesStatusBarAppearance(Dynamic<Bool>)
		case hidesBottomBarWhenPushed(Dynamic<Bool>)
		case toolbarItems(Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>)
		case tabBarItem(Dynamic<TabBarItemConvertible>)
		case isEditing(Signal<SetOrAnimate<Bool>>)
		
		// 2. Signal bindings are performed on the object after construction.
		case present(Signal<ModalPresentation>)
		
		// 3. Action bindings are triggered by the object after construction.
		case traitCollectionDidChange(SignalInput<(previous: UITraitCollection?, new: UITraitCollection)>)
		case willAppear(SignalInput<Bool>)
		case didAppear(SignalInput<Bool>)
		case didDisappear(SignalInput<Bool>)
		case willDisappear(SignalInput<Bool>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case loadView(() -> ViewConvertible)
		case didReceiveMemoryWarning(() -> Void)
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = ViewController
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(nibName: nil, bundle: nil) }
		
		public init() {}
		
		public var view: InitialSubsequent<ViewConvertible>?
		public var loadView: (() -> ViewConvertible)?
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .loadView(let x):
				assert(view == nil, "Construct the view using either .loadView or .view, not both.")
				loadView = x
			case .view(let x):
				assert(loadView == nil, "Construct the view using either .loadView or .view, not both.")
				view = x.initialSubsequent()
			case .inheritedBinding(let preceeding): linkedPreparer.prepareBinding(preceeding)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			// The loadView function needs to be ready in case one of the bindings triggers a view load.
			if let v = view?.initial() {
				storage.view = v
				instance.setBinderStorage(storage)
			} else if let lv = loadView {
				storage.viewConstructor = lv
				instance.setBinderStorage(storage)
			}
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .loadView: return nil
			case .view:
				return view?.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in
					storage.view = v
					if i.isViewLoaded {
						i.view = v.uiView()
					}
				} }
			case .title(let x): return x.apply(instance, storage) { i, s, v in i.title = v }
			case .preferredContentSize(let x): return x.apply(instance, storage) { i, s, v in i.preferredContentSize = v }
			case .modalPresentationStyle(let x): return x.apply(instance, storage) { i, s, v in i.modalPresentationStyle = v }
			case .modalTransitionStyle(let x): return x.apply(instance, storage) { i, s, v in i.modalTransitionStyle = v }
			case .isModalInPopover(let x): return x.apply(instance, storage) { i, s, v in i.isModalInPopover = v }
			case .definesPresentationContext(let x): return x.apply(instance, storage) { i, s, v in i.definesPresentationContext = v }
			case .providesPresentationContextTransitionStyle(let x): return x.apply(instance, storage) { i, s, v in i.providesPresentationContextTransitionStyle = v }
			case .transitioningDelegate(let x): return x.apply(instance, storage) { i, s, v in i.transitioningDelegate = v }
			case .edgesForExtendedLayout(let x): return x.apply(instance, storage) { i, s, v in i.edgesForExtendedLayout = v }
			case .extendedLayoutIncludesOpaqueBars(let x): return x.apply(instance, storage) { i, s, v in i.extendedLayoutIncludesOpaqueBars = v }
			case .restorationIdentifier(let x): return x.apply(instance, storage) { i, s, v in i.restorationIdentifier = v }
			case .restorationClass(let x): return x.apply(instance, storage) { i, s, v in i.restorationClass = v }
			case .modalPresentationCapturesStatusBarAppearance(let x): return x.apply(instance, storage) { i, s, v in i.modalPresentationCapturesStatusBarAppearance = v }
			case .hidesBottomBarWhenPushed(let x): return x.apply(instance, storage) { i, s, v in i.hidesBottomBarWhenPushed = v }
			case .toolbarItems(let x): return x.apply(instance, storage) { i, s, v in i.setToolbarItems(v.value.map { $0.uiBarButtonItem() }, animated: v.isAnimated) }
			case .tabBarItem(let x): return x.apply(instance, storage) { i, s, v in i.tabBarItem = v.uiTabBarItem() }
			case .isEditing(let x): return x.apply(instance, storage) { i, s, v in i.setEditing(v.value, animated: v.isAnimated) }
			case .present(let x):
				return x.apply(instance, storage) { i, s, v in
					s.queuedModalPresentations.append(v)
					s.processModalPresentations(viewController: i)
				}
			case .navigationItem(let x):
				x.value.applyBindings(to: instance.navigationItem)
				return nil
			case .traitCollectionDidChange(let x):
				storage.traitCollectionDidChange = x
				return x
			case .willAppear(let x):
				storage.willAppear = x
				return x
			case .didDisappear(let x):
				storage.didDisappear = x
				return x
			case .didAppear(let x):
				storage.didAppear = x
				return x
			case .willDisappear(let x):
				storage.willDisappear = x
				return x
			case .didReceiveMemoryWarning(let x):
				storage.didReceiveMemoryWarning = x
				return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: (), storage: ())
			}
		}
		
		public mutating func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
			let lifetime = linkedPreparer.finalizeInstance((), storage: ())
			
			// Send the initial "traitsCollection" once construction is complete.
			if let tcdc = storage.traitCollectionDidChange {
				tcdc.send(value: (previous: nil, new: instance.traitCollection))
			}
			return lifetime
		}
	}
	
	open class Storage: ObjectBinderStorage {
		open var traitCollectionDidChange: SignalInput<(previous: UITraitCollection?, new: UITraitCollection)>?
		open var didDisappear: SignalInput<Bool>?
		open var willAppear: SignalInput<Bool>?
		open var willDisappear: SignalInput<Bool>?
		open var didAppear: SignalInput<Bool>?
		open var queuedModalPresentations: [ModalPresentation] = []
		open var presentationInProgress: Bool = false
		open var view: ViewConvertible?
		open var viewConstructor: (() -> ViewConvertible?)?
		open var didReceiveMemoryWarning: (() -> Void)?
		
		open override var inUse: Bool {
			return super.inUse || view != nil || viewConstructor != nil || didReceiveMemoryWarning != nil
		}
		
		private static var isSwizzled: Bool = false
		private static let ensureSwizzled: () = {
			if isSwizzled {
				assertionFailure("This line should be unreachable")
				return
			}
			
			let loadViewSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.loadView))!
			let loadViewDestination = class_getInstanceMethod(ViewController.Storage.self, #selector(ViewController.Storage.swizzledLoadView))!
			method_exchangeImplementations(loadViewSource, loadViewDestination)
			
			let traitCollectionDidChangeSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.traitCollectionDidChange(_:)))!
			let traitCollectionDidChangeDestination = class_getInstanceMethod(ViewController.Storage.self, #selector(ViewController.Storage.swizzledTraitCollectionDidChange(_:)))!
			method_exchangeImplementations(traitCollectionDidChangeSource, traitCollectionDidChangeDestination)
			
			let willAppearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewWillAppear(_:)))!
			let willAppearDestination = class_getInstanceMethod(ViewController.Storage.self, #selector(ViewController.Storage.swizzledViewWillAppear(_:)))!
			method_exchangeImplementations(willAppearSource, willAppearDestination)
			
			let didDisappearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewDidDisappear(_:)))!
			let didDisappearDestination = class_getInstanceMethod(ViewController.Storage.self, #selector(ViewController.Storage.swizzledViewDidDisappear(_:)))!
			method_exchangeImplementations(didDisappearSource, didDisappearDestination)
			
			let didAppearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewDidAppear(_:)))!
			let didAppearDestination = class_getInstanceMethod(ViewController.Storage.self, #selector(ViewController.Storage.swizzledViewDidAppear(_:)))!
			method_exchangeImplementations(didAppearSource, didAppearDestination)
			
			let willDisappearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewWillDisappear(_:)))!
			let willDisappearDestination = class_getInstanceMethod(ViewController.Storage.self, #selector(ViewController.Storage.swizzledViewWillDisappear(_:)))!
			method_exchangeImplementations(willDisappearSource, willDisappearDestination)
			
			let didReceiveMemoryWarningSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.didReceiveMemoryWarning))!
			let didReceiveMemoryWarningDestination = class_getInstanceMethod(ViewController.Storage.self, #selector(ViewController.Storage.swizzledDidReceiveMemoryWarning))!
			method_exchangeImplementations(didReceiveMemoryWarningSource, didReceiveMemoryWarningDestination)
			
			isSwizzled = true
		}()
		
		public override init() {
			ViewController.Storage.ensureSwizzled
			super.init()
		}
		
		open func processModalPresentations(viewController: UIViewController) {
			if presentationInProgress {
				return
			}
			if let mp = queuedModalPresentations.first {
				if let vc = mp.viewController {
					guard viewController.view.window != nil else {
						presentationInProgress = false
						return
					}
					presentationInProgress = true
					viewController.present(vc.uiViewController(), animated: mp.animated) {
						mp.completion?.send(value: ())
						self.queuedModalPresentations.removeFirst()
						self.presentationInProgress = false
						self.processModalPresentations(viewController: viewController)
					}
				} else {
					presentationInProgress = true
					if let vc = viewController.presentedViewController, !vc.isBeingDismissed {
						vc.dismiss(animated: mp.animated, completion: { () -> Void in
							mp.completion?.send(value: ())
							self.queuedModalPresentations.removeFirst()
							self.presentationInProgress = false
							self.processModalPresentations(viewController: viewController)
						})
					} else {
						mp.completion?.send(value: ())
						self.queuedModalPresentations.removeFirst()
						self.presentationInProgress = false
						self.processModalPresentations(viewController: viewController)
					}
				}
			}
		}
		
		open func traitCollectionDidChange(_ previous: UITraitCollection?, _ new: UITraitCollection) {
			traitCollectionDidChange?.send(value: (previous: previous, new: new))
		}
		
		open func viewWillAppear(controller: UIViewController, animated: Bool) {
			willAppear?.send(value: animated)
		}
		
		open func viewDidDisappear(controller: UIViewController, animated: Bool) {
			didDisappear?.send(value: animated)
		}
		
		open func viewDidAppear(controller: UIViewController, animated: Bool) {
			didAppear?.send(value: animated)
		}
		
		open func viewWillDisappear(controller: UIViewController, animated: Bool) {
			willDisappear?.send(value: animated)
		}
		
		open func controllerDidReceiveMemoryWarning(controller: UIViewController) {
			didReceiveMemoryWarning?()
			
			if viewConstructor != nil, let view = controller.viewIfLoaded, view.window == nil {
				controller.view = nil
			}
		}
		
		open func loadView(for viewController: UIViewController) -> Bool {
			if let wrapper = view ?? viewConstructor?() {
				viewController.view = wrapper.uiView()
				return true
			}
			return false
		}
		
		@objc dynamic private func swizzledLoadView() {
			assert(ViewController.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Storage. Don't access any instance members on `self`.
			if let storage = getBinderStorage(type: ViewController.Storage.self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				
				if storage.loadView(for: vc) {
					return
				}
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Storage.swizzledLoadView)
			let m = class_getMethodImplementation(ViewController.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector) -> Void).self)(self, sel)
		}
		
		@objc dynamic private func swizzledTraitCollectionDidChange(_ previous: UITraitCollection?) {
			assert(ViewController.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Storage. Don't access any instance members on `self`.
			if let storage = getBinderStorage(type: ViewController.Storage.self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.traitCollectionDidChange(previous, vc.traitCollection)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Storage.swizzledTraitCollectionDidChange(_:))
			let m = class_getMethodImplementation(ViewController.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, UITraitCollection?) -> Void).self)(self, sel, previous)
		}
		
		@objc dynamic private func swizzledViewWillAppear(_ animated: Bool) {
			assert(ViewController.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Storage. Don't access any instance members on `self`.
			if let storage = getBinderStorage(type: ViewController.Storage.self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewWillAppear(controller: vc, animated: animated)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Storage.swizzledViewWillAppear(_:))
			let m = class_getMethodImplementation(ViewController.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledViewDidDisappear(_ animated: Bool) {
			assert(ViewController.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Storage. Don't access any instance members on `self`.
			if let storage = getBinderStorage(type: ViewController.Storage.self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewDidDisappear(controller: vc, animated: animated)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Storage.swizzledViewDidDisappear(_:))
			let m = class_getMethodImplementation(ViewController.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledViewDidAppear(_ animated: Bool) {
			assert(ViewController.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Storage. Don't access any instance members on `self`.
			if let storage = getBinderStorage(type: ViewController.Storage.self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewDidAppear(controller: vc, animated: animated)
				
				// Handle any modal presentation that were deferred until adding to the window
				storage.processModalPresentations(viewController: vc)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Storage.swizzledViewDidAppear(_:))
			let m = class_getMethodImplementation(ViewController.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledViewWillDisappear(_ animated: Bool) {
			assert(ViewController.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Storage. Don't access any instance members on `self`.
			if let storage = getBinderStorage(type: ViewController.Storage.self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewWillDisappear(controller: vc, animated: animated)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Storage.swizzledViewWillDisappear(_:))
			let m = class_getMethodImplementation(ViewController.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledDidReceiveMemoryWarning() {
			assert(ViewController.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Storage. Don't access any instance members on `self`.
			if let storage = getBinderStorage(type: ViewController.Storage.self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.controllerDidReceiveMemoryWarning(controller: vc)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Storage.swizzledDidReceiveMemoryWarning)
			let m = class_getMethodImplementation(ViewController.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector) -> Void).self)(self, sel)
		}
	}
}

extension BindingName where Binding: ViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .viewControllerBinding(ViewController.Binding.$1(v)) }) }
	public static var view: BindingName<Dynamic<ViewConvertible>, Binding> { return BindingName<Dynamic<ViewConvertible>, Binding>({ v in .viewControllerBinding(ViewController.Binding.view(v)) }) }
	public static var navigationItem: BindingName<Constant<NavigationItem>, Binding> { return BindingName<Constant<NavigationItem>, Binding>({ v in .viewControllerBinding(ViewController.Binding.navigationItem(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .viewControllerBinding(ViewController.Binding.title(v)) }) }
	public static var preferredContentSize: BindingName<Dynamic<CGSize>, Binding> { return BindingName<Dynamic<CGSize>, Binding>({ v in .viewControllerBinding(ViewController.Binding.preferredContentSize(v)) }) }
	public static var modalPresentationStyle: BindingName<Dynamic<UIModalPresentationStyle>, Binding> { return BindingName<Dynamic<UIModalPresentationStyle>, Binding>({ v in .viewControllerBinding(ViewController.Binding.modalPresentationStyle(v)) }) }
	public static var modalTransitionStyle: BindingName<Dynamic<UIModalTransitionStyle>, Binding> { return BindingName<Dynamic<UIModalTransitionStyle>, Binding>({ v in .viewControllerBinding(ViewController.Binding.modalTransitionStyle(v)) }) }
	public static var isModalInPopover: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.isModalInPopover(v)) }) }
	public static var definesPresentationContext: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.definesPresentationContext(v)) }) }
	public static var providesPresentationContextTransitionStyle: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.providesPresentationContextTransitionStyle(v)) }) }
	public static var transitioningDelegate: BindingName<Dynamic<UIViewControllerTransitioningDelegate>, Binding> { return BindingName<Dynamic<UIViewControllerTransitioningDelegate>, Binding>({ v in .viewControllerBinding(ViewController.Binding.transitioningDelegate(v)) }) }
	public static var edgesForExtendedLayout: BindingName<Dynamic<UIRectEdge>, Binding> { return BindingName<Dynamic<UIRectEdge>, Binding>({ v in .viewControllerBinding(ViewController.Binding.edgesForExtendedLayout(v)) }) }
	public static var extendedLayoutIncludesOpaqueBars: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.extendedLayoutIncludesOpaqueBars(v)) }) }
	public static var restorationIdentifier: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .viewControllerBinding(ViewController.Binding.restorationIdentifier(v)) }) }
	public static var restorationClass: BindingName<Dynamic<UIViewControllerRestoration.Type?>, Binding> { return BindingName<Dynamic<UIViewControllerRestoration.Type?>, Binding>({ v in .viewControllerBinding(ViewController.Binding.restorationClass(v)) }) }
	public static var modalPresentationCapturesStatusBarAppearance: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.modalPresentationCapturesStatusBarAppearance(v)) }) }
	public static var hidesBottomBarWhenPushed: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.hidesBottomBarWhenPushed(v)) }) }
	public static var toolbarItems: BindingName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding> { return BindingName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding>({ v in .viewControllerBinding(ViewController.Binding.toolbarItems(v)) }) }
	public static var tabBarItem: BindingName<Dynamic<TabBarItemConvertible>, Binding> { return BindingName<Dynamic<TabBarItemConvertible>, Binding>({ v in .viewControllerBinding(ViewController.Binding.tabBarItem(v)) }) }
	public static var isEditing: BindingName<Signal<SetOrAnimate<Bool>>, Binding> { return BindingName<Signal<SetOrAnimate<Bool>>, Binding>({ v in .viewControllerBinding(ViewController.Binding.isEditing(v)) }) }
	public static var present: BindingName<Signal<ModalPresentation>, Binding> { return BindingName<Signal<ModalPresentation>, Binding>({ v in .viewControllerBinding(ViewController.Binding.present(v)) }) }
	public static var traitCollectionDidChange: BindingName<SignalInput<(previous: UITraitCollection?, new: UITraitCollection)>, Binding> { return BindingName<SignalInput<(previous: UITraitCollection?, new: UITraitCollection)>, Binding>({ v in .viewControllerBinding(ViewController.Binding.traitCollectionDidChange(v)) }) }
	public static var willAppear: BindingName<SignalInput<Bool>, Binding> { return BindingName<SignalInput<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.willAppear(v)) }) }
	public static var didAppear: BindingName<SignalInput<Bool>, Binding> { return BindingName<SignalInput<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.didAppear(v)) }) }
	public static var didDisappear: BindingName<SignalInput<Bool>, Binding> { return BindingName<SignalInput<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.didDisappear(v)) }) }
	public static var willDisappear: BindingName<SignalInput<Bool>, Binding> { return BindingName<SignalInput<Bool>, Binding>({ v in .viewControllerBinding(ViewController.Binding.willDisappear(v)) }) }
	public static var loadView: BindingName<() -> ViewConvertible, Binding> { return BindingName<() -> ViewConvertible, Binding>({ v in .viewControllerBinding(ViewController.Binding.loadView(v)) }) }
}

public protocol ViewControllerConvertible {
	func uiViewController() -> ViewController.Instance
}
extension ViewController.Instance: ViewControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return self }
}

public protocol ViewControllerBinding: BaseBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self
}
extension ViewControllerBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return viewControllerBinding(.inheritedBinding(binding))
	}
}

public struct ModalPresentation {
	let viewController: ViewControllerConvertible?
	let animated: Bool
	let completion: SignalInput<Void>?
	
	public init(_ viewController: ViewControllerConvertible? = nil, animated: Bool = true, completion: SignalInput<Void>? = nil) {
		self.viewController = viewController
		self.animated = animated
		self.completion = completion
	}
}

extension SignalInterface {
	public func modalPresentation<T>(_ construct: @escaping (T) -> ViewControllerConvertible) -> Signal<ModalPresentation> where OutputValue == Optional<T> {
		return transform { (result, next) in
			switch result {
			case .success(.some(let t)): next.send(value: ModalPresentation(construct(t)))
			case .success: next.send(value: ModalPresentation(nil))
			case .failure(let e): next.send(error: e)
			}
		}
	}
}
