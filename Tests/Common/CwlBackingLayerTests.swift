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

func backingLayerConstructor(_ binding: BackingLayer.Binding) -> BackingLayer.Instance {
	let binder = BackingLayer(binding)
	let layer = CALayer()
	binder.applyBindings(to: layer)
	return layer
}

class CwlBackingLayerTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	#if os(macOS)
		func testAutoresizingMask() {
			testValueBinding(
				name: .autoresizingMask,
				constructor: backingLayerConstructor,
				skipReleaseCheck: true,
				initial: [],
				first: (.layerMinXMargin, .layerMinXMargin),
				second: (.layerMinYMargin, .layerMinYMargin),
				getter: { $0.autoresizingMask }
			)
		}
	#endif
	func testAffineTransform() {
		testValueBinding(
			name: .affineTransform,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGAffineTransform.identity,
			first: (CGAffineTransform(rotationAngle: 10), CGAffineTransform(rotationAngle: 10)),
			second: (CGAffineTransform(scaleX: 2, y: 2), CGAffineTransform(scaleX: 2, y: 2)),
			getter: { $0.affineTransform() }
		)
	}
	func testAnchorPoint() {
		testValueBinding(
			name: .anchorPoint,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGPoint(x: 0.5, y: 0.5),
			first: (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)),
			second: (CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 1)),
			getter: { $0.anchorPoint }
		)
	}
	func testAnchorPointZ() {
		testValueBinding(
			name: .anchorPointZ,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (1, 1),
			second: (-1, -1),
			getter: { $0.anchorPointZ }
		)
	}
	func testActions() {
		var lastValue: [String: String]? = nil
		let input = Input<[AnyHashable: Any]?>().subscribeValuesUntilEnd {
			lastValue = $0 as? [String: String]
		}
		testValueBinding(
			name: .actions,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (["a": input], 1),
			second: (["b": input], 2),
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
		testValueBinding(
			name: .backgroundColor,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1])),
			second: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			getter: { $0.backgroundColor }
		)
	}
	#if os(macOS)
		func testBackgroundFilters() {
			testValueBinding(
				name: .backgroundFilters,
				constructor: backingLayerConstructor,
				skipReleaseCheck: true,
				initial: nil,
				first: ([CIFilter(name: "CIGaussianBlur")!], "CIGaussianBlur"),
				second: ([CIFilter(name: "CIBloom")!], "CIBloom"),
				getter: { ($0.backgroundFilters?.first as? CIFilter)?.name }
			)
		}
	#endif
	func testBorderColor() {
		testValueBinding(
			name: .borderColor,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 0, 0, 1]),
			first: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1])),
			second: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			getter: { $0.borderColor }
		)
	}
	func testBorderWidth() {
		testValueBinding(
			name: .borderWidth,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (1, 1),
			second: (-1, -1),
			getter: { $0.borderWidth }
		)
	}
	func testBounds() {
		testValueBinding(
			name: .bounds,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: .zero,
			first: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 0, y: 0, width: 1, height: 1)),
			second: (CGRect(x: 1, y: 1, width: 2, height: 2), CGRect(x: 1, y: 1, width: 2, height: 2)),
			getter: { $0.bounds }
		)
	}
	#if os(macOS)
		func testCompositingFilter() {
			testValueBinding(
				name: .compositingFilter,
				constructor: backingLayerConstructor,
				skipReleaseCheck: true,
				initial: nil,
				first: (CIFilter(name: "CIGaussianBlur"), "CIGaussianBlur"),
				second: (CIFilter(name: "CIBloom"), "CIBloom"),
				getter: { ($0.compositingFilter as? CIFilter)?.name }
			)
		}
	#endif
	func testContents() {
		testValueBinding(
			name: .contents,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: (1, 1),
			second: (2, 2),
			getter: { $0.contents as? Int }
		)
	}
	func testContentsCenter() {
		testValueBinding(
			name: .contentsCenter,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGRect(x: 0, y: 0, width: 1, height: 1),
			first: (CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 0, y: 0, width: 2, height: 2)),
			second: (CGRect(x: 1, y: 1, width: 3, height: 3), CGRect(x: 1, y: 1, width: 3, height: 3)),
			getter: { $0.contentsCenter }
		)
	}
	func testContentsGravity() {
		testValueBinding(
			name: .contentsGravity,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: .resize,
			first: (.top, .top),
			second: (.bottom, .bottom),
			getter: { $0.contentsGravity }
		)
	}
	func testContentsRect() {
		testValueBinding(
			name: .contentsRect,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGRect(x: 0, y: 0, width: 1, height: 1),
			first: (CGRect(x: 0, y: 0, width: 2, height: 2), CGRect(x: 0, y: 0, width: 2, height: 2)),
			second: (CGRect(x: 1, y: 1, width: 3, height: 3), CGRect(x: 1, y: 1, width: 3, height: 3)),
			getter: { $0.contentsRect }
		)
	}
	func testContentsScale() {
		testValueBinding(
			name: .contentsScale,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 1,
			first: (1, 1),
			second: (-1, -1),
			getter: { $0.contentsScale }
		)
	}
	func testCornerRadius() {
		testValueBinding(
			name: .cornerRadius,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (1, 1),
			second: (-1, -1),
			getter: { $0.cornerRadius }
		)
	}
	func testIsDoubleSided() {
		testValueBinding(
			name: .isDoubleSided,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: true,
			first: (true, true),
			second: (false, false),
			getter: { $0.isDoubleSided }
		)
	}
	func testDrawsAsynchronously() {
		testValueBinding(
			name: .drawsAsynchronously,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.drawsAsynchronously }
		)
	}
	func testEdgeAntialiasingMask() {
		testValueBinding(
			name: .edgeAntialiasingMask,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge],
			first: (CAEdgeAntialiasingMask.layerBottomEdge, CAEdgeAntialiasingMask.layerBottomEdge),
			second: (CAEdgeAntialiasingMask.layerTopEdge, CAEdgeAntialiasingMask.layerTopEdge),
			getter: { $0.edgeAntialiasingMask }
		)
	}
	#if os(macOS)
		func testFilters() {
			testValueBinding(
				name: .filters,
				constructor: backingLayerConstructor,
				skipReleaseCheck: true,
				initial: nil,
				first: ([CIFilter(name: "CIGaussianBlur")!], "CIGaussianBlur"),
				second: ([CIFilter(name: "CIBloom")!], "CIBloom"),
				getter: { ($0.filters?.first as? CIFilter)?.name }
			)
		}
	#endif
	func testFrame() {
		testValueBinding(
			name: .frame,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: .zero,
			first: (CGRect(x: 0, y: 0, width: 1, height: 1), CGRect(x: 0, y: 0, width: 1, height: 1)),
			second: (CGRect(x: 1, y: 1, width: 2, height: 2), CGRect(x: 1, y: 1, width: 2, height: 2)),
			getter: { $0.frame }
		)
	}
	func testIsGeometryFlipped() {
		testValueBinding(
			name: .isGeometryFlipped,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isGeometryFlipped }
		)
	}
	func testIsHidden() {
		testValueBinding(
			name: .isHidden,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isHidden }
		)
	}
	func testMagnificationFilter() {
		testValueBinding(
			name: .magnificationFilter,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CALayerContentsFilter.linear,
			first: (CALayerContentsFilter.nearest, CALayerContentsFilter.nearest),
			second: (CALayerContentsFilter.trilinear, CALayerContentsFilter.trilinear),
			getter: { $0.magnificationFilter }
		)
	}
	func testMask() {
		testValueBinding(
			name: .mask,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: nil as CGRect?,
			first: (Layer() as LayerConvertible?, CGRect.zero as CGRect?),
			second: (Layer(.frame -- CGRect(x: 0, y: 0, width: 1, height: 1)) as LayerConvertible?, CGRect(x: 0, y: 0, width: 1, height: 1) as CGRect?),
			getter: { (layer: CALayer) -> CGRect? in layer.mask?.frame }
		)
	}
	func testMasksToBounds() {
		testValueBinding(
			name: .masksToBounds,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.masksToBounds }
		)
	}
	func testMinificationFilter() {
		testValueBinding(
			name: .minificationFilter,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CALayerContentsFilter.linear,
			first: (CALayerContentsFilter.nearest, CALayerContentsFilter.nearest),
			second: (CALayerContentsFilter.trilinear, CALayerContentsFilter.trilinear),
			getter: { $0.minificationFilter }
		)
	}
	func testMinificationFilterBias() {
		testValueBinding(
			name: .minificationFilterBias,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (1, 1),
			second: (-1, -1),
			getter: { $0.minificationFilterBias }
		)
	}
	func testName() {
		testValueBinding(
			name: .name,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: ("a", "a"),
			second: ("b", "b"),
			getter: { $0.name }
		)
	}
	func testNeedsDisplayOnBoundsChange() {
		testValueBinding(
			name: .needsDisplayOnBoundsChange,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.needsDisplayOnBoundsChange }
		)
	}
	func testOpacity() {
		testValueBinding(
			name: .opacity,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 1,
			first: (0, 0),
			second: (0.5, 0.5),
			getter: { $0.opacity }
		)
	}
	func testIsOpaque() {
		testValueBinding(
			name: .isOpaque,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isOpaque }
		)
	}
	func testPosition() {
		testValueBinding(
			name: .position,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGPoint(x: 0.0, y: 0.0),
			first: (CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0.5, y: 0.5)),
			second: (CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 1)),
			getter: { $0.position }
		)
	}
	func testRasterizationScale() {
		testValueBinding(
			name: .rasterizationScale,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 1,
			first: (3, 3),
			second: (2, 2),
			getter: { $0.rasterizationScale }
		)
	}
	func testShadowColor() {
		testValueBinding(
			name: .shadowColor,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 0, 0, 1]),
			first: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [1, 0, 0, 1])),
			second: (CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1]), CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0, 1, 0, 1])),
			getter: { $0.shadowColor }
		)
	}
	func testShadowOffset() {
		testValueBinding(
			name: .shadowOffset,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CGSize(width: 0, height: -3),
			first: (CGSize(width: 0, height: 0), CGSize(width: 0, height: 0)),
			second: (CGSize(width: 1, height: 1), CGSize(width: 1, height: 1)),
			getter: { $0.shadowOffset }
		)
	}
	func testShadowOpacity() {
		testValueBinding(
			name: .shadowOpacity,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (1, 1),
			second: (0.5, 0.5),
			getter: { $0.shadowOpacity }
		)
	}
	func testShadowPath() {
		testValueBinding(
			name: .shadowPath,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: (CGPath(rect: .zero, transform: nil) as CGPath?, .zero),
			second: (CGPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1), transform: nil) as CGPath?, CGRect(x: 0, y: 0, width: 1, height: 1)),
			getter: { (l: CALayer) -> CGRect? in l.shadowPath?.boundingBox }
		)
	}
	func testShadowRadius() {
		testValueBinding(
			name: .shadowRadius,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 3,
			first: (1, 1),
			second: (2, 2),
			getter: { $0.shadowRadius }
		)
	}
	func testShouldRasterize() {
		testValueBinding(
			name: .shouldRasterize,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.shouldRasterize }
		)
	}
	func testStyle() {
		testValueBinding(
			name: .style,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: ([:], [:]),
			second: (["a": "b"], ["a": "b"]),
			getter: { $0.style as? [String: String] }
		)
	}
	func testSublayers() {
		testValueBinding(
			name: .sublayers,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: ([Layer()], CGRect.zero),
			second: ([Layer(.frame -- CGRect(x: 0, y: 0, width: 1, height: 1))], CGRect(x: 0, y: 0, width: 1, height: 1)),
			getter: { $0.sublayers?.first?.frame }
		)
	}
	func testSublayerTransform() {
		testValueBinding(
			name: .sublayerTransform,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CATransform3DMakeScale(1, 1, 1),
			first: (CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeRotation(10, 1, 2, 3)),
			second: (CATransform3DMakeTranslation(1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			getter: { $0.sublayerTransform }
		)
	}
	func testTransform() {
		testValueBinding(
			name: .transform,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: CATransform3DMakeScale(1, 1, 1),
			first: (CATransform3DMakeRotation(10, 1, 2, 3), CATransform3DMakeRotation(10, 1, 2, 3)),
			second: (CATransform3DMakeTranslation(1, 2, 3), CATransform3DMakeTranslation(1, 2, 3)),
			getter: { $0.transform }
		)
	}
	func testZPosition() {
		testValueBinding(
			name: .zPosition,
			constructor: backingLayerConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (3, 3),
			second: (2, 2),
			getter: { $0.zPosition }
		)
	}
	
	// MARK: - 1. Value bindings
	
//	func testAddAnimation() {
//		test(signalBinding)
//	}
}

extension CATransform3D: Equatable {
	public static func ==(_ lhs: CATransform3D, _ rhs: CATransform3D) -> Bool {
		return CATransform3DEqualToTransform(lhs, rhs)
	}
}
