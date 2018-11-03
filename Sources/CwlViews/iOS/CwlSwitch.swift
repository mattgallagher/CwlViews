//
//  CwlSwitch.swift
//  CwlViews_iOS
//
//  Created by Matt Gallagher on 2017/12/20.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
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

public class Switch: ConstructingBinder, SwitchConvertible {
	public typealias Instance = UISwitch
	public typealias Inherited = Control
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiSwitch() -> Instance { return instance() }
	
	public enum Binding: SwitchBinding {
		public typealias EnclosingBinder = Switch
		public static func switchBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case isOn(Dynamic<SetOrAnimate<Bool>>)
		case onTintColor(Dynamic<UIColor>)
		case tintColor(Dynamic<UIColor>)
		case thumbTintColor(Dynamic<UIColor>)
		case onImage(Dynamic<UIImage?>)
		case offImage(Dynamic<UIImage?>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Switch
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .isOn(let x): return x.apply(instance, storage) { i, s, v in i.setOn(v.value, animated: v.isAnimated) }
			case .onTintColor(let x): return x.apply(instance, storage) { i, s, v in i.onTintColor = v }
			case .tintColor(let x): return x.apply(instance, storage) { i, s, v in i.tintColor = v }
			case .thumbTintColor(let x): return x.apply(instance, storage) { i, s, v in i.thumbTintColor = v }
			case .onImage(let x): return x.apply(instance, storage) { i, s, v in i.onImage = v }
			case .offImage(let x): return x.apply(instance, storage) { i, s, v in i.offImage = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = Control.Storage
}

extension BindingName where Binding: SwitchBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .switchBinding(Switch.Binding.$1(v)) }) }
	public static var isOn: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .switchBinding(Switch.Binding.isOn(v)) }) }
	public static var onTintColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .switchBinding(Switch.Binding.onTintColor(v)) }) }
	public static var tintColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .switchBinding(Switch.Binding.tintColor(v)) }) }
	public static var thumbTintColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .switchBinding(Switch.Binding.thumbTintColor(v)) }) }
	public static var onImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .switchBinding(Switch.Binding.onImage(v)) }) }
	public static var offImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .switchBinding(Switch.Binding.offImage(v)) }) }
}

public protocol SwitchConvertible: ControlConvertible {
	func uiSwitch() -> Switch.Instance
}
extension SwitchConvertible {
	public func uiControl() -> Control.Instance { return uiSwitch() }
}
extension Switch.Instance: SwitchConvertible {
	public func uiSwitch() -> Switch.Instance { return self }
}

public protocol SwitchBinding: ControlBinding {
	static func switchBinding(_ binding: Switch.Binding) -> Self
}
extension SwitchBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return switchBinding(.inheritedBinding(binding))
	}
}

