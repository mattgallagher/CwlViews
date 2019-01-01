//
//  CwlToolbar_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 23/10/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class Toolbar: Binder, ToolbarConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}

	public convenience init(type: Instance.Type = Instance.self, identifier: NSToolbar.Identifier, _ bindings: Binding...) {
		self.init(type: type, parameters: identifier, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Toolbar {
	enum Binding: ToolbarBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static styles are applied at construction and are subsequently immutable.
		case itemDescriptions(Constant<[ToolbarItemDescription]>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsExtensionItems(Dynamic<Bool>)
		case allowsUserCustomization(Dynamic<Bool>)
		case autosavesConfiguration(Dynamic<Bool>)
		case displayMode(Dynamic<NSToolbar.DisplayMode>)
		case isVisible(Dynamic<Bool>)
		case selectedItemIdentifier(Dynamic<NSToolbarItem.Identifier>)
		case showsBaselineSeparator(Dynamic<Bool>)
		case sizeMode(Dynamic<NSToolbar.SizeMode>)

		// 2. Signal bindings are performed on the object after construction.
		case runCustomizationPalette(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didRemoveItem(SignalInput<Void>)
		case willAddItem(SignalInput<Void>)
	}
}

// MARK: - Binder Part 3: Preparer
public extension Toolbar {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = Toolbar.Binding
		public typealias Delegate = DynamicDelegate
		public typealias Inherited = BinderBase
		public typealias Instance = NSToolbar
		public typealias Parameters = NSToolbar.Identifier
		
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
		
		var itemDescriptions: [ToolbarItemDescription]?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Toolbar.Preparer {
	var delegateIsRequired: Bool { return true }
	
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		return type.init(identifier: parameters)
	}
	
	mutating func prepareBinding(_ binding: Toolbar.Binding) {
		switch binding {
		case .inheritedBinding(let s): inherited.prepareBinding(s)
		
		case .itemDescriptions(let x): itemDescriptions = x.value
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)
		if let id = itemDescriptions {
			storage.itemDescriptions = id
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .itemDescriptions:return nil

		// 1. Value bindings may be applied at construction and may subsequently change.
		case .displayMode(let x): return x.apply(instance) { i, v in i.displayMode = v }
		case .showsBaselineSeparator(let x): return x.apply(instance) { i, v in i.showsBaselineSeparator = v }
		case .allowsUserCustomization(let x): return x.apply(instance) { i, v in i.allowsUserCustomization = v }
		case .allowsExtensionItems(let x): return x.apply(instance) { i, v in i.allowsExtensionItems = v }
		case .sizeMode(let x): return x.apply(instance) { i, v in i.sizeMode = v }
		case .selectedItemIdentifier(let x): return x.apply(instance) { i, v in i.selectedItemIdentifier = v }
		case .isVisible(let x): return x.apply(instance) { i, v in i.isVisible = v }
		case .autosavesConfiguration(let x): return x.apply(instance) { i, v in i.autosavesConfiguration = v }
		
		// 2. Signal bindings are performed on the object after construction.
		case .runCustomizationPalette(let x): return x.apply(instance) { i, v in i.runCustomizationPalette(nil) }
		
		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .didRemoveItem(let x): return Signal.notifications(name: NSToolbar.didRemoveItemNotification, object: instance).map { _ in () }.cancellableBind(to: x)
		case .willAddItem(let x): return Signal.notifications(name: NSToolbar.willAddItemNotification, object: instance).map { _ in () }.cancellableBind(to: x)
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Toolbar.Preparer {
	open class Storage: ObjectBinderStorage, NSToolbarDelegate {
		open override var isInUse: Bool { return true }
		
		open var itemDescriptions: [ToolbarItemDescription] = []
		open func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
			return itemDescriptions.first { $0.identifier == itemIdentifier }?.constructor(itemIdentifier, flag)?.nsToolbarItem()
		}
		
		open var allowedItemIdentifiers: [NSToolbarItem.Identifier] = []
		open func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
			return itemDescriptions.filter { $0.isAllowed }.map { $0.identifier }
		}
		
		open var defaultItemIdentifiers: [NSToolbarItem.Identifier] = []
		open func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
			return itemDescriptions.filter { $0.isDefault }.map { $0.identifier }
		}
		
		open var selectableItemIdentifiers: [NSToolbarItem.Identifier] = []
		open func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
			return itemDescriptions.filter { $0.isSelectable }.map { $0.identifier }
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ToolbarBinding {
	public typealias ToolbarName<V> = BindingName<V, Toolbar.Binding, Binding>
	private typealias B = Toolbar.Binding
	private static func name<V>(_ source: @escaping (V) -> Toolbar.Binding) -> ToolbarName<V> {
		return ToolbarName<V>(source: source, downcast: Binding.toolbarBinding)
	}
}
public extension BindingName where Binding: ToolbarBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ToolbarName<$2> { return .name(B.$1) }

	//	0. Static styles are applied at construction and are subsequently immutable.
	static var itemDescriptions: ToolbarName<Constant<[ToolbarItemDescription]>> { return .name(B.itemDescriptions) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsExtensionItems: ToolbarName<Dynamic<Bool>> { return .name(B.allowsExtensionItems) }
	static var allowsUserCustomization: ToolbarName<Dynamic<Bool>> { return .name(B.allowsUserCustomization) }
	static var autosavesConfiguration: ToolbarName<Dynamic<Bool>> { return .name(B.autosavesConfiguration) }
	static var displayMode: ToolbarName<Dynamic<NSToolbar.DisplayMode>> { return .name(B.displayMode) }
	static var isVisible: ToolbarName<Dynamic<Bool>> { return .name(B.isVisible) }
	static var selectedItemIdentifier: ToolbarName<Dynamic<NSToolbarItem.Identifier>> { return .name(B.selectedItemIdentifier) }
	static var showsBaselineSeparator: ToolbarName<Dynamic<Bool>> { return .name(B.showsBaselineSeparator) }
	static var sizeMode: ToolbarName<Dynamic<NSToolbar.SizeMode>> { return .name(B.sizeMode) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var runCustomizationPalette: ToolbarName<Signal<Void>> { return .name(B.runCustomizationPalette) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var didRemoveItem: ToolbarName<SignalInput<Void>> { return .name(B.didRemoveItem) }
	static var willAddItem: ToolbarName<SignalInput<Void>> { return .name(B.willAddItem) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ToolbarConvertible {
	func nsToolbar() -> Toolbar.Instance
}
extension NSToolbar: ToolbarConvertible, DefaultConstructable, HasDelegate {
	public func nsToolbar() -> Toolbar.Instance { return self }
}
public extension Toolbar {
	public func nsToolbar() -> Toolbar.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ToolbarBinding: BinderBaseBinding {
	static func toolbarBinding(_ binding: Toolbar.Binding) -> Self
}
extension ToolbarBinding {
	public static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return toolbarBinding(.inheritedBinding(binding))
	}
}
public extension Toolbar.Binding {
	public typealias Preparer = Toolbar.Preparer
	static func toolbarBinding(_ binding: Toolbar.Binding) -> Toolbar.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct ToolbarItemDescription {
	public let identifier: NSToolbarItem.Identifier
	public let isDefault: Bool
	public let isAllowed: Bool
	public let isSelectable: Bool
	public let constructor: (_ itemIdentifier: NSToolbarItem.Identifier, _ willBeInserted: Bool) -> ToolbarItemConvertible?
	
	public init(identifier: NSToolbarItem.Identifier, isDefault: Bool = true, isAllowed: Bool = true, isSelectable: Bool = false, constructor: @escaping (_ itemIdentifier: NSToolbarItem.Identifier, _ willBeInserted: Bool) -> ToolbarItemConvertible?) {
		self.identifier = identifier
		self.isDefault = isDefault
		self.isAllowed = isAllowed
		self.isSelectable = isSelectable
		self.constructor = constructor
	}
}

#endif
