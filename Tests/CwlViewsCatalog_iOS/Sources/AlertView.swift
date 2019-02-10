//
//  AlertView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 9/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct AlertViewState: CodableContainer {
	let showAlert: ToggleVar
	let lastSelectedValue: Var<String>
	init() {
		showAlert = ToggleVar(false)
		lastSelectedValue = Var(.noValue)
	}
}

func alertView(_ alertState: AlertViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				.view(Label(.text <-- alertState.lastSelectedValue)),
				.space(),
				.view(Button(
					.title -- .normal(.trigger),
					.titleColor -- .normal(.orange),
					.action(.primaryActionTriggered) --> Input()
						.map { _ in () }
						.bind(to: alertState.showAlert)
				))
			)
		),
		.present <-- alertState.showAlert
			.filter { $0 }
			.map { _ in ModalPresentation(alert(alertState)) }
	)
}

private func alert(_ alertState: AlertViewState) -> ViewControllerConvertible {
	return AlertController(
		.willDisappear --> Input().map { _ in () }.bind(to: alertState.showAlert),
		.title -- .alertTitle,
		.actions -- [
			AlertAction(
				.title -- .first,
				.handler --> Input().map { .firstValue }.bind(to: alertState.lastSelectedValue)
			),
			AlertAction(
				.title -- .second,
				.handler --> Input().map { .secondValue }.bind(to: alertState.lastSelectedValue)
			)
		],
		.preferredActionIndex -- 0
	)
}

private extension String {
	static let alertTitle = NSLocalizedString("Choose an option", comment: "")
	static let first = NSLocalizedString("First", comment: "")
	static let firstValue = NSLocalizedString("First value selected", comment: "")
	static let noValue = NSLocalizedString("No value selected", comment: "")
	static let second = NSLocalizedString("Second", comment: "")
	static let secondValue = NSLocalizedString("Second value selected", comment: "")
	static let trigger = NSLocalizedString("Display alert", comment: "")
}
