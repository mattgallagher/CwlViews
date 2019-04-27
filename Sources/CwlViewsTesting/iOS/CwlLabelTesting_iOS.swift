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

extension BindingParser where Downcast: LabelBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Label.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asLabelBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var adjustsFontSizeToFitWidth: BindingParser<Dynamic<Bool>, Label.Binding, Downcast> { return .init(extract: { if case .adjustsFontSizeToFitWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var allowsDefaultTighteningForTruncation: BindingParser<Dynamic<Bool>, Label.Binding, Downcast> { return .init(extract: { if case .allowsDefaultTighteningForTruncation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var attributedText: BindingParser<Dynamic<NSAttributedString?>, Label.Binding, Downcast> { return .init(extract: { if case .attributedText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var baselineAdjustment: BindingParser<Dynamic<UIBaselineAdjustment>, Label.Binding, Downcast> { return .init(extract: { if case .baselineAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var font: BindingParser<Dynamic<UIFont>, Label.Binding, Downcast> { return .init(extract: { if case .font(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var highlightedTextColor: BindingParser<Dynamic<UIColor?>, Label.Binding, Downcast> { return .init(extract: { if case .highlightedTextColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var isEnabled: BindingParser<Dynamic<Bool>, Label.Binding, Downcast> { return .init(extract: { if case .isEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var isHighlighted: BindingParser<Dynamic<Bool>, Label.Binding, Downcast> { return .init(extract: { if case .isHighlighted(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var lineBreakMode: BindingParser<Dynamic<NSLineBreakMode>, Label.Binding, Downcast> { return .init(extract: { if case .lineBreakMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var minimumScaleFactor: BindingParser<Dynamic<CGFloat>, Label.Binding, Downcast> { return .init(extract: { if case .minimumScaleFactor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var numberOfLines: BindingParser<Dynamic<Int>, Label.Binding, Downcast> { return .init(extract: { if case .numberOfLines(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var preferredMaxLayoutWidth: BindingParser<Dynamic<CGFloat>, Label.Binding, Downcast> { return .init(extract: { if case .preferredMaxLayoutWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var shadowColor: BindingParser<Dynamic<UIColor?>, Label.Binding, Downcast> { return .init(extract: { if case .shadowColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var shadowOffset: BindingParser<Dynamic<CGSize>, Label.Binding, Downcast> { return .init(extract: { if case .shadowOffset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var text: BindingParser<Dynamic<String>, Label.Binding, Downcast> { return .init(extract: { if case .text(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var textAlignment: BindingParser<Dynamic<NSTextAlignment>, Label.Binding, Downcast> { return .init(extract: { if case .textAlignment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	public static var textColor: BindingParser<Dynamic<UIColor>, Label.Binding, Downcast> { return .init(extract: { if case .textColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asLabelBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
