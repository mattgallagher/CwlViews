//
//  CatalogTable.swift
//  CwlViewsCatalog_macOS
//
//  Created by Matt Gallagher on 2/4/19.
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
	case button(ButtonViewState)
	case control(ControlViewState)
	case gestureRecognizer(GestureRecognizerViewState)
	case imageView(ImageViewState)
	case layers(LayersViewState)
	case slider(SliderViewState)
	case textField(TextFieldViewState)
	case textView(TextViewState)
	case webView(WebViewState)
}

func catalogTable(_ windowState: WindowState, tag: Int) -> ViewConvertible {
	return TableView<CatalogViewState.CaseName>(
		.tag -- tag,
		.rows -- CatalogViewState.CaseName.allCases.tableData(),
		.focusRingType -- .none,
		.usesAutomaticRowHeights -- true,
		.selectRow() <-- windowState.rowSelection.map { $0?.index },
		.columns -- [
			TableColumn<CatalogViewState.CaseName>(
				.cellConstructor { identifier, cellData -> TableCellViewConvertible in
					TableCellView(
						.layout -- .inset(
							margins: NSEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
							.view(
								TextField.label(
									.stringValue <-- cellData.map { data in data.localizedString },
									.font -- .preferredFont(forTextStyle: .label, size: .title2),
									.textColor -- .white
								)
							)
						)
					)
				}
			)
		],
		.cellSelected(\.data?.viewState) --> Input().compact().bind(to: windowState.rowSelection)
	)
}

extension CatalogViewState {
	enum CaseName: String, CaseIterable {
		case button
		case control
		case gestureRecognizer
		case imageView
		case layers
		case slider
		case textField
		case textView
		case webView
	}

	var caseName: CatalogViewState.CaseName {
		switch self {
		case .button: return .button
		case .control: return .control
		case .gestureRecognizer: return .gestureRecognizer
		case .imageView: return .imageView
		case .layers: return .layers
		case .slider: return .slider
		case .textField: return .textField
		case .textView: return .textView
		case .webView: return .webView
		}
	}
	
	var index: Int? {
		return CaseName.allCases.firstIndex(of: caseName)
	}
}

extension CatalogViewState.CaseName: CaseNameDecoder {
	var localizedString: String {
		switch self {
		case .button: return NSLocalizedString("Button", comment: "")
		case .control: return NSLocalizedString("Control", comment: "")
		case .gestureRecognizer: return NSLocalizedString("GestureRecognizer", comment: "")
		case .imageView: return NSLocalizedString("ImageView", comment: "")
		case .layers: return NSLocalizedString("Layers", comment: "")
		case .slider: return NSLocalizedString("Slider", comment: "")
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
		case .button: return .button(try container.decodeIfPresent(ButtonViewState.self, forKey: self) ?? .init())
		case .control: return .control(try container.decodeIfPresent(ControlViewState.self, forKey: self) ?? .init())
		case .gestureRecognizer: return .gestureRecognizer(try container.decodeIfPresent(GestureRecognizerViewState.self, forKey: self) ?? .init())
		case .imageView: return .imageView(try container.decodeIfPresent(ImageViewState.self, forKey: self) ?? .init())
		case .layers: return .layers(try container.decodeIfPresent(LayersViewState.self, forKey: self) ?? .init())
		case .slider: return .slider(try container.decodeIfPresent(SliderViewState.self, forKey: self) ?? .init())
		case .textField: return .textField(try container.decodeIfPresent(TextFieldViewState.self, forKey: self) ?? .init())
		case .textView: return .textView(try container.decodeIfPresent(TextViewState.self, forKey: self) ?? .init())
		case .webView: return .webView(try container.decodeIfPresent(WebViewState.self, forKey: self) ?? .init())
		}
	}
}
