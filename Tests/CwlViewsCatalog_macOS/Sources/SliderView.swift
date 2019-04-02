//
//  SliderView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SliderViewState: CodableContainer {
	static let min = 0 as Float
	static let max = 500 as Float
	static let initial = 100 as Float
	
	let value: Var<Float>
	init() {
		value = Var(SliderViewState.initial)
	}
}
