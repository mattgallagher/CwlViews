//
//  TabBarController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

func tabBarController(_ viewState: SplitViewState) -> ViewControllerConvertible {
	enum Tabs { case left, right }
	return NavigationController(
		.stack -- [TabBarController<Tabs>(
			.items -- [.left, .right],
			.tabConstructor -- { identifier in
				switch identifier {
				case .left:
					return NavigationController(
						.tabBarItem -- TabBarItem(
							.title -- .listTab,
							.image -- .drawn(width: 30, height: 30) { $0.fillEllipse(in: $1) }
						),
						.stack -- [
							tableViewController(viewState)
						]
					)
				case .right:
					return ViewController(
						.tabBarItem -- TabBarItem(
							.title -- .aboutTab,
							.image -- .drawn(width: 30, height: 30) { $0.fill($1) }
						),
						.view -- aboutTabScrollContainer()
					)
				}
			}
		)]
	)
}

private func aboutTabScrollContainer() -> ViewConvertible {
	return View(
		.backgroundColor -- .white,
		.layout -- .single(
			ScrollView(
				.alwaysBounceVertical -- true,
				.contentInsetAdjustmentBehavior -- .never,
				.layout -- .single(
					marginEdges: .none,
					length: .equalTo(ratio: 1, priority: .userMid),
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
	static let aboutTab = NSLocalizedString("About", comment: "")
	static let bodyText = NSLocalizedString("""
		This catalog should contain one instance of every type of view constructible by CwlViews.
		
		The purpose is to provide a location for interacting with views during development, \
		debugging and UI testing.
		
		The usage of views in this catalog should not be considered idiomatic as the program has \
		no model.
		""", comment: "")
	static let aboutTitle = NSLocalizedString("CwlViews Catalog", comment: "")
	static let listTab = NSLocalizedString("List", comment: "")
}
