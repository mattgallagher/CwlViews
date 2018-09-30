//
//  CwlClipView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 7/11/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

public class ClipView: ConstructingBinder, ClipViewConvertible {
	public typealias Instance = NSClipView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsClipView() -> Instance { return instance() }
	
	public enum Binding: ClipViewBinding {
		public typealias EnclosingBinder = ClipView
		public static func clipViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case copiesOnScroll(Dynamic<Bool>)
		case documentView(Dynamic<ViewConvertible?>)
		case documentCursor(Dynamic<NSCursor?>)
		case drawsBackground(Dynamic<Bool>)
		case backgroundColor(Dynamic<NSColor>)

		// 2. Signal bindings are performed on the object after construction.
		case scrollTo(Signal<CGPoint>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = ClipView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }

		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .copiesOnScroll(let x): return x.apply(instance, storage) { i, s, v in i.copiesOnScroll = v }
			case .documentView(let x): return x.apply(instance, storage) { i, s, v in i.documentView = v?.nsView() }
			case .documentCursor(let x): return x.apply(instance, storage) { i, s, v in i.documentCursor = v }
			case .drawsBackground(let x): return x.apply(instance, storage) { i, s, v in i.drawsBackground = v }
			case .backgroundColor(let x): return x.apply(instance, storage) { i, s, v in i.backgroundColor = v }
			case .scrollTo(let x): return x.apply(instance, storage) { i, s, v in i.scroll(to: v) }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = View.Storage
}

extension BindingName where Binding: ClipViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .clipViewBinding(ClipView.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var copiesOnScroll: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .clipViewBinding(ClipView.Binding.copiesOnScroll(v)) }) }
	public static var documentView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .clipViewBinding(ClipView.Binding.documentView(v)) }) }
	public static var documentCursor: BindingName<Dynamic<NSCursor?>, Binding> { return BindingName<Dynamic<NSCursor?>, Binding>({ v in .clipViewBinding(ClipView.Binding.documentCursor(v)) }) }
	public static var drawsBackground: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .clipViewBinding(ClipView.Binding.drawsBackground(v)) }) }
	public static var backgroundColor: BindingName<Dynamic<NSColor>, Binding> { return BindingName<Dynamic<NSColor>, Binding>({ v in .clipViewBinding(ClipView.Binding.backgroundColor(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var scrollTo: BindingName<Signal<CGPoint>, Binding> { return BindingName<Signal<CGPoint>, Binding>({ v in .clipViewBinding(ClipView.Binding.scrollTo(v)) }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol ClipViewConvertible: ViewConvertible {
	func nsClipView() -> ClipView.Instance
}
extension ClipViewConvertible {
	public func nsView() -> View.Instance { return nsClipView() }
}
extension ClipView.Instance: ClipViewConvertible {
	public func nsClipView() -> ClipView.Instance { return self }
}

public protocol ClipViewBinding: ViewBinding {
	static func clipViewBinding(_ binding: ClipView.Binding) -> Self
}
extension ClipViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return clipViewBinding(.inheritedBinding(binding))
	}
}
