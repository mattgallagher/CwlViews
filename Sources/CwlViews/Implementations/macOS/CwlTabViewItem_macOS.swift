//
//  CwlTabViewItem_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 30/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class TabViewItem: Binder, TabViewItemConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TabViewItem {
	enum Binding: TabViewItemBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case color(Dynamic<NSColor>)
		case image(Dynamic<NSImage?>)
		case initialFirstResponderTag(Dynamic<Int>)
		case label(Dynamic<String>)
		case toolTip(Dynamic<String>)
		case view(Dynamic<ViewConvertible>)

		// 2. Signal bindings are performed on the object after construction.
		/* case someFunction(Signal<FunctionParametersAsTuple>) */

		// 3. Action bindings are triggered by the object after construction.
		/* case someAction(SignalInput<CallbackParameters>) */

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		/* case someDelegateFunction((Param) -> Result)) */
	}
}

// MARK: - Binder Part 3: Preparer
public extension TabViewItem {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = TabViewItem.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSTabViewItem
		
		public var inherited = Inherited()
		public init() {}
		
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var initialFirstResponderTag: Dynamic<Int>? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TabViewItem.Preparer {
	func constructInstance(type: Instance.Type, parameters: Void) -> Instance {
		return type.init(identifier: nil)
	}
	
	mutating func prepareBinding(_ binding: TabViewItem.Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .initialFirstResponderTag(let x): initialFirstResponderTag = x
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		case .color(let x): return x.apply(instance) { i, v in i.color = v }
		case .image(let x): return x.apply(instance) { i, v in i.image = v }
		case .initialFirstResponderTag: return nil
		case .label(let x): return x.apply(instance) { i, v in i.label = v }
		case .toolTip(let x): return x.apply(instance) { i, v in i.toolTip = v }
		case .view(let x): return x.apply(instance) { i, v in i.view = v.nsView() }
		}
	}
	
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		var lifetimes = [Lifetime]()
		lifetimes += initialFirstResponderTag?.apply(instance) { i, v in
			let view = i.view?.viewWithTag(v)
			i.initialFirstResponder = view
		}
		lifetimes += inheritedFinalizedInstance(instance, storage: storage)
		return lifetimes.isEmpty ? nil : AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TabViewItem.Preparer {
	public typealias Storage = AssociatedBinderStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TabViewItemBinding {
	public typealias TabViewItemName<V> = BindingName<V, TabViewItem.Binding, Binding>
	private typealias B = TabViewItem.Binding
	private static func name<V>(_ source: @escaping (V) -> TabViewItem.Binding) -> TabViewItemName<V> {
		return TabViewItemName<V>(source: source, downcast: Binding.tabViewItemBinding)
	}
}
public extension BindingName where Binding: TabViewItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TabViewItemName<$2> { return .name(B.$1) }
	static var color: TabViewItemName<Dynamic<NSColor>> { return .name(B.color) }
	static var image: TabViewItemName<Dynamic<NSImage?>> { return .name(B.image) }
	static var initialFirstResponderTag: TabViewItemName<Dynamic<Int>> { return .name(B.initialFirstResponderTag) }
	static var label: TabViewItemName<Dynamic<String>> { return .name(B.label) }
	static var toolTip: TabViewItemName<Dynamic<String>> { return .name(B.toolTip) }
	static var view: TabViewItemName<Dynamic<ViewConvertible>> { return .name(B.view) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TabViewItemConvertible {
	func nsTabViewItem() -> TabViewItem.Instance
}
extension TabViewItemConvertible {
	public func nsBinderBase() -> BinderBase.Instance { return nsTabViewItem() }
}
extension NSTabViewItem: TabViewItemConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func nsTabViewItem() -> TabViewItem.Instance { return self }
}
public extension TabViewItem {
	func nsTabViewItem() -> TabViewItem.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TabViewItemBinding: BinderBaseBinding {
	static func tabViewItemBinding(_ binding: TabViewItem.Binding) -> Self
}
public extension TabViewItemBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return tabViewItemBinding(.inheritedBinding(binding))
	}
}
public extension TabViewItem.Binding {
	typealias Preparer = TabViewItem.Preparer
	static func tabViewItemBinding(_ binding: TabViewItem.Binding) -> TabViewItem.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
