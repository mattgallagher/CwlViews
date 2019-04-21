//
//  CwlGestureRecognizer_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 23/10/2015.
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

#if os(macOS)

extension BindingParser where Binding == GestureRecognizer.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowedTouchTypes: BindingParser<Dynamic<NSTouch.TouchTypeMask>, Binding> { return BindingParser<Dynamic<NSTouch.TouchTypeMask>, Binding>(parse: { binding -> Optional<Dynamic<NSTouch.TouchTypeMask>> in if case .allowedTouchTypes(let x) = binding { return x } else { return nil } }) }
	public static var pressureConfiguration: BindingParser<Dynamic<NSPressureConfiguration>, Binding> { return BindingParser<Dynamic<NSPressureConfiguration>, Binding>(parse: { binding -> Optional<Dynamic<NSPressureConfiguration>> in if case .pressureConfiguration(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingParser<TargetAction, Binding> { return BindingParser<TargetAction, Binding>(parse: { binding -> Optional<TargetAction> in if case .action(let x) = binding { return x } else { return nil } }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var shouldAttemptToRecognize: BindingParser<(NSGestureRecognizer, NSEvent) -> Bool, Binding> { return BindingParser<(NSGestureRecognizer, NSEvent) -> Bool, Binding>(parse: { binding -> Optional<(NSGestureRecognizer, NSEvent) -> Bool> in if case .shouldAttemptToRecognize(let x) = binding { return x } else { return nil } }) }
	public static var shouldBegin: BindingParser<(NSGestureRecognizer) -> Bool, Binding> { return BindingParser<(NSGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(NSGestureRecognizer) -> Bool> in if case .shouldBegin(let x) = binding { return x } else { return nil } }) }
	public static var shouldRecognizeSimultaneously: BindingParser<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding> { return BindingParser<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(NSGestureRecognizer, NSGestureRecognizer) -> Bool> in if case .shouldRecognizeSimultaneously(let x) = binding { return x } else { return nil } }) }
	public static var shouldRequireFailure: BindingParser<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding> { return BindingParser<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(NSGestureRecognizer, NSGestureRecognizer) -> Bool> in if case .shouldRequireFailure(let x) = binding { return x } else { return nil } }) }
	public static var shouldRequireToFail: BindingParser<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding> { return BindingParser<(NSGestureRecognizer, NSGestureRecognizer) -> Bool, Binding>(parse: { binding -> Optional<(NSGestureRecognizer, NSGestureRecognizer) -> Bool> in if case .shouldRequireToFail(let x) = binding { return x } else { return nil } }) }
	public static var shouldReceiveTouch: BindingParser<(NSGestureRecognizer, NSTouch) -> Bool, Binding> { return BindingParser<(NSGestureRecognizer, NSTouch) -> Bool, Binding>(parse: { binding -> Optional<(NSGestureRecognizer, NSTouch) -> Bool> in if case .shouldReceiveTouch(let x) = binding { return x } else { return nil } }) }
}

#endif
