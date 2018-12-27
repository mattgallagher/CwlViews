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

public class AlertController: Binder, AlertControllerConvertible {
	public typealias Instance = UIAlertController
	public typealias Inherited = ViewController
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiAlertController() -> Instance { return instance() }
	
	enum Binding: AlertControllerBinding {
		public typealias EnclosingBinder = AlertController
		public static func alertControllerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case preferredStyle(Constant<UIAlertController.Style>)
		case textFields(Constant<[TextField]>)
		case actions(Constant<[AlertActionConvertible]>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case message(Dynamic<String?>)
		case preferredActionIndex(Dynamic<Int?>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = AlertController
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			return subclass.init(title: initialTitle, message: initialMessage ?? nil, preferredStyle: preferredStyle)
		}
		
		var title = InitialSubsequent<String>()
		var initialTitle: String? = nil
		var message = InitialSubsequent<String?>()
		var initialMessage: String?? = nil
		var preferredStyle: UIAlertController.Style = .alert
		
		public init() {}
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .preferredStyle(let x): preferredStyle = x.value
			case .message(let x):
				message = x.initialSubsequent()
				initialMessage = message.initial()
			case .inheritedBinding(.title(let x)):
				title = x.initialSubsequent()
				initialTitle = title.initial()
			case .inheritedBinding(let s): return inherited.prepareBinding(s)
			default: break
			}
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .preferredStyle: return nil
			case .actions(let x):
				for a in x.value {
					instance.addAction(a.uiAlertAction())
				}
				return nil
			case .textFields(let x):
				for bindings in x.value {
					instance.addTextField { textField in
						bindings.applyBindings(to: textField)
					}
				}
				return nil
			case .message(let x): return x.apply(instance) { i, v in i.message = v }
			case .preferredActionIndex(let x):
				return x.apply(instance) { i, v in
					i.preferredAction = v.map { i.actions[$0] }
				}
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = ViewController.Storage
}

extension BindingName where Binding: AlertControllerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .alertControllerBinding(AlertController.Binding.$1(v)) }) }
	public static var preferredStyle: BindingName<Constant<UIAlertController.Style>, Binding> { return BindingName<Constant<UIAlertController.Style>, Binding>({ v in .alertControllerBinding(AlertController.Binding.preferredStyle(v)) }) }
	public static var textFields: BindingName<Constant<[TextField]>, Binding> { return BindingName<Constant<[TextField]>, Binding>({ v in .alertControllerBinding(AlertController.Binding.textFields(v)) }) }
	public static var actions: BindingName<Constant<[AlertActionConvertible]>, Binding> { return BindingName<Constant<[AlertActionConvertible]>, Binding>({ v in .alertControllerBinding(AlertController.Binding.actions(v)) }) }
	public static var message: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .alertControllerBinding(AlertController.Binding.message(v)) }) }
	public static var preferredActionIndex: BindingName<Dynamic<Int?>, Binding> { return BindingName<Dynamic<Int?>, Binding>({ v in .alertControllerBinding(AlertController.Binding.preferredActionIndex(v)) }) }
}

public protocol AlertControllerConvertible: ViewControllerConvertible {
	func uiAlertController() -> AlertController.Instance
}
extension AlertControllerConvertible {
	public func uiViewController() -> ViewController.Instance { return uiAlertController() }
}
extension AlertController.Instance: AlertControllerConvertible {
	public func uiAlertController() -> AlertController.Instance { return self }
}

public protocol AlertControllerBinding: ViewControllerBinding {
	static func alertControllerBinding(_ binding: AlertController.Binding) -> Self
}
extension AlertControllerBinding {
	public static func viewControllerBinding(_ binding: ViewController.Binding) -> Self {
		return alertControllerBinding(.inheritedBinding(binding))
	}
}

#endif
