//
//  CwlGradientLayer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/03.
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

extension BindingParser where Downcast: GradientLayerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, GradientLayer.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asGradientLayerBinding() }) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var colors: BindingParser<Dynamic<[CGColor]>, GradientLayer.Binding, Downcast> { return .init(extract: { if case .colors(let x) = $0 { return x } else { return nil } }, upcast: { $0.asGradientLayerBinding() }) }
	public static var locations: BindingParser<Dynamic<[CGFloat]>, GradientLayer.Binding, Downcast> { return .init(extract: { if case .locations(let x) = $0 { return x } else { return nil } }, upcast: { $0.asGradientLayerBinding() }) }
	public static var endPoint: BindingParser<Dynamic<CGPoint>, GradientLayer.Binding, Downcast> { return .init(extract: { if case .endPoint(let x) = $0 { return x } else { return nil } }, upcast: { $0.asGradientLayerBinding() }) }
	public static var startPoint: BindingParser<Dynamic<CGPoint>, GradientLayer.Binding, Downcast> { return .init(extract: { if case .startPoint(let x) = $0 { return x } else { return nil } }, upcast: { $0.asGradientLayerBinding() }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}
