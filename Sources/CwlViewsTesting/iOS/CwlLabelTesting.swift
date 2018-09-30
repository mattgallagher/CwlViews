//
//  CwlLabelTesting.swift
//  CwlViewsTesting_iOS
//
//  Created by Matt Gallagher on 2018/03/26.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Binding == Label.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var text: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .text(let x) = binding { return x } else { return nil } }) }
	public static var attributedText: BindingParser<Dynamic<NSAttributedString?>, Binding> { return BindingParser<Dynamic<NSAttributedString?>, Binding>(parse: { binding -> Optional<Dynamic<NSAttributedString?>> in if case .attributedText(let x) = binding { return x } else { return nil } }) }
	public static var font: BindingParser<Dynamic<UIFont>, Binding> { return BindingParser<Dynamic<UIFont>, Binding>(parse: { binding -> Optional<Dynamic<UIFont>> in if case .font(let x) = binding { return x } else { return nil } }) }
	public static var textColor: BindingParser<Dynamic<UIColor>, Binding> { return BindingParser<Dynamic<UIColor>, Binding>(parse: { binding -> Optional<Dynamic<UIColor>> in if case .textColor(let x) = binding { return x } else { return nil } }) }
	public static var textAlignment: BindingParser<Dynamic<NSTextAlignment>, Binding> { return BindingParser<Dynamic<NSTextAlignment>, Binding>(parse: { binding -> Optional<Dynamic<NSTextAlignment>> in if case .textAlignment(let x) = binding { return x } else { return nil } }) }
	public static var lineBreakMode: BindingParser<Dynamic<NSLineBreakMode>, Binding> { return BindingParser<Dynamic<NSLineBreakMode>, Binding>(parse: { binding -> Optional<Dynamic<NSLineBreakMode>> in if case .lineBreakMode(let x) = binding { return x } else { return nil } }) }
	public static var isEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEnabled(let x) = binding { return x } else { return nil } }) }
	public static var adjustsFontSizeToFitWidth: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .adjustsFontSizeToFitWidth(let x) = binding { return x } else { return nil } }) }
	public static var allowsDefaultTighteningForTruncation: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsDefaultTighteningForTruncation(let x) = binding { return x } else { return nil } }) }
	public static var baselineAdjustment: BindingParser<Dynamic<UIBaselineAdjustment>, Binding> { return BindingParser<Dynamic<UIBaselineAdjustment>, Binding>(parse: { binding -> Optional<Dynamic<UIBaselineAdjustment>> in if case .baselineAdjustment(let x) = binding { return x } else { return nil } }) }
	public static var minimumScaleFactor: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .minimumScaleFactor(let x) = binding { return x } else { return nil } }) }
	public static var numberOfLines: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .numberOfLines(let x) = binding { return x } else { return nil } }) }
	public static var highlightedTextColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .highlightedTextColor(let x) = binding { return x } else { return nil } }) }
	public static var isHighlighted: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isHighlighted(let x) = binding { return x } else { return nil } }) }
	public static var shadowColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .shadowColor(let x) = binding { return x } else { return nil } }) }
	public static var shadowOffset: BindingParser<Dynamic<CGSize>, Binding> { return BindingParser<Dynamic<CGSize>, Binding>(parse: { binding -> Optional<Dynamic<CGSize>> in if case .shadowOffset(let x) = binding { return x } else { return nil } }) }
	public static var preferredMaxLayoutWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .preferredMaxLayoutWidth(let x) = binding { return x } else { return nil } }) }
}
