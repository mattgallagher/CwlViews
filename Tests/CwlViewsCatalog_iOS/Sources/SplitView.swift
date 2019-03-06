//
//  SplitViewController.swift
//  CwlViewsCatalog_iOS
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

func splitView(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return SplitViewController(
		.backgroundView -- View(.backgroundColor -- .orange),
		.preferredDisplayMode -- .allVisible,
		.displayModeButton --> viewState.splitButtonVar,
		.primaryViewController -- tabbedView(viewState),
		.secondaryViewController -- NavigationController(
			.stack <-- viewState.rowSelection.map { [split = viewState.splitButtonVar] selection in
				let navigationItem = NavigationItem(
					.leftBarButtonItems() <-- split.optionalToArray(),
					.title -- selection?.codingKey.rawValue ?? ""
				)
				switch selection {
				case nil: return ViewController(.view -- View(.backgroundColor -- .white))
				case .alert(let state)?: return alertView(state, navigationItem)
				case .barButton(let state)?: return barButtonView(state, navigationItem)
				case .button(let state)?: return buttonView(state, navigationItem)
				case .control(let state)?: return controlView(state, navigationItem)
				case .gestureRecognizer(let state)?: return gestureRecognizerView(state, navigationItem)
				case .imageView(let state)?: return imageView(state, navigationItem)
				case .layersView(let state)?: return layersView(state, navigationItem)
				case .navigationBar(let state)?: return navigationView(state, navigationItem)
				case .pageViewController(let state)?: return pageView(state, navigationItem)
				case .searchBar(let state)?: return searchBarView(state, navigationItem)
				case .slider(let state)?: return sliderView(state, navigationItem)
				case .switch(let state)?: return switchView(state, navigationItem)
				case .textField(let state)?: return textFieldView(state, navigationItem)
				case .webView(let state)?: return webView(state, navigationItem)
				}
			}.map { .reload([$0]) }
		),
		.shouldShowSecondary <-- viewState.rowSelection.map { $0 != nil },
		.dismissedSecondary --> Input().map { _ in nil }.bind(to: viewState.rowSelection)
	)
}
