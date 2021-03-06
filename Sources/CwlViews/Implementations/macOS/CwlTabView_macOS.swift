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

// MARK: - Binder Part 1: Binder
public class TabView<Identifier: Equatable>: Binder, TabViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TabView {
	enum Binding: TabViewBinding {
		public typealias IdentifierType = Identifier
		
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsTruncatedLabels(Dynamic<Bool>)
		case borderType(Dynamic<NSTabView.TabViewBorderType>)
		case controlSize(Dynamic<NSControl.ControlSize>)
		case drawsBackground(Dynamic<Bool>)
		case font(Dynamic<NSFont>)
		case position(Dynamic<NSTabView.TabPosition>)
		case tabs(Dynamic<ArrayMutation<Identifier>>)
		case type(Dynamic<NSTabView.TabType>)

		// 2. Signal bindings are performed on the object after construction.
		case selectedItem(Dynamic<Identifier>)
		case selectFirstItem(Signal<Void>)
		case selectLastItem(Signal<Void>)
		case selectNextItem(Signal<Void>)
		case selectPreviousItem(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didChangeNumberOfItems((NSTabView) -> Void)
		case didSelect((NSTabView, NSTabViewItem?, Identifier?) -> Void)
		case shouldSelect((NSTabView, NSTabViewItem?, Identifier?) -> Bool)
		case tabConstructor((Identifier) -> TabViewItemConvertible)
		case willSelect((NSTabView, NSTabViewItem?, Identifier?) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TabView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TabView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSTabView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var tabConstructor: ((Identifier) -> TabViewItemConvertible)? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TabView.Preparer {
	func constructStorage(instance: Instance) -> Storage {
		return Storage(tabConstructor: tabConstructor)
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .didChangeNumberOfItems(let x): delegate().addMultiHandler1(x, #selector(NSTabViewDelegate.tabViewDidChangeNumberOfTabViewItems(_:)))
		case .didSelect(let x): delegate().addMultiHandler3(x, #selector(NSTabViewDelegate.tabView(_:didSelect:)))
		case .shouldSelect(let x): delegate().addSingleHandler3(x, #selector(NSTabViewDelegate.tabView(_:shouldSelect:)))
		case .tabConstructor(let x): tabConstructor = x
		case .willSelect(let x): delegate().addMultiHandler3(x, #selector(NSTabViewDelegate.tabView(_:willSelect:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		// 0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowsTruncatedLabels(let x): return x.apply(instance) { i, v in i.allowsTruncatedLabels = v }
		case .borderType(let x): return x.apply(instance) { i, v in i.tabViewBorderType = v }
		case .controlSize(let x): return x.apply(instance) { i, v in i.controlSize = v }
		case .drawsBackground(let x): return x.apply(instance) { i, v in i.drawsBackground = v }
		case .font(let x): return x.apply(instance) { i, v in i.font = v }
		case .position(let x): return x.apply(instance) { i, v in i.tabPosition = v }
		case .selectedItem(let x):
			return x.apply(instance) { i, v in
				for tabItem in i.tabViewItems {
					if let identifier = tabItem.identifier as? Identifier, identifier == v {
						i.selectTabViewItem(tabItem)
						if let window = i.window, let responder = tabItem.initialFirstResponder {
							window.makeFirstResponder(responder)
						}
						break
					}
				}
			}
		case .tabs(let x):
			return x.apply(instance, storage) { i, s, v in
				let constructor = s.tabConstructor ?? { _ in NSTabViewItem(identifier: nil) }
				v.insertionsAndRemovals(
					length: i.numberOfTabViewItems,
					insert: { index, identifier in
						let item = constructor(identifier).nsTabViewItem()
						item.identifier = identifier
						i.insertTabViewItem(item, at: index)
					},
					remove: { index in i.removeTabViewItem(i.tabViewItem(at: index)) }
				)
			}
		case .type(let x): return x.apply(instance) { i, v in i.tabViewType = v }
			
		// 2. Signal bindings are performed on the object after construction.
		case .selectFirstItem(let x): return x.apply(instance) { i, v in i.selectFirstTabViewItem(nil) }
		case .selectLastItem(let x): return x.apply(instance) { i, v in i.selectLastTabViewItem(nil) }
		case .selectNextItem(let x): return x.apply(instance) { i, v in i.selectNextTabViewItem(nil) }
		case .selectPreviousItem(let x): return x.apply(instance) { i, v in i.selectPreviousTabViewItem(nil) }
			
		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .didChangeNumberOfItems: return nil
		case .didSelect: return nil
		case .shouldSelect: return nil
		case .tabConstructor: return nil
		case .willSelect: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TabView.Preparer {
	open class Storage: View.Preparer.Storage, NSTabViewDelegate {
		open var tabConstructor: ((Identifier) -> TabViewItemConvertible)?
		public init(tabConstructor: ((Identifier) -> TabViewItemConvertible)?) {
			self.tabConstructor = tabConstructor
		}
	}

	open class Delegate: DynamicDelegate, NSTabViewDelegate {
		open func tabViewDidChangeNumberOfTabViewItems(_ tabView: NSTabView) {
			multiHandler(tabView)
		}
		
		open func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
			multiHandler(tabView, tabViewItem, tabViewItem?.identifier as? Identifier)
		}
		
		open func tabView(_ tabView: NSTabView, shouldSelect tabViewItem: NSTabViewItem?) -> Bool {
			return singleHandler(tabView, tabViewItem, tabViewItem?.identifier as? Identifier)
		}
		
		open func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
			multiHandler(tabView, tabViewItem, tabViewItem?.identifier as? Identifier)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TabViewBinding {
	public typealias TabViewName<V> = BindingName<V, TabView<Binding.IdentifierType>.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> TabView<Binding.IdentifierType>.Binding) -> TabViewName<V> {
		return TabViewName<V>(source: source, downcast: Binding.tabViewBinding)
	}
}
public extension BindingName where Binding: TabViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TabViewName<$2> { return .name(TabView.Binding.$1) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsTruncatedLabels: TabViewName<Dynamic<Bool>> { return .name(TabView.Binding.allowsTruncatedLabels) }
	static var borderType: TabViewName<Dynamic<NSTabView.TabViewBorderType>> { return .name(TabView.Binding.borderType) }
	static var controlSize: TabViewName<Dynamic<NSControl.ControlSize>> { return .name(TabView.Binding.controlSize) }
	static var drawsBackground: TabViewName<Dynamic<Bool>> { return .name(TabView.Binding.drawsBackground) }
	static var font: TabViewName<Dynamic<NSFont>> { return .name(TabView.Binding.font) }
	static var position: TabViewName<Dynamic<NSTabView.TabPosition>> { return .name(TabView.Binding.position) }
	static var tabs: TabViewName<Dynamic<ArrayMutation<Binding.IdentifierType>>> { return .name(TabView.Binding.tabs) }
	static var type: TabViewName<Dynamic<NSTabView.TabType>> { return .name(TabView.Binding.type) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var selectedItem: TabViewName<Dynamic<Binding.IdentifierType>> { return .name(TabView.Binding.selectedItem) }
	static var selectFirstItem: TabViewName<Signal<Void>> { return .name(TabView.Binding.selectFirstItem) }
	static var selectLastItem: TabViewName<Signal<Void>> { return .name(TabView.Binding.selectLastItem) }
	static var selectNextItem: TabViewName<Signal<Void>> { return .name(TabView.Binding.selectNextItem) }
	static var selectPreviousItem: TabViewName<Signal<Void>> { return .name(TabView.Binding.selectPreviousItem) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var didChangeNumberOfItems: TabViewName<(NSTabView) -> Void> { return .name(TabView.Binding.didChangeNumberOfItems) }
	static var didSelect: TabViewName<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void> { return .name(TabView.Binding.didSelect) }
	static var shouldSelect: TabViewName<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Bool> { return .name(TabView.Binding.shouldSelect) }
	static var tabConstructor: TabViewName<(Binding.IdentifierType) -> TabViewItemConvertible> { return .name(TabView.Binding.tabConstructor) }
	static var willSelect: TabViewName<(NSTabView, NSTabViewItem?, Binding.IdentifierType?) -> Void> { return .name(TabView.Binding.willSelect) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TabViewConvertible: ViewConvertible {
	func nsTabView() -> NSTabView
}
extension TabViewConvertible {
	public func nsView() -> View.Instance { return nsTabView() }
}
extension NSTabView: TabViewConvertible, HasDelegate {
	public func nsTabView() -> NSTabView { return self }
}
public extension TabView {
	func nsTabView() -> TabView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TabViewBinding: ViewBinding {
	associatedtype IdentifierType: Equatable
	static func tabViewBinding(_ binding: TabView<IdentifierType>.Binding) -> Self
	func asTabViewBinding() -> TabView<IdentifierType>.Binding?
}
public extension TabViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return tabViewBinding(.inheritedBinding(binding))
	}
}
public extension TabViewBinding where Preparer.Inherited.Binding: TabViewBinding, Preparer.Inherited.Binding.IdentifierType == IdentifierType {
	func asTabViewBinding() -> TabView<IdentifierType>.Binding? {
		return asInheritedBinding()?.asTabViewBinding()
	}
}
public extension TabView.Binding {
	typealias Preparer = TabView.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asTabViewBinding() -> TabView.Binding? { return self }
	static func tabViewBinding(_ binding: TabView<IdentifierType>.Binding) -> TabView<IdentifierType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
