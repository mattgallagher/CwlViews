//
//  WebView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct WebViewState: CodableContainer {
	init() {
	}
}

func webView(_ webViewState: WebViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.layoutMargins -- UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
			.backgroundColor -- .darkGray,
			.layout -- .fill(
				marginEdges: .allLayout,
				WebView(
					.loadHTMLString <-- Signal<(string: String, baseURL: URL?)>.just((.htmlString, nil)).ignoreCallback()
				)
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
