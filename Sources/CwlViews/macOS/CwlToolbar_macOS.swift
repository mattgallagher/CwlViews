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

public class Toolbar: Binder, ToolbarConvertible {
	public typealias Instance = NSToolbar
	public typealias Inherited = BaseBinder
	
	public var state: BinderState<Instance, BinderAdditionalParameters<Instance, Binding, NSToolbar.Identifier>>
	public required init(state: BinderState<Instance, BinderAdditionalParameters<Instance, Binding, NSToolbar.Identifier>>) {
		self.state = state
	}
	public init(subclass: Instance.Type = Instance.self, identifier: NSToolbar.Identifier, bindings: [Binding]) {
		state = .pending(BinderAdditionalParameters(subclass: subclass, additional: identifier, bindings: bindings))
	}
	public init(subclass: Instance.Type = Instance.self, identifier: NSToolbar.Identifier, _ bindings: Binding...) {
		state = .pending(BinderAdditionalParameters(subclass: subclass, additional: identifier, bindings: bindings))
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func instance(additional: ((Instance) -> Lifetime?)? = nil) -> Instance {
		return binderConstruct(
			additional: additional,
			storageConstructor: { prep, params, i in prep.constructStorage() },
			instanceConstructor: { prep, params in prep.constructInstance(subclass: params.subclass, identifier: params.additional) },
			combine: embedStorageIfInUse,
			output: { i, s in i })
	}
	public func nsToolbar() -> Instance { return instance() }
	
	enum Binding: ToolbarBinding {
		public typealias EnclosingBinder = Toolbar
		public static func toolbarBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static styles are applied at construction and are subsequently immutable.
		case itemDescriptions(Constant<[ToolbarItemDescription]>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case displayMode(Dynamic<NSToolbar.DisplayMode>)
		case showsBaselineSeparator(Dynamic<Bool>)
		case allowsUserCustomization(Dynamic<Bool>)
		case allowsExtensionItems(Dynamic<Bool>)
		case sizeMode(Dynamic<NSToolbar.SizeMode>)
		case selectedItemIdentifier(Dynamic<NSToolbarItem.Identifier>)
		case isVisible(Dynamic<Bool>)
		case autosavesConfiguration(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case runCustomizationPalette(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didRemoveItem(SignalInput<Void>)
		case willAddItem(SignalInput<Void>)
	}

	struct Preparer: StoragePreparer {
		public typealias EnclosingBinder = Toolbar
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type, identifier: NSToolbar.Identifier) -> EnclosingBinder.Instance { return subclass.init(identifier: identifier) }
		
		public init() {}

		public func prepareInstance(_ instance: Instance, storage: Storage) {
			// Toolbar delegate is mandatory
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			instance.delegate = storage

			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .displayMode(let x): return x.apply(instance) { i, v in i.displayMode = v }
			case .showsBaselineSeparator(let x): return x.apply(instance) { i, v in i.showsBaselineSeparator = v }
			case .allowsUserCustomization(let x): return x.apply(instance) { i, v in i.allowsUserCustomization = v }
			case .allowsExtensionItems(let x): return x.apply(instance) { i, v in i.allowsExtensionItems = v }
			case .sizeMode(let x): return x.apply(instance) { i, v in i.sizeMode = v }
			case .selectedItemIdentifier(let x): return x.apply(instance) { i, v in i.selectedItemIdentifier = v }
			case .isVisible(let x): return x.apply(instance) { i, v in i.isVisible = v }
			case .autosavesConfiguration(let x): return x.apply(instance) { i, v in i.autosavesConfiguration = v }
			case .itemDescriptions(let x):
				storage.itemDescriptions = x.value
				return nil
			case .runCustomizationPalette(let x): return x.apply(instance) { i, v in i.runCustomizationPalette(nil) }
			case .didRemoveItem(let x):
				return Signal.notifications(name: NSToolbar.didRemoveItemNotification, object: instance).map { _ in () }.cancellableBind(to: x)
			case .willAddItem(let x):
				return Signal.notifications(name: NSToolbar.willAddItemNotification, object: instance).map { _ in () }.cancellableBind(to: x)
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ObjectBinderStorage, NSToolbarDelegate {
		open override var inUse: Bool { return true }
		
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

extension BindingName where Binding: ToolbarBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .toolbarBinding(Toolbar.Binding.$1(v)) }) }

	//	0. Static styles are applied at construction and are subsequently immutable.
	public static var itemDescriptions: BindingName<Constant<[ToolbarItemDescription]>, Binding> { return BindingName<Constant<[ToolbarItemDescription]>, Binding>({ v in .toolbarBinding(Toolbar.Binding.itemDescriptions(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var displayMode: BindingName<Dynamic<NSToolbar.DisplayMode>, Binding> { return BindingName<Dynamic<NSToolbar.DisplayMode>, Binding>({ v in .toolbarBinding(Toolbar.Binding.displayMode(v)) }) }
	public static var showsBaselineSeparator: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .toolbarBinding(Toolbar.Binding.showsBaselineSeparator(v)) }) }
	public static var allowsUserCustomization: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .toolbarBinding(Toolbar.Binding.allowsUserCustomization(v)) }) }
	public static var allowsExtensionItems: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .toolbarBinding(Toolbar.Binding.allowsExtensionItems(v)) }) }
	public static var sizeMode: BindingName<Dynamic<NSToolbar.SizeMode>, Binding> { return BindingName<Dynamic<NSToolbar.SizeMode>, Binding>({ v in .toolbarBinding(Toolbar.Binding.sizeMode(v)) }) }
	public static var selectedItemIdentifier: BindingName<Dynamic<NSToolbarItem.Identifier>, Binding> { return BindingName<Dynamic<NSToolbarItem.Identifier>, Binding>({ v in .toolbarBinding(Toolbar.Binding.selectedItemIdentifier(v)) }) }
	public static var isVisible: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .toolbarBinding(Toolbar.Binding.isVisible(v)) }) }
	public static var autosavesConfiguration: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .toolbarBinding(Toolbar.Binding.autosavesConfiguration(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var runCustomizationPalette: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .toolbarBinding(Toolbar.Binding.runCustomizationPalette(v)) }) }

	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didRemoveItem: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .toolbarBinding(Toolbar.Binding.didRemoveItem(v)) }) }
	public static var willAddItem: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .toolbarBinding(Toolbar.Binding.willAddItem(v)) }) }
}

public protocol ToolbarConvertible {
	func nsToolbar() -> Toolbar.Instance
}
extension Toolbar.Instance: ToolbarConvertible {
	public func nsToolbar() -> Toolbar.Instance { return self }
}

public protocol ToolbarBinding: BaseBinding {
	static func toolbarBinding(_ binding: Toolbar.Binding) -> Self
}
extension ToolbarBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return toolbarBinding(.inheritedBinding(binding))
	}
}

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
