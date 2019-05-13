//
//  CwlImageDrawn.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/2/19.
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

import Foundation

#if os(macOS)
	extension NSImage {
		public static func drawn(width: CGFloat, height: CGFloat, flipped: Bool = true, _ function: @escaping (CGContext, CGRect) -> Void) -> NSImage {
			let size = CGSize(width: width, height: height)
			return NSImage(size: size, flipped: flipped) { rect -> Bool in
				guard let context = NSGraphicsContext.current else { return false }
				function(context.cgContext, rect)
				return true
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
