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

public class TableView<RowData>: Binder, TableViewConvertible {
	public static func scrollEmbedded(subclass: NSTableView.Type = NSTableView.self, _ bindings: Binding...) -> ScrollView {
		return ScrollView(
			.borderType -- .bezelBorder,
			.hasVerticalScroller -- true,
			.hasHorizontalScroller -- true,
			.autohidesScrollers -- true,
			.contentView -- ClipView(
				.documentView -- TableView<RowData>(subclass: subclass, bindings: bindings)
			)
		)
	}

	public typealias Instance = NSTableView
	public typealias Inherited = Control
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsTableView() -> NSTableView { return instance() }

	enum Binding: TableViewBinding {
		public typealias RowDataType = RowData
		public typealias EnclosingBinder = TableView
		public static func tableViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsColumnReordering(Dynamic<Bool>)
		case allowsColumnResizing(Dynamic<Bool>)
		case allowsMultipleSelection(Dynamic<Bool>)
		case allowsEmptySelection(Dynamic<Bool>)
		case allowsColumnSelection(Dynamic<Bool>)
		case intercellSpacing(Dynamic<NSSize>)
		case rowHeight(Dynamic<CGFloat>)
		case backgroundColor(Dynamic<NSColor>)
		case usesAlternatingRowBackgroundColors(Dynamic<Bool>)
		case selectionHighlightStyle(Dynamic<NSTableView.SelectionHighlightStyle>)
		case gridColor(Dynamic<NSColor>)
		case gridStyleMask(Dynamic<NSTableView.GridLineStyle>)
		case rowSizeStyle(Dynamic<NSTableView.RowSizeStyle>)
		case allowsTypeSelect(Dynamic<Bool>)
		case floatsGroupRows(Dynamic<Bool>)
		case columnAutoresizingStyle(Dynamic<NSTableView.ColumnAutoresizingStyle>)
		case autosaveName(Dynamic<NSTableView.AutosaveName?>)
		case autosaveTableColumns(Dynamic<Bool>)
		case verticalMotionCanBeginDrag(Dynamic<Bool>)
		case draggingDestinationFeedbackStyle(Dynamic<NSTableView.DraggingDestinationFeedbackStyle>)
		case headerView(Dynamic<TableHeaderViewConvertible?>)
		case cornerView(Dynamic<ViewConvertible?>)
		case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)
		case columns(Dynamic<[TableColumn<RowData>]>)
		case rows(Dynamic<TableRowMutation<RowData>>)

		// 2. Signal bindings are performed on the object after construction.
		case highlightColumn(Signal<NSUserInterfaceItemIdentifier?>)
		case selectColumns(Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>)
		case selectRows(Signal<(indexes: IndexSet, byExtendingSelection: Bool)>)
		case deselectColumn(Signal<NSUserInterfaceItemIdentifier>)
		case deselectRow(Signal<Int>)
		case selectAll(Signal<Void>)
		case deselectAll(Signal<Void>)
		case sizeLastColumnToFit(Signal<Void>)
		case sizeToFit(Signal<Void>)
		case scrollRowToVisible(Signal<Int>)
		case scrollColumnToVisible(Signal<NSUserInterfaceItemIdentifier>)
		case moveColumn(Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>)
		@available(macOS 10.11, *) case hideRowActions(Signal<Void>)
		@available(macOS 10.11, *) case hideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		@available(macOS 10.11, *) case unhideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)

		// 3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		case doubleAction(TargetAction)
		case selectionChanged(SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedRows: IndexSet)>)
		case columnResized(SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>)
		case columnMoved(SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>)
		case didDragTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case didClickTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case mouseDownInHeaderOfTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case visibleRowsChanged(SignalInput<CountableRange<Int>>)
		case sortDescriptorsDidChange(SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case groupRowCellConstructor((Int) -> TableCellViewConvertible)
		case rowView((_ row: Int, _ rowData: RowData?) -> TableRowViewConvertible?)
		case isGroupRow((_ row: Int, _ rowData: RowData?) -> Bool)
		case heightOfRow((_ row: Int, _ rowData: RowData?) -> CGFloat)
		case shouldSelectRow((_ row: Int, _ rowData: RowData?) -> Bool)
		@available(macOS 10.11, *) case rowActionsForRow((_ row: Int, _ data: RowData?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction])
		case typeSelectString((TableCell<RowData>) -> String?)

		case shouldReorderColumn((_ tableView: NSTableView, _ column: NSTableColumn, _ newIndex: Int) -> Bool)
		case sizeToFitWidthOfColumn((_ tableView: NSTableView, _ column: NSTableColumn) -> CGFloat)
		case shouldTypeSelectForEvent((_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool)
		case nextTypeSelectMatch((_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int)
		case shouldSelectTableColumn((_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool)
		case selectionIndexesForProposedSelection((_ tableView: NSTableView, IndexSet) -> IndexSet)
		case selectionShouldChange((_ tableView: NSTableView) -> Bool)
		
		case pasteboardWriter((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> NSPasteboardWriting)
		case acceptDrop((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> Bool)
		case validateDrop((_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation)
		case draggingSessionWillBegin((_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void)
		case updateDraggingItems((_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void)
		case draggingSessionEnded((_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void)
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = TableView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }

		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var possibleDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}

		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .didDragTableColumn(let x):
				let s = #selector(NSTableViewDelegate.tableView(_:didDrag:))
				delegate().addSelector(s).didDragTableColumn = { tc in x.send(value: tc.identifier) }
			case .didClickTableColumn(let x):
				let s = #selector(NSTableViewDelegate.tableView(_:didClick:))
				delegate().addSelector(s).didClickTableColumn = { tc in x.send(value: tc.identifier) }
			case .mouseDownInHeaderOfTableColumn(let x):
				let s = #selector(NSTableViewDelegate.tableView(_:mouseDownInHeaderOf:))
				delegate().addSelector(s).mouseDownInHeaderOfTableColumn = { tc in x.send(value: tc.identifier) }
			case .rowView(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:rowViewForRow:)))
			case .rowActionsForRow(let x):
				if #available(macOS 10.11, *) {
					let s = #selector(NSTableViewDelegate.tableView(_:rowActionsForRow:edge:))
					delegate().addSelector(s).rowActionsForRow = x
				}
			case .shouldReorderColumn(let x):
				let s = #selector(NSTableViewDelegate.tableView(_:shouldReorderColumn:toColumn:))
				delegate().addSelector(s).shouldReorderColumn = { (instance, sourceIndex, targetIndex) -> Bool in
					if let column = instance.tableColumns.at(sourceIndex) {
						return x(instance, column, targetIndex)
					}
					return false
				}
			case .sizeToFitWidthOfColumn(let x):
				let s = #selector(NSTableViewDelegate.tableView(_:sizeToFitWidthOfColumn:))
				delegate().addSelector(s).sizeToFitWidthOfColumn = { (instance, index) -> CGFloat in
					if let column = instance.tableColumns.at(index) {
						return x(instance, column)
					}
					return 0
				}
			case .shouldTypeSelectForEvent(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:shouldTypeSelectFor:withCurrentSearch:)))
			case .typeSelectString(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:typeSelectStringFor:row:)))
			case .nextTypeSelectMatch(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:nextTypeSelectMatchFromRow:toRow:for:)))
			case .heightOfRow(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:heightOfRow:)))
			case .shouldSelectTableColumn(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:shouldSelect:)))
			case .selectionIndexesForProposedSelection(let x):
				let s = #selector(NSTableViewDelegate.tableView(_:selectionIndexesForProposedSelection:))
				delegate().addSelector(s).selectionIndexesForProposedSelection = { instance, indexes in
					return x(instance, IndexSet(indexes.map { $0 }))
				}
			case .shouldSelectRow(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:shouldSelectRow:)))
			case .selectionShouldChange(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.selectionShouldChange(in:)))
			case .isGroupRow(let x): delegate().addHandler(x, #selector(NSTableViewDelegate.tableView(_:isGroupRow:)))
			case .sortDescriptorsDidChange(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:sortDescriptorsDidChange:)))
			case .pasteboardWriter(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:pasteboardWriterForRow:)))
			case .acceptDrop(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:acceptDrop:row:dropOperation:)))
			case .validateDrop(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:validateDrop:proposedRow:proposedDropOperation:)))
			case .draggingSessionWillBegin(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:draggingSession:willBeginAt:forRowIndexes:)))
			case .updateDraggingItems(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:updateDraggingItemsForDrag:)))
			case .draggingSessionEnded(let x): delegate().addHandler(x, #selector(NSTableViewDataSource.tableView(_:draggingSession:endedAt:operation:)))
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}

		public func prepareInstance(_ instance: Instance, storage: Storage) {
			// TableView delegate is mandatory
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			instance.delegate = storage
			instance.dataSource = storage

			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .allowsColumnReordering(let x): return x.apply(instance) { i, v in i.allowsColumnReordering = v }
			case .allowsColumnResizing(let x): return x.apply(instance) { i, v in i.allowsColumnResizing = v }
			case .allowsMultipleSelection(let x): return x.apply(instance) { i, v in i.allowsMultipleSelection = v }
			case .allowsEmptySelection(let x): return x.apply(instance) { i, v in i.allowsEmptySelection = v }
			case .allowsColumnSelection(let x): return x.apply(instance) { i, v in i.allowsColumnSelection = v }
			case .intercellSpacing(let x): return x.apply(instance) { i, v in i.intercellSpacing = v }
			case .rowHeight(let x): return x.apply(instance) { i, v in i.rowHeight = v }
			case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
			case .usesAlternatingRowBackgroundColors(let x): return x.apply(instance) { i, v in i.usesAlternatingRowBackgroundColors = v }
			case .selectionHighlightStyle(let x): return x.apply(instance) { i, v in i.selectionHighlightStyle = v }
			case .gridColor(let x): return x.apply(instance) { i, v in i.gridColor = v }
			case .gridStyleMask(let x): return x.apply(instance) { i, v in i.gridStyleMask = v }
			case .rowSizeStyle(let x): return x.apply(instance) { i, v in i.rowSizeStyle = v }
			case .allowsTypeSelect(let x): return x.apply(instance) { i, v in i.allowsTypeSelect = v }
			case .floatsGroupRows(let x): return x.apply(instance) { i, v in i.floatsGroupRows = v }
			case .columnAutoresizingStyle(let x): return x.apply(instance) { i, v in i.columnAutoresizingStyle = v }
			case .autosaveName(let x): return x.apply(instance) { i, v in i.autosaveName = v }
			case .autosaveTableColumns(let x): return x.apply(instance) { i, v in i.autosaveTableColumns = v }
			case .verticalMotionCanBeginDrag(let x): return x.apply(instance) { i, v in i.verticalMotionCanBeginDrag = v }
			case .draggingDestinationFeedbackStyle(let x): return x.apply(instance) { i, v in i.draggingDestinationFeedbackStyle = v }
			case .userInterfaceLayoutDirection(let x): return x.apply(instance) { i, v in i.userInterfaceLayoutDirection = v }
				
			// Action behavior implementions:
			case .highlightColumn(let x): return x.apply(instance) { i, v in
				i.highlightedTableColumn = v.flatMap { (identifier: NSUserInterfaceItemIdentifier) -> NSTableColumn? in
					return i.tableColumns.first(where: { $0.identifier == identifier })
				}
				}
			case .selectColumns(let x):
				return x.apply(instance) { i, v in
					let indexes = v.identifiers.compactMap { identifier in i.tableColumns.enumerated().first(where: { $0.element.identifier == identifier })?.offset }
					let indexSet = IndexSet(indexes)
					i.selectColumnIndexes(indexSet, byExtendingSelection: v.byExtendingSelection)
				}
			case .selectRows(let x): return x.apply(instance) { i, v in i.selectRowIndexes(v.indexes, byExtendingSelection: v.byExtendingSelection) }
			case .deselectColumn(let x):
				return x.apply(instance) { i, v in
					if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
						i.deselectColumn(index)
					}
				}
			case .deselectRow(let x): return x.apply(instance) { i, v in i.deselectRow(v) }
			case .selectAll(let x): return x.apply(instance) { i, v in i.selectAll(nil) }
			case .deselectAll(let x): return x.apply(instance) { i, v in i.deselectAll(nil) }
			case .sizeLastColumnToFit(let x): return x.apply(instance) { i, v in i.sizeLastColumnToFit() }
			case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }
			case .scrollRowToVisible(let x): return x.apply(instance) { i, v in i.scrollRowToVisible(v) }
			case .scrollColumnToVisible(let x):
				return x.apply(instance) { i, v in
					if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
						i.scrollColumnToVisible(index)
					}
				}
			case .moveColumn(let x):
				return x.apply(instance) { i, v in
					if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v.identifier })?.offset {
						i.moveColumn(index, toColumn: v.toIndex)
					}
				}
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
			case .action(let x):
				switch x {
				case .firstResponder(let s):
					instance.target = nil
					instance.action = s
					return nil
				case .singleTarget(let s):
					let target: SignalDoubleActionTarget
					if let t = storage.actionTarget {
						target = t
					} else {
						target = SignalDoubleActionTarget()
						storage.actionTarget = target
					}
					
					instance.target = target
					instance.action = SignalActionTarget.selector
					
					return target.signal.cancellableBind(to: s)
				}
			case .doubleAction(let x):
				switch x {
				case .firstResponder(let s):
					instance.target = nil
					instance.doubleAction = s
					return nil
				case .singleTarget(let s):
					let target: SignalDoubleActionTarget
					if let t = storage.actionTarget {
						target = t
					} else {
						target = SignalDoubleActionTarget()
						storage.actionTarget = target
					}
					
					instance.target = target
					instance.doubleAction = SignalDoubleActionTarget.secondSelector
					
					return target.secondSignal.cancellableBind(to: s)
				}
			case .selectionChanged(let x):
				return Signal.notifications(name: NSTableView.selectionDidChangeNotification, object: instance).compactMap { [weak instance] n -> (selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedRows: IndexSet)? in
					guard let i = instance else {
						return nil
					}
					let selectedColumns = Set<NSUserInterfaceItemIdentifier>(i.selectedColumnIndexes.compactMap { i.tableColumns.at($0)?.identifier })
					let selectedRowIndexes = IndexSet(i.selectedRowIndexes.map { $0 })
					return (selectedColumns: selectedColumns, selectedRows: selectedRowIndexes as IndexSet)
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
			case .visibleRowsChanged(let x):
				storage.visibleRowsSignalInput = x
				return nil
			case .groupRowCellConstructor(let x):
				storage.groupRowCellConstructor = x
				return nil
			case .didDragTableColumn: return nil
			case .didClickTableColumn: return nil
			case .mouseDownInHeaderOfTableColumn: return nil
			case .rowView: return nil
			case .rowActionsForRow: return nil
			case .shouldReorderColumn: return nil
			case .sizeToFitWidthOfColumn: return nil
			case .shouldTypeSelectForEvent: return nil
			case .typeSelectString: return nil
			case .nextTypeSelectMatch: return nil
			case .heightOfRow: return nil
			case .shouldSelectTableColumn: return nil
			case .selectionIndexesForProposedSelection: return nil
			case .shouldSelectRow: return nil
			case .selectionShouldChange: return nil
			case .isGroupRow: return nil
				
			case .sortDescriptorsDidChange: return nil
			case .pasteboardWriter: return nil
			case .acceptDrop: return nil
			case .validateDrop: return nil
			case .draggingSessionWillBegin: return nil
			case .updateDraggingItems: return nil
			case .draggingSessionEnded: return nil
				
			case .columns(let x): return x.apply(instance) { i, v in s.updateColumns(v.map { $0.construct() }, in: i) }
			case .headerView(let x): return x.apply(instance) { i, v in i.headerView = v?.nsTableHeaderView() }
			case .cornerView(let x): return x.apply(instance) { i, v in i.cornerView = v?.nsView() }
			case .rows(let x): return x.apply(instance) { i, v in s.applyTableRowMutation(v, in: i) }
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: View.Storage, NSTableViewDelegate, NSTableViewDataSource {
		open override var inUse: Bool { return true }

		open var actionTarget: SignalDoubleActionTarget? = nil
		open var rowState: TableRowState<RowData> = TableRowState<RowData>()
		open var visibleRows: IndexSet = []
		open var visibleRowsSignalInput: SignalInput<CountableRange<Int>>? = nil
		open var groupRowCellConstructor: ((Int) -> TableCellViewConvertible)?
		open var columns: [TableColumn<RowData>.Storage] = []
		
		fileprivate func rowData(at row: Int) -> RowData? {
			return rowState.rows.at(row)
		}
		
		open func columnForIdentifier(_ identifier: NSUserInterfaceItemIdentifier) -> (offset: Int, element: TableColumn<RowData>.Storage)? {
			return columns.enumerated().first { (tuple: (offset: Int, element: TableColumn<RowData>.Storage)) -> Bool in
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

		open func updateColumns(_ v: [TableColumn<RowData>.Storage], in tableView: NSTableView) {
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
		public required override init() {
			super.init()
		}
		
		private func storage(for tableView: NSTableView) -> Storage? {
			return tableView.delegate as? Storage
		}
		
		open func tableView(_ tableView: NSTableView, didDrag tableColumn: NSTableColumn) {
			handler(ofType: ((NSTableColumn) -> Void).self)(tableColumn)
		}

		open func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
			handler(ofType: ((NSTableColumn) -> Void).self)(tableColumn)
		}

		open func tableView(_ tableView: NSTableView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
			handler(ofType: ((NSTableColumn) -> Void).self)(tableColumn)
		}

		open func tableView(_ tableView: NSTableView, rowViewForRow rowIndex: Int) -> NSTableRowView? {
			return handler(ofType: ((Int, RowData?) -> TableRowViewConvertible?).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))?.nsTableRowView()
		}

		open func tableView(_ tableView: NSTableView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
			return handler(ofType: ((_ tableView: NSTableView, _ sourceIndex: Int, _ targetIndex: Int) -> Bool).self)(tableView, columnIndex, newColumnIndex)
		}

		open func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
			return handler(ofType: ((_ tableView: NSTableView, _ column: Int) -> CGFloat).self)(tableView, column)
		}

		open func tableView(_ tableView: NSTableView, shouldTypeSelectFor event: NSEvent, withCurrentSearch searchString: String?) -> Bool {
			return handler(ofType: ((_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool).self)(tableView, event, searchString)
		}

		open var typeSelectString: ((TableCell<RowData>) -> String?)?
		open func tableView(_ tableView: NSTableView, typeSelectStringFor tableColumn: NSTableColumn?, row: Int) -> String? {
			guard let tc = tableColumn, row >= 0 else { return nil }
			return typeSelectString!(TableCell(row: row, column: tc, tableView: tableView))
		}

		open func tableView(_ tableView: NSTableView, nextTypeSelectMatchFromRow startRow: Int, toRow endRow: Int, for searchString: String) -> Int {
			return handler(ofType: ((_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int).self)(tableView, startRow, endRow, searchString)
		}

		open func tableView(_ tableView: NSTableView, heightOfRow rowIndex: Int) -> CGFloat {
			return handler(ofType: ((_ row: Int, _ data: RowData?) -> CGFloat).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
			return handler(ofType: ((_ tableView: NSTableView, _ tableColumn: NSTableColumn?) -> Bool).self)(tableView, tableColumn)
		}

		open func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
			return handler(ofType: ((_ tableView: NSTableView, _ proposedSelectionIndexes: IndexSet) -> IndexSet).self)(tableView, proposedSelectionIndexes)
		}

		open func tableView(_ tableView: NSTableView, shouldSelectRow rowIndex: Int) -> Bool {
			return handler(ofType: ((_ row: Int, _ data: RowData?) -> Bool).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func selectionShouldChange(in tableView: NSTableView) -> Bool {
			return handler(ofType: ((_ tableView: NSTableView) -> Bool).self)(tableView)
		}

		open func tableView(_ tableView: NSTableView, isGroupRow rowIndex: Int) -> Bool {
			return handler(ofType: ((_ row: Int, _ data: RowData?) -> Bool).self)(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
			handler(ofType: SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>.self).send(value: (new: tableView.sortDescriptors, old: oldDescriptors))
		}

		open func tableView(_ tableView: NSTableView, pasteboardWriterForRow rowIndex: Int) -> NSPasteboardWriting? {
			return handler(ofType: ((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> NSPasteboardWriting?).self)(tableView, rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row rowIndex: Int, dropOperation: NSTableView.DropOperation) -> Bool {
			return handler(ofType: ((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> Bool).self)(tableView, rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
			return handler(ofType: ((_ tableView: NSTableView, _ info: NSDraggingInfo, _ row: Int, _ dropOperation: NSTableView.DropOperation) -> NSDragOperation).self)(tableView, info, row, dropOperation)
		}

		open func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
			return handler(ofType: ((_ tableView: NSTableView, _ session: NSDraggingSession, _ screenPoint: NSPoint, _ rowIndexes: IndexSet) -> Void).self)(tableView, session, screenPoint, rowIndexes)
		}

		open func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
			return handler(ofType: ((_ tableView: NSTableView, _ draggingInfo: NSDraggingInfo) -> Void).self)(tableView, draggingInfo)
		}

		open func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
			return handler(ofType: ((_ tableView: NSTableView, _ session: NSDraggingSession, _ screenPoint: NSPoint, _ operation: NSDragOperation) -> Void).self)(tableView, session, screenPoint, operation)
		}

		open var rowActionsForRow: Any?
		@available(macOS 10.11, *)
		open func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
			return (rowActionsForRow as! (_ tableView: NSTableView, _ row: Int, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction])(tableView, row, edge)
		}
	}
}

extension BindingName where Binding: TableViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsColumnReordering: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.allowsColumnReordering(v)) }) }
	public static var allowsColumnResizing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.allowsColumnResizing(v)) }) }
	public static var allowsMultipleSelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.allowsMultipleSelection(v)) }) }
	public static var allowsEmptySelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.allowsEmptySelection(v)) }) }
	public static var allowsColumnSelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.allowsColumnSelection(v)) }) }
	public static var intercellSpacing: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.intercellSpacing(v)) }) }
	public static var rowHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.rowHeight(v)) }) }
	public static var backgroundColor: BindingName<Dynamic<NSColor>, Binding> { return BindingName<Dynamic<NSColor>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.backgroundColor(v)) }) }
	public static var usesAlternatingRowBackgroundColors: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.usesAlternatingRowBackgroundColors(v)) }) }
	public static var selectionHighlightStyle: BindingName<Dynamic<NSTableView.SelectionHighlightStyle>, Binding> { return BindingName<Dynamic<NSTableView.SelectionHighlightStyle>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.selectionHighlightStyle(v)) }) }
	public static var gridColor: BindingName<Dynamic<NSColor>, Binding> { return BindingName<Dynamic<NSColor>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.gridColor(v)) }) }
	public static var gridStyleMask: BindingName<Dynamic<NSTableView.GridLineStyle>, Binding> { return BindingName<Dynamic<NSTableView.GridLineStyle>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.gridStyleMask(v)) }) }
	public static var rowSizeStyle: BindingName<Dynamic<NSTableView.RowSizeStyle>, Binding> { return BindingName<Dynamic<NSTableView.RowSizeStyle>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.rowSizeStyle(v)) }) }
	public static var allowsTypeSelect: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.allowsTypeSelect(v)) }) }
	public static var floatsGroupRows: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.floatsGroupRows(v)) }) }
	public static var columnAutoresizingStyle: BindingName<Dynamic<NSTableView.ColumnAutoresizingStyle>, Binding> { return BindingName<Dynamic<NSTableView.ColumnAutoresizingStyle>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.columnAutoresizingStyle(v)) }) }
	public static var autosaveName: BindingName<Dynamic<NSTableView.AutosaveName?>, Binding> { return BindingName<Dynamic<NSTableView.AutosaveName?>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.autosaveName(v)) }) }
	public static var autosaveTableColumns: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.autosaveTableColumns(v)) }) }
	public static var verticalMotionCanBeginDrag: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.verticalMotionCanBeginDrag(v)) }) }
	public static var draggingDestinationFeedbackStyle: BindingName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>, Binding> { return BindingName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.draggingDestinationFeedbackStyle(v)) }) }
	public static var headerView: BindingName<Dynamic<TableHeaderViewConvertible?>, Binding> { return BindingName<Dynamic<TableHeaderViewConvertible?>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.headerView(v)) }) }
	public static var cornerView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.cornerView(v)) }) }
	public static var userInterfaceLayoutDirection: BindingName<Dynamic<NSUserInterfaceLayoutDirection>, Binding> { return BindingName<Dynamic<NSUserInterfaceLayoutDirection>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.userInterfaceLayoutDirection(v)) }) }
	public static var columns: BindingName<Dynamic<[TableColumn<Binding.RowDataType>]>, Binding> { return BindingName<Dynamic<[TableColumn<Binding.RowDataType>]>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.columns(v)) }) }
	public static var rows: BindingName<Dynamic<TableRowMutation<Binding.RowDataType>>, Binding> { return BindingName<Dynamic<TableRowMutation<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.rows(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var highlightColumn: BindingName<Signal<NSUserInterfaceItemIdentifier?>, Binding> { return BindingName<Signal<NSUserInterfaceItemIdentifier?>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.highlightColumn(v)) }) }
	public static var selectColumns: BindingName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>, Binding> { return BindingName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.selectColumns(v)) }) }
	public static var selectRows: BindingName<Signal<(indexes: IndexSet, byExtendingSelection: Bool)>, Binding> { return BindingName<Signal<(indexes: IndexSet, byExtendingSelection: Bool)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.selectRows(v)) }) }
	public static var deselectColumn: BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.deselectColumn(v)) }) }
	public static var deselectRow: BindingName<Signal<Int>, Binding> { return BindingName<Signal<Int>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.deselectRow(v)) }) }
	public static var selectAll: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.selectAll(v)) }) }
	public static var deselectAll: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.deselectAll(v)) }) }
	public static var sizeLastColumnToFit: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.sizeLastColumnToFit(v)) }) }
	public static var sizeToFit: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.sizeToFit(v)) }) }
	public static var scrollRowToVisible: BindingName<Signal<Int>, Binding> { return BindingName<Signal<Int>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.scrollRowToVisible(v)) }) }
	public static var scrollColumnToVisible: BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.scrollColumnToVisible(v)) }) }
	public static var moveColumn: BindingName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>, Binding> { return BindingName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.moveColumn(v)) }) }
	@available(macOS 10.11, *) public static var hideRowActions: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.hideRowActions(v)) }) }
	@available(macOS 10.11, *) public static var hideRows: BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding> { return BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.hideRows(v)) }) }
	@available(macOS 10.11, *) public static var unhideRows: BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding> { return BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.unhideRows(v)) }) }

	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.action(v)) }) }
	public static var doubleAction: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.doubleAction(v)) }) }
	public static var selectionChanged: BindingName<SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedRows: IndexSet)>, Binding> { return BindingName<SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedRows: IndexSet)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.selectionChanged(v)) }) }
	public static var columnResized: BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>, Binding> { return BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.columnResized(v)) }) }
	public static var columnMoved: BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>, Binding> { return BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.columnMoved(v)) }) }
	public static var didDragTableColumn: BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.didDragTableColumn(v)) }) }
	public static var didClickTableColumn: BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.didClickTableColumn(v)) }) }
	public static var mouseDownInHeaderOfTableColumn: BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.mouseDownInHeaderOfTableColumn(v)) }) }
	public static var visibleRowsChanged: BindingName<SignalInput<CountableRange<Int>>, Binding> { return BindingName<SignalInput<CountableRange<Int>>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.visibleRowsChanged(v)) }) }
	public static var sortDescriptorsDidChange: BindingName<SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>, Binding> { return BindingName<SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.sortDescriptorsDidChange(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var groupRowCellConstructor: BindingName<(Int) -> TableCellViewConvertible, Binding> { return BindingName<(Int) -> TableCellViewConvertible, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.groupRowCellConstructor(v)) }) }
	public static var rowView: BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> TableRowViewConvertible?, Binding> { return BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> TableRowViewConvertible?, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.rowView(v)) }) }
	public static var isGroupRow: BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> Bool, Binding> { return BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> Bool, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.isGroupRow(v)) }) }
	public static var heightOfRow: BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> CGFloat, Binding> { return BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> CGFloat, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.heightOfRow(v)) }) }
	public static var shouldSelectRow: BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> Bool, Binding> { return BindingName<(_ row: Int, _ rows: Binding.RowDataType?) -> Bool, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.shouldSelectRow(v)) }) }
	@available(macOS 10.11, *) public static var rowActionsForRow: BindingName<(_ row: Int, _ data: Binding.RowDataType?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction], Binding> { return BindingName<(_ row: Int, _ data: Binding.RowDataType?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction], Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.rowActionsForRow(v)) }) }
	public static var typeSelectString: BindingName<(TableCell<Binding.RowDataType>) -> String?, Binding> { return BindingName<(TableCell<Binding.RowDataType>) -> String?, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.typeSelectString(v)) }) }

	public static var shouldReorderColumn: BindingName<(_ tableView: NSTableView, _ column: NSTableColumn, _ newIndex: Int) -> Bool, Binding> { return BindingName<(_ tableView: NSTableView, _ column: NSTableColumn, _ newIndex: Int) -> Bool, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.shouldReorderColumn(v)) }) }
	public static var sizeToFitWidthOfColumn: BindingName<(_ tableView: NSTableView, _ column: NSTableColumn) -> CGFloat, Binding> { return BindingName<(_ tableView: NSTableView, _ column: NSTableColumn) -> CGFloat, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.sizeToFitWidthOfColumn(v)) }) }
	public static var shouldTypeSelectForEvent: BindingName<(_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool, Binding> { return BindingName<(_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.shouldTypeSelectForEvent(v)) }) }
	public static var nextTypeSelectMatch: BindingName<(_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int, Binding> { return BindingName<(_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.nextTypeSelectMatch(v)) }) }
	public static var shouldSelectTableColumn: BindingName<(_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool, Binding> { return BindingName<(_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.shouldSelectTableColumn(v)) }) }
	public static var selectionIndexesForProposedSelection: BindingName<(_ tableView: NSTableView, IndexSet) -> IndexSet, Binding> { return BindingName<(_ tableView: NSTableView, IndexSet) -> IndexSet, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.selectionIndexesForProposedSelection(v)) }) }
	public static var selectionShouldChange: BindingName<(_ tableView: NSTableView) -> Bool, Binding> { return BindingName<(_ tableView: NSTableView) -> Bool, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.selectionShouldChange(v)) }) }
	
	public static var pasteboardWriter: BindingName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> NSPasteboardWriting, Binding> { return BindingName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> NSPasteboardWriting, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.pasteboardWriter(v)) }) }
	public static var acceptDrop: BindingName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> Bool, Binding> { return BindingName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> Bool, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.acceptDrop(v)) }) }
	public static var validateDrop: BindingName<(_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation, Binding> { return BindingName<(_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.validateDrop(v)) }) }
	public static var draggingSessionWillBegin: BindingName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void, Binding> { return BindingName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.draggingSessionWillBegin(v)) }) }
	public static var updateDraggingItems: BindingName<(_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void, Binding> { return BindingName<(_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.updateDraggingItems(v)) }) }
	public static var draggingSessionEnded: BindingName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void, Binding> { return BindingName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void, Binding>({ v in .tableViewBinding(TableView<Binding.RowDataType>.Binding.draggingSessionEnded(v)) }) }
}

extension BindingName where Binding: TableViewBinding {
	// Additional helper binding names
	public static var rowAction: BindingName<SignalInput<TableCell<Binding.RowDataType>?>, Binding> {
		return BindingName<SignalInput<TableCell<Binding.RowDataType>?>, Binding> { (v: SignalInput<TableCell<Binding.RowDataType>?>) in
			.tableViewBinding(TableView<Binding.RowDataType>.Binding.action(TargetAction.singleTarget(
				Input<Any?>().map { s in
					guard let tableView = s as? NSTableView, tableView.selectedRow >= 0, tableView.selectedColumn >= 0 else { return nil }
					return TableCell<Binding.RowDataType>(row: tableView.selectedRow, column: tableView.selectedColumn, tableView: tableView)
					}.bind(to: v)
			)))
		}
	}
	public static var rowDoubleAction: BindingName<SignalInput<TableCell<Binding.RowDataType>?>, Binding> {
		return BindingName<SignalInput<TableCell<Binding.RowDataType>?>, Binding> { (v: SignalInput<TableCell<Binding.RowDataType>?>) in
			.tableViewBinding(TableView<Binding.RowDataType>.Binding.doubleAction(TargetAction.singleTarget(
				Input<Any?>().map { s in
					guard let tableView = s as? NSTableView, tableView.selectedRow >= 0, tableView.selectedColumn >= 0 else { return nil }
					return TableCell<Binding.RowDataType>(row: tableView.selectedRow, column: tableView.selectedColumn, tableView: tableView)
					}.bind(to: v)
			)))
		}
	}
}

public protocol TableViewConvertible: ControlConvertible {
	func nsTableView() -> NSTableView
}
extension TableViewConvertible {
	public func nsControl() -> Control.Instance { return nsTableView() }
}
extension TableView.Instance: TableViewConvertible {
	public func nsTableView() -> NSTableView { return self }
}

public protocol TableViewBinding: ControlBinding {
	associatedtype RowDataType
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> Self
}
extension TableViewBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return tableViewBinding(.inheritedBinding(binding))
	}
}

public struct TableCell<RowData> {
	public let row: Int
	public let column: Int
	public let columnIdentifier: NSUserInterfaceItemIdentifier
	public let data: RowData?
	
	public init(row: Int, column: Int, tableView: NSTableView) {
		self.row = row
		self.column = column
		self.columnIdentifier = tableView.tableColumns[column].identifier
		self.data = (tableView.delegate as? TableView<RowData>.Storage)?.rowData(at: row)
	}
	
	public init(row: Int, column: NSTableColumn, tableView: NSTableView) {
		self.row = row
		self.column = tableView.column(withIdentifier: column.identifier)
		self.columnIdentifier = column.identifier
		self.data = (tableView.delegate as? TableView<RowData>.Storage)?.rowData(at: row)
	}
}

#endif
