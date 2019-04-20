//
//  CwlToolbarItem_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 11/3/16.
//  Copyright © 2016 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class ToolbarItem: Binder, ToolbarItemConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}

	public convenience init(type: Instance.Type = Instance.self, itemIdentifier: NSToolbarItem.Identifier, _ bindings: Binding...) {
		self.init(type: type, parameters: itemIdentifier, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ToolbarItem {
	enum Binding: ToolbarItemBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case image(Dynamic<NSImage?>)
		case isEnabled(Dynamic<Bool>)
		case label(Dynamic<String>)
		case maxSize(Dynamic<NSSize>)
		case menuFormRepresentation(Dynamic<MenuItemConvertible>)
		case minSize(Dynamic<NSSize>)
		case paletteLabel(Dynamic<String>)
		case tag(Dynamic<Int>)
		case toolTip(Dynamic<String?>)
		case view(Dynamic<ViewConvertible?>)
		case visibilityPriority(Dynamic<NSToolbarItem.VisibilityPriority>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case action(TargetAction)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case validate((NSToolbarItem) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension ToolbarItem {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = ToolbarItem.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSToolbarItem
		public typealias Parameters = NSToolbarItem.Identifier
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var validator: ((NSToolbarItem) -> Bool)?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ToolbarItem.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .validate(let x): validator = x
		default: break
		}
	}

	func constructInstance(type: Instance.Type, parameters: NSToolbarItem.Identifier) -> NSToolbarItem {
		return type.init(itemIdentifier: parameters)
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static styles are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .image(let x): return x.apply(instance) { i, v in i.image = v }
		case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }
		case .label(let x): return x.apply(instance) { i, v in i.label = v }
		case .maxSize(let x): return x.apply(instance) { i, v in i.maxSize = v }
		case .menuFormRepresentation(let x): return x.apply(instance) { i, v in i.menuFormRepresentation = v.nsMenuItem() }
		case .minSize(let x): return x.apply(instance) { i, v in i.minSize = v }
		case .paletteLabel(let x): return x.apply(instance) { i, v in i.paletteLabel = v }
		case .tag(let x): return x.apply(instance) { i, v in i.tag = v }
		case .toolTip(let x): return x.apply(instance) { i, v in i.toolTip = v }
		case .view(let x): return x.apply(instance) { i, v in i.view = v?.nsView() }
		case .visibilityPriority(let x): return x.apply(instance) { i, v in i.visibilityPriority = v }
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case .action(let x): return x.apply(to: instance, constructTarget: ToolbarItemTarget.init)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .validate: return nil
		}
	}
	
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		// Need to apply the validator *after* the action exists
		if let v = validator, let target = instance.target as? ToolbarItemTarget {
			target.validator = v
		}
		
		return inheritedFinalizedInstance(instance, storage: storage)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ToolbarItem.Preparer {
	public typealias Storage = AssociatedBinderStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ToolbarItemBinding {
	public typealias ToolbarItemName<V> = BindingName<V, ToolbarItem.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> ToolbarItem.Binding) -> ToolbarItemName<V> {
		return ToolbarItemName<V>(source: source, downcast: Binding.toolbarItemBinding)
	}
}
public extension BindingName where Binding: ToolbarItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ToolbarItemName<$2> { return .name(ToolbarItem.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var image: ToolbarItemName<Dynamic<NSImage?>> { return .name(ToolbarItem.Binding.image) }
	static var isEnabled: ToolbarItemName<Dynamic<Bool>> { return .name(ToolbarItem.Binding.isEnabled) }
	static var label: ToolbarItemName<Dynamic<String>> { return .name(ToolbarItem.Binding.label) }
	static var maxSize: ToolbarItemName<Dynamic<NSSize>> { return .name(ToolbarItem.Binding.maxSize) }
	static var menuFormRepresentation: ToolbarItemName<Dynamic<MenuItemConvertible>> { return .name(ToolbarItem.Binding.menuFormRepresentation) }
	static var minSize: ToolbarItemName<Dynamic<NSSize>> { return .name(ToolbarItem.Binding.minSize) }
	static var paletteLabel: ToolbarItemName<Dynamic<String>> { return .name(ToolbarItem.Binding.paletteLabel) }
	static var tag: ToolbarItemName<Dynamic<Int>> { return .name(ToolbarItem.Binding.tag) }
	static var toolTip: ToolbarItemName<Dynamic<String?>> { return .name(ToolbarItem.Binding.toolTip) }
	static var view: ToolbarItemName<Dynamic<ViewConvertible?>> { return .name(ToolbarItem.Binding.view) }
	static var visibilityPriority: ToolbarItemName<Dynamic<NSToolbarItem.VisibilityPriority>> { return .name(ToolbarItem.Binding.visibilityPriority) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var action: ToolbarItemName<TargetAction> { return .name(ToolbarItem.Binding.action) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var validate: ToolbarItemName<(NSToolbarItem) -> Bool> { return .name(ToolbarItem.Binding.validate) }

	// Composite binding names
	static func action<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> ToolbarItemName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, ToolbarItem.Binding.action, Binding.toolbarItemBinding)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ToolbarItemConvertible {
	func nsToolbarItem() -> ToolbarItem.Instance
}
extension NSToolbarItem: ToolbarItemConvertible, TargetActionSender {
	public func nsToolbarItem() -> ToolbarItem.Instance { return self }
}
public extension ToolbarItem {
	func nsToolbarItem() -> ToolbarItem.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ToolbarItemBinding: BinderBaseBinding {
	static func toolbarItemBinding(_ binding: ToolbarItem.Binding) -> Self
}
public extension ToolbarItemBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return toolbarItemBinding(.inheritedBinding(binding))
	}
}
public extension ToolbarItem.Binding {
	typealias Preparer = ToolbarItem.Preparer
	static func toolbarItemBinding(_ binding: ToolbarItem.Binding) -> ToolbarItem.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
open class ToolbarItemTarget: SignalActionTarget {
	open var validator: ((NSToolbarItem) -> Bool)?
}

#endif
