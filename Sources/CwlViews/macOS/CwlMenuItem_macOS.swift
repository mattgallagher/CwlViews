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

public class MenuItem: ConstructingBinder, MenuItemConvertible {
	public typealias Instance = NSMenuItem
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
   public func nsMenuItem() -> Instance { return instance() }
	
	public enum Binding: MenuItemBinding {
		public typealias EnclosingBinder = MenuItem
		public static func menuItemBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
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

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = MenuItem
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .isEnabled(let x): return x.apply(instance, storage) { i, s, v in i.isEnabled = v }
			case .isHidden(let x): return x.apply(instance, storage) { i, s, v in i.isHidden = v }
			case .isAlternate(let x): return x.apply(instance, storage) { i, s, v in i.isAlternate = v }
			case .title(let x): return x.apply(instance, storage) { i, s, v in i.title = v }
			case .attributedTitle(let x): return x.apply(instance, storage) { i, s, v in i.attributedTitle = v }
			case .representedObject(let x): return x.apply(instance, storage) { i, s, v in i.representedObject = v }
			case .tag(let x): return x.apply(instance, storage) { i, s, v in i.tag = v }
			case .state(let x): return x.apply(instance, storage) { i, s, v in i.state = v }
			case .indentationLevel(let x): return x.apply(instance, storage) { i, s, v in i.indentationLevel = v }
			case .image(let x): return x.apply(instance, storage) { i, s, v in i.image = v }
			case .onStateImage(let x): return x.apply(instance, storage) { i, s, v in i.onStateImage = v }
			case .offStateImage(let x): return x.apply(instance, storage) { i, s, v in i.offStateImage = v }
			case .mixedStateImage(let x): return x.apply(instance, storage) { i, s, v in i.mixedStateImage = v }
			case .submenu(let x): return x.apply(instance, storage) { i, s, v in i.submenu = v?.nsMenu() }
			case .keyEquivalent(let x): return x.apply(instance, storage) { i, s, v in i.keyEquivalent = v }
			case .keyEquivalentModifierMask(let x): return x.apply(instance, storage) { i, s, v in i.keyEquivalentModifierMask = v }
			case .toolTip(let x): return x.apply(instance, storage) { i, s, v in i.toolTip = v }
			case .view(let x): return x.apply(instance, storage) { i, s, v in i.view = v?.nsView() }
			case .action(let x):
				return x.apply(instance: instance, constructTarget: SignalActionTarget.init) { sender -> (Int, Any?) in
					guard let menuItem = sender as? NSMenuItem else { return (-1, nil) }
					return (menuItem.tag, menuItem.representedObject)
				}
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = ObjectBinderStorage
}

extension BindingName where Binding: MenuItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .menuItemBinding(MenuItem.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .menuItemBinding(MenuItem.Binding.isEnabled(v)) }) }
	public static var isHidden: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .menuItemBinding(MenuItem.Binding.isHidden(v)) }) }
	public static var isAlternate: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .menuItemBinding(MenuItem.Binding.isAlternate(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .menuItemBinding(MenuItem.Binding.title(v)) }) }
	public static var attributedTitle: BindingName<Dynamic<NSAttributedString?>, Binding> { return BindingName<Dynamic<NSAttributedString?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.attributedTitle(v)) }) }
	public static var tag: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .menuItemBinding(MenuItem.Binding.tag(v)) }) }
	public static var representedObject: BindingName<Dynamic<AnyObject?>, Binding> { return BindingName<Dynamic<AnyObject?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.representedObject(v)) }) }
	public static var state: BindingName<Dynamic<NSControl.StateValue>, Binding> { return BindingName<Dynamic<NSControl.StateValue>, Binding>({ v in .menuItemBinding(MenuItem.Binding.state(v)) }) }
	public static var indentationLevel: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .menuItemBinding(MenuItem.Binding.indentationLevel(v)) }) }
	public static var image: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.image(v)) }) }
	public static var onStateImage: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.onStateImage(v)) }) }
	public static var offStateImage: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.offStateImage(v)) }) }
	public static var mixedStateImage: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.mixedStateImage(v)) }) }
	public static var submenu: BindingName<Dynamic<MenuConvertible?>, Binding> { return BindingName<Dynamic<MenuConvertible?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.submenu(v)) }) }
	public static var keyEquivalent: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .menuItemBinding(MenuItem.Binding.keyEquivalent(v)) }) }
	public static var keyEquivalentModifierMask: BindingName<Dynamic<NSEvent.ModifierFlags>, Binding> { return BindingName<Dynamic<NSEvent.ModifierFlags>, Binding>({ v in .menuItemBinding(MenuItem.Binding.keyEquivalentModifierMask(v)) }) }
	public static var toolTip: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.toolTip(v)) }) }
	public static var view: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .menuItemBinding(MenuItem.Binding.view(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .menuItemBinding(MenuItem.Binding.action(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol MenuItemConvertible {
	func nsMenuItem() -> MenuItem.Instance
}
extension MenuItem.Instance: MenuItemConvertible {
	public func nsMenuItem() -> MenuItem.Instance { return self }
}

public protocol MenuItemBinding: BaseBinding {
	static func menuItemBinding(_ binding: MenuItem.Binding) -> Self
}
extension MenuItemBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return menuItemBinding(.inheritedBinding(binding))
	}
}

extension NSMenuItem: TargetActionSender {}

#endif
