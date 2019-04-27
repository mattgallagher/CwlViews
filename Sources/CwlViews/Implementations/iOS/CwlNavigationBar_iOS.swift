//
//  CwlNavigationBar_iOS.swift
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class NavigationBar: Binder, NavigationBarConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension NavigationBar {
	enum Binding: NavigationBarBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundImage(Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>)
		case backIndicatorImage(Dynamic<UIImage?>)
		case backIndicatorTransitionMaskImage(Dynamic<UIImage?>)
		case barStyle(Dynamic<UIBarStyle>)
		case barTintColor(Dynamic<UIColor?>)
		case isTranslucent(Dynamic<Bool>)
		case items(Dynamic<StackMutation<NavigationItemConvertible>>)
		case shadowImage(Dynamic<UIImage?>)
		case tintColor(Dynamic<UIColor?>)
		case titleTextAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		case titleVerticalPositionAdjustment(Dynamic<ScopedValues<UIBarMetrics, CGFloat>>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didPop((UINavigationBar, UINavigationItem) -> Void)
		case didPush((UINavigationBar, UINavigationItem) -> Void)
		case position((UIBarPositioning) -> UIBarPosition)
		case shouldPop((UINavigationBar, UINavigationItem) -> Bool)
		case shouldPush((UINavigationBar, UINavigationItem) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension NavigationBar {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = NavigationBar.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UINavigationBar
		
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
public extension NavigationBar.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding { 
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .didPop(let x): delegate().addMultiHandler2(x, #selector(UINavigationBarDelegate.navigationBar(_:didPop:)))
		case .didPush(let x): delegate().addMultiHandler2(x, #selector(UINavigationBarDelegate.navigationBar(_:didPush:)))
		case .position(let x): delegate().addSingleHandler1(x, #selector(UINavigationBarDelegate.position(for:)))
		case .shouldPop(let x): delegate().addSingleHandler2(x, #selector(UINavigationBarDelegate.navigationBar(_:shouldPop:)))
		case .shouldPush(let x): delegate().addSingleHandler2(x, #selector(UINavigationBarDelegate.navigationBar(_:shouldPush:)))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .backgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackgroundImage(nil, for: scope.barPosition, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setBackgroundImage(v, for: scope.barPosition, barMetrics: scope.barMetrics) }
			)
		case .backIndicatorImage(let x): return x.apply(instance) { i, v in i.backIndicatorImage = v }
		case .backIndicatorTransitionMaskImage(let x): return x.apply(instance) { i, v in i.backIndicatorTransitionMaskImage = v }
		case .barStyle(let x): return x.apply(instance) { i, v in i.barStyle = v }
		case .barTintColor(let x): return x.apply(instance) { i, v in i.barTintColor = v }
		case .isTranslucent(let x): return x.apply(instance) { i, v in i.isTranslucent = v }
		case .items(let x):
			return x.apply(instance, storage) { i, s, v in
				switch v {
				case .push(let e):
					i.pushItem(e.uiNavigationItem(), animated: true)
				case .pop:
					i.popItem(animated: true)
				case .popToCount(let c):
					i.setItems(i.items?.dropLast((i.items?.count ?? 0) - c) ?? [], animated: true)
				case .reload(let newStack):
					i.setItems(newStack.map { $0.uiNavigationItem() }, animated: false)
				}
			}
		case .shadowImage(let x): return x.apply(instance) { i, v in i.shadowImage = v }
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
		case .titleTextAttributes(let x): return x.apply(instance) { i, v in i.titleTextAttributes = v }
		case .titleVerticalPositionAdjustment(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setTitleVerticalPositionAdjustment(0, for: scope) },
				applyNew: { i, scope, v in i.setTitleVerticalPositionAdjustment(v, for: scope) }
			)
			
		// 2. Signal bindings are performed on the object after construction.
			
		//	3. Action bindings are triggered by the object after construction.
		case .didPush: return nil
		case .didPop: return nil
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .position: return nil
		case .shouldPop: return nil
		case .shouldPush: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension NavigationBar.Preparer {
	open class Storage: View.Preparer.Storage, UINavigationBarDelegate {}

	open class Delegate: DynamicDelegate, UINavigationBarDelegate {
		open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
			return singleHandler(navigationBar, item)
		}
		
		open func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
			return singleHandler(navigationBar, item)
		}
		
		open func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
			multiHandler(navigationBar, item)
		}
		
		open func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
			multiHandler(navigationBar, item)
		}
		
		open func position(for bar: UIBarPositioning) -> UIBarPosition {
			return singleHandler(bar)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: NavigationBarBinding {
	public typealias NavigationBarName<V> = BindingName<V, NavigationBar.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> NavigationBar.Binding) -> NavigationBarName<V> {
		return NavigationBarName<V>(source: source, downcast: Binding.scrollViewBinding)
	}
}
public extension BindingName where Binding: NavigationBarBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: NavigationBarName<$2> { return .name(NavigationBar.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backgroundImage: NavigationBarName<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>> { return .name(NavigationBar.Binding.backgroundImage) }
	static var backIndicatorImage: NavigationBarName<Dynamic<UIImage?>> { return .name(NavigationBar.Binding.backIndicatorImage) }
	static var backIndicatorTransitionMaskImage: NavigationBarName<Dynamic<UIImage?>> { return .name(NavigationBar.Binding.backIndicatorTransitionMaskImage) }
	static var barStyle: NavigationBarName<Dynamic<UIBarStyle>> { return .name(NavigationBar.Binding.barStyle) }
	static var barTintColor: NavigationBarName<Dynamic<UIColor?>> { return .name(NavigationBar.Binding.barTintColor) }
	static var isTranslucent: NavigationBarName<Dynamic<Bool>> { return .name(NavigationBar.Binding.isTranslucent) }
	static var items: NavigationBarName<Dynamic<StackMutation<NavigationItemConvertible>>> { return .name(NavigationBar.Binding.items) }
	static var shadowImage: NavigationBarName<Dynamic<UIImage?>> { return .name(NavigationBar.Binding.shadowImage) }
	static var tintColor: NavigationBarName<Dynamic<UIColor?>> { return .name(NavigationBar.Binding.tintColor) }
	static var titleTextAttributes: NavigationBarName<Dynamic<[NSAttributedString.Key: Any]>> { return .name(NavigationBar.Binding.titleTextAttributes) }
	static var titleVerticalPositionAdjustment: NavigationBarName<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>> { return .name(NavigationBar.Binding.titleVerticalPositionAdjustment) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var didPop: NavigationBarName<(UINavigationBar, UINavigationItem) -> Void> { return .name(NavigationBar.Binding.didPop) }
	static var didPush: NavigationBarName<(UINavigationBar, UINavigationItem) -> Void> { return .name(NavigationBar.Binding.didPush) }
	static var position: NavigationBarName<(UIBarPositioning) -> UIBarPosition> { return .name(NavigationBar.Binding.position) }
	static var shouldPop: NavigationBarName<(UINavigationBar, UINavigationItem) -> Bool> { return .name(NavigationBar.Binding.shouldPop) }
	static var shouldPush: NavigationBarName<(UINavigationBar, UINavigationItem) -> Bool> { return .name(NavigationBar.Binding.shouldPush) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol NavigationBarConvertible: ViewConvertible {
	func uiNavigationBar() -> NavigationBar.Instance
}
extension NavigationBarConvertible {
	public func uiView() -> View.Instance { return uiNavigationBar() }
}
extension UINavigationBar: NavigationBarConvertible, HasDelegate {
	public func uiNavigationBar() -> NavigationBar.Instance { return self }
}
public extension NavigationBar {
	func uiNavigationBar() -> NavigationBar.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol NavigationBarBinding: ViewBinding {
	static func scrollViewBinding(_ binding: NavigationBar.Binding) -> Self
	func asNavigationBarBinding() -> NavigationBar.Binding?
}
public extension NavigationBarBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return scrollViewBinding(.inheritedBinding(binding))
	}
}
public extension NavigationBarBinding where Preparer.Inherited.Binding: NavigationBarBinding {
	func asNavigationBarBinding() -> NavigationBar.Binding? {
		return asInheritedBinding()?.asNavigationBarBinding()
	}
}
public extension NavigationBar.Binding {
	typealias Preparer = NavigationBar.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asNavigationBarBinding() -> NavigationBar.Binding? { return self }
	static func scrollViewBinding(_ binding: NavigationBar.Binding) -> NavigationBar.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
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

#endif
