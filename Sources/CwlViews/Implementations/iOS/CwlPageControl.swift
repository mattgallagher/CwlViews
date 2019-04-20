//
//  CwlPageControl.swift
//  CwlViews
//
//  Created by Matt Gallagher on 26/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class PageControl: Binder, PageControlConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension PageControl {
	enum Binding: PageControlBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case currentPage(Dynamic<Int>)
		case currentPageIndicatorTintColor(Dynamic<UIColor?>)
		case defersCurrentPageDisplay(Dynamic<Bool>)
		case numberOfPages(Dynamic<Int>)
		case pageIndicatorTintColor(Dynamic<UIColor?>)

		// 2. Signal bindings are performed on the object after construction.
		case updateCurrentPageDisplay(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension PageControl {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = PageControl.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UIPageControl
		public typealias Parameters = () /* change if non-default construction required */
		
		public var inherited = Inherited()
		public init() {}
		
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension PageControl.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		case .currentPage(let x): return x.apply(instance) { i, v in i.currentPage = v }
		case .currentPageIndicatorTintColor(let x): return x.apply(instance) { i, v in i.currentPageIndicatorTintColor = v }
		case .defersCurrentPageDisplay(let x): return x.apply(instance) { i, v in i.defersCurrentPageDisplay = v }
		case .numberOfPages(let x): return x.apply(instance) { i, v in i.numberOfPages = v }
		case .pageIndicatorTintColor(let x): return x.apply(instance) { i, v in i.pageIndicatorTintColor = v }
		case .updateCurrentPageDisplay(let x): return x.apply(instance) { i, _ in i.updateCurrentPageDisplay() }
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PageControl.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: PageControlBinding {
	public typealias PageControlName<V> = BindingName<V, PageControl.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> PageControl.Binding) -> PageControlName<V> {
		return PageControlName<V>(source: source, downcast: Binding.pageControlBinding)
	}
}
public extension BindingName where Binding: PageControlBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: PageControlName<$2> { return .name(PageControl.Binding.$1) }

	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	static var currentPage: PageControlName<Dynamic<Int>> { return .name(PageControl.Binding.currentPage) }
	static var currentPageIndicatorTintColor: PageControlName<Dynamic<UIColor?>> { return .name(PageControl.Binding.currentPageIndicatorTintColor) }
	static var defersCurrentPageDisplay: PageControlName<Dynamic<Bool>> { return .name(PageControl.Binding.defersCurrentPageDisplay) }
	static var numberOfPages: PageControlName<Dynamic<Int>> { return .name(PageControl.Binding.numberOfPages) }
	static var pageIndicatorTintColor: PageControlName<Dynamic<UIColor?>> { return .name(PageControl.Binding.pageIndicatorTintColor) }

	// 2. Signal bindings are performed on the object after construction.
	static var updateCurrentPageDisplay: PageControlName<Signal<Void>> { return .name(PageControl.Binding.updateCurrentPageDisplay) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol PageControlConvertible: ControlConvertible {
	func uiPageControl() -> PageControl.Instance
}
extension PageControlConvertible {
	public func uiControl() -> Control.Instance { return uiPageControl() }
}
extension UIPageControl: PageControlConvertible {
	public func uiPageControl() -> PageControl.Instance { return self }
}
public extension PageControl {
	func uiPageControl() -> PageControl.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol PageControlBinding: ControlBinding {
	static func pageControlBinding(_ binding: PageControl.Binding) -> Self
}
public extension PageControlBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return pageControlBinding(.inheritedBinding(binding))
	}
}
public extension PageControl.Binding {
	typealias Preparer = PageControl.Preparer
	static func pageControlBinding(_ binding: PageControl.Binding) -> PageControl.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
