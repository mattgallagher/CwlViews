//
//  CwlMenu.swift
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

public class Menu: ConstructingBinder, MenuConvertible {
	public typealias Instance = NSMenu
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsMenu() -> Instance { return instance() }
	
	public enum Binding: MenuBinding {
		public typealias EnclosingBinder = Menu
		public static func menuBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case systemName(Constant<SystemMenu>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case items(Dynamic<[MenuItemConvertible]>)
		case title(Dynamic<String>)
		case autoenablesItems(Dynamic<Bool>)
		case minimumWidth(Dynamic<CGFloat>)
		case font(Dynamic<NSFont>)
		case allowsContextMenuPlugIns(Dynamic<Bool>)
		case showsStateColumn(Dynamic<Bool>)
		@available(macOS 10.11, *) case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)

		// 2. Signal bindings are performed on the object after construction.
		case popUpContextMenu(Signal<(with: NSEvent, for: NSView)>)
		case popUp(Signal<(item: Int, at: NSPoint, in: NSView?)>)
		case performAction(Signal<Int>)
		case cancelTracking(Signal<Void>)
		case cancelTrackingWithoutAnimation(Signal<Void>)
		
		// 3. Action bindings are triggered by the object after construction.
		case willOpen(SignalInput<Void>)
		case didClose(SignalInput<Void>)
		case didBeginTracking(SignalInput<Void>)
		case didEndTracking(SignalInput<Void>)
		case willHighlight(SignalInput<Int?>)
		case willSendAction(SignalInput<Int>)
		case didSendAction(SignalInput<Int>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case confinementRect((_ menu: NSMenu, _ screen: NSScreen?) -> NSRect)
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Menu
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			let x: NSMenu
			if let sn = systemName {
				let name = sn.rawValue
				let codingProxy = MenuCodingProxy(name: name)
				let data = NSMutableData()
				let archiver = NSKeyedArchiver(forWritingWith: data)
				archiver.setClassName(NSStringFromClass(NSMenu.self), for: MenuCodingProxy.self)
				archiver.outputFormat = .binary
				archiver.encode(codingProxy, forKey: NSKeyedArchiveRootObjectKey)
				archiver.finishEncoding()
				
				x = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? NSMenu ?? NSMenu()
			} else {
				x = subclass.init()
			}
			return x
		}
		
		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var possibleDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}

		public var systemName: SystemMenu?
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .systemName(let x): systemName = x.value
			case .willOpen:
				delegate().addSelector(#selector(NSMenuDelegate.menuWillOpen(_:)))
			case .didClose:
				delegate().addSelector(#selector(NSMenuDelegate.menuDidClose(_:)))
			case .confinementRect(let x):
				let s = #selector(NSMenuDelegate.confinementRect(for:on:))
				delegate().addSelector(s).confinement = x
			case .willHighlight:
				delegate().addSelector(#selector(NSMenuDelegate.menu(_:willHighlight:)))
			case .inheritedBinding(let preceeding): linkedPreparer.prepareBinding(preceeding)
			default: break
			}
		}

		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			// Don't steal the delegate from system menus
			if possibleDelegate != nil {
				precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
				storage.dynamicDelegate = possibleDelegate
				instance.delegate = storage
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .systemName: return nil
			case .willOpen(let x):
				if let d = possibleDelegate {
					let (input, signal) = Signal<Void>.create()
					d.willOpen = { input.send(value: ()) }
					return signal.cancellableBind(to: x)
				}
				return nil
			case .didClose(let x):
				if let d = possibleDelegate {
					let (input, signal) = Signal<Void>.create()
					d.didClose = { input.send(value: ()) }
					return signal.cancellableBind(to: x)
				}
				return nil
			case .willHighlight(let x):
				if let d = possibleDelegate {
					let (input, signal) = Signal<Int?>.create()
					d.willHighlight = { menu, isHighlighted in
						if let h = isHighlighted {
							for (index, item) in menu.items.enumerated() {
								if h == item {
									input.send(value: index)
									return
								}
							}
						}
						input.send(value: nil)
					}
					return signal.cancellableBind(to: x)
				}
				return nil
			case .items(let x):
				return x.apply(instance, storage) { i, s, v in
					i.removeAllItems()
					v.forEach { i.addItem($0.nsMenuItem()) }
				}
			case .title(let x): return x.apply(instance, storage) { i, s, v in i.title = v }
			case .autoenablesItems(let x): return x.apply(instance, storage) { i, s, v in i.autoenablesItems = v }
			case .minimumWidth(let x): return x.apply(instance, storage) { i, s, v in i.minimumWidth = v }
			case .font(let x): return x.apply(instance, storage) { i, s, v in i.font = v }
			case .allowsContextMenuPlugIns(let x): return x.apply(instance, storage) { i, s, v in i.allowsContextMenuPlugIns = v }
			case .showsStateColumn(let x): return x.apply(instance, storage) { i, s, v in i.showsStateColumn = v }
			case .userInterfaceLayoutDirection(let x):
				if #available(macOS 10.11, *) {
					return x.apply(instance, storage) { i, s, v in i.userInterfaceLayoutDirection = v }
				}
				return nil
			case .popUpContextMenu(let x): return x.apply(instance, storage) { i, s, v in NSMenu.popUpContextMenu(i, with: v.with, for: v.for) }
			case .popUp(let x):
				return x.apply(instance, storage) { i, s, v in
					let item = v.item >= 0 ? (i.items.at(v.item) ?? i.items.last) : i.items.first
					i.popUp(positioning: item, at: v.at, in: v.in)
				}
			case .performAction(let x):
				return x.apply(instance, storage) { i, s, v in
					i.performActionForItem(at: v)
				}
			case .cancelTracking(let x): return x.apply(instance, storage) { i, s, v in i.cancelTracking() }
			case .cancelTrackingWithoutAnimation(let x): return x.apply(instance, storage) { i, s, v in i.cancelTrackingWithoutAnimation() }
			case .didBeginTracking(let x):
				return Signal.notifications(name: NSMenu.didBeginTrackingNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didEndTracking(let x):
				return Signal.notifications(name: NSMenu.didEndTrackingNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willSendAction(let x):
				return Signal.notifications(name: NSMenu.willSendActionNotification, object: instance).compactMap { n -> Int? in
					if let menuItem = n.userInfo?["MenuItem"] as? NSMenuItem, let menu = menuItem.menu, let index = menu.items.index(where: { i in i == menuItem }) {
						return index
					}
					return nil
					}.cancellableBind(to: x)
			case .didSendAction(let x):
				return Signal.notifications(name: NSMenu.didSendActionNotification, object: instance).compactMap { n -> Int? in
					if let menuItem = n.userInfo?["MenuItem"] as? NSMenuItem, let menu = menuItem.menu, let index = menu.items.index(where: { i in i == menuItem }) {
						return index
					}
					return nil
				}.cancellableBind(to: x)
			case .confinementRect:
				return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ObjectBinderStorage, NSMenuDelegate {}

	open class Delegate: DynamicDelegate, NSMenuDelegate {
		public required override init() {
			super.init()
		}
		
		open var willOpen: (() -> Void)?
		open func menuWillOpen(_ menu: NSMenu) {
			return willOpen!()
		}
		
		open var didClose: (() -> Void)?
		open func menuDidClose(_ menu: NSMenu) {
			return didClose!()
		}
		
		open var confinement: ((NSMenu, NSScreen?) -> NSRect)?
		open func confinementRect(for menu: NSMenu, on screen: NSScreen?) -> NSRect {
			return confinement!(menu, screen)
		}
		
		open var willHighlight: ((NSMenu, NSMenuItem?) -> Void)?
		open func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
			return willHighlight!(menu, item)
		}
	}
}

extension BindingName where Binding: MenuBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .menuBinding(Menu.Binding.$1(v)) }) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var systemName: BindingName<Constant<SystemMenu>, Binding> { return BindingName<Constant<SystemMenu>, Binding>({ v in .menuBinding(Menu.Binding.systemName(v)) }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var items: BindingName<Dynamic<[MenuItemConvertible]>, Binding> { return BindingName<Dynamic<[MenuItemConvertible]>, Binding>({ v in .menuBinding(Menu.Binding.items(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .menuBinding(Menu.Binding.title(v)) }) }
	public static var autoenablesItems: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .menuBinding(Menu.Binding.autoenablesItems(v)) }) }
	public static var minimumWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .menuBinding(Menu.Binding.minimumWidth(v)) }) }
	public static var font: BindingName<Dynamic<NSFont>, Binding> { return BindingName<Dynamic<NSFont>, Binding>({ v in .menuBinding(Menu.Binding.font(v)) }) }
	public static var allowsContextMenuPlugIns: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .menuBinding(Menu.Binding.allowsContextMenuPlugIns(v)) }) }
	public static var showsStateColumn: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .menuBinding(Menu.Binding.showsStateColumn(v)) }) }
	@available(macOS 10.11, *) public static var userInterfaceLayoutDirection: BindingName<Dynamic<NSUserInterfaceLayoutDirection>, Binding> { return BindingName<Dynamic<NSUserInterfaceLayoutDirection>, Binding>({ v in .menuBinding(Menu.Binding.userInterfaceLayoutDirection(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var popUpContextMenu: BindingName<Signal<(with: NSEvent, for: NSView)>, Binding> { return BindingName<Signal<(with: NSEvent, for: NSView)>, Binding>({ v in .menuBinding(Menu.Binding.popUpContextMenu(v)) }) }
	public static var popUp: BindingName<Signal<(item: Int, at: NSPoint, in: NSView?)>, Binding> { return BindingName<Signal<(item: Int, at: NSPoint, in: NSView?)>, Binding>({ v in .menuBinding(Menu.Binding.popUp(v)) }) }
	public static var performAction: BindingName<Signal<Int>, Binding> { return BindingName<Signal<Int>, Binding>({ v in .menuBinding(Menu.Binding.performAction(v)) }) }
	public static var cancelTracking: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .menuBinding(Menu.Binding.cancelTracking(v)) }) }
	public static var cancelTrackingWithoutAnimation: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .menuBinding(Menu.Binding.cancelTrackingWithoutAnimation(v)) }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var willOpen: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .menuBinding(Menu.Binding.willOpen(v)) }) }
	public static var didClose: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .menuBinding(Menu.Binding.didClose(v)) }) }
	public static var didBeginTracking: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .menuBinding(Menu.Binding.didBeginTracking(v)) }) }
	public static var didEndTracking: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .menuBinding(Menu.Binding.didEndTracking(v)) }) }
	public static var willHighlight: BindingName<SignalInput<Int?>, Binding> { return BindingName<SignalInput<Int?>, Binding>({ v in .menuBinding(Menu.Binding.willHighlight(v)) }) }
	public static var willSendAction: BindingName<SignalInput<Int>, Binding> { return BindingName<SignalInput<Int>, Binding>({ v in .menuBinding(Menu.Binding.willSendAction(v)) }) }
	public static var didSendAction: BindingName<SignalInput<Int>, Binding> { return BindingName<SignalInput<Int>, Binding>({ v in .menuBinding(Menu.Binding.didSendAction(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var confinementRect: BindingName<(_ menu: NSMenu, _ screen: NSScreen?) -> NSRect, Binding> { return BindingName<(_ menu: NSMenu, _ screen: NSScreen?) -> NSRect, Binding>({ v in .menuBinding(Menu.Binding.confinementRect(v)) }) }
}

public protocol MenuConvertible {
	func nsMenu() -> Menu.Instance
}
extension Menu.Instance: MenuConvertible {
	public func nsMenu() -> Menu.Instance { return self }
}

public protocol MenuBinding: BaseBinding {
	static func menuBinding(_ binding: Menu.Binding) -> Self
}
extension MenuBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return menuBinding(.inheritedBinding(binding))
	}
}

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
