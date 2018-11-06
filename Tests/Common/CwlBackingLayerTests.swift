//
//  CwlBackingLayerTests.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 4/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
@testable import CwlViews

func backingLayerConstructor(_ binding: BackingLayer.Binding) -> BackingLayer.Instance {
	let binder = BackingLayer(binding)
	let layer = CALayer()
	binder.applyBindings(to: layer)
	return layer
}


class CwlBackingLayerTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	func testAffineTransform() {
		test(
			dynamicBinding: .affineTransform,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGAffineTransform.identity,
			first: (CGAffineTransform(rotationAngle: 10), CGAffineTransform(rotationAngle: 10)),
			second: (CGAffineTransform(scaleX: 2, y: 2), CGAffineTransform(scaleX: 2, y: 2)),
			getter: { $0.affineTransform() }
		)
	}
}
