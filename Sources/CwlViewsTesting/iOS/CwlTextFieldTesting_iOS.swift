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

extension BindingParser where Binding == TextField.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var textInputTraits: BindingParser<Constant<TextInputTraits>, Binding> { return BindingParser<Constant<TextInputTraits>, Binding>(parse: { binding -> Optional<Constant<TextInputTraits>> in if case .textInputTraits(let x) = binding { return x } else { return nil } }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var adjustsFontSizeToFitWidth: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .adjustsFontSizeToFitWidth(let x) = binding { return x } else { return nil } }) }
	public static var allowsEditingTextAttributes: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsEditingTextAttributes(let x) = binding { return x } else { return nil } }) }
	public static var attributedPlaceholder: BindingParser<Dynamic<NSAttributedString?>, Binding> { return BindingParser<Dynamic<NSAttributedString?>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString?>> in if case .attributedPlaceholder(let x) = binding { return x } else { return nil } }) }
	public static var attributedText: BindingParser<Dynamic<NSAttributedString?>, Binding> { return BindingParser<Dynamic<NSAttributedString?>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString?>> in if case .attributedText(let x) = binding { return x } else { return nil } }) }
	public static var background: BindingParser<Dynamic<UIImage?>, Binding> { return BindingParser<Dynamic<UIImage?>, Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .background(let x) = binding { return x } else { return nil } }) }
	public static var borderStyle: BindingParser<Dynamic<UITextField.BorderStyle>, Binding> { return BindingParser<Dynamic<UITextField.BorderStyle>, Binding>(parse: { binding -> Optional<Dynamic<UITextField.BorderStyle>> in if case .borderStyle(let x) = binding { return x } else { return nil } }) }
	public static var clearButtonMode: BindingParser<Dynamic<UITextField.ViewMode>, Binding> { return BindingParser<Dynamic<UITextField.ViewMode>, Binding>(parse: { binding -> Optional<Dynamic<UITextField.ViewMode>> in if case .clearButtonMode(let x) = binding { return x } else { return nil } }) }
	public static var clearsOnBeginEditing: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .clearsOnBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var clearsOnInsertion: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .clearsOnInsertion(let x) = binding { return x } else { return nil } }) }
	public static var defaultTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding>(parse: { binding -> Optional<Dynamic<[NSAttributedString.Key: Any]>> in if case .defaultTextAttributes(let x) = binding { return x } else { return nil } }) }
	public static var disabledBackground: BindingParser<Dynamic<UIImage?>, Binding> { return BindingParser<Dynamic<UIImage?>, Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .disabledBackground(let x) = binding { return x } else { return nil } }) }
	public static var font: BindingParser<Dynamic<UIFont?>, Binding> { return BindingParser<Dynamic<UIFont?>, Binding>(parse: { binding -> Optional<Dynamic<UIFont?>> in if case .font(let x) = binding { return x } else { return nil } }) }
	public static var inputAccessoryView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .inputAccessoryView(let x) = binding { return x } else { return nil } }) }
	public static var inputView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .inputView(let x) = binding { return x } else { return nil } }) }
	public static var leftView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .leftView(let x) = binding { return x } else { return nil } }) }
	public static var leftViewMode: BindingParser<Dynamic<UITextField.ViewMode>, Binding> { return BindingParser<Dynamic<UITextField.ViewMode>, Binding>(parse: { binding -> Optional<Dynamic<UITextField.ViewMode>> in if case .leftViewMode(let x) = binding { return x } else { return nil } }) }
	public static var minimumFontSize: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .minimumFontSize(let x) = binding { return x } else { return nil } }) }
	public static var placeholder: BindingParser<Dynamic<String?>, Binding> { return BindingParser<Dynamic<String?>, Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .placeholder(let x) = binding { return x } else { return nil } }) }
	public static var rightView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .rightView(let x) = binding { return x } else { return nil } }) }
	public static var rightViewMode: BindingParser<Dynamic<UITextField.ViewMode>, Binding> { return BindingParser<Dynamic<UITextField.ViewMode>, Binding>(parse: { binding -> Optional<Dynamic<UITextField.ViewMode>> in if case .rightViewMode(let x) = binding { return x } else { return nil } }) }
	public static var text: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .text(let x) = binding { return x } else { return nil } }) }
	public static var textAlignment: BindingParser<Dynamic<NSTextAlignment>, Binding> { return BindingParser<Dynamic<NSTextAlignment>, Binding>(parse: { binding -> Optional<Dynamic<NSTextAlignment>> in if case .textAlignment(let x) = binding { return x } else { return nil } }) }
	public static var textColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .textColor(let x) = binding { return x } else { return nil } }) }
	public static var typingAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]?>, Binding> { return BindingParser<Dynamic<[NSAttributedString.Key: Any]?>, Binding>(parse: { binding -> Optional<Dynamic<[NSAttributedString.Key: Any]?>> in if case .typingAttributes(let x) = binding { return x } else { return nil } }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var resignFirstResponder: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .resignFirstResponder(let x) = binding { return x } else { return nil } }) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didBeginEditing: BindingParser<(_ textField: UITextField) -> Void, Binding> { return BindingParser<(_ textField: UITextField) -> Void, Binding>(parse: { binding -> Optional<(_ textField: UITextField) -> Void> in if case .didBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var didChange: BindingParser<(_ textField: UITextField) -> Void, Binding> { return BindingParser<(_ textField: UITextField) -> Void, Binding>(parse: { binding -> Optional<(_ textField: UITextField) -> Void> in if case .didChange(let x) = binding { return x } else { return nil } }) }
	public static var didEndEditing: BindingParser<(_ textField: UITextField) -> Void, Binding> { return BindingParser<(_ textField: UITextField) -> Void, Binding>(parse: { binding -> Optional<(_ textField: UITextField) -> Void> in if case .didEndEditing(let x) = binding { return x } else { return nil } }) }
	public static var didEndEditingWithReason: BindingParser<(_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void, Binding> { return BindingParser<(_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void, Binding>(parse: { binding -> Optional<(_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void> in if case .didEndEditingWithReason(let x) = binding { return x } else { return nil } }) }
	public static var shouldBeginEditing: BindingParser<(_ textField: UITextField) -> Bool, Binding> { return BindingParser<(_ textField: UITextField) -> Bool, Binding>(parse: { binding -> Optional<(_ textField: UITextField) -> Bool> in if case .shouldBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var shouldChangeCharacters: BindingParser<(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool, Binding> { return BindingParser<(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool, Binding>(parse: { binding -> Optional<(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool> in if case .shouldChangeCharacters(let x) = binding { return x } else { return nil } }) }
	public static var shouldClear: BindingParser<(_ textField: UITextField) -> Bool, Binding> { return BindingParser<(_ textField: UITextField) -> Bool, Binding>(parse: { binding -> Optional<(_ textField: UITextField) -> Bool> in if case .shouldClear(let x) = binding { return x } else { return nil } }) }
	public static var shouldEndEditing: BindingParser<(_ textField: UITextField) -> Bool, Binding> { return BindingParser<(_ textField: UITextField) -> Bool, Binding>(parse: { binding -> Optional<(_ textField: UITextField) -> Bool> in if case .shouldEndEditing(let x) = binding { return x } else { return nil } }) }
	public static var shouldReturn: BindingParser<(_ textField: UITextField) -> Bool, Binding> { return BindingParser<(_ textField: UITextField) -> Bool, Binding>(parse: { binding -> Optional<(_ textField: UITextField) -> Bool> in if case .shouldReturn(let x) = binding { return x } else { return nil } }) }
}

#endif
