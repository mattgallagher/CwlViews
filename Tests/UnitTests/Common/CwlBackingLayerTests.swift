//
//  CwlBackingLayerTests.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 4/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
#if os(macOS)
	import CoreImage
#endif
@testable import CwlViews

class TestLayer: CALayer {
	var needsDisplayCalled: Int = 0
	override func setNeedsDisplay() {
		needsDisplayCalled += 1
	}

	var lastDisplayedRect: CGRect = .zero
	override func setNeedsDisplay(_ r: CGRect) {
		lastDisplayedRect = r
	}

	var removeAllCalled: Int = 0
	override func removeAllAnimations() {
		removeAllCalled += 1
	}
	
	var removedKeys: [String] = []
	override func removeAnimation(forKey key: String) {
		removedKeys.append(key)
	}
	
	var lastScrolledRect: CGRect = .zero
	override func scrollRectToVisible(_ r: CGRect) {
		lastScrolledRect = r
	}
}

extension BackingLayer: TestableBinder {
	static func constructor(binding: BackingLayer.Binding) -> Preparer.Instance {
		let layer = TestLayer()
		BackingLayer(binding).apply(to: layer)
		return layer
	}
	static var shoudPerformReleaseCheck: Bool { return false }
}

class CwlBackingLayerTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	#if os(macOS)
		func testAutoresizingMask() {
			BackingLayer.testValueBinding(
				name: .autoresizingMask,
				inputs: (.layerMinXMargin, .layerMinYMargin),
				outputs: ([], .layerMinXMargin, .layerMinYMargin),
				getter: { $0.autoresizingMask }
			)
		}
	#endif
	func testAffineTransform() {
		BackingLayer.testValueBinding(
			name: .affineTransform,
			inputs: (CGAffineTransform(rotationAngle: 10), CGAffineTransform(scaleX: 2, y: 2)),
			outputs: (CGAffineTransform.identity, CGAffineTransform(rotationAngle: 10), CGAffineTransform(scaleX: 2, y: 2)),
			getter: { $0.affineTransform() }
		)
	}
	func testAnchorPoint() {
		BackingLayer.testValueBinding(
			name: .anchorPoint,
			inputs: (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)),
			outputs: (CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)),
			getter: { $0.anchorPoint }
		)
	}
	func testAnchorPointZ() {
		BackingLayer.testValueBinding(
			name: .anchorPointZ,
			inputs: (1, -1),
			outputs: (0, 1, -1),
			getter: { $0.anchorPointZ }
		)
	}
	func testActions() {
		var lastValue: [String: String]? = nil
		let input = Input<[AnyHashable: Any]?>().subscribeValuesUntilEnd {
			lastValue = $0 as? [String: String]
		}
		BackingLayer.testValueBinding(
			name: .actions,
			inputs: (["a": input], ["b": input]),
			outputs: (0, 1, 2),
			getter: { (l: CALayer) -> Int in
				if let a = l.actions?["a"] {
					a.run(forKey: "a", object: l, arguments: ["b": "c"])
				}
				if let a = l.actions?["b"] {
					a.run(forKey: "b", object: l, arguments: ["d": "e"])
				}
				if lastValue == ["d": "e"] { return 2 }
				if lastValue == ["b": "c"] { return 1 }
				return 0
			}
		)
	}
	func testBackgroundColor() {
		BackingLayer.testValueBinding(
			name: .backgroundColor,
			inputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			outputs: (nil, CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			getter: { $0.backgroundColor }
		)
	}
	#if os(macOS)
		func testBackgroundFilters() {
			BackingLayer.testValueBinding(
				name: .backgroundFilters,
				inputs: ([CIFilter(name: "CIGaussianBlur")!], [CIFilter(name: "CIBloom")!]),
				outputs: (nil, "CIGaussianBlur", "CIBloom"),
				getter: { ($0.backgroundFilters?.first as? CIFilter)?.name }
			)
		}
	#endif
	func testBorderColor() {
		BackingLayer.testValueBinding(
			name: .borderColor,
			inputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			outputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			getter: { $0.borderColor }
		)
	}
	func testBorderWidth() {
		BackingLayer.testValueBinding(
			name: .borderWidth,
			inputs: (1, -1),
			outputs: (0, 1, -1),
			getter: { $0.borderWidth }
		)
	}
	func testBounds() {
		BackingLayer.testValueBinding(
			name: .bounds,
			inputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			outputs: (.zero, CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			getter: { $0.bounds }
		)
	}
	#if os(macOS)
		func testCompositingFilter() {
			BackingLayer.testValueBinding(
				name: .compositingFilter,
				inputs: (CIFilter(name: "CIGaussianBlur"), CIFilter(name: "CIBloom")),
				outputs: (nil, "CIGaussianBlur", "CIBloom"),
				getter: { ($0.compositingFilter as? CIFilter)?.name }
			)
		}
	#endif
	func testContents() {
		BackingLayer.testValueBinding(
			name: .contents,
			inputs: (1, 2),
			outputs: (nil, 1, 2),
			getter: { $0.contents as? Int }
		)
	}
	func testContentsCenter() {
		BackingLayer.testValueBinding(
			name: .contentsCenter,
			inputs: (CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			outputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			getter: { $0.contentsCenter }
		)
	}
	func testContentsGravity() {
		BackingLayer.testValueBinding(
			name: .contentsGravity,
			inputs: (.top, .bottom),
			outputs: (.resize, .top, .bottom),
			getter: { $0.contentsGravity }
		)
	}
	func testContentsRect() {
		BackingLayer.testValueBinding(
			name: .contentsRect,
			inputs: (CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			outputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			getter: { $0.contentsRect }
		)
	}
	func testContentsScale() {
		BackingLayer.testValueBinding(
			name: .contentsScale,
			inputs: (1, -1),
			outputs: (1, 1, -1),
			getter: { $0.contentsScale }
		)
	}
	func testCornerRadius() {
		BackingLayer.testValueBinding(
			name: .cornerRadius,
			inputs: (1, -1),
			outputs: (0, 1, -1),
			getter: { $0.cornerRadius }
		)
	}
	func testIsDoubleSided() {
		BackingLayer.testValueBinding(
			name: .isDoubleSided,
			inputs: (true, false),
			outputs: (true, true, false),
			getter: { $0.isDoubleSided }
		)
	}
	func testDrawsAsynchronously() {
		BackingLayer.testValueBinding(
			name: .drawsAsynchronously,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.drawsAsynchronously }
		)
	}
	func testEdgeAntialiasingMask() {
		BackingLayer.testValueBinding(
			name: .edgeAntialiasingMask,
			inputs: (CAEdgeAntialiasingMask.layerBottomEdge, CAEdgeAntialiasingMask.layerTopEdge),
			outputs: ([.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge], CAEdgeAntialiasingMask.layerBottomEdge, CAEdgeAntialiasingMask.layerTopEdge),
			getter: { $0.edgeAntialiasingMask }
		)
	}
	#if os(macOS)
		func testFilters() {
			BackingLayer.testValueBinding(
				name: .filters,
				inputs: ([CIFilter(name: "CIGaussianBlur")!], [CIFilter(name: "CIBloom")!]),
				outputs: (nil, "CIGaussianBlur", "CIBloom"),
				getter: { ($0.filters?.first as? CIFilter)?.name }
			)
		}
	#endif
	func testFrame() {
		BackingLayer.testValueBinding(
			name: .frame,
			inputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			outputs: (.zero, CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			getter: { $0.frame }
		)
	}
	func testIsGeometryFlipped() {
		BackingLayer.testValueBinding(
			name: .isGeometryFlipped,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isGeometryFlipped }
		)
	}
	func testIsHidden() {
		BackingLayer.testValueBinding(
			name: .isHidden,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isHidden }
		)
	}
	func testMagnificationFilter() {
		BackingLayer.testValueBinding(
			name: .magnificationFilter,
			inputs: (CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			outputs: (CALayerContentsFilter.linear, CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			getter: { $0.magnificationFilter }
		)
	}
	func testMask() {
		BackingLayer.testValueBinding(
			name: .mask,
			inputs: (Layer() as LayerConvertible?, Layer(.frame -- CGRect(x: 0, y: 0, width: 1, height: 1)) as LayerConvertible?),
			outputs: (nil as CGRect?, CGRect.zero as CGRect?, CGRect(x: 0, y: 0, width: 1, height: 1) as CGRect?),
			getter: { (layer: CALayer) -> CGRect? in layer.mask?.frame }
		)
	}
	func testMasksToBounds() {
		BackingLayer.testValueBinding(
			name: .masksToBounds,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.masksToBounds }
		)
	}
	func testMinificationFilter() {
		BackingLayer.testValueBinding(
			name: .minificationFilter,
			inputs: (CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			outputs: (CALayerContentsFilter.linear, CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			getter: { $0.minificationFilter }
		)
	}
	func testMinificationFilterBias() {
		BackingLayer.testValueBinding(
			name: .minificationFilterBias,
			inputs: (1, -1),
			outputs: (0, 1, -1),
			getter: { $0.minificationFilterBias }
		)
	}
	func testName() {
		BackingLayer.testValueBinding(
			name: .name,
			inputs: ("a", "b"),
			outputs: (nil, "a", "b"),
			getter: { $0.name }
		)
	}
	func testNeedsDisplayOnBoundsChange() {
		BackingLayer.testValueBinding(
			name: .needsDisplayOnBoundsChange,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.needsDisplayOnBoundsChange }
		)
	}
	func testOpacity() {
		BackingLayer.testValueBinding(
			name: .opacity,
			inputs: (0, 0.5),
			outputs: (1, 0, 0.5),
			getter: { $0.opacity }
		)
	}
	func testIsOpaque() {
		BackingLayer.testValueBinding(
			name: .isOpaque,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isOpaque }
		)
	}
	func testPosition() {
		BackingLayer.testValueBinding(
			name: .position,
			inputs: (CGPoint(x: 0.5, y: 0.5), CGPoint(x: 1, y: 1)),
			outputs: (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.5, y: 0.5), CGPoint(x: 1, y: 1)),
			getter: { $0.position }
		)
	}
	func testRasterizationScale() {
		BackingLayer.testValueBinding(
			name: .rasterizationScale,
			inputs: (3, 2),
			outputs: (1, 3, 2),
			getter: { $0.rasterizationScale }
		)
	}
	func testShadowColor() {
		BackingLayer.testValueBinding(
			name: .shadowColor,
			inputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			outputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			getter: { $0.shadowColor }
		)
	}
	func testShadowOffset() {
		BackingLayer.testValueBinding(
			name: .shadowOffset,
			inputs: (CGSize(width: 0, height: 0), CGSize(width: 1, height: 1)),
			outputs: (CGSize(width: 0, height: -3), CGSize(width: 0, height: 0), CGSize(width: 1, height: 1)),
			getter: { $0.shadowOffset }
		)
	}
	func testShadowOpacity() {
		BackingLayer.testValueBinding(
			name: .shadowOpacity,
			inputs: (1, 0.5),
			outputs: (0, 1, 0.5),
			getter: { $0.shadowOpacity }
		)
	}
	func testShadowPath() {
		BackingLayer.testValueBinding(
			name: .shadowPath,
			inputs: (CGPath(rect: .zero, transform: nil) as CGPath?, CGPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1), transform: nil) as CGPath?),
			outputs: (nil, .zero, CGRect(x: 0, y: 0, width: 1, height: 1)),
			getter: { (l: CALayer) -> CGRect? in l.shadowPath?.boundingBox }
		)
	}
	func testShadowRadius() {
		BackingLayer.testValueBinding(
			name: .shadowRadius,
			inputs: (1, 2),
			outputs: (3, 1, 2),
			getter: { $0.shadowRadius }
		)
	}
	func testShouldRasterize() {
		BackingLayer.testValueBinding(
			name: .shouldRasterize,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.shouldRasterize }
		)
	}
	func testStyle() {
		BackingLayer.testValueBinding(
			name: .style,
			inputs: ([:], ["a": "b"]),
			outputs: (nil, [:], ["a": "b"]),
			getter: { $0.style as? [String: String] }
		)
	}
	func testSublayers() {
		BackingLayer.testValueBinding(
			name: .sublayers,
			inputs: ([Layer()], [Layer(.frame -- CGRect(x: 0, y: 0, width: 1, height: 1))]),
			outputs: (nil, CGRect.zero, CGRect(x: 0, y: 0, width: 1, height: 1)),
			getter: { $0.sublayers?.first?.frame }
		)
	}
	func testSublayerTransform() {
		BackingLayer.testValueBinding(
			name: .sublayerTransform,
			inputs: (CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			outputs: (CATransform3DMakeScale(1, 1, 1), CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			getter: { $0.sublayerTransform }
		)
	}
	func testTransform() {
		BackingLayer.testValueBinding(
			name: .transform,
			inputs: (CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			outputs: (CATransform3DMakeScale(1, 1, 1), CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			getter: { $0.transform }
		)
	}
	func testZPosition() {
		BackingLayer.testValueBinding(
			name: .zPosition,
			inputs: (3, 2),
			outputs: (0, 3, 2),
			getter: { $0.zPosition }
		)
	}
	
	// MARK: - 2. Signal bindings
	
	func testAddAnimation() {
		BackingLayer.testSignalBinding(
			name: .addAnimation,
			inputs: (AnimationForKey.fade, AnimationForKey.moveIn(from: .left)),
			outputs: (nil, .fade, .moveIn),
			getter: { ($0.animation(forKey: kCATransition) as? CATransition)?.type }
		)
	}

	func testNeedsDisplay() {
		BackingLayer.testSignalBinding(
			name: .needsDisplay,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestLayer).needsDisplayCalled }
		)
	}

	func testNeedsDisplayInRect() {
		BackingLayer.testSignalBinding(
			name: .needsDisplayInRect,
			inputs: (CGRect(x: 1, y: 1, width: 1, height: 1), CGRect(x: 2, y: 2, width: 2, height: 2)),
			outputs: (CGRect.zero, CGRect(x: 1, y: 1, width: 1, height: 1), CGRect(x: 2, y: 2, width: 2, height: 2)),
			getter: { ($0 as! TestLayer).lastDisplayedRect }
		)
	}

	func testRemoveAllAnimations() {
		BackingLayer.testSignalBinding(
			name: .removeAllAnimations,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestLayer).removeAllCalled }
		)
	}

	func testRemoveAnimationForKey() {
		BackingLayer.testSignalBinding(
			name: .removeAnimationForKey,
			inputs: ("a", "b"),
			outputs: ([], ["a"], ["a", "b"]),
			getter: { ($0 as! TestLayer).removedKeys }
		)
	}

	func testScrollRectToVisible() {
		BackingLayer.testSignalBinding(
			name: .scrollRectToVisible,
			inputs: (CGRect(x: 1, y: 1, width: 1, height: 1), CGRect(x: 2, y: 2, width: 2, height: 2)),
			outputs: (CGRect.zero, CGRect(x: 1, y: 1, width: 1, height: 1), CGRect(x: 2, y: 2, width: 2, height: 2)),
			getter: { ($0 as! TestLayer).lastScrolledRect }
		)
	}
}

extension CATransform3D: Equatable {
	public static func ==(_ lhs: CATransform3D, _ rhs: CATransform3D) -> Bool {
		return CATransform3DEqualToTransform(lhs, rhs)
	}
}
