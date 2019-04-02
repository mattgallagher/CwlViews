//
//  CwlPreferredFonts.swift
//  CwlUtils
//
//  Created by Matt Gallagher on 11/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)
	import UIKit
	
	@available(iOSApplicationExtension 8.2, *)
	public extension UIFont {
		static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight = .regular, slant: Float = 0) -> UIFont {
			let base = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
			let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: weight, .slant: slant]
			let modified = base.addingAttributes([.traits: traits])
			return UIFont(descriptor: modified, size: 0)
		}
	}

	public func preferredFontSize(forTextStyle style: UIFont.TextStyle) -> CGFloat {
		return UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize
	}
#endif

#if os(macOS)
	import AppKit

	@available(OSXApplicationExtension 10.11, *)
	public extension NSFont {
		enum TextStyle {
			case controlContent
			case label
			case menu
			case menuBar
			case message
			case monospacedDigit
			case palette
			case system
			case titleBar
			case toolTips
		}
		enum TextSize {
			case controlMini
			case controlRegular
			case controlSmall
			case label
			case points(CGFloat)
			case system
			case title1
			case title2
		}

		static func preferredFont(forTextStyle style: TextStyle, size: TextSize = .system, weight: NSFont.Weight = .regular, slant: CGFloat = 0) -> NSFont {
			let pointSize: CGFloat
			switch size {
			case .controlMini: pointSize = NSFont.systemFontSize(for: .mini)
			case .controlRegular: pointSize = NSFont.systemFontSize(for: .regular)
			case .controlSmall: pointSize = NSFont.systemFontSize(for: .small)
			case .label: pointSize = NSFont.labelFontSize
			case .points(let other): pointSize = other
			case .system: pointSize = NSFont.systemFontSize
			case .title1: pointSize = NSFont.systemFontSize + 5
			case .title2: pointSize = NSFont.systemFontSize + 2
			}
			
			let base: NSFont
			switch style {
			case .controlContent: base = NSFont.controlContentFont(ofSize: pointSize)
			case .label: base = NSFont.labelFont(ofSize: pointSize)
			case .menu: base = NSFont.menuFont(ofSize: pointSize)
			case .menuBar:  base = NSFont.menuBarFont(ofSize: pointSize)
			case .message:  base = NSFont.messageFont(ofSize: pointSize)
			case .monospacedDigit:  base = NSFont.monospacedDigitSystemFont(ofSize: pointSize, weight: weight)
			case .palette:  base = NSFont.paletteFont(ofSize: pointSize)
			case .system:  base = NSFont.systemFont(ofSize: pointSize)
			case .titleBar:  base = NSFont.titleBarFont(ofSize: pointSize)
			case .toolTips:  base = NSFont.toolTipsFont(ofSize: pointSize)
			}

			let traits: [NSFontDescriptor.TraitKey: Any] = [.weight: weight, .slant: slant]
			let modified = base.fontDescriptor.addingAttributes([.traits: traits])
			
			return NSFont(descriptor: modified, size: 0) ?? base
		}
	}
#endif
