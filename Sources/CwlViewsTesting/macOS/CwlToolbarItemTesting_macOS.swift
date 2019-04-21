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

extension BindingParser where Binding == ToolbarItem.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var image: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .image(let x) = binding { return x } else { return nil } }) }
	public static var isEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEnabled(let x) = binding { return x } else { return nil } }) }
	public static var label: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .label(let x) = binding { return x } else { return nil } }) }
	public static var maxSize: BindingParser<Dynamic<NSSize>, Binding> { return BindingParser<Dynamic<NSSize>, Binding>(parse: { binding -> Optional<Dynamic<NSSize>> in if case .maxSize(let x) = binding { return x } else { return nil } }) }
	public static var menuFormRepresentation: BindingParser<Dynamic<MenuItemConvertible>, Binding> { return BindingParser<Dynamic<MenuItemConvertible>, Binding>(parse: { binding -> Optional<Dynamic<MenuItemConvertible>> in if case .menuFormRepresentation(let x) = binding { return x } else { return nil } }) }
	public static var minSize: BindingParser<Dynamic<NSSize>, Binding> { return BindingParser<Dynamic<NSSize>, Binding>(parse: { binding -> Optional<Dynamic<NSSize>> in if case .minSize(let x) = binding { return x } else { return nil } }) }
	public static var paletteLabel: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .paletteLabel(let x) = binding { return x } else { return nil } }) }
	public static var tag: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .tag(let x) = binding { return x } else { return nil } }) }
	public static var toolTip: BindingParser<Dynamic<String?>, Binding> { return BindingParser<Dynamic<String?>, Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .toolTip(let x) = binding { return x } else { return nil } }) }
	public static var view: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .view(let x) = binding { return x } else { return nil } }) }
	public static var visibilityPriority: BindingParser<Dynamic<NSToolbarItem.VisibilityPriority>, Binding> { return BindingParser<Dynamic<NSToolbarItem.VisibilityPriority>, Binding>(parse: { binding -> Optional<Dynamic<NSToolbarItem.VisibilityPriority>> in if case .visibilityPriority(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, Binding> { return BindingParser<TargetAction, Binding>(parse: { binding -> Optional<TargetAction> in if case .action(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var validate: BindingParser<(NSToolbarItem) -> Bool, Binding> { return BindingParser<(NSToolbarItem) -> Bool, Binding>(parse: { binding -> Optional<(NSToolbarItem) -> Bool> in if case .validate(let x) = binding { return x } else { return nil } }) }
}

#endif
