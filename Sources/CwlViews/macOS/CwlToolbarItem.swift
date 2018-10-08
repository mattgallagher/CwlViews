//
//  CwlToolbarItem.swift
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

public class ToolbarItem: Binder, ToolbarItemConvertible {
	public typealias Instance = NSToolbarItem
	public typealias Inherited = BaseBinder
	
	public var state: BinderState<Instance, BinderAdditionalParameters<Instance, Binding, NSToolbarItem.Identifier>>
	public required init(state: BinderState<Instance, BinderAdditionalParameters<Instance, Binding, NSToolbarItem.Identifier>>) {
		self.state = state
	}
	public init(subclass: Instance.Type = Instance.self, itemIdentifier: NSToolbarItem.Identifier, bindings: [Binding]) {
		state = .pending(BinderAdditionalParameters(subclass: subclass, additional: itemIdentifier, bindings: bindings))
	}
	public init(subclass: Instance.Type = Instance.self, itemIdentifier: NSToolbarItem.Identifier, _ bindings: Binding...) {
		state = .pending(BinderAdditionalParameters(subclass: subclass, additional: itemIdentifier, bindings: bindings))
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func instance(additional: ((Instance) -> Lifetime?)? = nil) -> Instance {
		return binderConstruct(
			additional: additional,
			storageConstructor: { prep, params, i in prep.constructStorage() },
			instanceConstructor: { prep, params in prep.constructInstance(subclass: params.subclass, itemIdentifier: params.additional) },
			combine: embedStorageIfInUse,
			output: { i, s in i })
	}
	public func nsToolbarItem() -> Instance { return instance() }
	
	public enum Binding: ToolbarItemBinding {
		public typealias EnclosingBinder = ToolbarItem
		public static func toolbarItemBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case label(Dynamic<String>)
		case paletteLabel(Dynamic<String>)
		case toolTip(Dynamic<String?>)
		case tag(Dynamic<Int>)
		case isEnabled(Dynamic<Bool>)
		case image(Dynamic<NSImage?>)
		case minSize(Dynamic<NSSize>)
		case maxSize(Dynamic<NSSize>)
		case visibilityPriority(Dynamic<NSToolbarItem.VisibilityPriority>)
		case menuFormRepresentation(Dynamic<MenuItemConvertible>)
		case view(Dynamic<ViewConvertible?>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case action(TargetAction)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case validate((NSToolbarItem) -> Bool)
	}

	public struct Preparer: StoragePreparer {
		public typealias EnclosingBinder = ToolbarItem
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type, itemIdentifier: NSToolbarItem.Identifier) -> EnclosingBinder.Instance { return subclass.init(itemIdentifier: itemIdentifier) }
		
		public init() {}

		var validator: ((NSToolbarItem) -> Bool)?
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .validate(let x): validator = x
			case .inheritedBinding(let preceeding): linkedPreparer.prepareBinding(preceeding)
			default: break
			}
		}

		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .label(let x): return x.apply(instance, storage) { i, s, v in i.label = v }
			case .paletteLabel(let x): return x.apply(instance, storage) { i, s, v in i.paletteLabel = v }
			case .toolTip(let x): return x.apply(instance, storage) { i, s, v in i.toolTip = v }
			case .tag(let x): return x.apply(instance, storage) { i, s, v in i.tag = v }
			case .isEnabled(let x): return x.apply(instance, storage) { i, s, v in i.isEnabled = v }
			case .image(let x): return x.apply(instance, storage) { i, s, v in i.image = v }
			case .minSize(let x): return x.apply(instance, storage) { i, s, v in i.minSize = v }
			case .maxSize(let x): return x.apply(instance, storage) { i, s, v in i.maxSize = v }
			case .visibilityPriority(let x): return x.apply(instance, storage) { i, s, v in i.visibilityPriority = v }
			case .action(let x): return x.apply(instance: instance, constructTarget: ToolbarItemTarget.init, processor: { _ in () })
			case .menuFormRepresentation(let x): return x.apply(instance, storage) { i, s, v in i.menuFormRepresentation = v.nsMenuItem() }
			case .view(let x): return x.apply(instance, storage) { i, s, v in i.view = v?.nsView() }
			case .validate: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
		
		public mutating func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
			let lifetime = linkedPreparer.finalizeInstance(instance, storage: storage)

			// Need to apply the validator *after* the action exists
			if let v = validator, let target = instance.target as? ToolbarItemTarget {
				target.validator = v
			}
			return lifetime
		}
	}

	public typealias Storage = ObjectBinderStorage
}

extension BindingName where Binding: ToolbarItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var label: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.label(v)) }) }
	public static var paletteLabel: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.paletteLabel(v)) }) }
	public static var toolTip: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.toolTip(v)) }) }
	public static var tag: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.tag(v)) }) }
	public static var isEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.isEnabled(v)) }) }
	public static var image: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.image(v)) }) }
	public static var minSize: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.minSize(v)) }) }
	public static var maxSize: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.maxSize(v)) }) }
	public static var visibilityPriority: BindingName<Dynamic<NSToolbarItem.VisibilityPriority>, Binding> { return BindingName<Dynamic<NSToolbarItem.VisibilityPriority>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.visibilityPriority(v)) }) }
	public static var menuFormRepresentation: BindingName<Dynamic<MenuItemConvertible>, Binding> { return BindingName<Dynamic<MenuItemConvertible>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.menuFormRepresentation(v)) }) }
	public static var view: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.view(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.action(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var validate: BindingName<(NSToolbarItem) -> Bool, Binding> { return BindingName<(NSToolbarItem) -> Bool, Binding>({ v in .toolbarItemBinding(ToolbarItem.Binding.validate(v)) }) }
}

public protocol ToolbarItemConvertible {
	func nsToolbarItem() -> ToolbarItem.Instance
}
extension ToolbarItem.Instance: ToolbarItemConvertible {
	public func nsToolbarItem() -> ToolbarItem.Instance { return self }
}

public protocol ToolbarItemBinding: BaseBinding {
	static func toolbarItemBinding(_ binding: ToolbarItem.Binding) -> Self
}
extension ToolbarItemBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return toolbarItemBinding(.inheritedBinding(binding))
	}
}

extension NSToolbarItem: TargetActionSender {}

open class ToolbarItemTarget: SignalActionTarget {
	open var validator: ((NSToolbarItem) -> Bool)?
}
