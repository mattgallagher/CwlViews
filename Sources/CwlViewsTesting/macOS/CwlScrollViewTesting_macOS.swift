//
//  CwlScrollView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/11/2015.
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

#if os(macOS)

extension BindingParser where Binding == ScrollView.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsMagnification: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsMagnification(let x) = binding { return x } else { return nil } }) }
	public static var autohidesScrollers: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .autohidesScrollers(let x) = binding { return x } else { return nil } }) }
	public static var automaticallyAdjustsContentInsets: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .automaticallyAdjustsContentInsets(let x) = binding { return x } else { return nil } }) }
	public static var backgroundColor: BindingParser<Dynamic<NSColor>, Binding> { return BindingParser<Dynamic<NSColor>, Binding>(parse: { binding -> Optional<Dynamic<NSColor>> in if case .backgroundColor(let x) = binding { return x } else { return nil } }) }
	public static var borderType: BindingParser<Dynamic<NSBorderType>, Binding> { return BindingParser<Dynamic<NSBorderType>, Binding>(parse: { binding -> Optional<Dynamic<NSBorderType>> in if case .borderType(let x) = binding { return x } else { return nil } }) }
	public static var contentInsets: BindingParser<Dynamic<NSEdgeInsets>, Binding> { return BindingParser<Dynamic<NSEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<NSEdgeInsets>> in if case .contentInsets(let x) = binding { return x } else { return nil } }) }
	public static var contentView: BindingParser<Dynamic<ClipViewConvertible>, Binding> { return BindingParser<Dynamic<ClipViewConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ClipViewConvertible>> in if case .contentView(let x) = binding { return x } else { return nil } }) }
	public static var documentCursor: BindingParser<Dynamic<NSCursor?>, Binding> { return BindingParser<Dynamic<NSCursor?>, Binding>(parse: { binding -> Optional<Dynamic<NSCursor?>> in if case .documentCursor(let x) = binding { return x } else { return nil } }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .drawsBackground(let x) = binding { return x } else { return nil } }) }
	public static var findBarPosition: BindingParser<Dynamic<NSScrollView.FindBarPosition>, Binding> { return BindingParser<Dynamic<NSScrollView.FindBarPosition>, Binding>(parse: { binding -> Optional<Dynamic<NSScrollView.FindBarPosition>> in if case .findBarPosition(let x) = binding { return x } else { return nil } }) }
	public static var floatingSubviews: BindingParser<Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>, Binding> { return BindingParser<Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>, Binding>(parse: { binding -> Optional<Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>> in if case .floatingSubviews(let x) = binding { return x } else { return nil } }) }
	public static var hasHorizontalRuler: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hasHorizontalRuler(let x) = binding { return x } else { return nil } }) }
	public static var hasHorizontalScroller: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hasHorizontalScroller(let x) = binding { return x } else { return nil } }) }
	public static var hasVerticalRuler: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hasVerticalRuler(let x) = binding { return x } else { return nil } }) }
	public static var hasVerticalScroller: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .hasVerticalScroller(let x) = binding { return x } else { return nil } }) }
	public static var horizontalLineScroll: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .horizontalLineScroll(let x) = binding { return x } else { return nil } }) }
	public static var horizontalPageScroll: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .horizontalPageScroll(let x) = binding { return x } else { return nil } }) }
	public static var horizontalScrollElasticity: BindingParser<Dynamic<NSScrollView.Elasticity>, Binding> { return BindingParser<Dynamic<NSScrollView.Elasticity>, Binding>(parse: { binding -> Optional<Dynamic<NSScrollView.Elasticity>> in if case .horizontalScrollElasticity(let x) = binding { return x } else { return nil } }) }
	public static var magnification: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .magnification(let x) = binding { return x } else { return nil } }) }
	public static var maxMagnification: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .maxMagnification(let x) = binding { return x } else { return nil } }) }
	public static var minMagnification: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .minMagnification(let x) = binding { return x } else { return nil } }) }
	public static var rulersVisible: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .rulersVisible(let x) = binding { return x } else { return nil } }) }
	public static var scrollerInsets: BindingParser<Dynamic<NSEdgeInsets>, Binding> { return BindingParser<Dynamic<NSEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<NSEdgeInsets>> in if case .scrollerInsets(let x) = binding { return x } else { return nil } }) }
	public static var scrollerKnobStyle: BindingParser<Dynamic<NSScroller.KnobStyle>, Binding> { return BindingParser<Dynamic<NSScroller.KnobStyle>, Binding>(parse: { binding -> Optional<Dynamic<NSScroller.KnobStyle>> in if case .scrollerKnobStyle(let x) = binding { return x } else { return nil } }) }
	public static var scrollerStyle: BindingParser<Dynamic<NSScroller.Style>, Binding> { return BindingParser<Dynamic<NSScroller.Style>, Binding>(parse: { binding -> Optional<Dynamic<NSScroller.Style>> in if case .scrollerStyle(let x) = binding { return x } else { return nil } }) }
	public static var scrollsDynamically: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .scrollsDynamically(let x) = binding { return x } else { return nil } }) }
	public static var usesPredominantAxisScrolling: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .usesPredominantAxisScrolling(let x) = binding { return x } else { return nil } }) }
	public static var verticalLineScroll: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .verticalLineScroll(let x) = binding { return x } else { return nil } }) }
	public static var verticalPageScroll: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .verticalPageScroll(let x) = binding { return x } else { return nil } }) }
	public static var verticalScrollElasticity: BindingParser<Dynamic<NSScrollView.Elasticity>, Binding> { return BindingParser<Dynamic<NSScrollView.Elasticity>, Binding>(parse: { binding -> Optional<Dynamic<NSScrollView.Elasticity>> in if case .verticalScrollElasticity(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var flashScrollers: BindingParser<Signal<Bool>, Binding> { return BindingParser<Signal<Bool>, Binding>(parse: { binding -> Optional<Signal<Bool>> in if case .flashScrollers(let x) = binding { return x } else { return nil } }) }
	public static var magnificationCenteredAtPoint: BindingParser<Signal<(CGFloat, NSPoint)>, Binding> { return BindingParser<Signal<(CGFloat, NSPoint)>, Binding>(parse: { binding -> Optional<Signal<(CGFloat, NSPoint)>> in if case .magnificationCenteredAtPoint(let x) = binding { return x } else { return nil } }) }
	public static var magnifyToFitRect: BindingParser<Signal<CGRect>, Binding> { return BindingParser<Signal<CGRect>, Binding>(parse: { binding -> Optional<Signal<CGRect>> in if case .magnifyToFitRect(let x) = binding { return x } else { return nil } }) }
	public static var scrollWheel: BindingParser<Signal<NSEvent>, Binding> { return BindingParser<Signal<NSEvent>, Binding>(parse: { binding -> Optional<Signal<NSEvent>> in if case .scrollWheel(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.
	public static var didEndLiveMagnify: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didEndLiveMagnify(let x) = binding { return x } else { return nil } }) }
	public static var didEndLiveScroll: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didEndLiveScroll(let x) = binding { return x } else { return nil } }) }
	public static var didLiveScroll: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didLiveScroll(let x) = binding { return x } else { return nil } }) }
	public static var willStartLiveMagnify: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .willStartLiveMagnify(let x) = binding { return x } else { return nil } }) }
	public static var willStartLiveScroll: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .willStartLiveScroll(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
