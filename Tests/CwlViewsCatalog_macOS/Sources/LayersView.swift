//
//  LayersView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct LayersViewState: CodableContainer {
	let path: TempVar<CGPath>
	init() {
		path = TempVar()
	}
}
