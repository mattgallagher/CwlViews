//
//  CwlTableColumn.swift
//  CwlViews
//
//  Created by Matt Gallagher on 29/10/2015.
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

public class TableColumn<RowData>: Binder {
	public typealias Instance = NSTableColumn
	public typealias Inherited = BaseBinder
	
	public var state: BinderState<Storage, BinderAdditionalParameters<Instance, Binding, NSUserInterfaceItemIdentifier>>
	public required init(state: BinderState<Storage, BinderAdditionalParameters<Instance, Binding, NSUserInterfaceItemIdentifier>>) {
		self.state = state
	}
	public init(subclass: Instance.Type = Instance.self, identifier: NSUserInterfaceItemIdentifier, bindings: [Binding]) {
		state = .pending(BinderAdditionalParameters(subclass: subclass, additional: identifier, bindings: bindings))
	}
	public init(subclass: Instance.Type = Instance.self, identifier: NSUserInterfaceItemIdentifier, _ bindings: Binding...) {
		state = .pending(BinderAdditionalParameters(subclass: subclass, additional: identifier, bindings: bindings))
	}
	public func applyBindings(to instance: Instance) {
		binderApply(
			to: instance,
			additional: nil,
			storageConstructor: { prep, params, i in Storage(column: instance) },
			combine: { i, s, cs in s.setLifetimes(cs) })
	}
	public func construct(additional: ((Instance) -> Lifetime?)? = nil) -> Storage {
		return binderConstruct(
			additional: additional,
			storageConstructor: { prep, params, i in Storage(column: i) },
			instanceConstructor: { prep, params in params.subclass.init(identifier: params.additional) },
			combine: { i, s, cs in s.setLifetimes(cs) },
			output: { i, s in s })
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	
	public enum Binding: TableColumnBinding {
		public typealias RowDataType = RowData
		public typealias EnclosingBinder = TableColumn
		public static func tableColumnBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case width(Dynamic<CGFloat>)
		case minWidth(Dynamic<CGFloat>)
		case maxWidth(Dynamic<CGFloat>)
		case resizingMask(Dynamic<NSTableColumn.ResizingOptions>)
		case title(Dynamic<String>)
		case headerCell(Dynamic<NSTableHeaderCell>)
		case isEditable(Dynamic<Bool>)
		case sortDescriptorPrototype(Dynamic<NSSortDescriptor?>)
		case isHidden(Dynamic<Bool>)
		case headerToolTip(Dynamic<String?>)
		case sortFunction(Dynamic<(_ isRow: RowData, _ orderedBefore: RowData) -> Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case sizeToFit(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case cellConstructor((_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: Signal<RowData>) -> TableCellViewConvertible)
		case dataMissingCell(() -> TableCellViewConvertible?)
		case cellIdentifierForRow((RowData?) -> NSUserInterfaceItemIdentifier)
	}

	public struct Preparer: DerivedPreparer {
		public typealias EnclosingBinder = TableColumn
		public var linkedPreparer = Inherited.Preparer()

		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .width(let x): return x.apply(instance, storage) { i, s, v in i.width = v }
			case .minWidth(let x): return x.apply(instance, storage) { i, s, v in i.minWidth = v }
			case .maxWidth(let x): return x.apply(instance, storage) { i, s, v in i.maxWidth = v }
			case .resizingMask(let x): return x.apply(instance, storage) { i, s, v in i.resizingMask = v }
			case .title(let x): return x.apply(instance, storage) { i, s, v in i.title = v }
			case .headerCell(let x): return x.apply(instance, storage) { i, s, v in i.headerCell = v }
			case .isEditable(let x): return x.apply(instance, storage) { i, s, v in i.isEditable = v }
			case .sortDescriptorPrototype(let x): return x.apply(instance, storage) { i, s, v in i.sortDescriptorPrototype = v }
			case .isHidden(let x): return x.apply(instance, storage) { i, s, v in i.isHidden = v }
			case .headerToolTip(let x): return x.apply(instance, storage) { i, s, v in i.headerToolTip = v }
			case .sortFunction(let x):
				return x.apply(instance, storage) { i, s, v in
					s.sortFunction = v
				}
			case .sizeToFit(let x): return x.apply(instance, storage) { i, s, v in i.sizeToFit() }
			case .cellConstructor(let x):
				storage.cellConstructor = x
				return nil
			case .dataMissingCell(let x):
				storage.dataMissingCell = x
				return nil
			case .cellIdentifierForRow(let x):
				storage.cellIdentifier = x
				return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ObjectBinderStorage {
		// Retain the tableColumn since this binder will own the object (rather than the typical object owning the binder arrangment)
		open var tableColumn: NSTableColumn
		
		public required init(column: NSTableColumn) {
			self.tableColumn = column
			super.init()
		}
		
		open var sortFunction: ((_ isRow: RowData, _ orderedBefore: RowData) -> Bool)?
		open var cellConstructor: ((_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: Signal<RowData>) -> TableCellViewConvertible)?
		open var dataMissingCell: (() -> TableCellViewConvertible?)?
		open var cellIdentifier: ((RowData?) -> NSUserInterfaceItemIdentifier)?
	}
}

extension BindingName where Binding: TableColumnBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tableColumnBinding(TableColumn.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var width: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.width(v)) }) }
	public static var minWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.minWidth(v)) }) }
	public static var maxWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.maxWidth(v)) }) }
	public static var resizingMask: BindingName<Dynamic<NSTableColumn.ResizingOptions>, Binding> { return BindingName<Dynamic<NSTableColumn.ResizingOptions>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.resizingMask(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.title(v)) }) }
	public static var headerCell: BindingName<Dynamic<NSTableHeaderCell>, Binding> { return BindingName<Dynamic<NSTableHeaderCell>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.headerCell(v)) }) }
	public static var isEditable: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.isEditable(v)) }) }
	public static var sortDescriptorPrototype: BindingName<Dynamic<NSSortDescriptor?>, Binding> { return BindingName<Dynamic<NSSortDescriptor?>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.sortDescriptorPrototype(v)) }) }
	public static var isHidden: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.isHidden(v)) }) }
	public static var headerToolTip: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.headerToolTip(v)) }) }
	public static var sortFunction: BindingName<Dynamic<(_ isRow: Binding.RowDataType, _ orderedBefore: Binding.RowDataType) -> Bool>, Binding> { return BindingName<Dynamic<(_ isRow: Binding.RowDataType, _ orderedBefore: Binding.RowDataType) -> Bool>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.sortFunction(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var sizeToFit: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.sizeToFit(v)) }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var cellConstructor: BindingName<(_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: Signal<Binding.RowDataType>) -> TableCellViewConvertible, Binding> { return BindingName<(_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: Signal<Binding.RowDataType>) -> TableCellViewConvertible, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.cellConstructor(v)) }) }
	public static var dataMissingCell: BindingName<() -> TableCellViewConvertible?, Binding> { return BindingName<() -> TableCellViewConvertible?, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.dataMissingCell(v)) }) }
	public static var cellIdentifierForRow: BindingName<(Binding.RowDataType?) -> NSUserInterfaceItemIdentifier, Binding> { return BindingName<(Binding.RowDataType?) -> NSUserInterfaceItemIdentifier, Binding>({ v in .tableColumnBinding(TableColumn<Binding.RowDataType>.Binding.cellIdentifierForRow(v)) }) }
}

public protocol TableColumnBinding: BaseBinding {
	associatedtype RowDataType
	static func tableColumnBinding(_ binding: TableColumn<RowDataType>.Binding) -> Self
}
extension TableColumnBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return tableColumnBinding(.inheritedBinding(binding))
	}
}

