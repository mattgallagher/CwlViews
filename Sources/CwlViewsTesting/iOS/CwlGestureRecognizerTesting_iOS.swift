//
//  CwlGestureRecognizer_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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

extension BindingParser where Binding == GestureRecognizer.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowedPressTypes: BindingParser<Dynamic<[NSNumber]>, Binding> { return BindingParser<Dynamic<[NSNumber]>, Binding>(parse: { binding -> Optional<Dynamic<[NSNumber]>> in if case .allowedPressTypes(let x) = binding { return x } else { return nil } }) }
	public static var allowedTouchTypes: BindingParser<Dynamic<[NSNumber]>, Binding> { return BindingParser<Dynamic<[NSNumber]>, Binding>(parse: { binding -> Optional<Dynamic<[NSNumber]>> in if case .allowedTouchTypes(let x) = binding { return x } else { return nil } }) }
	public static var cancelsTouchesInView: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .cancelsTouchesInView(let x) = binding { return x } else { return nil } }) }
	public static var delaysTouchesBegan: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .delaysTouchesBegan(let x) = binding { return x } else { return nil } }) }
	public static var delaysTouchesEnded: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .delaysTouchesEnded(let x) = binding { return x } else { return nil } }) }
	public static var requiresExclusiveTouchType: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .requiresExclusiveTouchType(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<SignalInput<Any?>, Binding> { return BindingParser<SignalInput<Any?>, Binding>(parse: { binding -> Optional<SignalInput<Any?>> in if case .action(let x) = binding { return x } else { return nil } }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var shouldBegin: BindingParser<(UIGestureRecognizer) -> Bool, Binding> { return BindingParser<(UIGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(UIGestureRecognizer) -> Bool> in if case .shouldBegin(let x) = binding { return x } else { return nil } }) }
	public static var shouldBeRequiredToFail: BindingParser<(UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool, Binding> { return BindingParser<(UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(UIGestureRecognizer, _ by: UIGestureRecognizer) -> Bool> in if case .shouldBeRequiredToFail(let x) = binding { return x } else { return nil } }) }
	public static var shouldReceivePress: BindingParser<(UIGestureRecognizer, UIPress) -> Bool, Binding> { return BindingParser<(UIGestureRecognizer, UIPress) -> Bool, Binding>(parse: { binding -> Optional<(UIGestureRecognizer, UIPress) -> Bool> in if case .shouldReceivePress(let x) = binding { return x } else { return nil } }) }
	public static var shouldReceiveTouch: BindingParser<(UIGestureRecognizer, UITouch) -> Bool, Binding> { return BindingParser<(UIGestureRecognizer, UITouch) -> Bool, Binding>(parse: { binding -> Optional<(UIGestureRecognizer, UITouch) -> Bool> in if case .shouldReceiveTouch(let x) = binding { return x } else { return nil } }) }
	public static var shouldRecognizeSimultanously: BindingParser<(UIGestureRecognizer, UIGestureRecognizer) -> Bool, Binding> { return BindingParser<(UIGestureRecognizer, UIGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(UIGestureRecognizer, UIGestureRecognizer) -> Bool> in if case .shouldRecognizeSimultanously(let x) = binding { return x } else { return nil } }) }
	public static var shouldRequireFailure: BindingParser<(UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool, Binding> { return BindingParser<(UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool> in if case .shouldRequireFailure(let x) = binding { return x } else { return nil } }) }
}

#endif
