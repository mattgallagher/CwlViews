//
//  CwlSegmentedControl.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

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
		case isSpringLoaded(Dynamic<Bool>)
		case distribution(Dynamic<NSSegmentedControl.Distribution>)
		case segments(Dynamic<[SegmentDescription]>)
		case segmentStyle(Dynamic<NSSegmentedControl.Style>)
		case selectedSegment(Dynamic<Int>)
		case trackingMode(Dynamic<NSSegmentedControl.SwitchTracking>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension SegmentedControl {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = SegmentedControl.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSSegmentedControl
		
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

		case .isSpringLoaded(let x): return x.apply(instance) { i, v in i.isSpringLoaded = v }
		case .distribution(let x): return x.apply(instance) { i, v in i.segmentDistribution = v }
		case .segments(let x):
			return x.apply(instance) { i, v in
				i.segmentCount = v.count
				for (index, segment) in v.enumerated() {
					i.setAlignment(segment.alignment, forSegment: index)
					i.setImage(segment.image, forSegment: index)
					i.setImageScaling(segment.imageScaling, forSegment: index)
					i.setEnabled(segment.isEnabled, forSegment: index)
					i.setLabel(segment.label, forSegment: index)
					i.setMenu(segment.menu?.nsMenu(), forSegment: index)
					i.setShowsMenuIndicator(segment.showsMenuIndicator, forSegment: index)
					i.setTag(segment.tag, forSegment: index)
					i.setToolTip(segment.toolTip, forSegment: index)
					i.setWidth(segment.width, forSegment: index)
				}
			}
		case .selectedSegment(let x): return x.apply(instance) { i, v in i.selectedSegment = v }
		case .segmentStyle(let x): return x.apply(instance) { i, v in i.segmentStyle = v }
		case .trackingMode(let x): return x.apply(instance) { i, v in i.trackingMode = v }
		}
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
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SegmentedControlName<$2> { return .name(SegmentedControl.Binding.$1) }

	static var isSpringLoaded: SegmentedControlName<Dynamic<Bool>> { return .name(SegmentedControl.Binding.isSpringLoaded) }
	static var distribution: SegmentedControlName<Dynamic<NSSegmentedControl.Distribution>> { return .name(SegmentedControl.Binding.distribution) }
	static var segments: SegmentedControlName<Dynamic<[SegmentDescription]>> { return .name(SegmentedControl.Binding.segments) }
	static var segmentStyle: SegmentedControlName<Dynamic<NSSegmentedControl.Style>> { return .name(SegmentedControl.Binding.segmentStyle) }
	static var selectedSegment: SegmentedControlName<Dynamic<Int>> { return .name(SegmentedControl.Binding.selectedSegment) }
	static var trackingMode: SegmentedControlName<Dynamic<NSSegmentedControl.SwitchTracking>> { return .name(SegmentedControl.Binding.trackingMode) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SegmentedControlConvertible: ControlConvertible {
	func nsSegmentedControl() -> SegmentedControl.Instance
}
extension SegmentedControlConvertible {
	public func nsControl() -> Control.Instance { return nsSegmentedControl() }
}
extension NSSegmentedControl: SegmentedControlConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func nsSegmentedControl() -> SegmentedControl.Instance { return self }
}
public extension SegmentedControl {
	func nsSegmentedControl() -> SegmentedControl.Instance { return instance() }
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
public extension SegmentedControlBinding where Preparer.Inherited.Binding: SegmentedControlBinding {
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
	public let alignment: NSTextAlignment
	public let image: NSImage?
	public let imageScaling: NSImageScaling
	public let isEnabled: Bool
	public let isSelected: Bool
	public let label: String
	public let menu: MenuConvertible?
	public let showsMenuIndicator: Bool
	public let tag: Int
	public let toolTip: String?
	public let width: CGFloat
	
	public init(label: String, alignment: NSTextAlignment = .center, image: NSImage? = nil, imageScaling: NSImageScaling = .scaleProportionallyDown, isEnabled: Bool = true, isSelected: Bool = false, menu: NSMenu? = nil, showsMenuIndicator: Bool = false, tag: Int = 0, toolTip: String? = nil, width: CGFloat = 0) {
		self.alignment = alignment
		self.image = image
		self.imageScaling = imageScaling
		self.isEnabled = isEnabled
		self.isSelected = isSelected
		self.label = label
		self.menu = menu
		self.showsMenuIndicator = showsMenuIndicator
		self.tag = tag
		self.toolTip = toolTip
		self.width = width
	}
}

#endif
