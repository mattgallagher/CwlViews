//
//  CwlNavigationController.swift
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

public class NavigationController: ConstructingBinder, NavigationControllerConvertible {
	public typealias Instance = UINavigationController
	public typealias Inherited = ViewController
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiNavigationController() -> Instance { return instance() }
	
	public enum Binding: NavigationControllerBinding {
		public typealias EnclosingBinder = NavigationController
		public static func navigationControllerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case navigationBar(Constant<NavigationBar>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case stack(Dynamic<StackMutation<ViewControllerConvertible>>)
		case supportedInterfaceOrientations(Dynamic<UIInterfaceOrientationMask>)
		case preferredInterfaceOrientation(Dynamic<UIInterfaceOrientation>)
		case isNavigationBarHidden(Dynamic<SetOrAnimate<Bool>>)
		case isToolbarHidden(Dynamic<SetOrAnimate<Bool>>)
		case hidesBarsOnTap(Dynamic<Bool>)
		case hidesBarsOnSwipe(Dynamic<Bool>)
		case hidesBarsWhenVerticallyCompact(Dynamic<Bool>)
		case hidesBarsWhenKeyboardAppears(Dynamic<Bool>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case poppedToCount(SignalInput<Int>)
		case willShow(SignalInput<(viewController: UIViewController, animated: Bool)>)
		case didShow(SignalInput<(viewController: UIViewController, animated: Bool)>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case animationController((_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?)
		case interactionController((_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?)
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = NavigationController
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage(popSignal: popSignal) }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(nibName: nil, bundle: nil) }
		
		public init() {
			self.init(delegateClass: NavigationControllerDelegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: NavigationControllerDelegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: NavigationControllerDelegate.Type
		var possibleDelegate: NavigationControllerDelegate? = nil
		mutating func delegate() -> NavigationControllerDelegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}
		
		var popSignal: SignalInput<Int>? = nil
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .poppedToCount(let x): popSignal = x
			case .supportedInterfaceOrientations:
				delegate().addSelector(#selector(UINavigationControllerDelegate.navigationControllerSupportedInterfaceOrientations(_:)))
			case .preferredInterfaceOrientation:
				delegate().addSelector(#selector(UINavigationControllerDelegate.navigationControllerPreferredInterfaceOrientationForPresentation(_:)))
			case .animationController(let x):
				let s = #selector(UINavigationControllerDelegate.navigationController(_:animationControllerFor:from:to:))
				delegate().addSelector(s).animationController = x
			case .interactionController(let x):
				let s = #selector(UINavigationControllerDelegate.navigationController(_:interactionControllerFor:))
				delegate().addSelector(s).interactionController = x
			case .willShow:
				let s = #selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:))
				delegate().addSelector(s)
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: UINavigationController, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			instance.delegate = storage
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .navigationBar(let x):
				x.value.applyBindings(to: instance.navigationBar)
				return nil
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
			case .isNavigationBarHidden(let x): return x.apply(instance, storage) { i, s, v in i.setNavigationBarHidden(v.value, animated: v.isAnimated) }
			case .isToolbarHidden(let x): return x.apply(instance, storage) { i, s, v in i.setToolbarHidden(v.value, animated: v.isAnimated) }
			case .hidesBarsOnTap(let x): return x.apply(instance, storage) { i, s, v in i.hidesBarsOnTap = v }
			case .hidesBarsOnSwipe(let x): return x.apply(instance, storage) { i, s, v in i.hidesBarsOnSwipe = v }
			case .hidesBarsWhenVerticallyCompact(let x): return x.apply(instance, storage) { i, s, v in i.hidesBarsWhenVerticallyCompact = v }
			case .hidesBarsWhenKeyboardAppears(let x): return x.apply(instance, storage) { i, s, v in i.hidesBarsWhenKeyboardAppears = v }
			case .supportedInterfaceOrientations: return nil
			case .preferredInterfaceOrientation: return nil
			case .didShow(let x):
				storage.didShow = x
				return nil
			case .willShow: return nil
			case .animationController: return nil
			case .interactionController: return nil
			case .poppedToCount: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ViewController.Storage, UINavigationControllerDelegate {
		open var supportedInterfaceOrientations: UIInterfaceOrientationMask = .all
		open var preferredInterfaceOrientation: UIInterfaceOrientation = .portrait
		open var expectedStackCount: Int = 0
		public let popSignal: SignalInput<Int>?
		weak var collapsedController: UINavigationController?
		
		open override var inUse: Bool {
			return true
		}
		
		public init(popSignal: SignalInput<Int>?) {
			self.popSignal = popSignal
			super.init()
		}
		
		open var didShow: SignalInput<(viewController: UIViewController, animated: Bool)>?
		public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
			// Handle pop operations triggered by the back button
			if animated, navigationController.viewControllers.count < expectedStackCount, let ps = popSignal {
				ps.send(value: navigationController.viewControllers.count)
			}
			
			// Handle removal of collapsed split view details
			if animated, navigationController.viewControllers.count == expectedStackCount, let collapsed = collapsedController, let splitViewStorage = navigationController.splitViewController?.getBinderStorage(type: SplitViewController.Storage.self) {
				collapsedController = nil
				splitViewStorage.collapsedController(collapsed)
			}
			
			// Track when a collapsed split view is added
			if navigationController.viewControllers.count == expectedStackCount + 1, let collapsed = navigationController.viewControllers.last as? UINavigationController {
				collapsedController = collapsed
			}
			
			didShow?.send(value: (viewController: viewController, animated: animated))
		}
	}
}

open class NavigationControllerDelegate: DynamicDelegate, UINavigationControllerDelegate {
	public required override init() {
		super.init()
	}
	
	open var willShow: ((UIViewController, Bool) -> Void)?
	open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		return willShow!(viewController, animated)
	}
	
	open var supportedInterfaceOrientations: (() -> UIInterfaceOrientationMask)?
	open func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
		return supportedInterfaceOrientations!()
	}
	
	open var preferredInterfaceOrientationForPresentation: (() -> UIInterfaceOrientation)?
	open func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
		return preferredInterfaceOrientationForPresentation!()
	}
	
	open var animationController: ((_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?)?
	open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return animationController!(navigationController, operation, fromVC, toVC)
	}
	
	open var interactionController: ((_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?)?
	open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
	{
		return interactionController!(navigationController, animationController)
	}
}

extension BindingName where Binding: NavigationControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.$1(v)) }) }
	public static var navigationBar: BindingName<Constant<NavigationBar>, Binding> { return BindingName<Constant<NavigationBar>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.navigationBar(v)) }) }
	public static var stack: BindingName<Dynamic<StackMutation<ViewControllerConvertible>>, Binding> { return BindingName<Dynamic<StackMutation<ViewControllerConvertible>>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.stack(v)) }) }
	public static var supportedInterfaceOrientations: BindingName<Dynamic<UIInterfaceOrientationMask>, Binding> { return BindingName<Dynamic<UIInterfaceOrientationMask>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.supportedInterfaceOrientations(v)) }) }
	public static var preferredInterfaceOrientation: BindingName<Dynamic<UIInterfaceOrientation>, Binding> { return BindingName<Dynamic<UIInterfaceOrientation>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.preferredInterfaceOrientation(v)) }) }
	public static var isNavigationBarHidden: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.isNavigationBarHidden(v)) }) }
	public static var isToolbarHidden: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.isToolbarHidden(v)) }) }
	public static var hidesBarsOnTap: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.hidesBarsOnTap(v)) }) }
	public static var hidesBarsOnSwipe: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.hidesBarsOnSwipe(v)) }) }
	public static var hidesBarsWhenVerticallyCompact: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.hidesBarsWhenVerticallyCompact(v)) }) }
	public static var hidesBarsWhenKeyboardAppears: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.hidesBarsWhenKeyboardAppears(v)) }) }
	public static var poppedToCount: BindingName<SignalInput<Int>, Binding> { return BindingName<SignalInput<Int>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.poppedToCount(v)) }) }
	public static var willShow: BindingName<SignalInput<(viewController: UIViewController, animated: Bool)>, Binding> { return BindingName<SignalInput<(viewController: UIViewController, animated: Bool)>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.willShow(v)) }) }
	public static var didShow: BindingName<SignalInput<(viewController: UIViewController, animated: Bool)>, Binding> { return BindingName<SignalInput<(viewController: UIViewController, animated: Bool)>, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.didShow(v)) }) }
	public static var animationController: BindingName<(_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?, Binding> { return BindingName<(_ navigationController: UINavigationController, _ operation: UINavigationController.Operation, _ from: UIViewController, _ to: UIViewController) -> UIViewControllerAnimatedTransitioning?, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.animationController(v)) }) }
	public static var interactionController: BindingName<(_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, Binding> { return BindingName<(_ navigationController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?, Binding>({ v in .navigationControllerBinding(NavigationController.Binding.interactionController(v)) }) }
}

public protocol NavigationControllerConvertible: ViewControllerConvertible {
	func uiNavigationController() -> NavigationController.Instance
}
extension NavigationControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiNavigationController() }
}
extension NavigationController.Instance: NavigationControllerConvertible {
	public func uiNavigationController() -> NavigationController.Instance { return self }
}

public protocol NavigationControllerBinding: ViewControllerBinding {
	static func navigationControllerBinding(_ binding: NavigationController.Binding) -> Self
}
extension NavigationControllerBinding {
	public static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return navigationControllerBinding(.inheritedBinding(binding))
	}
}
