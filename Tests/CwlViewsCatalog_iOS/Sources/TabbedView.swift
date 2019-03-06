//
//  TabBarController.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 7/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

enum Tabs: Int, Codable {
	case left
	case right
}

func tabbedView(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return NavigationController(
		.stack -- [
			TabBarController<Tabs>(
				.navigationItem -- NavigationItem(.title <-- viewState.selectedTab.map { $0.title }),
				.items -- [.left, .right],
				.didSelect --> viewState.selectedTab,
				.tabConstructor -- { identifier in
					switch identifier {
					case .left:
						return NavigationController(
							.isNavigationBarHidden -- true,
							.tabBarItem -- TabBarItem(
								.title -- .listTab,
								.image -- .drawn(width: 30, height: 30) { $0.fillEllipse(in: $1) }
							),
							.stack -- [
								catalogTable(viewState)
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
				},
				.animationControllerForTransition -- { _, source, destination -> UIViewControllerAnimatedTransitioning? in
					guard let navControllerView = source.navigationController?.view else { return nil }
					UIView.transition(from: navControllerView, to: navControllerView, duration: 0.3, options: [.transitionCrossDissolve, .showHideTransitionViews])
					return nil
				}
			)
		]
	)
}

private extension Tabs {
	var title: String {
		switch self {
		case .left: return .listTab
		case .right: return .aboutTab
		}
	}
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
