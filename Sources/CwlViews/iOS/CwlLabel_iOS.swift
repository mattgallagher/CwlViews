//
//  CwlLabel_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/23.
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

public class Label: Binder, LabelConvertible {
	public typealias Instance = UILabel
	public typealias Inherited = View
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiLabel() -> Instance { return instance() }
	
	enum Binding: LabelBinding {
		public typealias EnclosingBinder = Label
		public static func labelBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case text(Dynamic<String>)
		case attributedText(Dynamic<NSAttributedString?>)
		case font(Dynamic<UIFont>)
		case textColor(Dynamic<UIColor>)
		case textAlignment(Dynamic<NSTextAlignment>)
		case lineBreakMode(Dynamic<NSLineBreakMode>)
		case isEnabled(Dynamic<Bool>)
		case adjustsFontSizeToFitWidth(Dynamic<Bool>)
		case allowsDefaultTighteningForTruncation(Dynamic<Bool>)
		case baselineAdjustment(Dynamic<UIBaselineAdjustment>)
		case minimumScaleFactor(Dynamic<CGFloat>)
		case numberOfLines(Dynamic<Int>)
		case highlightedTextColor(Dynamic<UIColor?>)
		case isHighlighted(Dynamic<Bool>)
		case shadowColor(Dynamic<UIColor?>)
		case shadowOffset(Dynamic<CGSize>)
		case preferredMaxLayoutWidth(Dynamic<CGFloat>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = Label
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .text(let x): return x.apply(instance) { i, v in i.text = v }
			case .attributedText(let x): return x.apply(instance) { i, v in i.attributedText = v }
			case .font(let x): return x.apply(instance) { i, v in i.font = v }
			case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
			case .textAlignment(let x): return x.apply(instance) { i, v in i.textAlignment = v }
			case .lineBreakMode(let x): return x.apply(instance) { i, v in i.lineBreakMode = v }
			case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }
			case .adjustsFontSizeToFitWidth(let x): return x.apply(instance) { i, v in i.adjustsFontSizeToFitWidth = v }
			case .allowsDefaultTighteningForTruncation(let x): return x.apply(instance) { i, v in i.allowsDefaultTighteningForTruncation = v }
			case .baselineAdjustment(let x): return x.apply(instance) { i, v in i.baselineAdjustment = v }
			case .minimumScaleFactor(let x): return x.apply(instance) { i, v in i.minimumScaleFactor = v }
			case .numberOfLines(let x): return x.apply(instance) { i, v in i.numberOfLines = v }
			case .highlightedTextColor(let x): return x.apply(instance) { i, v in i.highlightedTextColor = v }
			case .isHighlighted(let x): return x.apply(instance) { i, v in i.isHighlighted = v }
			case .shadowColor(let x): return x.apply(instance) { i, v in i.shadowColor = v }
			case .shadowOffset(let x): return x.apply(instance) { i, v in i.shadowOffset = v }
			case .preferredMaxLayoutWidth(let x): return x.apply(instance) { i, v in i.preferredMaxLayoutWidth = v }
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = View.Storage
}

extension BindingName where Binding: LabelBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .labelBinding(Label.Binding.$1(v)) }) }
	public static var text: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .labelBinding(Label.Binding.text(v)) }) }
	public static var attributedText: BindingName<Dynamic<NSAttributedString?>, Binding> { return BindingName<Dynamic<NSAttributedString?>, Binding>({ v in .labelBinding(Label.Binding.attributedText(v)) }) }
	public static var font: BindingName<Dynamic<UIFont>, Binding> { return BindingName<Dynamic<UIFont>, Binding>({ v in .labelBinding(Label.Binding.font(v)) }) }
	public static var textColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .labelBinding(Label.Binding.textColor(v)) }) }
	public static var textAlignment: BindingName<Dynamic<NSTextAlignment>, Binding> { return BindingName<Dynamic<NSTextAlignment>, Binding>({ v in .labelBinding(Label.Binding.textAlignment(v)) }) }
	public static var lineBreakMode: BindingName<Dynamic<NSLineBreakMode>, Binding> { return BindingName<Dynamic<NSLineBreakMode>, Binding>({ v in .labelBinding(Label.Binding.lineBreakMode(v)) }) }
	public static var isEnabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .labelBinding(Label.Binding.isEnabled(v)) }) }
	public static var adjustsFontSizeToFitWidth: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .labelBinding(Label.Binding.adjustsFontSizeToFitWidth(v)) }) }
	public static var allowsDefaultTighteningForTruncation: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .labelBinding(Label.Binding.allowsDefaultTighteningForTruncation(v)) }) }
	public static var baselineAdjustment: BindingName<Dynamic<UIBaselineAdjustment>, Binding> { return BindingName<Dynamic<UIBaselineAdjustment>, Binding>({ v in .labelBinding(Label.Binding.baselineAdjustment(v)) }) }
	public static var minimumScaleFactor: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .labelBinding(Label.Binding.minimumScaleFactor(v)) }) }
	public static var numberOfLines: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .labelBinding(Label.Binding.numberOfLines(v)) }) }
	public static var highlightedTextColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .labelBinding(Label.Binding.highlightedTextColor(v)) }) }
	public static var isHighlighted: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .labelBinding(Label.Binding.isHighlighted(v)) }) }
	public static var shadowColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .labelBinding(Label.Binding.shadowColor(v)) }) }
	public static var shadowOffset: BindingName<Dynamic<CGSize>, Binding> { return BindingName<Dynamic<CGSize>, Binding>({ v in .labelBinding(Label.Binding.shadowOffset(v)) }) }
	public static var preferredMaxLayoutWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .labelBinding(Label.Binding.preferredMaxLayoutWidth(v)) }) }
}

public protocol LabelConvertible: ViewConvertible {
	func uiLabel() -> Label.Instance
}
extension LabelConvertible {
	public func uiView() -> View.Instance { return uiLabel() }
}
extension Label.Instance: LabelConvertible {
	public func uiLabel() -> Label.Instance { return self }
}

public protocol LabelBinding: ViewBinding {
	static func labelBinding(_ binding: Label.Binding) -> Self
}

extension LabelBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return labelBinding(.inheritedBinding(binding))
	}
}

#endif
