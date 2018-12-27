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

public class TextField: Binder, TextFieldConvertible {
	public static var defaultLabelBindings: [Binding] {
		return [
			.isEditable -- false,
			.isBordered -- false,
			.drawsBackground -- false
		]
	}
	
	public typealias Instance = NSTextField
	public typealias Inherited = Control
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public convenience init(subclass: Instance.Type = Instance.self, labelStyled bindings: Binding...) {
		self.init(subclass: subclass, bindings: TextField.defaultLabelBindings + bindings)
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsTextField() -> Instance { return instance() }
	
	enum Binding: TextFieldBinding {
		public typealias EnclosingBinder = TextField
		public static func textFieldBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case isEditable(Dynamic<Bool>)
		case isSelectable(Dynamic<Bool>)
		case allowsEditingTextAttributes(Dynamic<Bool>)
		case importsGraphics(Dynamic<Bool>)
		case textColor(Dynamic<NSColor?>)
		case preferredMaxLayoutWidth(Dynamic<CGFloat>)
		case backgroundColor(Dynamic<NSColor?>)
		case drawsBackground(Dynamic<Bool>)
		case bezeled(Dynamic<Bool>)
		case bezelStyle(Dynamic<NSTextField.BezelStyle>)
		case isBordered(Dynamic<Bool>)
		case allowsUndo(Dynamic<Bool>)
		case sendsActionOnEndEditing(Dynamic<Bool>)
		case usesSingleLineMode(Dynamic<Bool>)
		@available(macOS 10.12.2, *)
		case allowsCharacterPickerTouchBarItem(Dynamic<Bool>)
		@available(macOS 10.11, *)
		case allowsDefaultTighteningForTruncation(Dynamic<Bool>)
		@available(macOS 10.12.2, *)
		case isAutomaticTextCompletionEnabled(Dynamic<Bool>)
		@available(macOS 10.11, *)
		case maximumNumberOfLines(Dynamic<Int>)
		case placeholderAttributedString(Dynamic<NSAttributedString?>)
		case placeholderString(Dynamic<String?>)

		// 2. Signal bindings are performed on the object after construction.
		case selectText(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.
		case stringAction(TargetAction)
		case didFailToValidatePartialString(SignalInput<(string: String, errorDescription: String?)>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didFailToFormatString((_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool)
		case isValidObject((_ control: NSTextField, _ object: AnyObject) -> Bool)
		case shouldBeginEditing((_ control: NSTextField, _ text: NSText) -> Bool)
		case shouldEndEditing((_ control: NSTextField, _ text: NSText) -> Bool)
		case completions((_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String])
		case doCommand((_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool)
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = TextField
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var possibleDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .didFailToFormatString(let x): delegate().addHandler(x, #selector(NSTextFieldDelegate.control(_:didFailToFormatString:errorDescription:)))
			case .isValidObject(let x): delegate().addHandler(x, #selector(NSTextFieldDelegate.control(_:isValidObject:)))
			case .shouldBeginEditing(let x): delegate().addHandler(x, #selector(NSTextFieldDelegate.control(_:textShouldBeginEditing:)))
			case .shouldEndEditing(let x): delegate().addHandler(x, #selector(NSTextFieldDelegate.control(_:textShouldEndEditing:)))
			case .didFailToValidatePartialString(let x): delegate().addHandler(x, #selector(NSTextFieldDelegate.control(_:didFailToValidatePartialString:errorDescription:)))
			case .completions(let x): delegate().addHandler(x, #selector(NSTextFieldDelegate.control(_:textView:completions:forPartialWordRange:indexOfSelectedItem:)))
			case .doCommand(let x): delegate().addHandler(x, #selector(NSTextFieldDelegate.control(_:textView:doCommandBy:)))
			case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
			default: break
			}
		}

		public func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			if storage.inUse {
				instance.delegate = storage
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .usesSingleLineMode(let x): return x.apply(instance) { i, v in i.usesSingleLineMode = v }
			case .allowsCharacterPickerTouchBarItem(let x):
				return x.apply(instance) { i, v in
					if #available(macOS 10.12.2, *) {
						i.allowsCharacterPickerTouchBarItem = v
					}
				}
			case .allowsDefaultTighteningForTruncation(let x):
				return x.apply(instance) { i, v in
					if #available(macOS 10.11, *) {
						i.allowsDefaultTighteningForTruncation = v
					}
				}
			case .isAutomaticTextCompletionEnabled(let x):
				return x.apply(instance) { i, v in
					if #available(macOS 10.12.2, *) {
						i.isAutomaticTextCompletionEnabled = v
					}
				}
			case .maximumNumberOfLines(let x):
				return x.apply(instance) { i, v in
					if #available(macOS 10.11, *) {
						i.maximumNumberOfLines = v
					}
				}
			case .placeholderAttributedString(let x): return x.apply(instance) { i, v in i.placeholderAttributedString = v }
			case .placeholderString(let x): return x.apply(instance) { i, v in i.placeholderString = v }
			case .sendsActionOnEndEditing(let x): return x.apply(instance) { i, v in i.cell?.sendsActionOnEndEditing = v }
			case .isEditable(let x): return x.apply(instance) { i, v in i.isEditable = v }
			case .isSelectable(let x): return x.apply(instance) { i, v in i.isSelectable = v }
			case .allowsEditingTextAttributes(let x): return x.apply(instance) { i, v in i.allowsEditingTextAttributes = v }
			case .importsGraphics(let x): return x.apply(instance) { i, v in i.importsGraphics = v }
			case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
			case .preferredMaxLayoutWidth(let x): return x.apply(instance) { i, v in i.preferredMaxLayoutWidth = v }
			case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
			case .drawsBackground(let x): return x.apply(instance) { i, v in i.drawsBackground = v }
			case .bezeled(let x): return x.apply(instance) { i, v in i.isBezeled = v }
			case .bezelStyle(let x): return x.apply(instance) { i, v in i.bezelStyle = v }
			case .isBordered(let x): return x.apply(instance) { i, v in i.isBordered = v }
			case .allowsUndo(let x): return x.apply(instance) { i, v in
				i.cell?.allowsUndo = v
				}
				
			case .selectText(let x): return x.apply(instance) { i, v in i.selectText(nil) }
			case .didFailToValidatePartialString: return nil
			case .doCommand: return nil
			case .didFailToFormatString: return nil
			case .isValidObject: return nil
			case .shouldBeginEditing: return nil
			case .shouldEndEditing: return nil
			case .completions: return nil
			case .stringAction(let x): return x.apply(instance: instance, constructTarget: SignalActionTarget.init, processor: { sender in (sender as? NSTextField)?.attributedStringValue ?? NSAttributedString() })
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: Control.Storage, NSTextFieldDelegate {}

	open class Delegate: DynamicDelegate, NSTextFieldDelegate {
		public required override init() {
			super.init()
		}
		
		open func control(_ control: NSControl, isValidObject obj: Any?) -> Bool {
			return handler(ofType: ((_ control: NSTextField, _ object: AnyObject) -> Bool).self)(control as! NSTextField, obj as AnyObject)
		}
		
		open func control(_ control: NSControl, didFailToValidatePartialString string: String, errorDescription error: String?) {
			handler(ofType: SignalInput<(string: String, errorDescription: String?)>.self).send((string: string, errorDescription: error))
		}
		
		open func control(_ control: NSControl, didFailToFormatString string: String, errorDescription error: String?) -> Bool {
			return handler(ofType: ((_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool).self)(control as! NSTextField, string, error)
		}
		
		open func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
			return handler(ofType: ((_ control: NSTextField, _ text: NSText) -> Bool).self)(control as! NSTextField, fieldEditor)
		}
		
		open func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
			return handler(ofType: ((_ control: NSTextField, _ text: NSText) -> Bool).self)(control as! NSTextField, fieldEditor)
		}
		
		open func control(_ control: NSControl, textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String] {
			return handler(ofType: ((_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String]).self)(control as! NSTextField, textView, words, charRange, index)
		}
		
		open func control(_ control: NSControl, textView: NSTextView, doCommandBy doCommandBySelector: Selector) -> Bool {
			return handler(ofType: ((_ control: NSTextField, _ textView: NSTextView, _ doCommandBySelector: Selector) -> Bool).self)(control as! NSTextField, textView, doCommandBySelector)
		}
	}
}

extension BindingName where Binding: TextFieldBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .textFieldBinding(TextField.Binding.$1(v)) }) }

	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var isEditable: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.isEditable(v)) }) }
	public static var isSelectable: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.isSelectable(v)) }) }
	public static var allowsEditingTextAttributes: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.allowsEditingTextAttributes(v)) }) }
	public static var importsGraphics: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.importsGraphics(v)) }) }
	public static var textColor: BindingName<Dynamic<NSColor?>, Binding> { return BindingName<Dynamic<NSColor?>, Binding>({ v in .textFieldBinding(TextField.Binding.textColor(v)) }) }
	public static var preferredMaxLayoutWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .textFieldBinding(TextField.Binding.preferredMaxLayoutWidth(v)) }) }
	public static var backgroundColor: BindingName<Dynamic<NSColor?>, Binding> { return BindingName<Dynamic<NSColor?>, Binding>({ v in .textFieldBinding(TextField.Binding.backgroundColor(v)) }) }
	public static var drawsBackground: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.drawsBackground(v)) }) }
	public static var bezeled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.bezeled(v)) }) }
	public static var bezelStyle: BindingName<Dynamic<NSTextField.BezelStyle>, Binding> { return BindingName<Dynamic<NSTextField.BezelStyle>, Binding>({ v in .textFieldBinding(TextField.Binding.bezelStyle(v)) }) }
	public static var isBordered: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.isBordered(v)) }) }
	public static var allowsUndo: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.allowsUndo(v)) }) }
	public static var sendsActionOnEndEditing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.sendsActionOnEndEditing(v)) }) }
	public static var usesSingleLineMode: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.usesSingleLineMode(v)) }) }
	@available(macOS 10.12.2, *)
	public static var allowsCharacterPickerTouchBarItem: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.allowsCharacterPickerTouchBarItem(v)) }) }
	@available(macOS 10.11, *)
	public static var allowsDefaultTighteningForTruncation: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.allowsDefaultTighteningForTruncation(v)) }) }
	@available(macOS 10.12.2, *)
	public static var isAutomaticTextCompletionEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.isAutomaticTextCompletionEnabled(v)) }) }
	@available(macOS 10.11, *)
	public static var maximumNumberOfLines: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .textFieldBinding(TextField.Binding.maximumNumberOfLines(v)) }) }
	public static var placeholderAttributedString: BindingName<Dynamic<NSAttributedString?>, Binding> { return BindingName<Dynamic<NSAttributedString?>, Binding>({ v in .textFieldBinding(TextField.Binding.placeholderAttributedString(v)) }) }
	public static var placeholderString: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .textFieldBinding(TextField.Binding.placeholderString(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var selectText: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .textFieldBinding(TextField.Binding.selectText(v)) }) }

	// 3. Action bindings are triggered by the object after construction.
	public static var stringAction: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .textFieldBinding(TextField.Binding.stringAction(v)) }) }
	public static var didFailToValidatePartialString: BindingName<SignalInput<(string: String, errorDescription: String?)>, Binding> { return BindingName<SignalInput<(string: String, errorDescription: String?)>, Binding>({ v in .textFieldBinding(TextField.Binding.didFailToValidatePartialString(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didFailToFormatString: BindingName<(_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool, Binding> { return BindingName<(_ control: NSTextField, _ string: String, _ errorDescription: String?) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.didFailToFormatString(v)) }) }
	public static var isValidObject: BindingName<(_ control: NSTextField, _ object: AnyObject) -> Bool, Binding> { return BindingName<(_ control: NSTextField, _ object: AnyObject) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.isValidObject(v)) }) }
	public static var shouldBeginEditing: BindingName<(_ control: NSTextField, _ text: NSText) -> Bool, Binding> { return BindingName<(_ control: NSTextField, _ text: NSText) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.shouldBeginEditing(v)) }) }
	public static var shouldEndEditing: BindingName<(_ control: NSTextField, _ text: NSText) -> Bool, Binding> { return BindingName<(_ control: NSTextField, _ text: NSText) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.shouldEndEditing(v)) }) }
	public static var completions: BindingName<(_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String], Binding> { return BindingName<(_ control: NSTextField, _ textView: NSTextView, _ completions: [String], _ partialWordRange: NSRange, _ indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String], Binding>({ v in .textFieldBinding(TextField.Binding.completions(v)) }) }
	public static var doCommand: BindingName<(_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool, Binding> { return BindingName<(_ control: NSTextField, _ textView: NSText, _ doCommandBySelector: Selector) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.doCommand(v)) }) }
}

public protocol TextFieldConvertible: ControlConvertible {
	func nsTextField() -> TextField.Instance
}
extension TextFieldConvertible {
	public func nsControl() -> Control.Instance { return nsTextField() }
}
extension TextField.Instance: TextFieldConvertible {
	public func nsTextField() -> TextField.Instance { return self }
}

public protocol TextFieldBinding: ControlBinding {
	static func textFieldBinding(_ binding: TextField.Binding) -> Self
}
extension TextFieldBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return textFieldBinding(.inheritedBinding(binding))
	}
}

#endif
