//
//  CwlControl.swift
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

public class Control: ConstructingBinder, ControlConvertible {
	public typealias Instance = UIControl
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiControl() -> Instance { return instance() }
	
	public enum Binding: ControlBinding {
		public typealias EnclosingBinder = Control
		public static func controlBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case isEnabled(Dynamic<Bool>)
		case isSelected(Dynamic<Bool>)
		case isHighlighted(Dynamic<Bool>)
		case contentVerticalAlignment(Dynamic<UIControl.ContentVerticalAlignment>)
		case contentHorizontalAlignment(Dynamic<UIControl.ContentHorizontalAlignment>)
		case actions(Dynamic<ControlActions>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Control
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .isEnabled(let x): return x.apply(instance, storage) { i, s, v in i.isEnabled = v }
			case .isSelected(let x): return x.apply(instance, storage) { i, s, v in i.isSelected = v }
			case .isHighlighted(let x): return x.apply(instance, storage) { i, s, v in i.isHighlighted = v }
			case .contentVerticalAlignment(let x): return x.apply(instance, storage) { i, s, v in i.contentVerticalAlignment = v }
			case .contentHorizontalAlignment(let x): return x.apply(instance, storage) { i, s, v in i.contentHorizontalAlignment = v }
			case .actions(let x):
				var previous: ScopedValues<UIControl.Event, ControlAction>? = nil
				var junctions = [Cancellable]()
				var cancellable = x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.removeTarget(nil, action: nil, for: c.0)
						}
					}
					previous = v
					junctions.removeAll()
					for c in v.pairs {
						switch c.1 {
						case .firstResponder(let s):
							i.addTarget(nil, action: s, for: c.0)
						case .singleTarget(let s):
							let target = SignalControlEventActionTarget()
							i.addTarget(target, action: target.selector, for: c.0)
							junctions += target.signal.cancellableBind(to: s)
						}
					}
				}
				return OnDelete {
					for var j in junctions {
						j.cancel()
					}
					cancellable?.cancel()
				}
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = View.Storage
}

extension BindingName where Binding: ControlBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .controlBinding(Control.Binding.$1(v)) }) }
	public static var isEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.isEnabled(v)) }) }
	public static var isSelected: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.isSelected(v)) }) }
	public static var isHighlighted: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.isHighlighted(v)) }) }
	public static var contentVerticalAlignment: BindingName<Dynamic<UIControl.ContentVerticalAlignment>, Binding> { return BindingName<Dynamic<UIControl.ContentVerticalAlignment>, Binding>({ v in .controlBinding(Control.Binding.contentVerticalAlignment(v)) }) }
	public static var contentHorizontalAlignment: BindingName<Dynamic<UIControl.ContentHorizontalAlignment>, Binding> { return BindingName<Dynamic<UIControl.ContentHorizontalAlignment>, Binding>({ v in .controlBinding(Control.Binding.contentHorizontalAlignment(v)) }) }
	public static var actions: BindingName<Dynamic<ControlActions>, Binding> { return BindingName<Dynamic<ControlActions>, Binding>({ v in .controlBinding(Control.Binding.actions(v)) }) }
}

extension BindingName where Binding: ControlBinding, Binding.EnclosingBinder: BinderChain {
	// Additional helper binding names
	
	// This is the *preferred* construction of actions.
	public static func action<I: SignalInputInterface>(_ scope: UIControl.Event) -> BindingName<I, Binding> where I.InputValue == Void {
		return BindingName<I, Binding>({ (v: I) -> Binding in
			Binding.controlBinding(Control.Binding.actions(.constant(ControlActions.value(.singleTarget(Input<(UIControl, UIEvent)>().map { c, e in () }.bind(to: v.input)), for: scope))))
		})
	}
	public static func action<I: SignalInputInterface, Value>(_ scope: UIControl.Event, _ keyPath: KeyPath<Binding.EnclosingBinder.Instance, Value>) -> BindingName<I, Binding> where I.InputValue == Value {
		return BindingName<I, Binding> { (v: I) -> Binding in
			Binding.controlBinding(
				Control.Binding.actions(
					.constant(
						ControlActions.value(
							.singleTarget(
								Input<(UIControl, UIEvent)>()
									.map { c, e -> Value in
										(c as! Binding.EnclosingBinder.Instance)[keyPath: keyPath]
									}.bind(to: v.input)
							),
							for: scope
						)
					)
				)
			)
		}
	}
}

public protocol ControlConvertible: ViewConvertible {
	func uiControl() -> Control.Instance
}
extension ControlConvertible {
	public func uiView() -> View.Instance { return uiControl() }
}
extension Control.Instance: ControlConvertible {
	public func uiControl() -> Control.Instance { return self }
}

public protocol ControlBinding: ViewBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self
}
extension ControlBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return controlBinding(.inheritedBinding(binding))
	}
}

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
		
		// Otherwise, create a new one
		let (i, s) = Signal<(UIControl, UIEvent)>.create { s in
			// Instead of using a `isContinuous` transform, use a `buffer` to do the same thing while capturing `self` so that we're owned by the signal.
			s.customActivation { (b: inout Array<(UIControl, UIEvent)>, e: inout Error?, r: Result<(UIControl, UIEvent)>) in
				withExtendedLifetime(self) {}
				switch r {
				case .success(let v):
					b.removeAll(keepingCapacity: true)
					b.append(v)
				case .failure(let err):
					e = err
				}
			}
		}
		self.signalInput = i
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

