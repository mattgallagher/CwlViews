//
//  TableViewController.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 9/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

enum Catalog: String, Codable, CaseIterable {
	case alert = "Alert"
	case barButton = "BarButton"
	case button = "Button"
	case control = "Control"
	case gestureRecognizer = "GestureRecognizer"
	case imageView = "ImageView"
	case navigationBar = "NavigationBar"
	case pageViewController = "PageViewController"
	case searchBar = "SearchBar"
	case slider = "Slider"
	case `switch` = "Switch"
	case textField = "TextField"
}

func tableViewController(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return ViewController(
		.title -- "Catalog",
		.view -- TableView<Catalog>(
			.backgroundColor -- .white,
			.contentInsetAdjustmentBehavior -- .never,
			.tableData -- Catalog.allCases.tableData(),
			
			.cellConstructor -- { reuseIdentifier, cellData in
				TableViewCell(.textLabel -- Label(.text <-- cellData.map { data in data.rawValue }))
			},
			.didSelectRow --> Input().keyPath(\.data).bind(to: viewState.detailSelection),
			.selectRow <-- viewState.detailSelection.compactMap { $0 == nil ? .animate(nil) : nil }
		),
		.didAppear --> Input().map { _ in nil }.bind(to: viewState.detailSelection)
	)
}
