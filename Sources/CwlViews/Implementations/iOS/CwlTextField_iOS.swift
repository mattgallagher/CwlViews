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

// MARK: - Binder Part 1: Binder
public class TextField: Binder, TextFieldConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TextField {
	enum Binding: TextFieldBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case textInputTraits(Constant<TextInputTraits>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case adjustsFontSizeToFitWidth(Dynamic<Bool>)
		case allowsEditingTextAttributes(Dynamic<Bool>)
		case attributedPlaceholder(Dynamic<NSAttributedString?>)
		case attributedText(Dynamic<NSAttributedString?>)
		case background(Dynamic<UIImage?>)
		case borderStyle(Dynamic<UITextField.BorderStyle>)
		case clearButtonMode(Dynamic<UITextField.ViewMode>)
		case clearsOnBeginEditing(Dynamic<Bool>)
		case clearsOnInsertion(Dynamic<Bool>)
		case defaultTextAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		case disabledBackground(Dynamic<UIImage?>)
		case font(Dynamic<UIFont?>)
		case inputAccessoryView(Dynamic<ViewConvertible?>)
		case inputView(Dynamic<ViewConvertible?>)
		case leftView(Dynamic<ViewConvertible?>)
		case leftViewMode(Dynamic<UITextField.ViewMode>)
		case minimumFontSize(Dynamic<CGFloat>)
		case placeholder(Dynamic<String?>)
		case rightView(Dynamic<ViewConvertible?>)
		case rightViewMode(Dynamic<UITextField.ViewMode>)
		case text(Dynamic<String>)
		case textAlignment(Dynamic<NSTextAlignment>)
		case textColor(Dynamic<UIColor?>)
		case typingAttributes(Dynamic<[NSAttributedString.Key: Any]?>)
		
		//	2. Signal bindings are performed on the object after construction.
		case resignFirstResponder(Signal<Void>)
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case didBeginEditing((_ textField: UITextField) -> Void)
		case didChange((_ textField: UITextField) -> Void)
		case didEndEditing((_ textField: UITextField) -> Void)
		case didEndEditingWithReason((_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void)
		case shouldBeginEditing((_ textField: UITextField) -> Bool)
		case shouldChangeCharacters((_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool)
		case shouldClear((_ textField: UITextField) -> Bool)
		case shouldEndEditing((_ textField: UITextField) -> Bool)
		case shouldReturn((_ textField: UITextField) -> Bool)
	}
}
	
// MARK: - Binder Part 3: Preparer
public extension TextField {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TextField.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UITextField
		
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
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .didEndEditingWithReason(let x): delegate().addMultiHandler2(x, #selector(UITextFieldDelegate.textFieldDidEndEditing(_:reason:)))
		case .shouldBeginEditing(let x): delegate().addSingleHandler1(x, #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:)))
		case .shouldEndEditing(let x): delegate().addSingleHandler1(x, #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)))
		case .shouldChangeCharacters(let x): delegate().addSingleHandler3(x, #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:)))
		case .shouldClear(let x): delegate().addSingleHandler1(x, #selector(UITextFieldDelegate.textFieldShouldClear(_:)))
		case .shouldReturn(let x): delegate().addSingleHandler1(x, #selector(UITextFieldDelegate.textFieldShouldReturn(_:)))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .textInputTraits(let x): return x.value.apply(to: instance)
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .adjustsFontSizeToFitWidth(let x): return x.apply(instance) { i, v in i.adjustsFontSizeToFitWidth = v }
		case .allowsEditingTextAttributes(let x): return x.apply(instance) { i, v in i.allowsEditingTextAttributes = v }
		case .attributedPlaceholder(let x): return x.apply(instance) { i, v in i.attributedPlaceholder = v }
		case .attributedText(let x): return x.apply(instance) { i, v in i.attributedText = v }
		case .background(let x): return x.apply(instance) { i, v in i.background = v }
		case .borderStyle(let x): return x.apply(instance) { i, v in i.borderStyle = v }
		case .clearButtonMode(let x): return x.apply(instance) { i, v in i.clearButtonMode = v }
		case .clearsOnBeginEditing(let x): return x.apply(instance) { i, v in i.clearsOnBeginEditing = v }
		case .clearsOnInsertion(let x): return x.apply(instance) { i, v in i.clearsOnInsertion = v }
		case .defaultTextAttributes(let x): return x.apply(instance) { i, v in i.defaultTextAttributes = v }
		case .disabledBackground(let x): return x.apply(instance) { i, v in i.disabledBackground = v }
		case .font(let x): return x.apply(instance) { i, v in i.font = v }
		case .inputAccessoryView(let x): return x.apply(instance) { i, v in i.inputAccessoryView = v?.uiView() }
		case .inputView(let x): return x.apply(instance) { i, v in i.inputView = v?.uiView() }
		case .leftView(let x): return x.apply(instance) { i, v in i.leftView = v?.uiView() }
		case .leftViewMode(let x): return x.apply(instance) { i, v in i.leftViewMode = v }
		case .minimumFontSize(let x): return x.apply(instance) { i, v in i.minimumFontSize = v }
		case .placeholder(let x): return x.apply(instance) { i, v in i.placeholder = v }
		case .rightView(let x): return x.apply(instance) { i, v in i.rightView = v?.uiView() }
		case .rightViewMode(let x): return x.apply(instance) { i, v in i.rightViewMode = v }
		case .text(let x): return x.apply(instance) { i, v in i.text = v }
		case .textAlignment(let x): return x.apply(instance) { i, v in i.textAlignment = v }
		case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
		case .typingAttributes(let x): return x.apply(instance) { i, v in i.typingAttributes = v }
		
		//	2. Signal bindings are performed on the object after construction.
		case .resignFirstResponder(let x): return x.apply(instance) { i, v in i.resignFirstResponder() }
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .didBeginEditing(let x): return Signal.notifications(name: UITextField.textDidBeginEditingNotification, object: instance).compactMap { notification in return notification.object as? UITextField }.subscribeValues { field in x(field) }
		case .didChange(let x): return Signal.notifications(name: UITextField.textDidChangeNotification, object: instance).compactMap { notification in return notification.object as? UITextField }.subscribeValues { field in x(field) }
		case .didEndEditing(let x): return Signal.notifications(name: UITextField.textDidEndEditingNotification, object: instance).compactMap { notification in return notification.object as? UITextField }.subscribeValues { field in x(field) }
		case .shouldBeginEditing: return nil
		case .shouldChangeCharacters: return nil
		case .shouldClear: return nil
		case .shouldEndEditing: return nil
		case .shouldReturn: return nil

		case .didEndEditingWithReason: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TextField.Preparer {
	open class Storage: Control.Preparer.Storage, UITextFieldDelegate {}
	
	open class Delegate: DynamicDelegate, UITextFieldDelegate {
		open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
			return singleHandler(textField)
		}
		
		open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
			return singleHandler(textField)
		}
		
		open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
			return singleHandler(textField, range, string)
		}
		
		open func textFieldShouldClear(_ textField: UITextField) -> Bool {
			return singleHandler(textField)
		}
		
		open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			return singleHandler(textField)
		}
		
		open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
			multiHandler(textField, reason)
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
	static var textInputTraits: TextFieldName<Constant<TextInputTraits>> { return .name(TextField.Binding.textInputTraits) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var adjustsFontSizeToFitWidth: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.adjustsFontSizeToFitWidth) }
	static var allowsEditingTextAttributes: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.allowsEditingTextAttributes) }
	static var attributedPlaceholder: TextFieldName<Dynamic<NSAttributedString?>> { return .name(TextField.Binding.attributedPlaceholder) }
	static var attributedText: TextFieldName<Dynamic<NSAttributedString?>> { return .name(TextField.Binding.attributedText) }
	static var background: TextFieldName<Dynamic<UIImage?>> { return .name(TextField.Binding.background) }
	static var borderStyle: TextFieldName<Dynamic<UITextField.BorderStyle>> { return .name(TextField.Binding.borderStyle) }
	static var clearButtonMode: TextFieldName<Dynamic<UITextField.ViewMode>> { return .name(TextField.Binding.clearButtonMode) }
	static var clearsOnBeginEditing: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.clearsOnBeginEditing) }
	static var clearsOnInsertion: TextFieldName<Dynamic<Bool>> { return .name(TextField.Binding.clearsOnInsertion) }
	static var defaultTextAttributes: TextFieldName<Dynamic<[NSAttributedString.Key: Any]>> { return .name(TextField.Binding.defaultTextAttributes) }
	static var disabledBackground: TextFieldName<Dynamic<UIImage?>> { return .name(TextField.Binding.disabledBackground) }
	static var font: TextFieldName<Dynamic<UIFont?>> { return .name(TextField.Binding.font) }
	static var inputAccessoryView: TextFieldName<Dynamic<ViewConvertible?>> { return .name(TextField.Binding.inputAccessoryView) }
	static var inputView: TextFieldName<Dynamic<ViewConvertible?>> { return .name(TextField.Binding.inputView) }
	static var leftView: TextFieldName<Dynamic<ViewConvertible?>> { return .name(TextField.Binding.leftView) }
	static var leftViewMode: TextFieldName<Dynamic<UITextField.ViewMode>> { return .name(TextField.Binding.leftViewMode) }
	static var minimumFontSize: TextFieldName<Dynamic<CGFloat>> { return .name(TextField.Binding.minimumFontSize) }
	static var placeholder: TextFieldName<Dynamic<String?>> { return .name(TextField.Binding.placeholder) }
	static var rightView: TextFieldName<Dynamic<ViewConvertible?>> { return .name(TextField.Binding.rightView) }
	static var rightViewMode: TextFieldName<Dynamic<UITextField.ViewMode>> { return .name(TextField.Binding.rightViewMode) }
	static var text: TextFieldName<Dynamic<String>> { return .name(TextField.Binding.text) }
	static var textAlignment: TextFieldName<Dynamic<NSTextAlignment>> { return .name(TextField.Binding.textAlignment) }
	static var textColor: TextFieldName<Dynamic<UIColor?>> { return .name(TextField.Binding.textColor) }
	static var typingAttributes: TextFieldName<Dynamic<[NSAttributedString.Key: Any]?>> { return .name(TextField.Binding.typingAttributes) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var resignFirstResponder: TextFieldName<Signal<Void>> { return .name(TextField.Binding.resignFirstResponder) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var didBeginEditing: TextFieldName<(_ textField: UITextField) -> Void> { return .name(TextField.Binding.didBeginEditing) }
	static var didChange: TextFieldName<(_ textField: UITextField) -> Void> { return .name(TextField.Binding.didChange) }
	static var didEndEditing: TextFieldName<(_ textField: UITextField) -> Void> { return .name(TextField.Binding.didEndEditing) }
	static var didEndEditingWithReason: TextFieldName<(_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void> { return .name(TextField.Binding.didEndEditingWithReason) }
	static var shouldBeginEditing: TextFieldName<(_ textField: UITextField) -> Bool> { return .name(TextField.Binding.shouldBeginEditing) }
	static var shouldChangeCharacters: TextFieldName<(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool> { return .name(TextField.Binding.shouldChangeCharacters) }
	static var shouldClear: TextFieldName<(_ textField: UITextField) -> Bool> { return .name(TextField.Binding.shouldClear) }
	static var shouldEndEditing: TextFieldName<(_ textField: UITextField) -> Bool> { return .name(TextField.Binding.shouldEndEditing) }
	static var shouldReturn: TextFieldName<(_ textField: UITextField) -> Bool> { return .name(TextField.Binding.shouldReturn) }
	
	// Composite binding names
	static func textChanged(_ void: Void = ()) -> TextFieldName<SignalInput<String>> {
		return Binding.compositeName(
			value: { input in { textField in textField.text.map { _ = input.send(value: $0) } } },
			binding: TextField.Binding.didChange,
			downcast: Binding.textFieldBinding
		)
	}
	static func attributedTextChanged(_ void: Void = ()) -> TextFieldName<SignalInput<NSAttributedString>> {
		return Binding.compositeName(
			value: { input in { textField in textField.attributedText.map { _ = input.send(value: $0) } } },
			binding: TextField.Binding.didChange,
			downcast: Binding.textFieldBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TextFieldConvertible: ControlConvertible {
	func uiTextField() -> TextField.Instance
}
extension TextFieldConvertible {
	public func uiControl() -> Control.Instance { return uiTextField() }
}
extension UITextField: TextFieldConvertible, HasDelegate {
	public func uiTextField() -> TextField.Instance { return self }
}
public extension TextField {
	func uiTextField() -> TextField.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TextFieldBinding: ControlBinding {
	static func textFieldBinding(_ binding: TextField.Binding) -> Self
}
public extension TextFieldBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return textFieldBinding(.inheritedBinding(binding))
	}
}
public extension TextField.Binding {
	typealias Preparer = TextField.Preparer
	static func textFieldBinding(_ binding: TextField.Binding) -> TextField.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public func textFieldResignOnReturn(condition: @escaping (UITextField) -> Bool = { _ in return true }) -> (UITextField) -> Bool {
	return { tf in
		if condition(tf) {
			tf.resignFirstResponder()
			return false
		}
		return true
	}
}

#endif
