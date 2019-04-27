//
//  CwlWindow_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/08/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Downcast: WindowBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Window.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asWindowBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var frame: BindingParser<Dynamic<CGRect>, Window.Binding, Downcast> { return .init(extract: { if case .frame(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var rootViewController: BindingParser<Dynamic<ViewControllerConvertible>, Window.Binding, Downcast> { return .init(extract: { if case .rootViewController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var screen: BindingParser<Dynamic<UIScreen>, Window.Binding, Downcast> { return .init(extract: { if case .screen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var windowLevel: BindingParser<Dynamic<UIWindow.Level>, Window.Binding, Downcast> { return .init(extract: { if case .windowLevel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var makeKey: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .makeKey(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBecomeVisible: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didBecomeVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didBecomeHidden: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didBecomeHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didBecomeKey: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didBecomeKey(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didResignKey: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didResignKey(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var keyboardWillShow: BindingParser<SignalInput<[AnyHashable: Any]?>, Window.Binding, Downcast> { return .init(extract: { if case .keyboardWillShow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var keyboardDidShow: BindingParser<SignalInput<[AnyHashable: Any]?>, Window.Binding, Downcast> { return .init(extract: { if case .keyboardDidShow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var keyboardWillHide: BindingParser<SignalInput<[AnyHashable: Any]?>, Window.Binding, Downcast> { return .init(extract: { if case .keyboardWillHide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var keyboardDidHide: BindingParser<SignalInput<[AnyHashable: Any]?>, Window.Binding, Downcast> { return .init(extract: { if case .keyboardDidHide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var keyboardWillChangeFrame: BindingParser<SignalInput<[AnyHashable: Any]?>, Window.Binding, Downcast> { return .init(extract: { if case .keyboardWillChangeFrame(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var keyboardDidChangeFrame: BindingParser<SignalInput<[AnyHashable: Any]?>, Window.Binding, Downcast> { return .init(extract: { if case .keyboardDidChangeFrame(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
