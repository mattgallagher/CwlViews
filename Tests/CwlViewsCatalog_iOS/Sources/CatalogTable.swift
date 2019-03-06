//
//  TableViewController.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 9/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

extension CatalogViewState {
	enum CodingKeys: String, CodingKey, CaseIterable, Codable {
		case alert
		case barButton
		case button
		case control
		case gestureRecognizer
		case imageView
		case layersView
		case navigationBar
		case pageViewController
		case searchBar
		case slider
		case `switch`
		case textField
		case webView
	}
}

enum CatalogViewState: CodableContainer {
	case alert(AlertViewState)
	case barButton(BarButtonViewState)
	case button(ButtonViewState)
	case control(ControlViewState)
	case gestureRecognizer(GestureRecognizerViewState)
	case imageView(ImageViewState)
	case layersView(LayersViewState)
	case navigationBar(NavigationBarViewState)
	case pageViewController(PageViewState)
	case searchBar(SearchBarViewState)
	case slider(SliderViewState)
	case `switch`(SwitchViewState)
	case textField(TextFieldViewState)
	case webView(WebViewState)
}

func catalogTable(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return ViewController(
		.view -- TableView<CatalogViewState.CodingKeys>(
			.backgroundColor -- .white,
			.layoutMargins -- UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30),
			.separatorInset -- UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30),
			.separatorInsetReference -- .fromAutomaticInsets,
			.tableData -- CatalogViewState.CodingKeys.allCases.tableData(),
			.cellConstructor -- { reuseIdentifier, cellData in
				TableViewCell(.textLabel -- Label(.text <-- cellData.map { data in data.rawValue }))
			},
			.didSelectRow --> Input().keyPath(\.data?.viewState).bind(to: viewState.rowSelection),
			.selectRow <-- viewState.rowSelection.compactMap { $0 == nil ? .animate(nil) : nil }
		)
	)
}

extension CatalogViewState.CodingKeys {
	var viewState: CatalogViewState {
		switch self {
		case .alert: return .alert(AlertViewState())
		case .barButton: return .barButton(BarButtonViewState())
		case .button: return .button(ButtonViewState())
		case .control: return .control(ControlViewState())
		case .gestureRecognizer: return .gestureRecognizer(GestureRecognizerViewState())
		case .imageView: return .imageView(ImageViewState())
		case .layersView: return .layersView(LayersViewState())
		case .navigationBar: return .navigationBar(NavigationBarViewState())
		case .pageViewController: return .pageViewController(PageViewState())
		case .searchBar: return .searchBar(SearchBarViewState())
		case .slider: return .slider(SliderViewState())
		case .switch: return .switch(SwitchViewState())
		case .textField: return .textField(TextFieldViewState())
		case .webView: return .webView(WebViewState())
		}
	}
}

extension CatalogViewState {
	var codingKey: CatalogViewState.CodingKeys {
		switch self {
		case .alert: return .alert
		case .barButton: return .barButton
		case .button: return .button
		case .control: return .control
		case .gestureRecognizer: return .gestureRecognizer
		case .imageView: return .imageView
		case .layersView: return .layersView
		case .navigationBar: return .navigationBar
		case .pageViewController: return .pageViewController
		case .searchBar: return .searchBar
		case .slider: return .slider
		case .switch: return .switch
		case .textField: return .textField
		case .webView: return .webView
		}
	}
	
	init(from decoder: Decoder) throws {
		var c = try decoder.unkeyedContainer()
		let name = try c.decode(CatalogViewState.CodingKeys.self)
		switch name {
		case .alert: self = .alert(try c.decode(AlertViewState.self))
		case .barButton: self = .barButton(try c.decode(BarButtonViewState.self))
		case .button: self = .button(try c.decode(ButtonViewState.self))
		case .control: self = .control(try c.decode(ControlViewState.self))
		case .gestureRecognizer: self = .gestureRecognizer(try c.decode(GestureRecognizerViewState.self))
		case .imageView: self = .imageView(try c.decode(ImageViewState.self))
		case .layersView: self = .layersView(try c.decode(LayersViewState.self))
		case .navigationBar: self = .navigationBar(try c.decode(NavigationBarViewState.self))
		case .pageViewController: self = .pageViewController(try c.decode(PageViewState.self))
		case .searchBar: self = .searchBar(try c.decode(SearchBarViewState.self))
		case .slider: self = .slider(try c.decode(SliderViewState.self))
		case .switch: self = .switch(try c.decode(SwitchViewState.self))
		case .textField: self = .textField(try c.decode(TextFieldViewState.self))
		case .webView: self = .webView(try c.decode(WebViewState.self))
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
		case .layersView(let state): try c.encode(CatalogName.layersView); try c.encode(state)
		case .navigationBar(let state): try c.encode(CatalogName.navigationBar); try c.encode(state)
		case .pageViewController(let state): try c.encode(CatalogName.pageViewController); try c.encode(state)
		case .searchBar(let state): try c.encode(CatalogName.searchBar); try c.encode(state)
		case .slider(let state): try c.encode(CatalogName.slider); try c.encode(state)
		case .switch(let state): try c.encode(CatalogName.switch); try c.encode(state)
		case .textField(let state): try c.encode(CatalogName.textField); try c.encode(state)
		case .webView(let state): try c.encode(CatalogName.webView); try c.encode(state)
		}
	}
}
