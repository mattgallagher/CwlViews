//
//  TabBarController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

enum Tabs {
	case left
	case right
}

func tabBarController() -> ViewControllerConvertible {
	return TabBarController<Tabs>(
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
	)
}
