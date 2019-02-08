//
//  SplitViewController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SplitViewState: CodableContainer {
	let splitButtonVar = TempVar<BarButtonItemConvertible?>()
	var childCodableContainers: [CodableContainer] { return [] }
}

func splitViewController(_ viewState: SplitViewState, _ docAdapter: DocumentAdapter, _ services: Services) -> ViewControllerConvertible {
	return SplitViewController(
		.preferredDisplayMode -- .allVisible,
		.displayModeButton --> viewState.splitButtonVar,
		.primaryViewController -- TabBarController<Tabs>(
			.items -- [.left, .right],
			.tabConstructor -- { identifier in
				switch identifier {
				case .left:
					return NavigationController(
						.tabBarItem -- TabBarItem(
							.title -- "Blue",
							.image -- .drawn(width: 30, height: 30) { $0.fillEllipse(in: $1) }
						),
						.stack -- [ViewController(.view -- View(.backgroundColor -- .white))]
					)
				case .right:
					return ViewController(
						.tabBarItem -- TabBarItem(
							.title -- "Red",
							.image -- .drawn(width: 30, height: 30) { $0.fill($1) }
						),
						.view -- View(.backgroundColor -- .red)
					)
				}
			}
		),
		.secondaryViewController -- NavigationController(
			.stack -- [
				ViewController(
					.navigationItem -- NavigationItem(
						.leftBarButtonItems() <-- viewState.splitButtonVar.optionalToArray()
					),
					.view -- View(.backgroundColor -- .white)
				)
			]
		)
	)
}
