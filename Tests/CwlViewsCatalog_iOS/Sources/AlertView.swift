//
//  AlertView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 9/2/19.
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

struct AlertViewState: CodableContainer {
	let toggleAlert: ToggleVar
	let lastSelectedValue: Var<String>
	init() {
		toggleAlert = ToggleVar(false)
		lastSelectedValue = Var(.noValue)
	}
}

func alertView(_ alertState: AlertViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.present <-- alertState.toggleAlert
			.filter { $0 }
			.map { _ in
				ModalPresentation(
					alert(alertState),
					popoverPositioning: popoverPositioning,
					completion: alertState.toggleAlert.input
				)
			}
			.animate(.always),
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				.view(Label(.text <-- alertState.lastSelectedValue)),
				.space(),
				.view(Button(
					.tag -- ViewTags.alertButton.rawValue,
					.title -- .normal(.trigger),
					.titleColor -- .normal(.orange),
					.action(.primaryActionTriggered) --> alertState.toggleAlert
				))
			)
		)
	)
}

private func alert(_ alertState: AlertViewState) -> ViewControllerConvertible {
	return AlertController(
		.title -- .alertTitle,
		.preferredStyle -- .actionSheet,
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

private func popoverPositioning(_ viewController: UIViewController, _ popover: UIPopoverPresentationController) {
	if let button = viewController.view.viewWithTag(ViewTags.alertButton.rawValue) {
		popover.sourceView = button
	} else {
		popover.sourceView = viewController.view
	}
}

private enum ViewTags: Int {
	case none
	case alertButton
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
