//
//  CwlSplitView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 13/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Binding == SplitView.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var arrangedSubviews: BindingParser<Dynamic<ArrayMutation<SplitSubview>>, Binding> { return BindingParser<Dynamic<ArrayMutation<SplitSubview>>, Binding>(parse: { binding -> Optional<Dynamic<ArrayMutation<SplitSubview>>> in if case .arrangedSubviews(let x) = binding { return x } else { return nil } }) }
	public static var autosaveName: BindingParser<Dynamic<NSSplitView.AutosaveName?>, Binding> { return BindingParser<Dynamic<NSSplitView.AutosaveName?>, Binding>(parse: { binding -> Optional<Dynamic<NSSplitView.AutosaveName?>> in if case .autosaveName(let x) = binding { return x } else { return nil } }) }
	public static var dividerStyle: BindingParser<Dynamic<NSSplitView.DividerStyle>, Binding> { return BindingParser<Dynamic<NSSplitView.DividerStyle>, Binding>(parse: { binding -> Optional<Dynamic<NSSplitView.DividerStyle>> in if case .dividerStyle(let x) = binding { return x } else { return nil } }) }
	public static var isVertical: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isVertical(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var setDividerPosition: BindingParser<Signal<(position: CGFloat, dividerIndex: Int)>, Binding> { return BindingParser<Signal<(position: CGFloat, dividerIndex: Int)>, Binding>(parse: { binding -> Optional<Signal<(position: CGFloat, dividerIndex: Int)>> in if case .setDividerPosition(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.
	public static var didResizeSubviews: BindingParser<SignalInput<Int?>, Binding> { return BindingParser<SignalInput<Int?>, Binding>(parse: { binding -> Optional<SignalInput<Int?>> in if case .didResizeSubviews(let x) = binding { return x } else { return nil } }) }
	public static var willResizeSubviews: BindingParser<SignalInput<Int?>, Binding> { return BindingParser<SignalInput<Int?>, Binding>(parse: { binding -> Optional<SignalInput<Int?>> in if case .willResizeSubviews(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var additionalEffectiveRect: BindingParser<(_ splitView: NSSplitView, _ dividerAt: Int) -> NSRect, Binding> { return BindingParser<(_ splitView: NSSplitView, _ dividerAt: Int) -> NSRect, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ dividerAt: Int) -> NSRect> in if case .additionalEffectiveRect(let x) = binding { return x } else { return nil } }) }
	public static var canCollapseSubview: BindingParser<(_ splitView: NSSplitView, _ subview: NSView) -> Bool, Binding> { return BindingParser<(_ splitView: NSSplitView, _ subview: NSView) -> Bool, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ subview: NSView) -> Bool> in if case .canCollapseSubview(let x) = binding { return x } else { return nil } }) }
	public static var constrainMaxCoordinate: BindingParser<(_ splitView: NSSplitView, _ proposedMaximumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, Binding> { return BindingParser<(_ splitView: NSSplitView, _ proposedMaximumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ proposedMaximumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat> in if case .constrainMaxCoordinate(let x) = binding { return x } else { return nil } }) }
	public static var constrainMinCoordinate: BindingParser<(_ splitView: NSSplitView, _ proposedMinimumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, Binding> { return BindingParser<(_ splitView: NSSplitView, _ proposedMinimumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ proposedMinimumPosition: CGFloat, _ dividerIndex: Int) -> CGFloat> in if case .constrainMinCoordinate(let x) = binding { return x } else { return nil } }) }
	public static var constrainSplitPosition: BindingParser<(_ splitView: NSSplitView, _ proposedPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, Binding> { return BindingParser<(_ splitView: NSSplitView, _ proposedPosition: CGFloat, _ dividerIndex: Int) -> CGFloat, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ proposedPosition: CGFloat, _ dividerIndex: Int) -> CGFloat> in if case .constrainSplitPosition(let x) = binding { return x } else { return nil } }) }
	public static var effectiveRectForDrawnRect: BindingParser<(_ splitView: NSSplitView, _ proposedEffectiveRect: NSRect, _ drawnRect: NSRect, _ dividerIndex: Int) -> NSRect, Binding> { return BindingParser<(_ splitView: NSSplitView, _ proposedEffectiveRect: NSRect, _ drawnRect: NSRect, _ dividerIndex: Int) -> NSRect, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ proposedEffectiveRect: NSRect, _ drawnRect: NSRect, _ dividerIndex: Int) -> NSRect> in if case .effectiveRectForDrawnRect(let x) = binding { return x } else { return nil } }) }
	public static var resizeSubviews: BindingParser<(NSSplitView, NSSize) -> Void, Binding> { return BindingParser<(NSSplitView, NSSize) -> Void, Binding>(parse: { binding -> Optional<(NSSplitView, NSSize) -> Void> in if case .resizeSubviews(let x) = binding { return x } else { return nil } }) }
	public static var shouldAdjustSizeOfSubview: BindingParser<(_ splitView: NSSplitView, _ subview: NSView) -> Bool, Binding> { return BindingParser<(_ splitView: NSSplitView, _ subview: NSView) -> Bool, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ subview: NSView) -> Bool> in if case .shouldAdjustSizeOfSubview(let x) = binding { return x } else { return nil } }) }
	public static var shouldCollapseSubview: BindingParser<(_ splitView: NSSplitView, _ subview: NSView, _ dividerIndex: Int) -> Bool, Binding> { return BindingParser<(_ splitView: NSSplitView, _ subview: NSView, _ dividerIndex: Int) -> Bool, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ subview: NSView, _ dividerIndex: Int) -> Bool> in if case .shouldCollapseSubview(let x) = binding { return x } else { return nil } }) }
	public static var shouldHideDivider: BindingParser<(_ splitView: NSSplitView, _ dividerIndex: Int) -> Bool, Binding> { return BindingParser<(_ splitView: NSSplitView, _ dividerIndex: Int) -> Bool, Binding>(parse: { binding -> Optional<(_ splitView: NSSplitView, _ dividerIndex: Int) -> Bool> in if case .shouldHideDivider(let x) = binding { return x } else { return nil } }) }
}

#endif
