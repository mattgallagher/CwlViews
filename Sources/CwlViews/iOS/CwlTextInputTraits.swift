//
//  CwlTextInputTraits.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

public struct TextInputTraits {
	let bindings: [Binding]
	public init(bindings: [Binding]) {
		self.bindings = bindings
	}
	public init(_ bindings: Binding...) {
		self.init(bindings: bindings)
	}
	
	public enum Binding {
		case autocapitalizationType(Dynamic<UITextAutocapitalizationType>)
		case autocorrectionType(Dynamic<UITextAutocorrectionType>)
		case spellCheckingType(Dynamic<UITextSpellCheckingType>)
		case enablesReturnKeyAutomatically(Dynamic<Bool>)
		case keyboardAppearance(Dynamic<UIKeyboardAppearance>)
		case keyboardType(Dynamic<UIKeyboardType>)
		case returnKeyType(Dynamic<UIReturnKeyType>)
		@available(iOS 11.0, *)
		case smartDashesType(Dynamic<UITextSmartDashesType>)
		@available(iOS 11.0, *)
		case smartQuotesType(Dynamic<UITextSmartQuotesType>)
		@available(iOS 11.0, *)
		case smartInsertDeleteType(Dynamic<UITextSmartInsertDeleteType>)
		case isSecureTextEntry(Dynamic<Bool>)
		@available(iOS 10.0, *)
		case textContentType(Dynamic<UITextContentType>)
	}
}

extension BindingName where Binding == TextInputTraits.Binding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in TextInputTraits.$1(v) }) }
	public static var autocapitalizationType: BindingName<Dynamic<UITextAutocapitalizationType>, Binding> { return BindingName<Dynamic<UITextAutocapitalizationType>, Binding>({ v in TextInputTraits.Binding.autocapitalizationType(v) }) }
	public static var autocorrectionType: BindingName<Dynamic<UITextAutocorrectionType>, Binding> { return BindingName<Dynamic<UITextAutocorrectionType>, Binding>({ v in TextInputTraits.Binding.autocorrectionType(v) }) }
	public static var spellCheckingType: BindingName<Dynamic<UITextSpellCheckingType>, Binding> { return BindingName<Dynamic<UITextSpellCheckingType>, Binding>({ v in TextInputTraits.Binding.spellCheckingType(v) }) }
	public static var enablesReturnKeyAutomatically: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in TextInputTraits.Binding.enablesReturnKeyAutomatically(v) }) }
	public static var keyboardAppearance: BindingName<Dynamic<UIKeyboardAppearance>, Binding> { return BindingName<Dynamic<UIKeyboardAppearance>, Binding>({ v in TextInputTraits.Binding.keyboardAppearance(v) }) }
	public static var keyboardType: BindingName<Dynamic<UIKeyboardType>, Binding> { return BindingName<Dynamic<UIKeyboardType>, Binding>({ v in TextInputTraits.Binding.keyboardType(v) }) }
	public static var returnKeyType: BindingName<Dynamic<UIReturnKeyType>, Binding> { return BindingName<Dynamic<UIReturnKeyType>, Binding>({ v in TextInputTraits.Binding.returnKeyType(v) }) }
	@available(iOS 11.0, *)
	public static var smartDashesType: BindingName<Dynamic<UITextSmartDashesType>, Binding> { return BindingName<Dynamic<UITextSmartDashesType>, Binding>({ v in TextInputTraits.Binding.smartDashesType(v) }) }
	@available(iOS 11.0, *)
	public static var smartQuotesType: BindingName<Dynamic<UITextSmartQuotesType>, Binding> { return BindingName<Dynamic<UITextSmartQuotesType>, Binding>({ v in TextInputTraits.Binding.smartQuotesType(v) }) }
	@available(iOS 11.0, *)
	public static var smartInsertDeleteType: BindingName<Dynamic<UITextSmartInsertDeleteType>, Binding> { return BindingName<Dynamic<UITextSmartInsertDeleteType>, Binding>({ v in TextInputTraits.Binding.smartInsertDeleteType(v) }) }
	public static var isSecureTextEntry: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in TextInputTraits.Binding.isSecureTextEntry(v) }) }
	@available(iOS 10.0, *)
	public static var textContentType: BindingName<Dynamic<UITextContentType>, Binding> { return BindingName<Dynamic<UITextContentType>, Binding>({ v in TextInputTraits.Binding.textContentType(v) }) }
}
