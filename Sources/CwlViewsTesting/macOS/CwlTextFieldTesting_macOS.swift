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

extension BindingParser where Binding == TextField.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsCharacterPickerTouchBarItem: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsCharacterPickerTouchBarItem(let x) = binding { return x } else { return nil } }) }
	public static var allowsDefaultTighteningForTruncation: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsDefaultTighteningForTruncation(let x) = binding { return x } else { return nil } }) }
	public static var allowsEditingTextAttributes: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsEditingTextAttributes(let x) = binding { return x } else { return nil } }) }
	public static var allowsUndo: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsUndo(let x) = binding { return x } else { return nil } }) }
	public static var backgroundColor: BindingParser<Dynamic<NSColor?>, Binding> { return BindingParser<Dynamic<NSColor?>, Binding>(parse: { binding -> Optional<Dynamic<NSColor?>> in if case .backgroundColor(let x) = binding { return x } else { return nil } }) }
	public static var bezelStyle: BindingParser<Dynamic<NSTextField.BezelStyle>, Binding> { return BindingParser<Dynamic<NSTextField.BezelStyle>, Binding>(parse: { binding -> Optional<Dynamic<NSTextField.BezelStyle>> in if case .bezelStyle(let x) = binding { return x } else { return nil } }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .drawsBackground(let x) = binding { return x } else { return nil } }) }
	public static var importsGraphics: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .importsGraphics(let x) = binding { return x } else { return nil } }) }
	public static var isAutomaticTextCompletionEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isAutomaticTextCompletionEnabled(let x) = binding { return x } else { return nil } }) }
	public static var isBezeled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isBezeled(let x) = binding { return x } else { return nil } }) }
	public static var isBordered: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isBordered(let x) = binding { return x } else { return nil } }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEditable(let x) = binding { return x } else { return nil } }) }
	public static var isSelectable: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isSelectable(let x) = binding { return x } else { return nil } }) }
	public static var maximumNumberOfLines: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .maximumNumberOfLines(let x) = binding { return x } else { return nil } }) }
	public static var placeholderAttributedString: BindingParser<Dynamic<NSAttributedString?>, Binding> { return BindingParser<Dynamic<NSAttributedString?>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString?>> in if case .placeholderAttributedString(let x) = binding { return x } else { return nil } }) }
	public static var placeholderString: BindingParser<Dynamic<String?>, Binding> { return BindingParser<Dynamic<String?>, Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .placeholderString(let x) = binding { return x } else { return nil } }) }
	public static var preferredMaxLayoutWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .preferredMaxLayoutWidth(let x) = binding { return x } else { return nil } }) }
	public static var sendsActionOnEndEditing: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .sendsActionOnEndEditing(let x) = binding { return x } else { return nil } }) }
	public static var textColor: BindingParser<Dynamic<NSColor?>, Binding> { return BindingParser<Dynamic<NSColor?>, Binding>(parse: { binding -> Optional<Dynamic<NSColor?>> in if case .textColor(let x) = binding { return x } else { return nil } }) }
	public static var usesSingleLineMode: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .usesSingleLineMode(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var selectText: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .selectText(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var completions: BindingParser<(_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String], Binding> { return BindingParser<(_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String], Binding>(parse: { binding -> Optional<(_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String]> in if case .completions(let x) = binding { return x } else { return nil } }) }
	public static var didFailToFormatString: BindingParser<(_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool, Binding> { return BindingParser<(_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool, Binding>(parse: { binding -> Optional<(_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool> in if case .didFailToFormatString(let x) = binding { return x } else { return nil } }) }
	public static var didFailToValidatePartialString: BindingParser<(_ control: NSTextField, _ partialString: String, _ errorDescription: String?) -> Void, Binding> { return BindingParser<(_ control: NSTextField, _ partialString: String, _ errorDescription: String?) -> Void, Binding>(parse: { binding -> Optional<(_ control: NSTextField, _ partialString: String, _ errorDescription: String?) -> Void> in if case .didFailToValidatePartialString(let x) = binding { return x } else { return nil } }) }
	public static var doCommand: BindingParser<(_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool, Binding> { return BindingParser<(_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool, Binding>(parse: { binding -> Optional<(_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool> in if case .doCommand(let x) = binding { return x } else { return nil } }) }
	public static var isValidObject: BindingParser<(_ control: NSTextField, _ object: AnyObject) -> Bool, Binding> { return BindingParser<(_ control: NSTextField, _ object: AnyObject) -> Bool, Binding>(parse: { binding -> Optional<(_ control: NSTextField, _ object: AnyObject) -> Bool> in if case .isValidObject(let x) = binding { return x } else { return nil } }) }
	public static var shouldBeginEditing: BindingParser<(_ control: NSTextField, _ text: NSText) -> Bool, Binding> { return BindingParser<(_ control: NSTextField, _ text: NSText) -> Bool, Binding>(parse: { binding -> Optional<(_ control: NSTextField, _ text: NSText) -> Bool> in if case .shouldBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var shouldEndEditing: BindingParser<(_ control: NSTextField, _ text: NSText) -> Bool, Binding> { return BindingParser<(_ control: NSTextField, _ text: NSText) -> Bool, Binding>(parse: { binding -> Optional<(_ control: NSTextField, _ text: NSText) -> Bool> in if case .shouldEndEditing(let x) = binding { return x } else { return nil } }) }
}

#endif
