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

func gestureRecognizerView(_ gestureRecognizerViewState: GestureRecognizerViewState) -> ViewConvertible {
	return View(
		.layout -- gestureLayout(
			gestureRecognizerViewState,
			gestureArea(text: .longPanTap, color: .magenta, recognizers: [
				PressGestureRecognizer(.action --> Input().map { _ in .longPressGesture }.bind(to: gestureRecognizerViewState.lastEvent)),
				PanGestureRecognizer(
					.action --> Input().map { _ in .panGesture }.bind(to: gestureRecognizerViewState.lastEvent),
					.buttonMask -- 2
				),
				ClickGestureRecognizer(
					.action --> Input().map { _ in .tapGesture }.bind(to: gestureRecognizerViewState.lastEvent),
					.numberOfClicksRequired -- 2
				)
			]),
			gestureArea(text: .pinchRotate, color: .orange, recognizers: [
				MagnificationGestureRecognizer(.action --> Input().map { _ in .pinchGesture }.bind(to: gestureRecognizerViewState.lastEvent)),
				RotationGestureRecognizer(.action --> Input().map { _ in .rotationGesture }.bind(to: gestureRecognizerViewState.lastEvent))
			])
		)
	)
}

func gestureLayout(_ gestureRecognizerViewState: GestureRecognizerViewState, _ longPanTap: Layout.Entity, _ pinchRotateSwipe: Layout.Entity) -> Layout {
	return .vertical(
		.vertical(
			align: .center,
			.space(Layout.Dimension.init(integerLiteral: 24)),
			.view(TextField.label(.stringValue <-- gestureRecognizerViewState.lastEvent)),
			.space(),
			longPanTap,
			.matched(
				.space(.fillRemaining),
				.free(pinchRotateSwipe),
				.same(.space(.fillRemaining))
			)
		)
	)
}

func gestureArea(text: String, color: NSColor, recognizers: [GestureRecognizerConvertible]) -> Layout.Entity {
	return .view(
		length: .equalTo(ratio: 0.25),
		breadth: .equalTo(ratio: 1),
		View(
			.layer -- Layer(
				.backgroundColor -- color.cgColor,
				.borderWidth -- 1,
				.borderColor -- NSColor.darkGray.cgColor,
				.cornerRadius -- 8,
				.shadowOpacity -- 0.5,
				.shadowRadius -- 8,
				.shadowOffset -- CGSize(width: -5, height: 5)
			),
			.gestureRecognizers -- recognizers,
			.layout -- .center(.view(TextField.label(.stringValue -- text)))
		)
	)
}

private extension String {
	static let longPanTap = NSLocalizedString("Long, right-mouse pan and double-tap gestures", comment: "")
	static let longPressGesture = NSLocalizedString("Long press detected", comment: "")
	static let noEvent = NSLocalizedString("No gestures detected", comment: "")
	static let panGesture = NSLocalizedString("Right-mouse pan detected", comment: "")
	static let pinchGesture = NSLocalizedString("Pinch detected", comment: "")
	static let pinchRotate = NSLocalizedString("Pinch and rotate swipe gestures", comment: "")
	static let rotationGesture = NSLocalizedString("Rotation detected", comment: "")
	static let screenEdgePanGesture = NSLocalizedString("Screen edge pan detected", comment: "")
	static let screenEdge = NSLocalizedString("Screen edge pan gesture", comment: "")
	static let swipeGesture = NSLocalizedString("Swipe detected", comment: "")
	static let tapGesture = NSLocalizedString("Double tap detected", comment: "")
}
