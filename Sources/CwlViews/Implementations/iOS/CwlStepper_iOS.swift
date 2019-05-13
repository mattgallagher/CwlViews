//
//  CwlStepper_iOS.swift
//  CwlViews
//
//  Created by Sye Boddeus on 13/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class Stepper: Binder, StepperConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Stepper {
	enum Binding: StepperBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case autorepeat(Dynamic<Bool>)
		case backgroundImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case decrementImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case dividerImage(Dynamic<ScopedValues<LeftRightControlState, UIImage?>>)
		case incrementImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case isContinuous(Dynamic<Bool>)
		case maximumValue(Dynamic<Double>)
		case minimumValue(Dynamic<Double>)
		case stepValue(Dynamic<Double>)
		case tintColor(Dynamic<UIColor?>)
		case value(Dynamic<Double>)
		case wraps(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension Stepper {
	struct Preparer: BinderEmbedderConstructor /* or BinderDelegateEmbedderConstructor */ {
		public typealias Binding = Stepper.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UIStepper
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Stepper.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		case .autorepeat(let x): return x.apply(instance) { i, v in i.autorepeat = v }
		case .backgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackgroundImage(nil, for: scope) },
				applyNew: { i, scope, v in i.setBackgroundImage(v, for: scope) }
			)
		case .decrementImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setDecrementImage(nil, for: scope) },
				applyNew: { i, scope, v in i.setDecrementImage(v, for: scope) }
			)
		case .dividerImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setDividerImage(nil, forLeftSegmentState: scope.left, rightSegmentState: scope.right) },
				applyNew: { i, scope, v in i.setDividerImage(v, forLeftSegmentState: scope.left, rightSegmentState: scope.right) }
			)
		case .incrementImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setIncrementImage(nil, for: scope) },
				applyNew: { i, scope, v in i.setIncrementImage(v, for: scope) }
			)
		case .isContinuous(let x): return x.apply(instance) { i, v in i.isContinuous = v }
		case .maximumValue(let x): return x.apply(instance) { i, v in i.maximumValue = v }
		case .minimumValue(let x): return x.apply(instance) { i, v in i.minimumValue = v }
		case .stepValue(let x): return x.apply(instance) { i, v in i.stepValue = v }
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
		case .value(let x): return x.apply(instance) { i, v in i.value = v }
		case .wraps(let x): return x.apply(instance) { i, v in i.wraps = v}
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Stepper.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: StepperBinding {
	public typealias StepperName<V> = BindingName<V, Stepper.Binding, Binding>
			private static func name<V>(_ source: @escaping (V) -> Stepper.Binding) -> StepperName<V> {
		return StepperName<V>(source: source, downcast: Binding.stepperBinding)
	}
}
public extension BindingName where Binding: StepperBinding {
	static var autorepeat: StepperName<Dynamic<Bool>> { return .name(Stepper.Binding.autorepeat) }
	static var backgroundImage: StepperName<Dynamic<ScopedValues<UIControl.State, UIImage?>>> { return .name(Stepper.Binding.backgroundImage) }
	static var decrementImage: StepperName<Dynamic<ScopedValues<UIControl.State, UIImage?>>> { return .name(Stepper.Binding.decrementImage) }
	static var dividerImage: StepperName<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>> { return .name(Stepper.Binding.dividerImage) }
	static var incrementImage: StepperName<Dynamic<ScopedValues<UIControl.State, UIImage?>>> { return .name(Stepper.Binding.incrementImage) }
	static var isContinuous: StepperName<Dynamic<Bool>> { return .name(Stepper.Binding.isContinuous) }
	static var maximumValue: StepperName<Dynamic<Double>> { return .name(Stepper.Binding.maximumValue) }
	static var minimumValue: StepperName<Dynamic<Double>> { return .name(Stepper.Binding.minimumValue) }
	static var stepValue: StepperName<Dynamic<Double>> { return .name(Stepper.Binding.stepValue) }
	static var tintColor: StepperName<Dynamic<UIColor?>> { return .name(Stepper.Binding.tintColor) }
	static var value: StepperName<Dynamic<Double>> { return .name(Stepper.Binding.value) }
	static var wraps: StepperName<Dynamic<Bool>> { return .name(Stepper.Binding.wraps) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol StepperConvertible: ControlConvertible {
	func uiStepper() -> Stepper.Instance
}
extension StepperConvertible {
	public func uiControl() -> Control.Instance { return uiStepper() }
}
extension UIStepper: StepperConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func uiStepper() -> Stepper.Instance { return self }
}
public extension Stepper {
	func uiStepper() -> Stepper.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol StepperBinding: ControlBinding {
	static func stepperBinding(_ binding: Stepper.Binding) -> Self
	func asStepperBinding() -> Stepper.Binding?
}
public extension StepperBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return stepperBinding(.inheritedBinding(binding))
	}
}
extension StepperBinding where Preparer.Inherited.Binding: StepperBinding {
	func asStepperBinding() -> Stepper.Binding? {
		return asInheritedBinding()?.asStepperBinding()
	}
}
public extension Stepper.Binding {
	typealias Preparer = Stepper.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asStepperBinding() -> Stepper.Binding? { return self }
	static func stepperBinding(_ binding: Stepper.Binding) -> Stepper.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
