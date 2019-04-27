//
//  CwlTableRowView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 1/11/2015.
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
public class TableRowView: Binder, TableRowViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableRowView {
	enum Binding: TableRowViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundColor(Dynamic<NSColor>)
		case draggingDestinationFeedbackStyle(Dynamic<NSTableView.DraggingDestinationFeedbackStyle>)
		case indentationForDropOperation(Dynamic<CGFloat>)
		case isEmphasized(Dynamic<Bool>)
		case isFloating(Dynamic<Bool>)
		case isGroupRowStyle(Dynamic<Bool>)
		case isSelected(Dynamic<Bool>)
		case isTargetForDropOperation(Dynamic<Bool>)
		case selectionHighlightStyle(Dynamic<NSTableView.SelectionHighlightStyle>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableRowView {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = TableRowView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSTableRowView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableRowView.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .draggingDestinationFeedbackStyle(let x): return x.apply(instance) { i, v in i.draggingDestinationFeedbackStyle = v }
		case .indentationForDropOperation(let x): return x.apply(instance) { i, v in i.indentationForDropOperation = v }
		case .isEmphasized(let x): return x.apply(instance) { i, v in i.isEmphasized = v }
		case .isFloating(let x): return x.apply(instance) { i, v in i.isFloating = v }
		case .isGroupRowStyle(let x): return x.apply(instance) { i, v in i.isGroupRowStyle = v }
		case .isSelected(let x): return x.apply(instance) { i, v in i.isSelected = v }
		case .isTargetForDropOperation(let x): return x.apply(instance) { i, v in i.isTargetForDropOperation = v }
		case .selectionHighlightStyle(let x): return x.apply(instance) { i, v in i.selectionHighlightStyle = v }

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableRowView.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TableRowViewBinding {
	public typealias TableRowViewName<V> = BindingName<V, TableRowView.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> TableRowView.Binding) -> TableRowViewName<V> {
		return TableRowViewName<V>(source: source, downcast: Binding.tableRowViewBinding)
	}
}
public extension BindingName where Binding: TableRowViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableRowViewName<$2> { return .name(TableRowView.Binding.$1) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backgroundColor: TableRowViewName<Dynamic<NSColor>> { return .name(TableRowView.Binding.backgroundColor) }
	static var draggingDestinationFeedbackStyle: TableRowViewName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>> { return .name(TableRowView.Binding.draggingDestinationFeedbackStyle) }
	static var indentationForDropOperation: TableRowViewName<Dynamic<CGFloat>> { return .name(TableRowView.Binding.indentationForDropOperation) }
	static var isEmphasized: TableRowViewName<Dynamic<Bool>> { return .name(TableRowView.Binding.isEmphasized) }
	static var isFloating: TableRowViewName<Dynamic<Bool>> { return .name(TableRowView.Binding.isFloating) }
	static var isGroupRowStyle: TableRowViewName<Dynamic<Bool>> { return .name(TableRowView.Binding.isGroupRowStyle) }
	static var isSelected: TableRowViewName<Dynamic<Bool>> { return .name(TableRowView.Binding.isSelected) }
	static var isTargetForDropOperation: TableRowViewName<Dynamic<Bool>> { return .name(TableRowView.Binding.isTargetForDropOperation) }
	static var selectionHighlightStyle: TableRowViewName<Dynamic<NSTableView.SelectionHighlightStyle>> { return .name(TableRowView.Binding.selectionHighlightStyle) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableRowViewConvertible: ViewConvertible {
	func nsTableRowView() -> TableRowView.Instance
}
extension TableRowViewConvertible {
	public func nsView() -> View.Instance { return nsTableRowView() }
}
extension NSTableRowView: TableRowViewConvertible {
	public func nsTableRowView() -> TableRowView.Instance { return self }
}
extension TableRowView {
	public func nsTableRowView() -> TableRowView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableRowViewBinding: ViewBinding {
	static func tableRowViewBinding(_ binding: TableRowView.Binding) -> Self
	func asTableRowViewBinding() -> TableRowView.Binding?
}
public extension TableRowViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return tableRowViewBinding(.inheritedBinding(binding))
	}
}
public extension TableRowViewBinding where Preparer.Inherited.Binding: TableRowViewBinding {
	func asTableRowViewBinding() -> TableRowView.Binding? {
		return asInheritedBinding()?.asTableRowViewBinding()
	}
}
public extension TableRowView.Binding {
	typealias Preparer = TableRowView.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asTableRowViewBinding() -> TableRowView.Binding? { return self }
	static func tableRowViewBinding(_ binding: TableRowView.Binding) -> TableRowView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
