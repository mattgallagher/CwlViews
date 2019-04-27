//
//  CwlSplitView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 13/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Downcast: SplitViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, SplitView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asSplitViewBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var arrangedSubviews: BindingParser<Dynamic<ArrayMutation<SplitSubview>>, SplitView.Binding, Downcast> { return .init(extract: { if case .arrangedSubviews(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var autosaveName: BindingParser<Dynamic<NSSplitView.AutosaveName?>, SplitView.Binding, Downcast> { return .init(extract: { if case .autosaveName(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var dividerStyle: BindingParser<Dynamic<NSSplitView.DividerStyle>, SplitView.Binding, Downcast> { return .init(extract: { if case .dividerStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var isVertical: BindingParser<Dynamic<Bool>, SplitView.Binding, Downcast> { return .init(extract: { if case .isVertical(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var setDividerPosition: BindingParser<Signal<(position: CGFloat, dividerIndex: Int)>, SplitView.Binding, Downcast> { return .init(extract: { if case .setDividerPosition(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didResizeSubviews: BindingParser<SignalInput<Int?>, SplitView.Binding, Downcast> { return .init(extract: { if case .didResizeSubviews(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var willResizeSubviews: BindingParser<SignalInput<Int?>, SplitView.Binding, Downcast> { return .init(extract: { if case .willResizeSubviews(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var additionalEffectiveRect: BindingParser<(_ splitView: NSSplitView, _ dividerAt: Int) -> NSRect, SplitView.Binding, Downcast> { return .init(extract: { if case .additionalEffectiveRect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var canCollapseSubview: BindingParser<(_ splitView: NSSplitView, _ subview: NSView) -> Bool, SplitView.Binding, Downcast> { return .init(extract: { if case .canCollapseSubview(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var constrainMaxCoordinate: BindingParser<(_ splitView: NSSplitView, _ proposedMaximumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, SplitView.Binding, Downcast> { return .init(extract: { if case .constrainMaxCoordinate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var constrainMinCoordinate: BindingParser<(_ splitView: NSSplitView, _ proposedMinimumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, SplitView.Binding, Downcast> { return .init(extract: { if case .constrainMinCoordinate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var constrainSplitPosition: BindingParser<(_ splitView: NSSplitView, _ proposedPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, SplitView.Binding, Downcast> { return .init(extract: { if case .constrainSplitPosition(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var effectiveRectForDrawnRect: BindingParser<(_ splitView: NSSplitView, _ proposedEffectiveRect: NSRect, _ drawnRect: NSRect, _ dividerIndex: Int) -> NSRect, SplitView.Binding, Downcast> { return .init(extract: { if case .effectiveRectForDrawnRect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var resizeSubviews: BindingParser<(NSSplitView, NSSize) -> Void, SplitView.Binding, Downcast> { return .init(extract: { if case .resizeSubviews(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var shouldAdjustSizeOfSubview: BindingParser<(_ splitView: NSSplitView, _ subview: NSView) -> Bool, SplitView.Binding, Downcast> { return .init(extract: { if case .shouldAdjustSizeOfSubview(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var shouldCollapseSubview: BindingParser<(_ splitView: NSSplitView, _ subview: NSView, _ dividerIndex: Int) -> Bool, SplitView.Binding, Downcast> { return .init(extract: { if case .shouldCollapseSubview(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
	public static var shouldHideDivider: BindingParser<(_ splitView: NSSplitView, _ dividerIndex: Int) -> Bool, SplitView.Binding, Downcast> { return .init(extract: { if case .shouldHideDivider(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSplitViewBinding() }) }
}

#endif
