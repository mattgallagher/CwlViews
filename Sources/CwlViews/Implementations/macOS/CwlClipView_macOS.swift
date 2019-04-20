//
//  CwlClipView_macOS.swift
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

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class ClipView: Binder, ClipViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ClipView {
	enum Binding: ClipViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundColor(Dynamic<NSColor>)
		case bottomConstraintPriority(Dynamic<Layout.Dimension.Priority>)
		case copiesOnScroll(Dynamic<Bool>)
		case documentCursor(Dynamic<NSCursor?>)
		case documentView(Dynamic<ViewConvertible?>)
		case drawsBackground(Dynamic<Bool>)
		case trailingConstraintPriority(Dynamic<Layout.Dimension.Priority>)

		// 2. Signal bindings are performed on the object after construction.
		case scrollTo(Signal<CGPoint>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ClipView {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = ClipView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSClipView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ClipView.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .copiesOnScroll(let x): return x.apply(instance) { i, v in i.copiesOnScroll = v }
		case .documentCursor(let x): return x.apply(instance) { i, v in i.documentCursor = v }
		case .documentView(let x): return x.apply(instance, storage) { i, s, v in
			if let view = v?.nsView() {
				view.translatesAutoresizingMaskIntoConstraints = false
				i.addSubview(view)
				s.updateConstraints(clipView: i, documentView: view)
				i.documentView = view
			} else {
				s.clearConstraints()
				i.documentView = nil
			}
		}
		case .drawsBackground(let x): return x.apply(instance) { i, v in i.drawsBackground = v }
		case .bottomConstraintPriority(let x):
			return x.apply(instance, storage) { i, s, v in
				s.bottomPriority = v
				if let documentView = i.documentView {
					s.updateConstraints(clipView: i, documentView: documentView)
				}
			}
		case .trailingConstraintPriority(let x):
			return x.apply(instance, storage) { i, s, v in
				s.trailingPriority = v
				if let documentView = i.documentView {
					s.updateConstraints(clipView: i, documentView: documentView)
				}
			}
		
		// 2. Signal bindings are performed on the object after construction.
		case .scrollTo(let x): return x.apply(instance) { i, v in i.scroll(to: v) }

		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ClipView.Preparer {
	open class Storage: View.Preparer.Storage {
		open var trailingPriority: Layout.Dimension.Priority = .dragThatCannotResizeWindow
		open var bottomPriority: Layout.Dimension.Priority = .dragThatCannotResizeWindow
		open var constraints: [NSLayoutConstraint]?
		
		open func clearConstraints() {
			guard let existingConstraints = constraints else { return }
			NSLayoutConstraint.deactivate(existingConstraints)
			constraints = nil
		}
		
		open func updateConstraints(clipView: NSClipView, documentView: NSView) {
			clearConstraints()
			
			let trailingConstraint = documentView.trailingAnchor.constraint(equalTo: clipView.trailingAnchor)
			trailingConstraint.priority = trailingPriority
			let bottomConstraint = documentView.bottomAnchor.constraint(equalTo: clipView.bottomAnchor)
			bottomConstraint.priority = bottomPriority
			let newConstraints = [
				bottomConstraint,
				trailingConstraint,
				documentView.topAnchor.constraint(equalTo: clipView.topAnchor),
				documentView.leadingAnchor.constraint(equalTo: clipView.leadingAnchor)
			]
			NSLayoutConstraint.activate(newConstraints)
			constraints = newConstraints
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ClipViewBinding {
	public typealias ClipViewName<V> = BindingName<V, ClipView.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> ClipView.Binding) -> ClipViewName<V> {
		return ClipViewName<V>(source: source, downcast: Binding.clipViewBinding)
	}
}
public extension BindingName where Binding: ClipViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ClipViewName<$2> { return .name(ClipView.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backgroundColor: ClipViewName<Dynamic<NSColor>> { return .name(ClipView.Binding.backgroundColor) }
	static var copiesOnScroll: ClipViewName<Dynamic<Bool>> { return .name(ClipView.Binding.copiesOnScroll) }
	static var documentCursor: ClipViewName<Dynamic<NSCursor?>> { return .name(ClipView.Binding.documentCursor) }
	static var documentView: ClipViewName<Dynamic<ViewConvertible?>> { return .name(ClipView.Binding.documentView) }
	static var drawsBackground: ClipViewName<Dynamic<Bool>> { return .name(ClipView.Binding.drawsBackground) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var scrollTo: ClipViewName<Signal<CGPoint>> { return .name(ClipView.Binding.scrollTo) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ClipViewConvertible: ViewConvertible {
	func nsClipView() -> ClipView.Instance
}
extension ClipViewConvertible {
	public func nsView() -> View.Instance { return nsClipView() }
}
extension NSClipView: ClipViewConvertible {
	public func nsClipView() -> ClipView.Instance { return self }
}
public extension ClipView {
	func nsClipView() -> ClipView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ClipViewBinding: ViewBinding {
	static func clipViewBinding(_ binding: ClipView.Binding) -> Self
}
public extension ClipViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return clipViewBinding(.inheritedBinding(binding))
	}
}
public extension ClipView.Binding {
	typealias Preparer = ClipView.Preparer
	static func clipViewBinding(_ binding: ClipView.Binding) -> ClipView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
