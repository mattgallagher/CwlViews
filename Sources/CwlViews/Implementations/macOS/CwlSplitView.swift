//
//  CwlSplitView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 13/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class SplitView: Binder, SplitViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension SplitView {
	enum Binding: SplitViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.
		/* case someProperty(Constant<PropertyType>) */

		// 1. Value bindings may be applied at construction and may subsequently change.
		/* case someProperty(Dynamic<PropertyType>) */

		// 2. Signal bindings are performed on the object after construction.
		/* case someFunction(Signal<FunctionParametersAsTuple>) */

		// 3. Action bindings are triggered by the object after construction.
		/* case someAction(SignalInput<CallbackParameters>) */

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		/* case someDelegateFunction((Param) -> Result)) */
	}
}

// MARK: - Binder Part 3: Preparer
public extension SplitView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = SplitView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSSplitView
		public typealias Parameters = () /* change if non-default construction required */
		
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
public extension SplitView.Preparer {
	/* Enable if non-default construction required
	func constructInstance(type: Instance.Type, parameters: Preparer.Parameters) -> Instance {
		return type.init(someConstructionParameters: parameters)
	}
	*/

	/* Enable if delegate bindings used or setup prior to other bindings required 
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .someDelegate(let x): delegate().addMultiHandler(x, #selector(someDelegateFunction))
		default: break
	}
	*/

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		/* case .someStatic(let x): instance.someStatic = x.value */
		/* case .someProperty(let x): return x.apply(instance) { i, v in i.someProperty = v } */
		/* case .someSignal(let x): return x.apply(instance) { i, v in i.something(v) } */
		/* case .someAction(let x): return instance.addListenerAndReturnLifetime(x) */
		/* case .someDelegate(let x): return nil */
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SplitView.Preparer {
	open class Storage: View.Preparer.Storage, NSSplitViewDelegate {}
	
	open class Delegate: DynamicDelegate, NSSplitViewDelegate {
//		open func someDelegateFunction(_ splitView: NSSplitViewDelegate) -> Bool {
//			return singleHandler(splitView)
//		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SplitViewBinding {
	public typealias SplitViewName<V> = BindingName<V, SplitView.Binding, Binding>
	private typealias B = SplitView.Binding
	private static func name<V>(_ source: @escaping (V) -> SplitView.Binding) -> SplitViewName<V> {
		return SplitViewName<V>(source: source, downcast: Binding.splitViewBinding)
	}
}
public extension BindingName where Binding: SplitViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SplitViewName<$2> { return .name(B.$1) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SplitViewConvertible: ViewConvertible {
	func nsSplitView() -> SplitView.Instance
}
extension SplitViewConvertible {
	public func nsView() -> View.Instance { return nsSplitView() }
}
extension NSSplitView: SplitViewConvertible, HasDelegate {
	public func nsSplitView() -> SplitView.Instance { return self }
}
public extension SplitView {
	func nsSplitView() -> SplitView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SplitViewBinding: ViewBinding {
	static func splitViewBinding(_ binding: SplitView.Binding) -> Self
}
public extension SplitViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return splitViewBinding(.inheritedBinding(binding))
	}
}
public extension SplitView.Binding {
	typealias Preparer = SplitView.Preparer
	static func splitViewBinding(_ binding: SplitView.Binding) -> SplitView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
