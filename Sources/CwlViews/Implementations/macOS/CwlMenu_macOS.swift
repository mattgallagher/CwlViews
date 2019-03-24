//
//  CwlMenu_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/30/16.
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
public class Menu: Binder, MenuConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Menu {
	enum Binding: MenuBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case systemName(Constant<SystemMenu>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsContextMenuPlugIns(Dynamic<Bool>)
		case autoenablesItems(Dynamic<Bool>)
		case font(Dynamic<NSFont>)
		case items(Dynamic<[MenuItemConvertible]>)
		case minimumWidth(Dynamic<CGFloat>)
		case showsStateColumn(Dynamic<Bool>)
		case title(Dynamic<String>)
		case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)

		// 2. Signal bindings are performed on the object after construction.
		case cancelTracking(Signal<Void>)
		case cancelTrackingWithoutAnimation(Signal<Void>)
		case performAction(Signal<Int>)
		case popUp(Signal<(item: Int, at: NSPoint, in: NSView?)>)
		case popUpContextMenu(Signal<(with: NSEvent, for: NSView)>)
		
		// 3. Action bindings are triggered by the object after construction.
		case didBeginTracking(SignalInput<Void>)
		case didEndTracking(SignalInput<Void>)
		case didSendAction(SignalInput<Int>)
		case willSendAction(SignalInput<Int>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case confinementRect((_ menu: NSMenu, _ screen: NSScreen?) -> NSRect)
		case didClose((_ menu: NSMenu) -> Void)
		case willHighlight((_ menu: NSMenu, _ item: NSMenuItem?, _ index: Int?) -> Void)
		case willOpen((_ menu: NSMenu) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension Menu {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = Menu.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSMenu
		
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

		var systemName: SystemMenu?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Menu.Preparer {
	func constructInstance(type: Instance.Type, parameters: Void) -> Instance {
		let x: NSMenu
		if let sn = systemName {
			let name = sn.rawValue
			let codingProxy = MenuCodingProxy(name: name)
			let data = NSMutableData()
			let archiver = NSKeyedArchiver(forWritingWith: data)
			archiver.setClassName(NSStringFromClass(type), for: MenuCodingProxy.self)
			archiver.outputFormat = .binary
			archiver.encode(codingProxy, forKey: NSKeyedArchiveRootObjectKey)
			archiver.finishEncoding()
			
			x = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? NSMenu ?? NSMenu()
		} else {
			x = type.init()
		}
		return x
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .confinementRect(let x): delegate().addSingleHandler2(x, #selector(NSMenuDelegate.confinementRect(for:on:)))
		case .didClose(let x): delegate().addMultiHandler1(x, #selector(NSMenuDelegate.menuDidClose(_:)))
		case .systemName(let x): systemName = x.value
		case .willHighlight(let x): delegate().addMultiHandler3(x, #selector(NSMenuDelegate.menu(_:willHighlight:)))
		case .willOpen(let x): delegate().addMultiHandler1(x, #selector(NSMenuDelegate.menuWillOpen(_:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .systemName: return nil
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowsContextMenuPlugIns(let x): return x.apply(instance) { i, v in i.allowsContextMenuPlugIns = v }
		case .autoenablesItems(let x): return x.apply(instance) { i, v in i.autoenablesItems = v }
		case .font(let x): return x.apply(instance) { i, v in i.font = v }
		case .items(let x):
			return x.apply(instance) { i, v in
				i.removeAllItems()
				v.forEach { i.addItem($0.nsMenuItem()) }
			}
		case .minimumWidth(let x): return x.apply(instance) { i, v in i.minimumWidth = v }
		case .showsStateColumn(let x): return x.apply(instance) { i, v in i.showsStateColumn = v }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .userInterfaceLayoutDirection(let x): return x.apply(instance) { i, v in i.userInterfaceLayoutDirection = v }
		
		// 2. Signal bindings are performed on the object after construction.
		case .cancelTracking(let x): return x.apply(instance) { i, v in i.cancelTracking() }
		case .cancelTrackingWithoutAnimation(let x): return x.apply(instance) { i, v in i.cancelTrackingWithoutAnimation() }
		case .performAction(let x): return x.apply(instance) { i, v in i.performActionForItem(at: v) }
		case .popUp(let x):
			return x.apply(instance) { i, v in
				let item = v.item >= 0 ? (i.items.at(v.item) ?? i.items.last) : i.items.first
				i.popUp(positioning: item, at: v.at, in: v.in)
			}
		case .popUpContextMenu(let x): return x.apply(instance) { i, v in NSMenu.popUpContextMenu(i, with: v.with, for: v.for) }
			
		// 3. Action bindings are triggered by the object after construction.
		case .didBeginTracking(let x):
			return Signal.notifications(name: NSMenu.didBeginTrackingNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didClose: return nil
		case .didEndTracking(let x):
			return Signal.notifications(name: NSMenu.didEndTrackingNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didSendAction(let x):
			return Signal.notifications(name: NSMenu.didSendActionNotification, object: instance).compactMap { n -> Int? in
				if let menuItem = n.userInfo?["MenuItem"] as? NSMenuItem, let menu = menuItem.menu, let index = menu.items.firstIndex(where: { i in i == menuItem }) {
					return index
				}
				return nil
				}.cancellableBind(to: x)
		case .willHighlight: return nil
		case .willOpen: return nil
		case .willSendAction(let x):
			return Signal.notifications(name: NSMenu.willSendActionNotification, object: instance).compactMap { n -> Int? in
				if let menuItem = n.userInfo?["MenuItem"] as? NSMenuItem, let menu = menuItem.menu, let index = menu.items.firstIndex(of: menuItem) {
					return index
				}
				return nil
			}.cancellableBind(to: x)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .confinementRect: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Menu.Preparer {
	open class Storage: AssociatedBinderStorage, NSMenuDelegate {}

	open class Delegate: DynamicDelegate, NSMenuDelegate {
		open func menuWillOpen(_ menu: NSMenu) {
			multiHandler(menu)
		}
		
		open func menuDidClose(_ menu: NSMenu) {
			multiHandler(menu)
		}
		
		open func confinementRect(for menu: NSMenu, on screen: NSScreen?) -> NSRect {
			return singleHandler(menu, screen)
		}
		
		open func menu(_ menu: NSMenu, willHighlight menuItem: NSMenuItem?) {
			let match = menuItem.flatMap { item in menu.items.enumerated().first { offset, element in item == element } }
			multiHandler(menu, menuItem, match?.offset)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: MenuBinding {
	public typealias MenuName<V> = BindingName<V, Menu.Binding, Binding>
	private typealias B = Menu.Binding
	private static func name<V>(_ source: @escaping (V) -> Menu.Binding) -> MenuName<V> {
		return MenuName<V>(source: source, downcast: Binding.menuBinding)
	}
}
public extension BindingName where Binding: MenuBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: MenuName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var systemName: MenuName<Constant<SystemMenu>> { return .name(B.systemName) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsContextMenuPlugIns: MenuName<Dynamic<Bool>> { return .name(B.allowsContextMenuPlugIns) }
	static var autoenablesItems: MenuName<Dynamic<Bool>> { return .name(B.autoenablesItems) }
	static var font: MenuName<Dynamic<NSFont>> { return .name(B.font) }
	static var items: MenuName<Dynamic<[MenuItemConvertible]>> { return .name(B.items) }
	static var minimumWidth: MenuName<Dynamic<CGFloat>> { return .name(B.minimumWidth) }
	static var showsStateColumn: MenuName<Dynamic<Bool>> { return .name(B.showsStateColumn) }
	static var title: MenuName<Dynamic<String>> { return .name(B.title) }
	static var userInterfaceLayoutDirection: MenuName<Dynamic<NSUserInterfaceLayoutDirection>> { return .name(B.userInterfaceLayoutDirection) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var popUpContextMenu: MenuName<Signal<(with: NSEvent, for: NSView)>> { return .name(B.popUpContextMenu) }
	static var popUp: MenuName<Signal<(item: Int, at: NSPoint, in: NSView?)>> { return .name(B.popUp) }
	static var performAction: MenuName<Signal<Int>> { return .name(B.performAction) }
	static var cancelTracking: MenuName<Signal<Void>> { return .name(B.cancelTracking) }
	static var cancelTrackingWithoutAnimation: MenuName<Signal<Void>> { return .name(B.cancelTrackingWithoutAnimation) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var willOpen: MenuName<(NSMenu) -> Void> { return .name(B.willOpen) }
	static var didClose: MenuName<(NSMenu) -> Void> { return .name(B.didClose) }
	static var didBeginTracking: MenuName<SignalInput<Void>> { return .name(B.didBeginTracking) }
	static var didEndTracking: MenuName<SignalInput<Void>> { return .name(B.didEndTracking) }
	static var willHighlight: MenuName<(NSMenu, NSMenuItem?, Int?) -> Void> { return .name(B.willHighlight) }
	static var willSendAction: MenuName<SignalInput<Int>> { return .name(B.willSendAction) }
	static var didSendAction: MenuName<SignalInput<Int>> { return .name(B.didSendAction) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var confinementRect: MenuName<(_ menu: NSMenu, _ screen: NSScreen?) -> NSRect> { return .name(B.confinementRect) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol MenuConvertible {
	func nsMenu() -> Menu.Instance
}
extension NSMenu: MenuConvertible, HasDelegate, DefaultConstructable {
	public func nsMenu() -> Menu.Instance { return self }
}
public extension Menu {
	func nsMenu() -> Menu.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol MenuBinding: BinderBaseBinding {
	static func menuBinding(_ binding: Menu.Binding) -> Self
}
public extension MenuBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return menuBinding(.inheritedBinding(binding))
	}
}
public extension Menu.Binding {
	typealias Preparer = Menu.Preparer
	static func menuBinding(_ binding: Menu.Binding) -> Menu.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public enum SystemMenu: String {
	case apple = "NSAppleMenu"
	case font = "NSFontMenu"
	case help = "NSHelpMenu"
	case recentDocuments = "NSRecentDocumentsMenu"
	case services = "NSServicesMenu"
	case windows = "NSWindowsMenu"
}

class MenuCodingProxy: NSObject, NSCoding {
	let name: String
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode("", forKey: "NSTitle")
		aCoder.encode(name, forKey: "NSName")
	 }

	init(name: String) {
		self.name = name
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		name = ""
		super.init()
	 }
}

#endif
