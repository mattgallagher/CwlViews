//
//  CwlGestureRecognizer_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class GestureRecognizer: Binder, GestureRecognizerConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension GestureRecognizer {
	enum Binding: GestureRecognizerBinding {
		case inheritedBinding(Preparer.Inherited.Binding)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowedPressTypes(Dynamic<[NSNumber]>)
		case allowedTouchTypes(Dynamic<[NSNumber]>)
		case cancelsTouchesInView(Dynamic<Bool>)
		case delaysTouchesBegan(Dynamic<Bool>)
		case delaysTouchesEnded(Dynamic<Bool>)
		case requiresExclusiveTouchType(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case action(SignalInput<Any?>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldBegin((UIGestureRecognizer) -> Bool)
		case shouldBeRequiredToFail((UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool)
		case shouldReceivePress((UIGestureRecognizer, UIPress) -> Bool)
		case shouldReceiveTouch((UIGestureRecognizer, UITouch) -> Bool)
		case shouldRecognizeSimultanously((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
		case shouldRequireFailure((UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension GestureRecognizer {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = GestureRecognizer.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = UIGestureRecognizer
		
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
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension GestureRecognizer.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .shouldBegin(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizerShouldBegin(_:)))
		case .shouldBeRequiredToFail(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldBeRequiredToFailBy:)))
		case .shouldReceivePress(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:) as((UIGestureRecognizerDelegate) -> (UIGestureRecognizer, UIPress) -> Bool)?))
		case .shouldReceiveTouch(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:) as((UIGestureRecognizerDelegate) -> (UIGestureRecognizer, UITouch) -> Bool)?))
		case .shouldRecognizeSimultanously(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)))
		case .shouldRequireFailure(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRequireFailureOf:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowedPressTypes(let x): return x.apply(instance) { i, v in i.allowedPressTypes = v }
		case .allowedTouchTypes(let x): return x.apply(instance) { i, v in i.allowedTouchTypes = v }
		case .cancelsTouchesInView(let x): return x.apply(instance) { i, v in i.cancelsTouchesInView = v }
		case .delaysTouchesBegan(let x): return x.apply(instance) { i, v in i.delaysTouchesBegan = v }
		case .delaysTouchesEnded(let x): return x.apply(instance) { i, v in i.delaysTouchesEnded = v }
		
		case .requiresExclusiveTouchType(let x): return x.apply(instance) { i, v in i.requiresExclusiveTouchType = v }

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case .action(let x):
			let target = SignalActionTarget()
			instance.addTarget(target, action: SignalActionTarget.selector)
			return target.signal.cancellableBind(to: x)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .shouldBegin: return nil
		case .shouldReceiveTouch: return nil
		case .shouldRecognizeSimultanously: return nil
		case .shouldRequireFailure: return nil
		case .shouldBeRequiredToFail: return nil
		case .shouldReceivePress: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension GestureRecognizer.Preparer {
	open class Storage: AssociatedBinderStorage, UIGestureRecognizerDelegate {}

	open class Delegate: DynamicDelegate, UIGestureRecognizerDelegate {
		open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer) -> Bool).self)!(gestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UITouch) -> Bool).self)!(gestureRecognizer, touch)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool).self)!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool).self)!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool).self)!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UIPress) -> Bool).self)!(gestureRecognizer, press)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: GestureRecognizerBinding {
	public typealias GestureRecognizerName<V> = BindingName<V, GestureRecognizer.Binding, Binding>
	private typealias B = GestureRecognizer.Binding
	private static func name<V>(_ source: @escaping (V) -> GestureRecognizer.Binding) -> GestureRecognizerName<V> {
		return GestureRecognizerName<V>(source: source, downcast: Binding.gestureRecognizerBinding)
	}
}
public extension BindingName where Binding: GestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: GestureRecognizerName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowedPressTypes: GestureRecognizerName<Dynamic<[NSNumber]>> { return .name(B.allowedPressTypes) }
	static var allowedTouchTypes: GestureRecognizerName<Dynamic<[NSNumber]>> { return .name(B.allowedTouchTypes) }
	static var cancelsTouchesInView: GestureRecognizerName<Dynamic<Bool>> { return .name(B.cancelsTouchesInView) }
	static var delaysTouchesBegan: GestureRecognizerName<Dynamic<Bool>> { return .name(B.delaysTouchesBegan) }
	static var delaysTouchesEnded: GestureRecognizerName<Dynamic<Bool>> { return .name(B.delaysTouchesEnded) }
	static var requiresExclusiveTouchType: GestureRecognizerName<Dynamic<Bool>> { return .name(B.requiresExclusiveTouchType) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var action: GestureRecognizerName<SignalInput<Any?>> { return .name(B.action) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var shouldBegin: GestureRecognizerName<(UIGestureRecognizer) -> Bool> { return .name(B.shouldBegin) }
	static var shouldBeRequiredToFail: GestureRecognizerName<(UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool> { return .name(B.shouldBeRequiredToFail) }
	static var shouldReceivePress: GestureRecognizerName<(UIGestureRecognizer, UIPress) -> Bool> { return .name(B.shouldReceivePress) }
	static var shouldReceiveTouch: GestureRecognizerName<(UIGestureRecognizer, UITouch) -> Bool> { return .name(B.shouldReceiveTouch) }
	static var shouldRecognizeSimultanously: GestureRecognizerName<(UIGestureRecognizer, UIGestureRecognizer) -> Bool> { return .name(B.shouldRecognizeSimultanously) }
	static var shouldRequireFailure: GestureRecognizerName<(UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool> { return .name(B.shouldRequireFailure) }

	// Composite binding names
	static func action<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> GestureRecognizerName<SignalInput<Value>> {
		return Binding.mappedInputName(
			map: { sender in (sender as! Binding.Preparer.Instance)[keyPath: keyPath] },
			binding: GestureRecognizer.Binding.action,
			downcast: Binding.gestureRecognizerBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol GestureRecognizerConvertible {
	func uiGestureRecognizer() -> GestureRecognizer.Instance
}
extension UIGestureRecognizer: GestureRecognizerConvertible, DefaultConstructable, HasDelegate {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return self }
}
public extension GestureRecognizer {
	func uiGestureRecognizer() -> GestureRecognizer.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol GestureRecognizerBinding: BinderBaseBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self
}
public extension GestureRecognizerBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return gestureRecognizerBinding(.inheritedBinding(binding))
	}
}
public extension GestureRecognizer.Binding {
	typealias Preparer = GestureRecognizer.Preparer
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> GestureRecognizer.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
