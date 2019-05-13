//
//  SplitViewController.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 7/2/19.
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
					.title -- selection?.caseName.localizedString ?? ""
				)
				switch selection {
				case nil: return ViewController(.view -- View(.backgroundColor -- .white))
				case .alert(let state)?: return alertView(state, navigationItem)
				case .barButton(let state)?: return barButtonView(state, navigationItem)
				case .button(let state)?: return buttonView(state, navigationItem)
				case .control(let state)?: return controlView(state, navigationItem)
				case .gestureRecognizer(let state)?: return gestureRecognizerView(state, navigationItem)
				case .imageView(let state)?: return imageView(state, navigationItem)
				case .layers(let state)?: return layersView(state, navigationItem)
				case .navigationBar(let state)?: return navigationView(state, navigationItem)
				case .pageViewController(let state)?: return pageView(state, navigationItem)
				case .searchBar(let state)?: return searchBarView(state, navigationItem)
				case .slider(let state)?: return sliderView(state, navigationItem)
				case .stepper(let state)?: return stepperlView(state, navigationItem)
				case .switch(let state)?: return switchView(state, navigationItem)
				case .textField(let state)?: return textFieldView(state, navigationItem)
				case .textView(let state)?: return textView(state, navigationItem)
				case .webView(let state)?: return webView(state, navigationItem)
				case .segmentedControl(let state)?: return segmentedControlView(state, navigationItem)
				}
			}.map { .reload([$0]) }
		),
		.shouldShowSecondary <-- viewState.rowSelection.map { $0 != nil },
		.dismissedSecondary --> Input().map { _ in nil }.bind(to: viewState.rowSelection)
	)
}
