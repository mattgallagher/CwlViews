//
//  CwlDatePickerTesting_iOS.swift
//  CwlViewsCatalog_iOS
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

extension BindingParser where Downcast: DatePickerBinding {

	//	0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var calendar: BindingParser<Dynamic<Calendar>, DatePicker.Binding, Downcast> { return .init(extract: { if case .calendar(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }
	public static var countDownDuration: BindingParser<Dynamic<TimeInterval>, DatePicker.Binding, Downcast> { return .init(extract: { if case .countDownDuration(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }
	public static var date: BindingParser<Dynamic<SetOrAnimate<Date>>, DatePicker.Binding, Downcast> { return .init(extract: { if case .date(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }
	public static var datePickerMode: BindingParser<Dynamic<UIDatePicker.Mode>, DatePicker.Binding, Downcast> { return .init(extract: { if case .datePickerMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }
	public static var locale: BindingParser<Dynamic<Locale?>, DatePicker.Binding, Downcast> { return .init(extract: { if case .locale(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }
	public static var maximumDate: BindingParser<Dynamic<Date?>, DatePicker.Binding, Downcast> { return .init(extract: { if case .maximumDate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }
	public static var minimumDate: BindingParser<Dynamic<Date?>, DatePicker.Binding, Downcast> { return .init(extract: { if case .minimumDate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }
	public static var minuteInterval: BindingParser<Dynamic<Int>, DatePicker.Binding, Downcast> { return .init(extract: { if case .minuteInterval(let x) = $0 { return x } else { return nil } }, upcast: { $0.asDatePickerBinding() }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
