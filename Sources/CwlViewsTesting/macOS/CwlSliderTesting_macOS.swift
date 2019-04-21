//
//  CwlSlider_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Binding == Slider.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsTickMarkValuesOnly: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsTickMarkValuesOnly(let x) = binding { return x } else { return nil } }) }
	public static var altIncrementValue: BindingParser<Dynamic<Double>, Binding> { return BindingParser<Dynamic<Double>, Binding>(parse: { binding -> Optional<Dynamic<Double>> in if case .altIncrementValue(let x) = binding { return x } else { return nil } }) }
	public static var isVertical: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isVertical(let x) = binding { return x } else { return nil } }) }
	public static var maxValue: BindingParser<Dynamic<Double>, Binding> { return BindingParser<Dynamic<Double>, Binding>(parse: { binding -> Optional<Dynamic<Double>> in if case .maxValue(let x) = binding { return x } else { return nil } }) }
	public static var minValue: BindingParser<Dynamic<Double>, Binding> { return BindingParser<Dynamic<Double>, Binding>(parse: { binding -> Optional<Dynamic<Double>> in if case .minValue(let x) = binding { return x } else { return nil } }) }
	public static var numberOfTickMarks: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .numberOfTickMarks(let x) = binding { return x } else { return nil } }) }
	public static var sliderType: BindingParser<Dynamic<NSSlider.SliderType>, Binding> { return BindingParser<Dynamic<NSSlider.SliderType>, Binding>(parse: { binding -> Optional<Dynamic<NSSlider.SliderType>> in if case .sliderType(let x) = binding { return x } else { return nil } }) }
	public static var tickMarkPosition: BindingParser<Dynamic<NSSlider.TickMarkPosition>, Binding> { return BindingParser<Dynamic<NSSlider.TickMarkPosition>, Binding>(parse: { binding -> Optional<Dynamic<NSSlider.TickMarkPosition>> in if case .tickMarkPosition(let x) = binding { return x } else { return nil } }) }
	public static var trackFillColor: BindingParser<Dynamic<NSColor?>, Binding> { return BindingParser<Dynamic<NSColor?>, Binding>(parse: { binding -> Optional<Dynamic<NSColor?>> in if case .trackFillColor(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
