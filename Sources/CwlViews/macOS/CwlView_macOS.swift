//
//  CwlView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 19/10/2015.
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
public class View: Binder, ViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension View {
	enum Binding: ViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static styles are applied at construction and are subsequently immutable.
		case layer(Constant<BackingLayer>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case appearance(Dynamic<NSAppearance?>)
		case canDrawSubviewsIntoLayer(Dynamic<Bool>)
		case focusRingType(Dynamic<NSFocusRingType>)
		case frameRotation(Dynamic<CGFloat>)
		case gestureRecognizers(Dynamic<[GestureRecognizerConvertible]>)
		case horizontalContentCompressionResistancePriority(Dynamic<NSLayoutConstraint.Priority>)
		case horizontalContentHuggingPriority(Dynamic<NSLayoutConstraint.Priority>)
		case identifier(Dynamic<NSUserInterfaceItemIdentifier?>)
		case isHidden(Dynamic<Bool>)
		case layerContentsRedrawPolicy(Dynamic<NSView.LayerContentsRedrawPolicy>)
		case layout(Dynamic<Layout?>)
		case registeredDragTypes(Dynamic<[NSPasteboard.PasteboardType]>)
		case tooltip(Dynamic<String>)
		case verticalContentCompressionResistancePriority(Dynamic<NSLayoutConstraint.Priority>)
		case verticalContentHuggingPriority(Dynamic<NSLayoutConstraint.Priority>)

		@available(macOS 10.11, *) case pressureConfiguration(Dynamic<NSPressureConfiguration>)
		
		// 2. Signal bindings are performed on the object after construction.
		case needsDisplay(Signal<Bool>)
		case printView(Signal<Void>)
		case scrollRectToVisible(Signal<NSRect>)
		case setNeedsDisplayInRect(Signal<NSRect>)
		
		// 3. Action bindings are triggered by the object after construction.
		case boundsDidChange(SignalInput<NSRect>)
		case frameDidChange(SignalInput<NSRect>)
		case globalFrameDidChange(SignalInput<NSRect>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension View {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = View.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSView
		public typealias Storage = View.Storage
		
		public var inherited = Inherited()
		public init() {}

		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		public var backingLayer: BackingLayer? = nil
		public var postsFrameChangedNotifications: Bool = false
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension View.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		case .layer(let x): backingLayer = x.value
		case .boundsDidChange: postsFrameChangedNotifications = true 
		case .frameDidChange: postsFrameChangedNotifications = true
		case .globalFrameDidChange: postsFrameChangedNotifications = true
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		if let layer = backingLayer {
			instance.wantsLayer = true
			layer.apply(to: instance.layer!)
		}
		if postsFrameChangedNotifications {
			instance.postsFrameChangedNotifications = true
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static styles are applied at construction and are subsequently immutable.
		case .layer: return nil
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .appearance(let x): return x.apply(instance) { i, v in i.appearance = v }
		case .canDrawSubviewsIntoLayer(let x): return x.apply(instance) { i, v in i.canDrawSubviewsIntoLayer = v }
		case .focusRingType(let x): return x.apply(instance) { i, v in i.focusRingType = v }
		case .frameRotation(let x): return x.apply(instance) { i, v in i.frameRotation = v }
		case .gestureRecognizers(let x): return x.apply(instance) { i, v in i.gestureRecognizers = v.map { $0.nsGestureRecognizer() } }
		case .horizontalContentCompressionResistancePriority(let x): return x.apply(instance) { i, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Orientation.horizontal) }
		case .horizontalContentHuggingPriority(let x): return x.apply(instance) { i, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Orientation.horizontal) }
		case .identifier(let x): return x.apply(instance) { i, v in i.identifier = v }
		case .isHidden(let x): return x.apply(instance) { i, v in i.isHidden = v }
		case .layerContentsRedrawPolicy(let x): return x.apply(instance) { i, v in i.layerContentsRedrawPolicy = v }
		case .layout(let x): return x.apply(instance) { i, v in i.applyLayout(v) }
		case .registeredDragTypes(let x):
			return x.apply(instance) { i, v in
				if v.isEmpty {
					i.unregisterDraggedTypes()
				} else {
					i.registerForDraggedTypes(v)
				}
			}
		case .tooltip(let x): return x.apply(instance) { i, v in i.toolTip = v }
		case .verticalContentCompressionResistancePriority(let x): return x.apply(instance) { i, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Orientation.vertical) }
		case .verticalContentHuggingPriority(let x): return x.apply(instance) { i, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Orientation.vertical) }
			
		case .pressureConfiguration(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					i.pressureConfiguration = v
				}
			}
			
		// 2. Signal bindings are performed on the object after construction.
		case .needsDisplay(let x): return x.apply(instance) { i, v in i.needsDisplay = v }
		case .printView(let x): return x.apply(instance) { i, v in i.printView(nil) }
		case .setNeedsDisplayInRect(let x): return x.apply(instance) { i, v in i.setNeedsDisplay(v) }
		case .scrollRectToVisible(let x): return x.apply(instance) { i, v in i.scrollToVisible(v) }
			
		// 3. Action bindings are triggered by the object after construction.
		case .frameDidChange(let x):
			instance.postsFrameChangedNotifications = true
			return Signal.notifications(name: NSView.frameDidChangeNotification, object: instance).compactMap { notification -> NSRect? in (notification.object as? NSView)?.frame }.cancellableBind(to: x)
		case .globalFrameDidChange(let x):
			instance.postsFrameChangedNotifications = true
			return Signal.notifications(name: NSView.globalFrameDidChangeNotification, object: instance).compactMap { notification -> NSRect? in (notification.object as? NSView)?.frame }.cancellableBind(to: x)
		case .boundsDidChange(let x):
			instance.postsBoundsChangedNotifications = true
			return Signal.notifications(name: NSView.boundsDidChangeNotification, object: instance).compactMap { notification -> NSRect? in (notification.object as? NSView)?.bounds }.cancellableBind(to: x)
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension View {
	public typealias Storage = ObjectBinderStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ViewBinding {
	public typealias ViewName<V> = BindingName<V, View.Binding, Binding>
	private typealias B = View.Binding
	private static func name<V>(_ source: @escaping (V) -> View.Binding) -> ViewName<V> {
		return ViewName<V>(source: source, downcast: Binding.viewBinding)
	}
}
extension BindingName where Binding: ViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ViewName<$2> { return .name(B.$1) }
	
	//	0. Static styles are applied at construction and are subsequently immutable.
	static var layer: ViewName<Constant<BackingLayer>> { return .name(B.layer) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var appearance: ViewName<Dynamic<NSAppearance?>> { return .name(B.appearance) }
	static var canDrawSubviewsIntoLayer: ViewName<Dynamic<Bool>> { return .name(B.canDrawSubviewsIntoLayer) }
	static var focusRingType: ViewName<Dynamic<NSFocusRingType>> { return .name(B.focusRingType) }
	static var frameRotation: ViewName<Dynamic<CGFloat>> { return .name(B.frameRotation) }
	static var gestureRecognizers: ViewName<Dynamic<[GestureRecognizerConvertible]>> { return .name(B.gestureRecognizers) }
	static var horizontalContentCompressionResistancePriority: ViewName<Dynamic<NSLayoutConstraint.Priority>> { return .name(B.horizontalContentCompressionResistancePriority) }
	static var horizontalContentHuggingPriority: ViewName<Dynamic<NSLayoutConstraint.Priority>> { return .name(B.horizontalContentHuggingPriority) }
	static var identifier: ViewName<Dynamic<NSUserInterfaceItemIdentifier?>> { return .name(B.identifier) }
	static var isHidden: ViewName<Dynamic<Bool>> { return .name(B.isHidden) }
	static var layerContentsRedrawPolicy: ViewName<Dynamic<NSView.LayerContentsRedrawPolicy>> { return .name(B.layerContentsRedrawPolicy) }
	static var layout: ViewName<Dynamic<Layout?>> { return .name(B.layout) }
	static var registeredDragTypes: ViewName<Dynamic<[NSPasteboard.PasteboardType]>> { return .name(B.registeredDragTypes) }
	static var tooltip: ViewName<Dynamic<String>> { return .name(B.tooltip) }
	static var verticalContentCompressionResistancePriority: ViewName<Dynamic<NSLayoutConstraint.Priority>> { return .name(B.verticalContentCompressionResistancePriority) }
	static var verticalContentHuggingPriority: ViewName<Dynamic<NSLayoutConstraint.Priority>> { return .name(B.verticalContentHuggingPriority) }
	
	@available(macOS 10.11, *) static var pressureConfiguration: ViewName<Dynamic<NSPressureConfiguration>> { return .name(B.pressureConfiguration) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var needsDisplay: ViewName<Signal<Bool>> { return .name(B.needsDisplay) }
	static var printView: ViewName<Signal<Void>> { return .name(B.printView) }
	static var scrollRectToVisible: ViewName<Signal<NSRect>> { return .name(B.scrollRectToVisible) }
	static var setNeedsDisplayInRect: ViewName<Signal<NSRect>> { return .name(B.setNeedsDisplayInRect) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var boundsDidChange: ViewName<SignalInput<NSRect>> { return .name(B.boundsDidChange) }
	static var frameDidChange: ViewName<SignalInput<NSRect>> { return .name(B.frameDidChange) }
	static var globalFrameDidChange: ViewName<SignalInput<NSRect>> { return .name(B.globalFrameDidChange) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
extension NSView: DefaultConstructable {}
public extension View {
	func nsView() -> Layout.View { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ViewBinding: BinderBaseBinding {
	static func viewBinding(_ binding: View.Binding) -> Self
}
public extension ViewBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return viewBinding(.inheritedBinding(binding))
	}
}
public extension View.Binding {
	public typealias Preparer = View.Preparer
	static func viewBinding(_ binding: View.Binding) -> View.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
