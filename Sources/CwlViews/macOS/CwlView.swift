//
//  CwlView.swift
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

public class View: ConstructingBinder, ViewConvertible {
	public typealias Instance = NSView
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsView() -> Instance { return instance() }
	
	public enum Binding: ViewBinding {
		public typealias EnclosingBinder = View
		public static func viewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static styles are applied at construction and are subsequently immutable.
		case layer(Constant<BackingLayer>)
		case wantsBackingLayer(Constant<Bool>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case layout(Dynamic<Layout?>)
		case frameRotation(Dynamic<CGFloat>)
		case layerContentsRedrawPolicy(Dynamic<NSView.LayerContentsRedrawPolicy>)
		case canDrawSubviewsIntoLayer(Dynamic<Bool>)
		case horizontalContentCompressionResistancePriority(Dynamic<NSLayoutConstraint.Priority>)
		case verticalContentCompressionResistancePriority(Dynamic<NSLayoutConstraint.Priority>)
		case horizontalContentHuggingPriority(Dynamic<NSLayoutConstraint.Priority>)
		case verticalContentHuggingPriority(Dynamic<NSLayoutConstraint.Priority>)
		case focusRingType(Dynamic<NSFocusRingType>)
		case isHidden(Dynamic<Bool>)
		case registeredDragTypes(Dynamic<[NSPasteboard.PasteboardType]>)
		case tooltip(Dynamic<String>)
		@available(macOS 10.11, *) case pressureConfiguration(Dynamic<NSPressureConfiguration>)
		case identifier(Dynamic<NSUserInterfaceItemIdentifier?>)
		case appearance(Dynamic<NSAppearance?>)
		case hostedLayer(Dynamic<LayerConvertible?>)
		case gestureRecognizers(Dynamic<[GestureRecognizerConvertible]>)
		
		// 2. Signal bindings are performed on the object after construction.
		case printView(Signal<Void>)
		case setNeedsDisplayInRect(Signal<NSRect>)
		case needsDisplay(Signal<Bool>)
		case scrollRectToVisible(Signal<NSRect>)
		
		// 3. Action bindings are triggered by the object after construction.
		case frameDidChange(SignalInput<NSRect>)
		case globalFrameDidChange(SignalInput<NSRect>)
		case boundsDidChange(SignalInput<NSRect>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = View
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(frame: NSRect.zero) }
		
		// InitialSubsequent styles and other speciyal handling
		var hostedLayer = false
		var wantsBackingLayer = false
		var backingLayerShadow = false
		var layerBindings: [BackingLayer.Binding]? = nil
		
		public init() {}
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .layer(let x):
				let bindings = x.value.consumeBindings()
				layerBindings = bindings
				for s in bindings {
					switch s {
					case .shadowColor: fallthrough
					case .shadowOffset: fallthrough
					case .shadowOpacity: fallthrough
					case .shadowPath: fallthrough
					case .shadowRadius: backingLayerShadow = true
					default: break
					}
				}
				wantsBackingLayer = true
			case .wantsBackingLayer(let x): wantsBackingLayer = x.value
			case .hostedLayer:
				precondition(wantsBackingLayer == false, "Cannot set backing layer properties on a view *and* provide a hosted layer.")
				hostedLayer = true
			case .inheritedBinding(let preceeding): linkedPreparer.prepareBinding(preceeding)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			// Apply captured variables that need to be applied as soon as possible after construction
			if wantsBackingLayer == true {
				instance.wantsLayer = true
				if backingLayerShadow {
					instance.shadow = NSShadow()
				}
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .layer:
				if let l = instance.layer, let bindings = layerBindings {
					BackingLayer(bindings: bindings).applyBindings(to: l)
				}
				return nil
			case .layout(let x):
				return x.apply(instance, storage) { i, s, v in
					i.applyLayout(v)
				}
			case .frameRotation(let x): return x.apply(instance, storage) { i, s, v in i.frameRotation = v }
			case .layerContentsRedrawPolicy(let x): return x.apply(instance, storage) { i, s, v in i.layerContentsRedrawPolicy = v }
			case .canDrawSubviewsIntoLayer(let x): return x.apply(instance, storage) { i, s, v in i.canDrawSubviewsIntoLayer = v }
			case .horizontalContentCompressionResistancePriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Orientation.horizontal) }
			case .verticalContentCompressionResistancePriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Orientation.vertical) }
			case .horizontalContentHuggingPriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Orientation.horizontal) }
			case .verticalContentHuggingPriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Orientation.vertical) }
			case .focusRingType(let x): return x.apply(instance, storage) { i, s, v in i.focusRingType = v }
			case .isHidden(let x): return x.apply(instance, storage) { i, s, v in i.isHidden = v }
			case .registeredDragTypes(let x):
				return x.apply(instance, storage) { i, s, v in
					if v.isEmpty {
						i.unregisterDraggedTypes()
					} else {
						i.registerForDraggedTypes(v)
					}
				}
			case .tooltip(let x): return x.apply(instance, storage) { i, s, v in i.toolTip = v }
			case .pressureConfiguration(let x):
				return x.apply(instance, storage) { i, s, v in
					if #available(macOS 10.11, *) {
						i.pressureConfiguration = v
					}
				}
			case .identifier(let x): return x.apply(instance, storage) { i, s, v in i.identifier = v }
			case .appearance(let x): return x.apply(instance, storage) { i, s, v in i.appearance = v }
			case .printView(let x): return x.apply(instance, storage) { i, s, v in i.printView(nil) }
			case .setNeedsDisplayInRect(let x): return x.apply(instance, storage) { i, s, v in i.setNeedsDisplay(v) }
			case .needsDisplay(let x): return x.apply(instance, storage) { i, s, v in i.needsDisplay = v }
			case .scrollRectToVisible(let x): return x.apply(instance, storage) { i, s, v in i.scrollToVisible(v) }
			case .frameDidChange(let x):
				instance.postsFrameChangedNotifications = true
				return Signal.notifications(name: NSView.frameDidChangeNotification, object: instance).compactMap { notification -> NSRect? in (notification.object as? NSView)?.frame }.cancellableBind(to: x)
			case .globalFrameDidChange(let x):
				instance.postsFrameChangedNotifications = true
				return Signal.notifications(name: NSView.globalFrameDidChangeNotification, object: instance).compactMap { notification -> NSRect? in (notification.object as? NSView)?.frame }.cancellableBind(to: x)
			case .boundsDidChange(let x):
				instance.postsBoundsChangedNotifications = true
				return Signal.notifications(name: NSView.boundsDidChangeNotification, object: instance).compactMap { notification -> NSRect? in (notification.object as? NSView)?.bounds }.cancellableBind(to: x)
			case .hostedLayer(let x):
				return x.apply(instance, storage) { i, s, v in
					i.layer = v?.cgLayer
					i.wantsLayer = v != nil
				}
			case .wantsBackingLayer: return nil
			case .gestureRecognizers(let x): return x.apply(instance, storage) { i, s, v in i.gestureRecognizers = v.map { $0.nsGestureRecognizer() } }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = ObjectBinderStorage
}

extension BindingName where Binding: ViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .viewBinding(View.Binding.$1(v)) }) }

	//	0. Static styles are applied at construction and are subsequently immutable.
	public static var layer: BindingName<Constant<BackingLayer>, Binding> { return BindingName<Constant<BackingLayer>, Binding>({ v in .viewBinding(View.Binding.layer(v)) }) }
	public static var wantsBackingLayer: BindingName<Constant<Bool>, Binding> { return BindingName<Constant<Bool>, Binding>({ v in .viewBinding(View.Binding.wantsBackingLayer(v)) }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var layout: BindingName<Dynamic<Layout?>, Binding> { return BindingName<Dynamic<Layout?>, Binding>({ v in .viewBinding(View.Binding.layout(v)) }) }
	public static var frameRotation: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .viewBinding(View.Binding.frameRotation(v)) }) }
	public static var layerContentsRedrawPolicy: BindingName<Dynamic<NSView.LayerContentsRedrawPolicy>, Binding> { return BindingName<Dynamic<NSView.LayerContentsRedrawPolicy>, Binding>({ v in .viewBinding(View.Binding.layerContentsRedrawPolicy(v)) }) }
	public static var canDrawSubviewsIntoLayer: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewBinding(View.Binding.canDrawSubviewsIntoLayer(v)) }) }
	public static var horizontalContentCompressionResistancePriority: BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding>({ v in .viewBinding(View.Binding.horizontalContentCompressionResistancePriority(v)) }) }
	public static var verticalContentCompressionResistancePriority: BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding>({ v in .viewBinding(View.Binding.verticalContentCompressionResistancePriority(v)) }) }
	public static var horizontalContentHuggingPriority: BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding>({ v in .viewBinding(View.Binding.horizontalContentHuggingPriority(v)) }) }
	public static var verticalContentHuggingPriority: BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingName<Dynamic<NSLayoutConstraint.Priority>, Binding>({ v in .viewBinding(View.Binding.verticalContentHuggingPriority(v)) }) }
	public static var focusRingType: BindingName<Dynamic<NSFocusRingType>, Binding> { return BindingName<Dynamic<NSFocusRingType>, Binding>({ v in .viewBinding(View.Binding.focusRingType(v)) }) }
	public static var isHidden: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .viewBinding(View.Binding.isHidden(v)) }) }
	public static var registeredDragTypes: BindingName<Dynamic<[NSPasteboard.PasteboardType]>, Binding> { return BindingName<Dynamic<[NSPasteboard.PasteboardType]>, Binding>({ v in .viewBinding(View.Binding.registeredDragTypes(v)) }) }
	public static var tooltip: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .viewBinding(View.Binding.tooltip(v)) }) }
	@available(macOS 10.11, *) public static var pressureConfiguration: BindingName<Dynamic<NSPressureConfiguration>, Binding> { return BindingName<Dynamic<NSPressureConfiguration>, Binding>({ v in .viewBinding(View.Binding.pressureConfiguration(v)) }) }
	public static var identifier: BindingName<Dynamic<NSUserInterfaceItemIdentifier?>, Binding> { return BindingName<Dynamic<NSUserInterfaceItemIdentifier?>, Binding>({ v in .viewBinding(View.Binding.identifier(v)) }) }
	public static var appearance: BindingName<Dynamic<NSAppearance?>, Binding> { return BindingName<Dynamic<NSAppearance?>, Binding>({ v in .viewBinding(View.Binding.appearance(v)) }) }
	public static var hostedLayer: BindingName<Dynamic<LayerConvertible?>, Binding> { return BindingName<Dynamic<LayerConvertible?>, Binding>({ v in .viewBinding(View.Binding.hostedLayer(v)) }) }
	public static var gestureRecognizers: BindingName<Dynamic<[GestureRecognizerConvertible]>, Binding> { return BindingName<Dynamic<[GestureRecognizerConvertible]>, Binding>({ v in .viewBinding(View.Binding.gestureRecognizers(v)) }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var printView: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .viewBinding(View.Binding.printView(v)) }) }
	public static var setNeedsDisplayInRect: BindingName<Signal<NSRect>, Binding> { return BindingName<Signal<NSRect>, Binding>({ v in .viewBinding(View.Binding.setNeedsDisplayInRect(v)) }) }
	public static var needsDisplay: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .viewBinding(View.Binding.needsDisplay(v)) }) }
	public static var scrollRectToVisible: BindingName<Signal<NSRect>, Binding> { return BindingName<Signal<NSRect>, Binding>({ v in .viewBinding(View.Binding.scrollRectToVisible(v)) }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var frameDidChange: BindingName<SignalInput<NSRect>, Binding> { return BindingName<SignalInput<NSRect>, Binding>({ v in .viewBinding(View.Binding.frameDidChange(v)) }) }
	public static var globalFrameDidChange: BindingName<SignalInput<NSRect>, Binding> { return BindingName<SignalInput<NSRect>, Binding>({ v in .viewBinding(View.Binding.globalFrameDidChange(v)) }) }
	public static var boundsDidChange: BindingName<SignalInput<NSRect>, Binding> { return BindingName<SignalInput<NSRect>, Binding>({ v in .viewBinding(View.Binding.boundsDidChange(v)) }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol ViewBinding: BaseBinding {
	static func viewBinding(_ binding: View.Binding) -> Self
}
extension ViewBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return viewBinding(.inheritedBinding(binding))
	}
}
