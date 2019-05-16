//
//  CwlDatePicker_iOS.swift
//  CwlViews
//
//  Created by Sye Boddeus on 14/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class DatePicker: Binder, DatePickerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension DatePicker {
	enum Binding: DatePickerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case calendar(Dynamic<Calendar>)
		case countDownDuration(Dynamic<TimeInterval>)
		case date(Dynamic<SetOrAnimate<Date>>)
		case datePickerMode(Dynamic<UIDatePicker.Mode>)
		case locale(Dynamic<Locale?>)
		case maximumDate(Dynamic<Date?>)
		case minimumDate(Dynamic<Date?>)
		case minuteInterval(Dynamic<Int>)
		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension DatePicker {
	struct Preparer: BinderEmbedderConstructor /* or BinderDelegateEmbedderConstructor */ {
		public typealias Binding = DatePicker.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UIDatePicker
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension DatePicker.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		case .calendar(let x): return x.apply(instance) { i, v in i.calendar = v }
		case .countDownDuration(let x): return x.apply(instance) { i, v in i.countDownDuration = v }
		case .date(let x): return x.apply(instance) { i, v in i.setDate(v.value, animated: v.isAnimated) }
		case .datePickerMode(let x): return x.apply(instance) { i, v in i.datePickerMode = v }
		case .locale(let x): return x.apply(instance) { i, v in i.locale = v }
		case .maximumDate(let x): return x.apply(instance) { i, v in i.maximumDate = v }
		case .minimumDate(let x): return x.apply(instance) { i, v in i.minimumDate = v }
		case .minuteInterval(let x): return x.apply(instance) { i, v in i.minuteInterval = v }
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension DatePicker.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: DatePickerBinding {
	public typealias DatePickerName<V> = BindingName<V, DatePicker.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> DatePicker.Binding) -> DatePickerName<V> {
		return DatePickerName<V>(source: source, downcast: Binding.datePickerBinding)
	}
}
public extension BindingName where Binding: DatePickerBinding {
	static var calendar: DatePickerName<Dynamic<Calendar>> { return .name(DatePicker.Binding.calendar) }
	static var countDownDuration: DatePickerName<Dynamic<TimeInterval>> { return .name(DatePicker.Binding.countDownDuration) }
	static var date: DatePickerName<Dynamic<SetOrAnimate<Date>>> { return .name(DatePicker.Binding.date) }
	static var datePickerMode: DatePickerName<Dynamic<UIDatePicker.Mode>> { return .name(DatePicker.Binding.datePickerMode) }
	static var locale: DatePickerName<Dynamic<Locale?>> { return .name(DatePicker.Binding.locale) }
	static var maximumDate: DatePickerName<Dynamic<Date?>> { return .name(DatePicker.Binding.maximumDate) }
	static var minimumDate: DatePickerName<Dynamic<Date?>> { return .name(DatePicker.Binding.minimumDate) }
	static var minuteInterval: DatePickerName<Dynamic<Int>> { return .name(DatePicker.Binding.minuteInterval) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol DatePickerConvertible: ControlConvertible {
	func uiDatePicker() -> DatePicker.Instance
}
extension DatePickerConvertible {
	public func uiControl() -> Control.Instance { return uiDatePicker() }
}
extension UIDatePicker: DatePickerConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func uiDatePicker() -> DatePicker.Instance { return self }
}
public extension DatePicker {
	func uiDatePicker() -> DatePicker.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol DatePickerBinding: ControlBinding {
	static func datePickerBinding(_ binding: DatePicker.Binding) -> Self
	func asDatePickerBinding() -> DatePicker.Binding?
}
public extension DatePickerBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return datePickerBinding(.inheritedBinding(binding))
	}
}
extension DatePickerBinding where Preparer.Inherited.Binding: DatePickerBinding {
	func asDatePickerBinding() -> DatePicker.Binding? {
		return asInheritedBinding()?.asDatePickerBinding()
	}
}
public extension DatePicker.Binding {
	typealias Preparer = DatePicker.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asDatePickerBinding() -> DatePicker.Binding? { return self }
	static func datePickerBinding(_ binding: DatePicker.Binding) -> DatePicker.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
