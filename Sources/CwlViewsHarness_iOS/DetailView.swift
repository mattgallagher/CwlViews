//
//  DetailView.swift
//  CwlViewsHarness_iOS
//
//  Created by Matt Gallagher on 2017/07/31.
//  Copyright © 2017 Matt Gallagher. All rights reserved.
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

struct DetailViewState: StateContainer {
	let row: String
	let showChild: ToggleAdapter
	
	init(row: String) {
		self.row = row
		self.showChild = ToggleAdapter(false)
	}
	
	var childValues: [StateContainer] { return [showChild] }
}

func detailViewController(_ detailState: DetailViewState, _ doc: DocumentAdapter) -> ViewControllerConvertible {
	return ViewController(
		.title -- .localizedStringWithFormat(.titleText, detailState.row),
		.layout <-- layoutWithAnimation(detailState),
		.loadView -- { View(.backgroundColor -- .white) }
	)
}

func layoutWithAnimation(_ detailState: DetailViewState) -> Signal<Layout> {
	let childView = View(
		.backgroundColor -- .red,
		.layout <-- detailState.showChild.map { show in
			show ? .horizontal(align: .center,
				.view(Label(
					.textAlignment -- .center,
					.text -- "Hello there!"
				))
			) :.horizontal()
		}
	)
	let fixedLayout = Layout.Entity.vertical(align: .center,
		.space(),
		.view(Label(.text -- .localizedStringWithFormat(.detailText, detailState.row))),
		.space(),
		.view(Button(
			.title -- .normal("Toggle"),
			.action(.primaryActionTriggered) --> Input().map { _ in () }.bind(to: detailState.showChild)
		)),
		.space()
	)
	return detailState.showChild.map { show -> Layout in
		if show {
			return .vertical(align: .fill,
				fixedLayout,
				.view(length: .fillRemaining, childView),
				.space()
			)
		} else {
			return .vertical(align: .fill,
				fixedLayout,
				.view(length: 2, childView),
				.space(.fillRemaining)
			)
		}
	}
}

fileprivate extension String {
	static let titleText = NSLocalizedString("Row #%@", comment: "")
	static let detailText = NSLocalizedString("Detail view for row #%@", comment: "")
}
