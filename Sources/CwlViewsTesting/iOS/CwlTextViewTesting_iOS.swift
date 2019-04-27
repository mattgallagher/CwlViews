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

extension BindingParser where Downcast: TextViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TextView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTextViewBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var textInputTraits: BindingParser<Constant<TextInputTraits>, TextView.Binding, Downcast> { return .init(extract: { if case .textInputTraits(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsEditingTextAttributes: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .allowsEditingTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var attributedText: BindingParser<Dynamic<NSAttributedString>, TextView.Binding, Downcast> { return .init(extract: { if case .attributedText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var clearsOnInsertion: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .clearsOnInsertion(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var dataDetectorTypes: BindingParser<Dynamic<UIDataDetectorTypes>, TextView.Binding, Downcast> { return .init(extract: { if case .dataDetectorTypes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var font: BindingParser<Dynamic<UIFont?>, TextView.Binding, Downcast> { return .init(extract: { if case .font(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var inputAccessoryView: BindingParser<Dynamic<ViewConvertible?>, TextView.Binding, Downcast> { return .init(extract: { if case .inputAccessoryView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var inputView: BindingParser<Dynamic<ViewConvertible?>, TextView.Binding, Downcast> { return .init(extract: { if case .inputView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isEditable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isSelectable: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isSelectable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var linkTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, TextView.Binding, Downcast> { return .init(extract: { if case .linkTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var selectedRange: BindingParser<Dynamic<NSRange>, TextView.Binding, Downcast> { return .init(extract: { if case .selectedRange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var text: BindingParser<Dynamic<String>, TextView.Binding, Downcast> { return .init(extract: { if case .text(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var textAlignment: BindingParser<Dynamic<NSTextAlignment>, TextView.Binding, Downcast> { return .init(extract: { if case .textAlignment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var textColor: BindingParser<Dynamic<UIColor?>, TextView.Binding, Downcast> { return .init(extract: { if case .textColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var textContainerInset: BindingParser<Dynamic<UIEdgeInsets>, TextView.Binding, Downcast> { return .init(extract: { if case .textContainerInset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var typingAttributes: BindingParser<Dynamic<[NSAttributedString.Key: Any]>, TextView.Binding, Downcast> { return .init(extract: { if case .typingAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var scrollRangeToVisible: BindingParser<Signal<NSRange>, TextView.Binding, Downcast> { return .init(extract: { if case .scrollRangeToVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didBeginEditing: BindingParser<(UITextView) -> Void, TextView.Binding, Downcast> { return .init(extract: { if case .didBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var didChange: BindingParser<(UITextView) -> Void, TextView.Binding, Downcast> { return .init(extract: { if case .didChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var didChangeSelection: BindingParser<(UITextView) -> Void, TextView.Binding, Downcast> { return .init(extract: { if case .didChangeSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var didEndEditing: BindingParser<(UITextView) -> Void, TextView.Binding, Downcast> { return .init(extract: { if case .didEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var shouldBeginEditing: BindingParser<(UITextView) -> Bool, TextView.Binding, Downcast> { return .init(extract: { if case .shouldBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var shouldChangeText: BindingParser<(UITextView, NSRange, String) -> Bool, TextView.Binding, Downcast> { return .init(extract: { if case .shouldChangeText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var shouldEndEditing: BindingParser<(UITextView) -> Bool, TextView.Binding, Downcast> { return .init(extract: { if case .shouldEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var shouldInteractWithAttachment: BindingParser<(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool, TextView.Binding, Downcast> { return .init(extract: { if case .shouldInteractWithAttachment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var shouldInteractWithURL: BindingParser<(UITextView, URL, NSRange, UITextItemInteraction) -> Bool, TextView.Binding, Downcast> { return .init(extract: { if case .shouldInteractWithURL(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
}

#endif
