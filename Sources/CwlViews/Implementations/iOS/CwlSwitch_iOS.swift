//
//  CwlSwitch_iOS.swift
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class Switch: Binder, SwitchConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Switch {
	enum Binding: SwitchBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case isOn(Dynamic<SetOrAnimate<Bool>>)
		case offImage(Dynamic<UIImage?>)
		case onImage(Dynamic<UIImage?>)
		case onTintColor(Dynamic<UIColor>)
		case thumbTintColor(Dynamic<UIColor>)
		case tintColor(Dynamic<UIColor>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension Switch {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Switch.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UISwitch
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Switch.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .isOn(let x): return x.apply(instance) { i, v in i.setOn(v.value, animated: v.isAnimated) }
		case .offImage(let x): return x.apply(instance) { i, v in i.offImage = v }
		case .onImage(let x): return x.apply(instance) { i, v in i.onImage = v }
		case .onTintColor(let x): return x.apply(instance) { i, v in i.onTintColor = v }
		case .thumbTintColor(let x): return x.apply(instance) { i, v in i.thumbTintColor = v }
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
		
		// 2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Switch.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SwitchBinding {
	public typealias SwitchName<V> = BindingName<V, Switch.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> Switch.Binding) -> SwitchName<V> {
		return SwitchName<V>(source: source, downcast: Binding.switchBinding)
	}
}
public extension BindingName where Binding: SwitchBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SwitchName<$2> { return .name(Switch.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var isOn: SwitchName<Dynamic<SetOrAnimate<Bool>>> { return .name(Switch.Binding.isOn) }
	static var offImage: SwitchName<Dynamic<UIImage?>> { return .name(Switch.Binding.offImage) }
	static var onImage: SwitchName<Dynamic<UIImage?>> { return .name(Switch.Binding.onImage) }
	static var onTintColor: SwitchName<Dynamic<UIColor>> { return .name(Switch.Binding.onTintColor) }
	static var thumbTintColor: SwitchName<Dynamic<UIColor>> { return .name(Switch.Binding.thumbTintColor) }
	static var tintColor: SwitchName<Dynamic<UIColor>> { return .name(Switch.Binding.tintColor) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SwitchConvertible: ControlConvertible {
	func uiSwitch() -> Switch.Instance
}
extension SwitchConvertible {
	public func uiControl() -> Control.Instance { return uiSwitch() }
}
extension UISwitch: SwitchConvertible {
	public func uiSwitch() -> Switch.Instance { return self }
}
public extension Switch {
	func uiSwitch() -> Switch.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SwitchBinding: ControlBinding {
	static func switchBinding(_ binding: Switch.Binding) -> Self
}
public extension SwitchBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return switchBinding(.inheritedBinding(binding))
	}
}
public extension Switch.Binding {
	typealias Preparer = Switch.Preparer
	static func switchBinding(_ binding: Switch.Binding) -> Switch.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
