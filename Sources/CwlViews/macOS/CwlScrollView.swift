//
//  CwlScrollView.swift
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

public class ScrollView: ConstructingBinder, ScrollViewConvertible {
	public typealias Instance = NSScrollView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsScrollView() -> Instance { return instance() }
	
	public enum Binding: ScrollViewBinding {
		public typealias EnclosingBinder = ScrollView
		public static func scrollViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundColor(Dynamic<NSColor>)
		case contentView(Dynamic<ClipViewConvertible>)
		case drawsBackground(Dynamic<Bool>)
		case borderType(Dynamic<NSBorderType>)
		case documentCursor(Dynamic<NSCursor?>)
		case floatingSubviews(Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>)
		case hasHorizontalScroller(Dynamic<Bool>)
		case hasVerticalScroller(Dynamic<Bool>)
		case autohidesScrollers(Dynamic<Bool>)
		case hasHorizontalRuler(Dynamic<Bool>)
		case hasVerticalRuler(Dynamic<Bool>)
		case rulersVisible(Dynamic<Bool>)
		case automaticallyAdjustsContentInsets(Dynamic<Bool>)
		case contentInsets(Dynamic<NSEdgeInsets>)
		case scrollerInsets(Dynamic<NSEdgeInsets>)
		case scrollerStyle(Dynamic<NSScroller.Style>)
		case scrollerKnobStyle(Dynamic<NSScroller.KnobStyle>)
		case verticalLineScroll(Dynamic<CGFloat>)
		case horizontalLineScroll(Dynamic<CGFloat>)
		case horizontalPageScroll(Dynamic<CGFloat>)
		case verticalPageScroll(Dynamic<CGFloat>)
		case scrollsDynamically(Dynamic<Bool>)
		case findBarPosition(Dynamic<NSScrollView.FindBarPosition>)
		case usesPredominantAxisScrolling(Dynamic<Bool>)
		case horizontalScrollElasticity(Dynamic<NSScrollView.Elasticity>)
		case verticalScrollElasticity(Dynamic<NSScrollView.Elasticity>)
		case allowsMagnification(Dynamic<Bool>)
		case magnification(Dynamic<CGFloat>)
		case maxMagnification(Dynamic<CGFloat>)
		case minMagnification(Dynamic<CGFloat>)

		// 2. Signal bindings are performed on the object after construction.
		case scrollWheel(Signal<NSEvent>)
		case flashScrollers(Signal<Bool>)
		case magnificationCenteredAtPoint(Signal<(CGFloat, NSPoint)>)
		case magnifyToFitRect(Signal<CGRect>)

		// 3. Action bindings are triggered by the object after construction.
		case willStartLiveMagnify(SignalInput<Void>)
		case didEndLiveMagnify(SignalInput<Void>)
		case willStartLiveScroll(SignalInput<Void>)
		case didLiveScroll(SignalInput<Void>)
		case didEndLiveScroll(SignalInput<Void>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = ScrollView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .backgroundColor(let x): return x.apply(instance, storage) { i, s, v in i.backgroundColor = v }
			case .drawsBackground(let x): return x.apply(instance, storage) { i, s, v in i.drawsBackground = v }
			case .borderType(let x): return x.apply(instance, storage) { i, s, v in i.borderType = v }
			case .contentView(let x): return x.apply(instance, storage) { i, s, v in i.contentView = v.nsClipView() }
			case .documentCursor(let x): return x.apply(instance, storage) { i, s, v in i.documentCursor = v }
			case .floatingSubviews(let x):
				return x.apply(instance, storage) { i, s, v in
					s.floatingSubviews.forEach { $0.removeFromSuperview() }
					s.floatingSubviews = v.map {
						let sub = $0.view.nsView()
						i.addFloatingSubview(sub, for: $0.axis)
						return sub
					}
				}
			case .hasHorizontalScroller(let x): return x.apply(instance, storage) { i, s, v in i.hasHorizontalScroller = v }
			case .hasVerticalScroller(let x): return x.apply(instance, storage) { i, s, v in i.hasVerticalScroller = v }
			case .autohidesScrollers(let x): return x.apply(instance, storage) { i, s, v in i.autohidesScrollers = v }
			case .hasHorizontalRuler(let x): return x.apply(instance, storage) { i, s, v in i.hasHorizontalRuler = v }
			case .hasVerticalRuler(let x): return x.apply(instance, storage) { i, s, v in i.hasVerticalRuler = v }
			case .rulersVisible(let x): return x.apply(instance, storage) { i, s, v in i.rulersVisible = v }
			case .automaticallyAdjustsContentInsets(let x): return x.apply(instance, storage) { i, s, v in i.automaticallyAdjustsContentInsets = v }
			case .contentInsets(let x): return x.apply(instance, storage) { i, s, v in i.contentInsets = v }
			case .scrollerInsets(let x): return x.apply(instance, storage) { i, s, v in i.scrollerInsets = v }
			case .scrollerStyle(let x): return x.apply(instance, storage) { i, s, v in i.scrollerStyle = v }
			case .scrollerKnobStyle(let x): return x.apply(instance, storage) { i, s, v in i.scrollerKnobStyle = v }
			case .verticalLineScroll(let x): return x.apply(instance, storage) { i, s, v in i.verticalLineScroll = v }
			case .horizontalLineScroll(let x): return x.apply(instance, storage) { i, s, v in i.horizontalLineScroll = v }
			case .horizontalPageScroll(let x): return x.apply(instance, storage) { i, s, v in i.horizontalPageScroll = v }
			case .verticalPageScroll(let x): return x.apply(instance, storage) { i, s, v in i.verticalPageScroll = v }
			case .scrollsDynamically(let x): return x.apply(instance, storage) { i, s, v in i.scrollsDynamically = v }
			case .findBarPosition(let x): return x.apply(instance, storage) { i, s, v in i.findBarPosition = v }
			case .usesPredominantAxisScrolling(let x): return x.apply(instance, storage) { i, s, v in i.usesPredominantAxisScrolling = v }
			case .horizontalScrollElasticity(let x): return x.apply(instance, storage) { i, s, v in i.horizontalScrollElasticity = v }
			case .verticalScrollElasticity(let x): return x.apply(instance, storage) { i, s, v in i.verticalScrollElasticity = v }
			case .allowsMagnification(let x): return x.apply(instance, storage) { i, s, v in i.allowsMagnification = v }
			case .magnification(let x): return x.apply(instance, storage) { i, s, v in i.magnification = v }
			case .maxMagnification(let x): return x.apply(instance, storage) { i, s, v in i.maxMagnification = v }
			case .minMagnification(let x): return x.apply(instance, storage) { i, s, v in i.minMagnification = v }
			case .scrollWheel(let x): return x.apply(instance, storage) { i, s, v in i.scrollWheel(with: v) }
			case .flashScrollers(let x): return x.apply(instance, storage) { i, s, v in i.flashScrollers() }
			case .magnificationCenteredAtPoint(let x): return x.apply(instance, storage) { i, s, v in i.setMagnification(v.0, centeredAt: v.1) }
			case .magnifyToFitRect(let x): return x.apply(instance, storage) { i, s, v in i.magnify(toFit: v) }
			case .willStartLiveMagnify(let x): return Signal.notifications(name: NSScrollView.willStartLiveMagnifyNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didEndLiveMagnify(let x): return Signal.notifications(name: NSScrollView.didEndLiveMagnifyNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willStartLiveScroll(let x): return Signal.notifications(name: NSScrollView.willStartLiveScrollNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didLiveScroll(let x): return Signal.notifications(name: NSScrollView.didLiveScrollNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didEndLiveScroll(let x): return Signal.notifications(name: NSScrollView.didEndLiveScrollNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: View.Storage {
		open override var inUse: Bool {
			return super.inUse || !floatingSubviews.isEmpty
		}
		
		open var floatingSubviews: [NSView] = []
	}
}

extension BindingName where Binding: ScrollViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .scrollViewBinding(ScrollView.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundColor: BindingName<Dynamic<NSColor>, Binding> { return BindingName<Dynamic<NSColor>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.backgroundColor(v)) }) }
	public static var contentView: BindingName<Dynamic<ClipViewConvertible>, Binding> { return BindingName<Dynamic<ClipViewConvertible>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.contentView(v)) }) }
	public static var drawsBackground: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.drawsBackground(v)) }) }
	public static var borderType: BindingName<Dynamic<NSBorderType>, Binding> { return BindingName<Dynamic<NSBorderType>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.borderType(v)) }) }
	public static var documentCursor: BindingName<Dynamic<NSCursor?>, Binding> { return BindingName<Dynamic<NSCursor?>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.documentCursor(v)) }) }
	public static var floatingSubviews: BindingName<Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>, Binding> { return BindingName<Dynamic<[(view: ViewConvertible, axis: NSEvent.GestureAxis)]>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.floatingSubviews(v)) }) }
	public static var hasHorizontalScroller: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.hasHorizontalScroller(v)) }) }
	public static var hasVerticalScroller: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.hasVerticalScroller(v)) }) }
	public static var autohidesScrollers: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.autohidesScrollers(v)) }) }
	public static var hasHorizontalRuler: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.hasHorizontalRuler(v)) }) }
	public static var hasVerticalRuler: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.hasVerticalRuler(v)) }) }
	public static var rulersVisible: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.rulersVisible(v)) }) }
	public static var automaticallyAdjustsContentInsets: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.automaticallyAdjustsContentInsets(v)) }) }
	public static var contentInsets: BindingName<Dynamic<NSEdgeInsets>, Binding> { return BindingName<Dynamic<NSEdgeInsets>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.contentInsets(v)) }) }
	public static var scrollerInsets: BindingName<Dynamic<NSEdgeInsets>, Binding> { return BindingName<Dynamic<NSEdgeInsets>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollerInsets(v)) }) }
	public static var scrollerStyle: BindingName<Dynamic<NSScroller.Style>, Binding> { return BindingName<Dynamic<NSScroller.Style>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollerStyle(v)) }) }
	public static var scrollerKnobStyle: BindingName<Dynamic<NSScroller.KnobStyle>, Binding> { return BindingName<Dynamic<NSScroller.KnobStyle>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollerKnobStyle(v)) }) }
	public static var verticalLineScroll: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.verticalLineScroll(v)) }) }
	public static var horizontalLineScroll: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.horizontalLineScroll(v)) }) }
	public static var horizontalPageScroll: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.horizontalPageScroll(v)) }) }
	public static var verticalPageScroll: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.verticalPageScroll(v)) }) }
	public static var scrollsDynamically: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollsDynamically(v)) }) }
	public static var findBarPosition: BindingName<Dynamic<NSScrollView.FindBarPosition>, Binding> { return BindingName<Dynamic<NSScrollView.FindBarPosition>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.findBarPosition(v)) }) }
	public static var usesPredominantAxisScrolling: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.usesPredominantAxisScrolling(v)) }) }
	public static var horizontalScrollElasticity: BindingName<Dynamic<NSScrollView.Elasticity>, Binding> { return BindingName<Dynamic<NSScrollView.Elasticity>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.horizontalScrollElasticity(v)) }) }
	public static var verticalScrollElasticity: BindingName<Dynamic<NSScrollView.Elasticity>, Binding> { return BindingName<Dynamic<NSScrollView.Elasticity>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.verticalScrollElasticity(v)) }) }
	public static var allowsMagnification: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.allowsMagnification(v)) }) }
	public static var magnification: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.magnification(v)) }) }
	public static var maxMagnification: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.maxMagnification(v)) }) }
	public static var minMagnification: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.minMagnification(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var scrollWheel: BindingName<Signal<NSEvent>, Binding> { return BindingName<Signal<NSEvent>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.scrollWheel(v)) }) }
	public static var flashScrollers: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.flashScrollers(v)) }) }
	public static var magnificationCenteredAtPoint: BindingName<Signal<(CGFloat, NSPoint)>, Binding> { return BindingName<Signal<(CGFloat, NSPoint)>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.magnificationCenteredAtPoint(v)) }) }
	public static var magnifyToFitRect: BindingName<Signal<CGRect>, Binding> { return BindingName<Signal<CGRect>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.magnifyToFitRect(v)) }) }

	// 3. Action bindings are triggered by the object after construction.
	public static var willStartLiveMagnify: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.willStartLiveMagnify(v)) }) }
	public static var didEndLiveMagnify: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didEndLiveMagnify(v)) }) }
	public static var willStartLiveScroll: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.willStartLiveScroll(v)) }) }
	public static var didLiveScroll: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didLiveScroll(v)) }) }
	public static var didEndLiveScroll: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .scrollViewBinding(ScrollView.Binding.didEndLiveScroll(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol ScrollViewConvertible: ViewConvertible {
	func nsScrollView() -> ScrollView.Instance
}
extension ScrollViewConvertible {
	public func nsView() -> View.Instance { return nsScrollView() }
}
extension ScrollView.Instance: ScrollViewConvertible {
	public func nsScrollView() -> ScrollView.Instance { return self }
}

public protocol ScrollViewBinding: ViewBinding {
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self
}
extension ScrollViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return scrollViewBinding(.inheritedBinding(binding))
	}
}

