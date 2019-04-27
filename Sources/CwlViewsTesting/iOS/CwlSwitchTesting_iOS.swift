//
//  CwlSwitch_iOS.swift
//  CwlViews_iOS
//
//  Created by Matt Gallagher on 2017/12/20.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
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

extension BindingParser where Downcast: SwitchBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Switch.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asSwitchBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isOn: BindingParser<Dynamic<SetOrAnimate<Bool>>, Switch.Binding, Downcast> { return .init(extract: { if case .isOn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSwitchBinding() }) }
	public static var offImage: BindingParser<Dynamic<UIImage?>, Switch.Binding, Downcast> { return .init(extract: { if case .offImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSwitchBinding() }) }
	public static var onImage: BindingParser<Dynamic<UIImage?>, Switch.Binding, Downcast> { return .init(extract: { if case .onImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSwitchBinding() }) }
	public static var onTintColor: BindingParser<Dynamic<UIColor>, Switch.Binding, Downcast> { return .init(extract: { if case .onTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSwitchBinding() }) }
	public static var thumbTintColor: BindingParser<Dynamic<UIColor>, Switch.Binding, Downcast> { return .init(extract: { if case .thumbTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSwitchBinding() }) }
	public static var tintColor: BindingParser<Dynamic<UIColor>, Switch.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSwitchBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
