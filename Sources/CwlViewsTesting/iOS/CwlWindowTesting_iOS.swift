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

extension BindingParser where Binding == Window.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var frame: BindingParser<Dynamic<CGRect>, Binding> { return BindingParser<Dynamic<CGRect>, Binding>(parse: { binding -> Optional<Dynamic<CGRect>> in if case .frame(let x) = binding { return x } else { return nil } }) }
	public static var rootViewController: BindingParser<Dynamic<ViewControllerConvertible>, Binding> { return BindingParser<Dynamic<ViewControllerConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ViewControllerConvertible>> in if case .rootViewController(let x) = binding { return x } else { return nil } }) }
	public static var screen: BindingParser<Dynamic<UIScreen>, Binding> { return BindingParser<Dynamic<UIScreen>, Binding>(parse: { binding -> Optional<Dynamic<UIScreen>> in if case .screen(let x) = binding { return x } else { return nil } }) }
	public static var windowLevel: BindingParser<Dynamic<UIWindow.Level>, Binding> { return BindingParser<Dynamic<UIWindow.Level>, Binding>(parse: { binding -> Optional<Dynamic<UIWindow.Level>> in if case .windowLevel(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var makeKey: BindingParser<Signal<Void>, Binding> { return BindingParser<Signal<Void>, Binding>(parse: { binding -> Optional<Signal<Void>> in if case .makeKey(let x) = binding { return x } else { return nil } }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBecomeVisible: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didBecomeVisible(let x) = binding { return x } else { return nil } }) }
	public static var didBecomeHidden: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didBecomeHidden(let x) = binding { return x } else { return nil } }) }
	public static var didBecomeKey: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didBecomeKey(let x) = binding { return x } else { return nil } }) }
	public static var didResignKey: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .didResignKey(let x) = binding { return x } else { return nil } }) }
	public static var keyboardWillShow: BindingParser<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingParser<SignalInput<[AnyHashable: Any]?>, Binding>(parse: { binding -> Optional<SignalInput<[AnyHashable: Any]?>> in if case .keyboardWillShow(let x) = binding { return x } else { return nil } }) }
	public static var keyboardDidShow: BindingParser<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingParser<SignalInput<[AnyHashable: Any]?>, Binding>(parse: { binding -> Optional<SignalInput<[AnyHashable: Any]?>> in if case .keyboardDidShow(let x) = binding { return x } else { return nil } }) }
	public static var keyboardWillHide: BindingParser<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingParser<SignalInput<[AnyHashable: Any]?>, Binding>(parse: { binding -> Optional<SignalInput<[AnyHashable: Any]?>> in if case .keyboardWillHide(let x) = binding { return x } else { return nil } }) }
	public static var keyboardDidHide: BindingParser<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingParser<SignalInput<[AnyHashable: Any]?>, Binding>(parse: { binding -> Optional<SignalInput<[AnyHashable: Any]?>> in if case .keyboardDidHide(let x) = binding { return x } else { return nil } }) }
	public static var keyboardWillChangeFrame: BindingParser<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingParser<SignalInput<[AnyHashable: Any]?>, Binding>(parse: { binding -> Optional<SignalInput<[AnyHashable: Any]?>> in if case .keyboardWillChangeFrame(let x) = binding { return x } else { return nil } }) }
	public static var keyboardDidChangeFrame: BindingParser<SignalInput<[AnyHashable: Any]?>, Binding> { return BindingParser<SignalInput<[AnyHashable: Any]?>, Binding>(parse: { binding -> Optional<SignalInput<[AnyHashable: Any]?>> in if case .keyboardDidChangeFrame(let x) = binding { return x } else { return nil } }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
