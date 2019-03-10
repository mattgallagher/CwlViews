//
//  SwitchView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SwitchViewState: CodableContainer {
	init() {
	}
}

func switchView(_ switchViewState: SwitchViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				.view(Label(.text -- CatalogViewState.CaseName.switch.localizedString))
			)
		)
	)
}
