//
//  TabButton.swift
//  CwlViewsCatalog_macOS
//
//  Created by Matt Gallagher on 2/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import AppKit

class TabButton: NSButton {
	class TabButtonCell: NSButtonCell {
		override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
			let borderRect = frame.insetBy(dx: 2.5, dy: 4.5).offsetBy(dx: 0, dy: -1)
			let isFirst = (controlView as! TabButton).isFirst
			let isLast = (controlView as! TabButton).isLast
			
			let radius: CGFloat = 12
			let corners = [isFirst ? radius : 0, isFirst ? radius : 0, isLast ? radius : 0, isLast ? radius : 0]
			let points = [
				CGPoint(x: borderRect.minX , y: borderRect.minY),
				CGPoint(x: borderRect.minX , y: borderRect.maxY),
				CGPoint(x: borderRect.maxX , y: borderRect.maxY),
				CGPoint(x: borderRect.maxX , y: borderRect.minY)
			]
			
			let path = NSBezierPath()
			path.move(to: CGPoint(x: borderRect.midX , y: borderRect.minY))
			for i in 0..<points.count {
				path.appendArc(
					from: CGPoint(x: points[(i + 0) % 4].x, y: points[(i + 0) % 4].y),
					to: CGPoint(x: points[(i + 1) % 4].x, y: points[(i + 1) % 4].y),
					radius: corners[i]
				)
			}
			path.line(to: CGPoint(x: borderRect.midX , y: borderRect.minY))
			
			if state == .on || isHighlighted {
				NSColor.controlAccentColor.setStroke()
			} else {
				NSColor.controlShadowColor.setStroke()
			}
			path.lineWidth = 1
			path.stroke()
			
			if state == .on || isHighlighted {
				NSColor.selectedContentBackgroundColor.blended(withFraction: 0.8, of: .clear)?.setFill()
			} else {
				NSColor.controlBackgroundColor.blended(withFraction: 0.95, of: .clear)?.setFill()
			}
			path.fill()
		}
		
		override var cellSize: NSSize {
			var result = super.cellSize
			result.width += 8
			result.height += 8
			return result
		}
	}
	
	override class var cellClass: AnyClass? { get { return TabButtonCell.self } set { super.cellClass = newValue } }
	
	var isFirst: Bool = false
	var isLast: Bool = false
}
