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

	public static var verticalThinBindings: [Binding] {
		return [
			.isVertical -- true,
			.dividerStyle -- .thin
		]
	}
	
	public static func verticalThin(type: Instance.Type = Instance.self, _ bindings: Binding...) -> SplitView {
		return SplitView(type: type, parameters: (), bindings: SplitView.verticalThinBindings + bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension SplitView {
	enum Binding: SplitViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case arrangedSubviews(Dynamic<ArrayMutation<SplitSubview>>)
		case autosaveName(Dynamic<NSSplitView.AutosaveName?>)
		case dividerStyle(Dynamic<NSSplitView.DividerStyle>)
		case isVertical(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case setDividerPosition(Signal<(position: CGFloat, dividerIndex: Int)>)

		// 3. Action bindings are triggered by the object after construction.
		case didResizeSubviews(SignalInput<Int?>)
		case willResizeSubviews(SignalInput<Int?>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case additionalEffectiveRect((_ splitView: NSSplitView, _ dividerAt: Int) -> NSRect)
		case canCollapseSubview((_ splitView: NSSplitView, _ subview: NSView) -> Bool)
		case constrainMaxCoordinate((_ splitView: NSSplitView, _ proposedMaximumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat)
		case constrainMinCoordinate((_ splitView: NSSplitView, _ proposedMinimumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat)
		case constrainSplitPosition((_ splitView: NSSplitView, _ proposedPosition: CGFloat, _ dividerIndex: Int) -> CGFloat)
		case effectiveRectForDrawnRect((_ splitView: NSSplitView, _ proposedEffectiveRect: NSRect, _ drawnRect: NSRect, _ dividerIndex: Int) -> NSRect)
		case resizeSubviews((NSSplitView, NSSize) -> Void)
		case shouldAdjustSizeOfSubview((_ splitView: NSSplitView, _ subview: NSView) -> Bool)
		case shouldCollapseSubview((_ splitView: NSSplitView, _ subview: NSView, _ dividerIndex: Int) -> Bool)
		case shouldHideDivider((_ splitView: NSSplitView, _ dividerIndex: Int) -> Bool)
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
		
		var autosaveName: Dynamic<NSSplitView.AutosaveName?>? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension SplitView.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)

		case .additionalEffectiveRect(let x): delegate().addSingleHandler2(x, #selector(NSSplitViewDelegate.splitView(_:additionalEffectiveRectOfDividerAt:)))
		case .autosaveName(let x): autosaveName = x
		case .canCollapseSubview(let x): delegate().addSingleHandler2(x, #selector(NSSplitViewDelegate.splitView(_:canCollapseSubview:)))
		case .constrainMaxCoordinate(let x): delegate().addSingleHandler3(x, #selector(NSSplitViewDelegate.splitView(_:constrainMaxCoordinate:ofSubviewAt:)))
		case .constrainMinCoordinate(let x): delegate().addSingleHandler3(x, #selector(NSSplitViewDelegate.splitView(_:constrainMinCoordinate:ofSubviewAt:)))
		case .constrainSplitPosition(let x): delegate().addSingleHandler3(x, #selector(NSSplitViewDelegate.splitView(_:constrainSplitPosition:ofSubviewAt:)))
		case .effectiveRectForDrawnRect(let x): delegate().addSingleHandler4(x, #selector(NSSplitViewDelegate.splitView(_:effectiveRect:forDrawnRect:ofDividerAt:)))
		case .resizeSubviews(let x): delegate().addMultiHandler2(x, #selector(NSSplitViewDelegate.splitView(_:resizeSubviewsWithOldSize:)))
		case .shouldAdjustSizeOfSubview(let x): delegate().addSingleHandler2(x, #selector(NSSplitViewDelegate.splitView(_:shouldAdjustSizeOfSubview:)))
		case .shouldCollapseSubview(let x): delegate().addSingleHandler3(x, #selector(NSSplitViewDelegate.splitView(_:shouldCollapseSubview:forDoubleClickOnDividerAt:)))
		case .shouldHideDivider(let x): delegate().addSingleHandler2(x, #selector(NSSplitViewDelegate.splitView(_:shouldHideDividerAt:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case .arrangedSubviews(let x): return x.apply(instance) { i, v in
			v.insertionsAndRemovals(length: i.arrangedSubviews.count, insert: { index, component in
				let view = component.view.nsView()
				view.removeFromSuperview()
				instance.insertArrangedSubview(view, at: index)
				instance.setHoldingPriority(component.holdingPriority, forSubviewAt: index)
				
				let viewAnchor = instance.isVertical ? view.widthAnchor : view.heightAnchor
				let instanceAnchor = instance.isVertical ? i.widthAnchor : i.heightAnchor
				
				NSLayoutConstraint.activate(
					component.constraints.map { $0.scaledConstraintBetween(first: viewAnchor, second: instanceAnchor) }
				)
			}, remove: { index in
				instance.removeArrangedSubview(instance.arrangedSubviews[index])
			})
		}
		case .autosaveName: return nil
		case .dividerStyle(let x): return x.apply(instance) { i, v in i.dividerStyle = v }
		case .isVertical(let x): return x.apply(instance) { i, v in i.isVertical = v }

		// 2. Signal bindings are performed on the object after construction.
		case .setDividerPosition(let x): return x.apply(instance) { i, v in i.setPosition(v.position, ofDividerAt: v.dividerIndex) }

		// 3. Action bindings are triggered by the object after construction.
		case .didResizeSubviews(let x): return Signal.notifications(name: NSSplitView.didResizeSubviewsNotification, object: instance).map { n in return n.userInfo?["NSSplitViewDividerIndex"] as? Int }.cancellableBind(to: x)
		case .willResizeSubviews(let x):return Signal.notifications(name: NSSplitView.willResizeSubviewsNotification, object: instance).map { n in return n.userInfo?["NSSplitViewDividerIndex"] as? Int }.cancellableBind(to: x)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .additionalEffectiveRect: return nil
		case .canCollapseSubview: return nil
		case .constrainMaxCoordinate: return nil
		case .constrainMinCoordinate: return nil
		case .constrainSplitPosition: return nil
		case .effectiveRectForDrawnRect: return nil
		case .resizeSubviews: return nil
		case .shouldAdjustSizeOfSubview: return nil
		case .shouldCollapseSubview: return nil
		case .shouldHideDivider: return nil
		}
	}

	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		var lifetimes = [Lifetime]()
		lifetimes += autosaveName?.apply(instance) { i, v in
			i.autosaveName = v
		}

		lifetimes += inheritedFinalizedInstance(instance, storage: storage)
		return lifetimes.isEmpty ? nil : AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SplitView.Preparer {
	open class Storage: View.Preparer.Storage, NSSplitViewDelegate {
		var constraints: [(Layout.Dimension, NSLayoutConstraint)] = []
	}
	
	open class Delegate: DynamicDelegate, NSSplitViewDelegate {
		public func splitView(_ splitView: NSSplitView, additionalEffectiveRectOfDividerAt dividerIndex: Int) -> NSRect {
			return singleHandler(splitView, dividerIndex)
		}
		
		public func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
			return singleHandler(splitView, subview)
		}
		
		public func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
			return singleHandler(splitView, proposedMaximumPosition, dividerIndex)
		}
		
		public func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
			return singleHandler(splitView, proposedMinimumPosition, dividerIndex)
		}
		
		public func splitView(_ splitView: NSSplitView, constrainSplitPosition proposedPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
			return singleHandler(splitView, proposedPosition, dividerIndex)
		}
		
		public func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
			return singleHandler(splitView, proposedEffectiveRect, drawnRect, dividerIndex)
		}
		
		public func splitView(_ splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
			multiHandler(splitView, oldSize)
		}
		
		public func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
			return singleHandler(splitView, view)
		}
		
		public func splitView(_ splitView: NSSplitView, shouldCollapseSubview subview: NSView, forDoubleClickOnDividerAt dividerIndex: Int) -> Bool {
			return singleHandler(splitView, subview, dividerIndex)
		}
		
		public func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
			return singleHandler(splitView, dividerIndex)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SplitViewBinding {
	public typealias SplitViewName<V> = BindingName<V, SplitView.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> SplitView.Binding) -> SplitViewName<V> {
		return SplitViewName<V>(source: source, downcast: Binding.splitViewBinding)
	}
}
public extension BindingName where Binding: SplitViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SplitViewName<$2> { return .name(SplitView.Binding.$1) }

	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var arrangedSubviews: SplitViewName<Dynamic<ArrayMutation<SplitSubview>>> { return .name(SplitView.Binding.arrangedSubviews) }
	static var autosaveName: SplitViewName<Dynamic<NSSplitView.AutosaveName?>> { return .name(SplitView.Binding.autosaveName) }
	static var dividerStyle: SplitViewName<Dynamic<NSSplitView.DividerStyle>> { return .name(SplitView.Binding.dividerStyle) }
	static var isVertical: SplitViewName<Dynamic<Bool>> { return .name(SplitView.Binding.isVertical) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var setDividerPosition: SplitViewName<Signal<(position: CGFloat, dividerIndex: Int)>> { return .name(SplitView.Binding.setDividerPosition) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didResizeSubviews: SplitViewName<SignalInput<Int?>> { return .name(SplitView.Binding.didResizeSubviews) }
	static var willResizeSubviews: SplitViewName<SignalInput<Int?>> { return .name(SplitView.Binding.willResizeSubviews) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var additionalEffectiveRect: SplitViewName<(_ splitView: NSSplitView, _ dividerAt: Int) -> NSRect> { return .name(SplitView.Binding.additionalEffectiveRect) }
	static var canCollapseSubview: SplitViewName<(_ splitView: NSSplitView, _ subview: NSView) -> Bool> { return .name(SplitView.Binding.canCollapseSubview) }
	static var constrainMaxCoordinate: SplitViewName<(_ splitView: NSSplitView, _ proposedMaximumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat> { return .name(SplitView.Binding.constrainMaxCoordinate) }
	static var constrainMinCoordinate: SplitViewName<(_ splitView: NSSplitView, _ proposedMinimumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat> { return .name(SplitView.Binding.constrainMinCoordinate) }
	static var constrainSplitPosition: SplitViewName<(_ splitView: NSSplitView, _ proposedPosition: CGFloat, _ dividerIndex: Int) -> CGFloat> { return .name(SplitView.Binding.constrainSplitPosition) }
	static var effectiveRectForDrawnRect: SplitViewName<(_ splitView: NSSplitView, _ proposedEffectiveRect: NSRect, _ drawnRect: NSRect, _ dividerIndex: Int) -> NSRect> { return .name(SplitView.Binding.effectiveRectForDrawnRect) }
	static var resizeSubviews: SplitViewName<(NSSplitView, NSSize) -> Void> { return .name(SplitView.Binding.resizeSubviews) }
	static var shouldAdjustSizeOfSubview: SplitViewName<(_ splitView: NSSplitView, _ subview: NSView) -> Bool> { return .name(SplitView.Binding.shouldAdjustSizeOfSubview) }
	static var shouldCollapseSubview: SplitViewName<(_ splitView: NSSplitView, _ subview: NSView, _ dividerIndex: Int) -> Bool> { return .name(SplitView.Binding.shouldCollapseSubview) }
	static var shouldHideDivider: SplitViewName<(_ splitView: NSSplitView, _ dividerIndex: Int) -> Bool> { return .name(SplitView.Binding.shouldHideDivider) }
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
	func asSplitViewBinding() -> SplitView.Binding?
}
public extension SplitViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return splitViewBinding(.inheritedBinding(binding))
	}
}
public extension SplitViewBinding where Preparer.Inherited.Binding: SplitViewBinding {
	func asSplitViewBinding() -> SplitView.Binding? {
		return asInheritedBinding()?.asSplitViewBinding()
	}
}
public extension SplitView.Binding {
	typealias Preparer = SplitView.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asSplitViewBinding() -> SplitView.Binding? { return self }
	static func splitViewBinding(_ binding: SplitView.Binding) -> SplitView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct SplitSubview {
	let view: ViewConvertible
	let holdingPriority: NSLayoutConstraint.Priority
	let constraints: [Layout.Dimension]
	
	public init(view: ViewConvertible, holdingPriority: NSLayoutConstraint.Priority, constraints: [Layout.Dimension]) {
		self.view = view
		self.holdingPriority = holdingPriority
		self.constraints = constraints
	}
	
	public static func subview(_ viewConvertible: ViewConvertible, holdingPriority: NSLayoutConstraint.Priority = .defaultLow, constraints: Layout.Dimension...) -> SplitSubview {
		return SplitSubview(view: viewConvertible, holdingPriority: holdingPriority, constraints: constraints)
	}
}

#endif
