//
//  CwlGestureRecognizer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 23/10/2015.
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

public class GestureRecognizer: ConstructingBinder, GestureRecognizerConvertible {
	public typealias Instance = NSGestureRecognizer
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsGestureRecognizer() -> Instance { return instance() }
	
	public enum Binding: GestureRecognizerBinding {
		public typealias EnclosingBinder = GestureRecognizer
		public static func gestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		@available(macOS 10.11, *)
		case pressureConfiguration(Dynamic<NSPressureConfiguration>)
		@available(macOS 10.12.2, *)
		case allowedTouchTypes(Dynamic<NSTouch.TouchTypeMask>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldAttemptToRecognize((NSGestureRecognizer, NSEvent) -> Bool)
		case shouldBegin((NSGestureRecognizer) -> Bool)
		case shouldRecognizeSimultaneously((NSGestureRecognizer, NSGestureRecognizer) -> Bool)
		case shouldRequireFailure((NSGestureRecognizer, NSGestureRecognizer) -> Bool)
		case shouldRequireToFail((NSGestureRecognizer, NSGestureRecognizer) -> Bool)
		@available(macOS 10.12.2, *)
		case shouldReceiveTouch((NSGestureRecognizer, NSTouch) -> Bool)
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
			case .shouldAttemptToRecognize(let x):
				if #available(macOS 10.11, *) {
					let s = #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldAttemptToRecognizeWith:))
					delegate().addSelector(s).shouldAttemptToRecognize = x
				}
			case .shouldBegin(let x):
				let s = #selector(NSGestureRecognizerDelegate.gestureRecognizerShouldBegin(_:))
				delegate().addSelector(s).shouldBegin = x
			case .shouldRecognizeSimultaneously(let x):
				let s = #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:))
				delegate().addSelector(s).shouldRecognizeSimultaneously = x
			case .shouldRequireFailure(let x):
				let s = #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldRequireFailureOf:))
				delegate().addSelector(s).shouldRequireFailure = x
			case .shouldRequireToFail(let x):
				let s = #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldBeRequiredToFailBy:))
				delegate().addSelector(s).shouldRequireToFail = x
			case .shouldReceiveTouch(let x):
				if #available(macOS 10.12.2, *) {
					let s = #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:))
					delegate().addSelector(s).shouldReceive = x
				}
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
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .pressureConfiguration(let x):
				return x.apply(instance, storage) { (inst, bind, val) in
					if #available(macOS 10.11, *) {
						inst.pressureConfiguration = val
					}
				}
			case .allowedTouchTypes(let x):
				return x.apply(instance, storage) { (inst, bind, val) in
					if #available(macOS 10.12.2, *) {
						inst.allowedTouchTypes = val
					}
				}
			case .action(let x): return x.apply(instance: instance, constructTarget: SignalActionTarget.init, processor: { sender in () })
			case .shouldAttemptToRecognize: return nil
			case .shouldBegin: return nil
			case .shouldRecognizeSimultaneously: return nil
			case .shouldRequireFailure: return nil
			case .shouldRequireToFail: return nil
			case .shouldReceiveTouch: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	open class Storage: ObjectBinderStorage, NSGestureRecognizerDelegate {}
	
	open class Delegate: DynamicDelegate, NSGestureRecognizerDelegate {
		public required override init() {
			super.init()
		}
		
		open var shouldAttemptToRecognize: ((NSGestureRecognizer, NSEvent) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
			return shouldAttemptToRecognize!(gestureRecognizer, event)
		}
		
		open var shouldBegin: ((NSGestureRecognizer) -> Bool)?
		open func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
			return shouldBegin!(gestureRecognizer)
		}
		
		open var shouldRecognizeSimultaneously: ((NSGestureRecognizer, NSGestureRecognizer) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer) -> Bool {
			return shouldRecognizeSimultaneously!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open var shouldRequireFailure: ((NSGestureRecognizer, NSGestureRecognizer) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: NSGestureRecognizer) -> Bool {
			return shouldRequireFailure!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open var shouldRequireToFail: ((NSGestureRecognizer, NSGestureRecognizer) -> Bool)?
		@objc(gestureRecognizer: shouldBeRequiredToFailByGestureRecognizer:) open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: NSGestureRecognizer) -> Bool {
			return shouldRequireToFail!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open var shouldReceive: ((NSGestureRecognizer, NSTouch) -> Bool)?
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldReceive touch: NSTouch) -> Bool {
			return shouldReceive!(gestureRecognizer, touch)
		}
	}
}

extension BindingName where Binding: GestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	@available(macOS 10.11, *)
	public static var pressureConfiguration: BindingName<Dynamic<NSPressureConfiguration>, Binding> { return BindingName<Dynamic<NSPressureConfiguration>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.pressureConfiguration(v)) }) }
	@available(macOS 10.12.2, *)
	public static var allowedTouchTypes: BindingName<Dynamic<NSTouch.TouchTypeMask>, Binding> { return BindingName<Dynamic<NSTouch.TouchTypeMask>, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.allowedTouchTypes(v)) }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.action(v)) }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var shouldAttemptToRecognize: BindingName<(NSGestureRecognizer, NSEvent) -> Bool, Binding> { return BindingName<(NSGestureRecognizer, NSEvent) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldAttemptToRecognize(v)) }) }
	public static var shouldBegin: BindingName<(NSGestureRecognizer) -> Bool, Binding> { return BindingName<(NSGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldBegin(v)) }) }
	public static var shouldRecognizeSimultaneously: BindingName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding> { return BindingName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldRecognizeSimultaneously(v)) }) }
	public static var shouldRequireFailure: BindingName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding> { return BindingName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldRequireFailure(v)) }) }
	public static var shouldRequireToFail: BindingName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding> { return BindingName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldRequireToFail(v)) }) }
	@available(macOS 10.12.2, *)
	public static var shouldReceiveTouch: BindingName<(NSGestureRecognizer, NSTouch) -> Bool, Binding> { return BindingName<(NSGestureRecognizer, NSTouch) -> Bool, Binding>({ v in .gestureRecognizerBinding(GestureRecognizer.Binding.shouldReceiveTouch(v)) }) }
}

public protocol GestureRecognizerConvertible {
	func nsGestureRecognizer() -> GestureRecognizer.Instance
}
extension GestureRecognizer.Instance: GestureRecognizerConvertible {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return self }
}

public protocol GestureRecognizerBinding: BaseBinding {
	static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self
}

extension GestureRecognizerBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return gestureRecognizerBinding(.inheritedBinding(binding))
	}
}

extension NSGestureRecognizer: TargetActionSender {}
