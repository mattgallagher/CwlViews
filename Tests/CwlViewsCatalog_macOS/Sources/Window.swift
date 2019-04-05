//
//  Window.swift
//  CwlViews
//
//  Created by Matt Gallagher on 24/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct WindowState: CodableContainer {
	let appearance: TempVar<NSAppearance.Name>
	let selectedTab: Var<Tabs>
	let rowSelection: Var<CatalogViewState?>
	init() {
		appearance = TempVar()
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
		.contentView -- SplitView.verticalThin(
			.autosaveName -- Bundle.main.bundleIdentifier! + ".split",
			.arrangedSubviews -- [
				.subview(
					masterView(windowState),
					holdingPriority: .layoutMid,
					constraints: .equalTo(ratio: 0.3, priority: .layoutLow)
				),
				.subview(
					detailView(windowState)
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
			.space(.equalTo(constant: NSWindow.defaultTitleBarHeight)),
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
			case .left: return TabViewItem(.view -- catalogTable(windowState))
			case .right: return TabViewItem(.view -- aboutTab(windowState))
			}
		}
	)
}

private func detailView(_ windowState: WindowState) -> ViewConvertible {
	return View(
		.layer -- Layer(.backgroundColor <-- windowState.windowContentColor),
		.layout -- .vertical(
			.center(
				length: .equalTo(constant: NSWindow.defaultTitleBarHeight),
				.view(TextField.label(
					.stringValue -- "CwlViewCatalog",
					.isSelectable -- false,
					.font -- .preferredFont(forTextStyle: .titleBar, size: .system)
				))
			),
			.view(
				TextField.label(
					.stringValue -- "Right",
					.verticalContentHuggingPriority -- .layoutLow
				)
			)
		)
	)
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
