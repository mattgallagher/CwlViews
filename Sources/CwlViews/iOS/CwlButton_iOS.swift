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

public class Button: Binder, ButtonConvertible {
	public typealias Instance = UIButton
	public typealias Inherited = Control
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiButton() -> Instance { return instance() }
	
	enum Binding: ButtonBinding {
		public typealias EnclosingBinder = Button
		public static func buttonBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case type(Constant<UIButton.ButtonType>)
		case titleLabel(Constant<Label>)
		case imageView(Constant<ImageView>)
	
		// 1. Value bindings may be applied at construction and may subsequently change.
		case adjustsImageWhenHighlighted(Dynamic<Bool>)
		case adjustsImageWhenDisabled(Dynamic<Bool>)
		case showsTouchWhenHighlighted(Dynamic<Bool>)
		case contentEdgeInsets(Dynamic<UIEdgeInsets>)
		case titleEdgeInsets(Dynamic<UIEdgeInsets>)
		case imageEdgeInsets(Dynamic<UIEdgeInsets>)
		
		case title(Dynamic<ScopedValues<UIControl.State, String?>>)
		case titleColor(Dynamic<ScopedValues<UIControl.State, UIColor?>>)
		case titleShadowColor(Dynamic<ScopedValues<UIControl.State, UIColor?>>)
		case attributedTitle(Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>)
		case backgroundImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case image(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = Button
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			return subclass.init(type: type)
		}
		
		var type: UIButton.ButtonType = .roundedRect
		
		public init() {}
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .type(let x): type = x.value
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .titleLabel(let x):
				if let tl = instance.titleLabel {
					x.value.applyBindings(to: tl)
				}
				return nil
			case .imageView(let x):
				if let iv = instance.imageView {
					x.value.applyBindings(to: iv)
				}
				return nil
			case .type: return nil
			case .title(let x):
				var previous: ScopedValues<UIControl.State, String?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setTitle(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setTitle(c.1, for: c.0)
					}
				}
			case .titleColor(let x):
				var previous: ScopedValues<UIControl.State, UIColor?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setTitleColor(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setTitleColor(c.1, for: c.0)
					}
				}
			case .titleShadowColor(let x):
				var previous: ScopedValues<UIControl.State, UIColor?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setTitleShadowColor(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setTitleShadowColor(c.1, for: c.0)
					}
				}
			case .attributedTitle(let x):
				var previous: ScopedValues<UIControl.State, NSAttributedString?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setAttributedTitle(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setAttributedTitle(c.1, for: c.0)
					}
				}
			case .backgroundImage(let x):
				var previous: ScopedValues<UIControl.State, UIImage?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setBackgroundImage(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setBackgroundImage(c.1, for: c.0)
					}
				}
			case .image(let x):
				var previous: ScopedValues<UIControl.State, UIImage?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setImage(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setImage(c.1, for: c.0)
					}
				}
			case .adjustsImageWhenHighlighted(let x): return x.apply(instance) { i, v in i.adjustsImageWhenHighlighted = v }
			case .adjustsImageWhenDisabled(let x): return x.apply(instance) { i, v in i.adjustsImageWhenDisabled = v }
			case .showsTouchWhenHighlighted(let x): return x.apply(instance) { i, v in i.showsTouchWhenHighlighted = v }
			case .contentEdgeInsets(let x): return x.apply(instance) { i, v in i.contentEdgeInsets = v }
			case .titleEdgeInsets(let x): return x.apply(instance) { i, v in i.titleEdgeInsets = v }
			case .imageEdgeInsets(let x): return x.apply(instance) { i, v in i.imageEdgeInsets = v }
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = Control.Storage
}

extension BindingName where Binding: ButtonBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .buttonBinding(Button.Binding.$1(v)) }) }
	public static var type: BindingName<Constant<UIButton.ButtonType>, Binding> { return BindingName<Constant<UIButton.ButtonType>, Binding>({ v in .buttonBinding(Button.Binding.type(v)) }) }
	public static var titleLabel: BindingName<Constant<Label>, Binding> { return BindingName<Constant<Label>, Binding>({ v in .buttonBinding(Button.Binding.titleLabel(v)) }) }
	public static var imageView: BindingName<Constant<ImageView>, Binding> { return BindingName<Constant<ImageView>, Binding>({ v in .buttonBinding(Button.Binding.imageView(v)) }) }
	public static var adjustsImageWhenHighlighted: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.adjustsImageWhenHighlighted(v)) }) }
	public static var adjustsImageWhenDisabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.adjustsImageWhenDisabled(v)) }) }
	public static var showsTouchWhenHighlighted: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.showsTouchWhenHighlighted(v)) }) }
	public static var contentEdgeInsets: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .buttonBinding(Button.Binding.contentEdgeInsets(v)) }) }
	public static var titleEdgeInsets: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .buttonBinding(Button.Binding.titleEdgeInsets(v)) }) }
	public static var imageEdgeInsets: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .buttonBinding(Button.Binding.imageEdgeInsets(v)) }) }
	public static var title: BindingName<Dynamic<ScopedValues<UIControl.State, String?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, String?>>, Binding>({ v in .buttonBinding(Button.Binding.title(v)) }) }
	public static var titleColor: BindingName<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding>({ v in .buttonBinding(Button.Binding.titleColor(v)) }) }
	public static var titleShadowColor: BindingName<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIColor?>>, Binding>({ v in .buttonBinding(Button.Binding.titleShadowColor(v)) }) }
	public static var attributedTitle: BindingName<Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, NSAttributedString?>>, Binding>({ v in .buttonBinding(Button.Binding.attributedTitle(v)) }) }
	public static var backgroundImage: BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>({ v in .buttonBinding(Button.Binding.backgroundImage(v)) }) }
	public static var image: BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>({ v in .buttonBinding(Button.Binding.image(v)) }) }
}

public protocol ButtonConvertible: ControlConvertible {
	func uiButton() -> Button.Instance
}
extension ButtonConvertible {
	public func uiControl() -> Control.Instance { return uiButton() }
}
extension Button.Instance: ButtonConvertible {
	public func uiButton() -> Button.Instance { return self }
}

public protocol ButtonBinding: ControlBinding {
	static func buttonBinding(_ binding: Button.Binding) -> Self
}

extension ButtonBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return buttonBinding(.inheritedBinding(binding))
	}
}

#endif
