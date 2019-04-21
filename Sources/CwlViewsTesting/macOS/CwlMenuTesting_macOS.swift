//
//  CwlMenu_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/30/16.
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

extension BindingParser where Binding == Menu.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var systemName: BindingParser<Constant<SystemMenu>, Binding> { return BindingParser<Constant<SystemMenu>, Binding>(parse: { binding -> Optional<Constant<SystemMenu>> in if case .systemName(let x) = binding { return x } else { return nil } }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsContextMenuPlugIns: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsContextMenuPlugIns(let x) = binding { return x } else { return nil } }) }
	public static var autoenablesItems: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .autoenablesItems(let x) = binding { return x } else { return nil } }) }
	public static var font: BindingParser<Dynamic<NSFont>, Binding> { return BindingParser<Dynamic<NSFont>, Binding>(parse: { binding -> Optional<Dynamic<NSFont>> in if case .font(let x) = binding { return x } else { return nil } }) }
	public static var items: BindingParser<Dynamic<[MenuItemConvertible]>, Binding> { return BindingParser<Dynamic<[MenuItemConvertible]>, Binding>(parse: { binding -> Optional<Dynamic<[MenuItemConvertible]>> in if case .items(let x) = binding { return x } else { return nil } }) }
	public static var minimumWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .minimumWidth(let x) = binding { return x } else { return nil } }) }
	public static var showsStateColumn: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsStateColumn(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .title(let x) = binding { return x } else { return nil } }) }
	public static var userInterfaceLayoutDirection: BindingParser<Dynamic<NSUserInterfaceLayoutDirection>, Binding> { return BindingParser<Dynamic<NSUserInterfaceLayoutDirection>, Binding>(parse: { binding -> Optional<Dynamic<NSUserInterfaceLayoutDirection>> in if case .userInterfaceLayoutDirection(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var cancelTracking: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .cancelTracking(let x) = binding { return x } else { return nil } }) }
	public static var cancelTrackingWithoutAnimation: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .cancelTrackingWithoutAnimation(let x) = binding { return x } else { return nil } }) }
	public static var performAction: BindingParser<Signal<Int>, Binding> { return BindingParser<Signal<Int>, Binding>(parse: { binding -> Optional<Signal<Int>> in if case .performAction(let x) = binding { return x } else { return nil } }) }
	public static var popUp: BindingParser<Signal<(item: Int, at: NSPoint, in: NSView?)>, Binding> { return BindingParser<Signal<(item: Int, at: NSPoint, in: NSView?)>, Binding>(parse: { binding -> Optional<Signal<(item: Int, at: NSPoint, in: NSView?)>> in if case .popUp(let x) = binding { return x } else { return nil } }) }
	public static var popUpContextMenu: BindingParser<Signal<(with: NSEvent, for: NSView)>, Binding> { return BindingParser<Signal<(with: NSEvent, for: NSView)>, Binding>(parse: { binding -> Optional<Signal<(with: NSEvent, for: NSView)>> in if case .popUpContextMenu(let x) = binding { return x } else { return nil } }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBeginTracking: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didBeginTracking(let x) = binding { return x } else { return nil } }) }
	public static var didEndTracking: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didEndTracking(let x) = binding { return x } else { return nil } }) }
	public static var didSendAction: BindingParser<SignalInput<Int>, Binding> { return BindingParser<SignalInput<Int>, Binding>(parse: { binding -> Optional<SignalInput<Int>> in if case .didSendAction(let x) = binding { return x } else { return nil } }) }
	public static var willSendAction: BindingParser<SignalInput<Int>, Binding> { return BindingParser<SignalInput<Int>, Binding>(parse: { binding -> Optional<SignalInput<Int>> in if case .willSendAction(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var confinementRect: BindingParser<(_ menu: NSMenu, _ screen: NSScreen?) -> NSRect, Binding> { return BindingParser<(_ menu: NSMenu, _ screen: NSScreen?) -> NSRect, Binding>(parse: { binding -> Optional<(_ menu: NSMenu, _ screen: NSScreen?) -> NSRect> in if case .confinementRect(let x) = binding { return x } else { return nil } }) }
	public static var didClose: BindingParser<(_ menu: NSMenu) -> Void, Binding> { return BindingParser<(_ menu: NSMenu) -> Void, Binding>(parse: { binding -> Optional<(_ menu: NSMenu) -> Void> in if case .didClose(let x) = binding { return x } else { return nil } }) }
	public static var willHighlight: BindingParser<(_ menu: NSMenu, _ item: NSMenuItem?, _ index: Int?) -> Void, Binding> { return BindingParser<(_ menu: NSMenu, _ item: NSMenuItem?, _ index: Int?) -> Void, Binding>(parse: { binding -> Optional<(_ menu: NSMenu, _ item: NSMenuItem?, _ index: Int?) -> Void> in if case .willHighlight(let x) = binding { return x } else { return nil } }) }
	public static var willOpen: BindingParser<(_ menu: NSMenu) -> Void, Binding> { return BindingParser<(_ menu: NSMenu) -> Void, Binding>(parse: { binding -> Optional<(_ menu: NSMenu) -> Void> in if case .willOpen(let x) = binding { return x } else { return nil } }) }
}

#endif
