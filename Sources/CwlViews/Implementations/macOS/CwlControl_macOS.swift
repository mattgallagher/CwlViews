//
//  CwlControl_macOS.swift
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

#if os(macOS)

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
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case alignment(Dynamic<NSTextAlignment>)
		case allowsExpansionToolTips(Dynamic<Bool>)
		case attributedStringValue(Dynamic<NSAttributedString>)
		case baseWritingDirection(Dynamic<NSWritingDirection>)
		case doubleValue(Dynamic<Double>)
		case floatValue(Dynamic<Float>)
		case font(Dynamic<NSFont>)
		case formatter(Dynamic<Foundation.Formatter?>)
		case ignoresMultiClick(Dynamic<Bool>)
		case integerValue(Dynamic<Int>)
		case intValue(Dynamic<Int32>)
		case isContinuous(Dynamic<Bool>)
		case isEnabled(Dynamic<Bool>)
		case isHighlighted(Dynamic<Bool>)
		case lineBreakMode(Dynamic<NSLineBreakMode>)
		case objectValue(Dynamic<Any>)
		case refusesFirstResponder(Dynamic<Bool>)
		case sendActionOn(Dynamic<NSEvent.EventTypeMask>)
		case size(Dynamic<NSControl.ControlSize>)
		case stringValue(Dynamic<String>)
		case tag(Dynamic<Int>)
		case usesSingleLineMode(Dynamic<Bool>)
		
		//	2. Signal bindings are performed on the object after construction.
		case abortEditing(Signal<Void>)
		case performClick(Signal<Void>)
		case sizeToFit(Signal<Void>)
		case validateEditing(Signal<Void>)
		
		//	3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case textDidBeginEditing((NSText) -> Void)
		case textDidChange((NSText) -> Void)
		case textDidEndEditing((NSText) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension Control {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Control.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSControl
		
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
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .alignment(let x): return x.apply(instance) { i, v in i.alignment = v }
		case .allowsExpansionToolTips(let x): return x.apply(instance) { i, v in i.allowsExpansionToolTips = v }
		case .attributedStringValue(let x): return x.apply(instance) { i, v in i.attributedStringValue = v }
		case .baseWritingDirection(let x): return x.apply(instance) { i, v in i.baseWritingDirection = v }
		case .doubleValue(let x): return x.apply(instance) { i, v in i.doubleValue = v }
		case .floatValue(let x): return x.apply(instance) { i, v in i.floatValue = v }
		case .font(let x): return x.apply(instance) { i, v in i.font = v }
		case .formatter(let x): return x.apply(instance) { i, v in i.formatter = v }
		case .ignoresMultiClick(let x): return x.apply(instance) { i, v in i.ignoresMultiClick = v }
		case .integerValue(let x): return x.apply(instance) { i, v in i.integerValue = v }
		case .intValue(let x): return x.apply(instance) { i, v in i.intValue = v }
		case .isContinuous(let x): return x.apply(instance) { i, v in i.isContinuous = v }
		case .isEnabled(let x): return x.apply(instance, storage, false) { i, s, v in i.isEnabled = v }
		case .isHighlighted(let x): return x.apply(instance) { i, v in i.isHighlighted = v }
		case .lineBreakMode(let x): return x.apply(instance) { i, v in i.lineBreakMode = v }
		case .objectValue(let x): return x.apply(instance) { i, v in i.objectValue = v }
		case .refusesFirstResponder(let x): return x.apply(instance) { i, v in i.refusesFirstResponder = v }
		case .sendActionOn(let x): return x.apply(instance) { i, v in _ = i.sendAction(on: v) }
		case .size(let x): return x.apply(instance) { i, v in i.controlSize = v }
		case .stringValue(let x): return x.apply(instance) { i, v in i.stringValue = v }
		case .tag(let x): return x.apply(instance) { i, v in i.tag = v }
		case .usesSingleLineMode(let x): return x.apply(instance) { i, v in i.usesSingleLineMode = v }
			
		//	2. Signal bindings are performed on the object after construction.
		case .abortEditing(let x): return x.apply(instance) { i, v in i.abortEditing() }
		case .performClick(let x): return x.apply(instance) { i, v in i.performClick(nil) }
		case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }
		case .validateEditing(let x): return x.apply(instance) { i, v in i.validateEditing() }
			
		//	3. Action bindings are triggered by the object after construction.
		case .action(let x): return x.apply(to: instance, constructTarget: SignalActionTarget.init)
			
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .textDidBeginEditing(let x):
			return Signal.notifications(name: NSControl.textDidBeginEditingNotification, object: instance).compactMap { n in
				return n.userInfo?["NSFieldEditor"] as? NSText
			}.subscribeValues { x($0) }
		case .textDidChange(let x):
			return Signal.notifications(name: NSControl.textDidChangeNotification, object: instance).compactMap { n in
				return n.userInfo?["NSFieldEditor"] as? NSText
			}.subscribeValues { x($0) }
		case .textDidEndEditing(let x):
			return Signal.notifications(name: NSControl.textDidEndEditingNotification, object: instance).compactMap { n in
				return n.userInfo?["NSFieldEditor"] as? NSText
			}.subscribeValues { x($0) }
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
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var alignment: ControlName<Dynamic<NSTextAlignment>> { return .name(B.alignment) }
	static var allowsExpansionToolTips: ControlName<Dynamic<Bool>> { return .name(B.allowsExpansionToolTips) }
	static var attributedStringValue: ControlName<Dynamic<NSAttributedString>> { return .name(B.attributedStringValue) }
	static var baseWritingDirection: ControlName<Dynamic<NSWritingDirection>> { return .name(B.baseWritingDirection) }
	static var doubleValue: ControlName<Dynamic<Double>> { return .name(B.doubleValue) }
	static var floatValue: ControlName<Dynamic<Float>> { return .name(B.floatValue) }
	static var font: ControlName<Dynamic<NSFont>> { return .name(B.font) }
	static var formatter: ControlName<Dynamic<Foundation.Formatter?>> { return .name(B.formatter) }
	static var ignoresMultiClick: ControlName<Dynamic<Bool>> { return .name(B.ignoresMultiClick) }
	static var integerValue: ControlName<Dynamic<Int>> { return .name(B.integerValue) }
	static var intValue: ControlName<Dynamic<Int32>> { return .name(B.intValue) }
	static var isContinuous: ControlName<Dynamic<Bool>> { return .name(B.isContinuous) }
	static var isEnabled: ControlName<Dynamic<Bool>> { return .name(B.isEnabled) }
	static var isHighlighted: ControlName<Dynamic<Bool>> { return .name(B.isHighlighted) }
	static var lineBreakMode: ControlName<Dynamic<NSLineBreakMode>> { return .name(B.lineBreakMode) }
	static var objectValue: ControlName<Dynamic<Any>> { return .name(B.objectValue) }
	static var refusesFirstResponder: ControlName<Dynamic<Bool>> { return .name(B.refusesFirstResponder) }
	static var sendActionOn: ControlName<Dynamic<NSEvent.EventTypeMask>> { return .name(B.sendActionOn) }
	static var size: ControlName<Dynamic<NSControl.ControlSize>> { return .name(B.size) }
	static var stringValue: ControlName<Dynamic<String>> { return .name(B.stringValue) }
	static var tag: ControlName<Dynamic<Int>> { return .name(B.tag) }
	static var usesSingleLineMode: ControlName<Dynamic<Bool>> { return .name(B.usesSingleLineMode) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var abortEditing: ControlName<Signal<Void>> { return .name(B.abortEditing) }
	static var performClick: ControlName<Signal<Void>> { return .name(B.performClick) }
	static var sizeToFit: ControlName<Signal<Void>> { return .name(B.sizeToFit) }
	static var validateEditing: ControlName<Signal<Void>> { return .name(B.validateEditing) }
	
	//	3. Action bindings are triggered by the object after construction.
	static var action: ControlName<TargetAction> { return .name(B.action) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var textDidBeginEditing: ControlName<(NSText) -> Void> { return .name(B.textDidBeginEditing) }
	static var textDidChange: ControlName<(NSText) -> Void> { return .name(B.textDidChange) }
	static var textDidEndEditing: ControlName<(NSText) -> Void> { return .name(B.textDidEndEditing) }

	// Composite binding names
	static func action<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> ControlName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, Control.Binding.action, Binding.controlBinding)
	}
	static func stringChanged(_ void: Void = ()) -> ControlName<SignalInput<String>> {
		return Binding.compositeName(
			value: { input in { text in _ = input.send(value: text.string) } },
			binding: Control.Binding.textDidChange,
			downcast: Binding.controlBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ControlConvertible: ViewConvertible {
	func nsControl() -> Control.Instance
}
extension ControlConvertible {
	public func nsView() -> View.Instance { return nsControl() }
}
extension NSControl: ControlConvertible, TargetActionSender {
	public func nsControl() -> Control.Instance { return self }
}
public extension Control {
	func nsControl() -> Control.Instance { return instance() }
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
	typealias Preparer = Control.Preparer
	static func controlBinding(_ binding: Control.Binding) -> Control.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
