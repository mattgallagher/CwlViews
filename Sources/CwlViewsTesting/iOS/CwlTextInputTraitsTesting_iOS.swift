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

extension TextInputTraits.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0 }) }
	
	public static var autocapitalizationType: BindingParser<Dynamic<UITextAutocapitalizationType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .autocapitalizationType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var autocorrectionType: BindingParser<Dynamic<UITextAutocorrectionType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .autocorrectionType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var enablesReturnKeyAutomatically: BindingParser<Dynamic<Bool>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .enablesReturnKeyAutomatically(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var isSecureTextEntry: BindingParser<Dynamic<Bool>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .isSecureTextEntry(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var keyboardAppearance: BindingParser<Dynamic<UIKeyboardAppearance>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .keyboardAppearance(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var keyboardType: BindingParser<Dynamic<UIKeyboardType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .keyboardType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var returnKeyType: BindingParser<Dynamic<UIReturnKeyType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .returnKeyType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var smartDashesType: BindingParser<Dynamic<UITextSmartDashesType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .smartDashesType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var smartInsertDeleteType: BindingParser<Dynamic<UITextSmartInsertDeleteType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .smartInsertDeleteType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var smartQuotesType: BindingParser<Dynamic<UITextSmartQuotesType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .smartQuotesType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var spellCheckingType: BindingParser<Dynamic<UITextSpellCheckingType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .spellCheckingType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
	public static var textContentType: BindingParser<Dynamic<UITextContentType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .init(extract: { if case .textContentType(let x) = $0 { return x } else { return nil } }, upcast: { $0 }) }
}

#endif
