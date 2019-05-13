//
//  ButtonRowControl.swift
//  CwlViews
//
//  Created by Matt Gallagher on 31/3/19.
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

/// A subclass of NSSegmentedControl that ignores NSCell and instead uses a row of NSButtons to represent the content.
/// Appearance of the buttons can be customised by setting the `segmentConstructor`.
///
/// NOTE: `segmentDistribution`, `setShowsMenuIndicator` and `trackingMode` have no effect in the current implementation.
///
class ButtonRowControl: NSSegmentedControl {
	static func defaultButtonConstructor(_ index: Int, count: Int) -> ButtonConvertible {
		return NSButton()
	}
	
	var segments: [NSButton] = []
	var segmentConstructor = ButtonRowControl.defaultButtonConstructor
	
	override var font: NSFont? { didSet { segments.forEach { $0.font = self.font } } }
	override func setLabel(_ label: String, forSegment segment: Int) { segments[segment].title = label }
	override func setAlignment(_ alignment: NSTextAlignment, forSegment segment: Int) { segments[segment].alignment = alignment }
	override func setImage(_ image: NSImage?, forSegment segment: Int) { segments[segment].image = image }
	override func setImageScaling(_ scaling: NSImageScaling, forSegment segment: Int) { segments[segment].imageScaling = scaling }
	override func setMenu(_ menu: NSMenu?, forSegment segment: Int) { segments[segment].menu = menu }
	override func setSelected(_ selected: Bool, forSegment segment: Int) { segments[segment].state = selected ? .on : .off }

	override var segmentCount: Int {
		get { return segments.count }
		set {
			segments = (0..<newValue).map { index in segmentConstructor(index, newValue).nsButton() }
			segments.forEach { button in
				button.target = self
				button.action = #selector(segmentButtonPressed(_:))
				button.setButtonType(.onOff)
			}
			applyLayout(.horizontal(.same(priority: .layoutMid, entities: segments.map { Layout.Entity.view($0) })))
			DispatchQueue.main.async { [segments] in segments.forEach { $0.needsDisplay = true } }
		}
	}
	
	override var selectedSegment: Int {
		get { return segments.firstIndex { $0.state == .on } ?? NSNotFound }
		set { segments.enumerated().forEach { tuple in tuple.element.state = tuple.offset == newValue ? .on : .off } }
	}
	
	override var intrinsicContentSize: NSSize {
		var height: CGFloat = 0
		var width: CGFloat = 0
		for button in segments {
			let segmentSize = button.intrinsicContentSize
			width += segmentSize.width
			height = max(height, segmentSize.height)
		}
		return CGSize(width: width, height: height)
	}
	
	@objc func segmentButtonPressed(_ button: NSButton) {
		guard let index = segments.firstIndex(of: button) else { return }
		selectedSegment = index
		sendAction(action, to: target)
	}
}
