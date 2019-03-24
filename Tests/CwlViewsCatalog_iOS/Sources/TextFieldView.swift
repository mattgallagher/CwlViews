//
//  TextFieldView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews
import NaturalLanguage

struct TextFieldViewState: CodableContainer {
	var text: Var<String>
	init() {
		text = Var("")
	}
}

func textFieldView(_ textFieldViewState: TextFieldViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				alignment: .leading,
				marginEdges: .allLayout,
				breadth: .equalTo(ratio: 1.0),
				.horizontal(
					.space(),
					.view(
						length: .fillRemaining,
						Label(
							.font -- UIFont.preferredFont(forTextStyle: .callout, weight: .semibold),
							.numberOfLines -- 0,
							.text <-- textFieldViewState.text.allChanges().map { text in
								.localizedStringWithFormat(.labelFormat, text.count, text.wordCount)
							}
						)
					)
				),
				.space(),
				.view(
					breadth: .equalTo(ratio: 1.0),
					TextField(
						.text <-- textFieldViewState.text,
						.textChanged() --> textFieldViewState.text.update(),
						.borderStyle -- .roundedRect,
						.becomeFirstResponder <-- Signal.just(())
					)
				)
			)
		)
	)
}

private extension String {
	static let labelFormat = NSLocalizedString("Field contains %ld characters and %ld words.", comment: "")
	
	var wordCount: Int {
		let tokenizer = NLTokenizer(unit: .word)
		tokenizer.string = self
		return tokenizer.tokens(for: startIndex..<endIndex).count
	}
}
