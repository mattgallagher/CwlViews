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
	init() {
		appearance = TempVar()
	}
	var appearanceChanged: Signal<Void> {
		return appearance.debug().distinctUntilChanged().map { _ in () }.startWith(())
	}
}

func window(_ windowState: WindowState) -> WindowConvertible {
	return Window(
		.contentHeight -- .ratio(1.0, constant: -30),
		.contentRelativity -- .widthRelativeToHeight,
		.contentWidth -- .ratio(1.0, constant: 200),
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
							ExtendedView(
								.layer -- Layer(.backgroundColor -- .cwlBrown),
								.layout -- .vertical(
									.space(.equalTo(constant: NSWindow.defaultTitleBarHeight)),
									.view(
										TextField.label(
											.stringValue -- "Left",
											.verticalContentHuggingPriority -- .layoutLow
										)
									)
								)
							),
							constraints: .equalTo(ratio: 0.3, priority: .layoutLow)
						),
						.subview(
							ExtendedView(
								.backgroundColor -- NSColor.controlBackgroundColor,
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

private extension CGColor {
	static var cwlBrown: CGColor { return NSColor(displayP3Red: 0.498, green: 0.374, blue: 0.316, alpha: 1).cgColor }
}

private extension String {
	static let title = NSLocalizedString("CwlViewsCatalog", comment: "Window title")
}
