//
//  TableViewController.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 9/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

enum CatalogName: String, Codable, CaseIterable, CodingKey {
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

enum CatalogViewState {
	case alert(AlertViewState)
	case barButton(AlertViewState)
	case button(AlertViewState)
	case control(AlertViewState)
	case gestureRecognizer(AlertViewState)
	case imageView(AlertViewState)
	case navigationBar(AlertViewState)
	case pageViewController(AlertViewState)
	case searchBar(AlertViewState)
	case slider(AlertViewState)
	case `switch`(AlertViewState)
	case textField(AlertViewState)
}


func catalogTable(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return ViewController(
		.view -- TableView<CatalogName>(
			.backgroundColor -- .white,
			.layoutMargins -- UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30),
			.separatorInset -- UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30),
			.separatorInsetReference -- .fromAutomaticInsets,
			.tableData -- CatalogName.allCases.tableData(),
			.cellConstructor -- { reuseIdentifier, cellData in
				TableViewCell(.textLabel -- Label(.text <-- cellData.map { data in data.rawValue }))
			},
			.didSelectRow --> Input().keyPath(\.data?.viewState).bind(to: viewState.rowSelection),
			.selectRow <-- viewState.rowSelection.compactMap { $0 == nil ? .animate(nil) : nil }
		),
		.didAppear --> Input().map { _ in nil }.bind(to: viewState.rowSelection)
	)
}

extension CatalogName {
	var viewState: CatalogViewState {
		switch self {
		case .alert: return .alert(AlertViewState())
		case .barButton: return .barButton(AlertViewState())
		case .button: return .button(AlertViewState())
		case .control: return .control(AlertViewState())
		case .gestureRecognizer: return .gestureRecognizer(AlertViewState())
		case .imageView: return .imageView(AlertViewState())
		case .navigationBar: return .navigationBar(AlertViewState())
		case .pageViewController: return .pageViewController(AlertViewState())
		case .searchBar: return .searchBar(AlertViewState())
		case .slider: return .slider(AlertViewState())
		case .switch: return .switch(AlertViewState())
		case .textField: return .textField(AlertViewState())
		}
	}
}

extension CatalogViewState: CodableContainer {
	var name: CatalogName {
		switch self {
		case .alert: return .alert
		case .barButton: return .barButton
		case .button: return .button
		case .control: return .control
		case .gestureRecognizer: return .gestureRecognizer
		case .imageView: return .imageView
		case .navigationBar: return .navigationBar
		case .pageViewController: return .pageViewController
		case .searchBar: return .searchBar
		case .slider: return .slider
		case .switch: return .switch
		case .textField: return .textField
		}
	}
	
	init(from decoder: Decoder) throws {
		var c = try decoder.unkeyedContainer()
		let name = try c.decode(CatalogName.self)
		switch name {
		case .alert: self = .alert(try c.decode(AlertViewState.self))
		case .barButton: self = .barButton(try c.decode(AlertViewState.self))
		case .button: self = .button(try c.decode(AlertViewState.self))
		case .control: self = .control(try c.decode(AlertViewState.self))
		case .gestureRecognizer: self = .gestureRecognizer(try c.decode(AlertViewState.self))
		case .imageView: self = .imageView(try c.decode(AlertViewState.self))
		case .navigationBar: self = .navigationBar(try c.decode(AlertViewState.self))
		case .pageViewController: self = .pageViewController(try c.decode(AlertViewState.self))
		case .searchBar: self = .searchBar(try c.decode(AlertViewState.self))
		case .slider: self = .slider(try c.decode(AlertViewState.self))
		case .switch: self = .switch(try c.decode(AlertViewState.self))
		case .textField: self = .textField(try c.decode(AlertViewState.self))
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var c = encoder.unkeyedContainer()
		switch self {
		case .alert(let state): try c.encode(CatalogName.alert); try c.encode(state)
		case .barButton(let state): try c.encode(CatalogName.barButton); try c.encode(state)
		case .button(let state): try c.encode(CatalogName.button); try c.encode(state)
		case .control(let state): try c.encode(CatalogName.control); try c.encode(state)
		case .gestureRecognizer(let state): try c.encode(CatalogName.gestureRecognizer); try c.encode(state)
		case .imageView(let state): try c.encode(CatalogName.imageView); try c.encode(state)
		case .navigationBar(let state): try c.encode(CatalogName.navigationBar); try c.encode(state)
		case .pageViewController(let state): try c.encode(CatalogName.pageViewController); try c.encode(state)
		case .searchBar(let state): try c.encode(CatalogName.searchBar); try c.encode(state)
		case .slider(let state): try c.encode(CatalogName.slider); try c.encode(state)
		case .switch(let state): try c.encode(CatalogName.switch); try c.encode(state)
		case .textField(let state): try c.encode(CatalogName.textField); try c.encode(state)
		}
	}
}