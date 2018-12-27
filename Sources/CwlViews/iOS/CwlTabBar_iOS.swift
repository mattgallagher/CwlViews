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

public class TabBar<ItemIdentifier: Hashable>: Binder, TabBarConvertible {
	public typealias Instance = UITabBar
	public typealias Inherited = View
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiTabBar() -> Instance { return instance() }
	
	enum Binding: TabBarBinding {
		public typealias ItemIdentifierType = ItemIdentifier
		public typealias EnclosingBinder = TabBar
		public static func tabBarBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case items(Dynamic<SetOrAnimate<[ItemIdentifier]>>)
		case barStyle(Dynamic<UIBarStyle>)
		case isTranslucent(Dynamic<Bool>)
		case barTintColor(Dynamic<UIColor>)
		case tintColor(Dynamic<UIColor>)
		@available(iOS 10.0, *)
		case unselectedItemTintColor(Dynamic<UIColor>)
		case backgroundImage(Dynamic<UIImage?>)
		case shadowImage(Dynamic<UIImage?>)
		case selectionIndicatorImage(Dynamic<UIImage?>)
		case itemPositioning(Dynamic<UITabBar.ItemPositioning>)
		case itemSpacing(Dynamic<CGFloat>)
		case itemWidth(Dynamic<CGFloat>)

		// 2. Signal bindings are performed on the object after construction.
		case selectItem(Signal<ItemIdentifier>)
		case customizingItems(Signal<SetOrAnimate<[ItemIdentifier]?>>)

		// 3. Action bindings are triggered by the object after construction.
		case willBeginCustomizing(SignalInput<[ItemIdentifier]>)
		case didBeginCustomizing(SignalInput<[ItemIdentifier]>)
		case willEndCustomizing(SignalInput<([ItemIdentifier], Bool)>)
		case didEndCustomizing(SignalInput<([ItemIdentifier], Bool)>)
		case didSelectItem(SignalInput<ItemIdentifier>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case itemConstructor((ItemIdentifier) -> TabBarItemConvertible)
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = TabBar
		public var linkedPreparer = Inherited.Preparer()

		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }

		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var possibleDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}
		
		var tabBarItemConstructor: ((ItemIdentifier) -> TabBarItemConvertible)?

		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .itemConstructor(let x): tabBarItemConstructor = x
			case .willBeginCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:willBeginCustomizing:)))
			case .didBeginCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:didBeginCustomizing:)))
			case .willEndCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:willEndCustomizing:changed:)))
			case .didEndCustomizing(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:didEndCustomizing:changed:)))
			case .didSelectItem(let x): delegate().addHandler(x, #selector(UITabBarDelegate.tabBar(_:didSelect:)))
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}
		
		public func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")

			storage.dynamicDelegate = possibleDelegate
			storage.tabBarItemConstructor = tabBarItemConstructor
			
			if storage.inUse {
				instance.delegate = storage
			}
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			// e.g. case .someProperty(let x): return x.apply(instance, storage) { inst, stor, val in inst.someProperty = val }
			case .itemConstructor: return nil
			case .items(let x):
				return x.apply(instance, storage) { inst, stor, val in
					let items = val.value.compactMap { stor.tabBarItem(for: $0) }
					inst.setItems(items, animated: val.isAnimated)
				}
			case .selectItem(let x): return x.apply(instance, storage) { inst, stor, val in inst.selectedItem = stor.tabBarItem(for: val) }
			case .barStyle(let x): return x.apply(instance, storage) { inst, stor, val in inst.barStyle = val }
			case .isTranslucent(let x): return x.apply(instance, storage) { inst, stor, val in inst.isTranslucent = val }
			case .barTintColor(let x): return x.apply(instance, storage) { inst, stor, val in inst.barTintColor = val }
			case .tintColor(let x): return x.apply(instance, storage) { inst, stor, val in inst.tintColor = val }
			case .unselectedItemTintColor(let x): return x.apply(instance, storage) { inst, stor, val in
					if #available(iOS 10.0, *) {
						inst.unselectedItemTintColor = val
					}
				}
			case .backgroundImage(let x): return x.apply(instance, storage) { inst, stor, val in inst.backgroundImage = val }
			case .shadowImage(let x): return x.apply(instance, storage) { inst, stor, val in inst.shadowImage = val }
			case .selectionIndicatorImage(let x): return x.apply(instance, storage) { inst, stor, val in inst.selectionIndicatorImage = val }
			case .itemPositioning(let x): return x.apply(instance, storage) { inst, stor, val in inst.itemPositioning = val }
			case .itemSpacing(let x): return x.apply(instance, storage) { inst, stor, val in inst.itemSpacing = val }
			case .itemWidth(let x): return x.apply(instance, storage) { inst, stor, val in inst.itemWidth = val }
			case .customizingItems(let x): return x.apply(instance, storage) { inst, stor, val in
				if let v = val.value {
					let items = v.compactMap { stor.tabBarItem(for: $0) }
					inst.beginCustomizingItems(items)
				} else {
					inst.endCustomizing(animated: val.isAnimated)
				}
			}
			case .willBeginCustomizing: return nil
			case .didBeginCustomizing: return nil
			case .willEndCustomizing: return nil
			case .didEndCustomizing: return nil
			case .didSelectItem: return nil
			case .inheritedBinding(let b): return inherited.applyBinding(b, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: View.Storage, UITabBarDelegate {
		open var tabBarItemConstructor: ((ItemIdentifier) -> TabBarItemConvertible)?
		open var allItems: [ItemIdentifier: TabBarItemConvertible] = [:]
		
		open override var inUse: Bool { return true }
		
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
		public required override init() {
			super.init()
		}

		open var didSelectIndex: SignalInput<ItemIdentifier>?
		open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
			if let identifier = (tabBar.delegate as? Storage)?.identifier(for: item) {
				didSelectIndex?.send(value: identifier)
			}
		}

		open var willBeginCustomizing: SignalInput<[ItemIdentifier]>?
		open func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
			if let storage = tabBar.delegate as? Storage {
				willBeginCustomizing?.send(value: items.compactMap { storage.identifier(for: $0) })
			}
		}

		open var didBeginCustomizing: SignalInput<[ItemIdentifier]>?
		open func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {
			if let storage = tabBar.delegate as? Storage {
				didBeginCustomizing?.send(value: items.compactMap { storage.identifier(for: $0) })
			}
		}

		open var willEndCustomizing: SignalInput<([ItemIdentifier], Bool)>?
		open func tabBar(_ tabBar: UITabBar, willEndCustomizing items: [UITabBarItem], changed: Bool) {
			if let storage = tabBar.delegate as? Storage {
				willEndCustomizing?.send(value: (items.compactMap { storage.identifier(for: $0) }, changed))
			}
		}

		open var didEndCustomizing: SignalInput<([ItemIdentifier], Bool)>?
		open func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
			if let storage = tabBar.delegate as? Storage {
				didEndCustomizing?.send(value: (items.compactMap { storage.identifier(for: $0) }, changed))
			}
		}
	}
}

extension BindingName where Binding: TabBarBinding {
	// You can easily convert the `Binding` cases to `BindingName` by copying them to here and using the following Xcode-style regex:
	// Find:    case ([^\(]+)\((.+)\)$
	// Replace: public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.$1(v)) }) }
	public static var items: BindingName<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>, Binding> { return BindingName<Dynamic<SetOrAnimate<[Binding.ItemIdentifierType]>>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.items(v)) }) }
	public static var selectItem: BindingName<Signal<Binding.ItemIdentifierType>, Binding> { return BindingName<Signal<Binding.ItemIdentifierType>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.selectItem(v)) }) }
	public static var barStyle: BindingName<Dynamic<UIBarStyle>, Binding> { return BindingName<Dynamic<UIBarStyle>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.barStyle(v)) }) }
	public static var isTranslucent: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.isTranslucent(v)) }) }
	public static var barTintColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.barTintColor(v)) }) }
	public static var tintColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.tintColor(v)) }) }
	@available(iOS 10.0, *)
	public static var unselectedItemTintColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.unselectedItemTintColor(v)) }) }
	public static var backgroundImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.backgroundImage(v)) }) }
	public static var shadowImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.shadowImage(v)) }) }
	public static var selectionIndicatorImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.selectionIndicatorImage(v)) }) }
	public static var itemPositioning: BindingName<Dynamic<UITabBar.ItemPositioning>, Binding> { return BindingName<Dynamic<UITabBar.ItemPositioning>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.itemPositioning(v)) }) }
	public static var itemSpacing: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.itemSpacing(v)) }) }
	public static var itemWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.itemWidth(v)) }) }
	public static var customizingItems: BindingName<Signal<SetOrAnimate<[Binding.ItemIdentifierType]?>>, Binding> { return BindingName<Signal<SetOrAnimate<[Binding.ItemIdentifierType]?>>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.customizingItems(v)) }) }
	public static var willBeginCustomizing: BindingName<SignalInput<[Binding.ItemIdentifierType]>, Binding> { return BindingName<SignalInput<[Binding.ItemIdentifierType]>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.willBeginCustomizing(v)) }) }
	public static var didBeginCustomizing: BindingName<SignalInput<[Binding.ItemIdentifierType]>, Binding> { return BindingName<SignalInput<[Binding.ItemIdentifierType]>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.didBeginCustomizing(v)) }) }
	public static var willEndCustomizing: BindingName<SignalInput<([Binding.ItemIdentifierType], Bool)>, Binding> { return BindingName<SignalInput<([Binding.ItemIdentifierType], Bool)>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.willEndCustomizing(v)) }) }
	public static var didEndCustomizing: BindingName<SignalInput<([Binding.ItemIdentifierType], Bool)>, Binding> { return BindingName<SignalInput<([Binding.ItemIdentifierType], Bool)>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.didEndCustomizing(v)) }) }
	public static var didSelectItem: BindingName<SignalInput<Binding.ItemIdentifierType>, Binding> { return BindingName<SignalInput<Binding.ItemIdentifierType>, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.didSelectItem(v)) }) }
	public static var itemConstructor: BindingName<(Binding.ItemIdentifierType) -> TabBarItemConvertible, Binding> { return BindingName<(Binding.ItemIdentifierType) -> TabBarItemConvertible, Binding>({ v in .tabBarBinding(TabBar<Binding.ItemIdentifierType>.Binding.itemConstructor(v)) }) }
}

public protocol TabBarConvertible {
	func uiTabBar() -> UITabBar
}
extension TabBarConvertible {
	public func uiView() -> View.Instance { return uiTabBar() }
}
extension TabBar.Instance: TabBarConvertible {
	public func uiTabBar() -> UITabBar { return self }
}

public protocol TabBarBinding: ViewBinding {
	associatedtype ItemIdentifierType: Hashable
	static func tabBarBinding(_ binding: TabBar<ItemIdentifierType>.Binding) -> Self
}
extension TabBarBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return tabBarBinding(.inheritedBinding(binding))
	}
}

#endif
