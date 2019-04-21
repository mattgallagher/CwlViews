//
//  CwlClipView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/11/2015.
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

#if os(macOS)

extension BindingParser where Binding == ClipView.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundColor: BindingParser<Dynamic<NSColor>, Binding> { return BindingParser<Dynamic<NSColor>, Binding>(parse: { binding -> Optional<Dynamic<NSColor>> in if case .backgroundColor(let x) = binding { return x } else { return nil } }) }
	public static var bottomConstraintPriority: BindingParser<Dynamic<Layout.Dimension.Priority>, Binding> { return BindingParser<Dynamic<Layout.Dimension.Priority>, Binding>(parse: { binding -> Optional<Dynamic<Layout.Dimension.Priority>> in if case .bottomConstraintPriority(let x) = binding { return x } else { return nil } }) }
	public static var copiesOnScroll: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .copiesOnScroll(let x) = binding { return x } else { return nil } }) }
	public static var documentCursor: BindingParser<Dynamic<NSCursor?>, Binding> { return BindingParser<Dynamic<NSCursor?>, Binding>(parse: { binding -> Optional<Dynamic<NSCursor?>> in if case .documentCursor(let x) = binding { return x } else { return nil } }) }
	public static var documentView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .documentView(let x) = binding { return x } else { return nil } }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .drawsBackground(let x) = binding { return x } else { return nil } }) }
	public static var trailingConstraintPriority: BindingParser<Dynamic<Layout.Dimension.Priority>, Binding> { return BindingParser<Dynamic<Layout.Dimension.Priority>, Binding>(parse: { binding -> Optional<Dynamic<Layout.Dimension.Priority>> in if case .trailingConstraintPriority(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var scrollTo: BindingParser<Signal<CGPoint>, Binding> { return BindingParser<Signal<CGPoint>, Binding>(parse: { binding -> Optional<Signal<CGPoint>> in if case .scrollTo(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
