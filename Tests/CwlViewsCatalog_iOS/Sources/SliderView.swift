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

func sliderView(_ sliderViewState: SliderViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(marginEdges: .allLayout,
				.view(
					Label(
						.text <-- sliderViewState.value.allChanges().map { .localizedStringWithFormat(.valueFormat, $0, SliderViewState.max) },
						.font -- UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .regular)
					)
				),
				.space(),
				.view(
					Slider(
						.isContinuous -- true,
						.minimumValue -- SliderViewState.min,
						.maximumValue -- SliderViewState.max,
						.value <-- sliderViewState.value.animate(),
						.action(.valueChanged, \.value) --> sliderViewState.value.update()
					)
				)
			)
		)
	)
}

private extension String {
	static let valueFormat = NSLocalizedString("%.1f of %.1f", comment: "")
}
