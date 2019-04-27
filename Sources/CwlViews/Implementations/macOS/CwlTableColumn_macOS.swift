//
//  CwlTableColumn_macOS.swift
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

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class TableColumn<RowData>: Binder {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableColumn {
	enum Binding: TableColumnBinding {
		public typealias RowDataType = RowData
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case identifier(Constant<NSUserInterfaceItemIdentifier>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case headerCell(Dynamic<NSTableHeaderCell>)
		case headerToolTip(Dynamic<String?>)
		case isEditable(Dynamic<Bool>)
		case isHidden(Dynamic<Bool>)
		case maxWidth(Dynamic<CGFloat>)
		case minWidth(Dynamic<CGFloat>)
		case resizingMask(Dynamic<NSTableColumn.ResizingOptions>)
		case sortDescriptorPrototype(Dynamic<NSSortDescriptor?>)
		case sortFunction(Dynamic<(_ isRow: RowData, _ orderedBefore: RowData) -> Bool>)
		case title(Dynamic<String>)
		case width(Dynamic<CGFloat>)

		// 2. Signal bindings are performed on the object after construction.
		case sizeToFit(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case cellConstructor((_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: SignalMulti<RowData>) -> TableCellViewConvertible)
		case cellIdentifierForRow((RowData?) -> NSUserInterfaceItemIdentifier)
		case dataMissingCell(() -> TableCellViewConvertible?)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableColumn {
	struct Preparer: BinderConstructor {
		public typealias Binding = TableColumn.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSTableColumn
		public typealias Output = Storage
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage(tableColumn: instance, cellConstructor: cellConstructor, cellIdentifier: cellIdentifier, dataMissingCell: dataMissingCell) }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		var columnIdentifier: NSUserInterfaceItemIdentifier?
		var cellConstructor: ((_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: SignalMulti<RowData>) -> TableCellViewConvertible)?
		var cellIdentifier: ((RowData?) -> NSUserInterfaceItemIdentifier)?
		var dataMissingCell: (() -> TableCellViewConvertible?)?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableColumn.Preparer {
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		return type.init(identifier: columnIdentifier ?? NSUserInterfaceItemIdentifier(UUID().uuidString))
	}
	
	func combine(lifetimes: [Lifetime], instance: Instance, storage: Storage) -> Storage {
		return storage
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .identifier(let x): columnIdentifier = x.value
		case .cellConstructor(let x): cellConstructor = x
		case .cellIdentifierForRow(let x): cellIdentifier = x
		case .dataMissingCell(let x): dataMissingCell = x
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .identifier: return nil
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .headerCell(let x): return x.apply(instance) { i, v in i.headerCell = v }
		case .headerToolTip(let x): return x.apply(instance) { i, v in i.headerToolTip = v }
		case .isEditable(let x): return x.apply(instance) { i, v in i.isEditable = v }
		case .isHidden(let x): return x.apply(instance) { i, v in i.isHidden = v }
		case .maxWidth(let x): return x.apply(instance) { i, v in i.maxWidth = v }
		case .minWidth(let x): return x.apply(instance) { i, v in i.minWidth = v }
		case .resizingMask(let x): return x.apply(instance) { i, v in i.resizingMask = v }
		case .sortDescriptorPrototype(let x): return x.apply(instance) { i, v in i.sortDescriptorPrototype = v }
		case .sortFunction(let x): return x.apply(instance, storage) { i, s, v in s.sortFunction = v }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .width(let x): return x.apply(instance) { i, v in i.width = v }

		// 2. Signal bindings are performed on the object after construction.
		case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }

		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .cellConstructor: return nil
		case .cellIdentifierForRow: return nil
		case .dataMissingCell: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableColumn.Preparer {
	open class Storage: AssociatedBinderStorage {
		public let tableColumn: NSTableColumn
		public let cellConstructor: ((_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: SignalMulti<RowData>) -> TableCellViewConvertible)?
		public let cellIdentifier: ((RowData?) -> NSUserInterfaceItemIdentifier)?
		public let dataMissingCell: (() -> TableCellViewConvertible?)?

		open var sortFunction: ((_ isRow: RowData, _ orderedBefore: RowData) -> Bool)?

		public init(tableColumn: NSTableColumn, cellConstructor: ((_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: SignalMulti<RowData>) -> TableCellViewConvertible)?, cellIdentifier: ((RowData?) -> NSUserInterfaceItemIdentifier)?, dataMissingCell: (() -> TableCellViewConvertible?)?) {
			self.tableColumn = tableColumn
			self.cellConstructor = cellConstructor
			self.cellIdentifier = cellIdentifier
			self.dataMissingCell = dataMissingCell
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TableColumnBinding {
	public typealias TableColumnName<V> = BindingName<V, TableColumn<Binding.RowDataType>.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> TableColumn<Binding.RowDataType>.Binding) -> TableColumnName<V> {
		return TableColumnName<V>(source: source, downcast: Binding.tableColumnBinding)
	}
}
public extension BindingName where Binding: TableColumnBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableColumnName<$2> { return .name(TableColumn.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var identifier: TableColumnName<Constant<NSUserInterfaceItemIdentifier>> { return .name(TableColumn.Binding.identifier) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var headerCell: TableColumnName<Dynamic<NSTableHeaderCell>> { return .name(TableColumn.Binding.headerCell) }
	static var headerToolTip: TableColumnName<Dynamic<String?>> { return .name(TableColumn.Binding.headerToolTip) }
	static var isEditable: TableColumnName<Dynamic<Bool>> { return .name(TableColumn.Binding.isEditable) }
	static var isHidden: TableColumnName<Dynamic<Bool>> { return .name(TableColumn.Binding.isHidden) }
	static var maxWidth: TableColumnName<Dynamic<CGFloat>> { return .name(TableColumn.Binding.maxWidth) }
	static var minWidth: TableColumnName<Dynamic<CGFloat>> { return .name(TableColumn.Binding.minWidth) }
	static var resizingMask: TableColumnName<Dynamic<NSTableColumn.ResizingOptions>> { return .name(TableColumn.Binding.resizingMask) }
	static var sortDescriptorPrototype: TableColumnName<Dynamic<NSSortDescriptor?>> { return .name(TableColumn.Binding.sortDescriptorPrototype) }
	static var sortFunction: TableColumnName<Dynamic<(_ isRow: Binding.RowDataType, _ orderedBefore: Binding.RowDataType) -> Bool>> { return .name(TableColumn.Binding.sortFunction) }
	static var title: TableColumnName<Dynamic<String>> { return .name(TableColumn.Binding.title) }
	static var width: TableColumnName<Dynamic<CGFloat>> { return .name(TableColumn.Binding.width) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var sizeToFit: TableColumnName<Signal<Void>> { return .name(TableColumn.Binding.sizeToFit) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var cellConstructor: TableColumnName<(_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: SignalMulti<Binding.RowDataType>) -> TableCellViewConvertible> { return .name(TableColumn.Binding.cellConstructor) }
	static var cellIdentifierForRow: TableColumnName<(Binding.RowDataType?) -> NSUserInterfaceItemIdentifier> { return .name(TableColumn.Binding.cellIdentifierForRow) }
	static var dataMissingCell: TableColumnName<() -> TableCellViewConvertible?> { return .name(TableColumn.Binding.dataMissingCell) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)

// MARK: - Binder Part 8: Downcast protocols
public protocol TableColumnBinding: BinderBaseBinding {
	associatedtype RowDataType
	static func tableColumnBinding(_ binding: TableColumn<RowDataType>.Binding) -> Self
	func asTableColumnBinding() -> TableColumn<RowDataType>.Binding?
}
public extension TableColumnBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return tableColumnBinding(.inheritedBinding(binding))
	}
}
public extension TableColumnBinding where Preparer.Inherited.Binding: TableColumnBinding, Preparer.Inherited.Binding.RowDataType == RowDataType {
	func asTableColumnBinding() -> TableColumn<RowDataType>.Binding? {
		return asInheritedBinding()?.asTableColumnBinding()
	}
}
public extension TableColumn.Binding {
	typealias Preparer = TableColumn.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asTableColumnBinding() -> TableColumn.Binding? { return self }
	static func tableColumnBinding(_ binding: TableColumn.Binding) -> TableColumn.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
