//
//  CwlTabBarItem_iOS.swift
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
public class TabBarItem: Binder, TabBarItemConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TabBarItem {
	enum Binding: TabBarItemBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case systemItem(Constant<UITabBarItem.SystemItem?>)

		//	1. Value bindings may be applied at construction and may subsequently change.
		case badgeValue(Dynamic<String?>)
		case selectedImage(Dynamic<UIImage?>)
		case titlePositionAdjustment(Dynamic<UIOffset>)
		
		@available(iOS 10.0, *) case badgeColor(Dynamic<UIColor?>)
		@available(iOS 10.0, *) case badgeTextAttributes(Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key : Any]?>>)
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension TabBarItem {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = TabBarItem.Binding
		public typealias Inherited = BarItem.Preparer
		public typealias Instance = UITabBarItem
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		public var systemItem: UITabBarItem.SystemItem?
		public var title = InitialSubsequent<String>()
		public var image = InitialSubsequent<UIImage?>()
		public var selectedImage = InitialSubsequent<UIImage?>()
		public var tag = InitialSubsequent<Int>()
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TabBarItem.Preparer {
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		let x: UITabBarItem
		if let si = systemItem {
			x = type.init(tabBarSystemItem: si, tag: tag.initial ?? 0)
		} else if let si = selectedImage.initial {
			x = type.init(title: title.initial ?? nil, image: image.initial ?? nil, selectedImage: si)
		} else {
			x = type.init(title: title.initial ?? nil, image: image.initial ?? nil, tag: tag.initial ?? 0)
		}
		return x
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(.image(let x)): image = x.initialSubsequent()
		case .inheritedBinding(.tag(let x)): tag = x.initialSubsequent()
		case .inheritedBinding(.title(let x)): title = x.initialSubsequent()
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .selectedImage(let x): selectedImage = x.initialSubsequent()
		case .systemItem(let x): systemItem = x.value
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(.tag): return tag.resume()?.apply(instance) { i, v in i.tag = v }
		case .inheritedBinding(.image): return image.resume()?.apply(instance) { i, v in i.image = v }
		case .inheritedBinding(.title): return title.resume()?.apply(instance) { i, v in i.title = v }
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		case .systemItem: return nil
		
		case .badgeValue(let x): return x.apply(instance) { i, v in i.badgeValue = v }
		case .selectedImage: return selectedImage.resume()?.apply(instance) { i, v in i.selectedImage = v }
		case .titlePositionAdjustment(let x): return x.apply(instance) { i, v in i.titlePositionAdjustment = v }
		
		case .badgeColor(let x):
			guard #available(iOS 10.0, *) else { return nil }
			return x.apply(instance) { i, v in i.badgeColor = v }
		case .badgeTextAttributes(let x):
			guard #available(iOS 10.0, *) else { return nil }
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBadgeTextAttributes(nil, for: scope) },
				applyNew: { i, scope, v in i.setBadgeTextAttributes(v, for: scope) }
			)
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TabBarItem.Preparer {
	public typealias Storage = BarItem.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TabBarItemBinding {
	public typealias TabBarItemName<V> = BindingName<V, TabBarItem.Binding, Binding>
	private typealias B = TabBarItem.Binding
	private static func name<V>(_ source: @escaping (V) -> TabBarItem.Binding) -> TabBarItemName<V> {
		return TabBarItemName<V>(source: source, downcast: Binding.tabBarItemBinding)
	}
}
public extension BindingName where Binding: TabBarItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TabBarItemName<$2> { return .name(B.$1) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TabBarItemConvertible: BarItemConvertible {
	func uiTabBarItem() -> TabBarItem.Instance
}
extension TabBarItemConvertible {
	public func uiBarItem() -> BarItem.Instance { return uiTabBarItem() }
}
extension UITabBarItem: TabBarItemConvertible {
	public func uiTabBarItem() -> TabBarItem.Instance { return self }
}
public extension TabBarItem {
	func uiTabBarItem() -> TabBarItem.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TabBarItemBinding: BarItemBinding {
	static func tabBarItemBinding(_ binding: TabBarItem.Binding) -> Self
}
public extension TabBarItemBinding {
	static func barItemBinding(_ binding: BarItem.Binding) -> Self {
		return tabBarItemBinding(.inheritedBinding(binding))
	}
}
public extension TabBarItem.Binding {
	public typealias Preparer = TabBarItem.Preparer
	static func tabBarItemBinding(_ binding: TabBarItem.Binding) -> TabBarItem.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
