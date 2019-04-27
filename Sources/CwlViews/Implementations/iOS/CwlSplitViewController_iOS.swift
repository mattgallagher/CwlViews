//
//  CwlSplitViewController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/03.
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
public class SplitViewController: Binder, SplitViewControllerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension SplitViewController {
	enum Binding: SplitViewControllerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case backgroundView(Constant<View>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case maximumPrimaryColumnWidth(Dynamic<CGFloat>)
		case minimumPrimaryColumnWidth(Dynamic<CGFloat>)
		case preferredDisplayMode(Dynamic<UISplitViewController.DisplayMode>)
		case preferredPrimaryColumnWidthFraction(Dynamic<CGFloat>)
		case presentsWithGesture(Dynamic<Bool>)
		case primaryViewController(Dynamic<ViewControllerConvertible>)
		case secondaryViewController(Dynamic<ViewControllerConvertible>)
		case shouldShowSecondary(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case dismissedSecondary(SignalInput<Void>)
		case displayModeButton(SignalInput<BarButtonItemConvertible?>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case collapseSecondary((UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool)
		case preferredInterfaceOrientation((UISplitViewController) -> UIInterfaceOrientation)
		case primaryViewControllerForCollapsing((UISplitViewController) -> UIViewController?)
		case primaryViewControllerForExpanding((UISplitViewController) -> UIViewController?)
		case separateSecondary((UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?)
		case showPrimaryViewController((UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool)
		case showSecondaryViewController((UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool)
		case supportedInterfaceOrientations((UISplitViewController) -> UIInterfaceOrientationMask)
		case targetDisplayModeForAction((UISplitViewController) -> UISplitViewController.DisplayMode)
		case willChangeDisplayMode((UISplitViewController, UISplitViewController.DisplayMode) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension SplitViewController {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = SplitViewController.Binding
		public typealias Inherited = ViewController.Preparer
		public typealias Instance = UISplitViewController
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage(displayModeButton: displayModeButton, dismissedSecondary: dismissedSecondary) }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		public var primary = InitialSubsequent<ViewControllerConvertible>()
		public var secondary = InitialSubsequent<ViewControllerConvertible>()
		public var displayModeButton: MultiOutput<BarButtonItemConvertible?>?
		public var dismissedSecondary: MultiOutput<Void>?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension SplitViewController.Preparer {
	var delegateIsRequired: Bool { return true }
	
	func constructInstance(type: Instance.Type, parameters: Void) -> Instance { return type.init(nibName: nil, bundle: nil) }

	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .collapseSecondary(let x): delegate().addSingleHandler3(x, #selector(UISplitViewControllerDelegate.splitViewController(_:collapseSecondary:onto:)))
		case .preferredInterfaceOrientation(let x): delegate().addSingleHandler1(x, #selector(UISplitViewControllerDelegate.splitViewControllerPreferredInterfaceOrientationForPresentation(_:)))
		case .primaryViewController(let x): primary = x.initialSubsequent()
		case .primaryViewControllerForCollapsing(let x): delegate().addSingleHandler1(x, #selector(UISplitViewControllerDelegate.primaryViewController(forCollapsing:)))
		case .primaryViewControllerForExpanding(let x): delegate().addSingleHandler1(x, #selector(UISplitViewControllerDelegate.primaryViewController(forExpanding:)))
		case .secondaryViewController(let x): secondary = x.initialSubsequent()
		case .separateSecondary(let x): delegate().addSingleHandler2(x, #selector(UISplitViewControllerDelegate.splitViewController(_:separateSecondaryFrom:)))
		case .showPrimaryViewController(let x): delegate().addSingleHandler3(x, #selector(UISplitViewControllerDelegate.splitViewController(_:show:sender:)))
		case .showSecondaryViewController(let x): delegate().addSingleHandler3(x, #selector(UISplitViewControllerDelegate.splitViewController(_:showDetail:sender:)))
		case .supportedInterfaceOrientations(let x): delegate().addSingleHandler1(x, #selector(UISplitViewControllerDelegate.splitViewControllerSupportedInterfaceOrientations(_:)))
		case .targetDisplayModeForAction(let x): delegate().addSingleHandler1(x, #selector(UISplitViewControllerDelegate.targetDisplayModeForAction(in:)))
		case .willChangeDisplayMode(let x): delegate().addMultiHandler2(x, #selector(UISplitViewControllerDelegate.splitViewController(_:willChangeTo:)))
		case .dismissedSecondary(let x):
			dismissedSecondary = dismissedSecondary ?? Input().multicast()
			dismissedSecondary?.signal.bind(to: x)
		case .displayModeButton(let x):
			displayModeButton = displayModeButton ?? Input().multicast()
			displayModeButton?.signal.bind(to: x)
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		
		prepareDelegate(instance: instance, storage: storage)
		storage.secondaryViewController = secondary.initial?.uiViewController()
		instance.viewControllers = [primary.initial?.uiViewController() ?? UIViewController()]
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .backgroundView(let v):
			v.value.apply(to: instance.view)
			return nil
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .maximumPrimaryColumnWidth(let x): return x.apply(instance) { i, v in i.maximumPrimaryColumnWidth = v }
		case .minimumPrimaryColumnWidth(let x): return x.apply(instance) { i, v in i.minimumPrimaryColumnWidth = v }
		case .preferredDisplayMode(let x): return x.apply(instance) { i, v in i.preferredDisplayMode = v }
		case .preferredPrimaryColumnWidthFraction(let x): return x.apply(instance) { i, v in i.preferredPrimaryColumnWidthFraction = v }
		case .presentsWithGesture(let x): return x.apply(instance) { i, v in i.presentsWithGesture = v }
		case .primaryViewController: return primary.resume()?.apply(instance) { i, v in i.show(v.uiViewController(), sender: nil) }
		case .secondaryViewController:
			return secondary.resume()?.apply(instance, storage) { i, s, v in
				let vc = v.uiViewController()
				s.secondaryViewController = vc
				i.showDetailViewController(vc, sender: nil)
			}
		case .shouldShowSecondary(let x):
			return x.apply(instance, storage) { i, s, v in
				if v == true && s.shouldShowSecondary == false, let svc = s.secondaryViewController {
					i.showDetailViewController(svc, sender: nil)
				}
				s.shouldShowSecondary = v
			}

		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
		case .dismissedSecondary: return nil
		case .displayModeButton: return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .collapseSecondary: return nil
		case .preferredInterfaceOrientation: return nil
		case .primaryViewControllerForCollapsing: return nil
		case .primaryViewControllerForExpanding: return nil
		case .separateSecondary: return nil
		case .showPrimaryViewController: return nil
		case .showSecondaryViewController: return nil
		case .supportedInterfaceOrientations: return nil
		case .targetDisplayModeForAction: return nil
		case .willChangeDisplayMode: return nil
		}
	}

	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		if !instance.isCollapsed {
			storage.displayModeButton?.input.send(value: instance.displayModeButtonItem)
		}
		if let secondary = storage.secondaryViewController {
			instance.viewControllers.append(secondary)
		}
		
		return inheritedFinalizedInstance(instance, storage: storage)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SplitViewController.Preparer {
	open class Storage: ViewController.Preparer.Storage, UISplitViewControllerDelegate {
		open var secondaryViewController: UIViewController? = nil
		open var shouldShowSecondary: Bool = true
		public let dismissedSecondary: MultiOutput<Void>?
		public let displayModeButton: MultiOutput<BarButtonItemConvertible?>?
		
		public init(displayModeButton: MultiOutput<BarButtonItemConvertible?>?, dismissedSecondary: MultiOutput<Void>?) {
			self.dismissedSecondary = dismissedSecondary
			self.displayModeButton = displayModeButton
			super.init()
		}
		
		open override var isInUse: Bool {
			return true
		}
		
		open func collapsedController(_ controller: UINavigationController) {
			if let svc = secondaryViewController, svc === controller {
				dismissedSecondary?.input.send(value: ())
			}
		}

		open func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
			displayModeButton?.input.send(value: nil)

			if let dd = dynamicDelegate, dd.handlesSelector(#selector(UISplitViewControllerDelegate.splitViewController(_:collapseSecondary:onto:))) {
				return ((dd as? UISplitViewControllerDelegate)?.splitViewController?(splitViewController, collapseSecondary: secondaryViewController, onto: primaryViewController) ?? false) || !shouldShowSecondary
			}
			return !shouldShowSecondary
		}
		
		open func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
			displayModeButton?.input.send(value: splitViewController.displayModeButtonItem)

			if let dd = dynamicDelegate, dd.handlesSelector(#selector(UISplitViewControllerDelegate.splitViewController(_:separateSecondaryFrom:))) {
				return (dd as? UISplitViewControllerDelegate)?.splitViewController?(splitViewController, separateSecondaryFrom: primaryViewController)
			}
			return nil
		}
	}

	open class Delegate: DynamicDelegate, UISplitViewControllerDelegate {
		public func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
			multiHandler(svc, displayMode)
		}
		
		public func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewController.DisplayMode {
			return singleHandler(svc)
		}
		
		public func splitViewControllerPreferredInterfaceOrientationForPresentation(_ splitViewController: UISplitViewController) -> UIInterfaceOrientation {
			return singleHandler(splitViewController)
		}
		
		public func splitViewControllerSupportedInterfaceOrientations(_ splitViewController: UISplitViewController) -> UIInterfaceOrientationMask {
			return singleHandler(splitViewController)
		}
		
		public func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
			return singleHandler(splitViewController)
		}
		
		public func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
			return singleHandler(splitViewController)
		}
		
		public func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
			return singleHandler(splitViewController, vc, sender)
		}
		
		public func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
			return singleHandler(splitViewController, vc, sender)
		}

		public func splitViewController(_ splitViewController: UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool {
			return singleHandler(splitViewController, secondaryViewController, ontoPrimaryViewController)
		}
		
		public func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
			return singleHandler(splitViewController, primaryViewController)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SplitViewControllerBinding {
	public typealias SplitViewControllerName<V> = BindingName<V, SplitViewController.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> SplitViewController.Binding) -> SplitViewControllerName<V> {
		return SplitViewControllerName<V>(source: source, downcast: Binding.splitViewControllerBinding)
	}
}
public extension BindingName where Binding: SplitViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SplitViewControllerName<$2> { return .name(SplitViewController.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var backgroundView: SplitViewControllerName<Constant<View>> { return .name(SplitViewController.Binding.backgroundView) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var maximumPrimaryColumnWidth: SplitViewControllerName<Dynamic<CGFloat>> { return .name(SplitViewController.Binding.maximumPrimaryColumnWidth) }
	static var minimumPrimaryColumnWidth: SplitViewControllerName<Dynamic<CGFloat>> { return .name(SplitViewController.Binding.minimumPrimaryColumnWidth) }
	static var preferredDisplayMode: SplitViewControllerName<Dynamic<UISplitViewController.DisplayMode>> { return .name(SplitViewController.Binding.preferredDisplayMode) }
	static var preferredPrimaryColumnWidthFraction: SplitViewControllerName<Dynamic<CGFloat>> { return .name(SplitViewController.Binding.preferredPrimaryColumnWidthFraction) }
	static var presentsWithGesture: SplitViewControllerName<Dynamic<Bool>> { return .name(SplitViewController.Binding.presentsWithGesture) }
	static var primaryViewController: SplitViewControllerName<Dynamic<ViewControllerConvertible>> { return .name(SplitViewController.Binding.primaryViewController) }
	static var secondaryViewController: SplitViewControllerName<Dynamic<ViewControllerConvertible>> { return .name(SplitViewController.Binding.secondaryViewController) }
	static var shouldShowSecondary: SplitViewControllerName<Dynamic<Bool>> { return .name(SplitViewController.Binding.shouldShowSecondary) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var dismissedSecondary: SplitViewControllerName<SignalInput<Void>> { return .name(SplitViewController.Binding.dismissedSecondary) }
	static var displayModeButton: SplitViewControllerName<SignalInput<BarButtonItemConvertible?>> { return .name(SplitViewController.Binding.displayModeButton) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var collapseSecondary: SplitViewControllerName<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool> { return .name(SplitViewController.Binding.collapseSecondary) }
	static var preferredInterfaceOrientation: SplitViewControllerName<(UISplitViewController) -> UIInterfaceOrientation> { return .name(SplitViewController.Binding.preferredInterfaceOrientation) }
	static var primaryViewControllerForCollapsing: SplitViewControllerName<(UISplitViewController) -> UIViewController?> { return .name(SplitViewController.Binding.primaryViewControllerForCollapsing) }
	static var primaryViewControllerForExpanding: SplitViewControllerName<(UISplitViewController) -> UIViewController?> { return .name(SplitViewController.Binding.primaryViewControllerForExpanding) }
	static var separateSecondary: SplitViewControllerName<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?> { return .name(SplitViewController.Binding.separateSecondary) }
	static var showPrimaryViewController: SplitViewControllerName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool> { return .name(SplitViewController.Binding.showPrimaryViewController) }
	static var showSecondaryViewController: SplitViewControllerName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool> { return .name(SplitViewController.Binding.showSecondaryViewController) }
	static var supportedInterfaceOrientations: SplitViewControllerName<(UISplitViewController) -> UIInterfaceOrientationMask> { return .name(SplitViewController.Binding.supportedInterfaceOrientations) }
	static var targetDisplayModeForAction: SplitViewControllerName<(UISplitViewController) -> UISplitViewController.DisplayMode> { return .name(SplitViewController.Binding.targetDisplayModeForAction) }
	static var willChangeDisplayMode: SplitViewControllerName<(UISplitViewController, UISplitViewController.DisplayMode) -> Void> { return .name(SplitViewController.Binding.willChangeDisplayMode) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SplitViewControllerConvertible: ViewControllerConvertible {
	func uiSplitViewController() -> SplitViewController.Instance
}
extension SplitViewControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiSplitViewController() }
}
extension UISplitViewController: SplitViewControllerConvertible, HasDelegate {
	public func uiSplitViewController() -> SplitViewController.Instance { return self }
}
public extension SplitViewController {
	func uiSplitViewController() -> SplitViewController.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SplitViewControllerBinding: ViewControllerBinding {
	static func splitViewControllerBinding(_ binding: SplitViewController.Binding) -> Self
	func asSplitViewControllerBinding() -> SplitViewController.Binding?
}
public extension SplitViewControllerBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return splitViewControllerBinding(.inheritedBinding(binding))
	}
}
public extension SplitViewControllerBinding where Preparer.Inherited.Binding: SplitViewControllerBinding {
	func asSplitViewControllerBinding() -> SplitViewController.Binding? {
		return asInheritedBinding()?.asSplitViewControllerBinding()
	}
}
public extension SplitViewController.Binding {
	typealias Preparer = SplitViewController.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asSplitViewControllerBinding() -> SplitViewController.Binding? { return self }
	static func splitViewControllerBinding(_ binding: SplitViewController.Binding) -> SplitViewController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
