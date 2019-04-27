//
//  CwlBarButtonItem_iOS.swift
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

extension BindingParser where Downcast: BarButtonItemBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asBarButtonItemBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var systemItem: BindingParser<Constant<UIBarButtonItem.SystemItem>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .systemItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var backButtonBackgroundImage: BindingParser<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .backButtonBackgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var backButtonTitlePositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .backButtonTitlePositionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .backgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var backgroundVerticalPositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .backgroundVerticalPositionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var customView: BindingParser<Dynamic<ViewConvertible?>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .customView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var itemStyle: BindingParser<Dynamic<UIBarButtonItem.Style>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .itemStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var possibleTitles: BindingParser<Dynamic<Set<String>?>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .possibleTitles(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var tintColor: BindingParser<Dynamic<UIColor?>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var titlePositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .titlePositionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	public static var width: BindingParser<Dynamic<CGFloat>, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .width(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, BarButtonItem.Binding, Downcast> { return .init(extract: { if case .action(let x) = $0 { return x } else { return nil } }, upcast: { $0.asBarButtonItemBinding() }) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
