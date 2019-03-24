//
//  BarButtonView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
