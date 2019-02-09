//
//  SplitViewController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SplitViewState: CodableContainer {
	let splitButtonVar: TempVar<BarButtonItemConvertible?>
	let detailSelection: Var<Catalog?>
	
	init() {
		splitButtonVar = TempVar()
		detailSelection = Var(nil)
	}
	
	var childCodableContainers: [CodableContainer] { return [] }
}

func splitViewController(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return SplitViewController(
		.preferredDisplayMode -- .allVisible,
		.displayModeButton --> viewState.splitButtonVar,
		.primaryViewController -- tabBarController(viewState),
		.secondaryViewController -- NavigationController(
			.stack <-- viewState.detailSelection.map { selection in
				let view: ViewConvertible
				switch selection {
				case nil: view = View(.backgroundColor -- .white)
				case .alert?: view = buttonView()
				case .barButton?: view = buttonView()
				case .button?: view = buttonView()
				case .control?: view = buttonView()
				case .gestureRecognizer?: view = buttonView()
				case .imageView?: view = buttonView()
				case .navigationBar?: view = buttonView()
				case .pageViewController?: view = buttonView()
				case .searchBar?: view = buttonView()
				case .slider?: view = buttonView()
				case .switch?: view = buttonView()
				case .textField?: view = buttonView()
				}
				
				return [ViewController(
					.navigationItem -- NavigationItem(
						.leftBarButtonItems() <-- viewState.splitButtonVar.optionalToArray(),
						.title -- selection?.rawValue ?? ""
					),
					.view -- view
				)]
			}
		),
		.shouldShowSecondary <-- viewState.detailSelection.map { $0 != nil }
	)
}

func buttonView() -> ViewConvertible {
	return View(.backgroundColor -- .white)
}
