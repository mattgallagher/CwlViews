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

func textFieldView(_ textFieldViewState: TextFieldViewState) -> ViewConvertible {
	return View(
		.layout -- .center(
			.view(
				TextField.wrappingLabel(
					.font -- .preferredFont(forTextStyle: .label, size: .controlSmall, weight: .semibold),
					.stringValue <-- textFieldViewState.text.allChanges().map { text in
						.localizedStringWithFormat(.labelFormat, text.count, text.wordCount)
					}
				)
			),
			.space(),
			.view(
				length: .fillRemaining,
				TextField(
					.stringValue <-- textFieldViewState.text,
					.stringChanged() --> textFieldViewState.text.update(),
					.bezelStyle -- .roundedBezel,
					.becomeFirstResponder <-- Signal<Void>.timer(interval: .seconds(0), value: (), context: .main)
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
