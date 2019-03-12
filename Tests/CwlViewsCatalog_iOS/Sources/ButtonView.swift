//
//  ButtonView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
		.action(.primaryActionTriggered) --> Input().map { _ in () }.bind(to: buttonViewState.showChild)
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
