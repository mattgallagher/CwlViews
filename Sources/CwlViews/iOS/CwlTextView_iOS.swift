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

public class TextView: Binder, TextViewConvertible {
	public typealias Instance = UITextView
	public typealias Inherited = ScrollView
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiTextView() -> Instance { return instance() }
	
	enum Binding: TextViewBinding {
		public typealias EnclosingBinder = TextView
		public static func textViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case textInputTraits(Constant<TextInputTraits>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case text(Dynamic<String>)
		case attributedText(Dynamic<NSAttributedString>)
		case font(Dynamic<UIFont?>)
		case textColor(Dynamic<UIColor?>)
		case isEditable(Dynamic<Bool>)
		case allowsEditingTextAttributes(Dynamic<Bool>)
		case dataDetectorTypes(Dynamic<UIDataDetectorTypes>)
		case textAlignment(Dynamic<NSTextAlignment>)
		case typingAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		case linkTextAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		case textContainerInset(Dynamic<UIEdgeInsets>)
		case selectedRange(Dynamic<NSRange>)
		case clearsOnInsertion(Dynamic<Bool>)
		case isSelectable(Dynamic<Bool>)
		case inputView(Dynamic<ViewConvertible?>)
		case inputAccessoryView(Dynamic<ViewConvertible?>)
		
		// 2. Signal bindings are performed on the object after construction.
		case scrollRangeToVisible(Signal<NSRange>)
		
		//	3. Action bindings are triggered by the object after construction.
		case didBeginEditing(SignalInput<UITextView>)
		case didEndEditing(SignalInput<UITextView>)
		case didChange(SignalInput<UITextView>)
		case didChangeSelection(SignalInput<UITextView>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldBeginEditing((UITextView) -> Bool)
		case shouldEndEditing((UITextView) -> Bool)
		case shouldChangeText((UITextView, NSRange, String) -> Bool)
		@available(iOS 10.0, *)
		case shouldInteractWithAttachment((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)
		@available(iOS 10.0, *)
		case shouldInteractWithURL((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = TextView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		// Actual delegate construction is handled by the scroll view preparer
		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init(delegateClass: Delegate.Type) {
			linkedPreparer = Inherited.Preparer(delegateClass: delegateClass)
		}
		var dynamicDelegate: Delegate? { return linkedPreparer.dynamicDelegate as? Delegate }
		mutating func delegate() -> Delegate { return linkedPreparer.delegate() as! Delegate }
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .shouldBeginEditing(let x): delegate().addHandler(x, #selector(UITextViewDelegate.textViewShouldBeginEditing(_:)))
			case .shouldEndEditing(let x): delegate().addHandler(x, #selector(UITextViewDelegate.textViewShouldEndEditing(_:)))
			case .didBeginEditing(let x): delegate().addHandler(x, #selector(UITextViewDelegate.textViewDidBeginEditing(_:)))
			case .didEndEditing(let x): delegate().addHandler(x, #selector(UITextViewDelegate.textViewDidEndEditing(_:)))
			case .shouldChangeText(let x): delegate().addHandler(x, #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:)))
			case .didChange(let x): delegate().addHandler(x, #selector(UITextViewDelegate.textViewDidChange(_:)))
			case .didChangeSelection(let x): delegate().addHandler(x, #selector(UITextViewDelegate.textViewDidChangeSelection(_:)))
			case .shouldInteractWithAttachment(let x):
				if #available(iOS 10.0, *) {
					let s = #selector(UITextViewDelegate.textView(_:shouldInteractWith:in:interaction:) as ((UITextViewDelegate) -> (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)?)
					delegate().addSelector(s).shouldInteractWithAttachment = x
				}
			case .shouldInteractWithURL(let x):
				if #available(iOS 10.0, *) {
					let s = #selector(UITextViewDelegate.textView(_:shouldInteractWith:in:interaction:) as ((UITextViewDelegate) -> (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)?)
					delegate().addSelector(s).shouldInteractWithAttachment = x
				}
			case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
			default: break
			}
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .textInputTraits(let x):
				return AggregateLifetime(lifetimes: x.value.bindings.lazy.compactMap { trait in
					switch trait {
					case .autocapitalizationType(let y): return y.apply(instance) { i, v in i.autocapitalizationType = v }
					case .autocorrectionType(let y): return y.apply(instance) { i, v in i.autocorrectionType = v }
					case .spellCheckingType(let y): return y.apply(instance) { i, v in i.spellCheckingType = v }
					case .enablesReturnKeyAutomatically(let y): return y.apply(instance) { i, v in i.enablesReturnKeyAutomatically = v }
					case .keyboardAppearance(let y): return y.apply(instance) { i, v in i.keyboardAppearance = v }
					case .keyboardType(let y): return y.apply(instance) { i, v in i.keyboardType = v }
					case .returnKeyType(let y): return y.apply(instance) { i, v in i.returnKeyType = v }
					case .isSecureTextEntry(let y): return y.apply(instance) { i, v in i.isSecureTextEntry = v }
					case .textContentType(let y):
						return y.apply(instance) { i, v in
							if #available(iOS 10.0, *) {
								i.textContentType = v
							}
						}
					case .smartDashesType(let x):
						return x.apply(instance) { i, v in
							if #available(iOS 11.0, *) {
								i.smartDashesType = v
							}
						}
					case .smartQuotesType(let x):
						return x.apply(instance) { i, v in
							if #available(iOS 11.0, *) {
								i.smartQuotesType = v
							}
						}
					case .smartInsertDeleteType(let x):
						return x.apply(instance) { i, v in
							if #available(iOS 11.0, *) {
								i.smartInsertDeleteType = v
							}
						}
					}
				})
			case .text(let x): return x.apply(instance) { i, v in i.text = v }
			case .attributedText(let x): return x.apply(instance) { i, v in i.attributedText = v }
			case .font(let x): return x.apply(instance) { i, v in i.font = v }
			case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
			case .isEditable(let x): return x.apply(instance) { i, v in i.isEditable = v }
			case .allowsEditingTextAttributes(let x): return x.apply(instance) { i, v in i.allowsEditingTextAttributes = v }
			case .dataDetectorTypes(let x): return x.apply(instance) { i, v in i.dataDetectorTypes = v }
			case .textAlignment(let x): return x.apply(instance) { i, v in i.textAlignment = v }
			case .typingAttributes(let x): return x.apply(instance) { i, v in i.typingAttributes = v }
			case .linkTextAttributes(let x): return x.apply(instance) { i, v in i.linkTextAttributes = v }
			case .textContainerInset(let x): return x.apply(instance) { i, v in i.textContainerInset = v }
			case .selectedRange(let x): return x.apply(instance) { i, v in i.selectedRange = v }
			case .clearsOnInsertion(let x): return x.apply(instance) { i, v in i.clearsOnInsertion = v }
			case .isSelectable(let x): return x.apply(instance) { i, v in i.isSelectable = v }
			case .inputView(let x): return x.apply(instance) { i, v in i.inputView = v?.uiView() }
			case .inputAccessoryView(let x): return x.apply(instance) { i, v in i.inputAccessoryView = v?.uiView() }
			case .scrollRangeToVisible(let x): return x.apply(instance) { i, v in i.scrollRangeToVisible(v) }
			case .shouldBeginEditing: return nil
			case .didBeginEditing: return nil
			case .shouldEndEditing: return nil
			case .didEndEditing: return nil
			case .shouldChangeText: return nil
			case .didChange: return nil
			case .didChangeSelection: return nil
			case .shouldInteractWithAttachment: return nil
			case .shouldInteractWithURL: return nil
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	open class Storage: ScrollView.Preparer.Storage, UITextViewDelegate {}
	
	open class Delegate: ScrollView.Delegate, UITextViewDelegate {
		public required init() {
			super.init()
		}
		
		open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
			return handler(ofType: ((UITextView) -> Bool).self)(textView)
		}
		
		open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
			return handler(ofType: ((UITextView) -> Bool).self)(textView)
		}
		
		open func textViewDidBeginEditing(_ textView: UITextView) {
			handler(ofType: SignalInput<UITextView>.self).send(value: textView)
		}
		
		open func textViewDidEndEditing(_ textView: UITextView) {
			handler(ofType: SignalInput<UITextView>.self).send(value: textView)
		}
		
		open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			return handler(ofType: ((UITextView, NSRange, String) -> Bool).self)(textView, range, text)
		}
		
		open func textViewDidChange(_ textView: UITextView) {
			handler(ofType: SignalInput<UITextView>.self).send(value: textView)
		}
		
		open func textViewDidChangeSelection(_ textView: UITextView) {
			handler(ofType: SignalInput<UITextView>.self).send(value: textView)
		}
		
		open var shouldInteractWithAttachment: Any?
		@available(iOS 10.0, *)
		open func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
			return (shouldInteractWithAttachment as! (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)(textView, textAttachment, characterRange, interaction)
		}
		
		open var shouldInteractWithURL: Any?
		@available(iOS 10.0, *)
		open func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
			return (shouldInteractWithAttachment as! (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)(textView, url, characterRange, interaction)
		}
	}
}

extension BindingName where Binding: TextViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .textViewBinding(TextView.Binding.$1(v)) }) }
	public static var textInputTraits: BindingName<Constant<TextInputTraits>, Binding> { return BindingName<Constant<TextInputTraits>, Binding>({ v in .textViewBinding(TextView.Binding.textInputTraits(v)) }) }
	public static var text: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .textViewBinding(TextView.Binding.text(v)) }) }
	public static var attributedText: BindingName<Dynamic<NSAttributedString>, Binding> { return BindingName<Dynamic<NSAttributedString>, Binding>({ v in .textViewBinding(TextView.Binding.attributedText(v)) }) }
	public static var font: BindingName<Dynamic<UIFont?>, Binding> { return BindingName<Dynamic<UIFont?>, Binding>({ v in .textViewBinding(TextView.Binding.font(v)) }) }
	public static var textColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .textViewBinding(TextView.Binding.textColor(v)) }) }
	public static var isEditable: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textViewBinding(TextView.Binding.isEditable(v)) }) }
	public static var allowsEditingTextAttributes: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textViewBinding(TextView.Binding.allowsEditingTextAttributes(v)) }) }
	public static var dataDetectorTypes: BindingName<Dynamic<UIDataDetectorTypes>, Binding> { return BindingName<Dynamic<UIDataDetectorTypes>, Binding>({ v in .textViewBinding(TextView.Binding.dataDetectorTypes(v)) }) }
	public static var textAlignment: BindingName<Dynamic<NSTextAlignment>, Binding> { return BindingName<Dynamic<NSTextAlignment>, Binding>({ v in .textViewBinding(TextView.Binding.textAlignment(v)) }) }
	public static var typingAttributes: BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding>({ v in .textViewBinding(TextView.Binding.typingAttributes(v)) }) }
	public static var linkTextAttributes: BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding> { return BindingName<Dynamic<[NSAttributedString.Key: Any]>, Binding>({ v in .textViewBinding(TextView.Binding.linkTextAttributes(v)) }) }
	public static var textContainerInset: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .textViewBinding(TextView.Binding.textContainerInset(v)) }) }
	public static var selectedRange: BindingName<Dynamic<NSRange>, Binding> { return BindingName<Dynamic<NSRange>, Binding>({ v in .textViewBinding(TextView.Binding.selectedRange(v)) }) }
	public static var clearsOnInsertion: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textViewBinding(TextView.Binding.clearsOnInsertion(v)) }) }
	public static var isSelectable: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .textViewBinding(TextView.Binding.isSelectable(v)) }) }
	public static var inputView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .textViewBinding(TextView.Binding.inputView(v)) }) }
	public static var inputAccessoryView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .textViewBinding(TextView.Binding.inputAccessoryView(v)) }) }
	public static var scrollRangeToVisible: BindingName<Signal<NSRange>, Binding> { return BindingName<Signal<NSRange>, Binding>({ v in .textViewBinding(TextView.Binding.scrollRangeToVisible(v)) }) }
	public static var didBeginEditing: BindingName<SignalInput<UITextView>, Binding> { return BindingName<SignalInput<UITextView>, Binding>({ v in .textViewBinding(TextView.Binding.didBeginEditing(v)) }) }
	public static var didEndEditing: BindingName<SignalInput<UITextView>, Binding> { return BindingName<SignalInput<UITextView>, Binding>({ v in .textViewBinding(TextView.Binding.didEndEditing(v)) }) }
	public static var didChange: BindingName<SignalInput<UITextView>, Binding> { return BindingName<SignalInput<UITextView>, Binding>({ v in .textViewBinding(TextView.Binding.didChange(v)) }) }
	public static var didChangeSelection: BindingName<SignalInput<UITextView>, Binding> { return BindingName<SignalInput<UITextView>, Binding>({ v in .textViewBinding(TextView.Binding.didChangeSelection(v)) }) }
	public static var shouldBeginEditing: BindingName<(UITextView) -> Bool, Binding> { return BindingName<(UITextView) -> Bool, Binding>({ v in .textViewBinding(TextView.Binding.shouldBeginEditing(v)) }) }
	public static var shouldEndEditing: BindingName<(UITextView) -> Bool, Binding> { return BindingName<(UITextView) -> Bool, Binding>({ v in .textViewBinding(TextView.Binding.shouldEndEditing(v)) }) }
	public static var shouldChangeText: BindingName<(UITextView, NSRange, String) -> Bool, Binding> { return BindingName<(UITextView, NSRange, String) -> Bool, Binding>({ v in .textViewBinding(TextView.Binding.shouldChangeText(v)) }) }
	@available(iOS 10.0, *)
	public static var shouldInteractWithAttachment: BindingName<(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool, Binding> { return BindingName<(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool, Binding>({ v in .textViewBinding(TextView.Binding.shouldInteractWithAttachment(v)) }) }
	@available(iOS 10.0, *)
	public static var shouldInteractWithURL: BindingName<(UITextView, URL, NSRange, UITextItemInteraction) -> Bool, Binding> { return BindingName<(UITextView, URL, NSRange, UITextItemInteraction) -> Bool, Binding>({ v in .textViewBinding(TextView.Binding.shouldInteractWithURL(v)) }) }
}

public protocol TextViewConvertible: ScrollViewConvertible {
	func uiTextView() -> TextView.Instance
}
extension TextViewConvertible {
	public func uiScrollView() -> ScrollView.Instance { return uiTextView() }
}
extension TextView.Instance: TextViewConvertible {
	public func uiTextView() -> TextView.Instance { return self }
}

public protocol TextViewBinding: ScrollViewBinding {
	static func textViewBinding(_ binding: TextView.Binding) -> Self
}
extension TextViewBinding {
	public static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self {
		return textViewBinding(.inheritedBinding(binding))
	}
}

#endif
