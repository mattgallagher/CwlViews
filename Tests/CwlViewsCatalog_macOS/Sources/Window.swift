//
//  Window.swift
//  CwlViews
//
//  Created by Matt Gallagher on 24/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

enum Tabs: Int, Codable, CaseIterable {
	case left
	case right
}

struct WindowState: CodableContainer {
	let appearance: TempVar<NSAppearance.Name>
	let selectedTab: Var<Tabs>
	init() {
		appearance = TempVar()
		selectedTab = Var(.left)
	}
}

func window(_ windowState: WindowState) -> WindowConvertible {
	return Window(
		.contentHeight -- .ratio(1.0, constant: -30),
		.contentRelativity -- .widthRelativeToHeight,
		.contentWidth -- .ratio(1.0, constant: 200),
		.effectiveAppearanceName --> windowState.appearance,
		.frameAutosaveName -- Bundle.main.bundleIdentifier! + ".window",
		.frameHorizontal -- 15,
		.frameVertical -- 15,
		.styleMask -- [.titled, .resizable, .closable, .miniaturizable, .fullSizeContentView],
		.title -- .title,
		.titlebarAppearsTransparent -- true,
		.contentView -- View(
			.layout -- .fill(
				SplitView.verticalThin(
					.autosaveName -- Bundle.main.bundleIdentifier! + ".split",
					.arrangedSubviews -- [
						.subview(
							View(
								.layer -- Layer(
									.backgroundColor <-- windowState.appearance.map { name in
										name == .darkAqua ? .cwlBrownDark : .cwlBrownLight
									}
								),
								.layout -- .vertical(
									align: .center,
									.space(.equalTo(constant: NSWindow.defaultTitleBarHeight)),
									.space(),
									.view(
										breadth: .equalTo(ratio: 1.0, constant: -24),
										SegmentedControl(
											type: ButtonRowControl.self,
											.segments -- Tabs.allCases.map { SegmentDescription(label: $0.label) },
											.font -- .preferredFont(forTextStyle: .controlContent, size: .title2),
											.selectedSegment <-- Signal.timer(interval: .interval(0.01), value: 0),
											.adHocPrepare -- { control in
												(control as! ButtonRowControl).segmentConstructor = { index, count in
													Button(type: TabButton.self, .bezelStyle -- .regularSquare)
												}
											},
											.action(\.selectedSegment) --> Input()
												.compactMap(Tabs.init)
												.debug()
												.bind(to: windowState.selectedTab)
										)
									),
									.space(),
									.view(
										TabView<Tabs>(
											.tabs -- .reload(Tabs.allCases),
											.position -- .none,
											.borderType -- .none,
											.selectedItem <-- windowState.selectedTab.debug(),
											.willSelect -- { tabView, _, identifier in
												tabView.layer?.addAnimationForKey(.push(from: identifier == .left ? .left : .right))
											},
											.tabConstructor -- { identifier in
												switch identifier {
												case .left:
													return TabViewItem(
														.label -- "Yellow",
														.view -- View(.layer -- Layer(.backgroundColor -- .white))
													)
												case .right:
													return TabViewItem(
														.label -- "Banana",
														.view -- View(.layer -- Layer(.backgroundColor -- .black))
													)
												}
											}
										)
									)
								)
							),
							constraints: .equalTo(ratio: 0.3, priority: .layoutLow)
						),
						.subview(
							View(
								.layer -- Layer(
									.backgroundColor <-- windowState.appearance.map { name in
										name == .darkAqua ? NSColor(white: 0.2, alpha: 1).cgColor : NSColor.white.cgColor
									}
								),
								.layout -- .vertical(
									.space(.equalTo(constant: NSWindow.defaultTitleBarHeight)),
									.view(
										TextField.label(
											.stringValue -- "Right",
											.verticalContentHuggingPriority -- .layoutLow
										)
									)
								)
							)
						)
					]
				)
			)
		)
	)
}

class TabButton: NSButton {
	class TabButtonCell: NSButtonCell {
		override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
			let path = NSBezierPath(roundedRect: frame.insetBy(dx: 3.5, dy: 3.5).offsetBy(dx: 0, dy: -1), xRadius: 8, yRadius: 8)
			if state == .on || isHighlighted {
				NSColor.controlAccentColor.setStroke()
			} else {
				NSColor.controlShadowColor.setStroke()
			}
			path.lineWidth = 1
			path.stroke()
			
			if state == .on || isHighlighted {
				NSColor.selectedContentBackgroundColor.blended(withFraction: 0.8, of: .clear)?.setFill()
			} else {
				NSColor.controlBackgroundColor.blended(withFraction: 0.95, of: .clear)?.setFill()
			}
			path.fill()
		}
		
		override var cellSize: NSSize {
			var result = super.cellSize
			result.width += 8
			result.height += 8
			return result
		}
	}

	override class var cellClass: AnyClass? { get { return TabButtonCell.self } set { super.cellClass = newValue } }
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
