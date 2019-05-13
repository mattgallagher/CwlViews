//
//  ButtonView.swift
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

struct ButtonViewState: CodableContainer {
	let showChild: ToggleVar
	init() {
		showChild = ToggleVar(false)
	}
}

func buttonView(_ buttonViewState: ButtonViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout <-- layoutWithAnimation(buttonViewState))
	)
}

func layoutWithAnimation(_ buttonViewState: ButtonViewState) -> Signal<Layout> {
	let button = Button(
		.title <-- buttonViewState.showChild
			.map { show in show ? .normal(.collapse) : .normal(.expand) },
		.titleColor -- .normal(.blue),
		.action(.primaryActionTriggered) --> buttonViewState.showChild
	)
	let childView = View(
		.backgroundColor <-- buttonViewState.showChild.map { show in show ? .orange : .red },
		.layout <-- buttonViewState.showChild.map { show in
			show ? .center(axis: .horizontal, .view(Label(.text -- .helloWorld))) : .horizontal()
		}
	)
	return buttonViewState.showChild.map { show -> Layout in
		.vertical(
			align: .center,
			marginEdges: .allLayout,
			animation: .both(0.5),
			.space(24),
			.view(button),
			.space(),
			.view(length: show ? .fillRemaining : 8, breadth: .equalTo(ratio: 1.0), childView),
			.space(show ? 24 : .fillRemaining)
		)
	}
}

private extension String {
	static let helloWorld = NSLocalizedString("Hello world!", comment: "")
	static let expand = NSLocalizedString("Expand", comment: "")
	static let collapse = NSLocalizedString("Collapse", comment: "")
}
