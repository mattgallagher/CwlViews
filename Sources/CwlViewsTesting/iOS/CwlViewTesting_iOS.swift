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

extension BindingParser where Downcast: ViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, View.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asViewBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var layer: BindingParser<Constant<Layer>, View.Binding, Downcast> { return .init(extract: { if case .layer(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var alpha: BindingParser<Dynamic<(CGFloat)>, View.Binding, Downcast> { return .init(extract: { if case .alpha(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var backgroundColor: BindingParser<Dynamic<(UIColor?)>, View.Binding, Downcast> { return .init(extract: { if case .backgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var clearsContextBeforeDrawing: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .clearsContextBeforeDrawing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var clipsToBounds: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .clipsToBounds(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var contentMode: BindingParser<Dynamic<(UIView.ContentMode)>, View.Binding, Downcast> { return .init(extract: { if case .contentMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var gestureRecognizers: BindingParser<Dynamic<[GestureRecognizerConvertible]>, View.Binding, Downcast> { return .init(extract: { if case .gestureRecognizers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var horizontalContentCompressionResistancePriority: BindingParser<Dynamic<UILayoutPriority>, View.Binding, Downcast> { return .init(extract: { if case .horizontalContentCompressionResistancePriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var horizontalContentHuggingPriority: BindingParser<Dynamic<UILayoutPriority>, View.Binding, Downcast> { return .init(extract: { if case .horizontalContentHuggingPriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var isExclusiveTouch: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .isExclusiveTouch(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var isHidden: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .isHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var isMultipleTouchEnabled: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .isMultipleTouchEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var isOpaque: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .isOpaque(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var isUserInteractionEnabled: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .isUserInteractionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var layout: BindingParser<Dynamic<Layout>, View.Binding, Downcast> { return .init(extract: { if case .layout(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var layoutMargins: BindingParser<Dynamic<(UIEdgeInsets)>, View.Binding, Downcast> { return .init(extract: { if case .layoutMargins(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var mask: BindingParser<Dynamic<(ViewConvertible?)>, View.Binding, Downcast> { return .init(extract: { if case .mask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var motionEffects: BindingParser<Dynamic<([UIMotionEffect])>, View.Binding, Downcast> { return .init(extract: { if case .motionEffects(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var preservesSuperviewLayoutMargins: BindingParser<Dynamic<(Bool)>, View.Binding, Downcast> { return .init(extract: { if case .preservesSuperviewLayoutMargins(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var restorationIdentifier: BindingParser<Dynamic<String?>, View.Binding, Downcast> { return .init(extract: { if case .restorationIdentifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var semanticContentAttribute: BindingParser<Dynamic<(UISemanticContentAttribute)>, View.Binding, Downcast> { return .init(extract: { if case .semanticContentAttribute(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var tag: BindingParser<Dynamic<Int>, View.Binding, Downcast> { return .init(extract: { if case .tag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var tintAdjustmentMode: BindingParser<Dynamic<(UIView.TintAdjustmentMode)>, View.Binding, Downcast> { return .init(extract: { if case .tintAdjustmentMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var tintColor: BindingParser<Dynamic<(UIColor)>, View.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var verticalContentCompressionResistancePriority: BindingParser<Dynamic<UILayoutPriority>, View.Binding, Downcast> { return .init(extract: { if case .verticalContentCompressionResistancePriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var verticalContentHuggingPriority: BindingParser<Dynamic<UILayoutPriority>, View.Binding, Downcast> { return .init(extract: { if case .verticalContentHuggingPriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var becomeFirstResponder: BindingParser<Signal<Void>, View.Binding, Downcast> { return .init(extract: { if case .becomeFirstResponder(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	public static var endEditing: BindingParser<Signal<Bool>, View.Binding, Downcast> { return .init(extract: { if case .endEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
