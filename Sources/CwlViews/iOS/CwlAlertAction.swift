//
//  CwlAlertAction.swift
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

public class AlertAction: ConstructingBinder, AlertActionConvertible {
	public typealias Instance = UIAlertAction
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiAlertAction() -> Instance { return instance() }
	
	public enum Binding: AlertActionBinding {
		public typealias EnclosingBinder = AlertAction
		public static func alertActionBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case title(Constant<String>)
		case style(Constant<UIAlertAction.Style>)

		//	1. Value bindings may be applied at construction and may subsequently change.
		case isEnabled(Dynamic<Bool>)

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.
		case handler(SignalInput<Void>)

		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = AlertAction
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			return subclass.init(title: title, style: style, handler: handler.map { h in
				{ _ in h.send(value: ()) }
			})
		}
		
		public var title: String? = nil
		public var style: UIAlertAction.Style = .default
		public var handler: SignalInput<Void>? = nil

		public init() {}
		
		public mutating func prepareBinding(_ binding: AlertAction.Binding) {
			switch binding {
			case .title(let x): title = x.value
			case .style(let x): style = x.value
			case .handler(let x): handler = x
			case .inheritedBinding(let s): return linkedPreparer.prepareBinding(s)
			default: break
			}
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .title: return nil
			case .style: return nil
			case .handler: return nil
			case .isEnabled(let x): return x.apply(instance, storage) { i, s, v in i.isEnabled = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: (), storage: ())
			}
		}
		
		public mutating func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
			let linkedLifetime = linkedPreparer.finalizeInstance(instance, storage: storage)
			return Array<Lifetime>([linkedLifetime, handler as Optional<Lifetime>].compactMap { $0 })
		}
	}

	public typealias Storage = ObjectBinderStorage
}

extension BindingName where Binding: AlertActionBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .alertActionBinding(AlertAction.Binding.$1(v)) }) }
	public static var title: BindingName<Constant<String>, Binding> { return BindingName<Constant<String>, Binding>({ v in .alertActionBinding(AlertAction.Binding.title(v)) }) }
	public static var style: BindingName<Constant<UIAlertAction.Style>, Binding> { return BindingName<Constant<UIAlertAction.Style>, Binding>({ v in .alertActionBinding(AlertAction.Binding.style(v)) }) }
	public static var handler: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .alertActionBinding(AlertAction.Binding.handler(v)) }) }
	public static var isEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .alertActionBinding(AlertAction.Binding.isEnabled(v)) }) }
}

public protocol AlertActionConvertible {
	func uiAlertAction() -> AlertAction.Instance
}
extension AlertAction.Instance: AlertActionConvertible {
	public func uiAlertAction() -> AlertAction.Instance { return self }
}

public protocol AlertActionBinding: BaseBinding {
	static func alertActionBinding(_ binding: AlertAction.Binding) -> Self
}
extension AlertActionBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return alertActionBinding(.inheritedBinding(binding))
	}
}
