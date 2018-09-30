//
//  CwlControl.swift
//  CwlViews
//
//  Created by Matt Gallagher on 26/10/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
	public typealias Instance = NSControl
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsControl() -> Instance { return instance() }
	
	public enum Binding: ControlBinding {
		public typealias EnclosingBinder = Control
		public static func controlBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case alignment(Dynamic<NSTextAlignment>)
		case allowsExpansionToolTips(Dynamic<Bool>)
		case baseWritingDirection(Dynamic<NSWritingDirection>)
		case isContinuous(Dynamic<Bool>)
		case isEnabled(Dynamic<Bool>)
		case font(Dynamic<NSFont>)
		case formatter(Dynamic<Foundation.Formatter?>)
		case isHighlighted(Dynamic<Bool>)
		case ignoresMultiClick(Dynamic<Bool>)
		case lineBreakMode(Dynamic<NSLineBreakMode>)
		case refusesFirstResponder(Dynamic<Bool>)
		case size(Dynamic<NSControl.ControlSize>)
		case tag(Dynamic<Int>)
		case usesSingleLineMode(Dynamic<Bool>)
		case doubleValue(Dynamic<Double>)
		case floatValue(Dynamic<Float>)
		case intValue(Dynamic<Int32>)
		case integerValue(Dynamic<Int>)
		case objectValue(Dynamic<Any>)
		case stringValue(Dynamic<String>)
		case attributedStringValue(Dynamic<NSAttributedString>)
		case sendActionOn(Dynamic<NSEvent.EventTypeMask>)
		
		//	2. Signal bindings are performed on the object after construction.
		case abortEditing(Signal<Void>)
		case validateEditing(Signal<Void>)
		case performClick(Signal<Void>)
		case sizeToFit(Signal<Void>)
		
		//	3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		
		// See also: stringA
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case textDidChange((NSText) -> Void)
		case textDidBeginEditing((NSText) -> Void)
		case textDidEndEditing((NSText) -> Void)
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Control
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .alignment(let x): return x.apply(instance, storage) { i, s, v in i.alignment = v }
			case .allowsExpansionToolTips(let x): return x.apply(instance, storage) { i, s, v in i.allowsExpansionToolTips = v }
			case .baseWritingDirection(let x): return x.apply(instance, storage) { i, s, v in i.baseWritingDirection = v }
			case .isContinuous(let x): return x.apply(instance, storage) { i, s, v in i.isContinuous = v }
			case .isEnabled(let x): return x.apply(instance, storage, false) { i, s, v in i.isEnabled = v }
			case .font(let x): return x.apply(instance, storage) { i, s, v in i.font = v }
			case .formatter(let x): return x.apply(instance, storage) { i, s, v in i.formatter = v }
			case .isHighlighted(let x): return x.apply(instance, storage) { i, s, v in i.isHighlighted = v }
			case .ignoresMultiClick(let x): return x.apply(instance, storage) { i, s, v in i.ignoresMultiClick = v }
			case .lineBreakMode(let x): return x.apply(instance, storage) { i, s, v in i.lineBreakMode = v }
			case .refusesFirstResponder(let x): return x.apply(instance, storage) { i, s, v in i.refusesFirstResponder = v }
			case .size(let x): return x.apply(instance, storage) { i, s, v in i.controlSize = v }
			case .tag(let x): return x.apply(instance, storage) { i, s, v in i.tag = v }
			case .usesSingleLineMode(let x): return x.apply(instance, storage) { i, s, v in i.usesSingleLineMode = v }
			case .sendActionOn(let x): return x.apply(instance, storage) { i, s, v in _ = i.sendAction(on: v) }
			case .doubleValue(let x): return x.apply(instance, storage) { i, s, v in i.doubleValue = v }
			case .floatValue(let x): return x.apply(instance, storage) { i, s, v in i.floatValue = v }
			case .intValue(let x): return x.apply(instance, storage) { i, s, v in i.intValue = v }
			case .integerValue(let x): return x.apply(instance, storage) { i, s, v in i.integerValue = v }
			case .objectValue(let x): return x.apply(instance, storage) { i, s, v in i.objectValue = v }
			case .stringValue(let x): return x.apply(instance, storage) { i, s, v in i.stringValue = v }
			case .attributedStringValue(let x): return x.apply(instance, storage) { i, s, v in i.attributedStringValue = v }
			case .abortEditing(let x): return x.apply(instance, storage) { i, s, v in i.abortEditing() }
			case .validateEditing(let x): return x.apply(instance, storage) { i, s, v in i.validateEditing() }
			case .performClick(let x): return x.apply(instance, storage) { i, s, v in i.performClick(nil) }
			case .sizeToFit(let x): return x.apply(instance, storage) { i, s, v in i.sizeToFit() }
			case .textDidChange(let x):
				return Signal.notifications(name: NSControl.textDidChangeNotification, object: instance).compactMap { n in
					return n.userInfo?["NSFieldEditor"] as? NSText
				}.subscribeValues { x($0) }
			case .textDidBeginEditing(let x):
				return Signal.notifications(name: NSControl.textDidBeginEditingNotification, object: instance).compactMap { n in
					return n.userInfo?["NSFieldEditor"] as? NSText
				}.subscribeValues { x($0) }
			case .textDidEndEditing(let x):
				return Signal.notifications(name: NSControl.textDidEndEditingNotification, object: instance).compactMap { n in
					return n.userInfo?["NSFieldEditor"] as? NSText
				}.subscribeValues { x($0) }
			case .action(let x): return x.apply(instance: instance, constructTarget: SignalActionTarget.init, processor: { sender in sender as! Instance })
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

	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var alignment: BindingName<Dynamic<NSTextAlignment>, Binding> { return BindingName<Dynamic<NSTextAlignment>, Binding>({ v in .controlBinding(Control.Binding.alignment(v)) }) }
	public static var allowsExpansionToolTips: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.allowsExpansionToolTips(v)) }) }
	public static var baseWritingDirection: BindingName<Dynamic<NSWritingDirection>, Binding> { return BindingName<Dynamic<NSWritingDirection>, Binding>({ v in .controlBinding(Control.Binding.baseWritingDirection(v)) }) }
	public static var isContinuous: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.isContinuous(v)) }) }
	public static var isEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.isEnabled(v)) }) }
	public static var font: BindingName<Dynamic<NSFont>, Binding> { return BindingName<Dynamic<NSFont>, Binding>({ v in .controlBinding(Control.Binding.font(v)) }) }
	public static var formatter: BindingName<Dynamic<Foundation.Formatter?>, Binding> { return BindingName<Dynamic<Foundation.Formatter?>, Binding>({ v in .controlBinding(Control.Binding.formatter(v)) }) }
	public static var isHighlighted: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.isHighlighted(v)) }) }
	public static var ignoresMultiClick: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.ignoresMultiClick(v)) }) }
	public static var lineBreakMode: BindingName<Dynamic<NSLineBreakMode>, Binding> { return BindingName<Dynamic<NSLineBreakMode>, Binding>({ v in .controlBinding(Control.Binding.lineBreakMode(v)) }) }
	public static var refusesFirstResponder: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.refusesFirstResponder(v)) }) }
	public static var size: BindingName<Dynamic<NSControl.ControlSize>, Binding> { return BindingName<Dynamic<NSControl.ControlSize>, Binding>({ v in .controlBinding(Control.Binding.size(v)) }) }
	public static var tag: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .controlBinding(Control.Binding.tag(v)) }) }
	public static var usesSingleLineMode: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .controlBinding(Control.Binding.usesSingleLineMode(v)) }) }
	public static var doubleValue: BindingName<Dynamic<Double>, Binding> { return BindingName<Dynamic<Double>, Binding>({ v in .controlBinding(Control.Binding.doubleValue(v)) }) }
	public static var floatValue: BindingName<Dynamic<Float>, Binding> { return BindingName<Dynamic<Float>, Binding>({ v in .controlBinding(Control.Binding.floatValue(v)) }) }
	public static var intValue: BindingName<Dynamic<Int32>, Binding> { return BindingName<Dynamic<Int32>, Binding>({ v in .controlBinding(Control.Binding.intValue(v)) }) }
	public static var integerValue: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .controlBinding(Control.Binding.integerValue(v)) }) }
	public static var objectValue: BindingName<Dynamic<Any>, Binding> { return BindingName<Dynamic<Any>, Binding>({ v in .controlBinding(Control.Binding.objectValue(v)) }) }
	public static var stringValue: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .controlBinding(Control.Binding.stringValue(v)) }) }
	public static var attributedStringValue: BindingName<Dynamic<NSAttributedString>, Binding> { return BindingName<Dynamic<NSAttributedString>, Binding>({ v in .controlBinding(Control.Binding.attributedStringValue(v)) }) }
	public static var sendActionOn: BindingName<Dynamic<NSEvent.EventTypeMask>, Binding> { return BindingName<Dynamic<NSEvent.EventTypeMask>, Binding>({ v in .controlBinding(Control.Binding.sendActionOn(v)) }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var abortEditing: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .controlBinding(Control.Binding.abortEditing(v)) }) }
	public static var validateEditing: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .controlBinding(Control.Binding.validateEditing(v)) }) }
	public static var performClick: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .controlBinding(Control.Binding.performClick(v)) }) }
	public static var sizeToFit: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .controlBinding(Control.Binding.sizeToFit(v)) }) }
	
	//	3. Action bindings are triggered by the object after construction.
	public static var action: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .controlBinding(Control.Binding.action(v)) }) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var textDidChange: BindingName<(NSText) -> Void, Binding> { return BindingName<(NSText) -> Void, Binding>({ v in .controlBinding(Control.Binding.textDidChange(v)) }) }
	public static var textDidBeginEditing: BindingName<(NSText) -> Void, Binding> { return BindingName<(NSText) -> Void, Binding>({ v in .controlBinding(Control.Binding.textDidBeginEditing(v)) }) }
	public static var textDidEndEditing: BindingName<(NSText) -> Void, Binding> { return BindingName<(NSText) -> Void, Binding>({ v in .controlBinding(Control.Binding.textDidEndEditing(v)) }) }
}

extension BindingName where Binding: ControlBinding, Binding.EnclosingBinder: BinderChain {
	// Additional helper binding names
	public static func action<I: SignalInputInterface, Value>(_ keyPath: KeyPath<Binding.EnclosingBinder.Instance, Value>) -> BindingName<I, Binding> where I.InputValue == Value {
		return BindingName<I, Binding> { (v: I) -> Binding in
			Binding.controlBinding(
				Control.Binding.action(
					TargetAction.singleTarget(
						Input<Any?>()
							.map { c -> Value in (c as! Binding.EnclosingBinder.Instance)[keyPath: keyPath] }
							.bind(to: v.input)
					)
				)
			)
		}
	}
}
extension BindingName where Binding: ControlBinding {
	// Additional helper binding names
	public static var stringChanged: BindingName<SignalInput<String>, Binding> {
		return BindingName<SignalInput<String>, Binding> { (v: SignalInput<String>) -> Binding in
			Binding.controlBinding(
				Control.Binding.textDidChange { text in
					_ = v.input.send(text.string)
				}
			)
		}
	}
}

public protocol ControlConvertible: ViewConvertible {
	func nsControl() -> Control.Instance
}
extension ControlConvertible {
	public func nsView() -> View.Instance { return nsControl() }
}
extension Control.Instance: ControlConvertible {
	public func nsControl() -> Control.Instance { return self }
}

public protocol ControlBinding: ViewBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self
}

extension ControlBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return controlBinding(.inheritedBinding(binding))
	}
}

extension NSControl: TargetActionSender {}
