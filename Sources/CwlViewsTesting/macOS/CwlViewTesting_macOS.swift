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

extension BindingParser where Downcast: ViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, View.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asViewBinding() }) }
		
	//	0. Static styles are applied at construction and are subsequently immutable.
	public static var layer: BindingParser<Constant<Layer>, View.Binding, Downcast> { return .init(extract: { if case .layer(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var appearance: BindingParser<Dynamic<NSAppearance?>, View.Binding, Downcast> { return .init(extract: { if case .appearance(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var canDrawSubviewsIntoLayer: BindingParser<Dynamic<Bool>, View.Binding, Downcast> { return .init(extract: { if case .canDrawSubviewsIntoLayer(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var focusRingType: BindingParser<Dynamic<NSFocusRingType>, View.Binding, Downcast> { return .init(extract: { if case .focusRingType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var frameRotation: BindingParser<Dynamic<CGFloat>, View.Binding, Downcast> { return .init(extract: { if case .frameRotation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var gestureRecognizers: BindingParser<Dynamic<[GestureRecognizerConvertible]>, View.Binding, Downcast> { return .init(extract: { if case .gestureRecognizers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var horizontalContentCompressionResistancePriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, View.Binding, Downcast> { return .init(extract: { if case .horizontalContentCompressionResistancePriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var horizontalContentHuggingPriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, View.Binding, Downcast> { return .init(extract: { if case .horizontalContentHuggingPriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var identifier: BindingParser<Dynamic<NSUserInterfaceItemIdentifier?>, View.Binding, Downcast> { return .init(extract: { if case .identifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, View.Binding, Downcast> { return .init(extract: { if case .isHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var layerContentsRedrawPolicy: BindingParser<Dynamic<NSView.LayerContentsRedrawPolicy>, View.Binding, Downcast> { return .init(extract: { if case .layerContentsRedrawPolicy(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var layout: BindingParser<Dynamic<Layout>, View.Binding, Downcast> { return .init(extract: { if case .layout(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var pressureConfiguration: BindingParser<Dynamic<NSPressureConfiguration>, View.Binding, Downcast> { return .init(extract: { if case .pressureConfiguration(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var registeredDragTypes: BindingParser<Dynamic<[NSPasteboard.PasteboardType]>, View.Binding, Downcast> { return .init(extract: { if case .registeredDragTypes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var tooltip: BindingParser<Dynamic<String>, View.Binding, Downcast> { return .init(extract: { if case .tooltip(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var verticalContentCompressionResistancePriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, View.Binding, Downcast> { return .init(extract: { if case .verticalContentCompressionResistancePriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var verticalContentHuggingPriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, View.Binding, Downcast> { return .init(extract: { if case .verticalContentHuggingPriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var becomeFirstResponder: BindingParser<Signal<Void>, View.Binding, Downcast> { return .init(extract: { if case .becomeFirstResponder(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var needsDisplay: BindingParser<Signal<Bool>, View.Binding, Downcast> { return .init(extract: { if case .needsDisplay(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var printView: BindingParser<Signal<Void>, View.Binding, Downcast> { return .init(extract: { if case .printView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var scrollRectToVisible: BindingParser<Signal<NSRect>, View.Binding, Downcast> { return .init(extract: { if case .scrollRectToVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var setNeedsDisplayInRect: BindingParser<Signal<NSRect>, View.Binding, Downcast> { return .init(extract: { if case .setNeedsDisplayInRect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var boundsDidChange: BindingParser<SignalInput<NSRect>, View.Binding, Downcast> { return .init(extract: { if case .boundsDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var frameDidChange: BindingParser<SignalInput<NSRect>, View.Binding, Downcast> { return .init(extract: { if case .frameDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
