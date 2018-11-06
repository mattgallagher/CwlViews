//
//  NavView.swift
//  CwlViewsHarness_iOS
//
//  Created by Matt Gallagher on 2017/07/31.
//  Copyright © 2017 Matt Gallagher. All rights reserved.
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

typealias NavPathElement = MasterOrDetail<TableViewState, DetailViewState>
struct NavViewState: StateContainer {
	let navStack: StackAdapter<NavPathElement>
	init () {
		navStack = StackAdapter([.master(TableViewState())])
	}
	var childValues: [StateContainer] { return [navStack] }
}

func navViewController(_ navState: NavViewState, _ doc: DocumentAdapter) -> ViewControllerConvertible {
	return NavigationController(
		.stack <-- navState.navStack.stackMap { element in
			switch element {
			case .master(let tableState):
				return tableViewController(tableState, navState, doc)
			case .detail(let detailState):
				return detailViewController(detailState, doc)
			}
		},
		.poppedToCount --> navState.navStack.poppedToCount,
		.navigationBar -- NavigationBar(
			.barTintColor -- .barTint,
			.titleTextAttributes -- [.foregroundColor: UIColor.white],
			.tintColor -- .barText
		)
	)
}

fileprivate extension UIColor {
	static let barTint = UIColor(red: 0.521, green: 0.368, blue: 0.306, alpha: 1)
	static let barText = UIColor(red: 0.244, green: 0.254, blue: 0.330, alpha: 1)
}
