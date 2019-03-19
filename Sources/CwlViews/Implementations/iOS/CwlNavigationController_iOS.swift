//
//  CwlNavigationController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/16.
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
public class NavigationController: Binder, NavigationControllerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension NavigationController {
	enum Binding: NavigationControllerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case navigationBar(Constant<NavigationBar>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case hidesBarsOnSwipe(Dynamic<Bool>)
		case hidesBarsOnTap(Dynamic<Bool>)
		case hidesBarsWhenKeyboardAppears(Dynamic<Bool>)
		case hidesBarsWhenVerticallyCompact(Dynamic<Bool>)
		case isNavigationBarHidden(Dynamic<SetOrAnimate<Bool>>)
		case isToolbarHidden(Dynamic<SetOrAnimate<Bool>>)
		case preferredInterfaceOrientation(Dynamic<UIInterfaceOrientation>)
		case stack(Dynamic<StackMutation<ViewControllerConvertible>>)
		case supportedInterfaceOrientations(Dynamic<UIInterfaceOrientationMask>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case didShow(SignalInput<(viewController: UIViewController, animated: Bool)>)
		case poppedToCount(SignalInput<Int>)
		case willShow(SignalInput<(viewController: UIViewController, animated: Bool)>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case animationController((_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?)
		case interactionController((_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?)
	}
}

// MARK: - Binder Part 3: Preparer
public extension NavigationController {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = NavigationController.Binding
		public typealias Inherited = ViewController.Preparer
		public typealias Instance = UINavigationController
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage(didShow: didShow, popSignal: popSignal) }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		var popSignal: MultiOutput<Int>? = nil
		var didShow: MultiOutput<(viewController: UIViewController, animated: Bool)>? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension NavigationController.Preparer {
	var delegateIsRequired: Bool { return true }
	
	func constructInstance(type: Instance.Type, parameters: Void) -> Instance { return type.init(nibName: nil, bundle: nil) }

	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .animationController(let x): delegate().addSingleHandler(x, #selector(UINavigationControllerDelegate.navigationController(_:animationControllerFor:from:to:)))
		case .interactionController(let x): delegate().addSingleHandler(x, #selector(UINavigationControllerDelegate.navigationController(_:interactionControllerFor:)))
		case .didShow(let x):
			didShow = didShow ?? Input().multicast()
			didShow?.signal.bind(to: x)
		case .poppedToCount(let x):
			popSignal = popSignal ?? Input().multicast()
			popSignal?.signal.bind(to: x)
		case .preferredInterfaceOrientation(let x): delegate().addSingleHandler(x, #selector(UINavigationControllerDelegate.navigationControllerPreferredInterfaceOrientationForPresentation(_:)))
		case .supportedInterfaceOrientations(let x): delegate().addSingleHandler(x, #selector(UINavigationControllerDelegate.navigationControllerSupportedInterfaceOrientations(_:)))
		case .willShow(let x): delegate().addSingleHandler(x, #selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:)))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .navigationBar(let x):
			x.value.apply(to: instance.navigationBar)
			return nil

		// 1. Value bindings may be applied at construction and may subsequently change.
		case .hidesBarsOnSwipe(let x): return x.apply(instance) { i, v in i.hidesBarsOnSwipe = v }
		case .hidesBarsOnTap(let x): return x.apply(instance) { i, v in i.hidesBarsOnTap = v }
		case .hidesBarsWhenKeyboardAppears(let x): return x.apply(instance) { i, v in i.hidesBarsWhenKeyboardAppears = v }
		case .hidesBarsWhenVerticallyCompact(let x): return x.apply(instance) { i, v in i.hidesBarsWhenVerticallyCompact = v }
		case .isNavigationBarHidden(let x): return x.apply(instance) { i, v in i.setNavigationBarHidden(v.value, animated: v.isAnimated) }
		case .isToolbarHidden(let x): return x.apply(instance) { i, v in i.setToolbarHidden(v.value, animated: v.isAnimated) }
		case .preferredInterfaceOrientation: return nil
		case .stack(let x):
			return x.apply(instance, storage) { i, s, v in
				switch v {
				case .push(let e):
					s.expectedStackCount += 1
					i.pushViewController(e.uiViewController(), animated: true)
				case .pop:
					s.expectedStackCount -= 1
					i.popViewController(animated: true)
				case .popToCount(let c):
					s.expectedStackCount = c
					i.popToViewController(i.viewControllers[c - 1], animated: true)
				case .reload(let newStack):
					s.expectedStackCount = newStack.count
					i.setViewControllers(newStack.map { $0.uiViewController() }, animated: false)
				}
			}
		case .supportedInterfaceOrientations: return nil
			
		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
		case .didShow: return nil
		case .poppedToCount: return nil
		case .willShow: return nil
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .animationController: return nil
		case .interactionController: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension NavigationController.Preparer {
	open class Storage: ViewController.Preparer.Storage, UINavigationControllerDelegate {
		open var supportedInterfaceOrientations: UIInterfaceOrientationMask = .all
		open var preferredInterfaceOrientation: UIInterfaceOrientation = .portrait
		open var expectedStackCount: Int = 0
		public let popSignal: MultiOutput<Int>?
		public let didShow: MultiOutput<(viewController: UIViewController, animated: Bool)>?
		weak var collapsedController: UINavigationController?
		
		open override var isInUse: Bool {
			return true
		}
		
		public init(didShow: MultiOutput<(viewController: UIViewController, animated: Bool)>?, popSignal: MultiOutput<Int>?) {
			self.popSignal = popSignal
			self.didShow = didShow
			super.init()
		}
		
		open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
			// Handle pop operations triggered by the back button
			if animated, navigationController.viewControllers.count < expectedStackCount, let ps = popSignal {
				ps.input.send(value: navigationController.viewControllers.count)
			}
			
			// Handle removal of collapsed split view details
			if animated, navigationController.viewControllers.count == expectedStackCount, let collapsed = collapsedController, let splitView = navigationController.splitViewController, let splitViewStorage = splitView.associatedBinderStorage(subclass: SplitViewController.Preparer.Storage.self) {
				collapsedController = nil
				splitViewStorage.collapsedController(collapsed)
			}
			
			// Track when a collapsed split view is added
			if navigationController.viewControllers.count == expectedStackCount + 1, let collapsed = navigationController.viewControllers.last as? UINavigationController {
				collapsedController = collapsed
			}
			
			didShow?.input.send(value: (viewController: viewController, animated: animated))
		}
	}

	open class Delegate: DynamicDelegate, UINavigationControllerDelegate {
		open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
			return singleHandler(navigationController, viewController, animated)
		}
		
		open func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
			return singleHandler(navigationController)
		}
		
		open func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
			return singleHandler(navigationController)
		}
		
		open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			return singleHandler(navigationController, operation, fromVC, toVC)
		}
		
		open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
		{
			return singleHandler(navigationController, animationController)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: NavigationControllerBinding {
	public typealias NavigationControllerName<V> = BindingName<V, NavigationController.Binding, Binding>
	private typealias B = NavigationController.Binding
	private static func name<V>(_ source: @escaping (V) -> NavigationController.Binding) -> NavigationControllerName<V> {
		return NavigationControllerName<V>(source: source, downcast: Binding.navigationControllerBinding)
	}
}
public extension BindingName where Binding: NavigationControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: NavigationControllerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var navigationBar: NavigationControllerName<Constant<NavigationBar>> { return .name(B.navigationBar) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var hidesBarsOnSwipe: NavigationControllerName<Dynamic<Bool>> { return .name(B.hidesBarsOnSwipe) }
	static var hidesBarsOnTap: NavigationControllerName<Dynamic<Bool>> { return .name(B.hidesBarsOnTap) }
	static var hidesBarsWhenKeyboardAppears: NavigationControllerName<Dynamic<Bool>> { return .name(B.hidesBarsWhenKeyboardAppears) }
	static var hidesBarsWhenVerticallyCompact: NavigationControllerName<Dynamic<Bool>> { return .name(B.hidesBarsWhenVerticallyCompact) }
	static var isNavigationBarHidden: NavigationControllerName<Dynamic<SetOrAnimate<Bool>>> { return .name(B.isNavigationBarHidden) }
	static var isToolbarHidden: NavigationControllerName<Dynamic<SetOrAnimate<Bool>>> { return .name(B.isToolbarHidden) }
	static var preferredInterfaceOrientation: NavigationControllerName<Dynamic<UIInterfaceOrientation>> { return .name(B.preferredInterfaceOrientation) }
	static var stack: NavigationControllerName<Dynamic<StackMutation<ViewControllerConvertible>>> { return .name(B.stack) }
	static var supportedInterfaceOrientations: NavigationControllerName<Dynamic<UIInterfaceOrientationMask>> { return .name(B.supportedInterfaceOrientations) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var didShow: NavigationControllerName<SignalInput<(viewController: UIViewController, animated: Bool)>> { return .name(B.didShow) }
	static var poppedToCount: NavigationControllerName<SignalInput<Int>> { return .name(B.poppedToCount) }
	static var willShow: NavigationControllerName<SignalInput<(viewController: UIViewController, animated: Bool)>> { return .name(B.willShow) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var animationController: NavigationControllerName<(_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?> { return .name(B.animationController) }
	static var interactionController: NavigationControllerName<(_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?> { return .name(B.interactionController) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol NavigationControllerConvertible: ViewControllerConvertible {
	func uiNavigationController() -> NavigationController.Instance
}
extension NavigationControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiNavigationController() }
}
extension UINavigationController: NavigationControllerConvertible, HasDelegate {
	public func uiNavigationController() -> NavigationController.Instance { return self }
}
public extension NavigationController {
	func uiNavigationController() -> NavigationController.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol NavigationControllerBinding: ViewControllerBinding {
	static func navigationControllerBinding(_ binding: NavigationController.Binding) -> Self
}
public extension NavigationControllerBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return navigationControllerBinding(.inheritedBinding(binding))
	}
}
public extension NavigationController.Binding {
	typealias Preparer = NavigationController.Preparer
	static func navigationControllerBinding(_ binding: NavigationController.Binding) -> NavigationController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
