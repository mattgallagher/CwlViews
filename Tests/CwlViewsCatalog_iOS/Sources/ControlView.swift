//
//  ControlView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct ControlViewState: CodableContainer {
	let lastEvent: Var<String>
	init() {
		lastEvent = Var(.noEvent)
	}
}

func controlView(_ controlViewState: ControlViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				.view(Label(.text <-- controlViewState.lastEvent)),
				.space(),
				.view(
					length: 60,
					breadth: 220,
					Control(
						.backgroundColor -- .orange,
						.layer -- Layer(.borderWidth -- 2, .borderColor -- UIColor.brown.cgColor, .cornerRadius -- 8),
						.action(.touchDown) --> Input().map { .touchDownEvent }.bind(to: controlViewState.lastEvent),
						.action(.touchUpInside) --> Input().map { .touchUpEvent }.bind(to: controlViewState.lastEvent),
						.action(.touchDragInside) --> Input().map { .touchDragEvent }.bind(to:controlViewState.lastEvent)
					)
				)
			)
		)
	)
}

private extension String {
	static let noEvent = NSLocalizedString("No actions emitted", comment: "")
	static let touchDownEvent = NSLocalizedString("TouchDown emitted", comment: "")
	static let touchUpEvent = NSLocalizedString("TouchUp emitted", comment: "")
	static let touchDragEvent = NSLocalizedString("Touch drag emitted", comment: "")
}
