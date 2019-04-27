//
//  CwlTextField_iOS.swift
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

extension BindingParser where Downcast: TextFieldBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TextField.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTextFieldBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var textInputTraits: BindingParser<Constant<TextInputTraits>, TextField.Binding, Downcast> { return .init(extract: { if case .textInputTraits(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var adjustsFontSizeToFitWidth: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .adjustsFontSizeToFitWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var allowsEditingTextAttributes: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .allowsEditingTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var attributedPlaceholder: BindingParser<Dynamic<NSAttributedString?>, TextField.Binding, Downcast> { return .init(extract: { if case .attributedPlaceholder(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var attributedText: BindingParser<Dynamic<NSAttributedString?>, TextField.Binding, Downcast> { return .init(extract: { if case .attributedText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var background: BindingParser<Dynamic<UIImage?>, TextField.Binding, Downcast> { return .init(extract: { if case .background(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var borderStyle: BindingParser<Dynamic<UITextField.BorderStyle>, TextField.Binding, Downcast> { return .init(extract: { if case .borderStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var clearButtonMode: BindingParser<Dynamic<UITextField.ViewMode>, TextField.Binding, Downcast> { return .init(extract: { if case .clearButtonMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var clearsOnBeginEditing: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .clearsOnBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var clearsOnInsertion: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .clearsOnInsertion(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var defaultTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, TextField.Binding, Downcast> { return .init(extract: { if case .defaultTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var disabledBackground: BindingParser<Dynamic<UIImage?>, TextField.Binding, Downcast> { return .init(extract: { if case .disabledBackground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var font: BindingParser<Dynamic<UIFont?>, TextField.Binding, Downcast> { return .init(extract: { if case .font(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var inputAccessoryView: BindingParser<Dynamic<ViewConvertible?>, TextField.Binding, Downcast> { return .init(extract: { if case .inputAccessoryView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var inputView: BindingParser<Dynamic<ViewConvertible?>, TextField.Binding, Downcast> { return .init(extract: { if case .inputView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var leftView: BindingParser<Dynamic<ViewConvertible?>, TextField.Binding, Downcast> { return .init(extract: { if case .leftView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var leftViewMode: BindingParser<Dynamic<UITextField.ViewMode>, TextField.Binding, Downcast> { return .init(extract: { if case .leftViewMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var minimumFontSize: BindingParser<Dynamic<CGFloat>, TextField.Binding, Downcast> { return .init(extract: { if case .minimumFontSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var placeholder: BindingParser<Dynamic<String?>, TextField.Binding, Downcast> { return .init(extract: { if case .placeholder(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var rightView: BindingParser<Dynamic<ViewConvertible?>, TextField.Binding, Downcast> { return .init(extract: { if case .rightView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var rightViewMode: BindingParser<Dynamic<UITextField.ViewMode>, TextField.Binding, Downcast> { return .init(extract: { if case .rightViewMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var text: BindingParser<Dynamic<String>, TextField.Binding, Downcast> { return .init(extract: { if case .text(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var textAlignment: BindingParser<Dynamic<NSTextAlignment>, TextField.Binding, Downcast> { return .init(extract: { if case .textAlignment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var textColor: BindingParser<Dynamic<UIColor?>, TextField.Binding, Downcast> { return .init(extract: { if case .textColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var typingAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]?>, TextField.Binding, Downcast> { return .init(extract: { if case .typingAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var resignFirstResponder: BindingParser<Signal<Void>, TextField.Binding, Downcast> { return .init(extract: { if case .resignFirstResponder(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didBeginEditing: BindingParser<(_ textField: UITextField) -> Void, TextField.Binding, Downcast> { return .init(extract: { if case .didBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var didChange: BindingParser<(_ textField: UITextField) -> Void, TextField.Binding, Downcast> { return .init(extract: { if case .didChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var didEndEditing: BindingParser<(_ textField: UITextField) -> Void, TextField.Binding, Downcast> { return .init(extract: { if case .didEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var didEndEditingWithReason: BindingParser<(_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void, TextField.Binding, Downcast> { return .init(extract: { if case .didEndEditingWithReason(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var shouldBeginEditing: BindingParser<(_ textField: UITextField) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .shouldBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var shouldChangeCharacters: BindingParser<(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .shouldChangeCharacters(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var shouldClear: BindingParser<(_ textField: UITextField) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .shouldClear(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var shouldEndEditing: BindingParser<(_ textField: UITextField) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .shouldEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var shouldReturn: BindingParser<(_ textField: UITextField) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .shouldReturn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
}

#endif
