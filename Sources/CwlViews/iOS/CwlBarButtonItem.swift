//
//  CwlBarButtonItem.swift
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

public class BarButtonItem: ConstructingBinder, BarButtonItemConvertible {
	public typealias Instance = UIBarButtonItem
	public typealias Inherited = BarItem
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiBarButtonItem() -> Instance { return instance() }
	
	public enum Binding: BarButtonItemBinding {
		public typealias EnclosingBinder = BarButtonItem
		public static func barButtonItemBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case barButtonSystemItem(Constant<UIBarButtonItem.SystemItem>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case itemStyle(Dynamic<UIBarButtonItem.Style>)
		case possibleTitles(Dynamic<Set<String>?>)
		case width(Dynamic<CGFloat>)
		case customView(Dynamic<ViewConvertible?>)
		case tintColor(Dynamic<UIColor?>)
		case backgroundImage(Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>)
		case backButtonBackgroundImage(Dynamic<ScopedValues<StateAndMetrics, UIImage?>>)
		case backButtonTitlePositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, UIOffset>>)
		case backgroundVerticalPositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, CGFloat>>)
		case titlePositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, UIOffset>>)
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = BarButtonItem
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			let x: UIBarButtonItem
			if let si = systemItem {
				x = subclass.init(barButtonSystemItem: si, target: nil, action: nil)
			} else if case .some(.some(let cv)) = customViewInitial {
				x = subclass.init(customView: cv.uiView())
			} else if case .some(.some(let i)) = imageInitial {
				x = subclass.init(image: i, landscapeImagePhone: landscapeImagePhoneInitial ?? nil, style: itemStyleInitial ?? .plain, target: nil, action: nil)
			} else {
				x = subclass.init(title: titleInitial ?? nil, style: itemStyleInitial ?? .plain, target: nil, action: nil)
			}
			return x
		}
		
		public var systemItem: UIBarButtonItem.SystemItem?
		public var customView = InitialSubsequent<ViewConvertible?>()
		public var customViewInitial: ViewConvertible?? = nil
		public var itemStyle = InitialSubsequent<UIBarButtonItem.Style>()
		public var itemStyleInitial: UIBarButtonItem.Style? = nil
		public var image = InitialSubsequent<UIImage?>()
		public var imageInitial: UIImage?? = nil
		public var landscapeImagePhone = InitialSubsequent<UIImage?>()
		public var landscapeImagePhoneInitial: UIImage?? = nil
		public var title = InitialSubsequent<String>()
		public var titleInitial: String? = nil
		
		public init() {}
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .barButtonSystemItem(let x): systemItem = x.value
			case .customView(let x):
				customView = x.initialSubsequent()
				customViewInitial = customView.initial()
			case .itemStyle(let x):
				itemStyle = x.initialSubsequent()
				itemStyleInitial = itemStyle.initial()
			case .inheritedBinding(.image(let x)):
				image = x.initialSubsequent()
				imageInitial = image.initial()
			case .inheritedBinding(.landscapeImagePhone(let x)):
				landscapeImagePhone = x.initialSubsequent()
				landscapeImagePhoneInitial = landscapeImagePhone.initial()
			case .inheritedBinding(.title(let x)):
				title = x.initialSubsequent()
				titleInitial = title.initial()
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .barButtonSystemItem: return nil
			case .backgroundImage(let x):
				var previous: ScopedValues<StateStyleAndMetrics, UIImage?>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for conditions in p.pairs {
							if conditions.value != nil {
								i.setBackgroundImage(nil, for: conditions.scope.controlState, style: conditions.scope.itemStyle, barMetrics: conditions.scope.barMetrics)
							}
						}
					}
					previous = v
					for conditions in v.pairs {
						if let image = conditions.value {
							i.setBackgroundImage(image, for: conditions.scope.controlState, style: conditions.scope.itemStyle, barMetrics: conditions.scope.barMetrics)
						}
					}
				}
			case .backButtonBackgroundImage(let x):
				var previous: ScopedValues<StateAndMetrics, UIImage?>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for conditions in p.pairs {
							if conditions.value != nil {
								i.setBackButtonBackgroundImage(nil, for: conditions.scope.controlState, barMetrics: conditions.scope.barMetrics)
							}
						}
					}
					previous = v
					for conditions in v.pairs {
						if let image = conditions.value {
							i.setBackButtonBackgroundImage(image, for: conditions.scope.controlState, barMetrics: conditions.scope.barMetrics)
						}
					}
				}
			case .backButtonTitlePositionAdjustment(let x):
				var previous: ScopedValues<UIBarMetrics, UIOffset>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.setBackButtonTitlePositionAdjustment(UIOffset(), for: c.scope)
						}
					}
					previous = v
					for c in v.pairs {
						i.setBackButtonTitlePositionAdjustment(c.value, for: c.scope)
					}
				}
			case .backgroundVerticalPositionAdjustment(let x):
				var previous: ScopedValues<UIBarMetrics, CGFloat>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.setBackgroundVerticalPositionAdjustment(0, for: c.scope)
						}
					}
					previous = v
					for c in v.pairs {
						i.setBackgroundVerticalPositionAdjustment(c.value, for: c.scope)
					}
				}
			case .titlePositionAdjustment(let x):
				var previous: ScopedValues<UIBarMetrics, UIOffset>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.setTitlePositionAdjustment(UIOffset(), for: c.scope)
						}
					}
					previous = v
					for c in v.pairs {
						i.setTitlePositionAdjustment(c.value, for: c.scope)
					}
				}
			case .itemStyle:
				return itemStyle.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in i.style = v } }
			case .possibleTitles(let x): return x.apply(instance, storage) { i, s, v in i.possibleTitles = v }
			case .width(let x): return x.apply(instance, storage) { i, s, v in i.width = v }
			case .customView:
				return customView.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in i.customView = v?.uiView() } }
			case .tintColor(let x): return x.apply(instance, storage) { i, s, v in i.tintColor = v }
			case .action(let x): return x.apply(instance: instance, constructTarget: SignalActionTarget.init, processor: { sender in () })
				
			case .inheritedBinding(.image): return image.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in i.image = v } }
			case .inheritedBinding(.landscapeImagePhone): return landscapeImagePhone.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in i.landscapeImagePhone = v } }
			case .inheritedBinding(.title): return title.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in i.title = v } }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = BarItem.Storage
}

extension BindingName where Binding: BarButtonItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.$1(v)) }) }
	public static var barButtonSystemItem: BindingName<Constant<UIBarButtonItem.SystemItem>, Binding> { return BindingName<Constant<UIBarButtonItem.SystemItem>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.barButtonSystemItem(v)) }) }
	public static var itemStyle: BindingName<Dynamic<UIBarButtonItem.Style>, Binding> { return BindingName<Dynamic<UIBarButtonItem.Style>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.itemStyle(v)) }) }
	public static var possibleTitles: BindingName<Dynamic<Set<String>?>, Binding> { return BindingName<Dynamic<Set<String>?>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.possibleTitles(v)) }) }
	public static var width: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.width(v)) }) }
	public static var customView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.customView(v)) }) }
	public static var tintColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.tintColor(v)) }) }
	public static var backgroundImage: BindingName<Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.backgroundImage(v)) }) }
	public static var backButtonBackgroundImage: BindingName<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.backButtonBackgroundImage(v)) }) }
	public static var backButtonTitlePositionAdjustment: BindingName<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding> { return BindingName<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.backButtonTitlePositionAdjustment(v)) }) }
	public static var backgroundVerticalPositionAdjustment: BindingName<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding> { return BindingName<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.backgroundVerticalPositionAdjustment(v)) }) }
	public static var titlePositionAdjustment: BindingName<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding> { return BindingName<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.titlePositionAdjustment(v)) }) }
	public static var action: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .barButtonItemBinding(BarButtonItem.Binding.action(v)) }) }
}

extension BindingName where Binding: BarButtonItemBinding, Binding.EnclosingBinder: BinderChain {
	public static func action<I: SignalInputInterface, Value>(_ keyPath: KeyPath<Binding.EnclosingBinder.Instance, Value>) -> BindingName<I, Binding> where I.InputValue == Value {
		return BindingName<I, Binding> { (v: I) -> Binding in
			Binding.barButtonItemBinding(
				BarButtonItem.Binding.action(
					TargetAction.singleTarget(
						Input<Any?>()
							.map { i -> Value in
								(i as! Binding.EnclosingBinder.Instance)[keyPath: keyPath]
							}
							.bind(to: v.input)
					)
				)
			)
		}
	}
}

public protocol BarButtonItemConvertible: BarItemConvertible {
	func uiBarButtonItem() -> BarButtonItem.Instance
}
extension BarButtonItemConvertible {
	public func uiBarItem() -> BarItem.Instance { return uiBarButtonItem() }
}
extension BarButtonItem.Instance: BarButtonItemConvertible {
	public func uiBarButtonItem() -> BarButtonItem.Instance { return self }
}

public protocol BarButtonItemBinding: BarItemBinding {
	static func barButtonItemBinding(_ binding: BarButtonItem.Binding) -> Self
}
extension BarButtonItemBinding {
	public static func barItemBinding(_ binding: BarItem.Binding) -> Self {
		return barButtonItemBinding(.inheritedBinding(binding))
	}
}

extension UIBarButtonItem: TargetActionSender {}

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

