//
//  CwlTabBarController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/03/08.
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
public class TabBarController<ItemIdentifier: Hashable>: Binder, TabBarControllerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TabBarController {
	enum Binding: TabBarControllerBinding {
		public typealias ItemIdentifierType = ItemIdentifier
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case tabBar(Constant<TabBar<ItemIdentifier>>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case customizableItems(Dynamic<Set<ItemIdentifier>>)
		case items(Dynamic<SetOrAnimate<[ItemIdentifier]>>)

		// 2. Signal bindings are performed on the object after construction.
		case selectItem(Signal<ItemIdentifier>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case animationControllerForTransition((UITabBarController, UIViewController, ItemIdentifier, UIViewController, ItemIdentifier) -> UIViewControllerAnimatedTransitioning?)
		case didEndCustomizing((UITabBarController, [UIViewController], [ItemIdentifier], Bool) -> Void)
		case didSelect((UITabBarController, UIViewController, ItemIdentifier) -> Void)
		case interactionControllerForAnimation((UITabBarController, UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?)
		case preferredInterfaceOrientationForPresentation((UITabBarController) -> UIInterfaceOrientation)
		case shouldSelect((UITabBarController, UIViewController, ItemIdentifier) -> Bool)
		case supportedInterfaceOrientations((UITabBarController) -> UIInterfaceOrientationMask)
		case tabConstructor((ItemIdentifier) -> ViewControllerConvertible)
		case willBeginCustomizing((UITabBarController, [UIViewController], [ItemIdentifier]) -> Void)
		case willEndCustomizing((UITabBarController, [UIViewController], [ItemIdentifier], Bool) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TabBarController {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TabBarController.Binding
		public typealias Inherited = ViewController.Preparer
		public typealias Instance = UITabBarController
		
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
		
		var tabConstructor: ((ItemIdentifier) -> ViewControllerConvertible)?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TabBarController.Preparer {
	var delegateIsRequired: Bool { return true }
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .animationControllerForTransition(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarController(_:animationControllerForTransitionFrom:to:)))
		case .didEndCustomizing(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarController(_:didEndCustomizing:changed:)))
		case .didSelect(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarController(_:didSelect:)))
		case .interactionControllerForAnimation(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarController(_:interactionControllerFor:)))
		case .preferredInterfaceOrientationForPresentation(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarControllerPreferredInterfaceOrientationForPresentation(_:)))
		case .shouldSelect(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarController(_:shouldSelect:)))
		case .supportedInterfaceOrientations(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarControllerSupportedInterfaceOrientations(_:)))
		case .tabConstructor(let x): tabConstructor = x
		case .willBeginCustomizing(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarController(_:willBeginCustomizing:)))
		case .willEndCustomizing(let x): delegate().addSingleHandler(x, #selector(UITabBarControllerDelegate.tabBarController(_:willEndCustomizing:changed:)))
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)

		storage.tabConstructor = tabConstructor
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .tabBar(let x):
			x.value.apply(to: instance.tabBar)
			return nil

		// 1. Value bindings may be applied at construction and may subsequently change.
		case .customizableItems(let x):
			return x.apply(instance, storage) { i, s, v in
				i.customizableViewControllers = v.compactMap { s.viewController(for: $0) }
			}
		case .items(let x):
			return x.apply(instance, storage) { i, s, v in
				let items = v.value.compactMap { s.viewController(for: $0) }
				i.setViewControllers(items, animated: v.isAnimated)
			}

		// 2. Signal bindings are performed on the object after construction.
		case .selectItem(let x):
			return x.apply(instance, storage) { i, s, v in
				if let vc = s.viewController(for: v), let index = i.viewControllers?.firstIndex(of: vc) {
					i.selectedIndex = index
				}
			}

		// 3. Action bindings are triggered by the object after construction.
		case .didEndCustomizing: return nil
		case .didSelect: return nil
		case .willBeginCustomizing: return nil
		case .willEndCustomizing: return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .animationControllerForTransition: return nil
		case .interactionControllerForAnimation: return nil
		case .preferredInterfaceOrientationForPresentation: return nil
		case .shouldSelect: return nil
		case .supportedInterfaceOrientations: return nil
		case .tabConstructor: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TabBarController.Preparer {
	open class Storage: ViewController.Preparer.Storage, UITabBarControllerDelegate {
		open var tabConstructor: ((ItemIdentifier) -> ViewControllerConvertible)?
		open var allItems: [ItemIdentifier: ViewControllerConvertible] = [:]
		
		open override var isInUse: Bool { return true }
		
		open func identifier(for viewController: UIViewController) -> ItemIdentifier? {
			return allItems.first(where: { pair -> Bool in
				pair.value.uiViewController() === viewController
			})?.key
		}
		open func viewController(for identifier: ItemIdentifier) -> UIViewController? {
			if let existing = allItems[identifier] {
				return existing.uiViewController()
			}
			if let binding = tabConstructor {
				let new = binding(identifier)
				allItems[identifier] = new
				return new.uiViewController()
			}
			return nil
		}
	}
	
	open class Delegate: DynamicDelegate, UITabBarControllerDelegate {
		open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
			guard let identifier = (tabBarController.delegate as? Storage)?.identifier(for: viewController) else { return }
			multiHandler(tabBarController, viewController, identifier)
		}

		open func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]) {
			guard let storage = tabBarController.delegate as? Storage else { return }
			let identifiers = viewControllers.compactMap { storage.identifier(for: $0) }
			multiHandler(tabBarController, viewControllers, identifiers)
		}

		open func tabBarController(_ tabBarController: UITabBarController, didBeginCustomizing viewControllers: [UIViewController]) {
			guard let storage = tabBarController.delegate as? Storage else { return }
			let identifiers = viewControllers.compactMap { storage.identifier(for: $0) }
			multiHandler(tabBarController, viewControllers, identifiers)
		}

		open func tabBarController(_ tabBarController: UITabBarController, willEndCustomizing viewControllers: [UIViewController], changed: Bool) {
			guard let storage = tabBarController.delegate as? Storage else { return }
			let identifiers = viewControllers.compactMap { storage.identifier(for: $0) }
			multiHandler(tabBarController, viewControllers, identifiers, changed)
		}

		open func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
			guard let storage = tabBarController.delegate as? Storage else { return }
			let identifiers = viewControllers.compactMap { storage.identifier(for: $0) }
			multiHandler(tabBarController, viewControllers, identifiers, changed)
		}
		
		open func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
			guard let storage = tabBarController.delegate as? Storage, let identifier = storage.identifier(for: viewController) else { return false }
			return singleHandler(tabBarController, viewController, identifier)
		}
		
		open func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
			return singleHandler(tabBarController)
		}
		
		open func tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation {
			return singleHandler(tabBarController)
		}
		
		open func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
			return singleHandler(tabBarController, animationController)
		}
		
		open func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			guard let identifierFrom = (tabBarController.delegate as? Storage)?.identifier(for: fromVC) else { return nil }
			guard let identifierTo = (tabBarController.delegate as? Storage)?.identifier(for: toVC) else { return nil }
			return singleHandler(tabBarController, fromVC, identifierFrom, toVC, identifierTo)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TabBarControllerBinding {
	public typealias TabBarControllerName<V> = BindingName<V, TabBarController<Binding.ItemIdentifierType>.Binding, Binding>
	private typealias B = TabBarController<Binding.ItemIdentifierType>.Binding
	private static func name<V>(_ source: @escaping (V) -> TabBarController<Binding.ItemIdentifierType>.Binding) -> TabBarControllerName<V> {
		return TabBarControllerName<V>(source: source, downcast: Binding.tabBarControllerBinding)
	}
}
public extension BindingName where Binding: TabBarControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TabBarControllerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var tabBar: TabBarControllerName<Constant<TabBar<Binding.ItemIdentifierType>>> { return .name(B.tabBar) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var customizableItems: TabBarControllerName<Dynamic<Set<Binding.ItemIdentifierType>>> { return .name(B.customizableItems) }
	static var items: TabBarControllerName<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>> { return .name(B.items) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var selectItem: TabBarControllerName<Signal<Binding.ItemIdentifierType>> { return .name(B.selectItem) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var animationControllerForTransition: TabBarControllerName<(UITabBarController, UIViewController, Binding.ItemIdentifierType, UIViewController, Binding.ItemIdentifierType) -> UIViewControllerAnimatedTransitioning?> { return .name(B.animationControllerForTransition) }
	static var didEndCustomizing: TabBarControllerName<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void> { return .name(B.didEndCustomizing) }
	static var didSelect: TabBarControllerName<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Void> { return .name(B.didSelect) }
	static var interactionControllerForAnimation: TabBarControllerName<(UITabBarController, UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?> { return .name(B.interactionControllerForAnimation) }
	static var preferredInterfaceOrientationForPresentation: TabBarControllerName<(UITabBarController) -> UIInterfaceOrientation> { return .name(B.preferredInterfaceOrientationForPresentation) }
	static var shouldSelect: TabBarControllerName<(UITabBarController, UIViewController, Binding.ItemIdentifierType) -> Bool> { return .name(B.shouldSelect) }
	static var supportedInterfaceOrientations: TabBarControllerName<(UITabBarController) -> UIInterfaceOrientationMask> { return .name(B.supportedInterfaceOrientations) }
	static var tabConstructor: TabBarControllerName<(Binding.ItemIdentifierType) -> ViewControllerConvertible> { return .name(B.tabConstructor) }
	static var willBeginCustomizing: TabBarControllerName<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType]) -> Void> { return .name(B.willBeginCustomizing) }
	static var willEndCustomizing: TabBarControllerName<(UITabBarController, [UIViewController], [Binding.ItemIdentifierType], Bool) -> Void> { return .name(B.willEndCustomizing) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TabBarControllerConvertible: ViewControllerConvertible {
	func uiTabBarController() -> UITabBarController
}
extension TabBarControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiTabBarController() }
}
extension UITabBarController: TabBarControllerConvertible, HasDelegate {
	public func uiTabBarController() -> UITabBarController { return self }
}
public extension TabBarController {
	func uiTabBarController() -> UITabBarController { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TabBarControllerBinding: ViewControllerBinding {
	associatedtype ItemIdentifierType: Hashable
	static func tabBarControllerBinding(_ binding: TabBarController<ItemIdentifierType>.Binding) -> Self
}
public extension TabBarControllerBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return tabBarControllerBinding(TabBarController<ItemIdentifierType>.Binding.inheritedBinding(binding))
	}
}
public extension TabBarController.Binding {
	typealias Preparer = TabBarController.Preparer
	static func tabBarControllerBinding(_ binding: TabBarController<ItemIdentifierType>.Binding) -> TabBarController<ItemIdentifierType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
