//
//  NavigationView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct NavigationBarViewState: CodableContainer {
	let stack: StackAdapter<Int>
	init() {
		stack = StackAdapter([0])
	}
}

func navigationView(_ navigationViewState: NavigationBarViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .horizontal(
				align: .center,
				.view(
					NavigationBar(
						.items <-- navigationViewState.stack.stackMap { value -> NavigationItemConvertible in
							NavigationItem(
								.title -- .localizedStringWithFormat(.item, value),
								.leftBarButtonItems -- value != 0 ? [
									BarButtonItem(
										.title -- .button1,
										.action --> Input()
											.map { _ in .pop }
											.bind(to: navigationViewState.stack)
									)
								] : [],
								.rightBarButtonItems -- [
									BarButtonItem(
										.title -- .button2,
										.action --> Input()
											.map { _ in .push(value + 1) }
											.bind(to: navigationViewState.stack)
									)
								]
							)
						}
					)
				)
			)
		)
	)
}

private extension String {
	static let button1 = NSLocalizedString("Pop", comment: "")
	static let button2 = NSLocalizedString("Push", comment: "")
	static let item = NSLocalizedString("Item %ld", comment: "")
}
