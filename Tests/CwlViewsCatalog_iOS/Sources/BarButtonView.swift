//
//  BarButtonView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
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

struct BarButtonViewState: CodableContainer {
	let lastSelectedValue: Var<String>
	init() {
		lastSelectedValue = Var(.noValue)
	}
}

func barButtonView(_ barButtonViewState: BarButtonViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				breadth: .equalTo(ratio: 0.75, priority: .layoutMid),
				.view(Label(.text <-- barButtonViewState.lastSelectedValue)),
				.space(),
				.view(
					Toolbar(
						.items -- [
							BarButtonItem(
								.title -- .button1,
								.action --> Input()
									.map { _ in .firstValue }
									.bind(to: barButtonViewState.lastSelectedValue)
							),
							BarButtonItem(.systemItem -- .flexibleSpace),
							BarButtonItem(
								.title -- .button2,
								.action --> Input()
									.map { _ in .secondValue }
									.bind(to: barButtonViewState.lastSelectedValue)
							),
						]
					)
				)
			)
		)
	)
}

private extension String {
	static let button1 = NSLocalizedString("Button 1", comment: "")
	static let button2 = NSLocalizedString("Button 2", comment: "")
	static let firstValue = NSLocalizedString("Button 1 selected", comment: "")
	static let noValue = NSLocalizedString("No value selected", comment: "")
	static let secondValue = NSLocalizedString("Button 2 selected", comment: "")
}
