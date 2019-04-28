//
//  TextView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews
import NaturalLanguage

struct TextViewState: CodableContainer {
	let text: Var<String>
	init() {
		text = Var("")
	}
}

func textView(_ textViewState: TextViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .vertical(
				marginEdges: .allLayout,
				.space(),
				.horizontal(
					.space(),
					.view(
						length: .fillRemaining,
						Label(
							.font -- UIFont.preferredFont(forTextStyle: .callout, weight: .semibold),
							.numberOfLines -- 0,
							.text <-- textViewState.text.allChanges().map { text in
								.localizedStringWithFormat(.labelFormat, text.count, text.wordCount)
							}
						)
					)
				),
				.space(),
				.view(
					length: .fillRemaining,
					TextView(
						.text <-- textViewState.text,
						.font -- .preferredFont(forTextStyle: .body),
						.textChanged() --> textViewState.text.update(),
						.becomeFirstResponder <-- Signal.just(()),
						.backgroundColor -- .lightGray
					)
				)
			)
		)
	)
}

private extension String {
	static let labelFormat = NSLocalizedString("Text view contains %ld characters and %ld words. This label may span across multiple-lines.", comment: "")
	
	var wordCount: Int {
		let tokenizer = NLTokenizer(unit: .word)
		tokenizer.string = self
		return tokenizer.tokens(for: startIndex..<endIndex).count
	}
}
