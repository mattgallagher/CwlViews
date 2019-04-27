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

// MARK: - Binder Part 1: Binder
public class TextField: Binder, TextFieldConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}

	public static var labelBindings: [Binding] {
		return [
			.isEditable -- false,
			.isSelectable -- true,
			.isBordered -- false,
			.drawsBackground -- false
		]
	}
	
	public static var wrappingLabelBindings: [Binding] {
		return [
			.isEditable -- false,
			.isSelectable -- true,
			.isBordered -- false,
			.drawsBackground -- false,
			.lineBreakMode -- .byWordWrapping,
			.horizontalContentCompressionResistancePriority -- .defaultLow
		]
	}
	
	public static func label(type: Instance.Type = Instance.self, _ bindings: Binding...) -> TextField {
		return TextField(type: type, parameters: (), bindings: TextField.labelBindings + bindings)
	}
	
	public static func wrappingLabel(type: Instance.Type = Instance.self, _ bindings: Binding...) -> TextField {
		return TextField(type: type, parameters: (), bindings: TextField.wrappingLabelBindings + bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TextField {
	enum Binding: TextFieldBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case allowsCharacterPickerTouchBarItem(Dynamic<Bool>)
		case allowsDefaultTighteningForTruncation(Dynamic<Bool>)
		case allowsEditingTextAttributes(Dynamic<Bool>)
		case allowsUndo(Dynamic<Bool>)
		case backgroundColor(Dynamic<NSColor?>)
		case bezelStyle(Dynamic<NSTextField.BezelStyle>)
		case drawsBackground(Dynamic<Bool>)
		case importsGraphics(Dynamic<Bool>)
		case isAutomaticTextCompletionEnabled(Dynamic<Bool>)
		case isBezeled(Dynamic<Bool>)
		case isBordered(Dynamic<Bool>)
		case isEditable(Dynamic<Bool>)
		case isSelectable(Dynamic<Bool>)
		case maximumNumberOfLines(Dynamic<Int>)
		case placeholderAttributedString(Dynamic<NSAttributedString?>)
		case placeholderString(Dynamic<String?>)
		case preferredMaxLayoutWidth(Dynamic<CGFloat>)
		case sendsActionOnEndEditing(Dynamic<Bool>)
		case textColor(Dynamic<NSColor?>)
		case usesSingleLineMode(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case selectText(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case completions((_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String])
		case didFailToFormatString((_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool)
		case didFailToValidatePartialString((_ control: NSTextField, _ partialString: String, _ errorDescription: String?) -> Void)
		case doCommand((_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool)
		case isValidObject((_ control: NSTextField, _ object: AnyObject) -> Bool)
		case shouldBeginEditing((_ control: NSTextField, _ text: NSText) -> Bool)
		case shouldEndEditing((_ control: NSTextField, _ text: NSText) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TextField {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TextField.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSTextField
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TextField.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .completions(let x): delegate().addSingleHandler5(x, #selector(NSTextFieldDelegate.control(_:textView:completions:forPartialWordRange:indexOfSelectedItem:)))
		case .didFailToFormatString(let x): delegate().addSingleHandler3(x, #selector(NSTextFieldDelegate.control(_:didFailToFormatString:errorDescription:)))
		case .didFailToValidatePartialString(let x): delegate().addMultiHandler3(x, #selector(NSTextFieldDelegate.control(_:didFailToValidatePartialString:errorDescription:)))
		case .doCommand(let x): delegate().addSingleHandler3(x, #selector(NSTextFieldDelegate.control(_:textView:doCommandBy:)))
		case .isValidObject(let x): delegate().addSingleHandler2(x, #selector(NSTextFieldDelegate.control(_:isValidObject:)))
		case .shouldBeginEditing(let x): delegate().addSingleHandler2(x, #selector(NSTextFieldDelegate.control(_:textShouldBeginEditing:)))
		case .shouldEndEditing(let x): delegate().addSingleHandler2(x, #selector(NSTextFieldDelegate.control(_:textShouldEndEditing:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .allowsCharacterPickerTouchBarItem(let x): return x.apply(instance) { i, v in i.allowsCharacterPickerTouchBarItem = v }
		case .allowsDefaultTighteningForTruncation(let x): return x.apply(instance) { i, v in i.allowsDefaultTighteningForTruncation = v }
		case .allowsEditingTextAttributes(let x): return x.apply(instance) { i, v in i.allowsEditingTextAttributes = v }
		case .allowsUndo(let x): return x.apply(instance) { i, v in i.cell?.allowsUndo = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .isBezeled(let x): return x.apply(instance) { i, v in i.isBezeled = v }
		case .bezelStyle(let x): return x.apply(instance) { i, v in i.bezelStyle = v }
		case .drawsBackground(let x): return x.apply(instance) { i, v in i.drawsBackground = v }
		case .importsGraphics(let x): return x.apply(instance) { i, v in i.importsGraphics = v }
		case .isAutomaticTextCompletionEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticTextCompletionEnabled = v }
		case .isBordered(let x): return x.apply(instance) { i, v in i.isBordered = v }
		case .isEditable(let x): return x.apply(instance) { i, v in i.isEditable = v }
		case .isSelectable(let x): return x.apply(instance) { i, v in i.isSelectable = v }
		case .maximumNumberOfLines(let x): return x.apply(instance) { i, v in i.maximumNumberOfLines = v }
		case .placeholderAttributedString(let x): return x.apply(instance) { i, v in i.placeholderAttributedString = v }
		case .placeholderString(let x): return x.apply(instance) { i, v in i.placeholderString = v }
		case .preferredMaxLayoutWidth(let x): return x.apply(instance) { i, v in i.preferredMaxLayoutWidth = v }
		case .sendsActionOnEndEditing(let x): return x.apply(instance) { i, v in i.cell?.sendsActionOnEndEditing = v }
		case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
		case .usesSingleLineMode(let x): return x.apply(instance) { i, v in i.usesSingleLineMode = v }

		// 2. Signal bindings are performed on the object after construction.
		case .selectText(let x): return x.apply(instance) { i, v in i.selectText(nil) }

		// 3. Action bindings are triggered by the object after construction.
		case .didFailToValidatePartialString: return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .completions: return nil
		case .didFailToFormatString: return nil
		case .doCommand: return nil
		case .isValidObject: return nil
		case .shouldBeginEditing: return nil
		case .shouldEndEditing: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TextField.Preparer {
	open class Storage: Control.Preparer.Storage, NSTextFieldDelegate {}

	open class Delegate: DynamicDelegate, NSTextFieldDelegate {
		open func control(_ control: NSControl, isValidObject obj: Any?) -> Bool {
			return singleHandler(control as! NSTextField, obj as AnyObject)
		}
		
		open func control(_ control: NSControl, didFailToValidatePartialString string: String, errorDescription error: String?) {
			multiHandler(control, string, error)
		}
		
		open func control(_ control: NSControl, didFailToFormatString string: String, errorDescription error: String?) -> Bool {
			return singleHandler(control as! NSTextField, string, error)
		}
		
		open func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
			return singleHandler(control as! NSTextField, fieldEditor)
		}
		
		open func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
			return singleHandler(control as! NSTextField, fieldEditor)
		}
		
		open func control(_ control: NSControl, textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String] {
			return singleHandler(control as! NSTextField, textView, words, charRange, index)
		}
		
		open func control(_ control: NSControl, textView: NSTextView, doCommandBy doCommandBySelector: Selector) -> Bool {
			return singleHandler(control as! NSTextField, textView, doCommandBySelector)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TextFieldBinding {
	public typealias TextFieldName<V> = BindingName<V, TextField.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> TextField.Binding) -> TextFieldName<V> {
		return TextFieldName<V>(source: source, downcast: Binding.textFieldBinding)
	}
}
public extension BindingName where Binding: TextFieldBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TextFieldName<$2> { return .name(TextField.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var allowsCharacterPickerTouchBarItem: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.allowsCharacterPickerTouchBarItem) }
	static var allowsDefaultTighteningForTruncation: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.allowsDefaultTighteningForTruncation) }
	static var allowsEditingTextAttributes: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.allowsEditingTextAttributes) }
	static var allowsUndo: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.allowsUndo) }
	static var backgroundColor: TextFieldName<Dynamic<NSColor?>> { return .name(TextField.Binding.backgroundColor) }
	static var isBezeled: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.isBezeled) }
	static var bezelStyle: TextFieldName<Dynamic<NSTextField.BezelStyle>> { return .name(TextField.Binding.bezelStyle) }
	static var drawsBackground: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.drawsBackground) }
	static var importsGraphics: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.importsGraphics) }
	static var isAutomaticTextCompletionEnabled: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.isAutomaticTextCompletionEnabled) }
	static var isBordered: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.isBordered) }
	static var isEditable: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.isEditable) }
	static var isSelectable: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.isSelectable) }
	static var maximumNumberOfLines: TextFieldName<Dynamic<Int>> { return .name(TextField.Binding.maximumNumberOfLines) }
	static var placeholderAttributedString: TextFieldName<Dynamic<NSAttributedString?>> { return .name(TextField.Binding.placeholderAttributedString) }
	static var placeholderString: TextFieldName<Dynamic<String?>> { return .name(TextField.Binding.placeholderString) }
	static var preferredMaxLayoutWidth: TextFieldName<Dynamic<CGFloat>> { return .name(TextField.Binding.preferredMaxLayoutWidth) }
	static var sendsActionOnEndEditing: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.sendsActionOnEndEditing) }
	static var textColor: TextFieldName<Dynamic<NSColor?>> { return .name(TextField.Binding.textColor) }
	static var usesSingleLineMode: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.usesSingleLineMode) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var selectText: TextFieldName<Signal<Void>> { return .name(TextField.Binding.selectText) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var completions: TextFieldName<(_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String]> { return .name(TextField.Binding.completions) }
	static var didFailToFormatString: TextFieldName<(_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool> { return .name(TextField.Binding.didFailToFormatString) }
	static var didFailToValidatePartialString: TextFieldName<(_ control: NSTextField, _ partialString: String, _ errorDescription: String?) -> Void> { return .name(TextField.Binding.didFailToValidatePartialString) }
	static var doCommand: TextFieldName<(_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool> { return .name(TextField.Binding.doCommand) }
	static var isValidObject: TextFieldName<(_ control: NSTextField, _ object: AnyObject) -> Bool> { return .name(TextField.Binding.isValidObject) }
	static var shouldBeginEditing: TextFieldName<(_ control: NSTextField, _ text: NSText) -> Bool> { return .name(TextField.Binding.shouldBeginEditing) }
	static var shouldEndEditing: TextFieldName<(_ control: NSTextField, _ text: NSText) -> Bool> { return .name(TextField.Binding.shouldEndEditing) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TextFieldConvertible: ControlConvertible {
	func nsTextField() -> TextField.Instance
}
extension TextFieldConvertible {
	public func nsControl() -> Control.Instance { return nsTextField() }
}
extension NSTextField: TextFieldConvertible, HasDelegate {
	public func nsTextField() -> TextField.Instance { return self }
}
public extension TextField {
	func nsTextField() -> TextField.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TextFieldBinding: ControlBinding {
	static func textFieldBinding(_ binding: TextField.Binding) -> Self
	func asTextFieldBinding() -> TextField.Binding?
}
public extension TextFieldBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return textFieldBinding(.inheritedBinding(binding))
	}
}
public extension TextFieldBinding where Preparer.Inherited.Binding: TextFieldBinding {
	func asTextFieldBinding() -> TextField.Binding? {
		return asInheritedBinding()?.asTextFieldBinding()
	}
}
public extension TextField.Binding {
	typealias Preparer = TextField.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asTextFieldBinding() -> TextField.Binding? { return self }
	static func textFieldBinding(_ binding: TextField.Binding) -> TextField.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
