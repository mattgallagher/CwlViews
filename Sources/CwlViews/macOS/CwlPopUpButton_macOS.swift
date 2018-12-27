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

public class PopUpButton: Binder, PopUpButtonConvertible {
	public typealias Instance = NSPopUpButton
	public typealias Inherited = Button
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsPopUpButton() -> Instance { return instance() }
	
	enum Binding: PopUpButtonBinding {
		public typealias EnclosingBinder = PopUpButton
		public static func popUpButtonBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case pullsDown(Dynamic<Bool>)
		case autoenablesItems(Dynamic<Bool>)
		case menu(Dynamic<(NSMenu, selectedIndex: Int)>)
		case preferredEdge(Dynamic<NSRectEdge>)
		case title(Dynamic<String>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case willPopUp(SignalInput<Void>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = PopUpButton
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			return subclass.init(frame: NSRect.zero, pullsDown: pullsDownInitial ?? false)
		}

		public var pullsDown = InitialSubsequent<Bool>()
		public var pullsDownInitial: Bool? = nil

		public init() {}

		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .pullsDown(let x):
				pullsDown = x.initialSubsequent()
				pullsDownInitial = pullsDown.initial()
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}

		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .pullsDown: return pullsDown.resume()?.apply(instance) { i, v in i.pullsDown = v }
			case .autoenablesItems(let x): return x.apply(instance) { i, v in i.autoenablesItems = v }
			case .menu(let x):
				return x.apply(instance) { i, v in
					i.menu = v.0
					i.selectItem(at: v.selectedIndex)
				}
			case .preferredEdge(let x): return x.apply(instance) { i, v in i.preferredEdge = v }
			case .title(let x): return x.apply(instance) { i, v in i.title = v }
			case .willPopUp(let x):
				return Signal.notifications(name: NSPopUpButton.willPopUpNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = Button.Storage
}

extension BindingName where Binding: PopUpButtonBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .popUpButtonBinding(PopUpButton.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var pullsDown: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .popUpButtonBinding(PopUpButton.Binding.pullsDown(v)) }) }
	public static var autoenablesItems: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .popUpButtonBinding(PopUpButton.Binding.autoenablesItems(v)) }) }
	public static var menu: BindingName<Dynamic<(NSMenu, selectedIndex: Int)>, Binding> { return BindingName<Dynamic<(NSMenu, selectedIndex: Int)>, Binding>({ v in .popUpButtonBinding(PopUpButton.Binding.menu(v)) }) }
	public static var preferredEdge: BindingName<Dynamic<NSRectEdge>, Binding> { return BindingName<Dynamic<NSRectEdge>, Binding>({ v in .popUpButtonBinding(PopUpButton.Binding.preferredEdge(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .popUpButtonBinding(PopUpButton.Binding.title(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.
	public static var willPopUp: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .popUpButtonBinding(PopUpButton.Binding.willPopUp(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol PopUpButtonConvertible: ButtonConvertible {
	func nsPopUpButton() -> PopUpButton.Instance
}
extension PopUpButtonConvertible {
	public func nsButton() -> Button.Instance { return nsPopUpButton() }
}
extension PopUpButton.Instance: PopUpButtonConvertible {
	public func nsPopUpButton() -> PopUpButton.Instance { return self }
}

public protocol PopUpButtonBinding: ButtonBinding {
	static func popUpButtonBinding(_ binding: PopUpButton.Binding) -> Self
}
extension PopUpButtonBinding {
	public static func buttonBinding(_ binding: Button.Binding) -> Self {
		return popUpButtonBinding(.inheritedBinding(binding))
	}
}

#endif
