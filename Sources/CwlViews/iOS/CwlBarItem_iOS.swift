//
//  BarItem_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
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

public class BarItem: Binder, BarItemConvertible {
	public typealias Instance = UIBarItem
	public typealias Inherited = BaseBinder
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiBarItem() -> Instance { return instance() }
	
	enum Binding: BarItemBinding {
		public typealias EnclosingBinder = BarItem
		public static func barItemBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case isEnabled(Dynamic<Bool>)
		case image(Dynamic<UIImage?>)
		case landscapeImagePhone(Dynamic<UIImage?>)
		case imageInsets(Dynamic<UIEdgeInsets>)
		case landscapeImagePhoneInsets(Dynamic<UIEdgeInsets>)
		case title(Dynamic<String>)
		case tag(Dynamic<Int>)
		case titleTextAttributes(Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>>)

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = BarItem
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}

		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }
			case .image(let x): return x.apply(instance) { i, v in i.image = v }
			case .landscapeImagePhone(let x): return x.apply(instance) { i, v in i.landscapeImagePhone = v }
			case .imageInsets(let x): return x.apply(instance) { i, v in i.imageInsets = v }
			case .landscapeImagePhoneInsets(let x): return x.apply(instance) { i, v in i.landscapeImagePhoneInsets = v }
			case .title(let x): return x.apply(instance) { i, v in i.title = v }
			case .tag(let x): return x.apply(instance) { i, v in i.tag = v }
			case .titleTextAttributes(let x):
				var previous: ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setTitleTextAttributes([:], for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setTitleTextAttributes(c.1, for: c.0)
					}
				}
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = ObjectBinderStorage
}

extension BindingName where Binding: BarItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .barItemBinding(BarItem.Binding.$1(v)) }) }
	public static var isEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .barItemBinding(BarItem.Binding.isEnabled(v)) }) }
	public static var image: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .barItemBinding(BarItem.Binding.image(v)) }) }
	public static var landscapeImagePhone: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .barItemBinding(BarItem.Binding.landscapeImagePhone(v)) }) }
	public static var imageInsets: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .barItemBinding(BarItem.Binding.imageInsets(v)) }) }
	public static var landscapeImagePhoneInsets: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .barItemBinding(BarItem.Binding.landscapeImagePhoneInsets(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .barItemBinding(BarItem.Binding.title(v)) }) }
	public static var tag: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .barItemBinding(BarItem.Binding.tag(v)) }) }
	public static var titleTextAttributes: BindingName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>>, Binding>({ v in .barItemBinding(BarItem.Binding.titleTextAttributes(v)) }) }
}

public protocol BarItemConvertible {
	func uiBarItem() -> BarItem.Instance
}
extension BarItem.Instance: BarItemConvertible {
	public func uiBarItem() -> BarItem.Instance { return self }
}

public protocol BarItemBinding: BaseBinding {
	static func barItemBinding(_ binding: BarItem.Binding) -> Self
}
extension BarItemBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return barItemBinding(.inheritedBinding(binding))
	}
}

#endif
