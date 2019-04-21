//
//  TextView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/27.
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

extension BindingParser where Binding == TextView.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var textInputTraits: BindingParser<Constant<TextInputTraits>, Binding> { return BindingParser<Constant<TextInputTraits>, Binding>(parse: { binding -> Optional<Constant<TextInputTraits>> in if case .textInputTraits(let x) = binding { return x } else { return nil } }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsEditingTextAttributes: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsEditingTextAttributes(let x) = binding { return x } else { return nil } }) }
	public static var attributedText: BindingParser<Dynamic<NSAttributedString>, Binding> { return BindingParser<Dynamic<NSAttributedString>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString>> in if case .attributedText(let x) = binding { return x } else { return nil } }) }
	public static var clearsOnInsertion: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .clearsOnInsertion(let x) = binding { return x } else { return nil } }) }
	public static var dataDetectorTypes: BindingParser<Dynamic<UIDataDetectorTypes>, Binding> { return BindingParser<Dynamic<UIDataDetectorTypes>, Binding>(parse: { binding -> Optional<Dynamic<UIDataDetectorTypes>> in if case .dataDetectorTypes(let x) = binding { return x } else { return nil } }) }
	public static var font: BindingParser<Dynamic<UIFont?>, Binding> { return BindingParser<Dynamic<UIFont?>, Binding>(parse: { binding -> Optional<Dynamic<UIFont?>> in if case .font(let x) = binding { return x } else { return nil } }) }
	public static var inputAccessoryView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .inputAccessoryView(let x) = binding { return x } else { return nil } }) }
	public static var inputView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .inputView(let x) = binding { return x } else { return nil } }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEditable(let x) = binding { return x } else { return nil } }) }
	public static var isSelectable: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isSelectable(let x) = binding { return x } else { return nil } }) }
	public static var linkTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding>(parse: { binding -> Optional<Dynamic<[NSAttributedString.Key: Any]>> in if case .linkTextAttributes(let x) = binding { return x } else { return nil } }) }
	public static var selectedRange: BindingParser<Dynamic<NSRange>, Binding> { return BindingParser<Dynamic<NSRange>, Binding>(parse: { binding -> Optional<Dynamic<NSRange>> in if case .selectedRange(let x) = binding { return x } else { return nil } }) }
	public static var text: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .text(let x) = binding { return x } else { return nil } }) }
	public static var textAlignment: BindingParser<Dynamic<NSTextAlignment>, Binding> { return BindingParser<Dynamic<NSTextAlignment>, Binding>(parse: { binding -> Optional<Dynamic<NSTextAlignment>> in if case .textAlignment(let x) = binding { return x } else { return nil } }) }
	public static var textColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .textColor(let x) = binding { return x } else { return nil } }) }
	public static var textContainerInset: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .textContainerInset(let x) = binding { return x } else { return nil } }) }
	public static var typingAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingParser<Dynamic<[NSAttributedString.Key: Any]>, Binding>(parse: { binding -> Optional<Dynamic<[NSAttributedString.Key: Any]>> in if case .typingAttributes(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var scrollRangeToVisible: BindingParser<Signal<NSRange>, Binding> { return BindingParser<Signal<NSRange>, Binding>(parse: { binding -> Optional<Signal<NSRange>> in if case .scrollRangeToVisible(let x) = binding { return x } else { return nil } }) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didBeginEditing: BindingParser<(UITextView) -> Void, Binding> { return BindingParser<(UITextView) -> Void, Binding>(parse: { binding -> Optional<(UITextView) -> Void> in if case .didBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var didChange: BindingParser<(UITextView) -> Void, Binding> { return BindingParser<(UITextView) -> Void, Binding>(parse: { binding -> Optional<(UITextView) -> Void> in if case .didChange(let x) = binding { return x } else { return nil } }) }
	public static var didChangeSelection: BindingParser<(UITextView) -> Void, Binding> { return BindingParser<(UITextView) -> Void, Binding>(parse: { binding -> Optional<(UITextView) -> Void> in if case .didChangeSelection(let x) = binding { return x } else { return nil } }) }
	public static var didEndEditing: BindingParser<(UITextView) -> Void, Binding> { return BindingParser<(UITextView) -> Void, Binding>(parse: { binding -> Optional<(UITextView) -> Void> in if case .didEndEditing(let x) = binding { return x } else { return nil } }) }
	public static var shouldBeginEditing: BindingParser<(UITextView) -> Bool, Binding> { return BindingParser<(UITextView) -> Bool, Binding>(parse: { binding -> Optional<(UITextView) -> Bool> in if case .shouldBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var shouldChangeText: BindingParser<(UITextView, NSRange, String) -> Bool, Binding> { return BindingParser<(UITextView, NSRange, String) -> Bool, Binding>(parse: { binding -> Optional<(UITextView, NSRange, String) -> Bool> in if case .shouldChangeText(let x) = binding { return x } else { return nil } }) }
	public static var shouldEndEditing: BindingParser<(UITextView) -> Bool, Binding> { return BindingParser<(UITextView) -> Bool, Binding>(parse: { binding -> Optional<(UITextView) -> Bool> in if case .shouldEndEditing(let x) = binding { return x } else { return nil } }) }
	public static var shouldInteractWithAttachment: BindingParser<(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool, Binding> { return BindingParser<(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool, Binding>(parse: { binding -> Optional<(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool> in if case .shouldInteractWithAttachment(let x) = binding { return x } else { return nil } }) }
	public static var shouldInteractWithURL: BindingParser<(UITextView, URL, NSRange, UITextItemInteraction) -> Bool, Binding> { return BindingParser<(UITextView, URL, NSRange, UITextItemInteraction) -> Bool, Binding>(parse: { binding -> Optional<(UITextView, URL, NSRange, UITextItemInteraction) -> Bool> in if case .shouldInteractWithURL(let x) = binding { return x } else { return nil } }) }
}

#endif
