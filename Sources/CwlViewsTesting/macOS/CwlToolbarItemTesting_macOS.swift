//
//  CwlToolbarItem_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 11/3/16.
//  Copyright © 2016 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Downcast: ToolbarItemBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asToolbarItemBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var image: BindingParser<Dynamic<NSImage?>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var isEnabled: BindingParser<Dynamic<Bool>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .isEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var label: BindingParser<Dynamic<String>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .label(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var maxSize: BindingParser<Dynamic<NSSize>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .maxSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var menuFormRepresentation: BindingParser<Dynamic<MenuItemConvertible>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .menuFormRepresentation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var minSize: BindingParser<Dynamic<NSSize>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .minSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var paletteLabel: BindingParser<Dynamic<String>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .paletteLabel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var tag: BindingParser<Dynamic<Int>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .tag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var toolTip: BindingParser<Dynamic<String?>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .toolTip(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var view: BindingParser<Dynamic<ViewConvertible?>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .view(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	public static var visibilityPriority: BindingParser<Dynamic<NSToolbarItem.VisibilityPriority>, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .visibilityPriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .action(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var validate: BindingParser<(NSToolbarItem) -> Bool, ToolbarItem.Binding, Downcast> { return .init(extract: { if case .validate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asToolbarItemBinding() }) }
}

#endif
