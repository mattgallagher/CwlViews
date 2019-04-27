//
//  CwlTextField_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 28/10/2015.
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

extension BindingParser where Downcast: TextFieldBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TextField.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTextFieldBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsCharacterPickerTouchBarItem: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .allowsCharacterPickerTouchBarItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var allowsDefaultTighteningForTruncation: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .allowsDefaultTighteningForTruncation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var allowsEditingTextAttributes: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .allowsEditingTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var allowsUndo: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .allowsUndo(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var backgroundColor: BindingParser<Dynamic<NSColor?>, TextField.Binding, Downcast> { return .init(extract: { if case .backgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var bezelStyle: BindingParser<Dynamic<NSTextField.BezelStyle>, TextField.Binding, Downcast> { return .init(extract: { if case .bezelStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .drawsBackground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var importsGraphics: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .importsGraphics(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var isAutomaticTextCompletionEnabled: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .isAutomaticTextCompletionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var isBezeled: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .isBezeled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var isBordered: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .isBordered(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .isEditable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var isSelectable: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .isSelectable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var maximumNumberOfLines: BindingParser<Dynamic<Int>, TextField.Binding, Downcast> { return .init(extract: { if case .maximumNumberOfLines(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var placeholderAttributedString: BindingParser<Dynamic<NSAttributedString?>, TextField.Binding, Downcast> { return .init(extract: { if case .placeholderAttributedString(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var placeholderString: BindingParser<Dynamic<String?>, TextField.Binding, Downcast> { return .init(extract: { if case .placeholderString(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var preferredMaxLayoutWidth: BindingParser<Dynamic<CGFloat>, TextField.Binding, Downcast> { return .init(extract: { if case .preferredMaxLayoutWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var sendsActionOnEndEditing: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .sendsActionOnEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var textColor: BindingParser<Dynamic<NSColor?>, TextField.Binding, Downcast> { return .init(extract: { if case .textColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var usesSingleLineMode: BindingParser<Dynamic<Bool>, TextField.Binding, Downcast> { return .init(extract: { if case .usesSingleLineMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var selectText: BindingParser<Signal<Void>, TextField.Binding, Downcast> { return .init(extract: { if case .selectText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var completions: BindingParser<(_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String], TextField.Binding, Downcast> { return .init(extract: { if case .completions(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var didFailToFormatString: BindingParser<(_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .didFailToFormatString(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var didFailToValidatePartialString: BindingParser<(_ control: NSTextField, _ partialString: String, _ errorDescription: String?) -> Void, TextField.Binding, Downcast> { return .init(extract: { if case .didFailToValidatePartialString(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var doCommand: BindingParser<(_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .doCommand(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var isValidObject: BindingParser<(_ control: NSTextField, _ object: AnyObject) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .isValidObject(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var shouldBeginEditing: BindingParser<(_ control: NSTextField, _ text: NSText) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .shouldBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
	public static var shouldEndEditing: BindingParser<(_ control: NSTextField, _ text: NSText) -> Bool, TextField.Binding, Downcast> { return .init(extract: { if case .shouldEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextFieldBinding() }) }
}

#endif
