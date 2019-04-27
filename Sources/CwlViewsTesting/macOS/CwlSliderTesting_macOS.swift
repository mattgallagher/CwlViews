//
//  CwlSlider_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Downcast: SliderBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Slider.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asSliderBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsTickMarkValuesOnly: BindingParser<Dynamic<Bool>, Slider.Binding, Downcast> { return .init(extract: { if case .allowsTickMarkValuesOnly(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var altIncrementValue: BindingParser<Dynamic<Double>, Slider.Binding, Downcast> { return .init(extract: { if case .altIncrementValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var isVertical: BindingParser<Dynamic<Bool>, Slider.Binding, Downcast> { return .init(extract: { if case .isVertical(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var maxValue: BindingParser<Dynamic<Double>, Slider.Binding, Downcast> { return .init(extract: { if case .maxValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var minValue: BindingParser<Dynamic<Double>, Slider.Binding, Downcast> { return .init(extract: { if case .minValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var numberOfTickMarks: BindingParser<Dynamic<Int>, Slider.Binding, Downcast> { return .init(extract: { if case .numberOfTickMarks(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var sliderType: BindingParser<Dynamic<NSSlider.SliderType>, Slider.Binding, Downcast> { return .init(extract: { if case .sliderType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var tickMarkPosition: BindingParser<Dynamic<NSSlider.TickMarkPosition>, Slider.Binding, Downcast> { return .init(extract: { if case .tickMarkPosition(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var trackFillColor: BindingParser<Dynamic<NSColor?>, Slider.Binding, Downcast> { return .init(extract: { if case .trackFillColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
