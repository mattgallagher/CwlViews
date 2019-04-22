//
//  NavView.swift
//  iOSApp
//
//  Created by Matt Gallagher on 19/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import UIKit

typealias NavPathElement = MasterDetail<TableViewState, DetailViewState>
struct NavViewState: CodableContainer {
	let navStack: StackAdapter<NavPathElement>
	init () {
		navStack = StackAdapter([.master(TableViewState())])
	}
	var childCodableContainers: [CodableContainer] { return [navStack] }
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
		.poppedToCount --> navState.navStack.popToCount(),
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
