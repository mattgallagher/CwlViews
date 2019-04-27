//
//  CwlImageView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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

extension BindingParser where Downcast: ImageViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ImageView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asImageViewBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var image: BindingParser<Dynamic<UIImage?>, ImageView.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var highlightedImage: BindingParser<Dynamic<UIImage?>, ImageView.Binding, Downcast> { return .init(extract: { if case .highlightedImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var animationImages: BindingParser<Dynamic<[UIImage]?>, ImageView.Binding, Downcast> { return .init(extract: { if case .animationImages(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var highlightedAnimationImages: BindingParser<Dynamic<[UIImage]?>, ImageView.Binding, Downcast> { return .init(extract: { if case .highlightedAnimationImages(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var animationDuration: BindingParser<Dynamic<TimeInterval>, ImageView.Binding, Downcast> { return .init(extract: { if case .animationDuration(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var animationRepeatCount: BindingParser<Dynamic<Int>, ImageView.Binding, Downcast> { return .init(extract: { if case .animationRepeatCount(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var isHighlighted: BindingParser<Dynamic<Bool>, ImageView.Binding, Downcast> { return .init(extract: { if case .isHighlighted(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var animating: BindingParser<Signal<Bool>, ImageView.Binding, Downcast> { return .init(extract: { if case .animating(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
