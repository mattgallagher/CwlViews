//
//  TextView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
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
import NaturalLanguage

struct TextViewState: CodableContainer {
	let text: Var<String>
	init() {
		text = Var("")
	}
}

func textView(_ textViewState: TextViewState) -> ViewConvertible {
	return View(
		.layout -- .vertical(
			.view(
				TextField.wrappingLabel(
					.font -- NSFont.preferredFont(forTextStyle: .label, size: .controlSmall, weight: .semibold),
					.maximumNumberOfLines -- 0,
					.stringValue <-- textViewState.text.allChanges().map { text in
						.localizedStringWithFormat(.labelFormat, text.count, text.wordCount)
					}
				)
			),
			.space(),
			.view(
				length: .fillRemaining,
				TextView.scrollEmbedded(
					.string <-- textViewState.text,
					.font() -- NSFont.preferredFont(forTextStyle: .controlContent, size: .system, weight: .semibold),
					.stringChanged() --> textViewState.text.update(),
					.becomeFirstResponder <-- Signal<Void>.timer(interval: .seconds(0), value: (), context: .main),
					.backgroundColor -- .lightGray
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
