//
//  CwlViewController_iOS.swift
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class ViewController: Binder, ViewControllerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ViewController {
	enum Binding: ViewControllerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case navigationItem(Constant<NavigationItem>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case definesPresentationContext(Dynamic<Bool>)
		case edgesForExtendedLayout(Dynamic<UIRectEdge>)
		case extendedLayoutIncludesOpaqueBars(Dynamic<Bool>)
		case hidesBottomBarWhenPushed(Dynamic<Bool>)
		case isEditing(Signal<SetOrAnimate<Bool>>)
		case isModalInPopover(Dynamic<Bool>)
		case modalPresentationCapturesStatusBarAppearance(Dynamic<Bool>)
		case modalPresentationStyle(Dynamic<UIModalPresentationStyle>)
		case modalTransitionStyle(Dynamic<UIModalTransitionStyle>)
		case preferredContentSize(Dynamic<CGSize>)
		case providesPresentationContextTransitionStyle(Dynamic<Bool>)
		case restorationClass(Dynamic<UIViewControllerRestoration.Type?>)
		case restorationIdentifier(Dynamic<String?>)
		case tabBarItem(Dynamic<TabBarItemConvertible>)
		case title(Dynamic<String>)
		case toolbarItems(Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>)
		case transitioningDelegate(Dynamic<UIViewControllerTransitioningDelegate>)
		case view(Dynamic<ViewConvertible>)
		
		// 2. Signal bindings are performed on the object after construction.
		case present(Signal<ModalPresentation>)
		
		// 3. Action bindings are triggered by the object after construction.
		case didAppear(SignalInput<Bool>)
		case didDisappear(SignalInput<Bool>)
		case traitCollectionDidChange(SignalInput<(previous: UITraitCollection?, new: UITraitCollection)>)
		case willAppear(SignalInput<Bool>)
		case willDisappear(SignalInput<Bool>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didReceiveMemoryWarning(() -> Void)
		case loadView(() -> ViewConvertible)
	}
}

// MARK: - Binder Part 3: Preparer
public extension ViewController {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = ViewController.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = UIViewController
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		public var view: InitialSubsequent<ViewConvertible>?
		public var loadView: (() -> ViewConvertible)?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ViewController.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .view(let x):
			assert(loadView == nil, "Construct the view using either .loadView or .view, not both.")
			view = x.initialSubsequent()

		case .loadView(let x):
			assert(view == nil, "Construct the view using either .loadView or .view, not both.")
			loadView = x
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)

		// Need to set the embedded storage immediately (instead of waiting for the combine function) in case any of the swizzled methods get called (they rely on being able to access the embedded storage).
		EmbeddedObjectStorage.setEmbeddedStorage(storage, for: instance)
		
		// The loadView function needs to be ready in case one of the bindings triggers a view load.
		if let v = view?.initial?.uiView() {
			storage.view = v
		} else if let lv = loadView {
			storage.viewConstructor = lv
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .navigationItem(let x):
			x.value.apply(to: instance.navigationItem)
			return nil
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .definesPresentationContext(let x): return x.apply(instance) { i, v in i.definesPresentationContext = v }
		case .edgesForExtendedLayout(let x): return x.apply(instance) { i, v in i.edgesForExtendedLayout = v }
		case .extendedLayoutIncludesOpaqueBars(let x): return x.apply(instance) { i, v in i.extendedLayoutIncludesOpaqueBars = v }
		case .hidesBottomBarWhenPushed(let x): return x.apply(instance) { i, v in i.hidesBottomBarWhenPushed = v }
		case .isEditing(let x): return x.apply(instance) { i, v in i.setEditing(v.value, animated: v.isAnimated) }
		case .isModalInPopover(let x): return x.apply(instance) { i, v in i.isModalInPopover = v }
		case .modalPresentationCapturesStatusBarAppearance(let x): return x.apply(instance) { i, v in i.modalPresentationCapturesStatusBarAppearance = v }
		case .modalPresentationStyle(let x): return x.apply(instance) { i, v in i.modalPresentationStyle = v }
		case .modalTransitionStyle(let x): return x.apply(instance) { i, v in i.modalTransitionStyle = v }
		case .preferredContentSize(let x): return x.apply(instance) { i, v in i.preferredContentSize = v }
		case .providesPresentationContextTransitionStyle(let x): return x.apply(instance) { i, v in i.providesPresentationContextTransitionStyle = v }
		case .restorationClass(let x): return x.apply(instance) { i, v in i.restorationClass = v }
		case .restorationIdentifier(let x): return x.apply(instance) { i, v in i.restorationIdentifier = v }
		case .tabBarItem(let x): return x.apply(instance) { i, v in i.tabBarItem = v.uiTabBarItem() }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .toolbarItems(let x): return x.apply(instance) { i, v in i.setToolbarItems(v.value.map { $0.uiBarButtonItem() }, animated: v.isAnimated) }
		case .transitioningDelegate(let x): return x.apply(instance) { i, v in i.transitioningDelegate = v }
		case .view:
			return view?.apply(instance, storage) { i, s, v in
				s.view = v
				if i.isViewLoaded {
					i.view = v.uiView()
				}
			}
			
		// 2. Signal bindings are performed on the object after construction.
		case .present(let x):
			return x.apply(instance, storage) { i, s, v in
				s.queuedModalPresentations.append(v)
				s.processModalPresentations(viewController: i)
			}
			
		// 3. Action bindings are triggered by the object after construction.
		case .didAppear(let x):
			storage.didAppear = x
			return x
		case .didDisappear(let x):
			storage.didDisappear = x
			return x
		case .traitCollectionDidChange(let x):
			storage.traitCollectionDidChange = x
			return x
		case .willAppear(let x):
			storage.willAppear = x
			return x
		case .willDisappear(let x):
			storage.willDisappear = x
			return x
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .didReceiveMemoryWarning(let x):
			storage.didReceiveMemoryWarning = x
			return nil
		case .loadView: return nil
		}
	}
	
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		let lifetime = inheritedFinalizedInstance(instance, storage: storage)
		
		// Send the initial "traitsCollection" once construction is complete.
		if let tcdc = storage.traitCollectionDidChange {
			tcdc.send(value: (previous: nil, new: instance.traitCollection))
		}
		
		// We previously set the embedded storage so that any delegate methods triggered during setup would be able to resolve the storage. Now that we're done setting up, we need to *clear* the storage so the embed function doesn't complain that the storage is already set.
		EmbeddedObjectStorage.setEmbeddedStorage(nil, for: instance)
		
		return lifetime
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ViewController.Preparer {
	open class Storage: EmbeddedObjectStorage {
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
		
		open override var isInUse: Bool {
			return true
		}
		
		private static var isSwizzled: Bool = false
		private static let ensureSwizzled: () = {
			if isSwizzled {
				assertionFailure("This line should be unreachable")
				return
			}
			
			let loadViewSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.loadView))!
			let loadViewDestination = class_getInstanceMethod(ViewController.Preparer.Storage.self, #selector(ViewController.Preparer.Storage.swizzledLoadView))!
			method_exchangeImplementations(loadViewSource, loadViewDestination)
			
			let traitCollectionDidChangeSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.traitCollectionDidChange(_:)))!
			let traitCollectionDidChangeDestination = class_getInstanceMethod(ViewController.Preparer.Storage.self, #selector(ViewController.Preparer.Storage.swizzledTraitCollectionDidChange(_:)))!
			method_exchangeImplementations(traitCollectionDidChangeSource, traitCollectionDidChangeDestination)
			
			let willAppearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewWillAppear(_:)))!
			let willAppearDestination = class_getInstanceMethod(ViewController.Preparer.Storage.self, #selector(ViewController.Preparer.Storage.swizzledViewWillAppear(_:)))!
			method_exchangeImplementations(willAppearSource, willAppearDestination)
			
			let didDisappearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewDidDisappear(_:)))!
			let didDisappearDestination = class_getInstanceMethod(ViewController.Preparer.Storage.self, #selector(ViewController.Preparer.Storage.swizzledViewDidDisappear(_:)))!
			method_exchangeImplementations(didDisappearSource, didDisappearDestination)
			
			let didAppearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewDidAppear(_:)))!
			let didAppearDestination = class_getInstanceMethod(ViewController.Preparer.Storage.self, #selector(ViewController.Preparer.Storage.swizzledViewDidAppear(_:)))!
			method_exchangeImplementations(didAppearSource, didAppearDestination)
			
			let willDisappearSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewWillDisappear(_:)))!
			let willDisappearDestination = class_getInstanceMethod(ViewController.Preparer.Storage.self, #selector(ViewController.Preparer.Storage.swizzledViewWillDisappear(_:)))!
			method_exchangeImplementations(willDisappearSource, willDisappearDestination)
			
			let didReceiveMemoryWarningSource = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.didReceiveMemoryWarning))!
			let didReceiveMemoryWarningDestination = class_getInstanceMethod(ViewController.Preparer.Storage.self, #selector(ViewController.Preparer.Storage.swizzledDidReceiveMemoryWarning))!
			method_exchangeImplementations(didReceiveMemoryWarningSource, didReceiveMemoryWarningDestination)
			
			isSwizzled = true
		}()
		
		public override init() {
			ViewController.Preparer.Storage.ensureSwizzled
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
			assert(ViewController.Preparer.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Preparer.Storage. Don't access any instance members on `self`.
			if let storage = Storage.embeddedStorage(subclass: Storage.self, for: self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				if storage.loadView(for: vc) {
					return
				}
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Preparer.Storage.swizzledLoadView)
			let m = class_getMethodImplementation(ViewController.Preparer.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector) -> Void).self)(self, sel)
		}
		
		@objc dynamic private func swizzledTraitCollectionDidChange(_ previous: UITraitCollection?) {
			assert(ViewController.Preparer.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Preparer.Storage. Don't access any instance members on `self`.
			if let storage = Storage.embeddedStorage(subclass: Storage.self, for: self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.traitCollectionDidChange(previous, vc.traitCollection)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Preparer.Storage.swizzledTraitCollectionDidChange(_:))
			let m = class_getMethodImplementation(ViewController.Preparer.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, UITraitCollection?) -> Void).self)(self, sel, previous)
		}
		
		@objc dynamic private func swizzledViewWillAppear(_ animated: Bool) {
			assert(ViewController.Preparer.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Preparer.Storage. Don't access any instance members on `self`.
			if let storage = Storage.embeddedStorage(subclass: Storage.self, for: self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewWillAppear(controller: vc, animated: animated)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Preparer.Storage.swizzledViewWillAppear(_:))
			let m = class_getMethodImplementation(ViewController.Preparer.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledViewDidDisappear(_ animated: Bool) {
			assert(ViewController.Preparer.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Preparer.Storage. Don't access any instance members on `self`.
			if let storage = Storage.embeddedStorage(subclass: Storage.self, for: self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewDidDisappear(controller: vc, animated: animated)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Preparer.Storage.swizzledViewDidDisappear(_:))
			let m = class_getMethodImplementation(ViewController.Preparer.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledViewDidAppear(_ animated: Bool) {
			assert(ViewController.Preparer.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Preparer.Storage. Don't access any instance members on `self`.
			if let storage = Storage.embeddedStorage(subclass: Storage.self, for: self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewDidAppear(controller: vc, animated: animated)
				
				// Handle any modal presentation that were deferred until adding to the window
				storage.processModalPresentations(viewController: vc)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Preparer.Storage.swizzledViewDidAppear(_:))
			let m = class_getMethodImplementation(ViewController.Preparer.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledViewWillDisappear(_ animated: Bool) {
			assert(ViewController.Preparer.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Preparer.Storage. Don't access any instance members on `self`.
			if let storage = Storage.embeddedStorage(subclass: Storage.self, for: self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.viewWillDisappear(controller: vc, animated: animated)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Preparer.Storage.swizzledViewWillDisappear(_:))
			let m = class_getMethodImplementation(ViewController.Preparer.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector, Bool) -> Void).self)(self, sel, animated)
		}
		
		@objc dynamic private func swizzledDidReceiveMemoryWarning() {
			assert(ViewController.Preparer.Storage.isSwizzled)
			
			// SWIZZLED METHOD WARNING: `self` is an instance of UIViewController, not ViewController.Preparer.Storage. Don't access any instance members on `self`.
			if let storage = Storage.embeddedStorage(subclass: Storage.self, for: self) {
				let vc = unsafeBitCast(self, to: UIViewController.self)
				storage.controllerDidReceiveMemoryWarning(controller: vc)
			}
			
			// Relay back to the original implementation
			let sel = #selector(ViewController.Preparer.Storage.swizzledDidReceiveMemoryWarning)
			let m = class_getMethodImplementation(ViewController.Preparer.Storage.self, sel)!
			unsafeBitCast(m, to: (@convention(c) (NSObjectProtocol, Selector) -> Void).self)(self, sel)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ViewControllerBinding {
	public typealias ViewControllerName<V> = BindingName<V, ViewController.Binding, Binding>
	private typealias B = ViewController.Binding
	private static func name<V>(_ source: @escaping (V) -> ViewController.Binding) -> ViewControllerName<V> {
		return ViewControllerName<V>(source: source, downcast: Binding.viewControllerBinding)
	}
}
public extension BindingName where Binding: ViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ViewControllerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var navigationItem: ViewControllerName<Constant<NavigationItem>> { return .name(B.navigationItem) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var definesPresentationContext: ViewControllerName<Dynamic<Bool>> { return .name(B.definesPresentationContext) }
	static var edgesForExtendedLayout: ViewControllerName<Dynamic<UIRectEdge>> { return .name(B.edgesForExtendedLayout) }
	static var extendedLayoutIncludesOpaqueBars: ViewControllerName<Dynamic<Bool>> { return .name(B.extendedLayoutIncludesOpaqueBars) }
	static var hidesBottomBarWhenPushed: ViewControllerName<Dynamic<Bool>> { return .name(B.hidesBottomBarWhenPushed) }
	static var isEditing: ViewControllerName<Signal<SetOrAnimate<Bool>>> { return .name(B.isEditing) }
	static var isModalInPopover: ViewControllerName<Dynamic<Bool>> { return .name(B.isModalInPopover) }
	static var modalPresentationCapturesStatusBarAppearance: ViewControllerName<Dynamic<Bool>> { return .name(B.modalPresentationCapturesStatusBarAppearance) }
	static var modalPresentationStyle: ViewControllerName<Dynamic<UIModalPresentationStyle>> { return .name(B.modalPresentationStyle) }
	static var modalTransitionStyle: ViewControllerName<Dynamic<UIModalTransitionStyle>> { return .name(B.modalTransitionStyle) }
	static var preferredContentSize: ViewControllerName<Dynamic<CGSize>> { return .name(B.preferredContentSize) }
	static var providesPresentationContextTransitionStyle: ViewControllerName<Dynamic<Bool>> { return .name(B.providesPresentationContextTransitionStyle) }
	static var restorationClass: ViewControllerName<Dynamic<UIViewControllerRestoration.Type?>> { return .name(B.restorationClass) }
	static var restorationIdentifier: ViewControllerName<Dynamic<String?>> { return .name(B.restorationIdentifier) }
	static var tabBarItem: ViewControllerName<Dynamic<TabBarItemConvertible>> { return .name(B.tabBarItem) }
	static var title: ViewControllerName<Dynamic<String>> { return .name(B.title) }
	static var toolbarItems: ViewControllerName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> { return .name(B.toolbarItems) }
	static var transitioningDelegate: ViewControllerName<Dynamic<UIViewControllerTransitioningDelegate>> { return .name(B.transitioningDelegate) }
	static var view: ViewControllerName<Dynamic<ViewConvertible>> { return .name(B.view) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var present: ViewControllerName<Signal<ModalPresentation>> { return .name(B.present) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didAppear: ViewControllerName<SignalInput<Bool>> { return .name(B.didAppear) }
	static var didDisappear: ViewControllerName<SignalInput<Bool>> { return .name(B.didDisappear) }
	static var traitCollectionDidChange: ViewControllerName<SignalInput<(previous: UITraitCollection?, new: UITraitCollection)>> { return .name(B.traitCollectionDidChange) }
	static var willAppear: ViewControllerName<SignalInput<Bool>> { return .name(B.willAppear) }
	static var willDisappear: ViewControllerName<SignalInput<Bool>> { return .name(B.willDisappear) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var didReceiveMemoryWarning: ViewControllerName<() -> Void> { return .name(B.didReceiveMemoryWarning) }
	static var loadView: ViewControllerName<() -> ViewConvertible> { return .name(B.loadView) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ViewControllerConvertible {
	func uiViewController() -> ViewController.Instance
}
extension UIViewController: ViewControllerConvertible, DefaultConstructable {
	public func uiViewController() -> ViewController.Instance { return self }
}
public extension ViewController {
	func uiViewController() -> ViewController.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ViewControllerBinding: BinderBaseBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self
}
public extension ViewControllerBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return viewControllerBinding(.inheritedBinding(binding))
	}
}
public extension ViewController.Binding {
	public typealias Preparer = ViewController.Preparer
	static func viewControllerBinding(_ binding: ViewController.Binding) -> ViewController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
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

#endif
