//
//  BarItem_iOS.swift
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

#if os(iOS)

extension BindingParser where Downcast: BarItemBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, BarItem.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asBarItemBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var image: BindingParser<Dynamic<UIImage?>, BarItem.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }
	public static var imageInsets: BindingParser<Dynamic<UIEdgeInsets>, BarItem.Binding, Downcast> { return .init(extract: { if case .imageInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }
	public static var isEnabled: BindingParser<Dynamic<Bool>, BarItem.Binding, Downcast> { return .init(extract: { if case .isEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }
	public static var landscapeImagePhone: BindingParser<Dynamic<UIImage?>, BarItem.Binding, Downcast> { return .init(extract: { if case .landscapeImagePhone(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }
	public static var landscapeImagePhoneInsets: BindingParser<Dynamic<UIEdgeInsets>, BarItem.Binding, Downcast> { return .init(extract: { if case .landscapeImagePhoneInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }
	public static var tag: BindingParser<Dynamic<Int>, BarItem.Binding, Downcast> { return .init(extract: { if case .tag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }
	public static var title: BindingParser<Dynamic<String>, BarItem.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }
	public static var titleTextAttributes: BindingParser<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]>>, BarItem.Binding, Downcast> { return .init(extract: { if case .titleTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarItemBinding() }) }

	//	2. Signal bindings are performed on the object after construction.

	//	3. Action bindings are triggered by the object after construction.

	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
