//
//  CwlStackView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/10/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

// MARK: - Binder Part 1: Binder
public class StackView: Binder, StackViewConvertible {
	#if os(macOS)
		public typealias NSUIView = NSView
		public typealias NSUIStackView = NSStackView
		public typealias NSUIStackViewDistribution = NSStackView.Distribution
		public typealias NSUIStackViewAlignment = NSLayoutConstraint.Attribute
		public typealias NSUIUserInterfaceLayoutOrientation = NSUserInterfaceLayoutOrientation
		public typealias NSUILayoutPriority = NSLayoutConstraint.Priority
	#else
		public typealias NSUIView = UIView
		public typealias NSUIStackView = UIStackView
		public typealias NSUIStackViewDistribution = UIStackView.Distribution
		public typealias NSUIStackViewAlignment = UIStackView.Alignment
		public typealias NSUIUserInterfaceLayoutOrientation = NSLayoutConstraint.Axis
		public typealias NSUILayoutPriority = UILayoutPriority
	#endif

	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension StackView {
	enum Binding: StackViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case alignment(Dynamic<NSUIStackViewAlignment>)
		case arrangedSubviews(Dynamic<[ViewConvertible]>)
		case axis(Dynamic<NSUIUserInterfaceLayoutOrientation>)
		case distribution(Dynamic<NSUIStackViewDistribution>)
		case spacing(Dynamic<CGFloat>)
		
		@available(macOS 10.13, *) @available(iOS, unavailable) case edgeInsets(Dynamic<EdgeInsets>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case horizontalClippingResistance(Dynamic<NSUILayoutPriority>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case horizontalHuggingPriority(Dynamic<NSUILayoutPriority>)
		@available(macOS, unavailable) @available(iOS 11, *) case isLayoutMarginsRelativeArrangement(Dynamic<Bool>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case verticalClippingResistance(Dynamic<NSUILayoutPriority>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case verticalHuggingPriority(Dynamic<NSUILayoutPriority>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	#if os(macOS)
		public typealias EdgeInsets = NSEdgeInsets
	#else
		public typealias EdgeInsets = UIEdgeInsets
	#endif
}

// MARK: - Binder Part 3: Preparer
public extension StackView {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = StackView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSUIStackView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension StackView.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .alignment(let x): return x.apply(instance) { i, v in i.alignment = v }
		case .axis(let x):
			return x.apply(instance) { i, v in
				#if os(macOS)
					i.orientation = v
				#else
					i.axis = v
				#endif
			}
		case .arrangedSubviews(let x):
			return x.apply(instance) { i, v in
				i.arrangedSubviews.forEach { $0.removeFromSuperview() }
				#if os(macOS)
					v.forEach { i.addArrangedSubview($0.nsView()) }
				#else
					v.forEach { i.addArrangedSubview($0.uiView()) }
				#endif
			}
		case .distribution(let x): return x.apply(instance) { i, v in i.distribution = v }
		case .spacing(let x): return x.apply(instance) { i, v in i.spacing = v }

		case .edgeInsets(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.edgeInsets = v }
			#else
				return nil
			#endif
		case .horizontalClippingResistance(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.setClippingResistancePriority(v, for: .horizontal) }
			#else
				return nil
			#endif
		case .horizontalHuggingPriority(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.setHuggingPriority(v, for: .horizontal) }
			#else
				return nil
			#endif
		case .isLayoutMarginsRelativeArrangement(let x):
			#if os(macOS)
				return nil
			#else
				return x.apply(instance) { i, v in i.isLayoutMarginsRelativeArrangement = v }
			#endif
		case .verticalClippingResistance(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.setClippingResistancePriority(v, for: .vertical) }
			#else
				return nil
			#endif
		case .verticalHuggingPriority(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.setHuggingPriority(v, for: .vertical) }
			#else
				return nil
			#endif
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension StackView.Preparer {
	#if os(macOS)
		open class Storage: View.Preparer.Storage {
			open var gravity: NSStackView.Gravity = .center
		}
	#else
		public typealias Storage = View.Preparer.Storage
	#endif
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: StackViewBinding {
	public typealias StackViewName<V> = BindingName<V, StackView.Binding, Binding>
	private typealias B = StackView.Binding
	private static func name<V>(_ source: @escaping (V) -> StackView.Binding) -> StackViewName<V> {
		return StackViewName<V>(source: source, downcast: Binding.stackViewBinding)
	}
}
public extension BindingName where Binding: StackViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: StackViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var alignment: StackViewName<Dynamic<StackView.NSUIStackViewAlignment>> { return .name(B.alignment) }
	static var arrangedSubviews: StackViewName<Dynamic<[ViewConvertible]>> { return .name(B.arrangedSubviews) }
	static var axis: StackViewName<Dynamic<StackView.NSUIUserInterfaceLayoutOrientation>> { return .name(B.axis) }
	static var distribution: StackViewName<Dynamic<StackView.NSUIStackViewDistribution>> { return .name(B.distribution) }
	static var spacing: StackViewName<Dynamic<CGFloat>> { return .name(B.spacing) }
	
	@available(macOS 10.13, *) @available(iOS, unavailable) static var edgeInsets: StackViewName<Dynamic<StackView.EdgeInsets>> { return .name(B.edgeInsets) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var horizontalClippingResistance: StackViewName<Dynamic<StackView.NSUILayoutPriority>> { return .name(B.horizontalClippingResistance) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var horizontalHuggingPriority: StackViewName<Dynamic<StackView.NSUILayoutPriority>> { return .name(B.horizontalHuggingPriority) }
	@available(macOS, unavailable) @available(iOS 11, *) static var isLayoutMarginsRelativeArrangement: StackViewName<Dynamic<Bool>> { return .name(B.isLayoutMarginsRelativeArrangement) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var verticalClippingResistance: StackViewName<Dynamic<StackView.NSUILayoutPriority>> { return .name(B.verticalClippingResistance) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var verticalHuggingPriority: StackViewName<Dynamic<StackView.NSUILayoutPriority>> { return .name(B.verticalHuggingPriority) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
#if os(macOS)
	public protocol StackViewConvertible: ViewConvertible {
		func nsStackView() -> StackView.Instance
	}
	public extension StackViewConvertible {
		func nsView() -> View.Instance { return nsStackView() }
	}
	extension NSStackView: StackViewConvertible {
		public func nsStackView() -> StackView.Instance { return self }
	}
	public extension StackView {
		func nsStackView() -> StackView.Instance { return instance() }
	}
#else
	public protocol StackViewConvertible: ViewConvertible {
		func uiStackView() -> StackView.Instance
	}
	public extension StackViewConvertible {
		func uiView() -> View.Instance { return uiStackView() }
	}
	extension UIStackView: StackViewConvertible {
		public func uiStackView() -> StackView.Instance { return self }
	}
	public extension StackView {
		func uiStackView() -> StackView.Instance { return instance() }
	}
#endif

// MARK: - Binder Part 8: Downcast protocols
public protocol StackViewBinding: ViewBinding {
	static func stackViewBinding(_ binding: StackView.Binding) -> Self
}
public extension StackViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return stackViewBinding(.inheritedBinding(binding))
	}
}
public extension StackView.Binding {
	public typealias Preparer = StackView.Preparer
	static func stackViewBinding(_ binding: StackView.Binding) -> StackView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
