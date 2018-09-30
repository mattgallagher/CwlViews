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

public class StackView: ConstructingBinder, StackViewConvertible {
#if os(macOS)
	public typealias NSUIView = NSView
	public typealias NSUIStackView = NSStackView
	public typealias NSUIStackViewDistribution = NSStackView.Gravity
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

	public typealias Instance = NSUIStackView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}

	#if os(macOS)
		public func nsStackView() -> Instance { return instance() }
	#else
		public func uiStackView() -> Instance { return instance() }
	#endif
	
	public enum Binding: StackViewBinding {
		public typealias EnclosingBinder = StackView
		public static func stackViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case alignment(Dynamic<NSUIStackViewAlignment>)
		case spacing(Dynamic<CGFloat>)
		case distribution(Dynamic<NSUIStackViewDistribution>)
		case axis(Dynamic<NSUIUserInterfaceLayoutOrientation>)
		case views(Dynamic<[ViewConvertible]>)
		#if os(macOS)
			case horizontalClippingResistance(Dynamic<NSUILayoutPriority>)
			case verticalClippingResistance(Dynamic<NSUILayoutPriority>)
			case horizontalHuggingPriority(Dynamic<NSUILayoutPriority>)
			case verticalHuggingPriority(Dynamic<NSUILayoutPriority>)
			case edgeInsets(Dynamic<NSEdgeInsets>)
			@available(*, unavailable)
			case isLayoutMarginsRelativeArrangement(())
		#else
			case isLayoutMarginsRelativeArrangement(Dynamic<Bool>)
			@available(*, unavailable)
			case edgeInsets(())
			@available(*, unavailable)
			case horizontalClippingResistance(Dynamic<NSUILayoutPriority>)
			@available(*, unavailable)
			case verticalClippingResistance(Dynamic<NSUILayoutPriority>)
			@available(*, unavailable)
			case horizontalHuggingPriority(Dynamic<NSUILayoutPriority>)
			@available(*, unavailable)
			case verticalHuggingPriority(Dynamic<NSUILayoutPriority>)
		#endif
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = StackView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .alignment(let x): return x.apply(instance, storage) { i, s, v in i.alignment = v }
			case .spacing(let x): return x.apply(instance, storage) { i, s, v in i.spacing = v }
			case .distribution(let x):
				return x.apply(instance, storage) { i, s, v in
					#if os(macOS)
						s.gravity = v
						if #available(macOS 10.11, *) {
							i.setViews(i.arrangedSubviews, in: s.gravity)
						} else {
							i.setViews(i.subviews, in: s.gravity)
						}
					#else
						i.distribution = v
					#endif
				}
			case .axis(let x):
				return x.apply(instance, storage) { i, s, v in
					#if os(macOS)
						i.orientation = v
					#else
						i.axis = v
					#endif
				}
			case .horizontalClippingResistance(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.setClippingResistancePriority(v, for: .horizontal) }
				#else
					return nil
				#endif
			case .verticalClippingResistance(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.setClippingResistancePriority(v, for: .vertical) }
				#else
					return nil
				#endif
			case .horizontalHuggingPriority(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.setHuggingPriority(v, for: .horizontal) }
				#else
					return nil
				#endif
			case .verticalHuggingPriority(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.setHuggingPriority(v, for: .vertical) }
				#else
					return nil
				#endif
			case .views(let x):
				return x.apply(instance, storage) { i, s, v in
					#if os(macOS)
						i.setViews(v.map { $0.nsView() }, in: s.gravity)
					#else
						for view in i.arrangedSubviews {
							view.removeFromSuperview()
						}
						for view in v {
							i.addArrangedSubview(view.uiView())
						}
					#endif
				}
			case .edgeInsets(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.edgeInsets = v }
				#else
					return nil
				#endif
			case .isLayoutMarginsRelativeArrangement(let x):
				#if os(macOS)
					return nil
				#else
					return x.apply(instance, storage) { i, s, v in i.isLayoutMarginsRelativeArrangement = v }
				#endif
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	#if os(macOS)
		open class Storage: View.Storage {
			open var gravity: NSStackView.Gravity = .center
		}
	#else
		public typealias Storage = View.Storage
	#endif
}

extension BindingName where Binding: StackViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .stackViewBinding(StackView.Binding.$1(v)) }) }
	public static var alignment: BindingName<Dynamic<StackView.NSUIStackViewAlignment>, Binding> { return BindingName<Dynamic<StackView.NSUIStackViewAlignment>, Binding>({ v in .stackViewBinding(StackView.Binding.alignment(v)) }) }
	public static var spacing: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .stackViewBinding(StackView.Binding.spacing(v)) }) }
	public static var distribution: BindingName<Dynamic<StackView.NSUIStackViewDistribution>, Binding> { return BindingName<Dynamic<StackView.NSUIStackViewDistribution>, Binding>({ v in .stackViewBinding(StackView.Binding.distribution(v)) }) }
	public static var axis: BindingName<Dynamic<StackView.NSUIUserInterfaceLayoutOrientation>, Binding> { return BindingName<Dynamic<StackView.NSUIUserInterfaceLayoutOrientation>, Binding>({ v in .stackViewBinding(StackView.Binding.axis(v)) }) }
	public static var views: BindingName<Dynamic<[ViewConvertible]>, Binding> { return BindingName<Dynamic<[ViewConvertible]>, Binding>({ v in .stackViewBinding(StackView.Binding.views(v)) }) }
	#if os(macOS)
		public static var horizontalClippingResistance: BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding>({ v in .stackViewBinding(StackView.Binding.horizontalClippingResistance(v)) }) }
		public static var verticalClippingResistance: BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding>({ v in .stackViewBinding(StackView.Binding.verticalClippingResistance(v)) }) }
		public static var horizontalHuggingPriority: BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding>({ v in .stackViewBinding(StackView.Binding.horizontalHuggingPriority(v)) }) }
		public static var verticalHuggingPriority: BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingName<Dynamic<StackView.NSUILayoutPriority>, Binding>({ v in .stackViewBinding(StackView.Binding.verticalHuggingPriority(v)) }) }
		public static var edgeInsets: BindingName<Dynamic<NSEdgeInsets>, Binding> { return BindingName<Dynamic<NSEdgeInsets>, Binding>({ v in .stackViewBinding(StackView.Binding.edgeInsets(v)) }) }
		@available(*, unavailable)
		public static var isLayoutMarginsRelativeArrangement: BindingName<(), Binding> { return BindingName<(), Binding>({ v in .baseBinding(.cancelOnClose(.constant([]))) }) }
	#endif
}

#if os(macOS)
	public protocol StackViewConvertible: ViewConvertible {
		func nsStackView() -> StackView.Instance
	}
	extension StackViewConvertible {
		public func nsView() -> View.Instance { return nsStackView() }
	}
	extension StackView.Instance: StackViewConvertible {
		public func nsStackView() -> StackView.Instance { return self }
	}
#else
	public protocol StackViewConvertible: ViewConvertible {
		func uiStackView() -> StackView.Instance
	}
	extension StackViewConvertible {
		public func uiView() -> View.Instance { return uiStackView() }
	}
	extension StackView.Instance: StackViewConvertible {
		public func uiStackView() -> StackView.Instance { return self }
	}
#endif

public protocol StackViewBinding: ViewBinding {
	static func stackViewBinding(_ binding: StackView.Binding) -> Self
}

extension StackViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return stackViewBinding(.inheritedBinding(binding))
	}
}
