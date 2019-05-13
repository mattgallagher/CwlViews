//
//  AboutTab.swift
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

func aboutTabScrollContainer() -> ViewConvertible {
	return View(
		.backgroundColor -- .white,
		.layout -- .fill(
			ScrollView(
				.alwaysBounceVertical -- true,
				.contentInsetAdjustmentBehavior -- .never,
				.layout -- .fill(
					marginEdges: .none,
					length: .equalTo(ratio: 1, priority: .layoutMid),
					breadth: .equalTo(ratio: 1),
					aboutTabContent()
				)
			)
		)
	)
}

private func aboutTabContent() -> ViewConvertible {
	return View(
		.layoutMargins -- UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30),
		.layout -- .vertical(
			align: .leading,
			marginEdges: .allLayout,
			.view(
				Label(
					.text -- .aboutTitle,
					.font -- .preferredFont(forTextStyle: .title1)
				)
			),
			.space(24),
			.view(
				Label(
					.numberOfLines -- 0,
					.text -- .bodyText,
					.font -- .preferredFont(forTextStyle: .body)
				)
			),
			.space(.fillRemaining)
		)
	)
}

private extension String {
	static let bodyText = NSLocalizedString("""
		This catalog should contain one instance of every type of view constructible by CwlViews.
		
		The purpose is to provide a location for interacting with views during development, \
		debugging and UI testing.
		
		The usage of views in this catalog should not be considered idiomatic as the program has \
		no model.
		""", comment: "")
	static let aboutTitle = NSLocalizedString("CwlViews Catalog", comment: "")
}
