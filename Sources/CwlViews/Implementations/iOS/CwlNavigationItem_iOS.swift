//
//  CwlNavigationItem_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/21.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class NavigationItem: Binder, NavigationItemConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension NavigationItem {
	enum Binding: NavigationItemBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backBarButtonItem(Dynamic<BarButtonItemConvertible?>)
		case hidesBackButton(Dynamic<SetOrAnimate<Bool>>)
		case leftBarButtonItems(Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>)
		case leftItemsSupplementBackButton(Dynamic<Bool>)
		case prompt(Dynamic<String?>)
		case rightBarButtonItems(Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>)
		case title(Dynamic<String>)
		case titleView(Dynamic<ViewConvertible?>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension NavigationItem {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = NavigationItem.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = UINavigationItem
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}
		
// MARK: - Binder Part 4: Preparer overrides
public extension NavigationItem.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .backBarButtonItem(let x): return x.apply(instance) { i, v in i.backBarButtonItem = v?.uiBarButtonItem() }
		case .hidesBackButton(let x): return x.apply(instance) { i, v in i.setHidesBackButton(v.value, animated: v.isAnimated) }
		case .leftBarButtonItems(let x): return x.apply(instance) { i, v in i.setLeftBarButtonItems(v.value.map { $0.uiBarButtonItem() }, animated: v.isAnimated) }
		case .leftItemsSupplementBackButton(let x): return x.apply(instance) { i, v in i.leftItemsSupplementBackButton = v }
		case .prompt(let x): return x.apply(instance) { i, v in i.prompt = v }
		case .rightBarButtonItems(let x): return x.apply(instance) { i, v in i.setRightBarButtonItems(v.value.map { $0.uiBarButtonItem() }, animated: v.isAnimated) }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .titleView(let x): return x.apply(instance) { i, v in i.titleView = v?.uiView() }

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension NavigationItem.Preparer {
	public typealias Storage = EmbeddedObjectStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: NavigationItemBinding {
	public typealias NavigationItemName<V> = BindingName<V, NavigationItem.Binding, Binding>
	private typealias B = NavigationItem.Binding
	private static func name<V>(_ source: @escaping (V) -> NavigationItem.Binding) -> NavigationItemName<V> {
		return NavigationItemName<V>(source: source, downcast: Binding.navigationItemBinding)
	}
}
public extension BindingName where Binding: NavigationItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: NavigationItemName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backBarButtonItem: NavigationItemName<Dynamic<BarButtonItemConvertible?>> { return .name(B.backBarButtonItem) }
	static var hidesBackButton: NavigationItemName<Dynamic<SetOrAnimate<Bool>>> { return .name(B.hidesBackButton) }
	static var leftBarButtonItems: NavigationItemName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> { return .name(B.leftBarButtonItems) }
	static var leftItemsSupplementBackButton: NavigationItemName<Dynamic<Bool>> { return .name(B.leftItemsSupplementBackButton) }
	static var prompt: NavigationItemName<Dynamic<String?>> { return .name(B.prompt) }
	static var rightBarButtonItems: NavigationItemName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> { return .name(B.rightBarButtonItems) }
	static var title: NavigationItemName<Dynamic<String>> { return .name(B.title) }
	static var titleView: NavigationItemName<Dynamic<ViewConvertible?>> { return .name(B.titleView) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	
	// Composite binding names
	static func leftBarButtonItems(animate: AnimationChoice = .subsequent) -> NavigationItemName<Dynamic<[BarButtonItemConvertible]>> {
		return Binding.compositeName(
			value: { dynamicArray in 
				switch dynamicArray {
				case .constant(let b) where animate == .all: return .constant(.animate(b))
				case .constant(let b): return .constant(.set(b))
				case .dynamic(let b): return .dynamic(b.animate(animate))
				}
			},
			binding: NavigationItem.Binding.leftBarButtonItems,
			downcast: Binding.navigationItemBinding
		)
	}
	static func rightBarButtonItems(animate: AnimationChoice = .subsequent) -> NavigationItemName<Dynamic<[BarButtonItemConvertible]>> {
		return Binding.compositeName(
			value: { dynamicArray in 
				switch dynamicArray {
				case .constant(let b) where animate == .all: return .constant(.animate(b))
				case .constant(let b): return .constant(.set(b))
				case .dynamic(let b): return .dynamic(b.animate(animate))
				}
			},
			binding: NavigationItem.Binding.rightBarButtonItems,
			downcast: Binding.navigationItemBinding)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol NavigationItemConvertible {
	func uiNavigationItem() -> NavigationItem.Instance
}
extension UINavigationItem: NavigationItemConvertible, DefaultConstructable {
	public func uiNavigationItem() -> NavigationItem.Instance { return self }
}
public extension NavigationItem {
	func uiNavigationItem() -> NavigationItem.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol NavigationItemBinding: BinderBaseBinding {
	static func navigationItemBinding(_ binding: NavigationItem.Binding) -> Self
}
public extension NavigationItemBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return navigationItemBinding(.inheritedBinding(binding))
	}
}
public extension NavigationItem.Binding {
	public typealias Preparer = NavigationItem.Preparer
	static func navigationItemBinding(_ binding: NavigationItem.Binding) -> NavigationItem.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
