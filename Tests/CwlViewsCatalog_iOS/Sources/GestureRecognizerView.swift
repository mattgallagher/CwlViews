//
//  GestureRecognizerView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
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

struct GestureRecognizerViewState: CodableContainer {
	let lastEvent: Var<String>
	init() {
		lastEvent = Var(.noEvent)
	}
}

func gestureRecognizerView(_ gestureRecognizerViewState: GestureRecognizerViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- gestureLayout(
				gestureRecognizerViewState,
				gestureArea(text: .longPanTap, color: .magenta, recognizers: [
					LongPressGestureRecognizer(.action --> Input().map { _ in .longPressGesture }.bind(to: gestureRecognizerViewState.lastEvent)),
					PanGestureRecognizer(.action --> Input().map { _ in .panGesture }.bind(to: gestureRecognizerViewState.lastEvent)),
					TapGestureRecognizer(.action --> Input().map { _ in .tapGesture }.bind(to: gestureRecognizerViewState.lastEvent))
				]),
				gestureArea(text: .pinchRotateSwipe, color: .orange, recognizers: [
					PinchGestureRecognizer(.action --> Input().map { _ in .pinchGesture }.bind(to: gestureRecognizerViewState.lastEvent)),
					RotationGestureRecognizer(.action --> Input().map { _ in .rotationGesture }.bind(to: gestureRecognizerViewState.lastEvent)),
					SwipeGestureRecognizer(.action --> Input().map { _ in .swipeGesture }.bind(to: gestureRecognizerViewState.lastEvent))
				]),
				gestureArea(text: .screenEdge, color: .green, recognizers: [
					ScreenEdgePanGestureRecognizer(
						.edges -- UIRectEdge.right,
						.action --> Input().map { _ in .screenEdgePanGesture }.bind(to: gestureRecognizerViewState.lastEvent)
					)
				])
			)
		)
	)
}

func gestureLayout(_ gestureRecognizerViewState: GestureRecognizerViewState, _ longPanTap: Layout.Entity, _ pinchRotateSwipe: Layout.Entity, _ screenEdge: Layout.Entity) -> Layout {
	return .vertical(
		marginEdges: MarginEdges.allLayout.subtracting(.trailingLayout),
		.vertical(
			align: .center,
			.space(Layout.Dimension.init(integerLiteral: 24)),
			.view(Label(.text <-- gestureRecognizerViewState.lastEvent)),
			.space(),
			longPanTap,
			.matched(
				.space(.fillRemaining),
				.free(pinchRotateSwipe),
				.same(.space(.fillRemaining)),
				.free(screenEdge),
				.same(.space(.fillRemaining))
			)
		)
	)
}

func gestureArea(text: String, color: UIColor, recognizers: [GestureRecognizerConvertible]) -> Layout.Entity {
	return .view(
		length: .equalTo(ratio: 0.25),
		breadth: .equalTo(ratio: 1),
		View(
			.backgroundColor -- color,
			.layer -- Layer(
				.borderWidth -- 1,
				.borderColor -- UIColor.darkGray.cgColor,
				.cornerRadius -- 8,
				.shadowOpacity -- 0.5,
				.shadowRadius -- 8,
				.shadowOffset -- CGSize(width: -5, height: 5)
			),
			.gestureRecognizers -- recognizers,
			.layout -- .center(marginEdges: .none, .view(Label(.text -- text)))
		)
	)
}

private extension String {
	static let longPanTap = NSLocalizedString("Long, pan and tap gestures", comment: "")
	static let longPressGesture = NSLocalizedString("Long press detected", comment: "")
	static let noEvent = NSLocalizedString("No gestures detected", comment: "")
	static let panGesture = NSLocalizedString("Pan detected", comment: "")
	static let pinchGesture = NSLocalizedString("Pinch detected", comment: "")
	static let pinchRotateSwipe = NSLocalizedString("Pinch, rotate and swipe gestures", comment: "")
	static let rotationGesture = NSLocalizedString("Rotation detected", comment: "")
	static let screenEdgePanGesture = NSLocalizedString("Screen edge pan detected", comment: "")
	static let screenEdge = NSLocalizedString("Screen edge pan gesture", comment: "")
	static let swipeGesture = NSLocalizedString("Swipe detected", comment: "")
	static let tapGesture = NSLocalizedString("Tap detected", comment: "")
}
