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

// MARK: - Binder Part 1: Binder
public class TextView: Binder, TextViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TextView {
	enum Binding: TextViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case textInputTraits(Constant<TextInputTraits>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsEditingTextAttributes(Dynamic<Bool>)
		case attributedText(Dynamic<NSAttributedString>)
		case clearsOnInsertion(Dynamic<Bool>)
		case dataDetectorTypes(Dynamic<UIDataDetectorTypes>)
		case font(Dynamic<UIFont?>)
		case inputAccessoryView(Dynamic<ViewConvertible?>)
		case inputView(Dynamic<ViewConvertible?>)
		case isEditable(Dynamic<Bool>)
		case isSelectable(Dynamic<Bool>)
		case linkTextAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		case selectedRange(Dynamic<NSRange>)
		case text(Dynamic<String>)
		case textAlignment(Dynamic<NSTextAlignment>)
		case textColor(Dynamic<UIColor?>)
		case textContainerInset(Dynamic<UIEdgeInsets>)
		case typingAttributes(Dynamic<[NSAttributedString.Key: Any]>)
		
		// 2. Signal bindings are performed on the object after construction.
		case scrollRangeToVisible(Signal<NSRange>)
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didBeginEditing((UITextView) -> Void)
		case didChange((UITextView) -> Void)
		case didChangeSelection((UITextView) -> Void)
		case didEndEditing((UITextView) -> Void)
		case shouldBeginEditing((UITextView) -> Bool)
		case shouldChangeText((UITextView, NSRange, String) -> Bool)
		case shouldEndEditing((UITextView) -> Bool)
		case shouldInteractWithAttachment((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)
		case shouldInteractWithURL((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TextView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TextView.Binding
		public typealias Inherited = ScrollView.Preparer
		public typealias Instance = UITextView
		
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
public extension TextView.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.

		// 2. Signal bindings are performed on the object after construction.
			
		//	3. Action bindings are triggered by the object after construction.
		case .didBeginEditing(let x): delegate().addMultiHandler1(x, #selector(UITextViewDelegate.textViewDidBeginEditing(_:)))
		case .didChange(let x): delegate().addMultiHandler1(x, #selector(UITextViewDelegate.textViewDidChange(_:)))
		case .didChangeSelection(let x): delegate().addMultiHandler1(x, #selector(UITextViewDelegate.textViewDidChangeSelection(_:)))
		case .didEndEditing(let x): delegate().addMultiHandler1(x, #selector(UITextViewDelegate.textViewDidEndEditing(_:)))
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .shouldBeginEditing(let x): delegate().addSingleHandler1(x, #selector(UITextViewDelegate.textViewShouldBeginEditing(_:)))
		case .shouldChangeText(let x): delegate().addSingleHandler3(x, #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:)))
		case .shouldEndEditing(let x): delegate().addSingleHandler1(x, #selector(UITextViewDelegate.textViewShouldEndEditing(_:)))
		
		case .shouldInteractWithAttachment(let x): delegate().addSingleHandler4(x, #selector(UITextViewDelegate.textView(_:shouldInteractWith:in:interaction:) as ((UITextViewDelegate) -> (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)?))
		case .shouldInteractWithURL(let x): delegate().addSingleHandler4(x, #selector(UITextViewDelegate.textView(_:shouldInteractWith:in:interaction:) as ((UITextViewDelegate) -> (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)?))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .textInputTraits(let x): return x.value.apply(to: instance)
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowsEditingTextAttributes(let x): return x.apply(instance) { i, v in i.allowsEditingTextAttributes = v }
		case .attributedText(let x): return x.apply(instance) { i, v in i.attributedText = v }
		case .clearsOnInsertion(let x): return x.apply(instance) { i, v in i.clearsOnInsertion = v }
		case .dataDetectorTypes(let x): return x.apply(instance) { i, v in i.dataDetectorTypes = v }
		case .font(let x): return x.apply(instance) { i, v in i.font = v }
		case .inputAccessoryView(let x): return x.apply(instance) { i, v in i.inputAccessoryView = v?.uiView() }
		case .inputView(let x): return x.apply(instance) { i, v in i.inputView = v?.uiView() }
		case .isEditable(let x): return x.apply(instance) { i, v in i.isEditable = v }
		case .isSelectable(let x): return x.apply(instance) { i, v in i.isSelectable = v }
		case .linkTextAttributes(let x): return x.apply(instance) { i, v in i.linkTextAttributes = v }
		case .selectedRange(let x): return x.apply(instance) { i, v in i.selectedRange = v }
		case .text(let x): return x.apply(instance) { i, v in i.text = v }
		case .textAlignment(let x): return x.apply(instance) { i, v in i.textAlignment = v }
		case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
		case .textContainerInset(let x): return x.apply(instance) { i, v in i.textContainerInset = v }
		case .typingAttributes(let x): return x.apply(instance) { i, v in i.typingAttributes = v }
			
		// 2. Signal bindings are performed on the object after construction.
		case .scrollRangeToVisible(let x): return x.apply(instance) { i, v in i.scrollRangeToVisible(v) }
			
		//	3. Action bindings are triggered by the object after construction.
		case .didBeginEditing: return nil
		case .didChange: return nil
		case .didChangeSelection: return nil
		case .didEndEditing: return nil
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .shouldBeginEditing: return nil
		case .shouldChangeText: return nil
		case .shouldEndEditing: return nil
		
		case .shouldInteractWithAttachment: return nil
		case .shouldInteractWithURL: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TextView.Preparer {
	open class Storage: ScrollView.Preparer.Storage, UITextViewDelegate {}
	
	open class Delegate: ScrollView.Preparer.Delegate, UITextViewDelegate {
		open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
			return singleHandler(textView)
		}
		
		open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
			return singleHandler(textView)
		}
		
		open func textViewDidBeginEditing(_ textView: UITextView) {
			multiHandler(textView)
		}
		
		open func textViewDidEndEditing(_ textView: UITextView) {
			multiHandler(textView)
		}
		
		open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			return singleHandler(textView, range, text)
		}
		
		open func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
			return singleHandler(textView, textAttachment, characterRange, interaction)
		}
		
		open func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
			return singleHandler(textView, url, characterRange, interaction)
		}
		
		open func textViewDidChange(_ textView: UITextView) {
			multiHandler(textView)
		}
		
		open func textViewDidChangeSelection(_ textView: UITextView) {
			multiHandler(textView)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TextViewBinding {
	public typealias TextViewName<V> = BindingName<V, TextView.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> TextView.Binding) -> TextViewName<V> {
		return TextViewName<V>(source: source, downcast: Binding.textViewBinding)
	}
}
public extension BindingName where Binding: TextViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TextViewName<$2> { return .name(TextView.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var textInputTraits: TextViewName<Constant<TextInputTraits>> { return .name(TextView.Binding.textInputTraits) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsEditingTextAttributes: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.allowsEditingTextAttributes) }
	static var attributedText: TextViewName<Dynamic<NSAttributedString>> { return .name(TextView.Binding.attributedText) }
	static var clearsOnInsertion: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.clearsOnInsertion) }
	static var dataDetectorTypes: TextViewName<Dynamic<UIDataDetectorTypes>> { return .name(TextView.Binding.dataDetectorTypes) }
	static var font: TextViewName<Dynamic<UIFont?>> { return .name(TextView.Binding.font) }
	static var inputAccessoryView: TextViewName<Dynamic<ViewConvertible?>> { return .name(TextView.Binding.inputAccessoryView) }
	static var inputView: TextViewName<Dynamic<ViewConvertible?>> { return .name(TextView.Binding.inputView) }
	static var isEditable: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isEditable) }
	static var isSelectable: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isSelectable) }
	static var linkTextAttributes: TextViewName<Dynamic<[NSAttributedString.Key: Any]>> { return .name(TextView.Binding.linkTextAttributes) }
	static var selectedRange: TextViewName<Dynamic<NSRange>> { return .name(TextView.Binding.selectedRange) }
	static var text: TextViewName<Dynamic<String>> { return .name(TextView.Binding.text) }
	static var textAlignment: TextViewName<Dynamic<NSTextAlignment>> { return .name(TextView.Binding.textAlignment) }
	static var textColor: TextViewName<Dynamic<UIColor?>> { return .name(TextView.Binding.textColor) }
	static var textContainerInset: TextViewName<Dynamic<UIEdgeInsets>> { return .name(TextView.Binding.textContainerInset) }
	static var typingAttributes: TextViewName<Dynamic<[NSAttributedString.Key: Any]>> { return .name(TextView.Binding.typingAttributes) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var scrollRangeToVisible: TextViewName<Signal<NSRange>> { return .name(TextView.Binding.scrollRangeToVisible) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var didBeginEditing: TextViewName<(UITextView) -> Void> { return .name(TextView.Binding.didBeginEditing) }
	static var didChange: TextViewName<(UITextView) -> Void> { return .name(TextView.Binding.didChange) }
	static var didChangeSelection: TextViewName<(UITextView) -> Void> { return .name(TextView.Binding.didChangeSelection) }
	static var didEndEditing: TextViewName<(UITextView) -> Void> { return .name(TextView.Binding.didEndEditing) }
	static var shouldBeginEditing: TextViewName<(UITextView) -> Bool> { return .name(TextView.Binding.shouldBeginEditing) }
	static var shouldChangeText: TextViewName<(UITextView, NSRange, String) -> Bool> { return .name(TextView.Binding.shouldChangeText) }
	static var shouldEndEditing: TextViewName<(UITextView) -> Bool> { return .name(TextView.Binding.shouldEndEditing) }
	static var shouldInteractWithAttachment: TextViewName<(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool> { return .name(TextView.Binding.shouldInteractWithAttachment) }
	static var shouldInteractWithURL: TextViewName<(UITextView, URL, NSRange, UITextItemInteraction) -> Bool> { return .name(TextView.Binding.shouldInteractWithURL) }
	
	// Composite binding names
	static func textChanged(_ void: Void = ()) -> TextViewName<SignalInput<String>> {
		return Binding.compositeName(
			value: { input in { textView in _ = input.send(value: textView.text) } },
			binding: TextView.Binding.didChange,
			downcast: Binding.textViewBinding
		)
	}
	static func attributedTextChanged(_ void: Void = ()) -> TextViewName<SignalInput<NSAttributedString>> {
		return Binding.compositeName(
			value: { input in { textView in _ = input.send(value: textView.attributedText) } },
			binding: TextView.Binding.didChange,
			downcast: Binding.textViewBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TextViewConvertible: ScrollViewConvertible {
	func uiTextView() -> UITextView
}
extension TextViewConvertible {
	public func uiScrollView() -> ScrollView.Instance { return uiTextView() }
}
extension UITextView: TextViewConvertible {
	public func uiTextView() -> UITextView { return self }
}
public extension TextView {
	func uiTextView() -> UITextView { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TextViewBinding: ScrollViewBinding {
	static func textViewBinding(_ binding: TextView.Binding) -> Self
}
public extension TextViewBinding {
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self {
		return textViewBinding(.inheritedBinding(binding))
	}
}
public extension TextView.Binding {
	typealias Preparer = TextView.Preparer
	static func textViewBinding(_ binding: TextView.Binding) -> TextView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
