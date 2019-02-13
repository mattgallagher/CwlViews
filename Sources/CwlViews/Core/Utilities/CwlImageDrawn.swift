//
//  CwlImageDrawn.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import Foundation

#if os(macOS)
	extension NSImage {
		public static func drawn(width: CGFloat, height: CGFloat, flipped: Bool = true, _ function: (CGContext, CGRect) -> Void) -> NSImage {
			let size = CGSize(width: width, height: height)
			return withoutActuallyEscaping(draw) { draw in
				NSImage(size: size, flipped: flipped) { rect -> Bool in
					guard let context = NSGraphicsContext.current else { return false }
					function(context.cgContext, rect)
					return true
				}
			}
		}
	}
#else
	extension UIImage {
		public static func drawn(width: CGFloat, height: CGFloat, _ function: (CGContext, CGRect) -> Void) -> UIImage {
			let size = CGSize(width: width, height: height)
			UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
			if let graphicsContext = UIGraphicsGetCurrentContext() {
				function(graphicsContext, CGRect(origin: .zero, size: size))
			}
			let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return rectangleImage ?? UIImage()
		}
	}
#endif
