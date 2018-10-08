//
//  CwlNavigationBar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/15.
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

public class NavigationBar: ConstructingBinder, NavigationBarConvertible {
	public typealias Instance = UINavigationBar
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiNavigationBar() -> Instance { return instance() }
	
	public enum Binding: NavigationBarBinding {
		public typealias EnclosingBinder = NavigationBar
		public static func navigationBarBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case items(Dynamic<SetOrAnimate<[NavigationItemConvertible]>>)
		case backIndicatorImage(Dynamic<UIImage?>)
		case backIndicatorTransitionMaskImage(Dynamic<UIImage?>)
		case barStyle(Dynamic<UIBarStyle>)
		case barTintColor(Dynamic<UIColor?>)
		case shadowImage(Dynamic<UIImage?>)
		case tintColor(Dynamic<UIColor?>)
		case isTranslucent(Dynamic<Bool>)
		case titleTextAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		case titleVerticalPositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, CGFloat>>)
		case backgroundImage(Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		case didPush(SignalInput<UINavigationItem>)
		case didPop(SignalInput<UINavigationItem>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldPush((UINavigationBar, UINavigationItem) -> Bool)
		case shouldPop((UINavigationBar, UINavigationItem) -> Bool)
		case position((UIBarPositioning) -> UIBarPosition)
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = NavigationBar
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
			case .shouldPush(let x):
				let s = #selector(UINavigationBarDelegate.navigationBar(_:shouldPush:))
				delegate().addSelector(s).shouldPush = x
			case .shouldPop(let x):
				let s = #selector(UINavigationBarDelegate.navigationBar(_:shouldPop:))
				delegate().addSelector(s).shouldPop = x
			case .position(let x):
				let s = #selector(UINavigationBarDelegate.position(for:))
				delegate().addSelector(s).position = x
			case .didPush(let x):
				let s = #selector(UINavigationBarDelegate.navigationBar(_:didPush:))
				delegate().addSelector(s).didPush = x
			case .didPop(let x):
				let s = #selector(UINavigationBarDelegate.navigationBar(_:didPop:))
				delegate().addSelector(s).didPop = x
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			// Don't steal the delegate from the navigation controller
			if possibleDelegate != nil {
				precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
				storage.dynamicDelegate = possibleDelegate
				instance.delegate = storage
			}
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .backgroundImage(let x):
				var previous: ScopedValues<PositionAndMetrics, UIImage?>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for conditions in p.pairs {
							if conditions.value != nil {
								i.setBackgroundImage(nil, for: conditions.scope.barPosition, barMetrics: conditions.scope.barMetrics)
							}
						}
					}
					previous = v
					for conditions in v.pairs {
						if let image = conditions.value {
							i.setBackgroundImage(image, for: conditions.scope.barPosition, barMetrics: conditions.scope.barMetrics)
						}
					}
				}
			case .titleVerticalPositionAdjustment(let x):
				var previous: ScopedValues<UIBarMetrics, CGFloat>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.setTitleVerticalPositionAdjustment(0, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setTitleVerticalPositionAdjustment(c.1, for: c.0)
					}
				}
			case .items(let x): return x.apply(instance, storage) { i, s, v in i.setItems(v.value.map { $0.uiNavigationItem() }, animated: v.isAnimated) }
			case .backIndicatorImage(let x): return x.apply(instance, storage) { i, s, v in i.backIndicatorImage = v }
			case .backIndicatorTransitionMaskImage(let x): return x.apply(instance, storage) { i, s, v in i.backIndicatorTransitionMaskImage = v }
			case .barStyle(let x): return x.apply(instance, storage) { i, s, v in i.barStyle = v }
			case .barTintColor(let x): return x.apply(instance, storage) { i, s, v in i.barTintColor = v }
			case .shadowImage(let x): return x.apply(instance, storage) { i, s, v in i.shadowImage = v }
			case .tintColor(let x): return x.apply(instance, storage) { i, s, v in i.tintColor = v }
			case .isTranslucent(let x): return x.apply(instance, storage) { i, s, v in i.isTranslucent = v }
			case .titleTextAttributes(let x):
				return x.apply(instance, storage) { i, s, v in
					i.titleTextAttributes = v
				}
			case .didPush: return nil
			case .didPop: return nil
			case .shouldPush: return nil
			case .shouldPop: return nil
			case .position: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: View.Storage, UINavigationBarDelegate {}

	open class Delegate: DynamicDelegate, UINavigationBarDelegate {
		public required override init() {
			super.init()
		}
		
		open var shouldPop: ((_ navigationBar: UINavigationBar, _ item: UINavigationItem) -> Bool)?
		open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
			return shouldPop!(navigationBar, item)
		}
		
		open var shouldPush: ((_ navigationBar: UINavigationBar, _ item: UINavigationItem) -> Bool)?
		open func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
			return shouldPush!(navigationBar, item)
		}
		
		open var didPop: SignalInput<UINavigationItem>?
		open func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
			didPop!.send(value: item)
		}
		
		open var didPush: SignalInput<UINavigationItem>?
		open func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
			didPush!.send(value: item)
		}
		
		open var position: ((UIBarPositioning) -> UIBarPosition)?
		open func position(for bar: UIBarPositioning) -> UIBarPosition {
			return position!(bar)
		}
	}
}

extension BindingName where Binding: NavigationBarBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.$1(v)) }) }
	public static var items: BindingName<Dynamic<SetOrAnimate<[NavigationItemConvertible]>>, Binding> { return BindingName<Dynamic<SetOrAnimate<[NavigationItemConvertible]>>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.items(v)) }) }
	public static var backIndicatorImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.backIndicatorImage(v)) }) }
	public static var backIndicatorTransitionMaskImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.backIndicatorTransitionMaskImage(v)) }) }
	public static var barStyle: BindingName<Dynamic<UIBarStyle>, Binding> { return BindingName<Dynamic<UIBarStyle>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.barStyle(v)) }) }
	public static var barTintColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.barTintColor(v)) }) }
	public static var shadowImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.shadowImage(v)) }) }
	public static var tintColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.tintColor(v)) }) }
	public static var isTranslucent: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.isTranslucent(v)) }) }
	public static var titleTextAttributes: BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.titleTextAttributes(v)) }) }
	public static var titleVerticalPositionAdjustment: BindingName<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding> { return BindingName<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.titleVerticalPositionAdjustment(v)) }) }
	public static var backgroundImage: BindingName<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.backgroundImage(v)) }) }
	public static var didPush: BindingName<SignalInput<UINavigationItem>, Binding> { return BindingName<SignalInput<UINavigationItem>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.didPush(v)) }) }
	public static var didPop: BindingName<SignalInput<UINavigationItem>, Binding> { return BindingName<SignalInput<UINavigationItem>, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.didPop(v)) }) }
	public static var shouldPush: BindingName<(UINavigationBar, UINavigationItem) -> Bool, Binding> { return BindingName<(UINavigationBar, UINavigationItem) -> Bool, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.shouldPush(v)) }) }
	public static var shouldPop: BindingName<(UINavigationBar, UINavigationItem) -> Bool, Binding> { return BindingName<(UINavigationBar, UINavigationItem) -> Bool, Binding>({ v in .navigationBarBinding(NavigationBar.Binding.shouldPop(v)) }) }
}

public protocol NavigationBarConvertible: ViewConvertible {
	func uiNavigationBar() -> NavigationBar.Instance
}
extension NavigationBarConvertible {
	public func uiView() -> View.Instance { return uiNavigationBar() }
}
extension NavigationBar.Instance: NavigationBarConvertible {
	public func uiNavigationBar() -> NavigationBar.Instance { return self }
}

public protocol NavigationBarBinding: ViewBinding {
	static func navigationBarBinding(_ binding: NavigationBar.Binding) -> Self
}
extension NavigationBarBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return navigationBarBinding(.inheritedBinding(binding))
	}
}

public struct PositionAndMetrics {
	public let barPosition: UIBarPosition
	public let barMetrics: UIBarMetrics
	public init(position: UIBarPosition = .any, metrics: UIBarMetrics = .default) {
		self.barPosition = position
		self.barMetrics = metrics
	}
}

extension ScopedValues where Scope == PositionAndMetrics {
	public static func any(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: PositionAndMetrics(position: .any, metrics: metrics))
	}
	public static func bottom(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: PositionAndMetrics(position: .bottom, metrics: metrics))
	}
	public static func top(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: PositionAndMetrics(position: .top, metrics: metrics))
	}
	public static func topAttached(metrics: UIBarMetrics = .default, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: PositionAndMetrics(position: .topAttached, metrics: metrics))
	}
}
