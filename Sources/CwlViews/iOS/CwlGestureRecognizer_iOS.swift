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

public class GestureRecognizer: Binder, GestureRecognizerConvertible {
	public typealias Instance = UIGestureRecognizer
	public typealias Inherited = BaseBinder
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiGestureRecognizer() -> Instance { return instance() }
	
	enum Binding: GestureRecognizerBinding {
		public typealias EnclosingBinder = GestureRecognizer
		public static func gestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case cancelsTouchesInView(Dynamic<Bool>)
		case delaysTouchesBegan(Dynamic<Bool>)
		case delaysTouchesEnded(Dynamic<Bool>)
		case allowedPressTypes(Dynamic<[NSNumber]>)
		case allowedTouchTypes(Dynamic<[NSNumber]>)
		@available(iOS 9.2, *) case requiresExclusiveTouchType(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case action(SignalInput<Void>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldBegin((UIGestureRecognizer) -> Bool)
		case shouldReceiveTouch((UIGestureRecognizer, UITouch) -> Bool)
		case shouldRecognizeSimultanously((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
		case shouldRequireFailure((UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool)
		case shouldBeRequiredToFail((UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool)
		case shouldReceivePress((UIGestureRecognizer, UIPress) -> Bool)
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = GestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }

		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var dynamicDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = dynamicDelegate {
				return d
			} else {
				let d = delegateClass.init()
				dynamicDelegate = d
				return d
			}
		}
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .shouldBegin(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizerShouldBegin(_:)))
			case .shouldReceiveTouch(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:) as((UIGestureRecognizerDelegate) -> (UIGestureRecognizer, UITouch) -> Bool)?))
			case .shouldRecognizeSimultanously(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)))
			case .shouldRequireFailure(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRequireFailureOf:)))
			case .shouldBeRequiredToFail(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldBeRequiredToFailBy:)))
			case .shouldReceivePress(let x): delegate().addHandler(x, #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:) as((UIGestureRecognizerDelegate) -> (UIGestureRecognizer, UIPress) -> Bool)?))
			case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
			default: break
			}
		}

		public func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = dynamicDelegate
			if storage.inUse {
				instance.delegate = storage
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .action(let x):
				let target = SignalActionTarget()
				instance.addTarget(target, action: SignalActionTarget.selector)
				return target.signal.map { _ in () }.cancellableBind(to: x)
			case .cancelsTouchesInView(let x): return x.apply(instance) { i, v in i.cancelsTouchesInView = v }
			case .delaysTouchesBegan(let x): return x.apply(instance) { i, v in i.delaysTouchesBegan = v }
			case .delaysTouchesEnded(let x): return x.apply(instance) { i, v in i.delaysTouchesEnded = v }
			case .allowedPressTypes(let x): return x.apply(instance) { i, v in i.allowedPressTypes = v }
			case .allowedTouchTypes(let x): return x.apply(instance) { i, v in i.allowedTouchTypes = v }
			case .requiresExclusiveTouchType(let x):
				return x.apply(instance) { i, v in
					if #available(iOS 9.2, *) {
						i.requiresExclusiveTouchType = v
					}
				}
			case .shouldBegin: return nil
			case .shouldReceiveTouch: return nil
			case .shouldRecognizeSimultanously: return nil
			case .shouldRequireFailure: return nil
			case .shouldBeRequiredToFail: return nil
			case .shouldReceivePress: return nil
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ObjectBinderStorage, UIGestureRecognizerDelegate {}

	open class Delegate: DynamicDelegate, UIGestureRecognizerDelegate {
		public required override init() {
			super.init()
		}
		
		open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer) -> Bool).self)(gestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UITouch) -> Bool).self)(gestureRecognizer, touch)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool).self)(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool).self)(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool).self)(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
			return handler(ofType: ((UIGestureRecognizer, UIPress) -> Bool).self)(gestureRecognizer, press)
		}
	}
}

extension BindingName where Binding: GestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.$1(v)) }) }
	public static var cancelsTouchesInView: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.cancelsTouchesInView(v)) }) }
	public static var delaysTouchesBegan: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.delaysTouchesBegan(v)) }) }
	public static var delaysTouchesEnded: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.delaysTouchesEnded(v)) }) }
	public static var allowedPressTypes: BindingName<Dynamic<[NSNumber]>, Binding> { return BindingName<Dynamic<[NSNumber]>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.allowedPressTypes(v)) }) }
	public static var allowedTouchTypes: BindingName<Dynamic<[NSNumber]>, Binding> { return BindingName<Dynamic<[NSNumber]>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.allowedTouchTypes(v)) }) }
	@available(iOS 9.2, *) public static var requiresExclusiveTouchType: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.requiresExclusiveTouchType(v)) }) }
	public static var action: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.action(v)) }) }
	public static var shouldBegin: BindingName<(UIGestureRecognizer) -> Bool, Binding> { return BindingName<(UIGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldBegin(v)) }) }
	public static var shouldReceiveTouch: BindingName<(UIGestureRecognizer, UITouch) -> Bool, Binding> { return BindingName<(UIGestureRecognizer, UITouch) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldReceiveTouch(v)) }) }
	public static var shouldRecognizeSimultanously: BindingName<(UIGestureRecognizer, UIGestureRecognizer) -> Bool, Binding> { return BindingName<(UIGestureRecognizer, UIGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldRecognizeSimultanously(v)) }) }
	public static var shouldRequireFailure: BindingName<(UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool, Binding> { return BindingName<(UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldRequireFailure(v)) }) }
	public static var shouldBeRequiredToFail: BindingName<(UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool, Binding> { return BindingName<(UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldBeRequiredToFail(v)) }) }
	public static var shouldReceivePress: BindingName<(UIGestureRecognizer, UIPress) -> Bool, Binding> { return BindingName<(UIGestureRecognizer, UIPress) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldReceivePress(v)) }) }
}

public protocol GestureRecognizerConvertible {
	func uiGestureRecognizer() -> GestureRecognizer.Instance
}
extension GestureRecognizer.Instance: GestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return self }
}

public protocol GestureRecognizerBinding: BaseBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self
}

extension GestureRecognizerBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return gestureRecognizerBinding(.inheritedBinding(binding))
	}
}

#endif
