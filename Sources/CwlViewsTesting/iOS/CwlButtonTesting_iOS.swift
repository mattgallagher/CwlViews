//
//  CwlButton_iOS.swift
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

extension BindingParser where Downcast: ButtonBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Button.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asButtonBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var imageView: BindingParser<Constant<ImageView>, Button.Binding, Downcast> { return .init(extract: { if case .imageView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var titleLabel: BindingParser<Constant<Label>, Button.Binding, Downcast> { return .init(extract: { if case .titleLabel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var type: BindingParser<Constant<UIButton.ButtonType>, Button.Binding, Downcast> { return .init(extract: { if case .type(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var adjustsImageWhenDisabled: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .adjustsImageWhenDisabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var adjustsImageWhenHighlighted: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .adjustsImageWhenHighlighted(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var attributedTitle: BindingParser<Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>, Button.Binding, Downcast> { return .init(extract: { if case .attributedTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Button.Binding, Downcast> { return .init(extract: { if case .backgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var contentEdgeInsets: BindingParser<Dynamic<UIEdgeInsets>, Button.Binding, Downcast> { return .init(extract: { if case .contentEdgeInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var image: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Button.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var imageEdgeInsets: BindingParser<Dynamic<UIEdgeInsets>, Button.Binding, Downcast> { return .init(extract: { if case .imageEdgeInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var showsTouchWhenHighlighted: BindingParser<Dynamic<Bool>, Button.Binding, Downcast> { return .init(extract: { if case .showsTouchWhenHighlighted(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var title: BindingParser<Dynamic<ScopedValues<UIControl.State, String?>>, Button.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var titleColor: BindingParser<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Button.Binding, Downcast> { return .init(extract: { if case .titleColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var titleEdgeInsets: BindingParser<Dynamic<UIEdgeInsets>, Button.Binding, Downcast> { return .init(extract: { if case .titleEdgeInsets(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	public static var titleShadowColor: BindingParser<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Button.Binding, Downcast> { return .init(extract: { if case .titleShadowColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asButtonBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
