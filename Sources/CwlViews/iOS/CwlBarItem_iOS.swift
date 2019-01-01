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

// MARK: - Binder Part 1: Binder
public class BarItem: Binder, BarItemConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension BarItem {
	enum Binding: BarItemBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case image(Dynamic<UIImage?>)
		case imageInsets(Dynamic<UIEdgeInsets>)
		case isEnabled(Dynamic<Bool>)
		case landscapeImagePhone(Dynamic<UIImage?>)
		case landscapeImagePhoneInsets(Dynamic<UIEdgeInsets>)
		case tag(Dynamic<Int>)
		case title(Dynamic<String>)
		case titleTextAttributes(Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>>)

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension BarItem {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = BarItem.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = UIBarItem
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension BarItem.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .image(let x): return x.apply(instance) { i, v in i.image = v }
		case .imageInsets(let x): return x.apply(instance) { i, v in i.imageInsets = v }
		case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }
		case .landscapeImagePhone(let x): return x.apply(instance) { i, v in i.landscapeImagePhone = v }
		case .landscapeImagePhoneInsets(let x): return x.apply(instance) { i, v in i.landscapeImagePhoneInsets = v }
		case .tag(let x): return x.apply(instance) { i, v in i.tag = v }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .titleTextAttributes(let x):
			var previous: ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>? = nil
			return x.apply(instance) { i, v in
				for c in previous?.pairs ?? [] {
					i.setTitleTextAttributes([:], for: c.0)
				}
				previous = v
				for c in v.pairs {
					i.setTitleTextAttributes(c.1, for: c.0)
				}
			}

		//	2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension BarItem.Preparer {
	public typealias Storage = EmbeddedObjectStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: BarItemBinding {
	public typealias BarItemName<V> = BindingName<V, BarItem.Binding, Binding>
	private typealias B = BarItem.Binding
	private static func name<V>(_ source: @escaping (V) -> BarItem.Binding) -> BarItemName<V> {
		return BarItemName<V>(source: source, downcast: Binding.barItemBinding)
	}
}
public extension BindingName where Binding: BarItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: BarItemName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var image: BarItemName<Dynamic<UIImage?>> { return .name(B.image) }
	static var imageInsets: BarItemName<Dynamic<UIEdgeInsets>> { return .name(B.imageInsets) }
	static var isEnabled: BarItemName<Dynamic<Bool>> { return .name(B.isEnabled) }
	static var landscapeImagePhone: BarItemName<Dynamic<UIImage?>> { return .name(B.landscapeImagePhone) }
	static var landscapeImagePhoneInsets: BarItemName<Dynamic<UIEdgeInsets>> { return .name(B.landscapeImagePhoneInsets) }
	static var tag: BarItemName<Dynamic<Int>> { return .name(B.tag) }
	static var title: BarItemName<Dynamic<String>> { return .name(B.title) }
	static var titleTextAttributes: BarItemName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>>> { return .name(B.titleTextAttributes) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol BarItemConvertible {
	func uiBarItem() -> BarItem.Instance
}
extension UIBarItem: BarItemConvertible, DefaultConstructable {
	public func uiBarItem() -> BarItem.Instance { return self }
}
public extension BarItem {
	func uiBarItem() -> BarItem.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol BarItemBinding: BinderBaseBinding {
	static func barItemBinding(_ binding: BarItem.Binding) -> Self
}
public extension BarItemBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return barItemBinding(.inheritedBinding(binding))
	}
}
public extension BarItem.Binding {
	public typealias Preparer = BarItem.Preparer
	static func barItemBinding(_ binding: BarItem.Binding) -> BarItem.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
