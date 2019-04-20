//
//  CwlExtendedView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 12/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

// MARK: - Binder Part 1: Binder
public class ExtendedView<Subclass: Layout.View & ViewWithDelegate & HasDelegate>: Binder, ViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

extension ExtendedView where Subclass == CwlExtendedView {
	public convenience init(bindings: [Preparer.Binding]) {
		self.init(type: CwlExtendedView.self, parameters: (), bindings: bindings)
	}
	
	public convenience init(_ bindings: Preparer.Binding...) {
		self.init(type: CwlExtendedView.self, parameters: (), bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ExtendedView {
	enum Binding: ExtendedViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		@available(macOS 10.10, *) @available(iOS, unavailable) case backgroundColor(Dynamic<NSColor?>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.
		case sizeDidChange(SignalInput<CGSize>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	#if os(macOS)
		typealias NSColor = AppKit.NSColor
	#else
		typealias NSColor = ()
	#endif
}

// MARK: - Binder Part 3: Preparer
public extension ExtendedView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = ExtendedView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = Subclass
		
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
public extension ExtendedView.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .sizeDidChange(let x): delegate().addMultiHandler1({ s in x.send(value: s) }, #selector(ViewDelegate.layoutSubviews(view:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		case .backgroundColor(let x):
			return x.apply(instance) { i, v in
				#if os(macOS)
					i.backgroundColor = v
				#endif
			}
		case .sizeDidChange: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ExtendedView.Preparer {
	open class Storage: View.Preparer.Storage, ViewDelegate {}
	
	open class Delegate: DynamicDelegate, ViewDelegate {
		open func layoutSubviews(view: Layout.View) {
			multiHandler(view.bounds.size)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ExtendedViewBinding {
	public typealias ExtendedViewName<V> = BindingName<V, ExtendedView<Binding.SubclassType>.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> ExtendedView<Binding.SubclassType>.Binding) -> ExtendedViewName<V> {
		return ExtendedViewName<V>(source: source, downcast: Binding.extendedViewBinding)
	}
}
public extension BindingName where Binding: ExtendedViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ExtendedViewName<$2> { return .name(ExtendedView.Binding.$1) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	#if os(macOS)
		static var backgroundColor: ExtendedViewName<Dynamic<NSColor?>> { return .name(ExtendedView.Binding.backgroundColor) }
	#endif
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	static var sizeDidChange: ExtendedViewName<SignalInput<CGSize>> { return .name(ExtendedView.Binding.sizeDidChange) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public extension ExtendedView {
	#if os(iOS)
		func uiView() -> View.Instance { return instance() }
	#elseif os(macOS)
		func nsView() -> View.Instance { return instance() }
	#endif
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ExtendedViewBinding: ViewBinding {
	associatedtype SubclassType: Layout.View & ViewWithDelegate & HasDelegate
	static func extendedViewBinding(_ binding: ExtendedView<SubclassType>.Binding) -> Self
}
public extension ExtendedViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return extendedViewBinding(.inheritedBinding(binding))
	}
}
public extension ExtendedView.Binding {
	typealias Preparer = ExtendedView.Preparer
	static func extendedViewBinding(_ binding: ExtendedView.Binding) -> ExtendedView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
@objc public protocol ViewDelegate: class {
	@objc optional func layoutSubviews(view: Layout.View)
}

public protocol ViewWithDelegate: class {
	var delegate: ViewDelegate? { get set }

	#if os(macOS)
		var backgroundColor: NSColor? { get set }
	#endif
}

#if os(macOS)
	extension ViewWithDelegate {
		// This default implementation is so that you're not required to implement `backgroundColor` to implement an ExtendedView
		var backgroundColor: NSColor? {
			get {
				return ((self as? NSView)?.layer?.backgroundColor).flatMap { NSColor(cgColor: $0) }
			}
			set {
				if let layer = (self as? NSView)?.layer {
					layer.backgroundColor = newValue?.cgColor 
				}
			}
		}
	}
#endif

/// Implementation of ViewWithDelegate on top of the base UIView.
/// You can use this view directly, subclass it or implement `ViewWithDelegate` and `HasDelegate` on top of another `UIView` to use that view with the `ExtendedView` binder.
open class CwlExtendedView: Layout.View, ViewWithDelegate, HasDelegate {
	public unowned var delegate: ViewDelegate?
	
	#if os(macOS)
		open var backgroundColor: NSColor?
	
		open override func draw(_ dirtyRect: NSRect) {
			super.draw(dirtyRect)
			
			if let backgroundColor = backgroundColor {
				backgroundColor.setFill()
				dirtyRect.fill()
			}
		}
	#endif
	
	#if os(iOS)
		open override func layoutSubviews() {
			delegate?.layoutSubviews?(view: self)
			super.layoutSubviews()
		}
	#elseif os(macOS)
		open override func layout() {
			delegate?.layoutSubviews?(view: self)
			super.layout()
		}
	#endif
}
