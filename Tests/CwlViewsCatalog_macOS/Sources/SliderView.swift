//
//  SliderView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SliderViewState: CodableContainer {
	static let min = 0 as Double
	static let max = 500 as Double
	static let initial = 100 as Double
	
	let value: Var<Double>
	init() {
		value = Var(.initial)
	}
}

func sliderView(_ sliderViewState: SliderViewState) -> ViewConvertible {
	return View(
		.layout -- .center(
			.view(
				TextField.label(
					.stringValue <-- sliderViewState.value.allChanges().map { .localizedStringWithFormat(.valueFormat, $0, SliderViewState.max) },
					.font -- NSFont.monospacedDigitSystemFont(ofSize: 20, weight: .regular)
				)
			),
			.space(),
			.view(
				Slider(
					.isContinuous -- true,
					.minValue -- .min,
					.maxValue -- .max,
					.doubleValue <-- sliderViewState.value,
					.action(\.doubleValue) --> sliderViewState.value.update()
				)
			)
		)
	)
}

private extension Double {
	static let min: Double = 0
	static let max: Double = 0
	static let initial: Double = 0
}

private extension String {
	static let valueFormat = NSLocalizedString("%.1f of %.1f", comment: "")
}
