//
//  ProgressView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 14/5/19.
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

struct ProgressViewState: CodableContainer {
	var progress: TempVar<Float>
	init() {
		progress = TempVar<Float>()
	}
}

func progressView(_ viewState: ProgressViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				marginEdges: .allLayout,
				.view(
					Label(
						.text <-- viewState.progress.map(String.label),
						.font -- UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
					)
				),
				.space(),
				.view(
					length: 20,
					ProgressView(
						.trackTintColor -- .green,
						.progressImage -- .drawn(width: 300, height: 20) { $0.fillEllipse(in: $1) },
						.progress <-- viewState.progress.animate(.never)
					)
				)
			)
		),
		.lifetimes -- [
			Signal
				.interval(.sixtyTimesPerSecond)
				.map { Float($0 % .fiveSecondsAtSixtyPerSecond) / Float(Int.fiveSecondsAtSixtyPerSecond) }
				.cancellableBind(to: viewState.progress)
		]
	)
}

private extension Int {
	static let fiveSecondsAtSixtyPerSecond = 60 * 5
}

private extension DispatchTimeInterval {
	static let sixtyTimesPerSecond = DispatchTimeInterval.interval(1 / 60)
}

private extension String {
	static func label(_ progress: Float) -> String {
		return String.localizedStringWithFormat(NSLocalizedString("Progress: %0.3f", comment: ""), progress)
	}
}
