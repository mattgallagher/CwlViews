//
//  CwlTabBarItem.swift
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

public class TabBarItem: ConstructingBinder, TabBarItemConvertible {
	public typealias Instance = UITabBarItem
	public typealias Inherited = BarItem
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiTabBarItem() -> Instance { return instance() }
	
	public enum Binding: TabBarItemBinding {
		public typealias EnclosingBinder = TabBarItem
		public static func tabBarItemBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case systemItem(Constant<UITabBarItem.SystemItem?>)

		//	1. Value bindings may be applied at construction and may subsequently change.
		case selectedImage(Dynamic<UIImage?>)
		case titlePositionAdjustment(Dynamic<UIOffset>)
		case badgeValue(Dynamic<String?>)
		@available(iOS 10.0, *)
		case badgeColor(Dynamic<UIColor?>)
		@available(iOS 10.0, *)
		case badgeTextAttributes(Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key : Any]?>>)
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = TabBarItem
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			let x: UITabBarItem
			if let si = systemItem {
				x = subclass.init(tabBarSystemItem: si, tag: tagInitial ?? 0)
			} else if let si = selectedImageInitial {
				x = subclass.init(title: titleInitial ?? nil, image: imageInitial ?? nil, selectedImage: si)
			} else {
				x = subclass.init(title: titleInitial ?? nil, image: imageInitial ?? nil, tag: tagInitial ?? 0)
			}
			return x
		}
		
		public var systemItem: UITabBarItem.SystemItem?
		public var title = InitialSubsequent<String>()
		public var titleInitial: String? = nil
		public var image = InitialSubsequent<UIImage?>()
		public var imageInitial: UIImage?? = nil
		public var selectedImage = InitialSubsequent<UIImage?>()
		public var selectedImageInitial: UIImage?? = nil
		public var tag = InitialSubsequent<Int>()
		public var tagInitial: Int? = nil
		
		public init() {}
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .systemItem(let x): systemItem = x.value
			case .selectedImage(let x):
				selectedImage = x.initialSubsequent()
				selectedImageInitial = selectedImage.initial()
			case .inheritedBinding(.tag(let x)):
				tag = x.initialSubsequent()
				tagInitial = tag.initial()
			case .inheritedBinding(.image(let x)):
				image = x.initialSubsequent()
				imageInitial = image.initial()
			case .inheritedBinding(.title(let x)):
				title = x.initialSubsequent()
				titleInitial = title.initial()
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .badgeTextAttributes(let x):
				if #available(iOS 10.0, *) {
					var previous: ScopedValues<UIControl.State, [NSAttributedString.Key : Any]?>? = nil
					return x.apply(instance, storage) { i, s, v in
						if let p = previous {
							for c in p.pairs {
								i.setBadgeTextAttributes(nil, for: c.0)
							}
						}
						previous = v
						for c in v.pairs {
							i.setBadgeTextAttributes(c.1, for: c.0)
						}
					}
				} else {
					return nil
				}
			case .titlePositionAdjustment(let x): return x.apply(instance, storage) { i, s, v in i.titlePositionAdjustment = v }
			case .badgeValue(let x): return x.apply(instance, storage) { i, s, v in i.badgeValue = v }
			case .badgeColor(let x):
				return x.apply(instance, storage) { i, s, v in
					if #available(iOS 10.0, *) {
						i.badgeColor = v
					}
				}
			case .systemItem: return nil
			case .selectedImage: return selectedImage.resume()?.apply(instance, storage) { i, s, v in i.selectedImage = v }
			case .inheritedBinding(.tag): return tag.resume()?.apply(instance, storage) { i, s, v in i.tag = v }
			case .inheritedBinding(.image): return image.resume()?.apply(instance, storage) { i, s, v in i.image = v }
			case .inheritedBinding(.title): return title.resume()?.apply(instance, storage) { i, s, v in i.title = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = BarItem.Storage
}

extension BindingName where Binding: TabBarItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tabBarItemBinding(TabBarItem.Binding.$1(v)) }) }
	public static var selectedImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .tabBarItemBinding(TabBarItem.Binding.selectedImage(v)) }) }
	public static var titlePositionAdjustment: BindingName<Dynamic<UIOffset>, Binding> { return BindingName<Dynamic<UIOffset>, Binding>({ v in .tabBarItemBinding(TabBarItem.Binding.titlePositionAdjustment(v)) }) }
	public static var badgeValue: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .tabBarItemBinding(TabBarItem.Binding.badgeValue(v)) }) }
	@available(iOS 10.0, *)
	public static var badgeColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .tabBarItemBinding(TabBarItem.Binding.badgeColor(v)) }) }
	@available(iOS 10.0, *)
	public static var badgeTextAttributes: BindingName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key : Any]?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key : Any]?>>, Binding>({ v in .tabBarItemBinding(TabBarItem.Binding.badgeTextAttributes(v)) }) }
}

public protocol TabBarItemConvertible: BarItemConvertible {
	func uiTabBarItem() -> TabBarItem.Instance
}
extension TabBarItemConvertible {
	public func uiBarItem() -> BarItem.Instance { return uiTabBarItem() }
}
extension TabBarItem.Instance: TabBarItemConvertible {
	public func uiTabBarItem() -> TabBarItem.Instance { return self }
}

public protocol TabBarItemBinding: BarItemBinding {
	static func tabBarItemBinding(_ binding: TabBarItem.Binding) -> Self
}
extension TabBarItemBinding {
	public static func barItemBinding(_ binding: BarItem.Binding) -> Self {
		return tabBarItemBinding(.inheritedBinding(binding))
	}
}
