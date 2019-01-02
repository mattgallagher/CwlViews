//
//  CwlAlertController_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/05.
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
public class AlertController: Binder, AlertControllerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension AlertController {
	enum Binding: AlertControllerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case actions(Constant<[AlertActionConvertible]>)
		case preferredStyle(Constant<UIAlertController.Style>)
		case textFields(Constant<[TextField]>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case message(Dynamic<String?>)
		case preferredActionIndex(Dynamic<Int?>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension AlertController {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = AlertController.Binding
		public typealias Inherited = ViewController.Preparer
		public typealias Instance = UIAlertController
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var title = InitialSubsequent<String>()
		var message = InitialSubsequent<String?>()
		var preferredStyle: UIAlertController.Style = .alert
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension AlertController.Preparer {
	func constructInstance(subclass: Instance.Type, parameters: Void) -> Instance {
		return subclass.init(title: title.initial, message: message.initial ?? nil, preferredStyle: preferredStyle)
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(.title(let x)): title = x.initialSubsequent()
		case .inheritedBinding(let s): return inherited.prepareBinding(s)
		case .preferredStyle(let x): preferredStyle = x.value
		case .message(let x): message = x.initialSubsequent()
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .actions(let x):
			for a in x.value {
				instance.addAction(a.uiAlertAction())
			}
			return nil
		case .preferredStyle: return nil
		case .textFields(let x):
			for bindings in x.value {
				instance.addTextField { textField in bindings.apply(to: textField) }
			}
			return nil
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .message(let x): return x.apply(instance) { i, v in i.message = v }
		case .preferredActionIndex(let x): return x.apply(instance) { i, v in i.preferredAction = v.map { i.actions[$0] } }
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension AlertController.Preparer {
	public typealias Storage = ViewController.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: AlertControllerBinding {
	public typealias AlertControllerName<V> = BindingName<V, AlertController.Binding, Binding>
	private typealias B = AlertController.Binding
	private static func name<V>(_ source: @escaping (V) -> AlertController.Binding) -> AlertControllerName<V> {
		return AlertControllerName<V>(source: source, downcast: Binding.alertControllerBinding)
	}
}
public extension BindingName where Binding: AlertControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: AlertControllerName<$2> { return .name(B.$1) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol AlertControllerConvertible: ViewControllerConvertible {
	func uiAlertController() -> AlertController.Instance
}
extension AlertControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiAlertController() }
}
extension UIAlertController: AlertControllerConvertible {
	public func uiAlertController() -> AlertController.Instance { return self }
}
public extension AlertController {
	func uiAlertController() -> AlertController.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol AlertControllerBinding: ViewControllerBinding {
	static func alertControllerBinding(_ binding: AlertController.Binding) -> Self
}
public extension AlertControllerBinding {
	static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return alertControllerBinding(.inheritedBinding(binding))
	}
}
public extension AlertController.Binding {
	public typealias Preparer = AlertController.Preparer
	static func alertControllerBinding(_ binding: AlertController.Binding) -> AlertController.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
