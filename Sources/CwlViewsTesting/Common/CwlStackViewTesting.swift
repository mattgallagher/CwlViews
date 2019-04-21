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

extension BindingParser where Binding == StackView.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var alignment: BindingParser<Dynamic<StackView.NSUIStackViewAlignment>, Binding> { return BindingParser<Dynamic<StackView.NSUIStackViewAlignment>, Binding>(parse: { binding -> Optional<Dynamic<StackView.NSUIStackViewAlignment>> in if case .alignment(let x) = binding { return x } else { return nil } }) }
	public static var arrangedSubviews: BindingParser<Dynamic<[ViewConvertible]>, Binding> { return BindingParser<Dynamic<[ViewConvertible]>, Binding>(parse: { binding -> Optional<Dynamic<[ViewConvertible]>> in if case .arrangedSubviews(let x) = binding { return x } else { return nil } }) }
	public static var axis: BindingParser<Dynamic<StackView.NSUIUserInterfaceLayoutOrientation>, Binding> { return BindingParser<Dynamic<StackView.NSUIUserInterfaceLayoutOrientation>, Binding>(parse: { binding -> Optional<Dynamic<StackView.NSUIUserInterfaceLayoutOrientation>> in if case .axis(let x) = binding { return x } else { return nil } }) }
	public static var distribution: BindingParser<Dynamic<StackView.NSUIStackViewDistribution>, Binding> { return BindingParser<Dynamic<StackView.NSUIStackViewDistribution>, Binding>(parse: { binding -> Optional<Dynamic<StackView.NSUIStackViewDistribution>> in if case .distribution(let x) = binding { return x } else { return nil } }) }
	public static var spacing: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .spacing(let x) = binding { return x } else { return nil } }) }
	
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var edgeInsets: BindingParser<Dynamic<StackView.EdgeInsets>, Binding> { return BindingParser<Dynamic<StackView.EdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<StackView.EdgeInsets>> in if case .edgeInsets(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var horizontalClippingResistance: BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<StackView.NSUILayoutPriority>> in if case .horizontalClippingResistance(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var horizontalHuggingPriority: BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<StackView.NSUILayoutPriority>> in if case .horizontalHuggingPriority(let x) = binding { return x } else { return nil } }) }
	@available(macOS, unavailable) @available(iOS 11, *) public static var isLayoutMarginsRelativeArrangement: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isLayoutMarginsRelativeArrangement(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var verticalClippingResistance: BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<StackView.NSUILayoutPriority>> in if case .verticalClippingResistance(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var verticalHuggingPriority: BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding> { return BindingParser<Dynamic<StackView.NSUILayoutPriority>, Binding>(parse: { binding -> Optional<Dynamic<StackView.NSUILayoutPriority>> in if case .verticalHuggingPriority(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}
