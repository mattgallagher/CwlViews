//
//  CwlTableView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 28/10/2015.
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
public class TableView<RowData>: Binder, TableViewConvertible {
	public static func scrollEmbedded(type: NSTableView.Type = NSTableView.self, _ bindings: Binding...) -> ScrollView {
		return ScrollView(
			.borderType -- .bezelBorder,
			.hasVerticalScroller -- true,
			.hasHorizontalScroller -- true,
			.autohidesScrollers -- true,
			.contentView -- ClipView(
				.documentView -- TableView<RowData>(type: type, bindings: bindings)
			)
		)
	}

	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableView {
	enum Binding: TableViewBinding {
		public typealias RowDataType = RowData
		
		case inheritedBinding(TableView<RowData>.Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsColumnReordering(Dynamic<Bool>)
		case allowsColumnResizing(Dynamic<Bool>)
		case allowsColumnSelection(Dynamic<Bool>)
		case allowsEmptySelection(Dynamic<Bool>)
		case allowsMultipleSelection(Dynamic<Bool>)
		case allowsTypeSelect(Dynamic<Bool>)
		case autosaveName(Dynamic<NSTableView.AutosaveName?>)
		case autosaveTableColumns(Dynamic<Bool>)
		case backgroundColor(Dynamic<NSColor>)
		case columnAutoresizingStyle(Dynamic<NSTableView.ColumnAutoresizingStyle>)
		case columns(Dynamic<[TableColumn<RowData>]>)
		case cornerView(Dynamic<ViewConvertible?>)
		case draggingDestinationFeedbackStyle(Dynamic<NSTableView.DraggingDestinationFeedbackStyle>)
		case floatsGroupRows(Dynamic<Bool>)
		case gridColor(Dynamic<NSColor>)
		case gridStyleMask(Dynamic<NSTableView.GridLineStyle>)
		case headerView(Dynamic<TableHeaderViewConvertible?>)
		case intercellSpacing(Dynamic<NSSize>)
		case rowHeight(Dynamic<CGFloat>)
		case rows(Dynamic<TableRowMutation<RowData>>)
		case rowSizeStyle(Dynamic<NSTableView.RowSizeStyle>)
		case selectionHighlightStyle(Dynamic<NSTableView.SelectionHighlightStyle>)
		case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)
		case usesAlternatingRowBackgroundColors(Dynamic<Bool>)
		case verticalMotionCanBeginDrag(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case deselectAll(Signal<Void>)
		case deselectColumn(Signal<NSUserInterfaceItemIdentifier>)
		case deselectRow(Signal<Int>)
		case highlightColumn(Signal<NSUserInterfaceItemIdentifier?>)
		case moveColumn(Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>)
		case scrollColumnToVisible(Signal<NSUserInterfaceItemIdentifier>)
		case scrollRowToVisible(Signal<Int>)
		case selectAll(Signal<Void>)
		case selectColumns(Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>)
		case selectRows(Signal<(indexes: IndexSet, byExtendingSelection: Bool)>)
		case sizeLastColumnToFit(Signal<Void>)
		case sizeToFit(Signal<Void>)
		
		@available(macOS 10.11, *) case hideRowActions(Signal<Void>)
		@available(macOS 10.11, *) case hideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		@available(macOS 10.11, *) case unhideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)

		// 3. Action bindings are triggered by the object after construction.
		case columnMoved(SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>)
		case columnResized(SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>)
		case didClickTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case didDragTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case doubleAction(TargetAction)
		case mouseDownInHeaderOfTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case selectionChanged(SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedRows: IndexSet)>)
		case sortDescriptorsDidChange(SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>)
		case visibleRowsChanged(SignalInput<CountableRange<Int>>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case acceptDrop((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> Bool)
		case draggingSessionEnded((_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void)
		case draggingSessionWillBegin((_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void)
		case groupRowCellConstructor((Int) -> TableCellViewConvertible)
		case heightOfRow((_ row: Int, _ rowData: RowData?) -> CGFloat)
		case isGroupRow((_ row: Int, _ rowData: RowData?) -> Bool)
		case nextTypeSelectMatch((_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int)
		case pasteboardWriter((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> NSPasteboardWriting)
		case rowView((_ row: Int, _ rowData: RowData?) -> TableRowViewConvertible?)
		case selectionIndexesForProposedSelection((_ tableView: NSTableView, IndexSet) -> IndexSet)
		case selectionShouldChange((_ tableView: NSTableView) -> Bool)
		case shouldReorderColumn((_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier, _ newIndex: Int) -> Bool)
		case shouldSelectRow((_ row: Int, _ rowData: RowData?) -> Bool)
		case shouldSelectTableColumn((_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool)
		case shouldTypeSelectForEvent((_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool)
		case sizeToFitWidthOfColumn((_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier) -> CGFloat)
		case typeSelectString((TableCell<RowData>) -> String?)
		case updateDraggingItems((_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void)
		case validateDrop((_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation)

		@available(macOS 10.11, *) case rowActionsForRow((_ row: Int, _ data: RowData?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction])
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TableView.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSTableView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		public var singleAction: TargetAction?
		public var doubleAction: TargetAction?
	}
}

public extension TableView.Preparer {
	var delegateIsRequired: Bool { return true }
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(.action(let x)): singleAction = x
		case .inheritedBinding(let x): inherited.prepareBinding(x)
			
		case .acceptDrop(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:acceptDrop:row:dropOperation:)))
		case .didDragTableColumn(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:didDrag:)))
		case .didClickTableColumn(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:didClick:)))
		case .doubleAction(let x): doubleAction = x
		case .draggingSessionEnded(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:draggingSession:endedAt:operation:)))
		case .draggingSessionWillBegin(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:draggingSession:willBeginAt:forRowIndexes:)))
		case .heightOfRow(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:heightOfRow:)))
		case .isGroupRow(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:isGroupRow:)))
		case .mouseDownInHeaderOfTableColumn(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:mouseDownInHeaderOf:)))
		case .nextTypeSelectMatch(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:nextTypeSelectMatchFromRow:toRow:for:)))
		case .pasteboardWriter(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:pasteboardWriterForRow:)))
		case .rowActionsForRow(let x):
			if #available(macOS 10.11, *) {
				delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:rowActionsForRow:edge:)))
			}
		case .rowView(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:rowViewForRow:)))
		case .selectionIndexesForProposedSelection(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:selectionIndexesForProposedSelection:)))
		case .selectionShouldChange(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.selectionShouldChange(in:)))
		case .shouldReorderColumn(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:shouldReorderColumn:toColumn:)))
		case .shouldSelectRow(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:shouldSelectRow:)))
		case .shouldSelectTableColumn(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:shouldSelect:)))
		case .shouldTypeSelectForEvent(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:shouldTypeSelectFor:withCurrentSearch:)))
		case .sizeToFitWidthOfColumn(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:sizeToFitWidthOfColumn:)))
		case .sortDescriptorsDidChange(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:sortDescriptorsDidChange:)))
		case .typeSelectString(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:typeSelectStringFor:row:)))
		case .updateDraggingItems(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:updateDraggingItemsForDrag:)))
		case .validateDrop(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:validateDrop:proposedRow:proposedDropOperation:)))
		default: break
		}
	}

	public func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)
		instance.dataSource = storage
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowsColumnReordering(let x): return x.apply(instance) { i, v in i.allowsColumnReordering = v }
		case .allowsColumnResizing(let x): return x.apply(instance) { i, v in i.allowsColumnResizing = v }
		case .allowsColumnSelection(let x): return x.apply(instance) { i, v in i.allowsColumnSelection = v }
		case .allowsEmptySelection(let x): return x.apply(instance) { i, v in i.allowsEmptySelection = v }
		case .allowsMultipleSelection(let x): return x.apply(instance) { i, v in i.allowsMultipleSelection = v }
		case .allowsTypeSelect(let x): return x.apply(instance) { i, v in i.allowsTypeSelect = v }
		case .autosaveName(let x): return x.apply(instance) { i, v in i.autosaveName = v }
		case .autosaveTableColumns(let x): return x.apply(instance) { i, v in i.autosaveTableColumns = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .columnAutoresizingStyle(let x): return x.apply(instance) { i, v in i.columnAutoresizingStyle = v }
		case .columns(let x): return x.apply(instance, storage) { i, s, v in s.updateColumns(v.map { $0.construct() }, in: i) }
		case .cornerView(let x): return x.apply(instance) { i, v in i.cornerView = v?.nsView() }
		case .draggingDestinationFeedbackStyle(let x): return x.apply(instance) { i, v in i.draggingDestinationFeedbackStyle = v }
		case .floatsGroupRows(let x): return x.apply(instance) { i, v in i.floatsGroupRows = v }
		case .gridColor(let x): return x.apply(instance) { i, v in i.gridColor = v }
		case .gridStyleMask(let x): return x.apply(instance) { i, v in i.gridStyleMask = v }
		case .intercellSpacing(let x): return x.apply(instance) { i, v in i.intercellSpacing = v }
		case .rowHeight(let x): return x.apply(instance) { i, v in i.rowHeight = v }
		case .rowSizeStyle(let x): return x.apply(instance) { i, v in i.rowSizeStyle = v }
		case .selectionHighlightStyle(let x): return x.apply(instance) { i, v in i.selectionHighlightStyle = v }
		case .userInterfaceLayoutDirection(let x): return x.apply(instance) { i, v in i.userInterfaceLayoutDirection = v }
		case .usesAlternatingRowBackgroundColors(let x): return x.apply(instance) { i, v in i.usesAlternatingRowBackgroundColors = v }
		case .verticalMotionCanBeginDrag(let x): return x.apply(instance) { i, v in i.verticalMotionCanBeginDrag = v }

		// 2. Signal bindings are performed on the object after construction.
		case .deselectAll(let x): return x.apply(instance) { i, v in i.deselectAll(nil) }
		case .deselectColumn(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
					i.deselectColumn(index)
				}
			}
		case .deselectRow(let x): return x.apply(instance) { i, v in i.deselectRow(v) }
		case .highlightColumn(let x):
			return x.apply(instance) { i, v in
				i.highlightedTableColumn = v.flatMap { (identifier: NSUserInterfaceItemIdentifier) -> NSTableColumn? in
					return i.tableColumns.first(where: { $0.identifier == identifier })
				}
			}
		case .moveColumn(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v.identifier })?.offset {
					i.moveColumn(index, toColumn: v.toIndex)
				}
			}
		case .scrollRowToVisible(let x): return x.apply(instance) { i, v in i.scrollRowToVisible(v) }
		case .scrollColumnToVisible(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
					i.scrollColumnToVisible(index)
				}
			}
		case .selectAll(let x): return x.apply(instance) { i, v in i.selectAll(nil) }
		case .selectColumns(let x):
			return x.apply(instance) { i, v in
				let indexes = v.identifiers.compactMap { identifier in i.tableColumns.enumerated().first(where: { $0.element.identifier == identifier })?.offset }
				let indexSet = IndexSet(indexes)
				i.selectColumnIndexes(indexSet, byExtendingSelection: v.byExtendingSelection)
			}
		case .selectRows(let x): return x.apply(instance) { i, v in i.selectRowIndexes(v.indexes, byExtendingSelection: v.byExtendingSelection) }
		case .sizeLastColumnToFit(let x): return x.apply(instance) { i, v in i.sizeLastColumnToFit() }
		case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }
		
		case .hideRowActions(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					i.rowActionsVisible = false
				}
			}
		case .hideRows(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					i.hideRows(at: v.indexes, withAnimation: v.withAnimation)
				}
			}
		case .unhideRows(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					i.unhideRows(at: v.indexes, withAnimation: v.withAnimation)
				}
			}

		// 3. Action bindings are triggered by the object after construction.
		case .columnMoved(let x):
			return Signal.notifications(name: NSTableView.columnDidMoveNotification, object: instance).compactMap { [weak instance] notification -> (column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)? in
				guard let index = (notification.userInfo?["NSNewColumn"] as? NSNumber)?.intValue, let column = instance?.tableColumns.at(index) else {
					return nil
				}
				guard let oldIndex = (notification.userInfo?["NSNewColumn"] as? NSNumber)?.intValue else {
					return nil
				}
				return (column: column.identifier, oldIndex: oldIndex, newIndex: index)
				}.cancellableBind(to: x)
		case .columnResized(let x):
			return Signal.notifications(name: NSTableView.columnDidResizeNotification, object: instance).compactMap { notification -> (column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)? in
				guard let column = (notification.userInfo?["NSTableColumn"] as? NSTableColumn) else {
					return nil
				}
				guard let oldWidth = (notification.userInfo?["NSOldWidth"] as? NSNumber)?.doubleValue else {
					return nil
				}
				return (column: column.identifier, oldWidth: CGFloat(oldWidth), newWidth: column.width)
				}.cancellableBind(to: x)
		case .didClickTableColumn: return nil
		case .didDragTableColumn: return nil
		case .doubleAction: return nil
		case .mouseDownInHeaderOfTableColumn: return nil
		case .selectionChanged(let x):
			return Signal.notifications(name: NSTableView.selectionDidChangeNotification, object: instance).compactMap { [weak instance] n -> (selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedRows: IndexSet)? in
				guard let i = instance else {
					return nil
				}
				let selectedColumns = Set<NSUserInterfaceItemIdentifier>(i.selectedColumnIndexes.compactMap { i.tableColumns.at($0)?.identifier })
				let selectedRowIndexes = IndexSet(i.selectedRowIndexes.map { $0 })
				return (selectedColumns: selectedColumns, selectedRows: selectedRowIndexes as IndexSet)
			}.cancellableBind(to: x)
		case .sortDescriptorsDidChange: return nil
		case .visibleRowsChanged(let x):
			storage.visibleRowsSignalInput = x
			return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .acceptDrop: return nil
		case .draggingSessionEnded: return nil
		case .draggingSessionWillBegin: return nil
		case .groupRowCellConstructor(let x):
			storage.groupRowCellConstructor = x
			return nil
		case .headerView(let x): return x.apply(instance) { i, v in i.headerView = v?.nsTableHeaderView() }
		case .heightOfRow: return nil
		case .isGroupRow: return nil
		case .nextTypeSelectMatch: return nil
		case .pasteboardWriter: return nil
		case .rowActionsForRow: return nil
		case .rows(let x): return x.apply(instance, storage) { i, s, v in s.applyTableRowMutation(v, in: i) }
		case .rowView: return nil
		case .selectionIndexesForProposedSelection: return nil
		case .selectionShouldChange: return nil
		case .shouldReorderColumn: return nil
		case .shouldSelectRow: return nil
		case .shouldSelectTableColumn: return nil
		case .shouldTypeSelectForEvent: return nil
		case .sizeToFitWidthOfColumn: return nil
		case .typeSelectString: return nil
		case .updateDraggingItems: return nil
		case .validateDrop: return nil
		}
	}
	
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		var lifetimes = [Lifetime]()
		
		switch (singleAction, doubleAction) {
		case (nil, nil): break
		case (.firstResponder(let sa)?, .firstResponder(let da)?):
			instance.action = sa
			instance.doubleAction = da
			instance.target = nil
		case (.singleTarget(let st)?, .singleTarget(let dt)?):
			let target = SignalDoubleActionTarget()
			instance.target = target 
			lifetimes += target.signal.cancellableBind(to: st)
			lifetimes += target.signal.cancellableBind(to: dt)
			instance.action = SignalDoubleActionTarget.selector
			instance.doubleAction = SignalDoubleActionTarget.secondSelector
		case (let s?, nil):
			lifetimes += s.apply(to: instance, constructTarget: SignalActionTarget.init)
		case (nil, let d?):
			lifetimes += d.apply(to: instance, constructTarget: SignalActionTarget.init)
			instance.doubleAction = instance.action
			instance.action = nil
		case (.some, .some): fatalError("Action and double action may not use mix of single target and first responder")
		}
		
		return AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableView.Preparer {
	open class Storage: View.Preparer.Storage, NSTableViewDelegate, NSTableViewDataSource {
		open override var isInUse: Bool { return true }

		open var actionTarget: SignalDoubleActionTarget? = nil
		open var rowState: TableRowState<RowData> = TableRowState<RowData>()
		open var visibleRows: IndexSet = []
		open var visibleRowsSignalInput: SignalInput<CountableRange<Int>>? = nil
		open var groupRowCellConstructor: ((Int) -> TableCellViewConvertible)?
		open var columns: [TableColumn<RowData>.Preparer.Storage] = []
		
		fileprivate func rowData(at row: Int) -> RowData? {
			return rowState.rows.at(row)
		}
		
		open func columnForIdentifier(_ identifier: NSUserInterfaceItemIdentifier) -> (offset: Int, element: TableColumn<RowData>.Preparer.Storage)? {
			return columns.enumerated().first { (tuple: (offset: Int, element: TableColumn<RowData>.Preparer.Storage)) -> Bool in
				tuple.element.tableColumn.identifier == identifier
			}
		}
		
		open func numberOfRows(in tableView: NSTableView) -> Int {
			return rowState.globalCount
		}

		open func tableView(_ tableView: NSTableView, didAdd: NSTableRowView, forRow: Int) {
			Exec.mainAsync.invoke {
				if let vrsi = self.visibleRowsSignalInput {
					let previousMin = self.visibleRows.min() ?? 0
					let previousMax = self.visibleRows.max() ?? previousMin
					self.visibleRows.insert(forRow)
					let newMin = self.visibleRows.min() ?? 0
					let newMax = self.visibleRows.max() ?? newMin
					if previousMin != newMin || previousMax != newMax {
						vrsi.send(value: newMin..<newMax)
					}
				}
			}
		}
		
		open func tableView(_ tableView: NSTableView, didRemove: NSTableRowView, forRow: Int) {
			Exec.mainAsync.invoke {
				if let vrsi = self.visibleRowsSignalInput {
					let previousMin = self.visibleRows.min() ?? 0
					let previousMax = self.visibleRows.max() ?? previousMin
					self.visibleRows.remove(forRow)
					let newMin = self.visibleRows.min() ?? 0
					let newMax = self.visibleRows.max() ?? newMin
					if previousMin != newMin || previousMax != newMax {
						vrsi.send(value: newMin..<newMax)
					}
				}
			}
		}

		open func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
			return nil
		}
		
		open func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			if let tc = tableColumn {
				if let col = columnForIdentifier(tc.identifier) {
					let data = rowState.rows.at(row - rowState.localOffset)
					let identifier = col.element.cellIdentifier?(data) ?? tc.identifier

					let cellView: NSTableCellView
					let cellInput: SignalInput<RowData>?
					if let reusedView = tableView.makeView(withIdentifier: identifier, owner: tableView), let downcast = reusedView as? NSTableCellView {
						cellView = downcast
						cellInput = getSignalInput(for: cellView, valueType: RowData.self)
					} else if let cc = col.element.cellConstructor {
						let dataTuple = Signal<RowData>.create()
						let constructed = cc(identifier, dataTuple.signal).nsTableCellView()
						if constructed.identifier == nil {
							constructed.identifier = identifier
						}
						cellView = constructed
						cellInput = dataTuple.input
						setSignalInput(for: cellView, to: dataTuple.input)
					} else {
						return col.element.dataMissingCell?()?.nsTableCellView()
					}
					
					if let d = data {
						_ = cellInput?.send(value: d)
					}
					return cellView
				}
			} else {
				return groupRowCellConstructor?(row).nsTableCellView()
			}
			return nil
		}

		open func updateColumns(_ v: [TableColumn<RowData>.Preparer.Storage], in tableView: NSTableView) {
			columns = v
			let columnsArray = v.map { $0.tableColumn }
			let newColumnSet = Set(columnsArray)
			let oldColumnSet = Set(tableView.tableColumns)
			
			for c in columnsArray {
				if !oldColumnSet.contains(c) {
					tableView.addTableColumn(c)
				}
				if !newColumnSet.contains(c) {
					tableView.removeTableColumn(c)
				}
			}
		}

		open func applyTableRowMutation(_ rowMutation: TableRowMutation<RowData>, in tableView: NSTableView) {
			rowMutation.apply(to: &rowState)
			switch rowMutation.arrayMutation.kind {
			case .delete:
				tableView.removeRows(at: rowMutation.arrayMutation.indexSet.offset(by: rowState.localOffset), withAnimation: rowMutation.animation)
			case .move(let destination):
				tableView.beginUpdates()
				for (count, index) in rowMutation.arrayMutation.indexSet.offset(by: rowState.localOffset).enumerated() {
					tableView.moveRow(at: index, to: destination + count)
				}
				tableView.endUpdates()
			case .insert:
				tableView.insertRows(at: rowMutation.arrayMutation.indexSet.offset(by: rowState.localOffset), withAnimation: rowMutation.animation)
			case .scroll:
				tableView.reloadData(forRowIndexes: rowMutation.arrayMutation.indexSet.offset(by: rowState.localOffset), columnIndexes: IndexSet(integersIn: 0..<tableView.tableColumns.count))
			case .update:
				for rowIndex in rowMutation.arrayMutation.indexSet {
					for columnIndex in 0..<tableView.numberOfColumns {
						guard let cell = tableView.view(atColumn: columnIndex, row: rowIndex, makeIfNecessary: false), let value = rowState.rows.at(rowIndex - rowState.localOffset) else { continue }
						getSignalInput(for: cell, valueType: RowData.self)?.send(value: value)
					}
				}
			case .reload:
				tableView.reloadData()
			}
		}
	}

	open class Delegate: DynamicDelegate, NSTableViewDelegate, NSTableViewDataSource {
		private func storage(for tableView: NSTableView) -> Storage? {
			return tableView.delegate as? Storage
		}
		
		open func tableView(_ tableView: NSTableView, didDrag tableColumn: NSTableColumn) {
			handler(ofType: SignalInput<NSUserInterfaceItemIdentifier>.self).send(value: tableColumn.identifier)
		}

		open func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
			handler(ofType: SignalInput<NSUserInterfaceItemIdentifier>.self).send(value: tableColumn.identifier)
		}

		open func tableView(_ tableView: NSTableView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
			handler(ofType: SignalInput<NSUserInterfaceItemIdentifier>.self).send(value: tableColumn.identifier)
		}

		open func tableView(_ tableView: NSTableView, rowViewForRow rowIndex: Int) -> NSTableRowView? {
			return handler(ofType: ((Int, RowData?) -> TableRowViewConvertible?).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))?.nsTableRowView()
		}

		open func tableView(_ tableView: NSTableView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
			if let column = tableView.tableColumns.at(columnIndex) {
				return handler(ofType: ((NSTableView, NSUserInterfaceItemIdentifier, Int) -> Bool).self)(tableView, column.identifier, newColumnIndex)
			}
			return false
		}

		open func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
			if let column = tableView.tableColumns.at(column) {
				return handler(ofType: ((NSTableView, NSUserInterfaceItemIdentifier) -> CGFloat).self)(tableView, column.identifier)
			}
			return 0
		}

		open func tableView(_ tableView: NSTableView, shouldTypeSelectFor event: NSEvent, withCurrentSearch searchString: String?) -> Bool {
			return handler(ofType: ((NSTableView, NSEvent, String?) -> Bool).self)(tableView, event, searchString)
		}

		open var typeSelectString: ((TableCell<RowData>) -> String?)?
		open func tableView(_ tableView: NSTableView, typeSelectStringFor tableColumn: NSTableColumn?, row: Int) -> String? {
			guard let tc = tableColumn, row >= 0 else { return nil }
			return typeSelectString!(TableCell(row: row, column: tc, tableView: tableView))
		}

		open func tableView(_ tableView: NSTableView, nextTypeSelectMatchFromRow startRow: Int, toRow endRow: Int, for searchString: String) -> Int {
			return handler(ofType: ((NSTableView, Int, Int, String) -> Int).self)(tableView, startRow, endRow, searchString)
		}

		open func tableView(_ tableView: NSTableView, heightOfRow rowIndex: Int) -> CGFloat {
			return handler(ofType: ((Int, RowData?) -> CGFloat).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
			return handler(ofType: ((NSTableView, NSTableColumn?) -> Bool).self)(tableView, tableColumn)
		}

		open func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
			return handler(ofType: ((NSTableView, IndexSet) -> IndexSet).self)(tableView, proposedSelectionIndexes)
		}

		open func tableView(_ tableView: NSTableView, shouldSelectRow rowIndex: Int) -> Bool {
			return handler(ofType: ((Int, RowData?) -> Bool).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func selectionShouldChange(in tableView: NSTableView) -> Bool {
			return handler(ofType: ((NSTableView) -> Bool).self)(tableView)
		}

		open func tableView(_ tableView: NSTableView, isGroupRow rowIndex: Int) -> Bool {
			return handler(ofType: ((Int, RowData?) -> Bool).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
			handler(ofType: SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>.self).send(value: (new: tableView.sortDescriptors, old: oldDescriptors))
		}

		open func tableView(_ tableView: NSTableView, pasteboardWriterForRow rowIndex: Int) -> NSPasteboardWriting? {
			return handler(ofType: ((NSTableView, Int, RowData?) -> NSPasteboardWriting?).self)(tableView, rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row rowIndex: Int, dropOperation: NSTableView.DropOperation) -> Bool {
			return handler(ofType: ((NSTableView, Int, RowData?) -> Bool).self)(tableView, rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
			return handler(ofType: ((NSTableView, NSDraggingInfo, Int, NSTableView.DropOperation) -> NSDragOperation).self)(tableView, info, row, dropOperation)
		}

		open func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
			return handler(ofType: ((NSTableView, NSDraggingSession, NSPoint, IndexSet) -> Void).self)(tableView, session, screenPoint, rowIndexes)
		}

		open func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
			return handler(ofType: ((NSTableView, NSDraggingInfo) -> Void).self)(tableView, draggingInfo)
		}

		open func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
			return handler(ofType: ((NSTableView, NSDraggingSession, NSPoint, NSDragOperation) -> Void).self)(tableView, session, screenPoint, operation)
		}

		@available(macOS 10.11, *)
		open func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
			return handler(ofType: ((NSTableView, Int, NSTableView.RowActionEdge) -> [NSTableViewRowAction]).self)(tableView, row, edge)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TableViewBinding {
	public typealias TableViewName<V> = BindingName<V, TableView<Binding.RowDataType>.Binding, Binding>
	private typealias B = TableView<Binding.RowDataType>.Binding
	private static func name<V>(_ source: @escaping (V) -> TableView<Binding.RowDataType>.Binding) -> TableViewName<V> {
		return TableViewName<V>(source: source, downcast: Binding.tableViewBinding)
	}
}
extension BindingName where Binding: TableViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableViewName<$2> { return .name(B.$1) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsColumnReordering: TableViewName<Dynamic<Bool>> { return .name(B.allowsColumnReordering) }
	static var allowsColumnResizing: TableViewName<Dynamic<Bool>> { return .name(B.allowsColumnResizing) }
	static var allowsColumnSelection: TableViewName<Dynamic<Bool>> { return .name(B.allowsColumnSelection) }
	static var allowsEmptySelection: TableViewName<Dynamic<Bool>> { return .name(B.allowsEmptySelection) }
	static var allowsMultipleSelection: TableViewName<Dynamic<Bool>> { return .name(B.allowsMultipleSelection) }
	static var allowsTypeSelect: TableViewName<Dynamic<Bool>> { return .name(B.allowsTypeSelect) }
	static var autosaveName: TableViewName<Dynamic<NSTableView.AutosaveName?>> { return .name(B.autosaveName) }
	static var autosaveTableColumns: TableViewName<Dynamic<Bool>> { return .name(B.autosaveTableColumns) }
	static var backgroundColor: TableViewName<Dynamic<NSColor>> { return .name(B.backgroundColor) }
	static var columnAutoresizingStyle: TableViewName<Dynamic<NSTableView.ColumnAutoresizingStyle>> { return .name(B.columnAutoresizingStyle) }
	static var columns: TableViewName<Dynamic<[TableColumn<Binding.RowDataType>]>> { return .name(B.columns) }
	static var cornerView: TableViewName<Dynamic<ViewConvertible?>> { return .name(B.cornerView) }
	static var draggingDestinationFeedbackStyle: TableViewName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>> { return .name(B.draggingDestinationFeedbackStyle) }
	static var floatsGroupRows: TableViewName<Dynamic<Bool>> { return .name(B.floatsGroupRows) }
	static var gridColor: TableViewName<Dynamic<NSColor>> { return .name(B.gridColor) }
	static var gridStyleMask: TableViewName<Dynamic<NSTableView.GridLineStyle>> { return .name(B.gridStyleMask) }
	static var headerView: TableViewName<Dynamic<TableHeaderViewConvertible?>> { return .name(B.headerView) }
	static var intercellSpacing: TableViewName<Dynamic<NSSize>> { return .name(B.intercellSpacing) }
	static var rowHeight: TableViewName<Dynamic<CGFloat>> { return .name(B.rowHeight) }
	static var rows: TableViewName<Dynamic<TableRowMutation<Binding.RowDataType>>> { return .name(B.rows) }
	static var rowSizeStyle: TableViewName<Dynamic<NSTableView.RowSizeStyle>> { return .name(B.rowSizeStyle) }
	static var selectionHighlightStyle: TableViewName<Dynamic<NSTableView.SelectionHighlightStyle>> { return .name(B.selectionHighlightStyle) }
	static var userInterfaceLayoutDirection: TableViewName<Dynamic<NSUserInterfaceLayoutDirection>> { return .name(B.userInterfaceLayoutDirection) }
	static var usesAlternatingRowBackgroundColors: TableViewName<Dynamic<Bool>> { return .name(B.usesAlternatingRowBackgroundColors) }
	static var verticalMotionCanBeginDrag: TableViewName<Dynamic<Bool>> { return .name(B.verticalMotionCanBeginDrag) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var deselectAll: TableViewName<Signal<Void>> { return .name(B.deselectAll) }
	static var deselectColumn: TableViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(B.deselectColumn) }
	static var deselectRow: TableViewName<Signal<Int>> { return .name(B.deselectRow) }
	static var highlightColumn: TableViewName<Signal<NSUserInterfaceItemIdentifier?>> { return .name(B.highlightColumn) }
	static var moveColumn: TableViewName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>> { return .name(B.moveColumn) }
	static var scrollColumnToVisible: TableViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(B.scrollColumnToVisible) }
	static var scrollRowToVisible: TableViewName<Signal<Int>> { return .name(B.scrollRowToVisible) }
	static var selectAll: TableViewName<Signal<Void>> { return .name(B.selectAll) }
	static var selectColumns: TableViewName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>> { return .name(B.selectColumns) }
	static var selectRows: TableViewName<Signal<(indexes: IndexSet, byExtendingSelection: Bool)>> { return .name(B.selectRows) }
	static var sizeLastColumnToFit: TableViewName<Signal<Void>> { return .name(B.sizeLastColumnToFit) }
	static var sizeToFit: TableViewName<Signal<Void>> { return .name(B.sizeToFit) }
	
	@available(macOS 10.11, *) static var hideRowActions: TableViewName<Signal<Void>> { return .name(B.hideRowActions) }
	@available(macOS 10.11, *) static var hideRows: TableViewName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>> { return .name(B.hideRows) }
	@available(macOS 10.11, *) static var unhideRows: TableViewName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>> { return .name(B.unhideRows) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var columnMoved: TableViewName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>> { return .name(B.columnMoved) }
	static var columnResized: TableViewName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>> { return .name(B.columnResized) }
	static var didClickTableColumn: TableViewName<SignalInput<NSUserInterfaceItemIdentifier>> { return .name(B.didClickTableColumn) }
	static var didDragTableColumn: TableViewName<SignalInput<NSUserInterfaceItemIdentifier>> { return .name(B.didDragTableColumn) }
	static var doubleAction: TableViewName<TargetAction> { return .name(B.doubleAction) }
	static var mouseDownInHeaderOfTableColumn: TableViewName<SignalInput<NSUserInterfaceItemIdentifier>> { return .name(B.mouseDownInHeaderOfTableColumn) }
	static var selectionChanged: TableViewName<SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedRows: IndexSet)>> { return .name(B.selectionChanged) }
	static var sortDescriptorsDidChange: TableViewName<SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>> { return .name(B.sortDescriptorsDidChange) }
	static var visibleRowsChanged: TableViewName<SignalInput<CountableRange<Int>>> { return .name(B.visibleRowsChanged) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var acceptDrop: TableViewName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> Bool> { return .name(B.acceptDrop) }
	static var draggingSessionEnded: TableViewName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void> { return .name(B.draggingSessionEnded) }
	static var draggingSessionWillBegin: TableViewName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void> { return .name(B.draggingSessionWillBegin) }
	static var groupRowCellConstructor: TableViewName<(Int) -> TableCellViewConvertible> { return .name(B.groupRowCellConstructor) }
	static var heightOfRow: TableViewName<(_ row: Int, _ rowData: Binding.RowDataType?) -> CGFloat> { return .name(B.heightOfRow) }
	static var isGroupRow: TableViewName<(_ row: Int, _ rowData: Binding.RowDataType?) -> Bool> { return .name(B.isGroupRow) }
	static var nextTypeSelectMatch: TableViewName<(_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int> { return .name(B.nextTypeSelectMatch) }
	static var pasteboardWriter: TableViewName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> NSPasteboardWriting> { return .name(B.pasteboardWriter) }
	static var rowView: TableViewName<(_ row: Int, _ rowData: Binding.RowDataType?) -> TableRowViewConvertible?> { return .name(B.rowView) }
	static var selectionIndexesForProposedSelection: TableViewName<(_ tableView: NSTableView, IndexSet) -> IndexSet> { return .name(B.selectionIndexesForProposedSelection) }
	static var selectionShouldChange: TableViewName<(_ tableView: NSTableView) -> Bool> { return .name(B.selectionShouldChange) }
	static var shouldReorderColumn: TableViewName<(_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier, _ newIndex: Int) -> Bool> { return .name(B.shouldReorderColumn) }
	static var shouldSelectRow: TableViewName<(_ row: Int, _ rowData: Binding.RowDataType?) -> Bool> { return .name(B.shouldSelectRow) }
	static var shouldSelectTableColumn: TableViewName<(_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool> { return .name(B.shouldSelectTableColumn) }
	static var shouldTypeSelectForEvent: TableViewName<(_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool> { return .name(B.shouldTypeSelectForEvent) }
	static var sizeToFitWidthOfColumn: TableViewName<(_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier) -> CGFloat> { return .name(B.sizeToFitWidthOfColumn) }
	static var typeSelectString: TableViewName<(TableCell<Binding.RowDataType>) -> String?> { return .name(B.typeSelectString) }
	static var updateDraggingItems: TableViewName<(_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void> { return .name(B.updateDraggingItems) }
	static var validateDrop: TableViewName<(_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation> { return .name(B.validateDrop) }
	
	@available(macOS 10.11, *) static var rowActionsForRow: TableViewName<(_ row: Int, _ data: Binding.RowDataType?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction]> { return .name(B.rowActionsForRow) }

	// Composite binding names
	public static func doubleAction<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> TableViewName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, TableView.Binding.doubleAction, Binding.tableViewBinding)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableViewConvertible: ControlConvertible {
	func nsTableView() -> NSTableView
}
extension NSTableView: TableViewConvertible, HasDelegate {
	public func nsTableView() -> NSTableView { return self }
}
public extension TableViewConvertible {
	func nsControl() -> Control.Instance { return nsTableView() }
}
public extension TableView {
	public func nsTableView() -> NSTableView { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableViewBinding: ControlBinding {
	associatedtype RowDataType
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> Self
}
public extension TableViewBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return tableViewBinding(TableView<RowDataType>.Binding.inheritedBinding(binding))
	}
}
public extension TableView.Binding {
	public typealias Preparer = Window.Preparer
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> TableView<RowDataType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct TableCell<RowData> {
	public let row: Int
	public let column: Int
	public let columnIdentifier: NSUserInterfaceItemIdentifier
	public let data: RowData?
	
	public init(row: Int, column: Int, tableView: NSTableView) {
		self.row = row
		self.column = column
		self.columnIdentifier = tableView.tableColumns[column].identifier
		self.data = (tableView.delegate as? TableView<RowData>.Preparer.Storage)?.rowData(at: row)
	}
	
	public init(row: Int, column: NSTableColumn, tableView: NSTableView) {
		self.row = row
		self.column = tableView.column(withIdentifier: column.identifier)
		self.columnIdentifier = column.identifier
		self.data = (tableView.delegate as? TableView<RowData>.Preparer.Storage)?.rowData(at: row)
	}
}

#endif
