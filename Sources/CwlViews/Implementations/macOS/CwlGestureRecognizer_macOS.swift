//
//  CwlGestureRecognizer_macOS.swift
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

#if os(macOS)

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
		case allowedTouchTypes(Dynamic<NSTouch.TouchTypeMask>)
		case pressureConfiguration(Dynamic<NSPressureConfiguration>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldAttemptToRecognize((NSGestureRecognizer, NSEvent) -> Bool)
		case shouldBegin((NSGestureRecognizer) -> Bool)
		case shouldRecognizeSimultaneously((NSGestureRecognizer, NSGestureRecognizer) -> Bool)
		case shouldRequireFailure((NSGestureRecognizer, NSGestureRecognizer) -> Bool)
		case shouldRequireToFail((NSGestureRecognizer, NSGestureRecognizer) -> Bool)
		case shouldReceiveTouch((NSGestureRecognizer, NSTouch) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension GestureRecognizer {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = GestureRecognizer.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSGestureRecognizer
		
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
		case .shouldBegin(let x): delegate().addHandler(x, #selector(NSGestureRecognizerDelegate.gestureRecognizerShouldBegin(_:)))
		case .shouldRecognizeSimultaneously(let x): delegate().addHandler(x, #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)))
		case .shouldRequireFailure(let x): delegate().addHandler(x, #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldRequireFailureOf:)))
		case .shouldRequireToFail(let x): delegate().addHandler(x, #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldBeRequiredToFailBy:)))
		case .shouldAttemptToRecognize(let x): delegate().addHandler(x, #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldAttemptToRecognizeWith:)))
		case .shouldReceiveTouch(let x): delegate().addHandler(x, #selector(NSGestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:)))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowedTouchTypes(let x): return x.apply(instance) { i, v in i.allowedTouchTypes = v }
		case .pressureConfiguration(let x): return x.apply(instance) { i, v in i.pressureConfiguration = v }
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		case .action(let x): return x.apply(to: instance, constructTarget: SignalActionTarget.init)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .shouldAttemptToRecognize: return nil
		case .shouldBegin: return nil
		case .shouldRecognizeSimultaneously: return nil
		case .shouldRequireFailure: return nil
		case .shouldRequireToFail: return nil
		
		case .shouldReceiveTouch: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension GestureRecognizer.Preparer {
	open class Storage: EmbeddedObjectStorage, NSGestureRecognizerDelegate {}
	
	open class Delegate: DynamicDelegate, NSGestureRecognizerDelegate {
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
			return handler(ofType: ((NSGestureRecognizer, NSEvent) -> Bool).self)!(gestureRecognizer, event)
		}
		
		open func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
			return handler(ofType: ((NSGestureRecognizer) -> Bool).self)!(gestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer) -> Bool {
			return handler(ofType: ((NSGestureRecognizer, NSGestureRecognizer) -> Bool).self)!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: NSGestureRecognizer) -> Bool {
			return handler(ofType: ((NSGestureRecognizer, NSGestureRecognizer) -> Bool).self)!(gestureRecognizer, otherGestureRecognizer)
		}
		
		@objc(gestureRecognizer: shouldBeRequiredToFailByGestureRecognizer:) open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: NSGestureRecognizer) -> Bool {
			return handler(ofType: ((NSGestureRecognizer, NSGestureRecognizer) -> Bool).self)!(gestureRecognizer, otherGestureRecognizer)
		}
		
		open func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldReceive touch: NSTouch) -> Bool {
			return handler(ofType: ((NSGestureRecognizer, NSTouch) -> Bool).self)!(gestureRecognizer, touch)
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
	static var allowedTouchTypes: GestureRecognizerName<Dynamic<NSTouch.TouchTypeMask>> { return .name(B.allowedTouchTypes) }
	static var pressureConfiguration: GestureRecognizerName<Dynamic<NSPressureConfiguration>> { return .name(B.pressureConfiguration) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var action: GestureRecognizerName<TargetAction> { return .name(B.action) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var shouldAttemptToRecognize: GestureRecognizerName<(NSGestureRecognizer, NSEvent) -> Bool> { return .name(B.shouldAttemptToRecognize) }
	static var shouldBegin: GestureRecognizerName<(NSGestureRecognizer) -> Bool> { return .name(B.shouldBegin) }
	static var shouldRecognizeSimultaneously: GestureRecognizerName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool> { return .name(B.shouldRecognizeSimultaneously) }
	static var shouldRequireFailure: GestureRecognizerName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool> { return .name(B.shouldRequireFailure) }
	static var shouldRequireToFail: GestureRecognizerName<(NSGestureRecognizer, NSGestureRecognizer) -> Bool> { return .name(B.shouldRequireToFail) }
	static var shouldReceiveTouch: GestureRecognizerName<(NSGestureRecognizer, NSTouch) -> Bool> { return .name(B.shouldReceiveTouch) }

	// Composite binding names
	static func action<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> GestureRecognizerName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, GestureRecognizer.Binding.action, Binding.gestureRecognizerBinding)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol GestureRecognizerConvertible {
	func nsGestureRecognizer() -> GestureRecognizer.Instance
}
extension NSGestureRecognizer: GestureRecognizerConvertible, TargetActionSender, DefaultConstructable, HasDelegate {
	public func nsGestureRecognizer() -> GestureRecognizer.Instance { return self }
}
public extension GestureRecognizer {
	func nsGestureRecognizer() -> GestureRecognizer.Instance { return instance() }
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
