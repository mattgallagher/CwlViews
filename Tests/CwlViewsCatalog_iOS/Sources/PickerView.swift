//
//  PickerView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 22/5/19.
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

struct PickerViewState: CodableContainer {
	static let min = 1
	static let max = 100
	
	var selectedRow: Var<[String]>
	var digit: Var<String>
	init() {
		selectedRow = Var([String(PickerViewState.min), String(PickerViewState.max)])
		digit = Var(String(PickerViewState.min))
	}
}

func pickerView(_ viewState: PickerViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				marginEdges: .allLayout,
				.view(
					Label(
						.text <-- viewState.selectedRow.map { $0.reduce("") { result, next in result + "\(next)\t"  } },
						.font -- UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
					)
				),
				.space(),
				.view(
					PickerView<String>(
						.pickerData -- [
							(PickerViewState.min...PickerViewState.max).map(String.init) as [String],
							(PickerViewState.min...PickerViewState.max).reversed().map(String.init) as [String]
						],
						.selectionChanged --> viewState.selectedRow,
						.viewConstructor -- { identifier, data in
							Label(
								.text <-- data.map { $0 },
								.textColor -- .blue
							)
						},
						.rowHeightForComponent -- { pickerView, component, data in 60 as CGFloat },
						.widthForComponent -- { pickerView, component, data in 35 as CGFloat }
					)
				),
				.space(40),
				.view(
					Label(
						.text <-- viewState.digit,
						.font -- UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
					)
				),
				.space(),
				.view(
					PickerView<String>(
						.pickerData -- [(PickerViewState.min...PickerViewState.max).map(String.init) as [String]],
						.rowSelected --> Input().map { $0.data }.bind(to: viewState.digit),
						.attributedTitle -- {
							(($0.location.row % 2) == 1) ? nil : .init(string: $0.data, attributes: [.foregroundColor: UIColor.red])
						},
						.title -- { (($0.location.row % 2) == 0) ? nil : $0.data }
					)
				)
			)
		)
	)
}
