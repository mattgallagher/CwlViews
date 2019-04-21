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

extension BindingParser where Binding == Slider.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isContinuous: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isContinuous(let x) = binding { return x } else { return nil } }) }
	public static var maximumTrackImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIImage?>>> in if case .maximumTrackImage(let x) = binding { return x } else { return nil } }) }
	public static var maximumTrackTintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .maximumTrackTintColor(let x) = binding { return x } else { return nil } }) }
	public static var maximumValue: BindingParser<Dynamic<Float>, Binding> { return BindingParser<Dynamic<Float>, Binding>(parse: { binding -> Optional<Dynamic<Float>> in if case .maximumValue(let x) = binding { return x } else { return nil } }) }
	public static var maximumValueImage: BindingParser<Dynamic<UIImage?>, Binding> { return BindingParser<Dynamic<UIImage?>, Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .maximumValueImage(let x) = binding { return x } else { return nil } }) }
	public static var minimumTrackImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIImage?>>> in if case .minimumTrackImage(let x) = binding { return x } else { return nil } }) }
	public static var minimumTrackTintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .minimumTrackTintColor(let x) = binding { return x } else { return nil } }) }
	public static var minimumValue: BindingParser<Dynamic<Float>, Binding> { return BindingParser<Dynamic<Float>, Binding>(parse: { binding -> Optional<Dynamic<Float>> in if case .minimumValue(let x) = binding { return x } else { return nil } }) }
	public static var minimumValueImage: BindingParser<Dynamic<UIImage?>, Binding> { return BindingParser<Dynamic<UIImage?>, Binding>(parse: { binding -> Optional<Dynamic<UIImage?>> in if case .minimumValueImage(let x) = binding { return x } else { return nil } }) }
	public static var thumbImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIImage?>>> in if case .thumbImage(let x) = binding { return x } else { return nil } }) }
	public static var thumbTintColor: BindingParser<Dynamic<UIColor?>, Binding> { return BindingParser<Dynamic<UIColor?>, Binding>(parse: { binding -> Optional<Dynamic<UIColor?>> in if case .thumbTintColor(let x) = binding { return x } else { return nil } }) }
	public static var value: BindingParser<Dynamic<SetOrAnimate<Float>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Float>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Float>>> in if case .value(let x) = binding { return x } else { return nil } }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
