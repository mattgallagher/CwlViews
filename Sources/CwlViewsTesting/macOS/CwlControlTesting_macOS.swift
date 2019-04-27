//
//  CwlControl_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 26/10/2015.
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

extension BindingParser where Downcast: ControlBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Control.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asControlBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var alignment: BindingParser<Dynamic<NSTextAlignment>, Control.Binding, Downcast> { return .init(extract: { if case .alignment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var allowsExpansionToolTips: BindingParser<Dynamic<Bool>, Control.Binding, Downcast> { return .init(extract: { if case .allowsExpansionToolTips(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var attributedStringValue: BindingParser<Dynamic<NSAttributedString>, Control.Binding, Downcast> { return .init(extract: { if case .attributedStringValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var baseWritingDirection: BindingParser<Dynamic<NSWritingDirection>, Control.Binding, Downcast> { return .init(extract: { if case .baseWritingDirection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var doubleValue: BindingParser<Dynamic<Double>, Control.Binding, Downcast> { return .init(extract: { if case .doubleValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var floatValue: BindingParser<Dynamic<Float>, Control.Binding, Downcast> { return .init(extract: { if case .floatValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var font: BindingParser<Dynamic<NSFont>, Control.Binding, Downcast> { return .init(extract: { if case .font(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var formatter: BindingParser<Dynamic<Foundation.Formatter?>, Control.Binding, Downcast> { return .init(extract: { if case .formatter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var ignoresMultiClick: BindingParser<Dynamic<Bool>, Control.Binding, Downcast> { return .init(extract: { if case .ignoresMultiClick(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var integerValue: BindingParser<Dynamic<Int>, Control.Binding, Downcast> { return .init(extract: { if case .integerValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var intValue: BindingParser<Dynamic<Int32>, Control.Binding, Downcast> { return .init(extract: { if case .intValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var isContinuous: BindingParser<Dynamic<Bool>, Control.Binding, Downcast> { return .init(extract: { if case .isContinuous(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var isEnabled: BindingParser<Dynamic<Bool>, Control.Binding, Downcast> { return .init(extract: { if case .isEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var isHighlighted: BindingParser<Dynamic<Bool>, Control.Binding, Downcast> { return .init(extract: { if case .isHighlighted(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var lineBreakMode: BindingParser<Dynamic<NSLineBreakMode>, Control.Binding, Downcast> { return .init(extract: { if case .lineBreakMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var objectValue: BindingParser<Dynamic<Any>, Control.Binding, Downcast> { return .init(extract: { if case .objectValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var refusesFirstResponder: BindingParser<Dynamic<Bool>, Control.Binding, Downcast> { return .init(extract: { if case .refusesFirstResponder(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var sendActionOn: BindingParser<Dynamic<NSEvent.EventTypeMask>, Control.Binding, Downcast> { return .init(extract: { if case .sendActionOn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var size: BindingParser<Dynamic<NSControl.ControlSize>, Control.Binding, Downcast> { return .init(extract: { if case .size(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var stringValue: BindingParser<Dynamic<String>, Control.Binding, Downcast> { return .init(extract: { if case .stringValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var tag: BindingParser<Dynamic<Int>, Control.Binding, Downcast> { return .init(extract: { if case .tag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var usesSingleLineMode: BindingParser<Dynamic<Bool>, Control.Binding, Downcast> { return .init(extract: { if case .usesSingleLineMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var abortEditing: BindingParser<Signal<Void>, Control.Binding, Downcast> { return .init(extract: { if case .abortEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var performClick: BindingParser<Signal<Void>, Control.Binding, Downcast> { return .init(extract: { if case .performClick(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var sizeToFit: BindingParser<Signal<Void>, Control.Binding, Downcast> { return .init(extract: { if case .sizeToFit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var validateEditing: BindingParser<Signal<Void>, Control.Binding, Downcast> { return .init(extract: { if case .validateEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	
	//	3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, Control.Binding, Downcast> { return .init(extract: { if case .action(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var textDidBeginEditing: BindingParser<(NSText) -> Void, Control.Binding, Downcast> { return .init(extract: { if case .textDidBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var textDidChange: BindingParser<(NSText) -> Void, Control.Binding, Downcast> { return .init(extract: { if case .textDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
	public static var textDidEndEditing: BindingParser<(NSText) -> Void, Control.Binding, Downcast> { return .init(extract: { if case .textDidEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asControlBinding() }) }
}

#endif
