//
//  CwlStackView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/10/2015.
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

extension BindingParser where Downcast: StackViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, StackView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asStackViewBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var alignment: BindingParser<Dynamic<StackView.NSUIStackViewAlignment>, StackView.Binding, Downcast> { return .init(extract: { if case .alignment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	public static var arrangedSubviews: BindingParser<Dynamic<[ViewConvertible]>, StackView.Binding, Downcast> { return .init(extract: { if case .arrangedSubviews(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	public static var axis: BindingParser<Dynamic<StackView.NSUIUserInterfaceLayoutOrientation>, StackView.Binding, Downcast> { return .init(extract: { if case .axis(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	public static var distribution: BindingParser<Dynamic<StackView.NSUIStackViewDistribution>, StackView.Binding, Downcast> { return .init(extract: { if case .distribution(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	public static var spacing: BindingParser<Dynamic<CGFloat>, StackView.Binding, Downcast> { return .init(extract: { if case .spacing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var edgeInsets: BindingParser<Dynamic<StackView.NSUIEdgeInsets>, StackView.Binding, Downcast> { return .init(extract: { if case .edgeInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var horizontalClippingResistance: BindingParser<Dynamic<StackView.NSUILayoutPriority>, StackView.Binding, Downcast> { return .init(extract: { if case .horizontalClippingResistance(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var horizontalHuggingPriority: BindingParser<Dynamic<StackView.NSUILayoutPriority>, StackView.Binding, Downcast> { return .init(extract: { if case .horizontalHuggingPriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	@available(macOS, unavailable) @available(iOS 11, *) public static var isLayoutMarginsRelativeArrangement: BindingParser<Dynamic<Bool>, StackView.Binding, Downcast> { return .init(extract: { if case .isLayoutMarginsRelativeArrangement(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var verticalClippingResistance: BindingParser<Dynamic<StackView.NSUILayoutPriority>, StackView.Binding, Downcast> { return .init(extract: { if case .verticalClippingResistance(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var verticalHuggingPriority: BindingParser<Dynamic<StackView.NSUILayoutPriority>, StackView.Binding, Downcast> { return .init(extract: { if case .verticalHuggingPriority(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStackViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}
