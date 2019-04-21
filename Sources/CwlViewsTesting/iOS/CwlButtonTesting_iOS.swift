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

extension BindingParser where Binding == Button.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var imageView: BindingParser<Constant<ImageView>, Binding> { return BindingParser<Constant<ImageView>, Binding>(parse: { binding -> Optional<Constant<ImageView>> in if case .imageView(let x) = binding { return x } else { return nil } }) }
	public static var titleLabel: BindingParser<Constant<Label>, Binding> { return BindingParser<Constant<Label>, Binding>(parse: { binding -> Optional<Constant<Label>> in if case .titleLabel(let x) = binding { return x } else { return nil } }) }
	public static var type: BindingParser<Constant<UIButton.ButtonType>, Binding> { return BindingParser<Constant<UIButton.ButtonType>, Binding>(parse: { binding -> Optional<Constant<UIButton.ButtonType>> in if case .type(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var adjustsImageWhenDisabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .adjustsImageWhenDisabled(let x) = binding { return x } else { return nil } }) }
	public static var adjustsImageWhenHighlighted: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .adjustsImageWhenHighlighted(let x) = binding { return x } else { return nil } }) }
	public static var attributedTitle: BindingParser<Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>> in if case .attributedTitle(let x) = binding { return x } else { return nil } }) }
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIImage?>>> in if case .backgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var contentEdgeInsets: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .contentEdgeInsets(let x) = binding { return x } else { return nil } }) }
	public static var image: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIImage?>>> in if case .image(let x) = binding { return x } else { return nil } }) }
	public static var imageEdgeInsets: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .imageEdgeInsets(let x) = binding { return x } else { return nil } }) }
	public static var showsTouchWhenHighlighted: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsTouchWhenHighlighted(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Dynamic<ScopedValues<UIControl.State, String?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, String?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, String?>>> in if case .title(let x) = binding { return x } else { return nil } }) }
	public static var titleColor: BindingParser<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIColor?>>> in if case .titleColor(let x) = binding { return x } else { return nil } }) }
	public static var titleEdgeInsets: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .titleEdgeInsets(let x) = binding { return x } else { return nil } }) }
	public static var titleShadowColor: BindingParser<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIColor?>>> in if case .titleShadowColor(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
