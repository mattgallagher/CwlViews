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

// MARK: - Binder Part 1: Binder
public class Window: Binder, WindowConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Window {
	enum Binding: WindowBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case frame(Dynamic<CGRect>)
		case rootViewController(Dynamic<ViewControllerConvertible>)
		case screen(Dynamic<UIScreen>)
		case windowLevel(Dynamic<UIWindow.Level>)
		
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
}

// MARK: - Binder Part 3: Preparer
public extension Window {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Window.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UIWindow
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		var isHidden: InitialSubsequent<Bool>? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Window.Preparer {
	mutating func prepareBinding(_ binding: Window.Binding) {
		switch binding {
		case .inheritedBinding(.isHidden(let x)): isHidden = x.initialSubsequent()
		case .inheritedBinding(let s): inherited.prepareBinding(s)
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(.isHidden): return nil
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .frame(let x): return x.apply(instance) { i, v in i.frame = v }
		case .rootViewController(let x):
			return x.apply(instance) { i, v in
				let rootViewController = v.uiViewController()
				i.rootViewController = rootViewController
				if rootViewController.restorationIdentifier == nil {
					rootViewController.restorationIdentifier = "cwlviews.root"
				}
			}
		case .screen(let x): return x.apply(instance) { i, v in i.screen = v }
		case .windowLevel(let x): return x.apply(instance) { i, v in i.windowLevel = v }
			
		// 2. Signal bindings are performed on the object after construction.
		case .makeKey(let x): return x.apply(instance) { i, v in i.makeKey() }
			
		// 3. Action bindings are triggered by the object after construction.
		case .didBecomeHidden(let x): return Signal.notifications(name: UIWindow.didBecomeHiddenNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
		case .didBecomeKey(let x): return Signal.notifications(name: UIWindow.didBecomeKeyNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
		case .didBecomeVisible(let x): return Signal.notifications(name: UIWindow.didBecomeVisibleNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
		case .didResignKey(let x): return Signal.notifications(name: UIWindow.didResignKeyNotification, object: instance).map { notification -> Void in }.cancellableBind(to: x)
		case .keyboardDidChangeFrame(let x): return Signal.notifications(name: UIResponder.keyboardDidChangeFrameNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
		case .keyboardDidHide(let x): return Signal.notifications(name: UIResponder.keyboardDidHideNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
		case .keyboardDidShow(let x): return Signal.notifications(name: UIResponder.keyboardDidShowNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
		case .keyboardWillChangeFrame(let x): return Signal.notifications(name: UIResponder.keyboardWillChangeFrameNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
		case .keyboardWillHide(let x): return Signal.notifications(name: UIResponder.keyboardWillHideNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
		case .keyboardWillShow(let x): return Signal.notifications(name: UIResponder.keyboardWillShowNotification, object: instance).map { notification -> [AnyHashable: Any]? in notification.userInfo }.cancellableBind(to: x)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
	
	func finalizeInstance(_ instance: Instance, storage: View.Preparer.Storage) -> Lifetime? {
		var lifetimes = [Lifetime]()
		
		// `isHidden` needs to be applied after everything else
		lifetimes += (isHidden?.resume()).flatMap {
			inherited.applyBinding(.isHidden(.dynamic($0)), instance: instance, storage: storage)
		}
		
		lifetimes += inherited.inheritedFinalizedInstance(instance, storage: storage)
		return AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Window.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: WindowBinding {
	public typealias WindowName<V> = BindingName<V, Window.Binding, Binding>
	private typealias B = Window.Binding
	private static func name<V>(_ source: @escaping (V) -> Window.Binding) -> WindowName<V> {
		return WindowName<V>(source: source, downcast: Binding.windowBinding)
	}
}
public extension BindingName where Binding: WindowBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: WindowName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var frame: WindowName<Dynamic<CGRect>> { return .name(B.frame) }
	static var rootViewController: WindowName<Dynamic<ViewControllerConvertible>> { return .name(B.rootViewController) }
	static var screen: WindowName<Dynamic<UIScreen>> { return .name(B.screen) }
	static var windowLevel: WindowName<Dynamic<UIWindow.Level>> { return .name(B.windowLevel) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var makeKey: WindowName<Signal<Void>> { return .name(B.makeKey) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didBecomeVisible: WindowName<SignalInput<Void>> { return .name(B.didBecomeVisible) }
	static var didBecomeHidden: WindowName<SignalInput<Void>> { return .name(B.didBecomeHidden) }
	static var didBecomeKey: WindowName<SignalInput<Void>> { return .name(B.didBecomeKey) }
	static var didResignKey: WindowName<SignalInput<Void>> { return .name(B.didResignKey) }
	static var keyboardWillShow: WindowName<SignalInput<[AnyHashable: Any]?>> { return .name(B.keyboardWillShow) }
	static var keyboardDidShow: WindowName<SignalInput<[AnyHashable: Any]?>> { return .name(B.keyboardDidShow) }
	static var keyboardWillHide: WindowName<SignalInput<[AnyHashable: Any]?>> { return .name(B.keyboardWillHide) }
	static var keyboardDidHide: WindowName<SignalInput<[AnyHashable: Any]?>> { return .name(B.keyboardDidHide) }
	static var keyboardWillChangeFrame: WindowName<SignalInput<[AnyHashable: Any]?>> { return .name(B.keyboardWillChangeFrame) }
	static var keyboardDidChangeFrame: WindowName<SignalInput<[AnyHashable: Any]?>> { return .name(B.keyboardDidChangeFrame) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol WindowConvertible: ViewConvertible {
	func uiWindow() -> Window.Instance
}
extension WindowConvertible {
	public func uiView() -> View.Instance { return uiWindow() }
}
extension UIWindow: WindowConvertible {
	public func uiWindow() -> Window.Instance { return self }
}
public extension Window {
	func uiWindow() -> Window.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol WindowBinding: ViewBinding {
	static func windowBinding(_ binding: Window.Binding) -> Self
}
public extension WindowBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return windowBinding(.inheritedBinding(binding))
	}
}
public extension Window.Binding {
	typealias Preparer = Window.Preparer
	static func windowBinding(_ binding: Window.Binding) -> Window.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
