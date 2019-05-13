//
//  CwlSegmentedControl_iOS.swift
//  CwlViews
//
//  Created by Sye Boddeus on 9/5/19.
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
public class SegmentedControl: Binder, SegmentedControlConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension SegmentedControl {
	enum Binding: SegmentedControlBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case apportionsSegmentWidthsByContent(Dynamic<Bool>)
		case backgroundImage(Dynamic<ScopedValues<StateAndMetrics, UIImage?>>)
		case contentPositionAdjustment(Dynamic<ScopedValues<SegmentTypeAndMetrics, UIOffset>>)
		case dividerImage(Dynamic<ScopedValues<LeftRightControlStateAndMetrics, UIImage?>>)
		case momentary(Dynamic<Bool>)
		case segments(Dynamic<SetOrAnimate<ArrayMutation<SegmentDescription>>>)
		case tintColor(Dynamic<UIColor?>)
		case titleTextAttributes(Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>)

		// 2. Signal bindings are performed on the object after construction.
		case selectItem(Signal<Int>)
		
		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension SegmentedControl {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = SegmentedControl.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UISegmentedControl

		public var inherited = Inherited()
		public init() {}
		
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var selectItem: Signal<Int>? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension SegmentedControl.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let s): return inherited.prepareBinding(s)
		case .selectItem(let x): selectItem = x
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .apportionsSegmentWidthsByContent(let x):
			return x.apply(instance) { i, v in i.apportionsSegmentWidthsByContent = v }
		case .backgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackgroundImage(nil, for: scope.controlState, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setBackgroundImage(v, for: scope.controlState, barMetrics: scope.barMetrics) }
			)
		case .contentPositionAdjustment(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setContentPositionAdjustment(UIOffset(), forSegmentType: scope.segmentType, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setContentPositionAdjustment(v, forSegmentType: scope.segmentType, barMetrics: scope.barMetrics) }
			)
		case .dividerImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setDividerImage(nil, forLeftSegmentState: scope.leftSegmentState, rightSegmentState: scope.rightSegmentState, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setDividerImage(v, forLeftSegmentState: scope.leftSegmentState, rightSegmentState: scope.rightSegmentState, barMetrics: scope.barMetrics) }
			)
		case .momentary(let x): return x.apply(instance) { i, v in i.isMomentary = v }
		case .segments(let x):
			return x.apply(instance) { i, v in
				v.value.insertionsAndRemovals(length: i.numberOfSegments, insert: { index, identifier in
					switch identifier.content {
					case .image(let image): i.insertSegment(with: image, at: index, animated: v.isAnimated)
					case .title(let title): i.insertSegment(withTitle: title, at: index, animated: v.isAnimated)
					}
					i.setWidth(identifier.width, forSegmentAt: index)
					i.setContentOffset(identifier.contentOffset, forSegmentAt: index)
					i.setEnabled(identifier.enabled, forSegmentAt: index)
				}, remove: { index in
					i.removeSegment(at: index, animated: v.isAnimated)
				})
			}
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
		case .titleTextAttributes(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setTitleTextAttributes([:], for: scope) },
				applyNew:  { i, scope, v in i.setTitleTextAttributes(v, for: scope) }
			)
		
		// 2. Signal bindings are performed on the object after construction.
		case .selectItem: return nil
		}
	}
	
	func finalizeInstance(_ instance: UISegmentedControl, storage: Control.Preparer.Storage) -> Lifetime? {
		var lifetimes = [Lifetime]()
		lifetimes += selectItem?.apply(instance) { i, v in
			i.selectedSegmentIndex = v
		}
		lifetimes += inheritedFinalizedInstance(instance, storage: storage)
		return lifetimes.isEmpty ? nil : AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SegmentedControl.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SegmentedControlBinding {
	public typealias SegmentedControlName<V> = BindingName<V, SegmentedControl.Binding, Binding>
			private static func name<V>(_ source: @escaping (V) -> SegmentedControl.Binding) -> SegmentedControlName<V> {
		return SegmentedControlName<V>(source: source, downcast: Binding.segmentedControlBinding)
	}
}
public extension BindingName where Binding: SegmentedControlBinding {
	static var apportionsSegmentWidthsByContent: SegmentedControlName<Dynamic<Bool>> { return .name(SegmentedControl.Binding.apportionsSegmentWidthsByContent) }
	static var backgroundImage: SegmentedControlName<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>> { return .name(SegmentedControl.Binding.backgroundImage) }
	static var contentPositionAdjustment: SegmentedControlName<Dynamic<ScopedValues<SegmentTypeAndMetrics, UIOffset
		>>> { return .name(SegmentedControl.Binding.contentPositionAdjustment) }
	static var dividerImage: SegmentedControlName<Dynamic<ScopedValues<LeftRightControlStateAndMetrics, UIImage?>>> { return .name(SegmentedControl.Binding.dividerImage) }
	static var momentary: SegmentedControlName<Dynamic<Bool>> { return .name(SegmentedControl.Binding.momentary)}
	static var segments: SegmentedControlName<Dynamic<SetOrAnimate<ArrayMutation<SegmentDescription>>>> { return .name(SegmentedControl.Binding.segments)}
	static var tintColor: SegmentedControlName<Dynamic<UIColor?>> { return .name(SegmentedControl.Binding.tintColor)}
	static var titleTextAttributes: SegmentedControlName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>> { return .name(SegmentedControl.Binding.titleTextAttributes) }
	
	static var selectItem: SegmentedControlName<Signal<Int>> { return .name(SegmentedControl.Binding.selectItem)}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SegmentedControlConvertible: ControlConvertible {
	func uiSegmentedControl() -> SegmentedControl.Instance
}
extension SegmentedControlConvertible {
	public func uiControl() -> Control.Instance { return uiSegmentedControl() }
}
extension UISegmentedControl: SegmentedControlConvertible {
	public func uiSegmentedControl() -> SegmentedControl.Instance { return self }
}
public extension SegmentedControl {
	func uiSegmentedControl() -> SegmentedControl.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SegmentedControlBinding: ControlBinding {
	static func segmentedControlBinding(_ binding: SegmentedControl.Binding) -> Self
	func asSegmentedControlBinding() -> SegmentedControl.Binding?
}
public extension SegmentedControlBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return segmentedControlBinding(.inheritedBinding(binding))
	}
}
extension SegmentedControlBinding where Preparer.Inherited.Binding: SegmentedControlBinding {
	func asSegmentedControlBinding() -> SegmentedControl.Binding? {
		return asInheritedBinding()?.asSegmentedControlBinding()
	}
}
public extension SegmentedControl.Binding {
	typealias Preparer = SegmentedControl.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asSegmentedControlBinding() -> SegmentedControl.Binding? { return self }
	static func segmentedControlBinding(_ binding: SegmentedControl.Binding) -> SegmentedControl.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct SegmentDescription {
	public enum Content {
		case title(String?)
		case image(UIImage?)
	}

	public let content: Content
	public let width: CGFloat
	public let contentOffset: CGSize
	public let enabled: Bool

	public init(_ content: Content, width: CGFloat = 0, contentOffset: CGSize = .zero, enabled: Bool = true) {
		self.content = content
		self.width = width
		self.contentOffset = contentOffset
		self.enabled = enabled
	}
	
	public static func title(_ title: String?, width: CGFloat = 0, contentOffset: CGSize = .zero, enabled: Bool = true) -> SegmentDescription {
		return SegmentDescription(.title(title), width: width, contentOffset: contentOffset, enabled: enabled)
	}
	
	public static func image(_ image: UIImage?, width: CGFloat = 0, contentOffset: CGSize = .zero, enabled: Bool = true) -> SegmentDescription {
		return SegmentDescription(.image(image), width: width, contentOffset: contentOffset, enabled: enabled)
	}
}

public struct SegmentTypeAndMetrics {
	public let segmentType: UISegmentedControl.Segment
	public let barMetrics: UIBarMetrics
	public init(segmentType: UISegmentedControl.Segment = .any, metrics: UIBarMetrics = .default) {
		self.segmentType = segmentType
		self.barMetrics = metrics
	}
}

public struct LeftRightControlStateAndMetrics {
	public let leftSegmentState: UIControl.State
	public let rightSegmentState: UIControl.State
	public let barMetrics: UIBarMetrics
	public init(leftState: UIControl.State = .normal, rightState: UIControl.State = .normal, metrics: UIBarMetrics = .default) {
		self.leftSegmentState = leftState
		self.rightSegmentState = rightState
		self.barMetrics = metrics
	}
}

extension ScopedValues where Scope == SegmentTypeAndMetrics {
	public static func any(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: SegmentTypeAndMetrics(segmentType: .any, metrics: metrics))
	}
	public static func left(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: SegmentTypeAndMetrics(segmentType: .left, metrics: metrics))
	}
	public static func center(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: SegmentTypeAndMetrics(segmentType: .center, metrics: metrics))
	}
	public static func right(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: SegmentTypeAndMetrics(segmentType: .right, metrics: metrics))
	}
	public static func alone(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: SegmentTypeAndMetrics(segmentType: .alone, metrics: metrics))
	}
}

#endif
