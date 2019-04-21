//
//  CwlTabViewItem_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 30/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Binding == TabViewItem.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var color: BindingParser<Dynamic<NSColor>, Binding> { return BindingParser<Dynamic<NSColor>, Binding>(parse: { binding -> Optional<Dynamic<NSColor>> in if case .color(let x) = binding { return x } else { return nil } }) }
	public static var image: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .image(let x) = binding { return x } else { return nil } }) }
	public static var initialFirstResponderTag: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .initialFirstResponderTag(let x) = binding { return x } else { return nil } }) }
	public static var label: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .label(let x) = binding { return x } else { return nil } }) }
	public static var toolTip: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .toolTip(let x) = binding { return x } else { return nil } }) }
	public static var view: BindingParser<Dynamic<ViewConvertible>, Binding> { return BindingParser<Dynamic<ViewConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible>> in if case .view(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	/* case someFunction(Signal<FunctionParametersAsTuple>) */

	// 3. Action bindings are triggered by the object after construction.
	/* case someAction(SignalInput<CallbackParameters>) */

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	/* case someDelegateFunction((Param) -> Result)) */
}

#endif
