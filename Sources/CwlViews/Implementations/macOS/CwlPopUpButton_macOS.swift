//
//  CwlPopUpButton_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/20.
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

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class PopUpButton: Binder, PopUpButtonConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension PopUpButton {
	enum Binding: PopUpButtonBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case autoenablesItems(Dynamic<Bool>)
		case menu(Dynamic<MenuConvertible>)
		case preferredEdge(Dynamic<NSRectEdge>)
		case pullsDown(Dynamic<Bool>)
		case selectedIndex(Dynamic<Int>)
		case title(Dynamic<String>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case willPopUp(SignalInput<Void>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension PopUpButton {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = PopUpButton.Binding
		public typealias Inherited = Button.Preparer
		public typealias Instance = NSPopUpButton
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var pullsDown = InitialSubsequent<Bool>()
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension PopUpButton.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .pullsDown(let x): pullsDown = x.initialSubsequent()
		default: break
		}
	}
	
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		return type.init(frame: NSRect.zero, pullsDown: pullsDown.initial ?? false)
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .autoenablesItems(let x): return x.apply(instance) { i, v in i.autoenablesItems = v }
		case .menu(let x): return x.apply(instance) { i, v in i.menu = v.nsMenu() }
		case .preferredEdge(let x): return x.apply(instance) { i, v in i.preferredEdge = v }
		case .pullsDown: return pullsDown.resume()?.apply(instance) { i, v in i.pullsDown = v }
		case .selectedIndex(let x): return x.apply(instance) { i, v in i.selectItem(at: v) }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case .willPopUp(let x): return Signal.notifications(name: NSPopUpButton.willPopUpNotification, object: instance).map { n in return () }.cancellableBind(to: x)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PopUpButton.Preparer {
	public typealias Storage = Button.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: PopUpButtonBinding {
	public typealias PopUpButtonName<V> = BindingName<V, PopUpButton.Binding, Binding>
	private typealias B = PopUpButton.Binding
	private static func name<V>(_ source: @escaping (V) -> PopUpButton.Binding) -> PopUpButtonName<V> {
		return PopUpButtonName<V>(source: source, downcast: Binding.popUpButtonBinding)
	}
}
public extension BindingName where Binding: PopUpButtonBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: PopUpButtonName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var autoenablesItems: PopUpButtonName<Dynamic<Bool>> { return .name(B.autoenablesItems) }
	static var menu: PopUpButtonName<Dynamic<MenuConvertible>> { return .name(B.menu) }
	static var preferredEdge: PopUpButtonName<Dynamic<NSRectEdge>> { return .name(B.preferredEdge) }
	static var pullsDown: PopUpButtonName<Dynamic<Bool>> { return .name(B.pullsDown) }
	static var selectedIndex: PopUpButtonName<Dynamic<Int>> { return .name(B.selectedIndex) }
	static var title: PopUpButtonName<Dynamic<String>> { return .name(B.title) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var willPopUp: PopUpButtonName<SignalInput<Void>> { return .name(B.willPopUp) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol PopUpButtonConvertible: ButtonConvertible {
	func nsPopUpButton() -> PopUpButton.Instance
}
extension PopUpButtonConvertible {
	public func nsButton() -> Button.Instance { return nsPopUpButton() }
}
extension NSPopUpButton: PopUpButtonConvertible {
	public func nsPopUpButton() -> PopUpButton.Instance { return self }
}
public extension PopUpButton {
	func nsPopUpButton() -> PopUpButton.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol PopUpButtonBinding: ButtonBinding {
	static func popUpButtonBinding(_ binding: PopUpButton.Binding) -> Self
}
public extension PopUpButtonBinding {
	static func buttonBinding(_ binding: Button.Binding) -> Self {
		return popUpButtonBinding(.inheritedBinding(binding))
	}
}
public extension PopUpButton.Binding {
	typealias Preparer = PopUpButton.Preparer
	static func popUpButtonBinding(_ binding: PopUpButton.Binding) -> PopUpButton.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
