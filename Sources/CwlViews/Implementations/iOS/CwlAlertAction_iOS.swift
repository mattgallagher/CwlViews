//
//  CwlAlertAction_iOS.swift
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
public class AlertAction: Binder, AlertActionConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension AlertAction {
	enum Binding: AlertActionBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case style(Constant<UIAlertAction.Style>)
		case title(Constant<String>)

		//	1. Value bindings may be applied at construction and may subsequently change.
		case isEnabled(Dynamic<Bool>)

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.
		case handler(SignalInput<Void>)

		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension AlertAction {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = AlertAction.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = UIAlertAction
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		public var title: String? = nil
		public var style: UIAlertAction.Style = .default
		public var handler: MultiOutput<Void>? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension AlertAction.Preparer {
	func constructInstance(type: Instance.Type, parameters: Void) -> Instance {
		return type.init(title: title, style: style, handler: handler.map { h in
			{ _ in h.input.send(value: ()) }
		})
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let s): return inherited.prepareBinding(s)
		
		case .style(let x): style = x.value
		case .title(let x): title = x.value
		
		case .handler(let x):
			handler = handler ?? Input<Void>().multicast()
			handler?.signal.bind(to: x)
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .style: return nil
		case .title: return nil
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.
		case .handler: return handler?.input

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension AlertAction.Preparer {
	public typealias Storage = AssociatedBinderStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: AlertActionBinding {
	public typealias AlertActionName<V> = BindingName<V, AlertAction.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> AlertAction.Binding) -> AlertActionName<V> {
		return AlertActionName<V>(source: source, downcast: Binding.alertActionBinding)
	}
}
public extension BindingName where Binding: AlertActionBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: AlertActionName<$2> { return .name(AlertAction.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var style: AlertActionName<Constant<UIAlertAction.Style>> { return .name(AlertAction.Binding.style) }
	static var title: AlertActionName<Constant<String>> { return .name(AlertAction.Binding.title) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var isEnabled: AlertActionName<Dynamic<Bool>> { return .name(AlertAction.Binding.isEnabled) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	static var handler: AlertActionName<SignalInput<Void>> { return .name(AlertAction.Binding.handler) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol AlertActionConvertible {
	func uiAlertAction() -> AlertAction.Instance
}
extension UIAlertAction: AlertActionConvertible, DefaultConstructable {
	public func uiAlertAction() -> AlertAction.Instance { return self }
}
public extension AlertAction {
	func uiAlertAction() -> AlertAction.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol AlertActionBinding: BinderBaseBinding {
	static func alertActionBinding(_ binding: AlertAction.Binding) -> Self
}
public extension AlertActionBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return alertActionBinding(.inheritedBinding(binding))
	}
}
public extension AlertAction.Binding {
	typealias Preparer = AlertAction.Preparer
	static func alertActionBinding(_ binding: AlertAction.Binding) -> AlertAction.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
