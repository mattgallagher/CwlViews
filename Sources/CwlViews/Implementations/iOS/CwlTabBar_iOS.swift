//
//  CwlTabBar_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class TabBar<ItemIdentifier: Hashable>: Binder, TabBarConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TabBar {
	enum Binding: TabBarBinding {
		public typealias ItemIdentifierType = ItemIdentifier
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundImage(Dynamic<UIImage?>)
		case barStyle(Dynamic<UIBarStyle>)
		case barTintColor(Dynamic<UIColor>)
		case isTranslucent(Dynamic<Bool>)
		case itemPositioning(Dynamic<UITabBar.ItemPositioning>)
		case items(Dynamic<SetOrAnimate<[ItemIdentifier]>>)
		case itemSpacing(Dynamic<CGFloat>)
		case itemWidth(Dynamic<CGFloat>)
		case selectionIndicatorImage(Dynamic<UIImage?>)
		case shadowImage(Dynamic<UIImage?>)
		case tintColor(Dynamic<UIColor>)
		case unselectedItemTintColor(Dynamic<UIColor>)

		// 2. Signal bindings are performed on the object after construction.
		case customizingItems(Signal<SetOrAnimate<[ItemIdentifier]?>>)
		case selectItem(Signal<ItemIdentifier>)

		// 3. Action bindings are triggered by the object after construction.
		case didBeginCustomizing(SignalInput<[ItemIdentifier]>)
		case didEndCustomizing(SignalInput<([ItemIdentifier], Bool)>)
		case didSelectItem(SignalInput<ItemIdentifier>)
		case willBeginCustomizing(SignalInput<[ItemIdentifier]>)
		case willEndCustomizing(SignalInput<([ItemIdentifier], Bool)>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case itemConstructor((ItemIdentifier) -> TabBarItemConvertible)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TabBar {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TabBar.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UITabBar
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var tabBarItemConstructor: ((ItemIdentifier) -> TabBarItemConvertible)?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TabBar.Preparer {
	var delegateIsRequired: Bool { return true }
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)

		case .didBeginCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:didBeginCustomizing:)))
		case .didEndCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:didEndCustomizing:changed:)))
		case .didSelectItem(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:didSelect:)))
		case .itemConstructor(let x): tabBarItemConstructor = x
		case .willBeginCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:willBeginCustomizing:)))
		case .willEndCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:willEndCustomizing:changed:)))
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)

		storage.tabBarItemConstructor = tabBarItemConstructor
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		// 0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .backgroundImage(let x): return x.apply(instance) { i, v in i.backgroundImage = v }
		case .barStyle(let x): return x.apply(instance) { i, v in i.barStyle = v }
		case .barTintColor(let x): return x.apply(instance) { i, v in i.barTintColor = v }
		case .isTranslucent(let x): return x.apply(instance) { i, v in i.isTranslucent = v }
		case .itemPositioning(let x): return x.apply(instance) { i, v in i.itemPositioning = v }
		case .items(let x):
			return x.apply(instance, storage) { i, s, v in
				let items = v.value.compactMap { s.tabBarItem(for: $0) }
				i.setItems(items, animated: v.isAnimated)
			}
		case .itemSpacing(let x): return x.apply(instance) { i, v in i.itemSpacing = v }
		case .itemWidth(let x): return x.apply(instance) { i, v in i.itemWidth = v }
		case .selectionIndicatorImage(let x): return x.apply(instance) { i, v in i.selectionIndicatorImage = v }
		case .shadowImage(let x): return x.apply(instance) { i, v in i.shadowImage = v }
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }

		case .unselectedItemTintColor(let x): return x.apply(instance) { i, v in i.unselectedItemTintColor = v }

		// 2. Signal bindings are performed on the object after construction.
		case .customizingItems(let x): return x.apply(instance, storage) { i, s, v in
			if let v = v.value {
				let items = v.compactMap { s.tabBarItem(for: $0) }
				i.beginCustomizingItems(items)
			} else {
				i.endCustomizing(animated: v.isAnimated)
			}
		}
		case .selectItem(let x): return x.apply(instance, storage) { i, s, v in i.selectedItem = s.tabBarItem(for: v) }

		// 3. Action bindings are triggered by the object after construction.
		case .didBeginCustomizing: return nil
		case .didEndCustomizing: return nil
		case .didSelectItem: return nil
		case .willBeginCustomizing: return nil
		case .willEndCustomizing: return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .itemConstructor: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TabBar.Preparer {
	open class Storage: View.Preparer.Storage, UITabBarDelegate {
		open var tabBarItemConstructor: ((ItemIdentifier) -> TabBarItemConvertible)?
		open var allItems: [ItemIdentifier: TabBarItemConvertible] = [:]
		
		open override var isInUse: Bool { return true }
		
		open func identifier(for tabBarItem: UITabBarItem) -> ItemIdentifier? {
			return allItems.first(where: { pair -> Bool in
				pair.value.uiTabBarItem() === tabBarItem
			})?.key
		}
		open func tabBarItem(for identifier: ItemIdentifier) -> UITabBarItem? {
			if let existing = allItems[identifier] {
				return existing.uiTabBarItem()
			}
			if let binding = tabBarItemConstructor {
				let new = binding(identifier)
				allItems[identifier] = new
				return new.uiTabBarItem()
			}
			return nil
		}
	}
	
	open class Delegate: DynamicDelegate, UITabBarDelegate {
		open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
			guard let identifier = (tabBar.delegate as? Storage)?.identifier(for: item) else { return }
			handler(ofType: SignalInput<ItemIdentifier>.self)!.send(value: identifier)
		}

		open func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
			guard let storage = tabBar.delegate as? Storage else { return }
			let identifiers = items.compactMap { storage.identifier(for: $0) }
			handler(ofType: SignalInput<[ItemIdentifier]>.self)!.send(value: identifiers)
		}

		open func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {
			guard let storage = tabBar.delegate as? Storage else { return }
			let identifiers = items.compactMap { storage.identifier(for: $0) }
			handler(ofType: SignalInput<[ItemIdentifier]>.self)!.send(value: identifiers)
		}

		open func tabBar(_ tabBar: UITabBar, willEndCustomizing items: [UITabBarItem], changed: Bool) {
			guard let storage = tabBar.delegate as? Storage else { return }
			let identifiers = items.compactMap { storage.identifier(for: $0) }
			handler(ofType: SignalInput<([ItemIdentifier], Bool)>.self)!.send(value: (identifiers, changed))
		}

		open func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
			guard let storage = tabBar.delegate as? Storage else { return }
			let identifiers = items.compactMap { storage.identifier(for: $0) }
			handler(ofType: SignalInput<([ItemIdentifier], Bool)>.self)!.send(value: (identifiers, changed))
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TabBarBinding {
	public typealias TabBarName<V> = BindingName<V, TabBar<Binding.ItemIdentifierType>.Binding, Binding>
	private typealias B = TabBar<Binding.ItemIdentifierType>.Binding
	private static func name<V>(_ source: @escaping (V) -> TabBar<Binding.ItemIdentifierType>.Binding) -> TabBarName<V> {
		return TabBarName<V>(source: source, downcast: Binding.tabBarBinding)
	}
}
public extension BindingName where Binding: TabBarBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TabBarName<$2> { return .name(B.$1) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backgroundImage: TabBarName<Dynamic<UIImage?>> { return .name(B.backgroundImage) }
	static var barStyle: TabBarName<Dynamic<UIBarStyle>> { return .name(B.barStyle) }
	static var barTintColor: TabBarName<Dynamic<UIColor>> { return .name(B.barTintColor) }
	static var isTranslucent: TabBarName<Dynamic<Bool>> { return .name(B.isTranslucent) }
	static var itemPositioning: TabBarName<Dynamic<UITabBar.ItemPositioning>> { return .name(B.itemPositioning) }
	static var items: TabBarName<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>> { return .name(B.items) }
	static var itemSpacing: TabBarName<Dynamic<CGFloat>> { return .name(B.itemSpacing) }
	static var itemWidth: TabBarName<Dynamic<CGFloat>> { return .name(B.itemWidth) }
	static var selectionIndicatorImage: TabBarName<Dynamic<UIImage?>> { return .name(B.selectionIndicatorImage) }
	static var shadowImage: TabBarName<Dynamic<UIImage?>> { return .name(B.shadowImage) }
	static var tintColor: TabBarName<Dynamic<UIColor>> { return .name(B.tintColor) }
	static var unselectedItemTintColor: TabBarName<Dynamic<UIColor>> { return .name(B.unselectedItemTintColor) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var customizingItems: TabBarName<Signal<SetOrAnimate<[Binding.ItemIdentifierType]?>>> { return .name(B.customizingItems) }
	static var selectItem: TabBarName<Signal<Binding.ItemIdentifierType>> { return .name(B.selectItem) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didBeginCustomizing: TabBarName<SignalInput<[Binding.ItemIdentifierType]>> { return .name(B.didBeginCustomizing) }
	static var didEndCustomizing: TabBarName<SignalInput<([Binding.ItemIdentifierType], Bool)>> { return .name(B.didEndCustomizing) }
	static var didSelectItem: TabBarName<SignalInput<Binding.ItemIdentifierType>> { return .name(B.didSelectItem) }
	static var willBeginCustomizing: TabBarName<SignalInput<[Binding.ItemIdentifierType]>> { return .name(B.willBeginCustomizing) }
	static var willEndCustomizing: TabBarName<SignalInput<([Binding.ItemIdentifierType], Bool)>> { return .name(B.willEndCustomizing) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var itemConstructor: TabBarName<(Binding.ItemIdentifierType) -> TabBarItemConvertible> { return .name(B.itemConstructor) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TabBarConvertible: ViewConvertible {
	func uiTabBar() -> UITabBar
}
extension TabBarConvertible {
	public func uiView() -> View.Instance { return uiTabBar() }
}
extension UITabBar: TabBarConvertible, HasDelegate {
	public func uiTabBar() -> UITabBar { return self }
}
public extension TabBar {
	func uiTabBar() -> UITabBar { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TabBarBinding: ViewBinding {
	associatedtype ItemIdentifierType: Hashable
	static func tabBarBinding(_ binding: TabBar<ItemIdentifierType>.Binding) -> Self
}
public extension TabBarBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return tabBarBinding(TabBar<ItemIdentifierType>.Binding.inheritedBinding(binding))
	}
}
public extension TabBar.Binding {
	public typealias Preparer = TabBar.Preparer
	static func tabBarBinding(_ binding: TabBar<ItemIdentifierType>.Binding) -> TabBar.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
