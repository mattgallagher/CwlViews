//
//  CwlExtendedViewController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 12/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Downcast: ExtendedViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asExtendedViewControllerBinding() }) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didAppear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .didAppear(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewControllerBinding() }) }
	public static var didDisappear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .didDisappear(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewControllerBinding() }) }
	public static var didReceiveMemoryWarning: BindingParser<(UIViewController) -> Void, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .didReceiveMemoryWarning(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewControllerBinding() }) }
	public static var loadView: BindingParser<() -> ViewConvertible, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .loadView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewControllerBinding() }) }
	public static var traitCollectionDidChange: BindingParser<(UIViewController, UITraitCollection?) -> Void, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .traitCollectionDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewControllerBinding() }) }
	public static var willAppear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .willAppear(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewControllerBinding() }) }
	public static var willDisappear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .willDisappear(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewControllerBinding() }) }
}

#endif
