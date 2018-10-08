//
//  CwlSlider.swift
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

public class Slider: ConstructingBinder, SliderConvertible {
	public typealias Instance = UISlider
	public typealias Inherited = Control
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiSlider() -> Instance { return instance() }
	
	public enum Binding: SliderBinding {
		public typealias EnclosingBinder = Slider
		public static func sliderBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case value(Dynamic<SetOrAnimate<Float>>)
		case maximumValue(Dynamic<Float>)
		case minimumValue(Dynamic<Float>)
		case isContinuous(Dynamic<Bool>)
		case minimumValueImage(Dynamic<UIImage?>)
		case maximumValueImage(Dynamic<UIImage?>)
		case minimumTrackTintColor(Dynamic<UIColor?>)
		case maximumTrackTintColor(Dynamic<UIColor?>)
		case thumbTintColor(Dynamic<UIColor?>)
		case thumbImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case minimumTrackImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case maximumTrackImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Slider
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .thumbImage(let x):
				var previous: ScopedValues<UIControl.State, UIImage?>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.setThumbImage(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setThumbImage(c.1, for: c.0)
					}
				}
			case .minimumTrackImage(let x):
				var previous: ScopedValues<UIControl.State, UIImage?>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.setMinimumTrackImage(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setMinimumTrackImage(c.1, for: c.0)
					}
				}
			case .maximumTrackImage(let x):
				var previous: ScopedValues<UIControl.State, UIImage?>? = nil
				return x.apply(instance, storage) { i, s, v in
					if let p = previous {
						for c in p.pairs {
							i.setMaximumTrackImage(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setMaximumTrackImage(c.1, for: c.0)
					}
				}
			case .value(let x): return x.apply(instance, storage) { i, s, v in i.setValue(v.value, animated: v.isAnimated) }
			case .maximumValue(let x): return x.apply(instance, storage) { i, s, v in i.maximumValue = v }
			case .minimumValue(let x): return x.apply(instance, storage) { i, s, v in i.minimumValue = v }
			case .isContinuous(let x): return x.apply(instance, storage) { i, s, v in i.isContinuous = v }
			case .minimumValueImage(let x): return x.apply(instance, storage) { i, s, v in i.minimumValueImage = v }
			case .maximumValueImage(let x): return x.apply(instance, storage) { i, s, v in i.maximumValueImage = v }
			case .minimumTrackTintColor(let x): return x.apply(instance, storage) { i, s, v in i.minimumTrackTintColor = v }
			case .maximumTrackTintColor(let x): return x.apply(instance, storage) { i, s, v in i.maximumTrackTintColor = v }
			case .thumbTintColor(let x): return x.apply(instance, storage) { i, s, v in i.thumbTintColor = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = Control.Storage
}

extension BindingName where Binding: SliderBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .sliderBinding(Slider.Binding.$1(v)) }) }
	public static var value: BindingName<Dynamic<SetOrAnimate<Float>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Float>>, Binding>({ v in .sliderBinding(Slider.Binding.value(v)) }) }
	public static var maximumValue: BindingName<Dynamic<Float>, Binding> { return BindingName<Dynamic<Float>, Binding>({ v in .sliderBinding(Slider.Binding.maximumValue(v)) }) }
	public static var minimumValue: BindingName<Dynamic<Float>, Binding> { return BindingName<Dynamic<Float>, Binding>({ v in .sliderBinding(Slider.Binding.minimumValue(v)) }) }
	public static var isContinuous: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .sliderBinding(Slider.Binding.isContinuous(v)) }) }
	public static var minimumValueImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .sliderBinding(Slider.Binding.minimumValueImage(v)) }) }
	public static var maximumValueImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .sliderBinding(Slider.Binding.maximumValueImage(v)) }) }
	public static var minimumTrackTintColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .sliderBinding(Slider.Binding.minimumTrackTintColor(v)) }) }
	public static var maximumTrackTintColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .sliderBinding(Slider.Binding.maximumTrackTintColor(v)) }) }
	public static var thumbTintColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .sliderBinding(Slider.Binding.thumbTintColor(v)) }) }
	public static var thumbImage: BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>({ v in .sliderBinding(Slider.Binding.thumbImage(v)) }) }
	public static var minimumTrackImage: BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>({ v in .sliderBinding(Slider.Binding.minimumTrackImage(v)) }) }
	public static var maximumTrackImage: BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>({ v in .sliderBinding(Slider.Binding.maximumTrackImage(v)) }) }
}

public protocol SliderConvertible: ControlConvertible {
	func uiSlider() -> Slider.Instance
}
extension SliderConvertible {
	public func uiControl() -> Control.Instance { return uiSlider() }
}
extension Slider.Instance: SliderConvertible {
	public func uiSlider() -> Slider.Instance { return self }
}

public protocol SliderBinding: ControlBinding {
	static func sliderBinding(_ binding: Slider.Binding) -> Self
}
extension SliderBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return sliderBinding(.inheritedBinding(binding))
	}
}
