//
//  CwlTabBarItem_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
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

#if os(iOS)

extension BindingParser where Downcast: TabBarItemBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabBarItem.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTabBarItemBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var systemItem: BindingParser<Constant<UITabBarItem.SystemItem?>, TabBarItem.Binding, Downcast> { return .init(extract: { if case .systemItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarItemBinding() }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var badgeColor: BindingParser<Dynamic<UIColor?>, TabBarItem.Binding, Downcast> { return .init(extract: { if case .badgeColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarItemBinding() }) }
	public static var badgeTextAttributes: BindingParser<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key : Any]?>>, TabBarItem.Binding, Downcast> { return .init(extract: { if case .badgeTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarItemBinding() }) }
	public static var badgeValue: BindingParser<Dynamic<String?>, TabBarItem.Binding, Downcast> { return .init(extract: { if case .badgeValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarItemBinding() }) }
	public static var selectedImage: BindingParser<Dynamic<UIImage?>, TabBarItem.Binding, Downcast> { return .init(extract: { if case .selectedImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarItemBinding() }) }
	public static var titlePositionAdjustment: BindingParser<Dynamic<UIOffset>, TabBarItem.Binding, Downcast> { return .init(extract: { if case .titlePositionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabBarItemBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
