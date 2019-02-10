//
//  SplitViewController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SplitViewState: CodableContainer {
	let rowSelection: Var<CatalogViewState?>
	let selectedTab: Var<Tabs>
	let splitButtonVar: TempVar<BarButtonItemConvertible?>
	
	init() {
		splitButtonVar = TempVar()
		rowSelection = Var(nil)
		selectedTab = Var(.left)
	}
}

func splitViewController(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return SplitViewController(
		.preferredDisplayMode -- .allVisible,
		.displayModeButton --> viewState.splitButtonVar,
		.primaryViewController -- tabBarController(viewState),
		.secondaryViewController -- NavigationController(
			.stack <-- viewState.rowSelection.map { [split = viewState.splitButtonVar] selection in
				let navigationItem = NavigationItem(
					.leftBarButtonItems() <-- split.optionalToArray(),
					.title -- selection?.name.rawValue ?? ""
				)
				switch selection {
				case nil: return ViewController(.view -- View(.backgroundColor -- .white))
				case .alert(let state)?: return alertView(state, navigationItem)
				case .barButton(let state)?: return alertView(state, navigationItem)
				case .button(let state)?: return alertView(state, navigationItem)
				case .control(let state)?: return alertView(state, navigationItem)
				case .gestureRecognizer(let state)?: return alertView(state, navigationItem)
				case .imageView(let state)?: return alertView(state, navigationItem)
				case .navigationBar(let state)?: return alertView(state, navigationItem)
				case .pageViewController(let state)?: return alertView(state, navigationItem)
				case .searchBar(let state)?: return alertView(state, navigationItem)
				case .slider(let state)?: return alertView(state, navigationItem)
				case .switch(let state)?: return alertView(state, navigationItem)
				case .textField(let state)?: return alertView(state, navigationItem)
				}
			}.map { .reload([$0]) }
		),
		.shouldShowSecondary <-- viewState.rowSelection.map { $0 != nil }
	)
}
