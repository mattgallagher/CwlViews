//
//  CwlSplitViewController.swift
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

public class SplitViewController: ConstructingBinder, SplitViewControllerConvertible {
	public typealias Instance = UISplitViewController
	public typealias Inherited = ViewController
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiSplitViewController() -> Instance { return instance() }
	
	public enum Binding: SplitViewControllerBinding {
		public typealias EnclosingBinder = SplitViewController
		public static func splitViewControllerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case primaryViewController(Dynamic<ViewControllerConvertible>)
		case secondaryViewController(Dynamic<ViewControllerConvertible>)
		case presentsWithGesture(Dynamic<Bool>)
		case preferredDisplayMode(Dynamic<UISplitViewController.DisplayMode>)
		case preferredPrimaryColumnWidthFraction(Dynamic<CGFloat>)
		case minimumPrimaryColumnWidth(Dynamic<CGFloat>)
		case maximumPrimaryColumnWidth(Dynamic<CGFloat>)
		case shouldShowSecondary(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case displayModeButton(SignalInput<BarButtonItemConvertible?>)
		case willChangeDisplayMode(SignalInput<UISplitViewController.DisplayMode>)
		case dismissedSecondary(SignalInput<Void>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case targetDisplayModeForAction((UISplitViewController) -> UISplitViewController.DisplayMode)
		case preferredInterfaceOrientation((UISplitViewController) -> UIInterfaceOrientation)
		case supportedInterfaceOrientations((UISplitViewController) -> UIInterfaceOrientationMask)
		case primaryViewControllerForCollapsing((UISplitViewController) -> UIViewController?)
		case collapseSecondary((UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool)
		case primaryViewControllerForExpanding((UISplitViewController) -> UIViewController?)
		case separateSecondary((UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?)
		case showPrimaryViewController((UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool)
		case showSecondaryViewController((UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool)
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = SplitViewController
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(nibName: nil, bundle: nil) }

		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var possibleDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}

		public var primary = InitialSubsequent<ViewControllerConvertible>()
		public var secondary = InitialSubsequent<ViewControllerConvertible>()

		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .primaryViewController(let x): primary = x.initialSubsequent()
			case .secondaryViewController(let x): secondary = x.initialSubsequent()
			case .willChangeDisplayMode(let x):
				let s = #selector(UISplitViewControllerDelegate.splitViewController(_:willChangeTo:))
				delegate().addSelector(s).willChangeDisplayMode = x
			case .targetDisplayModeForAction(let x):
				let s = #selector(UISplitViewControllerDelegate.targetDisplayModeForAction(in:))
				delegate().addSelector(s).targetDisplayMode = x
			case .preferredInterfaceOrientation(let x):
				let s = #selector(UISplitViewControllerDelegate.splitViewControllerPreferredInterfaceOrientationForPresentation(_:))
				delegate().addSelector(s).preferredInterfaceOrientation = x
			case .supportedInterfaceOrientations(let x):
				let s = #selector(UISplitViewControllerDelegate.splitViewControllerSupportedInterfaceOrientations(_:))
				delegate().addSelector(s).supportedInterfaceOrientations = x
			case .primaryViewControllerForCollapsing(let x):
				let s = #selector(UISplitViewControllerDelegate.primaryViewController(forCollapsing:))
				delegate().addSelector(s).primaryViewControllerForCollapsing = x
			case .primaryViewControllerForExpanding(let x):
				let s = #selector(UISplitViewControllerDelegate.primaryViewController(forExpanding:))
				delegate().addSelector(s).primaryViewControllerForExpanding = x
			case .showPrimaryViewController(let x):
				let s = #selector(UISplitViewControllerDelegate.splitViewController(_:show:sender:))
				delegate().addSelector(s).showPrimaryViewController = x
			case .showSecondaryViewController(let x):
				let s = #selector(UISplitViewControllerDelegate.splitViewController(_:showDetail:sender:))
				delegate().addSelector(s).showSecondaryViewController = x
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			if storage.inUse {
				instance.delegate = storage
			}

			storage.secondaryViewController = secondary.initial()?.uiViewController()
			instance.viewControllers = [primary.initial()?.uiViewController() ?? UIViewController()]
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .primaryViewController: return primary.resume()?.apply(instance, storage) { i, s, v in i.show(v.uiViewController(), sender: nil) }
			case .secondaryViewController:
				return secondary.resume()?.apply(instance, storage) { i, s, v in
					let vc = v.uiViewController()
					s.secondaryViewController = vc
					i.showDetailViewController(vc, sender: nil)
				}
			case .presentsWithGesture(let x): return x.apply(instance, storage) { i, s, v in i.presentsWithGesture = v }
			case .preferredDisplayMode(let x): return x.apply(instance, storage) { i, s, v in i.preferredDisplayMode = v }
			case .preferredPrimaryColumnWidthFraction(let x): return x.apply(instance, storage) { i, s, v in i.preferredPrimaryColumnWidthFraction = v }
			case .minimumPrimaryColumnWidth(let x): return x.apply(instance, storage) { i, s, v in i.minimumPrimaryColumnWidth = v }
			case .maximumPrimaryColumnWidth(let x): return x.apply(instance, storage) { i, s, v in i.maximumPrimaryColumnWidth = v }
			case .displayModeButton(let x):
				storage.displayModeButton = x
				return nil
			case .dismissedSecondary(let x):
				storage.dismissedSecondary = x
				return nil
			case .shouldShowSecondary(let x):
				return x.apply(instance, storage) { i, s, v in
					if v == true && s.shouldShowSecondary == false, let svc = s.secondaryViewController {
						i.showDetailViewController(svc, sender: nil)
					}
					s.shouldShowSecondary = v
				}
			case .willChangeDisplayMode: return nil
			case .targetDisplayModeForAction: return nil
			case .preferredInterfaceOrientation: return nil
			case .supportedInterfaceOrientations: return nil
			case .primaryViewControllerForCollapsing: return nil
			case .collapseSecondary(let x):
				storage.collapseSecondary = x
				return nil
			case .primaryViewControllerForExpanding: return nil
			case .separateSecondary(let x):
				storage.separateSecondary = x
				return nil
			case .showPrimaryViewController: return nil
			case .showSecondaryViewController: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}

		public mutating func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
			let lifetime = linkedPreparer.finalizeInstance(instance, storage: storage)
			if !instance.isCollapsed {
				storage.displayModeButton?.send(value: instance.displayModeButtonItem)
			}
			return lifetime
		}
	}

	open class Storage: ViewController.Storage, UISplitViewControllerDelegate {
		open var secondaryViewController: UIViewController? = nil
		open var shouldShowSecondary: Bool = true
		open var displayModeButton: SignalInput<BarButtonItemConvertible?>?
		open var dismissedSecondary: SignalInput<Void>?
		
		open override var inUse: Bool {
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
		
		open var collapseSecondary: ((UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool)?
		open func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
			displayModeButton?.send(value: nil)
			return (collapseSecondary?(splitViewController, secondaryViewController, primaryViewController) ?? false) || !shouldShowSecondary
		}
		
		open var separateSecondary: ((UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?)?
		open func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
			displayModeButton?.send(value: splitViewController.displayModeButtonItem)
			return separateSecondary?(splitViewController, primaryViewController)
		}
	}

	open class Delegate: DynamicDelegate, UISplitViewControllerDelegate {
		public required override init() {
			super.init()
		}
		
		open var willChangeDisplayMode: SignalInput<UISplitViewController.DisplayMode>?
		open func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
			willChangeDisplayMode!.send(value: displayMode)
		}
		
		open var targetDisplayMode: ((UISplitViewController) -> UISplitViewController.DisplayMode)?
		open func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewController.DisplayMode {
			return targetDisplayMode!(svc)
		}
		
		open var preferredInterfaceOrientation: ((UISplitViewController) -> UIInterfaceOrientation)?
		open func splitViewControllerPreferredInterfaceOrientationForPresentation(_ splitViewController: UISplitViewController) -> UIInterfaceOrientation {
			return preferredInterfaceOrientation!(splitViewController)
		}
		
		open var supportedInterfaceOrientations: ((UISplitViewController) -> UIInterfaceOrientationMask)?
		open func splitViewControllerSupportedInterfaceOrientations(_ splitViewController: UISplitViewController) -> UIInterfaceOrientationMask {
			return supportedInterfaceOrientations!(splitViewController)
		}
		
		open var primaryViewControllerForCollapsing: ((UISplitViewController) -> UIViewController?)?
		open func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
			return primaryViewControllerForCollapsing!(splitViewController)
		}
		
		open var primaryViewControllerForExpanding: ((UISplitViewController) -> UIViewController?)?
		open func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
			return primaryViewControllerForExpanding!(splitViewController)
		}
		
		open var showPrimaryViewController: ((UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool)?
		open func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
			return showPrimaryViewController!(splitViewController, vc, sender)
		}
		
		open var showSecondaryViewController: ((UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool)?
		open func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
			return showSecondaryViewController!(splitViewController, vc, sender)
		}
	}
}

extension BindingName where Binding: SplitViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.$1(v)) }) }
	public static var primaryViewController: BindingName<Dynamic<ViewControllerConvertible>, Binding> { return BindingName<Dynamic<ViewControllerConvertible>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.primaryViewController(v)) }) }
	public static var secondaryViewController: BindingName<Dynamic<ViewControllerConvertible>, Binding> { return BindingName<Dynamic<ViewControllerConvertible>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.secondaryViewController(v)) }) }
	public static var presentsWithGesture: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.presentsWithGesture(v)) }) }
	public static var preferredDisplayMode: BindingName<Dynamic<UISplitViewController.DisplayMode>, Binding> { return BindingName<Dynamic<UISplitViewController.DisplayMode>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.preferredDisplayMode(v)) }) }
	public static var preferredPrimaryColumnWidthFraction: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.preferredPrimaryColumnWidthFraction(v)) }) }
	public static var minimumPrimaryColumnWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.minimumPrimaryColumnWidth(v)) }) }
	public static var maximumPrimaryColumnWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.maximumPrimaryColumnWidth(v)) }) }
	public static var shouldShowSecondary: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.shouldShowSecondary(v)) }) }
	public static var displayModeButton: BindingName<SignalInput<BarButtonItemConvertible?>, Binding> { return BindingName<SignalInput<BarButtonItemConvertible?>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.displayModeButton(v)) }) }
	public static var willChangeDisplayMode: BindingName<SignalInput<UISplitViewController.DisplayMode>, Binding> { return BindingName<SignalInput<UISplitViewController.DisplayMode>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.willChangeDisplayMode(v)) }) }
	public static var dismissedSecondary: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.dismissedSecondary(v)) }) }
	public static var targetDisplayModeForAction: BindingName<(UISplitViewController) -> UISplitViewController.DisplayMode, Binding> { return BindingName<(UISplitViewController) -> UISplitViewController.DisplayMode, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.targetDisplayModeForAction(v)) }) }
	public static var preferredInterfaceOrientation: BindingName<(UISplitViewController) -> UIInterfaceOrientation, Binding> { return BindingName<(UISplitViewController) -> UIInterfaceOrientation, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.preferredInterfaceOrientation(v)) }) }
	public static var supportedInterfaceOrientations: BindingName<(UISplitViewController) -> UIInterfaceOrientationMask, Binding> { return BindingName<(UISplitViewController) -> UIInterfaceOrientationMask, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.supportedInterfaceOrientations(v)) }) }
	public static var primaryViewControllerForCollapsing: BindingName<(UISplitViewController) -> UIViewController?, Binding> { return BindingName<(UISplitViewController) -> UIViewController?, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.primaryViewControllerForCollapsing(v)) }) }
	public static var collapseSecondary: BindingName<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool, Binding> { return BindingName<(UISplitViewController, _ secondaryViewController: UIViewController, _ ontoPrimaryViewController: UIViewController) -> Bool, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.collapseSecondary(v)) }) }
	public static var primaryViewControllerForExpanding: BindingName<(UISplitViewController) -> UIViewController?, Binding> { return BindingName<(UISplitViewController) -> UIViewController?, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.primaryViewControllerForExpanding(v)) }) }
	public static var separateSecondary: BindingName<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?, Binding> { return BindingName<(UISplitViewController, _ fromPrimaryViewController: UIViewController) -> UIViewController?, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.separateSecondary(v)) }) }
	public static var showPrimaryViewController: BindingName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding> { return BindingName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.showPrimaryViewController(v)) }) }
	public static var showSecondaryViewController: BindingName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding> { return BindingName<(UISplitViewController, _ show: UIViewController, _ sender: Any?) -> Bool, Binding>({ v in .splitViewControllerBinding(SplitViewController.Binding.showSecondaryViewController(v)) }) }
}

public protocol SplitViewControllerConvertible: ViewControllerConvertible {
	func uiSplitViewController() -> SplitViewController.Instance
}
extension SplitViewControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiSplitViewController() }
}
extension SplitViewController.Instance: SplitViewControllerConvertible {
	public func uiSplitViewController() -> SplitViewController.Instance { return self }
}

public protocol SplitViewControllerBinding: ViewControllerBinding {
	static func splitViewControllerBinding(_ binding: SplitViewController.Binding) -> Self
}

extension SplitViewControllerBinding {
	public static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return splitViewControllerBinding(.inheritedBinding(binding))
	}
}
