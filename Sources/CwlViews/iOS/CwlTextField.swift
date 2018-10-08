//
//  CwlTextField.swift
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

public class TextField: ConstructingBinder, TextFieldConvertible {
	public typealias Instance = UITextField
	public typealias Inherited = Control
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiTextField() -> Instance { return instance() }
	
	public enum Binding: TextFieldBinding {
		public typealias EnclosingBinder = TextField
		public static func textFieldBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case textInputTraits(Constant<TextInputTraits>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case text(Dynamic<String>)
		case attributedText(Dynamic<NSAttributedString?>)
		case placeholder(Dynamic<String?>)
		case attributedPlaceholder(Dynamic<NSAttributedString?>)
		case defaultTextAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		case font(Dynamic<UIFont?>)
		case textColor(Dynamic<UIColor?>)
		case textAlignment(Dynamic<NSTextAlignment>)
		case typingAttributes(Dynamic<[NSAttributedString.Key: Any]?>)
		case adjustsFontSizeToFitWidth(Dynamic<Bool>)
		case minimumFontSize(Dynamic<CGFloat>)
		case clearsOnBeginEditing(Dynamic<Bool>)
		case clearsOnInsertion(Dynamic<Bool>)
		case allowsEditingTextAttributes(Dynamic<Bool>)
		case borderStyle(Dynamic<UITextField.BorderStyle>)
		case background(Dynamic<UIImage?>)
		case disabledBackground(Dynamic<UIImage?>)
		case clearButtonMode(Dynamic<UITextField.ViewMode>)
		case leftView(Dynamic<ViewConvertible?>)
		case leftViewMode(Dynamic<UITextField.ViewMode>)
		case rightView(Dynamic<ViewConvertible?>)
		case rightViewMode(Dynamic<UITextField.ViewMode>)
		case inputView(Dynamic<ViewConvertible?>)
		case inputAccessoryView(Dynamic<ViewConvertible?>)
		
		//	2. Signal bindings are performed on the object after construction.
		case resignFirstResponder(Signal<Void>)
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case didBeginEditing((_ textField: UITextField) -> Void)
		case didChange((_ textField: UITextField) -> Void)
		case didEndEditing((_ textField: UITextField) -> Void)
		@available(iOS 10.0, *)
		case didEndEditingWithReason((_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void)
		case shouldBeginEditing((_ textField: UITextField) -> Bool)
		case shouldEndEditing((_ textField: UITextField) -> Bool)
		case shouldChangeCharacters((_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool)
		case shouldClear((_ textField: UITextField) -> Bool)
		case shouldReturn((_ textField: UITextField) -> Bool)
	}
	
	public struct Preparer: ConstructingPreparer {
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
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .didEndEditingWithReason(let x):
				if #available(iOS 10.0, *) {
					let s = #selector(UITextFieldDelegate.textFieldDidEndEditing(_:reason:))
					delegate().addSelector(s).didEndEditingWithReason = x
				}
			case .shouldBeginEditing(let x):
				let s = #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))
				delegate().addSelector(s).shouldBeginEditing = x
			case .shouldEndEditing(let x):
				let s = #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))
				delegate().addSelector(s).shouldEndEditing = x
			case .shouldChangeCharacters(let x):
				let s = #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))
				delegate().addSelector(s).shouldChangeCharacters = x
			case .shouldClear(let x):
				let s = #selector(UITextFieldDelegate.textFieldShouldClear(_:))
				delegate().addSelector(s).shouldClear = x
			case .shouldReturn(let x):
				let s = #selector(UITextFieldDelegate.textFieldShouldReturn(_:))
				delegate().addSelector(s).shouldReturn = x
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			if storage.inUse {
				instance.delegate = storage
			}
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .textInputTraits(let x):
				return Array(x.value.bindings.lazy.compactMap { trait in
					switch trait {
					case .autocapitalizationType(let y): return y.apply(instance, storage) { i, s, v in i.autocapitalizationType = v }
					case .autocorrectionType(let y): return y.apply(instance, storage) { i, s, v in i.autocorrectionType = v }
					case .spellCheckingType(let y): return y.apply(instance, storage) { i, s, v in i.spellCheckingType = v }
					case .enablesReturnKeyAutomatically(let y): return y.apply(instance, storage) { i, s, v in i.enablesReturnKeyAutomatically = v }
					case .keyboardAppearance(let y): return y.apply(instance, storage) { i, s, v in i.keyboardAppearance = v }
					case .keyboardType(let y): return y.apply(instance, storage) { i, s, v in i.keyboardType = v }
					case .returnKeyType(let y): return y.apply(instance, storage) { i, s, v in i.returnKeyType = v }
					case .isSecureTextEntry(let y): return y.apply(instance, storage) { i, s, v in i.isSecureTextEntry = v }
					case .textContentType(let y):
						return y.apply(instance, storage) { i, s, v in
							if #available(iOS 10.0, *) {
								i.textContentType = v
							}
						}
					case .smartDashesType(let x):
						return x.apply(instance, storage) { i, s, v in
							if #available(iOS 11.0, *) {
								i.smartDashesType = v
							}
						}
					case .smartQuotesType(let x):
						return x.apply(instance, storage) { i, s, v in
							if #available(iOS 11.0, *) {
								i.smartQuotesType = v
							}
						}
					case .smartInsertDeleteType(let x):
						return x.apply(instance, storage) { i, s, v in
							if #available(iOS 11.0, *) {
								i.smartInsertDeleteType = v
							}
						}
					}
				})
			case .text(let x): return x.apply(instance, storage) { i, s, v in i.text = v }
			case .attributedText(let x): return x.apply(instance, storage) { i, s, v in i.attributedText = v }
			case .placeholder(let x): return x.apply(instance, storage) { i, s, v in i.placeholder = v }
			case .attributedPlaceholder(let x): return x.apply(instance, storage) { i, s, v in i.attributedPlaceholder = v }
			case .defaultTextAttributes(let x): return x.apply(instance, storage) { i, s, v in i.defaultTextAttributes = v }
			case .font(let x): return x.apply(instance, storage) { i, s, v in i.font = v }
			case .textColor(let x): return x.apply(instance, storage) { i, s, v in i.textColor = v }
			case .textAlignment(let x): return x.apply(instance, storage) { i, s, v in i.textAlignment = v }
			case .typingAttributes(let x): return x.apply(instance, storage) { i, s, v in i.typingAttributes = v }
			case .adjustsFontSizeToFitWidth(let x): return x.apply(instance, storage) { i, s, v in i.adjustsFontSizeToFitWidth = v }
			case .minimumFontSize(let x): return x.apply(instance, storage) { i, s, v in i.minimumFontSize = v }
			case .clearsOnBeginEditing(let x): return x.apply(instance, storage) { i, s, v in i.clearsOnBeginEditing = v }
			case .clearsOnInsertion(let x): return x.apply(instance, storage) { i, s, v in i.clearsOnInsertion = v }
			case .allowsEditingTextAttributes(let x): return x.apply(instance, storage) { i, s, v in i.allowsEditingTextAttributes = v }
			case .borderStyle(let x): return x.apply(instance, storage) { i, s, v in i.borderStyle = v }
			case .background(let x): return x.apply(instance, storage) { i, s, v in i.background = v }
			case .disabledBackground(let x): return x.apply(instance, storage) { i, s, v in i.disabledBackground = v }
			case .clearButtonMode(let x): return x.apply(instance, storage) { i, s, v in i.clearButtonMode = v }
			case .leftView(let x): return x.apply(instance, storage) { i, s, v in i.leftView = v?.uiView() }
			case .leftViewMode(let x): return x.apply(instance, storage) { i, s, v in i.leftViewMode = v }
			case .rightView(let x): return x.apply(instance, storage) { i, s, v in i.rightView = v?.uiView() }
			case .rightViewMode(let x): return x.apply(instance, storage) { i, s, v in i.rightViewMode = v }
			case .inputView(let x): return x.apply(instance, storage) { i, s, v in i.inputView = v?.uiView() }
			case .inputAccessoryView(let x): return x.apply(instance, storage) { i, s, v in i.inputAccessoryView = v?.uiView() }
			case .resignFirstResponder(let x): return x.apply(instance, storage) { i, s, v in i.resignFirstResponder() }
			case .didBeginEditing(let x):
				return Signal
					.notifications(name: UITextField.textDidBeginEditingNotification, object: instance)
					.compactMap { notification in return notification.object as? UITextField }
					.subscribeValues { field in x(field) }
			case .didEndEditing(let x):
				return Signal
					.notifications(name: UITextField.textDidEndEditingNotification, object: instance)
					.compactMap { notification in return notification.object as? UITextField }
					.subscribeValues { field in x(field) }
			case .didChange(let x):
				return Signal
					.notifications(name: UITextField.textDidChangeNotification, object: instance)
					.compactMap { notification in return notification.object as? UITextField }
					.subscribeValues { field in x(field) }
			case .didEndEditingWithReason: return nil
			case .shouldBeginEditing: return nil
			case .shouldEndEditing: return nil
			case .shouldChangeCharacters: return nil
			case .shouldClear: return nil
			case .shouldReturn: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	open class Storage: Control.Storage, UITextFieldDelegate {}
	
	open class Delegate: DynamicDelegate, UITextFieldDelegate {
		public required override init() {
			super.init()
		}
		
		open var shouldBeginEditing: ((_ textField: UITextField) -> Bool)?
		open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
			return shouldBeginEditing!(textField)
		}
		
		open var shouldEndEditing: ((_ textField: UITextField) -> Bool)?
		open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
			return shouldEndEditing!(textField)
		}
		
		open var shouldChangeCharacters: ((_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool)?
		open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
			return shouldChangeCharacters!(textField, range, string)
		}
		
		open var shouldClear: ((_ textField: UITextField) -> Bool)?
		open func textFieldShouldClear(_ textField: UITextField) -> Bool {
			return shouldClear!(textField)
		}
		
		open var shouldReturn: ((_ textField: UITextField) -> Bool)?
		open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			return shouldReturn!(textField)
		}
		
		open var didEndEditingWithReason: Any?
		@available(iOS 10.0, *)
		open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
			(didEndEditingWithReason as! (UITextField, UITextField.DidEndEditingReason) -> Void)(textField, reason)
		}
	}
}

extension BindingName where Binding: TextFieldBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .textFieldBinding(TextField.Binding.$1(v)) }) }
	public static var textInputTraits: BindingName<Constant<TextInputTraits>, Binding> { return BindingName<Constant<TextInputTraits>, Binding>({ v in .textFieldBinding(TextField.Binding.textInputTraits(v)) }) }
	public static var text: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .textFieldBinding(TextField.Binding.text(v)) }) }
	public static var attributedText: BindingName<Dynamic<NSAttributedString?>, Binding> { return BindingName<Dynamic<NSAttributedString?>, Binding>({ v in .textFieldBinding(TextField.Binding.attributedText(v)) }) }
	public static var placeholder: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .textFieldBinding(TextField.Binding.placeholder(v)) }) }
	public static var attributedPlaceholder: BindingName<Dynamic<NSAttributedString?>, Binding> { return BindingName<Dynamic<NSAttributedString?>, Binding>({ v in .textFieldBinding(TextField.Binding.attributedPlaceholder(v)) }) }
	public static var defaultTextAttributes: BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding>({ v in .textFieldBinding(TextField.Binding.defaultTextAttributes(v)) }) }
	public static var font: BindingName<Dynamic<UIFont?>, Binding> { return BindingName<Dynamic<UIFont?>, Binding>({ v in .textFieldBinding(TextField.Binding.font(v)) }) }
	public static var textColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .textFieldBinding(TextField.Binding.textColor(v)) }) }
	public static var textAlignment: BindingName<Dynamic<NSTextAlignment>, Binding> { return BindingName<Dynamic<NSTextAlignment>, Binding>({ v in .textFieldBinding(TextField.Binding.textAlignment(v)) }) }
	public static var typingAttributes: BindingName<Dynamic<[NSAttributedString.Key: Any]?>, Binding> { return BindingName<Dynamic<[NSAttributedString.Key: Any]?>, Binding>({ v in .textFieldBinding(TextField.Binding.typingAttributes(v)) }) }
	public static var adjustsFontSizeToFitWidth: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.adjustsFontSizeToFitWidth(v)) }) }
	public static var minimumFontSize: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .textFieldBinding(TextField.Binding.minimumFontSize(v)) }) }
	public static var clearsOnBeginEditing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.clearsOnBeginEditing(v)) }) }
	public static var clearsOnInsertion: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.clearsOnInsertion(v)) }) }
	public static var allowsEditingTextAttributes: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textFieldBinding(TextField.Binding.allowsEditingTextAttributes(v)) }) }
	public static var borderStyle: BindingName<Dynamic<UITextField.BorderStyle>, Binding> { return BindingName<Dynamic<UITextField.BorderStyle>, Binding>({ v in .textFieldBinding(TextField.Binding.borderStyle(v)) }) }
	public static var background: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .textFieldBinding(TextField.Binding.background(v)) }) }
	public static var disabledBackground: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .textFieldBinding(TextField.Binding.disabledBackground(v)) }) }
	public static var clearButtonMode: BindingName<Dynamic<UITextField.ViewMode>, Binding> { return BindingName<Dynamic<UITextField.ViewMode>, Binding>({ v in .textFieldBinding(TextField.Binding.clearButtonMode(v)) }) }
	public static var leftView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .textFieldBinding(TextField.Binding.leftView(v)) }) }
	public static var leftViewMode: BindingName<Dynamic<UITextField.ViewMode>, Binding> { return BindingName<Dynamic<UITextField.ViewMode>, Binding>({ v in .textFieldBinding(TextField.Binding.leftViewMode(v)) }) }
	public static var rightView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .textFieldBinding(TextField.Binding.rightView(v)) }) }
	public static var rightViewMode: BindingName<Dynamic<UITextField.ViewMode>, Binding> { return BindingName<Dynamic<UITextField.ViewMode>, Binding>({ v in .textFieldBinding(TextField.Binding.rightViewMode(v)) }) }
	public static var inputView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .textFieldBinding(TextField.Binding.inputView(v)) }) }
	public static var inputAccessoryView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .textFieldBinding(TextField.Binding.inputAccessoryView(v)) }) }
	public static var resignFirstResponder: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .textFieldBinding(TextField.Binding.resignFirstResponder(v)) }) }
	public static var didBeginEditing: BindingName<(_ textField: UITextField) -> Void, Binding> { return BindingName<(_ textField: UITextField) -> Void, Binding>({ v in .textFieldBinding(TextField.Binding.didBeginEditing(v)) }) }
	public static var didChange: BindingName<(_ textField: UITextField) -> Void, Binding> { return BindingName<(_ textField: UITextField) -> Void, Binding>({ v in .textFieldBinding(TextField.Binding.didChange(v)) }) }
	public static var didEndEditing: BindingName<(_ textField: UITextField) -> Void, Binding> { return BindingName<(_ textField: UITextField) -> Void, Binding>({ v in .textFieldBinding(TextField.Binding.didEndEditing(v)) }) }
	@available(iOS 10.0, *)
	public static var didEndEditingWithReason: BindingName<(_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void, Binding> { return BindingName<(_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void, Binding>({ v in .textFieldBinding(TextField.Binding.didEndEditingWithReason(v)) }) }
	public static var shouldBeginEditing: BindingName<(_ textField: UITextField) -> Bool, Binding> { return BindingName<(_ textField: UITextField) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.shouldBeginEditing(v)) }) }
	public static var shouldEndEditing: BindingName<(_ textField: UITextField) -> Bool, Binding> { return BindingName<(_ textField: UITextField) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.shouldEndEditing(v)) }) }
	public static var shouldChangeCharacters: BindingName<(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool, Binding> { return BindingName<(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.shouldChangeCharacters(v)) }) }
	public static var shouldClear: BindingName<(_ textField: UITextField) -> Bool, Binding> { return BindingName<(_ textField: UITextField) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.shouldClear(v)) }) }
	public static var shouldReturn: BindingName<(_ textField: UITextField) -> Bool, Binding> { return BindingName<(_ textField: UITextField) -> Bool, Binding>({ v in .textFieldBinding(TextField.Binding.shouldReturn(v)) }) }
}

extension BindingName where Binding: TextFieldBinding {
	// Additional helper binding names
	public static var textChanged: BindingName<SignalInput<String>, Binding> {
		return BindingName<SignalInput<String>, Binding>({ v in .textFieldBinding(TextField.Binding.didChange { textField in if let t = textField.text { v.send(value: t) } }) })
	}
	public static var attributedTextChanged: BindingName<SignalInput<NSAttributedString>, Binding> {
		return BindingName<SignalInput<NSAttributedString>, Binding>({ v in .textFieldBinding(TextField.Binding.didChange { textField in if let t = textField.attributedText { v.send(value: t) } }) })
	}
}

public protocol TextFieldConvertible: ControlConvertible {
	func uiTextField() -> TextField.Instance
}
extension TextFieldConvertible {
	public func uiControl() -> Control.Instance { return uiTextField() }
}
extension TextField.Instance: TextFieldConvertible {
	public func uiTextField() -> TextField.Instance { return self }
}

public protocol TextFieldBinding: ControlBinding {
	static func textFieldBinding(_ binding: TextField.Binding) -> Self
}
extension TextFieldBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return textFieldBinding(.inheritedBinding(binding))
	}
}

public func textFieldResignOnReturn(condition: @escaping (UITextField) -> Bool = { _ in return true }) -> (UITextField) -> Bool {
	return { tf in
		if condition(tf) {
			tf.resignFirstResponder()
			return false
		}
		return true
	}
}
