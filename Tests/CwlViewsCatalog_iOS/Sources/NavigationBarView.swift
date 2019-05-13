//
//  NavigationView.swift
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
				marginEdges: .allLayout,
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
