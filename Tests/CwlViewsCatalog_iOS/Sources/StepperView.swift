//
//  StepperView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 13/5/19.
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

struct StepperViewState: CodableContainer {
	let value: Var<Double>
	init() {
		value = Var(10.5)
	}
}

func stepperlView(_ viewState: StepperViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
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
					.view(Label(.text <-- viewState.value.allChanges().map { value in "\(value)" })),
					.space(),
					.view(
						Stepper(
							.minimumValue -- 0.0,
							.maximumValue -- 100.0,
							.isContinuous -- true,
							.stepValue -- 1.5,
							.tintColor -- .purple,
							.decrementImage -- .normal(.drawn(width: 10, height: 10) { $0.fillEllipse(in: $1) }),
							.incrementImage -- .normal(.drawn(width: 10, height: 10) { $0.fill($1) }),
							.value <-- viewState.value,
							.action(.valueChanged, \.value) --> viewState.value.update())
					)
				)
			)
		)
	)
}

