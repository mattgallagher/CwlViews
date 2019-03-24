//
//  CwlExtendedViewController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 12/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class ExtendedViewController<Subclass: UIViewController & ViewControllerWithDelegate & HasDelegate>: Binder, ViewControllerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Subclass.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

extension ExtendedViewController where Subclass == CwlExtendedViewController {
	public convenience init(bindings: [Preparer.Binding]) {
		self.init(type: CwlExtendedViewController.self, parameters: (), bindings: bindings)
	}
	
	public convenience init(_ bindings: Preparer.Binding...) {
		self.init(type: CwlExtendedViewController.self, parameters: (), bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ExtendedViewController {
	enum Binding: ExtendedViewControllerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didAppear((UIViewController, Bool) -> Void)
		case didDisappear((UIViewController, Bool) -> Void)
		case didReceiveMemoryWarning((UIViewController) -> Void)
		case loadView(() -> ViewConvertible)
		case traitCollectionDidChange((UIViewController, UITraitCollection?) -> Void)
		case willAppear((UIViewController, Bool) -> Void)
		case willDisappear((UIViewController, Bool) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension ExtendedViewController {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = ExtendedViewController.Binding
		public typealias Inherited = ViewController.Preparer
		public typealias Instance = Subclass
		public typealias Parameters = () /* change if non-default construction required */
		
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

		public var loadView: (() -> ViewConvertible)?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ExtendedViewController.Preparer {
	var delegateIsRequired: Bool { return dynamicDelegate != nil || loadView != nil }
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(.view(let x)):
			precondition(loadView == nil, "Construct the view using either .loadView or .view, not both.")
			inherited.prepareBinding(.view(x))
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .didAppear(let x): delegate().addMultiHandler2(x, #selector(ViewControllerDelegate.viewDidAppear(controller:animated:)))
		case .didDisappear(let x): delegate().addMultiHandler2(x, #selector(ViewControllerDelegate.viewDidDisappear(controller:animated:)))
		case .traitCollectionDidChange(let x): delegate().addMultiHandler2(x, #selector(ViewControllerDelegate.traitCollectionDidChange(controller:previousTraitCollection:)))
		case .willAppear(let x): delegate().addMultiHandler2(x, #selector(ViewControllerDelegate.viewWillAppear(controller:animated:)))
		case .willDisappear(let x): delegate().addMultiHandler2(x, #selector(ViewControllerDelegate.viewWillDisappear(controller:animated:)))
		case .didReceiveMemoryWarning(let x): delegate().addMultiHandler1(x, #selector(ViewControllerDelegate.didReceiveMemoryWarning(controller:)))
		case .loadView(let x):
			precondition(inherited.view == nil, "Construct the view using either .loadView or .view, not both.")
			loadView = x
		}
	}
	
	func prepareInstance(_ instance: Subclass, storage: ExtendedViewController<Subclass>.Preparer.Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)
		if let lv = loadView {
			storage.viewConstructor = lv
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		case .didAppear: return nil
		case .didDisappear: return nil
		case .traitCollectionDidChange: return nil
		case .willAppear: return nil
		case .willDisappear: return nil
			
		case .didReceiveMemoryWarning: return nil
		case .loadView: return nil
		}
	}
	
	func finalizeInstance(_ instance: Subclass, storage: ExtendedViewController<Subclass>.Preparer.Storage) -> Lifetime? {
		let lifetime = inheritedFinalizedInstance(instance, storage: storage)

		// Send the initial "traitsCollection" once construction is complete.
		if let dd = dynamicDelegate, dd.handlesSelector(#selector(ViewControllerDelegate.traitCollectionDidChange(controller:previousTraitCollection:))) {
			dd.traitCollectionDidChange(controller: instance, previousTraitCollection: nil)
		}
		
		return lifetime
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ExtendedViewController.Preparer {
	open class Storage: ViewController.Preparer.Storage, ViewControllerDelegate {
		open var viewConstructor: (() -> ViewConvertible?)?
		
		public func loadView(controller: UIViewController) -> UIView? {
			if let wrapper = viewConstructor?() {
				return wrapper.uiView()
			}
			return nil
		}
		
		public func didReceiveMemoryWarning(controller: UIViewController) {
			if let dd = dynamicDelegate, dd.handlesSelector(#selector(ViewControllerDelegate.didReceiveMemoryWarning(controller:))) {
				(dd as? ViewControllerDelegate)?.didReceiveMemoryWarning?(controller: controller)
			}
			
			if viewConstructor != nil, let view = controller.viewIfLoaded, view.window == nil {
				controller.view = nil
			}
		}
	}

	open class Delegate: DynamicDelegate, ViewControllerDelegate {
		public func loadView(controller: UIViewController) -> UIView? {
			return nil
		}
		
		public func didReceiveMemoryWarning(controller: UIViewController) {
			multiHandler(controller)
		}
		
		public func traitCollectionDidChange(controller: UIViewController, previousTraitCollection: UITraitCollection?) {
			multiHandler(controller, previousTraitCollection)
		}
		
		public func viewWillAppear(controller: UIViewController, animated: Bool) {
			multiHandler(controller, animated)
		}
		
		public func viewDidAppear(controller: UIViewController, animated: Bool) {
			multiHandler(controller, animated)
		}
		
		public func viewWillDisappear(controller: UIViewController, animated: Bool) {
			multiHandler(controller, animated)
		}
		
		public func viewDidDisappear(controller: UIViewController, animated: Bool) {
			multiHandler(controller, animated)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ExtendedViewControllerBinding {
	public typealias ExtendedViewControllerName<V> = BindingName<V, ExtendedViewController<Binding.SubclassType>.Binding, Binding>
	private typealias B = ExtendedViewController<Binding.SubclassType>.Binding
	private static func name<V>(_ source: @escaping (V) -> ExtendedViewController<Binding.SubclassType>.Binding) -> ExtendedViewControllerName<V> {
		return ExtendedViewControllerName<V>(source: source, downcast: Binding.extendedViewControllerBinding)
	}
}
public extension BindingName where Binding: ExtendedViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ExtendedViewControllerName<$2> { return .name(B.$1) }

	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var didAppear: ExtendedViewControllerName<(UIViewController, Bool) -> Void> { return .name(B.didAppear) }
	static var didDisappear: ExtendedViewControllerName<(UIViewController, Bool) -> Void> { return .name(B.didDisappear) }
	static var didReceiveMemoryWarning: ExtendedViewControllerName<(UIViewController) -> Void> { return .name(B.didReceiveMemoryWarning) }
	static var loadView: ExtendedViewControllerName<() -> ViewConvertible> { return .name(B.loadView) }
	static var traitCollectionDidChange: ExtendedViewControllerName<(UIViewController, UITraitCollection?) -> Void> { return .name(B.traitCollectionDidChange) }
	static var willAppear: ExtendedViewControllerName<(UIViewController, Bool) -> Void> { return .name(B.willAppear) }
	static var willDisappear: ExtendedViewControllerName<(UIViewController, Bool) -> Void> { return .name(B.willDisappear) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public extension ExtendedViewController {
	func uiViewController() -> ViewController.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ExtendedViewControllerBinding: ViewControllerBinding {
	associatedtype SubclassType: UIViewController & ViewControllerWithDelegate & HasDelegate
	static func extendedViewControllerBinding(_ binding: ExtendedViewController<SubclassType>.Binding) -> Self

}
public extension ExtendedViewControllerBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return extendedViewControllerBinding(.inheritedBinding(binding))
	}
}
public extension ExtendedViewController.Binding {
	typealias Preparer = ExtendedViewController.Preparer
	static func extendedViewControllerBinding(_ binding: ExtendedViewController.Binding) -> ExtendedViewController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
@objc public protocol ViewControllerDelegate: class {
	@objc optional func loadView(controller: UIViewController) -> UIView?
	@objc optional func didReceiveMemoryWarning(controller: UIViewController)
	@objc optional func traitCollectionDidChange(controller: UIViewController, previousTraitCollection: UITraitCollection?)
	@objc optional func viewWillAppear(controller: UIViewController, animated: Bool)
	@objc optional func viewDidAppear(controller: UIViewController, animated: Bool)
	@objc optional func viewWillDisappear(controller: UIViewController, animated: Bool)
	@objc optional func viewDidDisappear(controller: UIViewController, animated: Bool)
}

public protocol ViewControllerWithDelegate {
	var delegate: ViewControllerDelegate? { get set }
}

/// Implementation of ViewControllerWithDelegate on top of the base UIViewController.
/// You can use this view controller directly, subclass it or implement `ViewControllerWithDelegate` and `HasDelegate` on top of another `UIViewController` to use that view controller with the `ExtendedViewController` binder.
open class CwlExtendedViewController: UIViewController, ViewControllerWithDelegate, HasDelegate {
	public unowned var delegate: ViewControllerDelegate?
	
	open override func loadView() {
		if let loaded = delegate?.loadView?(controller: self) {
			view = loaded
		} else {
			super.loadView()
		}
	}
	
	open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		delegate?.traitCollectionDidChange?(controller: self, previousTraitCollection: previousTraitCollection)
		super.traitCollectionDidChange(previousTraitCollection)
	}
	
	open override func viewWillAppear(_ animated: Bool) {
		delegate?.viewWillAppear?(controller: self, animated: animated)
		super.viewWillAppear(animated)
	}
	
	open override func viewDidAppear(_ animated: Bool) {
		delegate?.viewDidAppear?(controller: self, animated: animated)
		super.viewDidAppear(animated)
	}
	
	open override func viewWillDisappear(_ animated: Bool) {
		delegate?.viewWillDisappear?(controller: self, animated: animated)
		super.viewWillDisappear(animated)
	}
	
	open override func viewDidDisappear(_ animated: Bool) {
		delegate?.viewDidDisappear?(controller: self, animated: animated)
		super.viewDidDisappear(animated)
	}
	
	open override func didReceiveMemoryWarning() {
		delegate?.didReceiveMemoryWarning?(controller: self)
		super.didReceiveMemoryWarning()
	}
}

#endif
