//
//  CwlToolbar_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/2/19.
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
public class Toolbar: Binder, ToolbarConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Toolbar {
	enum Binding: ToolbarBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundImage(Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>)
		case barStyle(Dynamic<UIBarStyle>)
		case barTintColor(Dynamic<UIColor?>)
		case isTranslucent(Dynamic<Bool>)
		case items(Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>)
		case shadowImage(Dynamic<ScopedValues<UIBarPosition, UIImage?>>)
		case tintColor(Dynamic<UIColor?>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case position((UIBarPositioning) -> UIBarPosition)
	}
}

// MARK: - Binder Part 3: Preparer
public extension Toolbar {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = Toolbar.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UIToolbar
		
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
public extension Toolbar.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
			
		case .position(let x): delegate().addSingleHandler1(x, #selector(UIToolbarDelegate.position(for:)))
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
				removeOld: { i, scope, v in i.setBackgroundImage(nil, forToolbarPosition: scope.barPosition, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setBackgroundImage(v, forToolbarPosition: scope.barPosition, barMetrics: scope.barMetrics) }
			)
		case .barStyle(let x): return x.apply(instance) { i, v in i.barStyle = v }
		case .barTintColor(let x): return x.apply(instance) { i, v in i.barTintColor = v }
		case .isTranslucent(let x): return x.apply(instance) { i, v in i.isTranslucent = v }
		case .items(let x): return x.apply(instance) { i, v in i.setItems(v.value.map { $0.uiBarButtonItem() }, animated: v.isAnimated) }
		case .shadowImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setShadowImage(nil, forToolbarPosition: scope) },
				applyNew: { i, scope, v in i.setShadowImage(v, forToolbarPosition: scope) }
			)
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
			
			// 2. Signal bindings are performed on the object after construction.
			
		//	3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .position: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Toolbar.Preparer {
	open class Storage: View.Preparer.Storage, UIToolbarDelegate {}
	
	open class Delegate: DynamicDelegate, UIToolbarDelegate {
		open func position(for bar: UIBarPositioning) -> UIBarPosition {
			return singleHandler(bar)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ToolbarBinding {
	public typealias ToolbarName<V> = BindingName<V, Toolbar.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> Toolbar.Binding) -> ToolbarName<V> {
		return ToolbarName<V>(source: source, downcast: Binding.scrollViewBinding)
	}
}
public extension BindingName where Binding: ToolbarBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ToolbarName<$2> { return .name(Toolbar.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backgroundImage: ToolbarName<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>> { return .name(Toolbar.Binding.backgroundImage) }
	static var barStyle: ToolbarName<Dynamic<UIBarStyle>> { return .name(Toolbar.Binding.barStyle) }
	static var barTintColor: ToolbarName<Dynamic<UIColor?>> { return .name(Toolbar.Binding.barTintColor) }
	static var isTranslucent: ToolbarName<Dynamic<Bool>> { return .name(Toolbar.Binding.isTranslucent) }
	static var items: ToolbarName<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> { return .name(Toolbar.Binding.items) }
	static var shadowImage: ToolbarName<Dynamic<ScopedValues<UIBarPosition, UIImage?>>> { return .name(Toolbar.Binding.shadowImage) }
	static var tintColor: ToolbarName<Dynamic<UIColor?>> { return .name(Toolbar.Binding.tintColor) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var position: ToolbarName<(UIBarPositioning) -> UIBarPosition> { return .name(Toolbar.Binding.position) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ToolbarConvertible: ViewConvertible {
	func uiToolbar() -> Toolbar.Instance
}
extension ToolbarConvertible {
	public func uiView() -> View.Instance { return uiToolbar() }
}
extension UIToolbar: ToolbarConvertible, HasDelegate {
	public func uiToolbar() -> Toolbar.Instance { return self }
}
public extension Toolbar {
	func uiToolbar() -> Toolbar.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ToolbarBinding: ViewBinding {
	static func scrollViewBinding(_ binding: Toolbar.Binding) -> Self
	func asToolbarBinding() -> Toolbar.Binding?
}
public extension ToolbarBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return scrollViewBinding(.inheritedBinding(binding))
	}
}
public extension ToolbarBinding where Preparer.Inherited.Binding: ToolbarBinding {
	func asToolbarBinding() -> Toolbar.Binding? {
		return asInheritedBinding()?.asToolbarBinding()
	}
}
public extension Toolbar.Binding {
	typealias Preparer = Toolbar.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asToolbarBinding() -> Toolbar.Binding? { return self }
	static func scrollViewBinding(_ binding: Toolbar.Binding) -> Toolbar.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
