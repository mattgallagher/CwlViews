//
//  CwlTableRowView.swift
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

public class TableRowView: ConstructingBinder, TableRowViewConvertible {
	public typealias Instance = NSTableRowView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsTableRowView() -> Instance { return instance() }
	
	public enum Binding: TableRowViewBinding {
		public typealias EnclosingBinder = TableRowView
		public static func tableRowViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case isEmphasized(Dynamic<Bool>)
		case isFloating(Dynamic<Bool>)
		case isSelected(Dynamic<Bool>)
		case selectionHighlightStyle(Dynamic<NSTableView.SelectionHighlightStyle>)
		case draggingDestinationFeedbackStyle(Dynamic<NSTableView.DraggingDestinationFeedbackStyle>)
		case indentationForDropOperation(Dynamic<CGFloat>)
		case isTargetForDropOperation(Dynamic<Bool>)
		case isGroupRowStyle(Dynamic<Bool>)
		case backgroundColor(Dynamic<NSColor>)
		

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = TableRowView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .isEmphasized(let x): return x.apply(instance, storage) { i, s, v in i.isEmphasized = v }
			case .isFloating(let x): return x.apply(instance, storage) { i, s, v in i.isFloating = v }
			case .isSelected(let x): return x.apply(instance, storage) { i, s, v in i.isSelected = v }
			case .selectionHighlightStyle(let x): return x.apply(instance, storage) { i, s, v in i.selectionHighlightStyle = v }
			case .draggingDestinationFeedbackStyle(let x): return x.apply(instance, storage) { i, s, v in i.draggingDestinationFeedbackStyle = v }
			case .indentationForDropOperation(let x): return x.apply(instance, storage) { i, s, v in i.indentationForDropOperation = v }
			case .isTargetForDropOperation(let x): return x.apply(instance, storage) { i, s, v in i.isTargetForDropOperation = v }
			case .isGroupRowStyle(let x): return x.apply(instance, storage) { i, s, v in i.isGroupRowStyle = v }
			case .backgroundColor(let x): return x.apply(instance, storage) { i, s, v in i.backgroundColor = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = View.Storage
}

extension BindingName where Binding: TableRowViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isEmphasized: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.isEmphasized(v)) }) }
	public static var isFloating: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.isFloating(v)) }) }
	public static var isSelected: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.isSelected(v)) }) }
	public static var selectionHighlightStyle: BindingName<Dynamic<NSTableView.SelectionHighlightStyle>, Binding> { return BindingName<Dynamic<NSTableView.SelectionHighlightStyle>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.selectionHighlightStyle(v)) }) }
	public static var draggingDestinationFeedbackStyle: BindingName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>, Binding> { return BindingName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.draggingDestinationFeedbackStyle(v)) }) }
	public static var indentationForDropOperation: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.indentationForDropOperation(v)) }) }
	public static var isTargetForDropOperation: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.isTargetForDropOperation(v)) }) }
	public static var isGroupRowStyle: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.isGroupRowStyle(v)) }) }
	public static var backgroundColor: BindingName<Dynamic<NSColor>, Binding> { return BindingName<Dynamic<NSColor>, Binding>({ v in .tableRowViewBinding(TableRowView.Binding.backgroundColor(v)) }) }
	

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol TableRowViewConvertible: ViewConvertible {
	func nsTableRowView() -> TableRowView.Instance
}
extension TableRowViewConvertible {
	public func nsView() -> View.Instance { return nsTableRowView() }
}
extension TableRowView.Instance: TableRowViewConvertible {
	public func nsTableRowView() -> TableRowView.Instance { return self }
}

public protocol TableRowViewBinding: ViewBinding {
	static func tableRowViewBinding(_ binding: TableRowView.Binding) -> Self
}
extension TableRowViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return tableRowViewBinding(.inheritedBinding(binding))
	}
}
