//
//  CwlNavigationItem.swift
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

public class NavigationItem: ConstructingBinder, NavigationItemConvertible {
	public typealias Instance = UINavigationItem
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiNavigationItem() -> Instance { return instance() }
	
	public enum Binding: NavigationItemBinding {
		public typealias EnclosingBinder = NavigationItem
		public static func navigationItemBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case title(Dynamic<String>)
		case titleView(Dynamic<ViewConvertible?>)
		case prompt(Dynamic<String?>)
		case backBarButtonItem(Dynamic<BarButtonItemConvertible?>)
		case hidesBackButton(Dynamic<SetOrAnimate<Bool>>)
		case leftBarButtonItems(Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>)
		case rightBarButtonItems(Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>)
		case leftItemsSupplementBackButton(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = NavigationItem
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .title(let x): return x.apply(instance, storage) { i, s, v in i.title = v }
			case .titleView(let x): return x.apply(instance, storage) { i, s, v in i.titleView = v?.uiView() }
			case .prompt(let x): return x.apply(instance, storage) { i, s, v in i.prompt = v }
			case .backBarButtonItem(let x): return x.apply(instance, storage) { i, s, v in i.backBarButtonItem = v?.uiBarButtonItem() }
			case .hidesBackButton(let x): return x.apply(instance, storage) { i, s, v in i.setHidesBackButton(v.value, animated: v.isAnimated) }
			case .leftBarButtonItems(let x): return x.apply(instance, storage) { i, s, v in i.setLeftBarButtonItems(v.value.map { $0.uiBarButtonItem() }, animated: v.isAnimated) }
			case .rightBarButtonItems(let x): return x.apply(instance, storage) { i, s, v in i.setRightBarButtonItems(v.value.map { $0.uiBarButtonItem() }, animated: v.isAnimated) }
			case .leftItemsSupplementBackButton(let x): return x.apply(instance, storage) { i, s, v in i.leftItemsSupplementBackButton = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: (), storage: ())
			}
		}
	}

	public typealias Storage = ObjectBinderStorage
}

extension BindingName where Binding: NavigationItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.$1(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.title(v)) }) }
	public static var titleView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.titleView(v)) }) }
	public static var prompt: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.prompt(v)) }) }
	public static var backBarButtonItem: BindingName<Dynamic<BarButtonItemConvertible?>, Binding> { return BindingName<Dynamic<BarButtonItemConvertible?>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.backBarButtonItem(v)) }) }
	public static var hidesBackButton: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.hidesBackButton(v)) }) }
	public static var leftBarButtonItems: BindingName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding> { return BindingName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.leftBarButtonItems(v)) }) }
	public static var rightBarButtonItems: BindingName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding> { return BindingName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.rightBarButtonItems(v)) }) }
	public static var leftItemsSupplementBackButton: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .navigationItemBinding(NavigationItem.Binding.leftItemsSupplementBackButton(v)) }) }
}

extension BindingName where Binding: NavigationItemBinding {
	// Additional helper binding names
	public static func leftBarButtonItems(animate: AnimationChoice = .subsequent) -> BindingName<Dynamic<[BarButtonItemConvertible]>, Binding> { return BindingName<Dynamic<[BarButtonItemConvertible]>, Binding>({ (v: Dynamic<[BarButtonItemConvertible]>) -> Binding in
		switch v {
		case .constant(let b) where animate == .all: return Binding.navigationItemBinding(NavigationItem.Binding.leftBarButtonItems(Dynamic.constant(.animate(b))))
		case .constant(let b): return Binding.navigationItemBinding(NavigationItem.Binding.leftBarButtonItems(Dynamic.constant(.set(b))))
		case .dynamic(let b): return Binding.navigationItemBinding(NavigationItem.Binding.leftBarButtonItems(Dynamic.dynamic(b.animate(animate))))
		}
	}) }
	public static func rightBarButtonItems(animate: AnimationChoice = .subsequent) -> BindingName<Dynamic<[BarButtonItemConvertible]>, Binding> { return BindingName<Dynamic<[BarButtonItemConvertible]>, Binding>({ (v: Dynamic<[BarButtonItemConvertible]>) -> Binding in
		switch v {
		case .constant(let b) where animate == .all: return Binding.navigationItemBinding(NavigationItem.Binding.rightBarButtonItems(Dynamic.constant(.animate(b))))
		case .constant(let b): return Binding.navigationItemBinding(NavigationItem.Binding.rightBarButtonItems(Dynamic.constant(.set(b))))
		case .dynamic(let b): return Binding.navigationItemBinding(NavigationItem.Binding.rightBarButtonItems(Dynamic.dynamic(b.animate(animate))))
		}
	}) }
}

public protocol NavigationItemConvertible {
	func uiNavigationItem() -> NavigationItem.Instance
}
extension NavigationItem.Instance: NavigationItemConvertible {
	public func uiNavigationItem() -> NavigationItem.Instance { return self }
}

public protocol NavigationItemBinding: BaseBinding {
	static func navigationItemBinding(_ binding: NavigationItem.Binding) -> Self
}
extension NavigationItemBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return navigationItemBinding(.inheritedBinding(binding))
	}
}
