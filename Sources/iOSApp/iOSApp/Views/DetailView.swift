//
//  DetailView.swift
//  iOSApp
//
//  Created by Matt Gallagher on 19/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import UIKit

struct DetailViewState: CodableContainer {
	let row: String
}

func detailViewController(_ detailState: DetailViewState, _ doc: DocumentAdapter) -> ViewControllerConvertible {
	return ViewController(
		.title -- .localizedStringWithFormat(.titleText, detailState.row),
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .vertical(align: .center,
				.space(),
				.view(Label(.text -- .localizedStringWithFormat(.detailText, detailState.row))),
				.space(),
				.view(Button(
					.action(.primaryActionTriggered) --> Input().subscribeValuesUntilEnd { print($0) }
				)),
				.space(.fillRemaining)
			)
		)
	)
}

private extension String {
	static let titleText = NSLocalizedString("Row #%@", comment: "")
	static let detailText = NSLocalizedString("Detail view for row #%@", comment: "")
}
