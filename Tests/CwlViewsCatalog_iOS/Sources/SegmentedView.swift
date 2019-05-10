//
//  File.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 9/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SegmentedViewState: CodableContainer {
	let indexValue: Var<Int>
	init() {
		indexValue = Var(1)
	}
}

func segmentedControlView(_ viewState: SegmentedViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
    return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
		.backgroundColor -- .white,
		.layout -- .center(
						marginEdges: .allLayout,
						length: .equalTo(constant: 100.0),
						breadth: .equalTo(constant: 400.0),
					   	.vertical(
								align: .center,
								.view(Label(.text <-- viewState.indexValue.allChanges().map { value in "\(value)" })),
								.space(),
								.view(
									SegmentedControl(
										.momentary -- false,
										.selectItem <-- viewState.indexValue,
										.tintColor -- .red,
										.action(.valueChanged, \.selectedSegmentIndex) --> viewState.indexValue.update(),
										//.backgroundImage -- (StateAndMetrics(), .drawn(width: 512, height: 512, drawIcon)),
										.segments -- [SegmentDescriptor(title: "0", width: 40),
													  SegmentDescriptor(title: "1", width: 40),
													  SegmentDescriptor(title: "2", width: 40, enabled: false),
													  SegmentDescriptor(title: "3", width: 40)])
							)
			)
			)
		)
	)
}
