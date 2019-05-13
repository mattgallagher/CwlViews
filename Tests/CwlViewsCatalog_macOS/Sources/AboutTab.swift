//
//  AboutTab.swift
//  CwlViewsCatalog_macOS
//
//  Created by Matt Gallagher on 2/4/19.
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

func aboutTab(_ windowState: WindowState, tag: Int) -> ViewConvertible {
	return View(
		.layer -- Layer(.backgroundColor <-- windowState.windowContentColor),
		.layout -- .fill(
			ScrollView(
				.borderType -- .noBorder,
				.hasVerticalScroller -- true,
				.hasHorizontalScroller -- true,
				.autohidesScrollers -- true,
				.contentView -- ClipView(
					.documentView -- aboutTabContent()
				)
			)
		)
	)
}

private func aboutTabContent() -> ViewConvertible {
	return View(
		.layout -- .horizontal(
			.space(20),
			.vertical(
				align: .leading,
				.space(20),
				.view(
					TextField.label(
						.stringValue -- .aboutTitle,
						.font -- .preferredFont(forTextStyle: .controlContent, size: .title1)
					)
				),
				.space(20),
				.view(
					TextField.wrappingLabel(
						.stringValue -- .bodyText,
						.font -- .preferredFont(forTextStyle: .system, size: .system)
					)
				),
				.space(.fillRemaining)
			),
			.space(20)
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
