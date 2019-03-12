//
//  SwitchView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SwitchViewState: CodableContainer {
	let value: Var<Bool>
	init() {
		value = Var(true)
	}
}

func switchView(_ switchViewState: SwitchViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				.view(
					Label(
						.text <-- switchViewState.value.map { .localizedStringWithFormat(.valueFormat, $0 ? String.on : String.off) }
					)
				),
				.space(),
				.view(
					Switch(
						.isOn <-- switchViewState.value.distinctUntilChanged().animate(),
						.action(.valueChanged, \.isOn) --> switchViewState.value
					)
				)
			)
		)
	)
}

private extension String {
	static let valueFormat = NSLocalizedString("Switch is %@", comment: "")
	static let on = NSLocalizedString("on", comment: "")
	static let off = NSLocalizedString("off", comment: "")
}
