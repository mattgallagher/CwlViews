//
//  CwlExtendedViewController.swift
//  CwlViews
//
//  Created by Matt Gallagher on 12/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)

extension BindingParser where Binding: ExtendedViewControllerBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<$2, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var didAppear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<(UIViewController, Bool) -> Void> in if case .didAppear(let x) = binding { return x } else { return nil } }) }
	public static var didDisappear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<(UIViewController, Bool) -> Void> in if case .didDisappear(let x) = binding { return x } else { return nil } }) }
	public static var didReceiveMemoryWarning: BindingParser<(UIViewController) -> Void, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<(UIViewController) -> Void, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<(UIViewController) -> Void> in if case .didReceiveMemoryWarning(let x) = binding { return x } else { return nil } }) }
	public static var loadView: BindingParser<() -> ViewConvertible, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<() -> ViewConvertible, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<() -> ViewConvertible> in if case .loadView(let x) = binding { return x } else { return nil } }) }
	public static var traitCollectionDidChange: BindingParser<(UIViewController, UITraitCollection?) -> Void, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<(UIViewController, UITraitCollection?) -> Void, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<(UIViewController, UITraitCollection?) -> Void> in if case .traitCollectionDidChange(let x) = binding { return x } else { return nil } }) }
	public static var willAppear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<(UIViewController, Bool) -> Void> in if case .willAppear(let x) = binding { return x } else { return nil } }) }
	public static var willDisappear: BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding> { return BindingParser<(UIViewController, Bool) -> Void, ExtendedViewController<Binding.SubclassType>.Binding>(parse: { binding -> Optional<(UIViewController, Bool) -> Void> in if case .willDisappear(let x) = binding { return x } else { return nil } }) }
}

#endif
