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
		case additionalSafeAreaInsets(Dynamic<UIEdgeInsets>)
		case children(Dynamic<[ViewControllerConvertible]>)
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
		case present(Signal<Animatable<ModalPresentation?, ()>>)
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case childrenLayout(([UIView]) -> Layout)
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
		
		public var childrenLayout: (([UIView]) -> Layout)?
		public var view: InitialSubsequent<ViewConvertible>?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ViewController.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .childrenLayout(let x): childrenLayout = x
		case .view(let x): view = x.initialSubsequent()
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)

		// Need to set the embedded storage immediately (instead of waiting for the combine function) in case any of the swizzled methods get called (they rely on being able to access the embedded storage).
		instance.setAssociatedBinderStorage(storage)
		
		// The loadView function needs to be ready in case one of the bindings triggers a view load.
		if let v = view?.initial?.uiView() {
			instance.view = v
		}
		
		// The childrenLayout should be ready for when the children property starts
		storage.childrenLayout = childrenLayout
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .navigationItem(let x):
			x.value.apply(to: instance.navigationItem)
			return nil
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .additionalSafeAreaInsets(let x): return x.apply(instance) { i, v in i.additionalSafeAreaInsets = v }
		case .children(let x):
			return x.apply(instance, storage) { i, s, v in
				let existing = i.children
				let next = v.map { $0.uiViewController() }
				
				for e in existing {
					if !next.contains(e) {
						e.willMove(toParent: nil)
					}
				}
				for n in next {
					if !existing.contains(n) {
						i.addChild(n)
					}
				}
				(storage.childrenLayout?(next.map { $0.view })).map(i.view.applyLayout)
				for n in next {
					if !existing.contains(n) {
						n.didMove(toParent: i)
					}
				}
				for e in existing {
					if !next.contains(e) {
						e.removeFromParent()
					}
				}
			}
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
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .childrenLayout: return nil
		}
	}
	
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		let lifetime = inheritedFinalizedInstance(instance, storage: storage)
		
		// We previously set the embedded storage so that any delegate methods triggered during setup would be able to resolve the storage. Now that we're done setting up, we need to *clear* the storage so the embed function doesn't complain that the storage is already set.
		instance.setAssociatedBinderStorage(nil)
		
		return lifetime
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ViewController.Preparer {
	private static var presenterKey = NSObject()
	
	open class Storage: AssociatedBinderStorage, UIPopoverPresentationControllerDelegate {
		open var view: ViewConvertible?
		open var childrenLayout: (([UIView]) -> Layout)?
		
		open var presentationAnimationInProgress: Bool = false
		open var currentModalPresentation: ModalPresentation? = nil
		open var queuedModalPresentations: [Animatable<ModalPresentation?, ()>] = []
		
		open override var isInUse: Bool {
			return true
		}
		
		private func presentationDismissed(viewController: UIViewController) {
			currentModalPresentation?.completion?.send(value: ())
			currentModalPresentation = nil
			processModalPresentations(viewController: viewController)
		}
		
		private func presentationAnimationCompleted(viewController: UIViewController, dismissed: Bool) {
			self.queuedModalPresentations.removeFirst()
			self.presentationAnimationInProgress = false
			if dismissed {
				presentationDismissed(viewController: viewController)
			}
		}
		
		open func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
			presentationDismissed(viewController: popoverPresentationController.presentingViewController)
		}
		
		private func present(viewController: UIViewController, modalPresentation: ModalPresentation, animated: Bool) {
			presentationAnimationInProgress = true
			currentModalPresentation = modalPresentation
			let presentation = modalPresentation.viewController.uiViewController()
			if let popover = presentation.popoverPresentationController, let configure = modalPresentation.popoverPositioning {
				configure(viewController, popover)
				popover.delegate = self
			} else if let presenter = presentation.presentationController {
				objc_setAssociatedObject(presenter, &presenterKey, OnDelete {
					guard presentation === self.currentModalPresentation?.viewController.uiViewController() else { return }
					self.presentationDismissed(viewController: viewController)
				}, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
			viewController.present(presentation, animated: animated) {
				self.presentationAnimationCompleted(viewController: viewController, dismissed: false)
			}
		}
		
		private func dismiss(viewController: UIViewController, animated: Bool) {
			presentationAnimationInProgress = true
			guard let vc = viewController.presentedViewController else {
				self.presentationAnimationCompleted(viewController: viewController, dismissed: true)
				return
			}
			guard !(vc === currentModalPresentation?.viewController.uiViewController()) || vc.isBeingDismissed else {
				assertionFailure("Presentations interleaved with other APIs is not supported.")
				let completionHandlers = queuedModalPresentations.compactMap {
					$0.value?.completion
				}
				queuedModalPresentations.removeAll()
				presentationAnimationInProgress = false
				currentModalPresentation?.completion?.send(value: ())
				completionHandlers.forEach { $0.send(value: ()) }
				return
			}
			vc.dismiss(animated: animated, completion: { () -> Void in
				self.presentationAnimationCompleted(viewController: viewController, dismissed: true)
			})
		}
		
		open func processModalPresentations(viewController: UIViewController) {
			guard !presentationAnimationInProgress, let first = queuedModalPresentations.first else { return }
			if let modalPresentation = first.value {
				guard viewController.view.window != nil else { return }
				present(viewController: viewController, modalPresentation: modalPresentation, animated: first.isAnimated)
			} else {
				dismiss(viewController: viewController, animated: first.isAnimated)
			}
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
	static var additionalSafeAreaInsets: ViewControllerName<Dynamic<UIEdgeInsets>> { return .name(B.additionalSafeAreaInsets) }
	static var children: ViewControllerName<Dynamic<[ViewControllerConvertible]>> { return .name(B.children) }
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
	static var present: ViewControllerName<Signal<Animatable<ModalPresentation?, ()>>> { return .name(B.present) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var childrenLayout: ViewControllerName<([UIView]) -> Layout> { return .name(B.childrenLayout) }
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
	typealias Preparer = ViewController.Preparer
	static func viewControllerBinding(_ binding: ViewController.Binding) -> ViewController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct ModalPresentation {
	let viewController: ViewControllerConvertible
	let popoverPositioning: ((_ presenter: UIViewController, _ popover: UIPopoverPresentationController) -> Void)?
	let completion: SignalInput<Void>?
	
	public init(_ viewController: ViewControllerConvertible, popoverPositioning: ((_ presenter: UIViewController, _ popover: UIPopoverPresentationController) -> Void)? = nil, completion: SignalInput<Void>? = nil) {
		self.viewController = viewController
		self.popoverPositioning = popoverPositioning
		self.completion = completion
	}
}

extension SignalInterface {
	public func modalPresentation<T>(_ construct: @escaping (T) -> ViewControllerConvertible) -> Signal<ModalPresentation?> where OutputValue == Optional<T> {
		return transform { result in
			switch result {
			case .success(.some(let t)): return .value(ModalPresentation(construct(t)))
			case .success: return .value(nil)
			case .failure(let e): return .end(e)
			}
		}
	}
}

#endif
