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

extension BindingParser where Downcast: ToolbarBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Toolbar.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asToolbarBinding() }) }
		
	//	0. Static styles are applied at construction and are subsequently immutable.
	public static var itemDescriptions: BindingParser<Constant<[ToolbarItemDescription]>, Toolbar.Binding, Downcast> { return .init(extract: { if case .itemDescriptions(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsExtensionItems: BindingParser<Dynamic<Bool>, Toolbar.Binding, Downcast> { return .init(extract: { if case .allowsExtensionItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var allowsUserCustomization: BindingParser<Dynamic<Bool>, Toolbar.Binding, Downcast> { return .init(extract: { if case .allowsUserCustomization(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var autosavesConfiguration: BindingParser<Dynamic<Bool>, Toolbar.Binding, Downcast> { return .init(extract: { if case .autosavesConfiguration(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var displayMode: BindingParser<Dynamic<NSToolbar.DisplayMode>, Toolbar.Binding, Downcast> { return .init(extract: { if case .displayMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var isVisible: BindingParser<Dynamic<Bool>, Toolbar.Binding, Downcast> { return .init(extract: { if case .isVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var selectedItemIdentifier: BindingParser<Dynamic<NSToolbarItem.Identifier>, Toolbar.Binding, Downcast> { return .init(extract: { if case .selectedItemIdentifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var showsBaselineSeparator: BindingParser<Dynamic<Bool>, Toolbar.Binding, Downcast> { return .init(extract: { if case .showsBaselineSeparator(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var sizeMode: BindingParser<Dynamic<NSToolbar.SizeMode>, Toolbar.Binding, Downcast> { return .init(extract: { if case .sizeMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var runCustomizationPalette: BindingParser<Signal<Void>, Toolbar.Binding, Downcast> { return .init(extract: { if case .runCustomizationPalette(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didRemoveItem: BindingParser<SignalInput<Void>, Toolbar.Binding, Downcast> { return .init(extract: { if case .didRemoveItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
	public static var willAddItem: BindingParser<SignalInput<Void>, Toolbar.Binding, Downcast> { return .init(extract: { if case .willAddItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarBinding() }) }
}

#endif
