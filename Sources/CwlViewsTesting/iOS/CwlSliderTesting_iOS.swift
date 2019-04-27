//
//  CwlSlider_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/06/05.
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

extension BindingParser where Downcast: SliderBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Slider.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asSliderBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isContinuous: BindingParser<Dynamic<Bool>, Slider.Binding, Downcast> { return .init(extract: { if case .isContinuous(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var maximumTrackImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Slider.Binding, Downcast> { return .init(extract: { if case .maximumTrackImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var maximumTrackTintColor: BindingParser<Dynamic<UIColor?>, Slider.Binding, Downcast> { return .init(extract: { if case .maximumTrackTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var maximumValue: BindingParser<Dynamic<Float>, Slider.Binding, Downcast> { return .init(extract: { if case .maximumValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var maximumValueImage: BindingParser<Dynamic<UIImage?>, Slider.Binding, Downcast> { return .init(extract: { if case .maximumValueImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var minimumTrackImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Slider.Binding, Downcast> { return .init(extract: { if case .minimumTrackImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var minimumTrackTintColor: BindingParser<Dynamic<UIColor?>, Slider.Binding, Downcast> { return .init(extract: { if case .minimumTrackTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var minimumValue: BindingParser<Dynamic<Float>, Slider.Binding, Downcast> { return .init(extract: { if case .minimumValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var minimumValueImage: BindingParser<Dynamic<UIImage?>, Slider.Binding, Downcast> { return .init(extract: { if case .minimumValueImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var thumbImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Slider.Binding, Downcast> { return .init(extract: { if case .thumbImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var thumbTintColor: BindingParser<Dynamic<UIColor?>, Slider.Binding, Downcast> { return .init(extract: { if case .thumbTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	public static var value: BindingParser<Dynamic<SetOrAnimate<Float>>, Slider.Binding, Downcast> { return .init(extract: { if case .value(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSliderBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
