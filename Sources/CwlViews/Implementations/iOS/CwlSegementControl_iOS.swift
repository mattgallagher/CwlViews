//
//  MyView.swift
//  CwlViews
//
//  Created by Sye Boddeus on 9/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)

import UIKit

// MARK: - Binder Part 1: Binder
public class SegmentedControl: Binder, SegmentControlConvertible {
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
		/* case someProperty(Constant<PropertyType>) */

		// 1. Value bindings may be applied at construction and may subsequently change.
		/* case someProperty(Dynamic<PropertyType>) */
		case apportionsSegmentWidthsByContent(Dynamic<Bool>)
		case backgroundImage(Dynamic<(StateAndMetrics, UIImage?)>)
		case momentary(Dynamic<Bool>)
		case segments(Dynamic<SetOrAnimate<[SegmentDescriptor]>>)
		case tintColor(Dynamic<UIColor?>)

		// 2. Signal bindings are performed on the object after construction.
		/* case someFunction(Signal<FunctionParametersAsTuple>) */
		case selectItem(Signal<Int>)
        
		// 3. Action bindings are triggered by the object after construction.
		/* case someAction(SignalInput<CallbackParameters>) */

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		/* case someDelegateFunction((Param) -> Result)) */
	}
}

// MARK: - Binder Part 3: Preparer
public extension SegmentedControl {
	struct Preparer: BinderEmbedderConstructor /* or BinderDelegateEmbedderConstructor */ {
		public typealias Binding = SegmentedControl.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UISegmentedControl

		public var inherited = Inherited()
		public init() {}
		
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension SegmentedControl.Preparer {

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .apportionsSegmentWidthsByContent(let x):
			return x.apply(instance) { i, v in i.apportionsSegmentWidthsByContent = v }
		case .backgroundImage(let x):
			return x.apply(instance) { i, v in i.setBackgroundImage(v.1, for: v.0.controlState, barMetrics: v.0.barMetrics) }
		case .momentary(let x): return x.apply(instance) { i, v in i.isMomentary = v }
		case .segments(let x):
			return x.apply(instance) { i, v in
				i.removeAllSegments()
				for (index, segment) in v.value.enumerated() {
					if let image = segment.image { i.insertSegment(with: image, at: index, animated: v.isAnimated) }
					if let title = segment.title { i.insertSegment(withTitle: title, at: index, animated: v.isAnimated) }
					if let width = segment.width { i.setWidth(width, forSegmentAt: index) }
					if let contentOffset = segment.contentOffset { i.setContentOffset(contentOffset, forSegmentAt: index) }
					if let enabled = segment.enabled { i.setEnabled(enabled, forSegmentAt: index) }
				}
			}
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
			
		// 2. Signal bindings are performed on the object after construction.
		case .selectItem(let x): return x.apply(instance) { i, v in i.selectedSegmentIndex = v }
		
        }
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SegmentedControl.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SegmentedControlBinding {
	public typealias SegmentControlName<V> = BindingName<V, SegmentedControl.Binding, Binding>
			private static func name<V>(_ source: @escaping (V) -> SegmentedControl.Binding) -> SegmentControlName<V> {
		return SegmentControlName<V>(source: source, downcast: Binding.segmentControlBinding)
	}
}
public extension BindingName where Binding: SegmentedControlBinding {
	static var apportionsSegmentWidthsByContent: SegmentControlName<Dynamic<Bool>> { return .name(SegmentedControl.Binding.apportionsSegmentWidthsByContent) }
	static var backgroundImage: SegmentControlName<Dynamic<(StateAndMetrics, UIImage?)>> { return .name(SegmentedControl.Binding.backgroundImage) }
	static var momentary: SegmentControlName<Dynamic<Bool>> { return .name(SegmentedControl.Binding.momentary)}
	static var segments: SegmentControlName<Dynamic<SetOrAnimate<[SegmentDescriptor]>>> { return .name(SegmentedControl.Binding.segments)}
	static var tintColor: SegmentControlName<Dynamic<UIColor?>> { return .name(SegmentedControl.Binding.tintColor)}
	
	static var selectItem: SegmentControlName<Signal<Int>> { return .name(SegmentedControl.Binding.selectItem)}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SegmentControlConvertible: ControlConvertible {
	func uiSegmentedControl() -> SegmentedControl.Instance
}
extension SegmentControlConvertible {
	public func uiControl() -> Control.Instance { return uiSegmentedControl() }
}
extension UISegmentedControl: SegmentControlConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func uiSegmentedControl() -> SegmentedControl.Instance { return self }
}
public extension SegmentedControl {
	func uiSegmentedControl() -> SegmentedControl.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SegmentedControlBinding: ControlBinding {
	static func segmentControlBinding(_ binding: SegmentedControl.Binding) -> Self
	func asSegmentControlBinding() -> SegmentedControl.Binding?
}
public extension SegmentedControlBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return segmentControlBinding(.inheritedBinding(binding))
	}
}
extension SegmentedControlBinding where Preparer.Inherited.Binding: SegmentedControlBinding {
	func asSegmentControlBinding() -> SegmentedControl.Binding? {
		return asInheritedBinding()?.asSegmentControlBinding()
	}
}
public extension SegmentedControl.Binding {
	typealias Preparer = SegmentedControl.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asSegmentControlBinding() -> SegmentedControl.Binding? { return self }
	static func segmentControlBinding(_ binding: SegmentedControl.Binding) -> SegmentedControl.Binding {
		return binding
	}
}

#endif
// MARK: - Binder Part 9: Other supporting types
public struct SegmentDescriptor {
	// Only one, title or image, can be non-nil
	// This is enfored through the constructor
	public let title: String?
	public let image: UIImage?

	public let width: CGFloat?
	public let contentOffset: CGSize?
	public let enabled: Bool?

	public init(title: String,
				width: CGFloat? = nil,
				contentOffset: CGSize? = nil,
				enabled: Bool? = nil) {
		self.init(image: nil,
				  title: title,
				  width: width,
				  contentOffset: contentOffset,
				  enabled: enabled)
	}

	public init(image: UIImage,
				width: CGFloat? = nil,
				contentOffset: CGSize? = nil,
				enabled: Bool? = nil) {
		self.init(image: image,
				  title: nil,
				  width: width,
				  contentOffset: contentOffset,
				  enabled: enabled)
	}

	private init(image: UIImage?,
				 title: String?,
				 width: CGFloat?,
				 contentOffset: CGSize?,
				 enabled: Bool?) {
		self.image = image
		self.title = title
		self.width = width
		self.contentOffset = contentOffset
		self.enabled = enabled
	}
}

// MARK: - Binder Part 10: Test support
#if canImport(CwlViews)
	//extension BindingParser where Downcast: ViewSubclassBinding {
		// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
		// Replace: case ([^\(]+)\((.+)\)$
		// With:    public static var $1: BindingParser<$2, ViewSubclass.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asViewSubclassBinding() }) }
	//}
#endif
