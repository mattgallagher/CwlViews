//
//  ButtonView.swift
//  CwlViewsCatalog_macOS
//
//  Created by Matt Gallagher on 2/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct ButtonViewState: CodableContainer {
	let showChild: ToggleVar
	init() {
		showChild = ToggleVar(false)
	}
}

func buttonView(_ buttonViewState: ButtonViewState) -> ViewConvertible {
	return View(
		.layout <-- layoutWithAnimation(buttonViewState)
	)
}

func layoutWithAnimation(_ buttonViewState: ButtonViewState) -> Signal<Layout> {
	let button = Button(
		.bezelStyle -- .rounded,
		.title <-- buttonViewState.showChild.map { show in show ? .collapse : .expand },
		.action() --> buttonViewState.showChild
	)
	let childView = View(
		.layer -- Layer(.backgroundColor <-- buttonViewState.showChild.map { show in
			show ? NSColor.orange.cgColor : NSColor.red.cgColor
		}),
		.layout <-- buttonViewState.showChild.map { show in
			show ? .center(axis: .horizontal, .view(TextField.label(.stringValue -- .helloWorld))) : .horizontal()
		}
	)
	return buttonViewState.showChild.map { show -> Layout in
		.vertical(
			align: .center,
			animation: .both(0.5),
			.view(button),
			.space(),
			.view(length: show ? .fillRemaining : 8, breadth: .equalTo(ratio: 1.0), childView),
			.space(show ? 0 : .fillRemaining)
		)
	}
}

private extension String {
	static let helloWorld = NSLocalizedString("Hello world!", comment: "")
	static let expand = NSLocalizedString("Expand", comment: "")
	static let collapse = NSLocalizedString("Collapse", comment: "")
}
