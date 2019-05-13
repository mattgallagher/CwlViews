//
//  TableViewController.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 9/2/19.
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

enum CatalogViewState: CodableContainer, CaseNameCodable {
	case alert(AlertViewState)
	case barButton(BarButtonViewState)
	case button(ButtonViewState)
	case control(ControlViewState)
	case gestureRecognizer(GestureRecognizerViewState)
	case imageView(ImageViewState)
	case layers(LayersViewState)
	case navigationBar(NavigationBarViewState)
	case pageViewController(PageViewState)
	case searchBar(SearchBarViewState)
	case segmentedControl(SegmentedViewState)
	case slider(SliderViewState)
	case `switch`(SwitchViewState)
	case textField(TextFieldViewState)
	case textView(TextViewState)
	case webView(WebViewState)
}

func catalogTable(_ viewState: SplitViewState) -> ViewControllerConvertible {
	return ViewController(
		.view -- TableView<CatalogViewState.CaseName>(
			.backgroundColor -- .white,
			.layoutMargins -- UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30),
			.separatorInset -- UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30),
			.separatorInsetReference -- .fromAutomaticInsets,
			.tableData -- CatalogViewState.CaseName.allCases.tableData(),
			.cellConstructor -- { reuseIdentifier, cellData in
				TableViewCell(.textLabel -- Label(.text <-- cellData.map { data in data.localizedString }))
			},
			.rowSelected(\.data?.viewState) --> viewState.rowSelection,
			.selectRow <-- viewState.rowSelection.compactMap { $0 == nil ? .animate(nil) : nil }
		)
	)
}

extension CatalogViewState {
	enum CaseName: String, CaseIterable {
		case alert
		case barButton
		case button
		case control
		case gestureRecognizer
		case imageView
		case layers
		case navigationBar
		case pageViewController
		case searchBar
		case segmentedControl
		case slider
		case `switch`
		case textField
		case textView
		case webView
	}
}

extension CatalogViewState.CaseName: CaseNameDecoder {
	var localizedString: String {
		switch self {
		case .alert: return NSLocalizedString("Alert", comment: "")
		case .barButton: return NSLocalizedString("BarButton", comment: "")
		case .button: return NSLocalizedString("Button", comment: "")
		case .control: return NSLocalizedString("Control", comment: "")
		case .gestureRecognizer: return NSLocalizedString("GestureRecognizer", comment: "")
		case .imageView: return NSLocalizedString("ImageView", comment: "")
		case .layers: return NSLocalizedString("Layers", comment: "")
		case .navigationBar: return NSLocalizedString("NavigationBar", comment: "")
		case .pageViewController: return NSLocalizedString("PageViewController", comment: "")
		case .searchBar: return NSLocalizedString("SearchBar", comment: "")
		case .segmentedControl: return NSLocalizedString("SegmentedControl", comment: "")
		case .slider: return NSLocalizedString("Slider", comment: "")
		case .`switch`: return NSLocalizedString("Switch", comment: "")
		case .textField: return NSLocalizedString("TextField", comment: "")
		case .textView: return NSLocalizedString("TextView", comment: "")
		case .webView: return NSLocalizedString("WebView", comment: "")
		}
	}
	
	var viewState: CatalogViewState {
		return try! decode(from: KeyedDecodingContainer<CatalogViewState.CaseName>.empty())
	}
	
	func decode(from container: KeyedDecodingContainer<CatalogViewState.CaseName>) throws -> CatalogViewState {
		switch self {
		case .alert: return .alert(try container.decodeIfPresent(AlertViewState.self, forKey: self) ?? .init())
		case .barButton: return .barButton(try container.decodeIfPresent(BarButtonViewState.self, forKey: self) ?? .init())
		case .button: return .button(try container.decodeIfPresent(ButtonViewState.self, forKey: self) ?? .init())
		case .control: return .control(try container.decodeIfPresent(ControlViewState.self, forKey: self) ?? .init())
		case .gestureRecognizer: return .gestureRecognizer(try container.decodeIfPresent(GestureRecognizerViewState.self, forKey: self) ?? .init())
		case .imageView: return .imageView(try container.decodeIfPresent(ImageViewState.self, forKey: self) ?? .init())
		case .layers: return .layers(try container.decodeIfPresent(LayersViewState.self, forKey: self) ?? .init())
		case .navigationBar: return .navigationBar(try container.decodeIfPresent(NavigationBarViewState.self, forKey: self) ?? .init())
		case .pageViewController: return .pageViewController(try container.decodeIfPresent(PageViewState.self, forKey: self) ?? .init())
		case .searchBar: return .searchBar(try container.decodeIfPresent(SearchBarViewState.self, forKey: self) ?? .init())
		case .segmentedControl: return .segmentedControl(try container.decodeIfPresent(SegmentedViewState.self, forKey: self) ?? .init())
		case .slider: return .slider(try container.decodeIfPresent(SliderViewState.self, forKey: self) ?? .init())
		case .switch: return .switch(try container.decodeIfPresent(SwitchViewState.self, forKey: self) ?? .init())
		case .textField: return .textField(try container.decodeIfPresent(TextFieldViewState.self, forKey: self) ?? .init())
		case .textView: return .textView(try container.decodeIfPresent(TextViewState.self, forKey: self) ?? .init())
		case .webView: return .webView(try container.decodeIfPresent(WebViewState.self, forKey: self) ?? .init())
		}
	}
}
