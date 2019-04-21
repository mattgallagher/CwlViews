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

extension BindingParser where Binding == View.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static styles are applied at construction and are subsequently immutable.
	public static var layer: BindingParser<Constant<Layer>, Binding> { return BindingParser<Constant<Layer>, Binding>(parse: { binding -> Optional<Constant<Layer>> in if case .layer(let x) = binding { return x } else { return nil } }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var appearance: BindingParser<Dynamic<NSAppearance?>, Binding> { return BindingParser<Dynamic<NSAppearance?>, Binding>(parse: { binding -> Optional<Dynamic<NSAppearance?>> in if case .appearance(let x) = binding { return x } else { return nil } }) }
	public static var canDrawSubviewsIntoLayer: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .canDrawSubviewsIntoLayer(let x) = binding { return x } else { return nil } }) }
	public static var focusRingType: BindingParser<Dynamic<NSFocusRingType>, Binding> { return BindingParser<Dynamic<NSFocusRingType>, Binding>(parse: { binding -> Optional<Dynamic<NSFocusRingType>> in if case .focusRingType(let x) = binding { return x } else { return nil } }) }
	public static var frameRotation: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .frameRotation(let x) = binding { return x } else { return nil } }) }
	public static var gestureRecognizers: BindingParser<Dynamic<[GestureRecognizerConvertible]>, Binding> { return BindingParser<Dynamic<[GestureRecognizerConvertible]>, Binding>(parse: { binding -> Optional<Dynamic<[GestureRecognizerConvertible]>> in if case .gestureRecognizers(let x) = binding { return x } else { return nil } }) }
	public static var horizontalContentCompressionResistancePriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding>(parse: { binding -> Optional<Dynamic<NSLayoutConstraint.Priority>> in if case .horizontalContentCompressionResistancePriority(let x) = binding { return x } else { return nil } }) }
	public static var horizontalContentHuggingPriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding>(parse: { binding -> Optional<Dynamic<NSLayoutConstraint.Priority>> in if case .horizontalContentHuggingPriority(let x) = binding { return x } else { return nil } }) }
	public static var identifier: BindingParser<Dynamic<NSUserInterfaceItemIdentifier?>, Binding> { return BindingParser<Dynamic<NSUserInterfaceItemIdentifier?>, Binding>(parse: { binding -> Optional<Dynamic<NSUserInterfaceItemIdentifier?>> in if case .identifier(let x) = binding { return x } else { return nil } }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isHidden(let x) = binding { return x } else { return nil } }) }
	public static var layerContentsRedrawPolicy: BindingParser<Dynamic<NSView.LayerContentsRedrawPolicy>, Binding> { return BindingParser<Dynamic<NSView.LayerContentsRedrawPolicy>, Binding>(parse: { binding -> Optional<Dynamic<NSView.LayerContentsRedrawPolicy>> in if case .layerContentsRedrawPolicy(let x) = binding { return x } else { return nil } }) }
	public static var layout: BindingParser<Dynamic<Layout>, Binding> { return BindingParser<Dynamic<Layout>, Binding>(parse: { binding -> Optional<Dynamic<Layout>> in if case .layout(let x) = binding { return x } else { return nil } }) }
	public static var pressureConfiguration: BindingParser<Dynamic<NSPressureConfiguration>, Binding> { return BindingParser<Dynamic<NSPressureConfiguration>, Binding>(parse: { binding -> Optional<Dynamic<NSPressureConfiguration>> in if case .pressureConfiguration(let x) = binding { return x } else { return nil } }) }
	public static var registeredDragTypes: BindingParser<Dynamic<[NSPasteboard.PasteboardType]>, Binding> { return BindingParser<Dynamic<[NSPasteboard.PasteboardType]>, Binding>(parse: { binding -> Optional<Dynamic<[NSPasteboard.PasteboardType]>> in if case .registeredDragTypes(let x) = binding { return x } else { return nil } }) }
	public static var tooltip: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .tooltip(let x) = binding { return x } else { return nil } }) }
	public static var verticalContentCompressionResistancePriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding>(parse: { binding -> Optional<Dynamic<NSLayoutConstraint.Priority>> in if case .verticalContentCompressionResistancePriority(let x) = binding { return x } else { return nil } }) }
	public static var verticalContentHuggingPriority: BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding> { return BindingParser<Dynamic<NSLayoutConstraint.Priority>, Binding>(parse: { binding -> Optional<Dynamic<NSLayoutConstraint.Priority>> in if case .verticalContentHuggingPriority(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var becomeFirstResponder: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .becomeFirstResponder(let x) = binding { return x } else { return nil } }) }
	public static var needsDisplay: BindingParser<Signal<Bool>, Binding> { return BindingParser<Signal<Bool>, Binding>(parse: { binding -> Optional<Signal<Bool>> in if case .needsDisplay(let x) = binding { return x } else { return nil } }) }
	public static var printView: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .printView(let x) = binding { return x } else { return nil } }) }
	public static var scrollRectToVisible: BindingParser<Signal<NSRect>, Binding> { return BindingParser<Signal<NSRect>, Binding>(parse: { binding -> Optional<Signal<NSRect>> in if case .scrollRectToVisible(let x) = binding { return x } else { return nil } }) }
	public static var setNeedsDisplayInRect: BindingParser<Signal<NSRect>, Binding> { return BindingParser<Signal<NSRect>, Binding>(parse: { binding -> Optional<Signal<NSRect>> in if case .setNeedsDisplayInRect(let x) = binding { return x } else { return nil } }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var boundsDidChange: BindingParser<SignalInput<NSRect>, Binding> { return BindingParser<SignalInput<NSRect>, Binding>(parse: { binding -> Optional<SignalInput<NSRect>> in if case .boundsDidChange(let x) = binding { return x } else { return nil } }) }
	public static var frameDidChange: BindingParser<SignalInput<NSRect>, Binding> { return BindingParser<SignalInput<NSRect>, Binding>(parse: { binding -> Optional<SignalInput<NSRect>> in if case .frameDidChange(let x) = binding { return x } else { return nil } }) }
	public static var globalFrameDidChange: BindingParser<SignalInput<NSRect>, Binding> { return BindingParser<SignalInput<NSRect>, Binding>(parse: { binding -> Optional<SignalInput<NSRect>> in if case .globalFrameDidChange(let x) = binding { return x } else { return nil } }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
