//
//  DatePickerView.swift
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

import CwlViews

struct DatePickerViewState: CodableContainer {
	// Set min as iOS release date
	static let min: Date? = {
		let formatter = DateFormatter.dateFormatter
		return formatter.date(from: "2007/06/29")
	}()
	// Set max two years into the future
	static let max: Date? = {
		let date = Date()
		var components = DateComponents()
		components.setValue(2, for: .year)
		return Calendar.current.date(byAdding: components, to: date)
	}()
	// Set initial date as now
	static let initial = Date()

	let date: Var<Date>
	init() {
		date = Var(DatePickerViewState.initial)
	}
}

func datePickerView(_ datePickerViewState: DatePickerViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {

	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				marginEdges: .allLayout,
				.view(
				Label(
					.text <-- datePickerViewState.date.allChanges().map { DateFormatter.dateFormatter.string(from: $0) },
					.font -- UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .regular))),
				.space(),
				.view(
					DatePicker(
						.locale -- Locale.current,
						.datePickerMode -- .date,
						.minimumDate -- DatePickerViewState.min,
						.maximumDate -- DatePickerViewState.max,
						.date <-- datePickerViewState.date.map { .animate($0) },
						.action(.valueChanged, \.date) --> datePickerViewState.date.update()
					)
				)
			)
		)
	)
}

private extension DateFormatter {
	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy/MM/dd"
		return formatter
	}()
}

