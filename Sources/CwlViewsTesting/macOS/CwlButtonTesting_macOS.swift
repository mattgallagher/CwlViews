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

extension BindingParser where Binding == Button.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsMixedState: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsMixedState(let x) = binding { return x } else { return nil } }) }
	public static var alternateImage: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .alternateImage(let x) = binding { return x } else { return nil } }) }
	public static var alternateTitle: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .alternateTitle(let x) = binding { return x } else { return nil } }) }
	public static var attributedAlternateTitle: BindingParser<Dynamic<NSAttributedString>, Binding> { return BindingParser<Dynamic<NSAttributedString>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString>> in if case .attributedAlternateTitle(let x) = binding { return x } else { return nil } }) }
	public static var attributedTitle: BindingParser<Dynamic<NSAttributedString>, Binding> { return BindingParser<Dynamic<NSAttributedString>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString>> in if case .attributedTitle(let x) = binding { return x } else { return nil } }) }
	public static var bezelColor: BindingParser<Dynamic<NSColor?>, Binding> { return BindingParser<Dynamic<NSColor?>, Binding>(parse: { binding -> Optional<Dynamic<NSColor?>> in if case .bezelColor(let x) = binding { return x } else { return nil } }) }
	public static var bezelStyle: BindingParser<Dynamic<NSButton.BezelStyle>, Binding> { return BindingParser<Dynamic<NSButton.BezelStyle>, Binding>(parse: { binding -> Optional<Dynamic<NSButton.BezelStyle>> in if case .bezelStyle(let x) = binding { return x } else { return nil } }) }
	public static var buttonType: BindingParser<Dynamic<NSButton.ButtonType>, Binding> { return BindingParser<Dynamic<NSButton.ButtonType>, Binding>(parse: { binding -> Optional<Dynamic<NSButton.ButtonType>> in if case .buttonType(let x) = binding { return x } else { return nil } }) }
	public static var highlight: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .highlight(let x) = binding { return x } else { return nil } }) }
	public static var image: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .image(let x) = binding { return x } else { return nil } }) }
	public static var imageHugsTitle: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .imageHugsTitle(let x) = binding { return x } else { return nil } }) }
	public static var imagePosition: BindingParser<Dynamic<NSControl.ImagePosition>, Binding> { return BindingParser<Dynamic<NSControl.ImagePosition>, Binding>(parse: { binding -> Optional<Dynamic<NSControl.ImagePosition>> in if case .imagePosition(let x) = binding { return x } else { return nil } }) }
	public static var imageScaling: BindingParser<Dynamic<NSImageScaling>, Binding> { return BindingParser<Dynamic<NSImageScaling>, Binding>(parse: { binding -> Optional<Dynamic<NSImageScaling>> in if case .imageScaling(let x) = binding { return x } else { return nil } }) }
	public static var isBordered: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isBordered(let x) = binding { return x } else { return nil } }) }
	public static var isSpringLoaded: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isSpringLoaded(let x) = binding { return x } else { return nil } }) }
	public static var isTransparent: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isTransparent(let x) = binding { return x } else { return nil } }) }
	public static var keyEquivalent: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .keyEquivalent(let x) = binding { return x } else { return nil } }) }
	public static var keyEquivalentModifierMask: BindingParser<Dynamic<NSEvent.ModifierFlags>, Binding> { return BindingParser<Dynamic<NSEvent.ModifierFlags>, Binding>(parse: { binding -> Optional<Dynamic<NSEvent.ModifierFlags>> in if case .keyEquivalentModifierMask(let x) = binding { return x } else { return nil } }) }
	public static var maxAcceleratorLevel: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .maxAcceleratorLevel(let x) = binding { return x } else { return nil } }) }
	public static var performKeyEquivalent: BindingParser<Dynamic<NSEvent>, Binding> { return BindingParser<Dynamic<NSEvent>, Binding>(parse: { binding -> Optional<Dynamic<NSEvent>> in if case .performKeyEquivalent(let x) = binding { return x } else { return nil } }) }
	public static var periodicDelay: BindingParser<Dynamic<(delay: Float, interval: Float)>, Binding> { return BindingParser<Dynamic<(delay: Float, interval: Float)>, Binding>(parse: { binding -> Optional<Dynamic<(delay: Float, interval: Float)>> in if case .periodicDelay(let x) = binding { return x } else { return nil } }) }
	public static var showsBorderOnlyWhileMouseInside: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsBorderOnlyWhileMouseInside(let x) = binding { return x } else { return nil } }) }
	public static var sound: BindingParser<Dynamic<NSSound?>, Binding> { return BindingParser<Dynamic<NSSound?>, Binding>(parse: { binding -> Optional<Dynamic<NSSound?>> in if case .sound(let x) = binding { return x } else { return nil } }) }
	public static var state: BindingParser<Dynamic<NSControl.StateValue>, Binding> { return BindingParser<Dynamic<NSControl.StateValue>, Binding>(parse: { binding -> Optional<Dynamic<NSControl.StateValue>> in if case .state(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .title(let x) = binding { return x } else { return nil } }) }

	@available(macOS 10.14, *) public static var contentTintColor: BindingParser<Dynamic<NSColor?>, Binding> { return BindingParser<Dynamic<NSColor?>, Binding>(parse: { binding -> Optional<Dynamic<NSColor?>> in if case .contentTintColor(let x) = binding { return x } else { return nil } }) }

	//	2. Signal bindings are performed on the object after construction.
	public static var setNextState: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .setNextState(let x) = binding { return x } else { return nil } }) }

	//	3. Action bindings are triggered by the object after construction.

	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
