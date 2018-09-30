//
//  CwlBarButtonItemTesting.swift
//  CwlViewsTesting_iOS
//
//  Created by Matt Gallagher on 2018/03/26.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Binding == BarButtonItem.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	public static var barButtonSystemItem: BindingParser<Constant<UIBarButtonItem.SystemItem>, Binding> { return BindingParser<Constant<UIBarButtonItem.SystemItem>, Binding>(parse: { binding -> Optional<Constant<UIBarButtonItem.SystemItem>> in if case .barButtonSystemItem(let x) = binding { return x } else { return nil } }) }
	public static var itemStyle: BindingParser<Dynamic<UIBarButtonItem.Style>, Binding> { return BindingParser<Dynamic<UIBarButtonItem.Style>, Binding>(parse: { binding -> Optional<Dynamic<UIBarButtonItem.Style>> in if case .itemStyle(let x) = binding { return x } else { return nil } }) }
	public static var possibleTitles: BindingParser<Dynamic<Set<String>?>, Binding> { return BindingParser<Dynamic<Set<String>?>, Binding>(parse: { binding -> Optional<Dynamic<Set<String>?>> in if case .possibleTitles(let x) = binding { return x } else { return nil } }) }
	public static var width: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .width(let x) = binding { return x } else { return nil } }) }
	public static var customView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .customView(let x) = binding { return x } else { return nil } }) }
	public static var tintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .tintColor(let x) = binding { return x } else { return nil } }) }
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<StateStyleAndMetrics, UIImage?>>> in if case .backgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var backButtonBackgroundImage: BindingParser<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<StateAndMetrics, UIImage?>>> in if case .backButtonBackgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var backButtonTitlePositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>> in if case .backButtonTitlePositionAdjustment(let x) = binding { return x } else { return nil } }) }
	public static var backgroundVerticalPositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIBarMetrics, CGFloat>>> in if case .backgroundVerticalPositionAdjustment(let x) = binding { return x } else { return nil } }) }
	public static var titlePositionAdjustment: BindingParser<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIBarMetrics, UIOffset>>> in if case .titlePositionAdjustment(let x) = binding { return x } else { return nil } }) }
	public static var action: BindingParser<TargetAction, Binding> { return BindingParser<TargetAction, Binding>(parse: { binding -> Optional<TargetAction> in if case .action(let x) = binding { return x } else { return nil } }) }
}
