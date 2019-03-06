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
		case willChangeDisplayMode(SignalInput<UISplitViewController.DisplayMode>)

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
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		public var primary = InitialSubsequent<ViewControllerConvertible>()
		public var secondary = InitialSubsequent<ViewControllerConvertible>()
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension SplitViewController.Preparer {
	var delegateIsRequired: Bool { return true }
	
	func constructInstance(type: Instance.Type, parameters: Void) -> Instance { return type.init(nibName: nil, bundle: nil) }

	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .collapseSecondary(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.splitViewController(_:collapseSecondary:onto:)))
		case .preferredInterfaceOrientation(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.splitViewControllerPreferredInterfaceOrientationForPresentation(_:)))
		case .primaryViewController(let x): primary = x.initialSubsequent()
		case .primaryViewControllerForCollapsing(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.primaryViewController(forCollapsing:)))
		case .primaryViewControllerForExpanding(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.primaryViewController(forExpanding:)))
		case .secondaryViewController(let x): secondary = x.initialSubsequent()
		case .separateSecondary(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.splitViewController(_:separateSecondaryFrom:)))
		case .showPrimaryViewController(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.splitViewController(_:show:sender:)))
		case .showSecondaryViewController(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.splitViewController(_:showDetail:sender:)))
		case .supportedInterfaceOrientations(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.splitViewControllerSupportedInterfaceOrientations(_:)))
		case .targetDisplayModeForAction(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.targetDisplayModeForAction(in:)))
		case .willChangeDisplayMode(let x): delegate().addHandler(x, #selector(UISplitViewControllerDelegate.splitViewController(_:willChangeTo:)))
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
		case .dismissedSecondary(let x):
			storage.dismissedSecondary = x
			return nil
		case .displayModeButton(let x):
			storage.displayModeButton = x
			return nil
		case .willChangeDisplayMode: return nil

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
		}
	}

	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		if !instance.isCollapsed {
			storage.displayModeButton?.send(value: instance.displayModeButtonItem)
		}
		return inheritedFinalizedInstance(instance, storage: storage)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SplitViewController.Preparer {
	open class Storage: ViewController.Preparer.Storage, UISplitViewControllerDelegate {
		open var secondaryViewController: UIViewController? = nil
		open var shouldShowSecondary: Bool = true
		open var displayModeButton: SignalInput<BarButtonItemConvertible?>?
		open var dismissedSecondary: SignalInput<Void>?
		
		open override var isInUse: Bool {
			return true
		}
		
		open func collapsedController(_ controller: UINavigationController) {
			if let svc = secondaryViewController, svc === controller {
				dismissedSecondary?.send(value: ())
			}
		}

		open override func viewWillAppear(controller: UIViewController, animated: Bool) {
			if let secondary = secondaryViewController, let splitViewController = controller as? UISplitViewController {
				splitViewController.viewControllers.append(secondary)
			}
			super.viewWillAppear(controller: controller, animated: animated)
		}
		
		open func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
			displayModeButton?.send(value: nil)

			if let dd = dynamicDelegate, dd.handlesSelector(#selector(UISplitViewControllerDelegate.splitViewController(_:collapseSecondary:onto:))) {
				return ((dd as? UISplitViewControllerDelegate)?.splitViewController?(splitViewController, collapseSecondary: secondaryViewController, onto: primaryViewController) ?? false) || !shouldShowSecondary
			}
			return !shouldShowSecondary
		}
		
		open func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
			displayModeButton?.send(value: splitViewController.displayModeButtonItem)

			if let dd = dynamicDelegate, dd.handlesSelector(#selector(UISplitViewControllerDelegate.splitViewController(_:separateSecondaryFrom:))) {
				return (dd as? UISplitViewControllerDelegate)?.splitViewController?(splitViewController, separateSecondaryFrom: primaryViewController)
			}
			return nil
		}
	}

	open class Delegate: DynamicDelegate, UISplitViewControllerDelegate {
		open func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
			handler(ofType: SignalInput<UISplitViewController.DisplayMode>.self)!.send(value: displayMode)
		}
		
		open func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewController.DisplayMode {
			return handler(ofType: ((UISplitViewController) -> UISplitViewController.DisplayMode).self)!(svc)
		}
		
		open func splitViewControllerPreferredInterfaceOrientationForPresentation(_ splitViewController: UISplitViewController) -> UIInterfaceOrientation {
			return handler(ofType: ((UISplitViewController) -> UIInterfaceOrientation).self)!(splitViewController)
		}
		
		open func splitViewControllerSupportedInterfaceOrientations(_ splitViewController: UISplitViewController) -> UIInterfaceOrientationMask {
			return handler(ofType: ((UISplitViewController) -> UIInterfaceOrientationMask).self)!(splitViewController)
		}
		
		open func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
			return handler(ofType: ((UISplitViewController) -> UIViewController?).self)!(splitViewController)
		}
		
		open func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
			return handler(ofType: ((UISplitViewController) -> UIViewController?).self)!(splitViewController)
		}
		
		open func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
			return handler(ofType: ((UISplitViewController, UIViewController, Any?) -> Bool).self)!(splitViewController, vc, sender)
		}
		
		open func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
			return handler(ofType: ((UISplitViewController, UIViewController, Any?) -> Bool).self)!(splitViewController, vc, sender)
		}

		open func splitViewController(_ splitViewController: UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool {
			return handler(ofType: ((UISplitViewController, UIViewController, UIViewController) -> Bool).self)!(splitViewController, secondaryViewController, ontoPrimaryViewController)
		}
		
		open func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
			return handler(ofType: ((UISplitViewController, UIViewController) -> UIViewController?).self)!(splitViewController, primaryViewController)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SplitViewControllerBinding {
	public typealias SplitViewControllerName<V> = BindingName<V, SplitViewController.Binding, Binding>
	private typealias B = SplitViewController.Binding
	private static func name<V>(_ source: @escaping (V) -> SplitViewController.Binding) -> SplitViewControllerName<V> {
		return SplitViewControllerName<V>(source: source, downcast: Binding.splitViewControllerBinding)
	}
}
public extension BindingName where Binding: SplitViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SplitViewControllerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var backgroundView: SplitViewControllerName<Constant<View>> { return .name(B.backgroundView) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var maximumPrimaryColumnWidth: SplitViewControllerName<Dynamic<CGFloat>> { return .name(B.maximumPrimaryColumnWidth) }
	static var minimumPrimaryColumnWidth: SplitViewControllerName<Dynamic<CGFloat>> { return .name(B.minimumPrimaryColumnWidth) }
	static var preferredDisplayMode: SplitViewControllerName<Dynamic<UISplitViewController.DisplayMode>> { return .name(B.preferredDisplayMode) }
	static var preferredPrimaryColumnWidthFraction: SplitViewControllerName<Dynamic<CGFloat>> { return .name(B.preferredPrimaryColumnWidthFraction) }
	static var presentsWithGesture: SplitViewControllerName<Dynamic<Bool>> { return .name(B.presentsWithGesture) }
	static var primaryViewController: SplitViewControllerName<Dynamic<ViewControllerConvertible>> { return .name(B.primaryViewController) }
	static var secondaryViewController: SplitViewControllerName<Dynamic<ViewControllerConvertible>> { return .name(B.secondaryViewController) }
	static var shouldShowSecondary: SplitViewControllerName<Dynamic<Bool>> { return .name(B.shouldShowSecondary) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var dismissedSecondary: SplitViewControllerName<SignalInput<Void>> { return .name(B.dismissedSecondary) }
	static var displayModeButton: SplitViewControllerName<SignalInput<BarButtonItemConvertible?>> { return .name(B.displayModeButton) }
	static var willChangeDisplayMode: SplitViewControllerName<SignalInput<UISplitViewController.DisplayMode>> { return .name(B.willChangeDisplayMode) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var collapseSecondary: SplitViewControllerName<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool> { return .name(B.collapseSecondary) }
	static var preferredInterfaceOrientation: SplitViewControllerName<(UISplitViewController) -> UIInterfaceOrientation> { return .name(B.preferredInterfaceOrientation) }
	static var primaryViewControllerForCollapsing: SplitViewControllerName<(UISplitViewController) -> UIViewController?> { return .name(B.primaryViewControllerForCollapsing) }
	static var primaryViewControllerForExpanding: SplitViewControllerName<(UISplitViewController) -> UIViewController?> { return .name(B.primaryViewControllerForExpanding) }
	static var separateSecondary: SplitViewControllerName<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?> { return .name(B.separateSecondary) }
	static var showPrimaryViewController: SplitViewControllerName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool> { return .name(B.showPrimaryViewController) }
	static var showSecondaryViewController: SplitViewControllerName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool> { return .name(B.showSecondaryViewController) }
	static var supportedInterfaceOrientations: SplitViewControllerName<(UISplitViewController) -> UIInterfaceOrientationMask> { return .name(B.supportedInterfaceOrientations) }
	static var targetDisplayModeForAction: SplitViewControllerName<(UISplitViewController) -> UISplitViewController.DisplayMode> { return .name(B.targetDisplayModeForAction) }
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
}
public extension SplitViewControllerBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return splitViewControllerBinding(.inheritedBinding(binding))
	}
}
public extension SplitViewController.Binding {
	typealias Preparer = SplitViewController.Preparer
	static func splitViewControllerBinding(_ binding: SplitViewController.Binding) -> SplitViewController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
