//
//  WebView.swift
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

struct WebViewState: CodableContainer {
	init() {
	}
}

func webView(_ webViewState: WebViewState) -> ViewConvertible {
	return View(
		.layer -- Layer(.backgroundColor -- NSColor.darkGray.cgColor),
		.layout -- Layout.fill(
			WebKitView.scrollEmbedded(
				.minimumFontSize -- 12,
				.loadHTMLString <-- Signal<(string: String, baseURL: URL?)>.just((.htmlString, nil)).ignoreCallback()
			)
		)
	)
}

private extension String {
	static let htmlString = """
		<html>
			<head>
				<meta name="viewport" content="width=450">
			</head>
			<body>
				<h1>Hello, there!</h1>
				<p>This text is loaded in a WKWebView.</p>
			</body>
		</html>
		"""
}
