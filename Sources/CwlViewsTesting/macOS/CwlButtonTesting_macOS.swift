//
//  CwlButton_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/11/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

#if os(macOS)

extension BindingParser where Downcast: ButtonBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Button.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asButtonBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsMixedState: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .allowsMixedState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var alternateImage: BindingParser<Dynamic<NSImage?>, Button.Binding, Downcast> { return .init(extract: { if case .alternateImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var alternateTitle: BindingParser<Dynamic<String>, Button.Binding, Downcast> { return .init(extract: { if case .alternateTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var attributedAlternateTitle: BindingParser<Dynamic<NSAttributedString>, Button.Binding, Downcast> { return .init(extract: { if case .attributedAlternateTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var attributedTitle: BindingParser<Dynamic<NSAttributedString>, Button.Binding, Downcast> { return .init(extract: { if case .attributedTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var bezelColor: BindingParser<Dynamic<NSColor?>, Button.Binding, Downcast> { return .init(extract: { if case .bezelColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var bezelStyle: BindingParser<Dynamic<NSButton.BezelStyle>, Button.Binding, Downcast> { return .init(extract: { if case .bezelStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var buttonType: BindingParser<Dynamic<NSButton.ButtonType>, Button.Binding, Downcast> { return .init(extract: { if case .buttonType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var highlight: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .highlight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var image: BindingParser<Dynamic<NSImage?>, Button.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var imageHugsTitle: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .imageHugsTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var imagePosition: BindingParser<Dynamic<NSControl.ImagePosition>, Button.Binding, Downcast> { return .init(extract: { if case .imagePosition(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var imageScaling: BindingParser<Dynamic<NSImageScaling>, Button.Binding, Downcast> { return .init(extract: { if case .imageScaling(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var isBordered: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .isBordered(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var isSpringLoaded: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .isSpringLoaded(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var isTransparent: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .isTransparent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var keyEquivalent: BindingParser<Dynamic<String>, Button.Binding, Downcast> { return .init(extract: { if case .keyEquivalent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var keyEquivalentModifierMask: BindingParser<Dynamic<NSEvent.ModifierFlags>, Button.Binding, Downcast> { return .init(extract: { if case .keyEquivalentModifierMask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var maxAcceleratorLevel: BindingParser<Dynamic<Int>, Button.Binding, Downcast> { return .init(extract: { if case .maxAcceleratorLevel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var performKeyEquivalent: BindingParser<Dynamic<NSEvent>, Button.Binding, Downcast> { return .init(extract: { if case .performKeyEquivalent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var periodicDelay: BindingParser<Dynamic<(delay: Float, interval: Float)>, Button.Binding, Downcast> { return .init(extract: { if case .periodicDelay(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var showsBorderOnlyWhileMouseInside: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .showsBorderOnlyWhileMouseInside(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var sound: BindingParser<Dynamic<NSSound?>, Button.Binding, Downcast> { return .init(extract: { if case .sound(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var state: BindingParser<Dynamic<NSControl.StateValue>, Button.Binding, Downcast> { return .init(extract: { if case .state(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var title: BindingParser<Dynamic<String>, Button.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }

	@available(macOS 10.14, *) public static var contentTintColor: BindingParser<Dynamic<NSColor?>, Button.Binding, Downcast> { return .init(extract: { if case .contentTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }

	//	2. Signal bindings are performed on the object after construction.
	public static var setNextState: BindingParser<Signal<Void>, Button.Binding, Downcast> { return .init(extract: { if case .setNextState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }

	//	3. Action bindings are triggered by the object after construction.

	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
