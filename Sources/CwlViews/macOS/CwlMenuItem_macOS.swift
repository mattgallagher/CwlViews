//
//  CwlMenuItem_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 28/10/2015.
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
public class MenuItem: Binder, MenuItemConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension MenuItem {
	enum Binding: MenuItemBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case isEnabled(Dynamic<Bool>)
		case isHidden(Dynamic<Bool>)
		case isAlternate(Dynamic<Bool>)
		case title(Dynamic<String>)
		case attributedTitle(Dynamic<NSAttributedString?>)
		case tag(Dynamic<Int>)
		case representedObject(Dynamic<AnyObject?>)
		case state(Dynamic<NSControl.StateValue>)
		case indentationLevel(Dynamic<Int>)
		case image(Dynamic<NSImage?>)
		case onStateImage(Dynamic<NSImage?>)
		case offStateImage(Dynamic<NSImage?>)
		case mixedStateImage(Dynamic<NSImage?>)
		case submenu(Dynamic<MenuConvertible?>)
		case keyEquivalent(Dynamic<String>)
		case keyEquivalentModifierMask(Dynamic<NSEvent.ModifierFlags>)
		case toolTip(Dynamic<String?>)
		case view(Dynamic<ViewConvertible?>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case action(TargetAction)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension MenuItem {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = MenuItem.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSMenuItem
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension MenuItem.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .attributedTitle(let x): return x.apply(instance) { i, v in i.attributedTitle = v }
		case .image(let x): return x.apply(instance) { i, v in i.image = v }
		case .indentationLevel(let x): return x.apply(instance) { i, v in i.indentationLevel = v }
		case .isAlternate(let x): return x.apply(instance) { i, v in i.isAlternate = v }
		case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }
		case .isHidden(let x): return x.apply(instance) { i, v in i.isHidden = v }
		case .keyEquivalent(let x): return x.apply(instance) { i, v in i.keyEquivalent = v }
		case .keyEquivalentModifierMask(let x): return x.apply(instance) { i, v in i.keyEquivalentModifierMask = v }
		case .mixedStateImage(let x): return x.apply(instance) { i, v in i.mixedStateImage = v }
		case .offStateImage(let x): return x.apply(instance) { i, v in i.offStateImage = v }
		case .onStateImage(let x): return x.apply(instance) { i, v in i.onStateImage = v }
		case .representedObject(let x): return x.apply(instance) { i, v in i.representedObject = v }
		case .state(let x): return x.apply(instance) { i, v in i.state = v }
		case .submenu(let x): return x.apply(instance) { i, v in i.submenu = v?.nsMenu() }
		case .tag(let x): return x.apply(instance) { i, v in i.tag = v }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .toolTip(let x): return x.apply(instance) { i, v in i.toolTip = v }
		case .view(let x): return x.apply(instance) { i, v in i.view = v?.nsView() }

		// 2. Signal bindings are performed on the object after construction.
			
		// 3. Action bindings are triggered by the object after construction.
		case .action(let x): return x.apply(to: instance, constructTarget: SignalActionTarget.init)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension MenuItem.Preparer {
	public typealias Storage = ObjectBinderStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: MenuItemBinding {
	public typealias MenuItemName<V> = BindingName<V, MenuItem.Binding, Binding>
	private typealias B = MenuItem.Binding
	private static func name<V>(_ source: @escaping (V) -> MenuItem.Binding) -> MenuItemName<V> {
		return MenuItemName<V>(source: source, downcast: Binding.menuItemBinding)
	}
}
public extension BindingName where Binding: MenuItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: MenuItemName<$2> { return .name(B.$1) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var isEnabled: MenuItemName<Dynamic<Bool>> { return .name(B.isEnabled) }
	static var isHidden: MenuItemName<Dynamic<Bool>> { return .name(B.isHidden) }
	static var isAlternate: MenuItemName<Dynamic<Bool>> { return .name(B.isAlternate) }
	static var title: MenuItemName<Dynamic<String>> { return .name(B.title) }
	static var attributedTitle: MenuItemName<Dynamic<NSAttributedString?>> { return .name(B.attributedTitle) }
	static var tag: MenuItemName<Dynamic<Int>> { return .name(B.tag) }
	static var representedObject: MenuItemName<Dynamic<AnyObject?>> { return .name(B.representedObject) }
	static var state: MenuItemName<Dynamic<NSControl.StateValue>> { return .name(B.state) }
	static var indentationLevel: MenuItemName<Dynamic<Int>> { return .name(B.indentationLevel) }
	static var image: MenuItemName<Dynamic<NSImage?>> { return .name(B.image) }
	static var onStateImage: MenuItemName<Dynamic<NSImage?>> { return .name(B.onStateImage) }
	static var offStateImage: MenuItemName<Dynamic<NSImage?>> { return .name(B.offStateImage) }
	static var mixedStateImage: MenuItemName<Dynamic<NSImage?>> { return .name(B.mixedStateImage) }
	static var submenu: MenuItemName<Dynamic<MenuConvertible?>> { return .name(B.submenu) }
	static var keyEquivalent: MenuItemName<Dynamic<String>> { return .name(B.keyEquivalent) }
	static var keyEquivalentModifierMask: MenuItemName<Dynamic<NSEvent.ModifierFlags>> { return .name(B.keyEquivalentModifierMask) }
	static var toolTip: MenuItemName<Dynamic<String?>> { return .name(B.toolTip) }
	static var view: MenuItemName<Dynamic<ViewConvertible?>> { return .name(B.view) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var action: MenuItemName<TargetAction> { return .name(B.action) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.

	// Composite binding names
	public static func action<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> MenuItemName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, MenuItem.Binding.action, Binding.menuItemBinding)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol MenuItemConvertible {
	func nsMenuItem() -> MenuItem.Instance
}
extension NSMenuItem: MenuItemConvertible, DefaultConstructable, TargetActionSender {
	public func nsMenuItem() -> MenuItem.Instance { return self }
}
public extension MenuItem {
	func nsMenuItem() -> MenuItem.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol MenuItemBinding: BinderBaseBinding {
	static func menuItemBinding(_ binding: MenuItem.Binding) -> Self
}
public extension MenuItemBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return menuItemBinding(.inheritedBinding(binding))
	}
}
public extension MenuItem.Binding {
	public typealias Preparer = MenuItem.Preparer
	static func menuItemBinding(_ binding: MenuItem.Binding) -> MenuItem.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
