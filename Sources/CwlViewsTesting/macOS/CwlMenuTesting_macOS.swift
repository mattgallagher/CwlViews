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

extension BindingParser where Downcast: MenuBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Menu.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asMenuBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var systemName: BindingParser<Constant<SystemMenu>, Menu.Binding, Downcast> { return .init(extract: { if case .systemName(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsContextMenuPlugIns: BindingParser<Dynamic<Bool>, Menu.Binding, Downcast> { return .init(extract: { if case .allowsContextMenuPlugIns(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var autoenablesItems: BindingParser<Dynamic<Bool>, Menu.Binding, Downcast> { return .init(extract: { if case .autoenablesItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var font: BindingParser<Dynamic<NSFont>, Menu.Binding, Downcast> { return .init(extract: { if case .font(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var items: BindingParser<Dynamic<[MenuItemConvertible]>, Menu.Binding, Downcast> { return .init(extract: { if case .items(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var minimumWidth: BindingParser<Dynamic<CGFloat>, Menu.Binding, Downcast> { return .init(extract: { if case .minimumWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var showsStateColumn: BindingParser<Dynamic<Bool>, Menu.Binding, Downcast> { return .init(extract: { if case .showsStateColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var title: BindingParser<Dynamic<String>, Menu.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var userInterfaceLayoutDirection: BindingParser<Dynamic<NSUserInterfaceLayoutDirection>, Menu.Binding, Downcast> { return .init(extract: { if case .userInterfaceLayoutDirection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var cancelTracking: BindingParser<Signal<Void>, Menu.Binding, Downcast> { return .init(extract: { if case .cancelTracking(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var cancelTrackingWithoutAnimation: BindingParser<Signal<Void>, Menu.Binding, Downcast> { return .init(extract: { if case .cancelTrackingWithoutAnimation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var performAction: BindingParser<Signal<Int>, Menu.Binding, Downcast> { return .init(extract: { if case .performAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var popUp: BindingParser<Signal<(item: Int, at: NSPoint, in: NSView?)>, Menu.Binding, Downcast> { return .init(extract: { if case .popUp(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var popUpContextMenu: BindingParser<Signal<(with: NSEvent, for: NSView)>, Menu.Binding, Downcast> { return .init(extract: { if case .popUpContextMenu(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBeginTracking: BindingParser<SignalInput<Void>, Menu.Binding, Downcast> { return .init(extract: { if case .didBeginTracking(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var didEndTracking: BindingParser<SignalInput<Void>, Menu.Binding, Downcast> { return .init(extract: { if case .didEndTracking(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var didSendAction: BindingParser<SignalInput<Int>, Menu.Binding, Downcast> { return .init(extract: { if case .didSendAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var willSendAction: BindingParser<SignalInput<Int>, Menu.Binding, Downcast> { return .init(extract: { if case .willSendAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var confinementRect: BindingParser<(_ menu: NSMenu, _ screen: NSScreen?) -> NSRect, Menu.Binding, Downcast> { return .init(extract: { if case .confinementRect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var didClose: BindingParser<(_ menu: NSMenu) -> Void, Menu.Binding, Downcast> { return .init(extract: { if case .didClose(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var willHighlight: BindingParser<(_ menu: NSMenu, _ item: NSMenuItem?, _ index: Int?) -> Void, Menu.Binding, Downcast> { return .init(extract: { if case .willHighlight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
	public static var willOpen: BindingParser<(_ menu: NSMenu) -> Void, Menu.Binding, Downcast> { return .init(extract: { if case .willOpen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asMenuBinding() }) }
}

#endif
