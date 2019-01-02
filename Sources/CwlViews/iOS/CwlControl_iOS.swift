//
//  CwlControl_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/22.
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
public class Control: Binder, ControlConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Control {
	enum Binding: ControlBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case isEnabled(Dynamic<Bool>)
		case isSelected(Dynamic<Bool>)
		case isHighlighted(Dynamic<Bool>)
		case contentVerticalAlignment(Dynamic<UIControl.ContentVerticalAlignment>)
		case contentHorizontalAlignment(Dynamic<UIControl.ContentHorizontalAlignment>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case actions(ControlActions)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension Control {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Control.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UIControl
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Control.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .contentHorizontalAlignment(let x): return x.apply(instance) { i, v in i.contentHorizontalAlignment = v }
		case .contentVerticalAlignment(let x): return x.apply(instance) { i, v in i.contentVerticalAlignment = v }
		case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }
		case .isHighlighted(let x): return x.apply(instance) { i, v in i.isHighlighted = v }
		case .isSelected(let x): return x.apply(instance) { i, v in i.isSelected = v }
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case .actions(let x):
			var lifetimes = [Lifetime]()
			for (scope, value) in x.pairs {
				switch value {
				case .firstResponder(let s):
					instance.addTarget(nil, action: s, for: scope)
				case .singleTarget(let s):
					let target = SignalControlEventActionTarget()
					instance.addTarget(target, action: target.selector, for: scope)
					lifetimes += target.signal.cancellableBind(to: s)
				}
			}
			return AggregateLifetime(lifetimes: lifetimes)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Control.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ControlBinding {
	public typealias ControlName<V> = BindingName<V, Control.Binding, Binding>
	private typealias B = Control.Binding
	private static func name<V>(_ source: @escaping (V) -> Control.Binding) -> ControlName<V> {
		return ControlName<V>(source: source, downcast: Binding.controlBinding)
	}
}
public extension BindingName where Binding: ControlBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ControlName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var isEnabled: ControlName<Dynamic<Bool>> { return .name(B.isEnabled) }
	static var isSelected: ControlName<Dynamic<Bool>> { return .name(B.isSelected) }
	static var isHighlighted: ControlName<Dynamic<Bool>> { return .name(B.isHighlighted) }
	static var contentVerticalAlignment: ControlName<Dynamic<UIControl.ContentVerticalAlignment>> { return .name(B.contentVerticalAlignment) }
	static var contentHorizontalAlignment: ControlName<Dynamic<UIControl.ContentHorizontalAlignment>> { return .name(B.contentHorizontalAlignment) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var actions: ControlName<ControlActions> { return .name(B.actions) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	
	// Composite binding names
	static func action(_ scope: UIControl.Event) -> ControlName<SignalInput<UIControl>> {
		return Binding.mappedWrappedInputName(
			map: { tuple in tuple.0 },
			wrap: { input in ControlActions(scope: scope, value: ControlAction.singleTarget(input)) },
			binding: Control.Binding.actions,
			downcast: Binding.controlBinding
		)
	}
	static func action<Value>(_ scope: UIControl.Event, _ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> ControlName<SignalInput<Value>> {
		return Binding.mappedWrappedInputName(
			map: { tuple in (tuple.0 as! Binding.Preparer.Instance)[keyPath: keyPath] },
			wrap: { input in ControlActions(scope: scope, value: ControlAction.singleTarget(input)) },
			binding: Control.Binding.actions,
			downcast: Binding.controlBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ControlConvertible: ViewConvertible {
	func uiControl() -> Control.Instance
}
extension ControlConvertible {
	public func uiView() -> View.Instance { return uiControl() }
}
extension UIControl: ControlConvertible {
	public func uiControl() -> Control.Instance { return self }
}
public extension Control {
	func uiControl() -> Control.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ControlBinding: ViewBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self
}
public extension ControlBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return controlBinding(.inheritedBinding(binding))
	}
}
public extension Control.Binding {
	public typealias Preparer = Control.Preparer
	static func controlBinding(_ binding: Control.Binding) -> Control.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public enum ControlAction {
	case firstResponder(Selector)
	case singleTarget(SignalInput<(UIControl, UIEvent)>)
}

public typealias ControlActions = ScopedValues<UIControl.Event, ControlAction>

extension ScopedValues where Scope == UIControl.State {
	public static func normal(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .normal)
	}
	public static func highlighted(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .highlighted)
	}
	public static func disabled(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .disabled)
	}
	public static func selected(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .selected)
	}
	@available(iOS 9.0, *)
	public static func focused(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .focused)
	}
	public static func application(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .application)
	}
	public static func reserved(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .reserved)
	}
}

open class SignalControlEventActionTarget: NSObject {
	private var signalInput: SignalInput<(UIControl, UIEvent)>? = nil
	
	// Ownership note: we are owned by the output signal so we only weakly retain it.
	private weak var signalOutput: SignalMulti<(UIControl, UIEvent)>? = nil
	
	/// The `signal` emits the actions received
	public var signal: SignalMulti<(UIControl, UIEvent)> {
		// If there's a current signal output, return it
		if let so = signalOutput {
			return so
		}
		
		let s = Signal<(UIControl, UIEvent)>.generate { i in self.signalInput = i }.continuous()
		self.signalOutput = s
		return s
	}
	
	/// Receiver function for the target-action events
	///
	/// - Parameter sender: typical target-action "sender" parameter
	@IBAction public func cwlSignalAction(_ sender: UIControl, forEvent event: UIEvent) {
		_ = signalInput?.send(value: (sender, event))
	}
	
	/// Convenience accessor for `#selector(SignalActionTarget<Value>.action(_:))`
	public var selector: Selector { return #selector(SignalControlEventActionTarget.cwlSignalAction(_:forEvent:)) }
}

#endif
