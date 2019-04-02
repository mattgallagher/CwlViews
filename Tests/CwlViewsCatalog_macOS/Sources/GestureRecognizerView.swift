//
//  GestureRecognizerView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct GestureRecognizerViewState: CodableContainer {
	let lastEvent: Var<String>
	init() {
		lastEvent = Var(.noEvent)
	}
}

private extension String {
	static let noEvent = NSLocalizedString("No gestures detected", comment: "")
}
