//
//  ControlView.swift
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

struct ControlViewState: CodableContainer {
	let lastEvent: Var<String>
	init() {
		lastEvent = Var(.noEvent)
	}
}

func controlView(_ controlViewState: ControlViewState) -> ViewConvertible {
	return View(
		.layout -- .center(
			.view(TextField.label(.stringValue <-- controlViewState.lastEvent)),
			.space(),
			.view(
				length: 60,
				breadth: 220,
				Control(
					type: MouseControl.self,
					.layer -- Layer(
						.borderWidth -- 2,
						.backgroundColor -- NSColor.orange.cgColor,
						.borderColor -- NSColor.brown.cgColor,
						.cornerRadius -- 8
					),
					.sendActionOn -- [.leftMouseDown],
					.action(\.cell?.state) --> Input()
						.map { state in state == .on ? .touchDownEvent : .touchUpEvent }
						.bind(to: controlViewState.lastEvent)
				)
			)
		)
	)
}

class MouseControl: NSControl {
	class MouseCell: NSActionCell {
		override func trackMouse(with event: NSEvent, in cellFrame: NSRect, of controlView: NSView, untilMouseUp flag: Bool) -> Bool {
			let value = super.trackMouse(with: event, in: cellFrame, of: controlView, untilMouseUp: flag)
			if value, let mouseControl = controlView as? MouseControl {
				setNextState()
				mouseControl.sendAction(action, to: target)
			}
			return value
		}
	}
	override class var cellClass: AnyClass? { get { return MouseCell.self } set { super.cellClass = newValue } }
}

private extension String {
	static let noEvent = NSLocalizedString("No actions emitted", comment: "")
	static let touchDownEvent = NSLocalizedString("Mouse down emitted", comment: "")
	static let touchUpEvent = NSLocalizedString("Mouse up emitted", comment: "")
}
