//
//  CwlAlertAction_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/05/05.
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

extension BindingParser where Binding == AlertAction.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var style: BindingParser<Constant<UIAlertAction.Style>, Binding> { return BindingParser<Constant<UIAlertAction.Style>, Binding>(parse: { binding -> Optional<Constant<UIAlertAction.Style>> in if case .style(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Constant<String>, Binding> { return BindingParser<Constant<String>, Binding>(parse: { binding -> Optional<Constant<String>> in if case .title(let x) = binding { return x } else { return nil } }) }

	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var isEnabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEnabled(let x) = binding { return x } else { return nil } }) }

	//	2. Signal bindings are performed on the object after construction.

	//	3. Action bindings are triggered by the object after construction.
	public static var handler: BindingParser<SignalInput<Void>, Binding> { return BindingParser<SignalInput<Void>, Binding>(parse: { binding -> Optional<SignalInput<Void>> in if case .handler(let x) = binding { return x } else { return nil } }) }

	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
