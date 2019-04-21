//
//  CwlTabView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Binding: TabViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabView<Binding.IdentifierType>.Binding> { return BindingParser<$2, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsTruncatedLabels: BindingParser<Dynamic<Bool>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<Bool>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsTruncatedLabels(let x) = binding { return x } else { return nil } }) }
	public static var borderType: BindingParser<Dynamic<NSTabView.TabViewBorderType>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<NSTabView.TabViewBorderType>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<NSTabView.TabViewBorderType>> in if case .borderType(let x) = binding { return x } else { return nil } }) }
	public static var controlSize: BindingParser<Dynamic<NSControl.ControlSize>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<NSControl.ControlSize>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<NSControl.ControlSize>> in if case .controlSize(let x) = binding { return x } else { return nil } }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<Bool>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .drawsBackground(let x) = binding { return x } else { return nil } }) }
	public static var font: BindingParser<Dynamic<NSFont>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<NSFont>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<NSFont>> in if case .font(let x) = binding { return x } else { return nil } }) }
	public static var position: BindingParser<Dynamic<NSTabView.TabPosition>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<NSTabView.TabPosition>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<NSTabView.TabPosition>> in if case .position(let x) = binding { return x } else { return nil } }) }
	public static var tabs: BindingParser<Dynamic<ArrayMutation<Binding.IdentifierType>>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<ArrayMutation<Binding.IdentifierType>>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<ArrayMutation<Binding.IdentifierType>>> in if case .tabs(let x) = binding { return x } else { return nil } }) }
	public static var type: BindingParser<Dynamic<NSTabView.TabType>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<NSTabView.TabType>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<NSTabView.TabType>> in if case .type(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var selectedItem: BindingParser<Dynamic<Binding.IdentifierType>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Dynamic<Binding.IdentifierType>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Dynamic<Binding.IdentifierType>> in if case .selectedItem(let x) = binding { return x } else { return nil } }) }
	public static var selectFirstItem: BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Signal<Void>> in if case .selectFirstItem(let x) = binding { return x } else { return nil } }) }
	public static var selectLastItem: BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Signal<Void>> in if case .selectLastItem(let x) = binding { return x } else { return nil } }) }
	public static var selectNextItem: BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Signal<Void>> in if case .selectNextItem(let x) = binding { return x } else { return nil } }) }
	public static var selectPreviousItem: BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding> { return BindingParser<Signal<Void>, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<Signal<Void>> in if case .selectPreviousItem(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didChangeNumberOfItems: BindingParser<(NSTabView) -> Void, TabView<Binding.IdentifierType>.Binding> { return BindingParser<(NSTabView) -> Void, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<(NSTabView) -> Void> in if case .didChangeNumberOfItems(let x) = binding { return x } else { return nil } }) }
	public static var didSelect: BindingParser<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void, TabView<Binding.IdentifierType>.Binding> { return BindingParser<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void> in if case .didSelect(let x) = binding { return x } else { return nil } }) }
	public static var shouldSelect: BindingParser<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Bool, TabView<Binding.IdentifierType>.Binding> { return BindingParser<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Bool, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Bool> in if case .shouldSelect(let x) = binding { return x } else { return nil } }) }
	public static var tabConstructor: BindingParser<(Binding.IdentifierType) -> TabViewItemConvertible, TabView<Binding.IdentifierType>.Binding> { return BindingParser<(Binding.IdentifierType) -> TabViewItemConvertible, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<(Binding.IdentifierType) -> TabViewItemConvertible> in if case .tabConstructor(let x) = binding { return x } else { return nil } }) }
	public static var willSelect: BindingParser<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void, TabView<Binding.IdentifierType>.Binding> { return BindingParser<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void, TabView<Binding.IdentifierType>.Binding>(parse: { binding -> Optional<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void> in if case .willSelect(let x) = binding { return x } else { return nil } }) }
}

#endif
