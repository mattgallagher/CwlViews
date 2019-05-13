//
//  CwlTabView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Downcast: TabViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTabViewBinding() }) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsTruncatedLabels: BindingParser<Dynamic<Bool>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .allowsTruncatedLabels(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var borderType: BindingParser<Dynamic<NSTabView.TabViewBorderType>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .borderType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var controlSize: BindingParser<Dynamic<NSControl.ControlSize>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .controlSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .drawsBackground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var font: BindingParser<Dynamic<NSFont>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .font(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var position: BindingParser<Dynamic<NSTabView.TabPosition>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .position(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var tabs: BindingParser<Dynamic<ArrayMutation<Downcast.IdentifierType>>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .tabs(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var type: BindingParser<Dynamic<NSTabView.TabType>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .type(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var selectedItem: BindingParser<Dynamic<Downcast.IdentifierType>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectedItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var selectFirstItem: BindingParser<Signal<Void>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectFirstItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var selectLastItem: BindingParser<Signal<Void>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectLastItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var selectNextItem: BindingParser<Signal<Void>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectNextItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var selectPreviousItem: BindingParser<Signal<Void>, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .selectPreviousItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didChangeNumberOfItems: BindingParser<(NSTabView) -> Void, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .didChangeNumberOfItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var didSelect: BindingParser<(NSTabView, NSTabViewItem?, Downcast.IdentifierType?) -> Void, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .didSelect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var shouldSelect: BindingParser<(NSTabView, NSTabViewItem?, Downcast.IdentifierType?) -> Bool, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .shouldSelect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var tabConstructor: BindingParser<(Downcast.IdentifierType) -> TabViewItemConvertible, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .tabConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
	public static var willSelect: BindingParser<(NSTabView, NSTabViewItem?, Downcast.IdentifierType?) -> Void, TabView<Downcast.IdentifierType>.Binding, Downcast> { return .init(extract: { if case .willSelect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewBinding() }) }
}

#endif
