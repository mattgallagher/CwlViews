//
//  CwlBackingLayerTests.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 4/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension Layer: TestableBinder {
	static func constructor(binding: Layer.Binding) -> Preparer.Instance {
		let layer = TestLayer()
		Layer(binding).apply(to: layer)
		return layer
	}
	static var shoudPerformReleaseCheck: Bool { return false }
}

class CwlLayerTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	#if os(macOS)
		func testAutoresizingMask() {
			Layer.testValueBinding(
				name: .autoresizingMask,
				inputs: (.layerMinXMargin, .layerMinYMargin),
				outputs: ([], .layerMinXMargin, .layerMinYMargin),
				getter: { $0.autoresizingMask }
			)
		}
	#endif
	func testAffineTransform() {
		Layer.testValueBinding(
			name: .affineTransform,
			inputs: (CGAffineTransform(rotationAngle: 10), CGAffineTransform(scaleX: 2, y: 2)),
			outputs: (CGAffineTransform.identity, CGAffineTransform(rotationAngle: 10), CGAffineTransform(scaleX: 2, y: 2)),
			getter: { $0.affineTransform() }
		)
	}
	func testAnchorPoint() {
		Layer.testValueBinding(
			name: .anchorPoint,
			inputs: (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)),
			outputs: (CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)),
			getter: { $0.anchorPoint }
		)
	}
	func testAnchorPointZ() {
		Layer.testValueBinding(
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
		Layer.testValueBinding(
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
		Layer.testValueBinding(
			name: .backgroundColor,
			inputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1])!, CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])!),
			outputs: (nil, CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1])!, CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])!),
			getter: { $0.backgroundColor }
		)
	}
	#if os(macOS)
		func testBackgroundFilters() {
			Layer.testValueBinding(
				name: .backgroundFilters,
				inputs: ([CIFilter(name: "CIGaussianBlur")!], [CIFilter(name: "CIBloom")!]),
				outputs: (nil, "CIGaussianBlur", "CIBloom"),
				getter: { ($0.backgroundFilters?.first as? CIFilter)?.name }
			)
		}
	#endif
	func testBorderColor() {
		Layer.testValueBinding(
			name: .borderColor,
			inputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1])!, CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])!),
			outputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 0, 0, 1])!, CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1])!, CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])!),
			getter: { $0.borderColor }
		)
	}
	func testBorderWidth() {
		Layer.testValueBinding(
			name: .borderWidth,
			inputs: (1, -1),
			outputs: (0, 1, -1),
			getter: { $0.borderWidth }
		)
	}
	func testBounds() {
		Layer.testValueBinding(
			name: .bounds,
			inputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			outputs: (.zero, CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			getter: { $0.bounds }
		)
	}
	#if os(macOS)
		func testCompositingFilter() {
			Layer.testValueBinding(
				name: .compositingFilter,
				inputs: (CIFilter(name: "CIGaussianBlur"), CIFilter(name: "CIBloom")),
				outputs: (nil, "CIGaussianBlur", "CIBloom"),
				getter: { ($0.compositingFilter as? CIFilter)?.name }
			)
		}
	#endif
	func testContents() {
		Layer.testValueBinding(
			name: .contents,
			inputs: (1, 2),
			outputs: (nil, 1, 2),
			getter: { $0.contents as? Int }
		)
	}
	func testContentsCenter() {
		Layer.testValueBinding(
			name: .contentsCenter,
			inputs: (CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			outputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			getter: { $0.contentsCenter }
		)
	}
	func testContentsGravity() {
		Layer.testValueBinding(
			name: .contentsGravity,
			inputs: (.top, .bottom),
			outputs: (.resize, .top, .bottom),
			getter: { $0.contentsGravity }
		)
	}
	func testContentsRect() {
		Layer.testValueBinding(
			name: .contentsRect,
			inputs: (CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			outputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 1, y: 1, width: 3, height: 3)),
			getter: { $0.contentsRect }
		)
	}
	func testContentsScale() {
		Layer.testValueBinding(
			name: .contentsScale,
			inputs: (1, -1),
			outputs: (1, 1, -1),
			getter: { $0.contentsScale }
		)
	}
	func testCornerRadius() {
		Layer.testValueBinding(
			name: .cornerRadius,
			inputs: (1, -1),
			outputs: (0, 1, -1),
			getter: { $0.cornerRadius }
		)
	}
	func testIsDoubleSided() {
		Layer.testValueBinding(
			name: .isDoubleSided,
			inputs: (true, false),
			outputs: (true, true, false),
			getter: { $0.isDoubleSided }
		)
	}
	func testDrawsAsynchronously() {
		Layer.testValueBinding(
			name: .drawsAsynchronously,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.drawsAsynchronously }
		)
	}
	func testEdgeAntialiasingMask() {
		Layer.testValueBinding(
			name: .edgeAntialiasingMask,
			inputs: (CAEdgeAntialiasingMask.layerBottomEdge, CAEdgeAntialiasingMask.layerTopEdge),
			outputs: ([.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge], CAEdgeAntialiasingMask.layerBottomEdge, CAEdgeAntialiasingMask.layerTopEdge),
			getter: { $0.edgeAntialiasingMask }
		)
	}
	#if os(macOS)
		func testFilters() {
			Layer.testValueBinding(
				name: .filters,
				inputs: ([CIFilter(name: "CIGaussianBlur")!], [CIFilter(name: "CIBloom")!]),
				outputs: (nil, "CIGaussianBlur", "CIBloom"),
				getter: { ($0.filters?.first as? CIFilter)?.name }
			)
		}
	#endif
	func testFrame() {
		Layer.testValueBinding(
			name: .frame,
			inputs: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			outputs: (.zero, CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 1, y: 1, width: 2, height: 2)),
			getter: { $0.frame }
		)
	}
	func testIsGeometryFlipped() {
		Layer.testValueBinding(
			name: .isGeometryFlipped,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isGeometryFlipped }
		)
	}
	func testIsHidden() {
		Layer.testValueBinding(
			name: .isHidden,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isHidden }
		)
	}
	func testMagnificationFilter() {
		Layer.testValueBinding(
			name: .magnificationFilter,
			inputs: (CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			outputs: (CALayerContentsFilter.linear, CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			getter: { $0.magnificationFilter }
		)
	}
	func testMask() {
		Layer.testValueBinding(
			name: .mask,
			inputs: (Layer() as LayerConvertible?, Layer(.frame -- CGRect(x: 0, y: 0, width: 1, height: 1)) as LayerConvertible?),
			outputs: (nil as CGRect?, CGRect.zero as CGRect?, CGRect(x: 0, y: 0, width: 1, height: 1) as CGRect?),
			getter: { (layer: CALayer) -> CGRect? in layer.mask?.frame }
		)
	}
	func testMasksToBounds() {
		Layer.testValueBinding(
			name: .masksToBounds,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.masksToBounds }
		)
	}
	func testMinificationFilter() {
		Layer.testValueBinding(
			name: .minificationFilter,
			inputs: (CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			outputs: (CALayerContentsFilter.linear, CALayerContentsFilter.nearest, CALayerContentsFilter.trilinear),
			getter: { $0.minificationFilter }
		)
	}
	func testMinificationFilterBias() {
		Layer.testValueBinding(
			name: .minificationFilterBias,
			inputs: (1, -1),
			outputs: (0, 1, -1),
			getter: { $0.minificationFilterBias }
		)
	}
	func testName() {
		Layer.testValueBinding(
			name: .name,
			inputs: ("a", "b"),
			outputs: (nil, "a", "b"),
			getter: { $0.name }
		)
	}
	func testNeedsDisplayOnBoundsChange() {
		Layer.testValueBinding(
			name: .needsDisplayOnBoundsChange,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.needsDisplayOnBoundsChange }
		)
	}
	func testOpacity() {
		Layer.testValueBinding(
			name: .opacity,
			inputs: (0, 0.5),
			outputs: (1, 0, 0.5),
			getter: { $0.opacity }
		)
	}
	func testIsOpaque() {
		Layer.testValueBinding(
			name: .isOpaque,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isOpaque }
		)
	}
	func testPosition() {
		Layer.testValueBinding(
			name: .position,
			inputs: (CGPoint(x: 0.5, y: 0.5), CGPoint(x: 1, y: 1)),
			outputs: (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.5, y: 0.5), CGPoint(x: 1, y: 1)),
			getter: { $0.position }
		)
	}
	func testRasterizationScale() {
		Layer.testValueBinding(
			name: .rasterizationScale,
			inputs: (3, 2),
			outputs: (1, 3, 2),
			getter: { $0.rasterizationScale }
		)
	}
	func testShadowColor() {
		Layer.testValueBinding(
			name: .shadowColor,
			inputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			outputs: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			getter: { $0.shadowColor }
		)
	}
	func testShadowOffset() {
		Layer.testValueBinding(
			name: .shadowOffset,
			inputs: (CGSize(width: 0, height: 0), CGSize(width: 1, height: 1)),
			outputs: (CGSize(width: 0, height: -3), CGSize(width: 0, height: 0), CGSize(width: 1, height: 1)),
			getter: { $0.shadowOffset }
		)
	}
	func testShadowOpacity() {
		Layer.testValueBinding(
			name: .shadowOpacity,
			inputs: (1, 0.5),
			outputs: (0, 1, 0.5),
			getter: { $0.shadowOpacity }
		)
	}
	func testShadowPath() {
		Layer.testValueBinding(
			name: .shadowPath,
			inputs: (CGPath(rect: .zero, transform: nil) as CGPath?, CGPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1), transform: nil) as CGPath?),
			outputs: (nil, .zero, CGRect(x: 0, y: 0, width: 1, height: 1)),
			getter: { (l: CALayer) -> CGRect? in l.shadowPath?.boundingBox }
		)
	}
	func testShadowRadius() {
		Layer.testValueBinding(
			name: .shadowRadius,
			inputs: (1, 2),
			outputs: (3, 1, 2),
			getter: { $0.shadowRadius }
		)
	}
	func testShouldRasterize() {
		Layer.testValueBinding(
			name: .shouldRasterize,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.shouldRasterize }
		)
	}
	func testStyle() {
		Layer.testValueBinding(
			name: .style,
			inputs: ([:], ["a": "b"]),
			outputs: (nil, [:], ["a": "b"]),
			getter: { $0.style as? [String: String] }
		)
	}
	func testSublayers() {
		Layer.testValueBinding(
			name: .sublayers,
			inputs: ([Layer()], [Layer(.frame -- CGRect(x: 0, y: 0, width: 1, height: 1))]),
			outputs: (nil, CGRect.zero, CGRect(x: 0, y: 0, width: 1, height: 1)),
			getter: { $0.sublayers?.first?.frame }
		)
	}
	func testSublayerTransform() {
		Layer.testValueBinding(
			name: .sublayerTransform,
			inputs: (CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			outputs: (CATransform3DMakeScale(1, 1, 1), CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			getter: { $0.sublayerTransform }
		)
	}
	func testTransform() {
		Layer.testValueBinding(
			name: .transform,
			inputs: (CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			outputs: (CATransform3DMakeScale(1, 1, 1), CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			getter: { $0.transform }
		)
	}
	func testZPosition() {
		Layer.testValueBinding(
			name: .zPosition,
			inputs: (3, 2),
			outputs: (0, 3, 2),
			getter: { $0.zPosition }
		)
	}
	
	// MARK: - 2. Signal bindings
	
	func testAddAnimation() {
		Layer.testSignalBinding(
			name: .addAnimation,
			inputs: (AnimationForKey.fade, AnimationForKey.moveIn(from: .left)),
			outputs: (nil, .fade, .moveIn),
			getter: { ($0.animation(forKey: kCATransition) as? CATransition)?.type }
		)
	}

	func testNeedsDisplay() {
		Layer.testSignalBinding(
			name: .needsDisplay,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestLayer).needsDisplayCalled }
		)
	}

	func testNeedsDisplayInRect() {
		Layer.testSignalBinding(
			name: .needsDisplayInRect,
			inputs: (CGRect(x: 1, y: 1, width: 1, height: 1), CGRect(x: 2, y: 2, width: 2, height: 2)),
			outputs: (CGRect.zero, CGRect(x: 1, y: 1, width: 1, height: 1), CGRect(x: 2, y: 2, width: 2, height: 2)),
			getter: { ($0 as! TestLayer).lastDisplayedRect }
		)
	}

	func testRemoveAllAnimations() {
		Layer.testSignalBinding(
			name: .removeAllAnimations,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestLayer).removeAllCalled }
		)
	}

	func testRemoveAnimationForKey() {
		Layer.testSignalBinding(
			name: .removeAnimationForKey,
			inputs: ("a", "b"),
			outputs: ([], ["a"], ["a", "b"]),
			getter: { ($0 as! TestLayer).removedKeys }
		)
	}

	func testScrollRectToVisible() {
		Layer.testSignalBinding(
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
