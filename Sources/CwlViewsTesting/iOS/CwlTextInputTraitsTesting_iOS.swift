//
//  CwlTextInputTraits_iOS.swift
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

#if os(iOS)

extension BindingParser where Binding == TextInputTraits.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	public static var autocapitalizationType: BindingParser<Dynamic<UITextAutocapitalizationType>, Binding> { return BindingParser<Dynamic<UITextAutocapitalizationType>, Binding>(parse: { binding -> Optional<Dynamic<UITextAutocapitalizationType>> in if case .autocapitalizationType(let x) = binding { return x } else { return nil } }) }
	public static var autocorrectionType: BindingParser<Dynamic<UITextAutocorrectionType>, Binding> { return BindingParser<Dynamic<UITextAutocorrectionType>, Binding>(parse: { binding -> Optional<Dynamic<UITextAutocorrectionType>> in if case .autocorrectionType(let x) = binding { return x } else { return nil } }) }
	public static var enablesReturnKeyAutomatically: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .enablesReturnKeyAutomatically(let x) = binding { return x } else { return nil } }) }
	public static var isSecureTextEntry: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isSecureTextEntry(let x) = binding { return x } else { return nil } }) }
	public static var keyboardAppearance: BindingParser<Dynamic<UIKeyboardAppearance>, Binding> { return BindingParser<Dynamic<UIKeyboardAppearance>, Binding>(parse: { binding -> Optional<Dynamic<UIKeyboardAppearance>> in if case .keyboardAppearance(let x) = binding { return x } else { return nil } }) }
	public static var keyboardType: BindingParser<Dynamic<UIKeyboardType>, Binding> { return BindingParser<Dynamic<UIKeyboardType>, Binding>(parse: { binding -> Optional<Dynamic<UIKeyboardType>> in if case .keyboardType(let x) = binding { return x } else { return nil } }) }
	public static var returnKeyType: BindingParser<Dynamic<UIReturnKeyType>, Binding> { return BindingParser<Dynamic<UIReturnKeyType>, Binding>(parse: { binding -> Optional<Dynamic<UIReturnKeyType>> in if case .returnKeyType(let x) = binding { return x } else { return nil } }) }
	public static var smartDashesType: BindingParser<Dynamic<UITextSmartDashesType>, Binding> { return BindingParser<Dynamic<UITextSmartDashesType>, Binding>(parse: { binding -> Optional<Dynamic<UITextSmartDashesType>> in if case .smartDashesType(let x) = binding { return x } else { return nil } }) }
	public static var smartInsertDeleteType: BindingParser<Dynamic<UITextSmartInsertDeleteType>, Binding> { return BindingParser<Dynamic<UITextSmartInsertDeleteType>, Binding>(parse: { binding -> Optional<Dynamic<UITextSmartInsertDeleteType>> in if case .smartInsertDeleteType(let x) = binding { return x } else { return nil } }) }
	public static var smartQuotesType: BindingParser<Dynamic<UITextSmartQuotesType>, Binding> { return BindingParser<Dynamic<UITextSmartQuotesType>, Binding>(parse: { binding -> Optional<Dynamic<UITextSmartQuotesType>> in if case .smartQuotesType(let x) = binding { return x } else { return nil } }) }
	public static var spellCheckingType: BindingParser<Dynamic<UITextSpellCheckingType>, Binding> { return BindingParser<Dynamic<UITextSpellCheckingType>, Binding>(parse: { binding -> Optional<Dynamic<UITextSpellCheckingType>> in if case .spellCheckingType(let x) = binding { return x } else { return nil } }) }
	public static var textContentType: BindingParser<Dynamic<UITextContentType>, Binding> { return BindingParser<Dynamic<UITextContentType>, Binding>(parse: { binding -> Optional<Dynamic<UITextContentType>> in if case .textContentType(let x) = binding { return x } else { return nil } }) }
}

#endif
