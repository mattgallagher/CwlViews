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

// MARK: - Binder Part 1: Binder
public class ScrollView: Binder, ScrollViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ScrollView {
	enum Binding: ScrollViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsMagnification(Dynamic<Bool>)
		case autohidesScrollers(Dynamic<Bool>)
		case automaticallyAdjustsContentInsets(Dynamic<Bool>)
		case backgroundColor(Dynamic<NSColor>)
		case borderType(Dynamic<NSBorderType>)
		case contentInsets(Dynamic<NSEdgeInsets>)
		case contentView(Dynamic<ClipViewConvertible>)
		case documentCursor(Dynamic<NSCursor?>)
		case drawsBackground(Dynamic<Bool>)
		case findBarPosition(Dynamic<NSScrollView.FindBarPosition>)
		case floatingSubviews(Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>)
		case hasHorizontalRuler(Dynamic<Bool>)
		case hasHorizontalScroller(Dynamic<Bool>)
		case hasVerticalRuler(Dynamic<Bool>)
		case hasVerticalScroller(Dynamic<Bool>)
		case horizontalLineScroll(Dynamic<CGFloat>)
		case horizontalPageScroll(Dynamic<CGFloat>)
		case horizontalScrollElasticity(Dynamic<NSScrollView.Elasticity>)
		case magnification(Dynamic<CGFloat>)
		case maxMagnification(Dynamic<CGFloat>)
		case minMagnification(Dynamic<CGFloat>)
		case rulersVisible(Dynamic<Bool>)
		case scrollerInsets(Dynamic<NSEdgeInsets>)
		case scrollerKnobStyle(Dynamic<NSScroller.KnobStyle>)
		case scrollerStyle(Dynamic<NSScroller.Style>)
		case scrollsDynamically(Dynamic<Bool>)
		case usesPredominantAxisScrolling(Dynamic<Bool>)
		case verticalLineScroll(Dynamic<CGFloat>)
		case verticalPageScroll(Dynamic<CGFloat>)
		case verticalScrollElasticity(Dynamic<NSScrollView.Elasticity>)

		// 2. Signal bindings are performed on the object after construction.
		case flashScrollers(Signal<Bool>)
		case magnificationCenteredAtPoint(Signal<(CGFloat, NSPoint)>)
		case magnifyToFitRect(Signal<CGRect>)
		case scrollWheel(Signal<NSEvent>)

		// 3. Action bindings are triggered by the object after construction.
		case didEndLiveMagnify(SignalInput<Void>)
		case didEndLiveScroll(SignalInput<Void>)
		case didLiveScroll(SignalInput<Void>)
		case willStartLiveMagnify(SignalInput<Void>)
		case willStartLiveScroll(SignalInput<Void>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ScrollView {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = ScrollView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSScrollView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ScrollView.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowsMagnification(let x): return x.apply(instance) { i, v in i.allowsMagnification = v }
		case .autohidesScrollers(let x): return x.apply(instance) { i, v in i.autohidesScrollers = v }
		case .automaticallyAdjustsContentInsets(let x): return x.apply(instance) { i, v in i.automaticallyAdjustsContentInsets = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .borderType(let x): return x.apply(instance) { i, v in i.borderType = v }
		case .contentInsets(let x): return x.apply(instance) { i, v in i.contentInsets = v }
		case .contentView(let x): return x.apply(instance) { i, v in i.contentView = v.nsClipView() }
		case .documentCursor(let x): return x.apply(instance) { i, v in i.documentCursor = v }
		case .drawsBackground(let x): return x.apply(instance) { i, v in i.drawsBackground = v }
		case .findBarPosition(let x): return x.apply(instance) { i, v in i.findBarPosition = v }
		case .floatingSubviews(let x):
			return x.apply(instance, storage) { i, s, v in
				s.floatingSubviews.forEach { $0.removeFromSuperview() }
				s.floatingSubviews = v.map {
					let sub = $0.view.nsView()
					i.addFloatingSubview(sub, for: $0.axis)
					return sub
				}
			}
		case .hasHorizontalRuler(let x): return x.apply(instance) { i, v in i.hasHorizontalRuler = v }
		case .hasHorizontalScroller(let x): return x.apply(instance) { i, v in i.hasHorizontalScroller = v }
		case .hasVerticalRuler(let x): return x.apply(instance) { i, v in i.hasVerticalRuler = v }
		case .hasVerticalScroller(let x): return x.apply(instance) { i, v in i.hasVerticalScroller = v }
		case .horizontalLineScroll(let x): return x.apply(instance) { i, v in i.horizontalLineScroll = v }
		case .horizontalPageScroll(let x): return x.apply(instance) { i, v in i.horizontalPageScroll = v }
		case .horizontalScrollElasticity(let x): return x.apply(instance) { i, v in i.horizontalScrollElasticity = v }
		case .magnification(let x): return x.apply(instance) { i, v in i.magnification = v }
		case .maxMagnification(let x): return x.apply(instance) { i, v in i.maxMagnification = v }
		case .minMagnification(let x): return x.apply(instance) { i, v in i.minMagnification = v }
		case .rulersVisible(let x): return x.apply(instance) { i, v in i.rulersVisible = v }
		case .scrollerInsets(let x): return x.apply(instance) { i, v in i.scrollerInsets = v }
		case .scrollerKnobStyle(let x): return x.apply(instance) { i, v in i.scrollerKnobStyle = v }
		case .scrollerStyle(let x): return x.apply(instance) { i, v in i.scrollerStyle = v }
		case .scrollsDynamically(let x): return x.apply(instance) { i, v in i.scrollsDynamically = v }
		case .usesPredominantAxisScrolling(let x): return x.apply(instance) { i, v in i.usesPredominantAxisScrolling = v }
		case .verticalLineScroll(let x): return x.apply(instance) { i, v in i.verticalLineScroll = v }
		case .verticalPageScroll(let x): return x.apply(instance) { i, v in i.verticalPageScroll = v }
		case .verticalScrollElasticity(let x): return x.apply(instance) { i, v in i.verticalScrollElasticity = v }

		// 2. Signal bindings are performed on the object after construction.
		case .flashScrollers(let x): return x.apply(instance) { i, v in i.flashScrollers() }
		case .magnificationCenteredAtPoint(let x): return x.apply(instance) { i, v in i.setMagnification(v.0, centeredAt: v.1) }
		case .magnifyToFitRect(let x): return x.apply(instance) { i, v in i.magnify(toFit: v) }
		case .scrollWheel(let x): return x.apply(instance) { i, v in i.scrollWheel(with: v) }

		// 3. Action bindings are triggered by the object after construction.
		case .didEndLiveMagnify(let x): return Signal.notifications(name: NSScrollView.didEndLiveMagnifyNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didEndLiveScroll(let x): return Signal.notifications(name: NSScrollView.didEndLiveScrollNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didLiveScroll(let x): return Signal.notifications(name: NSScrollView.didLiveScrollNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willStartLiveMagnify(let x): return Signal.notifications(name: NSScrollView.willStartLiveMagnifyNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willStartLiveScroll(let x): return Signal.notifications(name: NSScrollView.willStartLiveScrollNotification, object: instance).map { n in () }.cancellableBind(to: x)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ScrollView.Preparer {
	open class Storage: View.Preparer.Storage {
		open override var isInUse: Bool {
			return super.isInUse || !floatingSubviews.isEmpty
		}
		
		open var floatingSubviews: [NSView] = []
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ScrollViewBinding {
	public typealias ScrollViewName<V> = BindingName<V, ScrollView.Binding, Binding>
	private typealias B = ScrollView.Binding
	private static func name<V>(_ source: @escaping (V) -> ScrollView.Binding) -> ScrollViewName<V> {
		return ScrollViewName<V>(source: source, downcast: Binding.scrollViewBinding)
	}
}
public extension BindingName where Binding: ScrollViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ScrollViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsMagnification: ScrollViewName<Dynamic<Bool>> { return .name(B.allowsMagnification) }
	static var autohidesScrollers: ScrollViewName<Dynamic<Bool>> { return .name(B.autohidesScrollers) }
	static var automaticallyAdjustsContentInsets: ScrollViewName<Dynamic<Bool>> { return .name(B.automaticallyAdjustsContentInsets) }
	static var backgroundColor: ScrollViewName<Dynamic<NSColor>> { return .name(B.backgroundColor) }
	static var borderType: ScrollViewName<Dynamic<NSBorderType>> { return .name(B.borderType) }
	static var contentInsets: ScrollViewName<Dynamic<NSEdgeInsets>> { return .name(B.contentInsets) }
	static var contentView: ScrollViewName<Dynamic<ClipViewConvertible>> { return .name(B.contentView) }
	static var documentCursor: ScrollViewName<Dynamic<NSCursor?>> { return .name(B.documentCursor) }
	static var drawsBackground: ScrollViewName<Dynamic<Bool>> { return .name(B.drawsBackground) }
	static var findBarPosition: ScrollViewName<Dynamic<NSScrollView.FindBarPosition>> { return .name(B.findBarPosition) }
	static var floatingSubviews: ScrollViewName<Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>> { return .name(B.floatingSubviews) }
	static var hasHorizontalRuler: ScrollViewName<Dynamic<Bool>> { return .name(B.hasHorizontalRuler) }
	static var hasHorizontalScroller: ScrollViewName<Dynamic<Bool>> { return .name(B.hasHorizontalScroller) }
	static var hasVerticalRuler: ScrollViewName<Dynamic<Bool>> { return .name(B.hasVerticalRuler) }
	static var hasVerticalScroller: ScrollViewName<Dynamic<Bool>> { return .name(B.hasVerticalScroller) }
	static var horizontalLineScroll: ScrollViewName<Dynamic<CGFloat>> { return .name(B.horizontalLineScroll) }
	static var horizontalPageScroll: ScrollViewName<Dynamic<CGFloat>> { return .name(B.horizontalPageScroll) }
	static var horizontalScrollElasticity: ScrollViewName<Dynamic<NSScrollView.Elasticity>> { return .name(B.horizontalScrollElasticity) }
	static var magnification: ScrollViewName<Dynamic<CGFloat>> { return .name(B.magnification) }
	static var maxMagnification: ScrollViewName<Dynamic<CGFloat>> { return .name(B.maxMagnification) }
	static var minMagnification: ScrollViewName<Dynamic<CGFloat>> { return .name(B.minMagnification) }
	static var rulersVisible: ScrollViewName<Dynamic<Bool>> { return .name(B.rulersVisible) }
	static var scrollerInsets: ScrollViewName<Dynamic<NSEdgeInsets>> { return .name(B.scrollerInsets) }
	static var scrollerKnobStyle: ScrollViewName<Dynamic<NSScroller.KnobStyle>> { return .name(B.scrollerKnobStyle) }
	static var scrollerStyle: ScrollViewName<Dynamic<NSScroller.Style>> { return .name(B.scrollerStyle) }
	static var scrollsDynamically: ScrollViewName<Dynamic<Bool>> { return .name(B.scrollsDynamically) }
	static var usesPredominantAxisScrolling: ScrollViewName<Dynamic<Bool>> { return .name(B.usesPredominantAxisScrolling) }
	static var verticalLineScroll: ScrollViewName<Dynamic<CGFloat>> { return .name(B.verticalLineScroll) }
	static var verticalPageScroll: ScrollViewName<Dynamic<CGFloat>> { return .name(B.verticalPageScroll) }
	static var verticalScrollElasticity: ScrollViewName<Dynamic<NSScrollView.Elasticity>> { return .name(B.verticalScrollElasticity) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var flashScrollers: ScrollViewName<Signal<Bool>> { return .name(B.flashScrollers) }
	static var magnificationCenteredAtPoint: ScrollViewName<Signal<(CGFloat, NSPoint)>> { return .name(B.magnificationCenteredAtPoint) }
	static var magnifyToFitRect: ScrollViewName<Signal<CGRect>> { return .name(B.magnifyToFitRect) }
	static var scrollWheel: ScrollViewName<Signal<NSEvent>> { return .name(B.scrollWheel) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didEndLiveMagnify: ScrollViewName<SignalInput<Void>> { return .name(B.didEndLiveMagnify) }
	static var didEndLiveScroll: ScrollViewName<SignalInput<Void>> { return .name(B.didEndLiveScroll) }
	static var didLiveScroll: ScrollViewName<SignalInput<Void>> { return .name(B.didLiveScroll) }
	static var willStartLiveMagnify: ScrollViewName<SignalInput<Void>> { return .name(B.willStartLiveMagnify) }
	static var willStartLiveScroll: ScrollViewName<SignalInput<Void>> { return .name(B.willStartLiveScroll) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ScrollViewConvertible: ViewConvertible {
	func nsScrollView() -> ScrollView.Instance
}
extension ScrollViewConvertible {
	public func nsView() -> View.Instance { return nsScrollView() }
}
extension NSScrollView: ScrollViewConvertible {
	public func nsScrollView() -> ScrollView.Instance { return self }
}
public extension ScrollView {
	func nsScrollView() -> ScrollView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ScrollViewBinding: ViewBinding {
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self
}
public extension ScrollViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return scrollViewBinding(.inheritedBinding(binding))
	}
}
public extension ScrollView.Binding {
	typealias Preparer = ScrollView.Preparer
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> ScrollView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
