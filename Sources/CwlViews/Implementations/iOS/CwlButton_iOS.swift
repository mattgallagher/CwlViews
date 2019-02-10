//
//  CwlButton_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/23.
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

// MARK: - Binder Part 1: Binder
public class Button: Binder, ButtonConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Button {
	enum Binding: ButtonBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case imageView(Constant<ImageView>)
		case titleLabel(Constant<Label>)
		case type(Constant<UIButton.ButtonType>)
	
		// 1. Value bindings may be applied at construction and may subsequently change.
		case adjustsImageWhenDisabled(Dynamic<Bool>)
		case adjustsImageWhenHighlighted(Dynamic<Bool>)
		case attributedTitle(Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>)
		case backgroundImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case contentEdgeInsets(Dynamic<UIEdgeInsets>)
		case image(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case imageEdgeInsets(Dynamic<UIEdgeInsets>)
		case showsTouchWhenHighlighted(Dynamic<Bool>)
		case title(Dynamic<ScopedValues<UIControl.State, String?>>)
		case titleColor(Dynamic<ScopedValues<UIControl.State, UIColor?>>)
		case titleEdgeInsets(Dynamic<UIEdgeInsets>)
		case titleShadowColor(Dynamic<ScopedValues<UIControl.State, UIColor?>>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension Button {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Button.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UIButton
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var type: UIButton.ButtonType = .roundedRect
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Button.Preparer {
	func constructInstance(type: Instance.Type, parameters: Void) -> Instance {
		return type.init(type: self.type)
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .type(let x): type = x.value
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .imageView(let x):
			if let iv = instance.imageView {
				x.value.apply(to: iv)
			}
			return nil
		case .titleLabel(let x):
			if let tl = instance.titleLabel {
				x.value.apply(to: tl)
			}
			return nil
		case .type: return nil
	
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .adjustsImageWhenDisabled(let x): return x.apply(instance) { i, v in i.adjustsImageWhenDisabled = v }
		case .adjustsImageWhenHighlighted(let x): return x.apply(instance) { i, v in i.adjustsImageWhenHighlighted = v }
		case .attributedTitle(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setAttributedTitle(nil, for: scope) },
				applyNew: { i, scope, v in i.setAttributedTitle(v, for: scope) }
			)
		case .backgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackgroundImage(nil, for: scope) },
				applyNew: { i, scope, v in i.setBackgroundImage(v, for: scope) }
			)
		case .contentEdgeInsets(let x): return x.apply(instance) { i, v in i.contentEdgeInsets = v }
		case .image(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setImage(nil, for: scope) },
				applyNew: { i, scope, v in i.setImage(v, for: scope) }
			)
		case .imageEdgeInsets(let x): return x.apply(instance) { i, v in i.imageEdgeInsets = v }
		case .showsTouchWhenHighlighted(let x): return x.apply(instance) { i, v in i.showsTouchWhenHighlighted = v }
		case .title(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setTitle(nil, for: scope) },
				applyNew: { i, scope, v in i.setTitle(v, for: scope) }
			)
		case .titleColor(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setTitleColor(nil, for: scope) },
				applyNew: { i, scope, v in i.setTitleColor(v, for: scope) }
			)
		case .titleEdgeInsets(let x): return x.apply(instance) { i, v in i.titleEdgeInsets = v }
		case .titleShadowColor(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setTitleShadowColor(nil, for: scope) },
				applyNew: { i, scope, v in i.setTitleShadowColor(v, for: scope) }
			)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Button.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ButtonBinding {
	public typealias ButtonName<V> = BindingName<V, Button.Binding, Binding>
	private typealias B = Button.Binding
	private static func name<V>(_ source: @escaping (V) -> Button.Binding) -> ButtonName<V> {
		return ButtonName<V>(source: source, downcast: Binding.buttonBinding)
	}
}
public extension BindingName where Binding: ButtonBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ButtonName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var imageView: ButtonName<Constant<ImageView>> { return .name(B.imageView) }
	static var titleLabel: ButtonName<Constant<Label>> { return .name(B.titleLabel) }
	static var type: ButtonName<Constant<UIButton.ButtonType>> { return .name(B.type) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var adjustsImageWhenDisabled: ButtonName<Dynamic<Bool>> { return .name(B.adjustsImageWhenDisabled) }
	static var adjustsImageWhenHighlighted: ButtonName<Dynamic<Bool>> { return .name(B.adjustsImageWhenHighlighted) }
	static var attributedTitle: ButtonName<Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>> { return .name(B.attributedTitle) }
	static var backgroundImage: ButtonName<Dynamic<ScopedValues<UIControl.State, UIImage?>>> { return .name(B.backgroundImage) }
	static var contentEdgeInsets: ButtonName<Dynamic<UIEdgeInsets>> { return .name(B.contentEdgeInsets) }
	static var image: ButtonName<Dynamic<ScopedValues<UIControl.State, UIImage?>>> { return .name(B.image) }
	static var imageEdgeInsets: ButtonName<Dynamic<UIEdgeInsets>> { return .name(B.imageEdgeInsets) }
	static var showsTouchWhenHighlighted: ButtonName<Dynamic<Bool>> { return .name(B.showsTouchWhenHighlighted) }
	static var title: ButtonName<Dynamic<ScopedValues<UIControl.State, String?>>> { return .name(B.title) }
	static var titleColor: ButtonName<Dynamic<ScopedValues<UIControl.State, UIColor?>>> { return .name(B.titleColor) }
	static var titleEdgeInsets: ButtonName<Dynamic<UIEdgeInsets>> { return .name(B.titleEdgeInsets) }
	static var titleShadowColor: ButtonName<Dynamic<ScopedValues<UIControl.State, UIColor?>>> { return .name(B.titleShadowColor) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ButtonConvertible: ControlConvertible {
	func uiButton() -> Button.Instance
}
extension ButtonConvertible {
	public func uiControl() -> Control.Instance { return uiButton() }
}
extension UIButton: ButtonConvertible {
	public func uiButton() -> Button.Instance { return self }
}
public extension Button {
	func uiButton() -> Button.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ButtonBinding: ControlBinding {
	static func buttonBinding(_ binding: Button.Binding) -> Self
}
public extension ButtonBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return buttonBinding(.inheritedBinding(binding))
	}
}
public extension Button.Binding {
	typealias Preparer = Button.Preparer
	static func buttonBinding(_ binding: Button.Binding) -> Button.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
