//
//  CwlView_iOS.swift
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

#if os(iOS)

extension BindingParser where Binding == View.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var layer: BindingParser<Constant<Layer>, Binding> { return BindingParser<Constant<Layer>, Binding>(parse: { binding -> Optional<Constant<Layer>> in if case .layer(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var alpha: BindingParser<Dynamic<(CGFloat)>, Binding> { return BindingParser<Dynamic<(CGFloat)>, Binding>(parse: { binding -> Optional<Dynamic<(CGFloat)>> in if case .alpha(let x) = binding { return x } else { return nil } }) }
	public static var backgroundColor: BindingParser<Dynamic<(UIColor?)>, Binding> { return BindingParser<Dynamic<(UIColor?)>, Binding>(parse: { binding -> Optional<Dynamic<(UIColor?)>> in if case .backgroundColor(let x) = binding { return x } else { return nil } }) }
	public static var clearsContextBeforeDrawing: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .clearsContextBeforeDrawing(let x) = binding { return x } else { return nil } }) }
	public static var clipsToBounds: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .clipsToBounds(let x) = binding { return x } else { return nil } }) }
	public static var contentMode: BindingParser<Dynamic<(UIView.ContentMode)>, Binding> { return BindingParser<Dynamic<(UIView.ContentMode)>, Binding>(parse: { binding -> Optional<Dynamic<(UIView.ContentMode)>> in if case .contentMode(let x) = binding { return x } else { return nil } }) }
	public static var gestureRecognizers: BindingParser<Dynamic<[GestureRecognizerConvertible]>, Binding> { return BindingParser<Dynamic<[GestureRecognizerConvertible]>, Binding>(parse: { binding -> Optional<Dynamic<[GestureRecognizerConvertible]>> in if case .gestureRecognizers(let x) = binding { return x } else { return nil } }) }
	public static var horizontalContentCompressionResistancePriority: BindingParser<Dynamic<UILayoutPriority>, Binding> { return BindingParser<Dynamic<UILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<UILayoutPriority>> in if case .horizontalContentCompressionResistancePriority(let x) = binding { return x } else { return nil } }) }
	public static var horizontalContentHuggingPriority: BindingParser<Dynamic<UILayoutPriority>, Binding> { return BindingParser<Dynamic<UILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<UILayoutPriority>> in if case .horizontalContentHuggingPriority(let x) = binding { return x } else { return nil } }) }
	public static var isExclusiveTouch: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .isExclusiveTouch(let x) = binding { return x } else { return nil } }) }
	public static var isHidden: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .isHidden(let x) = binding { return x } else { return nil } }) }
	public static var isMultipleTouchEnabled: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .isMultipleTouchEnabled(let x) = binding { return x } else { return nil } }) }
	public static var isOpaque: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .isOpaque(let x) = binding { return x } else { return nil } }) }
	public static var isUserInteractionEnabled: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .isUserInteractionEnabled(let x) = binding { return x } else { return nil } }) }
	public static var layout: BindingParser<Dynamic<Layout>, Binding> { return BindingParser<Dynamic<Layout>, Binding>(parse: { binding -> Optional<Dynamic<Layout>> in if case .layout(let x) = binding { return x } else { return nil } }) }
	public static var layoutMargins: BindingParser<Dynamic<(UIEdgeInsets)>, Binding> { return BindingParser<Dynamic<(UIEdgeInsets)>, Binding>(parse: { binding -> Optional<Dynamic<(UIEdgeInsets)>> in if case .layoutMargins(let x) = binding { return x } else { return nil } }) }
	public static var mask: BindingParser<Dynamic<(ViewConvertible?)>, Binding> { return BindingParser<Dynamic<(ViewConvertible?)>, Binding>(parse: { binding -> Optional<Dynamic<(ViewConvertible?)>> in if case .mask(let x) = binding { return x } else { return nil } }) }
	public static var motionEffects: BindingParser<Dynamic<([UIMotionEffect])>, Binding> { return BindingParser<Dynamic<([UIMotionEffect])>, Binding>(parse: { binding -> Optional<Dynamic<([UIMotionEffect])>> in if case .motionEffects(let x) = binding { return x } else { return nil } }) }
	public static var preservesSuperviewLayoutMargins: BindingParser<Dynamic<(Bool)>, Binding> { return BindingParser<Dynamic<(Bool)>, Binding>(parse: { binding -> Optional<Dynamic<(Bool)>> in if case .preservesSuperviewLayoutMargins(let x) = binding { return x } else { return nil } }) }
	public static var restorationIdentifier: BindingParser<Dynamic<String?>, Binding> { return BindingParser<Dynamic<String?>, Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .restorationIdentifier(let x) = binding { return x } else { return nil } }) }
	public static var semanticContentAttribute: BindingParser<Dynamic<(UISemanticContentAttribute)>, Binding> { return BindingParser<Dynamic<(UISemanticContentAttribute)>, Binding>(parse: { binding -> Optional<Dynamic<(UISemanticContentAttribute)>> in if case .semanticContentAttribute(let x) = binding { return x } else { return nil } }) }
	public static var tag: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .tag(let x) = binding { return x } else { return nil } }) }
	public static var tintAdjustmentMode: BindingParser<Dynamic<(UIView.TintAdjustmentMode)>, Binding> { return BindingParser<Dynamic<(UIView.TintAdjustmentMode)>, Binding>(parse: { binding -> Optional<Dynamic<(UIView.TintAdjustmentMode)>> in if case .tintAdjustmentMode(let x) = binding { return x } else { return nil } }) }
	public static var tintColor: BindingParser<Dynamic<(UIColor)>, Binding> { return BindingParser<Dynamic<(UIColor)>, Binding>(parse: { binding -> Optional<Dynamic<(UIColor)>> in if case .tintColor(let x) = binding { return x } else { return nil } }) }
	public static var verticalContentCompressionResistancePriority: BindingParser<Dynamic<UILayoutPriority>, Binding> { return BindingParser<Dynamic<UILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<UILayoutPriority>> in if case .verticalContentCompressionResistancePriority(let x) = binding { return x } else { return nil } }) }
	public static var verticalContentHuggingPriority: BindingParser<Dynamic<UILayoutPriority>, Binding> { return BindingParser<Dynamic<UILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<UILayoutPriority>> in if case .verticalContentHuggingPriority(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var becomeFirstResponder: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .becomeFirstResponder(let x) = binding { return x } else { return nil } }) }
	public static var endEditing: BindingParser<Signal<Bool>, Binding> { return BindingParser<Signal<Bool>, Binding>(parse: { binding -> Optional<Signal<Bool>> in if case .endEditing(let x) = binding { return x } else { return nil } }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
