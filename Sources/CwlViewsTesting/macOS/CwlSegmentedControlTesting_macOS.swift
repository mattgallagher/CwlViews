//
//  CwlSegmentedControl.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Binding == SegmentedControl.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isSpringLoaded: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isSpringLoaded(let x) = binding { return x } else { return nil } }) }
	public static var distribution: BindingParser<Dynamic<NSSegmentedControl.Distribution>, Binding> { return BindingParser<Dynamic<NSSegmentedControl.Distribution>, Binding>(parse: { binding -> Optional<Dynamic<NSSegmentedControl.Distribution>> in if case .distribution(let x) = binding { return x } else { return nil } }) }
	public static var segments: BindingParser<Dynamic<[SegmentDescription]>, Binding> { return BindingParser<Dynamic<[SegmentDescription]>, Binding>(parse: { binding -> Optional<Dynamic<[SegmentDescription]>> in if case .segments(let x) = binding { return x } else { return nil } }) }
	public static var segmentStyle: BindingParser<Dynamic<NSSegmentedControl.Style>, Binding> { return BindingParser<Dynamic<NSSegmentedControl.Style>, Binding>(parse: { binding -> Optional<Dynamic<NSSegmentedControl.Style>> in if case .segmentStyle(let x) = binding { return x } else { return nil } }) }
	public static var selectedSegment: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .selectedSegment(let x) = binding { return x } else { return nil } }) }
	public static var trackingMode: BindingParser<Dynamic<NSSegmentedControl.SwitchTracking>, Binding> { return BindingParser<Dynamic<NSSegmentedControl.SwitchTracking>, Binding>(parse: { binding -> Optional<Dynamic<NSSegmentedControl.SwitchTracking>> in if case .trackingMode(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
