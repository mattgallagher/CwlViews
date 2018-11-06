//
//  CwlWindow_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/08/2015.
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

#if os(iOS)

public class Window: ConstructingBinder, WindowConvertible {
	public typealias Instance = UIWindow
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiWindow() -> Instance { return instance() }
	
	public enum Binding: WindowBinding {
		public typealias EnclosingBinder = Window
		public static func windowBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case rootViewController(Dynamic<ViewControllerConvertible>)
		case windowLevel(Dynamic<UIWindow.Level>)
		case screen(Dynamic<UIScreen>)
		case frame(Dynamic<CGRect>)
		
		// 2. Signal bindings are performed on the object after construction.
		case makeKey(Signal<Void>)
		
		// 3. Action bindings are triggered by the object after construction.
		case didBecomeVisible(SignalInput<Void>)
		case didBecomeHidden(SignalInput<Void>)
		case didBecomeKey(SignalInput<Void>)
		case didResignKey(SignalInput<Void>)
		case keyboardWillShow(SignalInput<[AnyHashable: Any]?>)
		case keyboardDidShow(SignalInput<[AnyHashable: Any]?>)
		case keyboardWillHide(SignalInput<[AnyHashable: Any]?>)
		case keyboardDidHide(SignalInput<[AnyHashable: Any]?>)
		case keyboardWillChangeFrame(SignalInput<[AnyHashable: Any]?>)
		case keyboardDidChangeFrame(SignalInput<[AnyHashable: Any]?>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Window
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}

		public var isHidden: InitialSubsequent<Bool>? = nil
		
		public mutating func prepareBinding(_ binding: Window.Binding) {
			switch binding {
			case .inheritedBinding(.isHidden(let x)): isHidden = x.initialSubsequent()
			case .inheritedBinding(let s): linkedPreparer.prepareBinding(s)
			default: break
			}
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .frame(let x): return x.apply(instance, storage) { i, s, v in i.frame = v }
			case .rootViewController(let x):
				return x.apply(instance, storage) { i, s, v in
					let rootViewController = v.uiViewController()
					i.rootViewController = rootViewController
					if rootViewController.restorationIdentifier == nil {
						rootViewController.restorationIdentifier = "cwlviews.root"
					}
				}
			case .windowLevel(let x): return x.apply(instance, storage) { i, s, v in i.windowLevel = v }
			case .screen(let x): return x.apply(instance, storage) { i, s, v in i.screen = v }
			case .makeKey(let x): return x.apply(instance, storage) { i, s, v in i.makeKey() }
			case .didBecomeVisible(let x): return Signal.notifications(name: UIWindow.didBecomeVisibleNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
			case .didBecomeHidden(let x): return Signal.notifications(name: UIWindow.didBecomeHiddenNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
			case .didBecomeKey(let x): return Signal.notifications(name: UIWindow.didBecomeKeyNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
			case .didResignKey(let x): return Signal.notifications(name: UIWindow.didResignKeyNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
			case .keyboardWillShow(let x): return Signal.notifications(name: UIResponder.keyboardWillShowNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
			case .keyboardDidShow(let x): return Signal.notifications(name: UIResponder.keyboardDidShowNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
			case .keyboardWillHide(let x): return Signal.notifications(name: UIResponder.keyboardWillHideNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
			case .keyboardDidHide(let x): return Signal.notifications(name: UIResponder.keyboardDidHideNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
			case .keyboardWillChangeFrame(let x): return Signal.notifications(name: UIResponder.keyboardWillChangeFrameNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
			case .keyboardDidChangeFrame(let x): return Signal.notifications(name: UIResponder.keyboardDidChangeFrameNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
			case .inheritedBinding(.isHidden): return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
		
		public mutating func finalizeInstance(_ instance: Instance, storage: View.Storage) -> Lifetime? {
			let lifetime = linkedPreparer.finalizeInstance(instance, storage: storage)
			if let h = isHidden?.resume() {
				if let c2 = linkedPreparer.applyBinding(.isHidden(.dynamic(h)), instance: instance, storage: storage) {
					return lifetime.map { c1 in AggregateLifetime(lifetimes: [c2, c1]) } ?? c2
				}
			}
			return lifetime
		}
	}
	
	public typealias Storage = View.Storage
}

extension BindingName where Binding: WindowBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .windowBinding(Window.Binding.$1(v)) }) }
	public static var frame: BindingName<Dynamic<CGRect>, Binding> { return BindingName<Dynamic<CGRect>, Binding>({ v in .windowBinding(Window.Binding.frame(v)) }) }
	public static var rootViewController: BindingName<Dynamic<ViewControllerConvertible>, Binding> { return BindingName<Dynamic<ViewControllerConvertible>, Binding>({ v in .windowBinding(Window.Binding.rootViewController(v)) }) }
	public static var windowLevel: BindingName<Dynamic<UIWindow.Level>, Binding> { return BindingName<Dynamic<UIWindow.Level>, Binding>({ v in .windowBinding(Window.Binding.windowLevel(v)) }) }
	public static var screen: BindingName<Dynamic<UIScreen>, Binding> { return BindingName<Dynamic<UIScreen>, Binding>({ v in .windowBinding(Window.Binding.screen(v)) }) }
	public static var makeKey: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.makeKey(v)) }) }
	public static var didBecomeVisible: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didBecomeVisible(v)) }) }
	public static var didBecomeHidden: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didBecomeHidden(v)) }) }
	public static var didBecomeKey: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didBecomeKey(v)) }) }
	public static var didResignKey: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didResignKey(v)) }) }
	public static var keyboardWillShow: BindingName<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingName<SignalInput<[AnyHashable: Any]?>, Binding>({ v in .windowBinding(Window.Binding.keyboardWillShow(v)) }) }
	public static var keyboardDidShow: BindingName<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingName<SignalInput<[AnyHashable: Any]?>, Binding>({ v in .windowBinding(Window.Binding.keyboardDidShow(v)) }) }
	public static var keyboardWillHide: BindingName<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingName<SignalInput<[AnyHashable: Any]?>, Binding>({ v in .windowBinding(Window.Binding.keyboardWillHide(v)) }) }
	public static var keyboardDidHide: BindingName<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingName<SignalInput<[AnyHashable: Any]?>, Binding>({ v in .windowBinding(Window.Binding.keyboardDidHide(v)) }) }
	public static var keyboardWillChangeFrame: BindingName<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingName<SignalInput<[AnyHashable: Any]?>, Binding>({ v in .windowBinding(Window.Binding.keyboardWillChangeFrame(v)) }) }
	public static var keyboardDidChangeFrame: BindingName<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingName<SignalInput<[AnyHashable: Any]?>, Binding>({ v in .windowBinding(Window.Binding.keyboardDidChangeFrame(v)) }) }
}

public protocol WindowConvertible: ViewConvertible {
	func uiWindow() -> Window.Instance
}
extension WindowConvertible {
	public func uiView() -> View.Instance { return uiWindow() }
}
extension Window.Instance: WindowConvertible {
	public func uiWindow() -> Window.Instance { return self }
}

public protocol WindowBinding: ViewBinding {
	static func windowBinding(_ binding: Window.Binding) -> Self
}
extension WindowBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return windowBinding(.inheritedBinding(binding))
	}
}

#endif
