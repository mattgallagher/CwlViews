//
//  CwlNavigationItemTesting.swift
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

extension BindingParser where Binding == NavigationItem.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .title(let x) = binding { return x } else { return nil } }) }
	public static var titleView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .titleView(let x) = binding { return x } else { return nil } }) }
	public static var prompt: BindingParser<Dynamic<String?>, Binding> { return BindingParser<Dynamic<String?>, Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .prompt(let x) = binding { return x } else { return nil } }) }
	public static var backBarButtonItem: BindingParser<Dynamic<BarButtonItemConvertible?>, Binding> { return BindingParser<Dynamic<BarButtonItemConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<BarButtonItemConvertible?>> in if case .backBarButtonItem(let x) = binding { return x } else { return nil } }) }
	public static var hidesBackButton: BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Bool>>> in if case .hidesBackButton(let x) = binding { return x } else { return nil } }) }
	public static var leftBarButtonItems: BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> in if case .leftBarButtonItems(let x) = binding { return x } else { return nil } }) }
	public static var rightBarButtonItems: BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<[BarButtonItemConvertible]>>> in if case .rightBarButtonItems(let x) = binding { return x } else { return nil } }) }
	public static var leftItemsSupplementBackButton: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .leftItemsSupplementBackButton(let x) = binding { return x } else { return nil } }) }
}
