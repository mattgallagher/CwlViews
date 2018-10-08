//
//  CwlGestureRecognizer.swift
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

public class GestureRecognizer: ConstructingBinder, GestureRecognizerConvertible {
	public typealias Instance = UIGestureRecognizer
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiGestureRecognizer() -> Instance { return instance() }
	
	public enum Binding: GestureRecognizerBinding {
		public typealias EnclosingBinder = GestureRecognizer
		public static func gestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)

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

	public struct Preparer: ConstructingPreparer {
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
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .shouldBegin(let x):
				let s = #selector(UIGestureRecognizerDelegate.gestureRecognizerShouldBegin(_:))
				delegate().addSelector(s).shouldBegin = x
			case .shouldReceiveTouch(let x):
				let s = #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:) as((UIGestureRecognizerDelegate) -> (UIGestureRecognizer, UITouch) -> Bool)?)
				delegate().addSelector(s).shouldReceiveTouch = x
			case .shouldRecognizeSimultanously(let x):
				let s = #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:))
				delegate().addSelector(s).shouldRecognizeSimultanously = x
			case .shouldRequireFailure(let x):
				let s = #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRequireFailureOf:))
				delegate().addSelector(s).shouldRequireFailure = x
			case .shouldBeRequiredToFail(let x):
				let s = #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldBeRequiredToFailBy:))
				delegate().addSelector(s).shouldBeRequiredToFail = x
			case .shouldReceivePress(let x):
				let s = #selector(UIGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:) as((UIGestureRecognizerDelegate) -> (UIGestureRecognizer, UIPress) -> Bool)?)
				delegate().addSelector(s).shouldReceivePress = x
			case .inheritedBinding(let preceeding): linkedPreparer.prepareBinding(preceeding)
			default: break
			}
		}

		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			if storage.inUse {
				instance.delegate = storage
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .action(let x):
				let target = SignalActionTarget()
				instance.addTarget(target, action: SignalActionTarget.selector)
				return target.signal.map { _ in () }.cancellableBind(to: x)
			case .cancelsTouchesInView(let x): return x.apply(instance, storage) { i, s, v in i.cancelsTouchesInView = v }
			case .delaysTouchesBegan(let x): return x.apply(instance, storage) { i, s, v in i.delaysTouchesBegan = v }
			case .delaysTouchesEnded(let x): return x.apply(instance, storage) { i, s, v in i.delaysTouchesEnded = v }
			case .allowedPressTypes(let x): return x.apply(instance, storage) { i, s, v in i.allowedPressTypes = v }
			case .allowedTouchTypes(let x): return x.apply(instance, storage) { i, s, v in i.allowedTouchTypes = v }
			case .requiresExclusiveTouchType(let x):
				return x.apply(instance, storage) { i, s, v in
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
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ObjectBinderStorage, UIGestureRecognizerDelegate {}

	open class Delegate: DynamicDelegate, UIGestureRecognizerDelegate {
		public required override init() {
			super.init()
		}
		
		open var shouldBegin: ((UIGestureRecognizer) -> Bool)?
		open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
			return shouldBegin!(gestureRecognizer)
		}
		
		open var shouldReceiveTouch: ((UIGestureRecognizer, UITouch) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
			return shouldReceiveTouch!(gestureRecognizer, touch)
		}
		
		open var shouldRecognizeSimultanously: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return shouldRecognizeSimultanously!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open var shouldRequireFailure: ((UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return shouldRequireFailure!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open var shouldBeRequiredToFail: ((UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return shouldBeRequiredToFail!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open var shouldReceivePress: ((UIGestureRecognizer, UIPress) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
			return shouldReceivePress!(gestureRecognizer, press)
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
