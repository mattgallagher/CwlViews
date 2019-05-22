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
	var selectedRow: TempVar<PickerRowAndComponent>
	init() {
		selectedRow = TempVar<PickerRowAndComponent>()
	}
}

func pickerView(_ viewState: PickerViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	//let moreFirstThing = PickerComponent<Void>.ComponentType.text("hello")
    //let firstThing = PickerComponent<Void>(width: 100,  rowHeight: 50, elements: [])
	//let things: Dynamic<PickerComponentMutation<PickerComponent<Void>>> = .reload([PickerComponent<Void>(width: 100,  rowHeight: 50, elements: [.text("1"), .text("2"), .text("3")])])
//	PickerView<Void>(
//		.backgroundColor -- .red,
//		.pickerData -- .reload([PickerComponent<Void>(elements: [.text("1"), .text("2"), .text("3")])]),
//		.row
//	)

	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				marginEdges: .allLayout,
				.view(
					Label(
						.text <-- viewState.selectedRow.map { value in return "\(value)"},
						.font -- UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
					)
				),
				.space(),
				.view(
					PickerView<Void>(
						.backgroundColor -- .red,
						.pickerData -- .reload([PickerComponent<Void>(elements: [.text("1"), .text("2"), .text("3")])]),
						.rowSelected --> viewState.selectedRow
					)
				)
			)
		)
	)
}
