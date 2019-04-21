//
//  CwlMenuItem_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 28/10/2015.
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

extension BindingParser where Binding == MenuItem.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEnabled(let x) = binding { return x } else { return nil } }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isHidden(let x) = binding { return x } else { return nil } }) }
	public static var isAlternate: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isAlternate(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .title(let x) = binding { return x } else { return nil } }) }
	public static var attributedTitle: BindingParser<Dynamic<NSAttributedString?>, Binding> { return BindingParser<Dynamic<NSAttributedString?>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString?>> in if case .attributedTitle(let x) = binding { return x } else { return nil } }) }
	public static var tag: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .tag(let x) = binding { return x } else { return nil } }) }
	public static var representedObject: BindingParser<Dynamic<AnyObject?>, Binding> { return BindingParser<Dynamic<AnyObject?>, Binding>(parse: { binding -> Optional<Dynamic<AnyObject?>> in if case .representedObject(let x) = binding { return x } else { return nil } }) }
	public static var state: BindingParser<Dynamic<NSControl.StateValue>, Binding> { return BindingParser<Dynamic<NSControl.StateValue>, Binding>(parse: { binding -> Optional<Dynamic<NSControl.StateValue>> in if case .state(let x) = binding { return x } else { return nil } }) }
	public static var indentationLevel: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .indentationLevel(let x) = binding { return x } else { return nil } }) }
	public static var image: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .image(let x) = binding { return x } else { return nil } }) }
	public static var onStateImage: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .onStateImage(let x) = binding { return x } else { return nil } }) }
	public static var offStateImage: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .offStateImage(let x) = binding { return x } else { return nil } }) }
	public static var mixedStateImage: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .mixedStateImage(let x) = binding { return x } else { return nil } }) }
	public static var submenu: BindingParser<Dynamic<MenuConvertible?>, Binding> { return BindingParser<Dynamic<MenuConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<MenuConvertible?>> in if case .submenu(let x) = binding { return x } else { return nil } }) }
	public static var keyEquivalent: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .keyEquivalent(let x) = binding { return x } else { return nil } }) }
	public static var keyEquivalentModifierMask: BindingParser<Dynamic<NSEvent.ModifierFlags>, Binding> { return BindingParser<Dynamic<NSEvent.ModifierFlags>, Binding>(parse: { binding -> Optional<Dynamic<NSEvent.ModifierFlags>> in if case .keyEquivalentModifierMask(let x) = binding { return x } else { return nil } }) }
	public static var toolTip: BindingParser<Dynamic<String?>, Binding> { return BindingParser<Dynamic<String?>, Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .toolTip(let x) = binding { return x } else { return nil } }) }
	public static var view: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .view(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, Binding> { return BindingParser<TargetAction, Binding>(parse: { binding -> Optional<TargetAction> in if case .action(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
