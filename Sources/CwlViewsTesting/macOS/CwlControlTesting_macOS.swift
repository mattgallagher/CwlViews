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

extension BindingParser where Binding == Control.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var alignment: BindingParser<Dynamic<NSTextAlignment>, Binding> { return BindingParser<Dynamic<NSTextAlignment>, Binding>(parse: { binding -> Optional<Dynamic<NSTextAlignment>> in if case .alignment(let x) = binding { return x } else { return nil } }) }
	public static var allowsExpansionToolTips: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsExpansionToolTips(let x) = binding { return x } else { return nil } }) }
	public static var attributedStringValue: BindingParser<Dynamic<NSAttributedString>, Binding> { return BindingParser<Dynamic<NSAttributedString>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString>> in if case .attributedStringValue(let x) = binding { return x } else { return nil } }) }
	public static var baseWritingDirection: BindingParser<Dynamic<NSWritingDirection>, Binding> { return BindingParser<Dynamic<NSWritingDirection>, Binding>(parse: { binding -> Optional<Dynamic<NSWritingDirection>> in if case .baseWritingDirection(let x) = binding { return x } else { return nil } }) }
	public static var doubleValue: BindingParser<Dynamic<Double>, Binding> { return BindingParser<Dynamic<Double>, Binding>(parse: { binding -> Optional<Dynamic<Double>> in if case .doubleValue(let x) = binding { return x } else { return nil } }) }
	public static var floatValue: BindingParser<Dynamic<Float>, Binding> { return BindingParser<Dynamic<Float>, Binding>(parse: { binding -> Optional<Dynamic<Float>> in if case .floatValue(let x) = binding { return x } else { return nil } }) }
	public static var font: BindingParser<Dynamic<NSFont>, Binding> { return BindingParser<Dynamic<NSFont>, Binding>(parse: { binding -> Optional<Dynamic<NSFont>> in if case .font(let x) = binding { return x } else { return nil } }) }
	public static var formatter: BindingParser<Dynamic<Foundation.Formatter?>, Binding> { return BindingParser<Dynamic<Foundation.Formatter?>, Binding>(parse: { binding -> Optional<Dynamic<Foundation.Formatter?>> in if case .formatter(let x) = binding { return x } else { return nil } }) }
	public static var ignoresMultiClick: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .ignoresMultiClick(let x) = binding { return x } else { return nil } }) }
	public static var integerValue: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .integerValue(let x) = binding { return x } else { return nil } }) }
	public static var intValue: BindingParser<Dynamic<Int32>, Binding> { return BindingParser<Dynamic<Int32>, Binding>(parse: { binding -> Optional<Dynamic<Int32>> in if case .intValue(let x) = binding { return x } else { return nil } }) }
	public static var isContinuous: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isContinuous(let x) = binding { return x } else { return nil } }) }
	public static var isEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEnabled(let x) = binding { return x } else { return nil } }) }
	public static var isHighlighted: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isHighlighted(let x) = binding { return x } else { return nil } }) }
	public static var lineBreakMode: BindingParser<Dynamic<NSLineBreakMode>, Binding> { return BindingParser<Dynamic<NSLineBreakMode>, Binding>(parse: { binding -> Optional<Dynamic<NSLineBreakMode>> in if case .lineBreakMode(let x) = binding { return x } else { return nil } }) }
	public static var objectValue: BindingParser<Dynamic<Any>, Binding> { return BindingParser<Dynamic<Any>, Binding>(parse: { binding -> Optional<Dynamic<Any>> in if case .objectValue(let x) = binding { return x } else { return nil } }) }
	public static var refusesFirstResponder: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .refusesFirstResponder(let x) = binding { return x } else { return nil } }) }
	public static var sendActionOn: BindingParser<Dynamic<NSEvent.EventTypeMask>, Binding> { return BindingParser<Dynamic<NSEvent.EventTypeMask>, Binding>(parse: { binding -> Optional<Dynamic<NSEvent.EventTypeMask>> in if case .sendActionOn(let x) = binding { return x } else { return nil } }) }
	public static var size: BindingParser<Dynamic<NSControl.ControlSize>, Binding> { return BindingParser<Dynamic<NSControl.ControlSize>, Binding>(parse: { binding -> Optional<Dynamic<NSControl.ControlSize>> in if case .size(let x) = binding { return x } else { return nil } }) }
	public static var stringValue: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .stringValue(let x) = binding { return x } else { return nil } }) }
	public static var tag: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .tag(let x) = binding { return x } else { return nil } }) }
	public static var usesSingleLineMode: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .usesSingleLineMode(let x) = binding { return x } else { return nil } }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var abortEditing: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .abortEditing(let x) = binding { return x } else { return nil } }) }
	public static var performClick: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .performClick(let x) = binding { return x } else { return nil } }) }
	public static var sizeToFit: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .sizeToFit(let x) = binding { return x } else { return nil } }) }
	public static var validateEditing: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .validateEditing(let x) = binding { return x } else { return nil } }) }
	
	//	3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, Binding> { return BindingParser<TargetAction, Binding>(parse: { binding -> Optional<TargetAction> in if case .action(let x) = binding { return x } else { return nil } }) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var textDidBeginEditing: BindingParser<(NSText) -> Void, Binding> { return BindingParser<(NSText) -> Void, Binding>(parse: { binding -> Optional<(NSText) -> Void> in if case .textDidBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var textDidChange: BindingParser<(NSText) -> Void, Binding> { return BindingParser<(NSText) -> Void, Binding>(parse: { binding -> Optional<(NSText) -> Void> in if case .textDidChange(let x) = binding { return x } else { return nil } }) }
	public static var textDidEndEditing: BindingParser<(NSText) -> Void, Binding> { return BindingParser<(NSText) -> Void, Binding>(parse: { binding -> Optional<(NSText) -> Void> in if case .textDidEndEditing(let x) = binding { return x } else { return nil } }) }
}

#endif
