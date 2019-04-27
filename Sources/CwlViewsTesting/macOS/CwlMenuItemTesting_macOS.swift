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

extension BindingParser where Downcast: MenuItemBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, MenuItem.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asMenuItemBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isEnabled: BindingParser<Dynamic<Bool>, MenuItem.Binding, Downcast> { return .init(extract: { if case .isEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, MenuItem.Binding, Downcast> { return .init(extract: { if case .isHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var isAlternate: BindingParser<Dynamic<Bool>, MenuItem.Binding, Downcast> { return .init(extract: { if case .isAlternate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var title: BindingParser<Dynamic<String>, MenuItem.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var attributedTitle: BindingParser<Dynamic<NSAttributedString?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .attributedTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var tag: BindingParser<Dynamic<Int>, MenuItem.Binding, Downcast> { return .init(extract: { if case .tag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var representedObject: BindingParser<Dynamic<AnyObject?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .representedObject(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var state: BindingParser<Dynamic<NSControl.StateValue>, MenuItem.Binding, Downcast> { return .init(extract: { if case .state(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var indentationLevel: BindingParser<Dynamic<Int>, MenuItem.Binding, Downcast> { return .init(extract: { if case .indentationLevel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var image: BindingParser<Dynamic<NSImage?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var onStateImage: BindingParser<Dynamic<NSImage?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .onStateImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var offStateImage: BindingParser<Dynamic<NSImage?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .offStateImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var mixedStateImage: BindingParser<Dynamic<NSImage?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .mixedStateImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var submenu: BindingParser<Dynamic<MenuConvertible?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .submenu(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var keyEquivalent: BindingParser<Dynamic<String>, MenuItem.Binding, Downcast> { return .init(extract: { if case .keyEquivalent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var keyEquivalentModifierMask: BindingParser<Dynamic<NSEvent.ModifierFlags>, MenuItem.Binding, Downcast> { return .init(extract: { if case .keyEquivalentModifierMask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var toolTip: BindingParser<Dynamic<String?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .toolTip(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	public static var view: BindingParser<Dynamic<ViewConvertible?>, MenuItem.Binding, Downcast> { return .init(extract: { if case .view(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, MenuItem.Binding, Downcast> { return .init(extract: { if case .action(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuItemBinding() }) }
}

#endif
