//
//  CwlBarButtonItem_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
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
public class BarButtonItem: Binder, BarButtonItemConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension BarButtonItem {
	enum Binding: BarButtonItemBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case barButtonSystemItem(Constant<UIBarButtonItem.SystemItem>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case backButtonBackgroundImage(Dynamic<ScopedValues<StateAndMetrics, UIImage?>>)
		case backButtonTitlePositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, UIOffset>>)
		case backgroundImage(Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>)
		case backgroundVerticalPositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, CGFloat>>)
		case customView(Dynamic<ViewConvertible?>)
		case itemStyle(Dynamic<UIBarButtonItem.Style>)
		case possibleTitles(Dynamic<Set<String>?>)
		case tintColor(Dynamic<UIColor?>)
		case titlePositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, UIOffset>>)
		case width(Dynamic<CGFloat>)
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension BarButtonItem {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = BarButtonItem.Binding
		public typealias Inherited = BarItem.Preparer
		public typealias Instance = UIBarButtonItem
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		public var systemItem: UIBarButtonItem.SystemItem?
		public var customView = InitialSubsequent<ViewConvertible?>()
		public var itemStyle = InitialSubsequent<UIBarButtonItem.Style>()
		public var image = InitialSubsequent<UIImage?>()
		public var landscapeImagePhone = InitialSubsequent<UIImage?>()
		public var title = InitialSubsequent<String>()
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension BarButtonItem.Preparer {
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		let x: UIBarButtonItem
		if let si = systemItem {
			x = type.init(barButtonSystemItem: si, target: nil, action: nil)
		} else if case .some(.some(let cv)) = customView.initial {
			x = type.init(customView: cv.uiView())
		} else if case .some(.some(let i)) = image.initial {
			x = type.init(image: i, landscapeImagePhone: landscapeImagePhone.initial ?? nil, style: itemStyle.initial ?? .plain, target: nil, action: nil)
		} else {
			x = type.init(title: title.initial ?? nil, style: itemStyle.initial ?? .plain, target: nil, action: nil)
		}
		return x
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(.image(let x)): image = x.initialSubsequent()
		case .inheritedBinding(.landscapeImagePhone(let x)): landscapeImagePhone = x.initialSubsequent()
		case .inheritedBinding(.title(let x)): title = x.initialSubsequent()
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .barButtonSystemItem(let x): systemItem = x.value
		case .customView(let x): customView = x.initialSubsequent()
		case .itemStyle(let x): itemStyle = x.initialSubsequent()
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(.image): return image.apply(instance) { i, v in i.image = v }
		case .inheritedBinding(.landscapeImagePhone): return landscapeImagePhone.apply(instance) { i, v in i.landscapeImagePhone = v }
		case .inheritedBinding(.title): return title.apply(instance) { i, v in i.title = v }
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .barButtonSystemItem: return nil
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .backButtonBackgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackButtonBackgroundImage(nil, for: scope.controlState, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setBackButtonBackgroundImage(v, for: scope.controlState, barMetrics: scope.barMetrics) }
			)
		case .backButtonTitlePositionAdjustment(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackButtonTitlePositionAdjustment(UIOffset(), for: scope) },
				applyNew: { i, scope, v in i.setBackButtonTitlePositionAdjustment(v, for: scope) }
			)
		case .backgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackgroundImage(nil, for: scope.controlState, style: scope.itemStyle, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setBackgroundImage(v, for: scope.controlState, style: scope.itemStyle, barMetrics: scope.barMetrics) }
			)
		case .backgroundVerticalPositionAdjustment(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackgroundVerticalPositionAdjustment(0, for: scope) },
				applyNew: { i, scope, v in i.setBackgroundVerticalPositionAdjustment(v, for: scope) }
			)
		case .customView: return customView.apply(instance) { i, v in i.customView = v?.uiView() }
		case .itemStyle: return itemStyle.apply(instance) { i, v in i.style = v }
		case .possibleTitles(let x): return x.apply(instance) { i, v in i.possibleTitles = v }
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
		case .titlePositionAdjustment(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setTitlePositionAdjustment(UIOffset(), for: scope) },
				applyNew: { i, scope, v in i.setTitlePositionAdjustment(v, for: scope) }
			)
		case .width(let x): return x.apply(instance) { i, v in i.width = v }
			
		//	2. Signal bindings are performed on the object after construction.
			
		//	3. Action bindings are triggered by the object after construction.
		case .action(let x): return x.apply(to: instance, constructTarget: SignalActionTarget.init)
			
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension BarButtonItem.Preparer {
	public typealias Storage = BarItem.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: BarButtonItemBinding {
	public typealias BarButtonItemName<V> = BindingName<V, BarButtonItem.Binding, Binding>
	private typealias B = BarButtonItem.Binding
	private static func name<V>(_ source: @escaping (V) -> BarButtonItem.Binding) -> BarButtonItemName<V> {
		return BarButtonItemName<V>(source: source, downcast: Binding.barButtonItemBinding)
	}
}
public extension BindingName where Binding: BarButtonItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: BarButtonItemName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var barButtonSystemItem: BarButtonItemName<Constant<UIBarButtonItem.SystemItem>> { return .name(B.barButtonSystemItem) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var backButtonBackgroundImage: BarButtonItemName<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>> { return .name(B.backButtonBackgroundImage) }
	static var backButtonTitlePositionAdjustment: BarButtonItemName<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>> { return .name(B.backButtonTitlePositionAdjustment) }
	static var backgroundImage: BarButtonItemName<Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>> { return .name(B.backgroundImage) }
	static var backgroundVerticalPositionAdjustment: BarButtonItemName<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>> { return .name(B.backgroundVerticalPositionAdjustment) }
	static var customView: BarButtonItemName<Dynamic<ViewConvertible?>> { return .name(B.customView) }
	static var itemStyle: BarButtonItemName<Dynamic<UIBarButtonItem.Style>> { return .name(B.itemStyle) }
	static var possibleTitles: BarButtonItemName<Dynamic<Set<String>?>> { return .name(B.possibleTitles) }
	static var tintColor: BarButtonItemName<Dynamic<UIColor?>> { return .name(B.tintColor) }
	static var titlePositionAdjustment: BarButtonItemName<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>> { return .name(B.titlePositionAdjustment) }
	static var width: BarButtonItemName<Dynamic<CGFloat>> { return .name(B.width) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	static var action: BarButtonItemName<TargetAction> { return .name(B.action) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.

	// Composite binding names
	static func action<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> BarButtonItemName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, BarButtonItem.Binding.action, Binding.barButtonItemBinding)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol BarButtonItemConvertible: BarItemConvertible {
	func uiBarButtonItem() -> BarButtonItem.Instance
}
extension BarButtonItemConvertible {
	public func uiBarItem() -> BarItem.Instance { return uiBarButtonItem() }
}
extension UIBarButtonItem: BarButtonItemConvertible, TargetActionSender {
	public func uiBarButtonItem() -> BarButtonItem.Instance { return self }
}
public extension BarButtonItem {
	func uiBarButtonItem() -> BarButtonItem.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol BarButtonItemBinding: BarItemBinding {
	static func barButtonItemBinding(_ binding: BarButtonItem.Binding) -> Self
}
public extension BarButtonItemBinding {
	static func barItemBinding(_ binding: BarItem.Binding) -> Self {
		return barButtonItemBinding(.inheritedBinding(binding))
	}
}
public extension BarButtonItem.Binding {
	public typealias Preparer = BarButtonItem.Preparer
	static func barButtonItemBinding(_ binding: BarButtonItem.Binding) -> BarButtonItem.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct StateStyleAndMetrics {
	public let controlState: UIControl.State
	public let itemStyle: UIBarButtonItem.Style
	public let barMetrics: UIBarMetrics
	public init(state: UIControl.State = .normal, style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default) {
		self.controlState = state
		self.itemStyle = style
		self.barMetrics = metrics
	}
}

public struct StateAndMetrics {
	public let controlState: UIControl.State
	public let barMetrics: UIBarMetrics
	public init(state: UIControl.State = .normal, metrics: UIBarMetrics = .default) {
		self.controlState = state
		self.barMetrics = metrics
	}
}

extension ScopedValues where Scope == StateAndMetrics {
	public static func normal(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateAndMetrics(state: .normal, metrics: metrics))
	}
	public static func highlighted(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateAndMetrics(state: .highlighted, metrics: metrics))
	}
	public static func disabled(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateAndMetrics(state: .disabled, metrics: metrics))
	}
	public static func selected(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateAndMetrics(state: .selected, metrics: metrics))
	}
	@available(iOS 9.0, *)
	public static func focused(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateAndMetrics(state: .focused, metrics: metrics))
	}
	public static func application(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateAndMetrics(state: .application, metrics: metrics))
	}
	public static func reserved(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateAndMetrics(state: .reserved, metrics: metrics))
	}
}

extension ScopedValues where Scope == StateStyleAndMetrics {
	public static func normal(style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateStyleAndMetrics(state: .normal, metrics: metrics))
	}
	public static func highlighted(style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateStyleAndMetrics(state: .highlighted, metrics: metrics))
	}
	public static func disabled(style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateStyleAndMetrics(state: .disabled, metrics: metrics))
	}
	public static func selected(style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateStyleAndMetrics(state: .selected, metrics: metrics))
	}
	@available(iOS 9.0, *)
	public static func focused(style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateStyleAndMetrics(state: .focused, metrics: metrics))
	}
	public static func application(style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateStyleAndMetrics(state: .application, metrics: metrics))
	}
	public static func reserved(style: UIBarButtonItem.Style = .plain, metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: StateStyleAndMetrics(state: .reserved, metrics: metrics))
	}
}

extension ScopedValues where Scope == UIBarMetrics {
	public static func `default`(_ value: Value) -> ScopedValues<Scope, Value> {
		return ScopedValues<Scope, Value>(scope: .default, value: value)
	}
	public static func compact(_ value: Value) -> ScopedValues<Scope, Value> {
		return ScopedValues<Scope, Value>(scope: .compact, value: value)
	}
	public static func defaultPrompt(_ value: Value) -> ScopedValues<Scope, Value> {
		return ScopedValues<Scope, Value>(scope: .defaultPrompt, value: value)
	}
	public static func compactPrompt(_ value: Value) -> ScopedValues<Scope, Value> {
		return ScopedValues<Scope, Value>(scope: .compactPrompt, value: value)
	}
}

#endif
