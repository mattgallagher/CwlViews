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

// MARK: - Binder Part 1: Binder
public class Label: Binder, LabelConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Label {
	enum Binding: LabelBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case adjustsFontSizeToFitWidth(Dynamic<Bool>)
		case allowsDefaultTighteningForTruncation(Dynamic<Bool>)
		case attributedText(Dynamic<NSAttributedString?>)
		case baselineAdjustment(Dynamic<UIBaselineAdjustment>)
		case font(Dynamic<UIFont>)
		case highlightedTextColor(Dynamic<UIColor?>)
		case isEnabled(Dynamic<Bool>)
		case isHighlighted(Dynamic<Bool>)
		case lineBreakMode(Dynamic<NSLineBreakMode>)
		case minimumScaleFactor(Dynamic<CGFloat>)
		case numberOfLines(Dynamic<Int>)
		case preferredMaxLayoutWidth(Dynamic<CGFloat>)
		case shadowColor(Dynamic<UIColor?>)
		case shadowOffset(Dynamic<CGSize>)
		case text(Dynamic<String>)
		case textAlignment(Dynamic<NSTextAlignment>)
		case textColor(Dynamic<UIColor>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension Label {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Label.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UILabel
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Label.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .adjustsFontSizeToFitWidth(let x): return x.apply(instance) { i, v in i.adjustsFontSizeToFitWidth = v }
		case .allowsDefaultTighteningForTruncation(let x): return x.apply(instance) { i, v in i.allowsDefaultTighteningForTruncation = v }
		case .attributedText(let x): return x.apply(instance) { i, v in i.attributedText = v }
		case .baselineAdjustment(let x): return x.apply(instance) { i, v in i.baselineAdjustment = v }
		case .font(let x): return x.apply(instance) { i, v in i.font = v }
		case .highlightedTextColor(let x): return x.apply(instance) { i, v in i.highlightedTextColor = v }
		case .isEnabled(let x): return x.apply(instance) { i, v in i.isEnabled = v }
		case .isHighlighted(let x): return x.apply(instance) { i, v in i.isHighlighted = v }
		case .lineBreakMode(let x): return x.apply(instance) { i, v in i.lineBreakMode = v }
		case .minimumScaleFactor(let x): return x.apply(instance) { i, v in i.minimumScaleFactor = v }
		case .numberOfLines(let x): return x.apply(instance) { i, v in i.numberOfLines = v }
		case .preferredMaxLayoutWidth(let x): return x.apply(instance) { i, v in i.preferredMaxLayoutWidth = v }
		case .shadowColor(let x): return x.apply(instance) { i, v in i.shadowColor = v }
		case .shadowOffset(let x): return x.apply(instance) { i, v in i.shadowOffset = v }
		case .text(let x): return x.apply(instance) { i, v in i.text = v }
		case .textAlignment(let x): return x.apply(instance) { i, v in i.textAlignment = v }
		case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Label.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: LabelBinding {
	public typealias LabelName<V> = BindingName<V, Label.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> Label.Binding) -> LabelName<V> {
		return LabelName<V>(source: source, downcast: Binding.windowBinding)
	}
}
public extension BindingName where Binding: LabelBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: LabelName<$2> { return .name(Label.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var adjustsFontSizeToFitWidth: LabelName<Dynamic<Bool>> { return .name(Label.Binding.adjustsFontSizeToFitWidth) }
	static var allowsDefaultTighteningForTruncation: LabelName<Dynamic<Bool>> { return .name(Label.Binding.allowsDefaultTighteningForTruncation) }
	static var attributedText: LabelName<Dynamic<NSAttributedString?>> { return .name(Label.Binding.attributedText) }
	static var baselineAdjustment: LabelName<Dynamic<UIBaselineAdjustment>> { return .name(Label.Binding.baselineAdjustment) }
	static var font: LabelName<Dynamic<UIFont>> { return .name(Label.Binding.font) }
	static var highlightedTextColor: LabelName<Dynamic<UIColor?>> { return .name(Label.Binding.highlightedTextColor) }
	static var isEnabled: LabelName<Dynamic<Bool>> { return .name(Label.Binding.isEnabled) }
	static var isHighlighted: LabelName<Dynamic<Bool>> { return .name(Label.Binding.isHighlighted) }
	static var lineBreakMode: LabelName<Dynamic<NSLineBreakMode>> { return .name(Label.Binding.lineBreakMode) }
	static var minimumScaleFactor: LabelName<Dynamic<CGFloat>> { return .name(Label.Binding.minimumScaleFactor) }
	static var numberOfLines: LabelName<Dynamic<Int>> { return .name(Label.Binding.numberOfLines) }
	static var preferredMaxLayoutWidth: LabelName<Dynamic<CGFloat>> { return .name(Label.Binding.preferredMaxLayoutWidth) }
	static var shadowColor: LabelName<Dynamic<UIColor?>> { return .name(Label.Binding.shadowColor) }
	static var shadowOffset: LabelName<Dynamic<CGSize>> { return .name(Label.Binding.shadowOffset) }
	static var text: LabelName<Dynamic<String>> { return .name(Label.Binding.text) }
	static var textAlignment: LabelName<Dynamic<NSTextAlignment>> { return .name(Label.Binding.textAlignment) }
	static var textColor: LabelName<Dynamic<UIColor>> { return .name(Label.Binding.textColor) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol LabelConvertible: ViewConvertible {
	func uiLabel() -> Label.Instance
}
extension LabelConvertible {
	public func uiView() -> View.Instance { return uiLabel() }
}
extension UILabel: LabelConvertible {
	public func uiLabel() -> Label.Instance { return self }
}
public extension Label {
	func uiLabel() -> Label.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol LabelBinding: ViewBinding {
	static func windowBinding(_ binding: Label.Binding) -> Self
	func asLabelBinding() -> Label.Binding?
}
public extension LabelBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return windowBinding(.inheritedBinding(binding))
	}
}
public extension LabelBinding where Preparer.Inherited.Binding: LabelBinding {
	func asLabelBinding() -> Label.Binding? {
		return asInheritedBinding()?.asLabelBinding()
	}
}
public extension Label.Binding {
	typealias Preparer = Label.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asLabelBinding() -> Label.Binding? { return self }
	static func windowBinding(_ binding: Label.Binding) -> Label.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
