//
//  CwlToolbar_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 23/10/2015.
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

extension BindingParser where Binding == Toolbar.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static styles are applied at construction and are subsequently immutable.
	public static var itemDescriptions: BindingParser<Constant<[ToolbarItemDescription]>, Binding> { return BindingParser<Constant<[ToolbarItemDescription]>, Binding>(parse: { binding -> Optional<Constant<[ToolbarItemDescription]>> in if case .itemDescriptions(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsExtensionItems: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsExtensionItems(let x) = binding { return x } else { return nil } }) }
	public static var allowsUserCustomization: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsUserCustomization(let x) = binding { return x } else { return nil } }) }
	public static var autosavesConfiguration: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .autosavesConfiguration(let x) = binding { return x } else { return nil } }) }
	public static var displayMode: BindingParser<Dynamic<NSToolbar.DisplayMode>, Binding> { return BindingParser<Dynamic<NSToolbar.DisplayMode>, Binding>(parse: { binding -> Optional<Dynamic<NSToolbar.DisplayMode>> in if case .displayMode(let x) = binding { return x } else { return nil } }) }
	public static var isVisible: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isVisible(let x) = binding { return x } else { return nil } }) }
	public static var selectedItemIdentifier: BindingParser<Dynamic<NSToolbarItem.Identifier>, Binding> { return BindingParser<Dynamic<NSToolbarItem.Identifier>, Binding>(parse: { binding -> Optional<Dynamic<NSToolbarItem.Identifier>> in if case .selectedItemIdentifier(let x) = binding { return x } else { return nil } }) }
	public static var showsBaselineSeparator: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsBaselineSeparator(let x) = binding { return x } else { return nil } }) }
	public static var sizeMode: BindingParser<Dynamic<NSToolbar.SizeMode>, Binding> { return BindingParser<Dynamic<NSToolbar.SizeMode>, Binding>(parse: { binding -> Optional<Dynamic<NSToolbar.SizeMode>> in if case .sizeMode(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var runCustomizationPalette: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .runCustomizationPalette(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didRemoveItem: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didRemoveItem(let x) = binding { return x } else { return nil } }) }
	public static var willAddItem: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .willAddItem(let x) = binding { return x } else { return nil } }) }
}

#endif
