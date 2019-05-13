//
//  Window.swift
//  CwlViews
//
//  Created by Matt Gallagher on 24/3/19.
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

struct WindowState: CodableContainer {
	let appearance: TempVar<NSAppearance.Name>
	let error: TempVar<Error>
	let selectedTab: Var<Tabs>
	let rowSelection: Var<CatalogViewState?>
	
	init() {
		appearance = TempVar()
		error = TempVar()
		selectedTab = Var(.left)
		rowSelection = Var(nil)
	}
	
	var windowContentColor: Signal<CGColor> {
		return appearance.map { name in
			name == .darkAqua ? NSColor(white: 0.2, alpha: 1).cgColor : NSColor.white.cgColor
		}
	}
}

func window(_ windowState: WindowState) -> WindowConvertible {
	return Window(
		.contentHeight -- 311,
		.contentRelativity -- .widthRelativeToHeight,
		.contentWidth -- 650,
		.effectiveAppearanceName --> windowState.appearance,
		.frameAutosaveName -- Bundle.main.bundleIdentifier! + ".window",
		.frameHorizontal -- 15,
		.frameVertical -- 15,
		.styleMask -- [.titled, .resizable, .closable, .miniaturizable, .fullSizeContentView],
		.title -- .title,
		.titleVisibility -- .hidden,
		.titlebarAppearsTransparent -- true,
		.toolbar -- toolbar(windowState),
		.presentError <-- windowState.error.ignoreCallback(),
		.contentView -- SplitView.verticalThin(
			.autosaveName -- Bundle.main.bundleIdentifier! + ".split",
			.arrangedSubviews -- [
				.subview(
					masterView(windowState),
					holdingPriority: .layoutMid,
					constraints: .equalTo(ratio: 0.3, priority: .layoutLow)
				),
				.subview(
					detailContainer(windowState)
				)
			]
		)
	)
}

private func masterView(_ windowState: WindowState) -> ViewConvertible {
	return View(
		.layer -- Layer(
			.backgroundColor <-- windowState.appearance.map { name in
				name == .darkAqua ? .cwlBrownDark : .cwlBrownLight
			}
		),
		.layout -- .vertical(
			align: .fill,
			.space(.equalTo(constant: NSWindow.integratedToolbarHeight)),
			.space(),
			.horizontal(
				.space(12),
				.view(segmentedControl(windowState)),
				.space(12)
			),
			.space(),
			.view(
				tabView(windowState)
			)
		)
	)
}

private func segmentedControl(_ windowState: WindowState) -> SegmentedControlConvertible {
	return SegmentedControl(
		type: ButtonRowControl.self,
		.segments -- Tabs.allCases.map { SegmentDescription(label: $0.label) },
		.font -- .preferredFont(forTextStyle: .controlContent, size: .controlRegular),
		.selectedSegment -- 0,
		.adHocPrepare -- { control in
			(control as! ButtonRowControl).segmentConstructor = { index, count in
				Button(
					type: TabButton.self,
					.bezelStyle -- .regularSquare,
					.adHocPrepare -- { b in
						(b as! TabButton).isFirst = index == 0
						(b as! TabButton).isLast = index == count - 1
					}
				)
			}
		},
		.action(\.selectedSegment) --> Input()
			.compactMap(Tabs.init)
			.bind(to: windowState.selectedTab)
	)
}

private func tabView(_ windowState: WindowState) -> TabViewConvertible {
	return TabView<Tabs>(
		.tabs -- .reload(Tabs.allCases),
		.position -- .none,
		.borderType -- .none,
		.selectedItem <-- windowState.selectedTab,
		.willSelect -- { tabView, _, identifier in
			tabView.layer?.addAnimationForKey(.push(from: identifier == .left ? .left : .right))
		},
		.tabConstructor -- { identifier in
			switch identifier {
			case .left:
				return TabViewItem(
					.view -- catalogTable(windowState, tag: identifier.rawValue + 1),
					.initialFirstResponderTag -- identifier.rawValue + 1
				)
			case .right:
				return TabViewItem(
					.view -- aboutTab(windowState, tag: identifier.rawValue + 1),
					.initialFirstResponderTag -- identifier.rawValue + 1
				)
			}
		}
	)
}

private func detailContainer(_ windowState: WindowState) -> ViewConvertible {
	return View(
		.layer -- Layer(.backgroundColor <-- windowState.windowContentColor),
		.layout <-- windowState.rowSelection.distinctUntilChanged { $0?.caseName == $1?.caseName }.map { selection in
			.vertical(
				animation: Layout.Animation(style: .fade, duration: 0.1),
				.center(
					length: .equalTo(constant: NSWindow.integratedToolbarHeight),
					.view(TextField.label(
						.stringValue -- "CwlViewsCatalog",
						.isSelectable -- false,
						.font -- .preferredFont(forTextStyle: .titleBar, size: .system)
					))
				),
				.inset(
					margins: NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
					.view(detailView(selection))
				)
			)
		}
	)
}

private func toolbar(_ windowState: WindowState) -> ToolbarConvertible {
	return Toolbar(
		identifier: NSToolbar.Identifier("toolbar"),
		.displayMode -- .iconAndLabel,
		.sizeMode -- .small,
		.showsBaselineSeparator -- true,
		.itemDescriptions -- [
			ToolbarItemDescription(identifier: NSToolbarItem.Identifier.flexibleSpace) { identifier, willBeInserted -> ToolbarItemConvertible? in
				ToolbarItem(itemIdentifier: identifier)
			},
			ToolbarItemDescription(identifier: NSToolbarItem.Identifier(rawValue: "error")) { identifier, willBeInserted -> ToolbarItemConvertible? in
				ToolbarItem(
					itemIdentifier: identifier,
					.image -- NSImage(named: NSImage.cautionName),
					.toolTip -- NSLocalizedString("Deliberately trigger an error", comment: ""),
					.action --> Input().map { _ in undeclaredError() }.bind(to: windowState.error)
				)
			}
		]
	)
}

private func detailView(_ viewState: CatalogViewState?) -> ViewConvertible {
	switch viewState {
	case .button(let state)?: return buttonView(state)
	case .control(let state)?: return controlView(state)
	case .gestureRecognizer(let state)?: return gestureRecognizerView(state)
	case .imageView(let state)?: return imageView(state)
	case .layers(let state)?: return layersView(state)
	case .slider(let state)?: return sliderView(state)
	case .textField(let state)?: return textFieldView(state)
	case .textView(let state)?: return textView(state)
	case .webView(let state)?: return webView(state)
	case nil:
		return TextField.label(
			.stringValue -- "No item selected",
			.verticalContentHuggingPriority -- .layoutLow
		)
	}
}

enum Tabs: Int, Codable, CaseIterable {
	case left
	case right
}

private extension Tabs {
	var label: String {
		switch self {
		case .left: return .listTab
		case .right: return .aboutTab
		}
	}
}

private extension CGColor {
	static var cwlBrownLight: CGColor { return NSColor(displayP3Red: 0.498, green: 0.374, blue: 0.316, alpha: 1).cgColor }
	static var cwlBrownDark: CGColor { return NSColor(displayP3Red: 0.35, green: 0.275, blue: 0.225, alpha: 1).cgColor }
}

private extension String {
	static let aboutTab = NSLocalizedString("About", comment: "")
	static let aboutTitle = NSLocalizedString("CwlViews Catalog", comment: "")
	static let bodyText = NSLocalizedString("""
		This catalog should contain one instance of every type of view constructible by CwlViews.
		
		The purpose is to provide a location for interacting with views during development, \
		debugging and UI testing.
		
		The usage of views in this catalog should not be considered idiomatic as the program has \
		no model.
		""", comment: "")
	static let listTab = NSLocalizedString("List", comment: "")
	static let title = NSLocalizedString("CwlViewsCatalog", comment: "Window title")
}
