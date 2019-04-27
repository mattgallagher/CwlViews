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

extension BindingParser where Downcast: ScrollViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ScrollView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asScrollViewBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsMagnification: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .allowsMagnification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var autohidesScrollers: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .autohidesScrollers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var automaticallyAdjustsContentInsets: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .automaticallyAdjustsContentInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var backgroundColor: BindingParser<Dynamic<NSColor>, ScrollView.Binding, Downcast> { return .init(extract: { if case .backgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var borderType: BindingParser<Dynamic<NSBorderType>, ScrollView.Binding, Downcast> { return .init(extract: { if case .borderType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var contentInsets: BindingParser<Dynamic<NSEdgeInsets>, ScrollView.Binding, Downcast> { return .init(extract: { if case .contentInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var contentView: BindingParser<Dynamic<ClipViewConvertible>, ScrollView.Binding, Downcast> { return .init(extract: { if case .contentView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var documentCursor: BindingParser<Dynamic<NSCursor?>, ScrollView.Binding, Downcast> { return .init(extract: { if case .documentCursor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .drawsBackground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var findBarPosition: BindingParser<Dynamic<NSScrollView.FindBarPosition>, ScrollView.Binding, Downcast> { return .init(extract: { if case .findBarPosition(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var floatingSubviews: BindingParser<Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>, ScrollView.Binding, Downcast> { return .init(extract: { if case .floatingSubviews(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var hasHorizontalRuler: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .hasHorizontalRuler(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var hasHorizontalScroller: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .hasHorizontalScroller(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var hasVerticalRuler: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .hasVerticalRuler(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var hasVerticalScroller: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .hasVerticalScroller(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var horizontalLineScroll: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .horizontalLineScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var horizontalPageScroll: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .horizontalPageScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var horizontalScrollElasticity: BindingParser<Dynamic<NSScrollView.Elasticity>, ScrollView.Binding, Downcast> { return .init(extract: { if case .horizontalScrollElasticity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var magnification: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .magnification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var maxMagnification: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .maxMagnification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var minMagnification: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .minMagnification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var rulersVisible: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .rulersVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollerInsets: BindingParser<Dynamic<NSEdgeInsets>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollerInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollerKnobStyle: BindingParser<Dynamic<NSScroller.KnobStyle>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollerKnobStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollerStyle: BindingParser<Dynamic<NSScroller.Style>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollerStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollsDynamically: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollsDynamically(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var usesPredominantAxisScrolling: BindingParser<Dynamic<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .usesPredominantAxisScrolling(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var verticalLineScroll: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .verticalLineScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var verticalPageScroll: BindingParser<Dynamic<CGFloat>, ScrollView.Binding, Downcast> { return .init(extract: { if case .verticalPageScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var verticalScrollElasticity: BindingParser<Dynamic<NSScrollView.Elasticity>, ScrollView.Binding, Downcast> { return .init(extract: { if case .verticalScrollElasticity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var flashScrollers: BindingParser<Signal<Bool>, ScrollView.Binding, Downcast> { return .init(extract: { if case .flashScrollers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var magnificationCenteredAtPoint: BindingParser<Signal<(CGFloat, NSPoint)>, ScrollView.Binding, Downcast> { return .init(extract: { if case .magnificationCenteredAtPoint(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var magnifyToFitRect: BindingParser<Signal<CGRect>, ScrollView.Binding, Downcast> { return .init(extract: { if case .magnifyToFitRect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var scrollWheel: BindingParser<Signal<NSEvent>, ScrollView.Binding, Downcast> { return .init(extract: { if case .scrollWheel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didEndLiveMagnify: BindingParser<SignalInput<Void>, ScrollView.Binding, Downcast> { return .init(extract: { if case .didEndLiveMagnify(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didEndLiveScroll: BindingParser<SignalInput<Void>, ScrollView.Binding, Downcast> { return .init(extract: { if case .didEndLiveScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var didLiveScroll: BindingParser<SignalInput<Void>, ScrollView.Binding, Downcast> { return .init(extract: { if case .didLiveScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var willStartLiveMagnify: BindingParser<SignalInput<Void>, ScrollView.Binding, Downcast> { return .init(extract: { if case .willStartLiveMagnify(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }
	public static var willStartLiveScroll: BindingParser<SignalInput<Void>, ScrollView.Binding, Downcast> { return .init(extract: { if case .willStartLiveScroll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asScrollViewBinding() }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
