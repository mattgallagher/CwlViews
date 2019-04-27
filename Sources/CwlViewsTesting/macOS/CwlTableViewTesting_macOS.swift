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

extension TableViewBinding {
	public static func tableStructure<S: Sequence>(in bindings: S) throws -> TableRowState<RowDataType> where S.Element == TableView<RowDataType>.Binding {
		var found: TableRowState<RowDataType>? = nil
		for b in bindings {
			if case .rows(let x) = b {
				if found != nil {
					throw BindingParserErrors.multipleMatchesFound
				}
				let values = x.values
				var rowState = TableRowState<RowDataType>()
				for v in values {
					v.value.apply(toSubrange: &rowState)
				}
				found = rowState
			}
		}
		if let f = found {
			return f
		}
		throw BindingParserErrors.noMatchesFound
	}
}

extension BindingParser where Downcast: TableViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTableViewBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsColumnReordering: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsColumnReordering(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsColumnResizing: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsColumnResizing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsColumnSelection: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsColumnSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsEmptySelection: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsEmptySelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsMultipleSelection: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsMultipleSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsTypeSelect: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsTypeSelect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var autosaveName: BindingParser<Dynamic<NSTableView.AutosaveName?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .autosaveName(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var autosaveTableColumns: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .autosaveTableColumns(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var backgroundColor: BindingParser<Dynamic<NSColor>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .backgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var columnAutoresizingStyle: BindingParser<Dynamic<NSTableView.ColumnAutoresizingStyle>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .columnAutoresizingStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var columns: BindingParser<Dynamic<[TableColumn<Downcast.RowDataType>]>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .columns(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var cornerView: BindingParser<Dynamic<ViewConvertible?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .cornerView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var draggingDestinationFeedbackStyle: BindingParser<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .draggingDestinationFeedbackStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var floatsGroupRows: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .floatsGroupRows(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var gridColor: BindingParser<Dynamic<NSColor>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .gridColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var gridStyleMask: BindingParser<Dynamic<NSTableView.GridLineStyle>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .gridStyleMask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var headerView: BindingParser<Dynamic<TableHeaderViewConvertible?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .headerView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var intercellSpacing: BindingParser<Dynamic<NSSize>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .intercellSpacing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var rowHeight: BindingParser<Dynamic<CGFloat>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .rowHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var rows: BindingParser<Dynamic<TableRowAnimatable<Downcast.RowDataType>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .rows(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var rowSizeStyle: BindingParser<Dynamic<NSTableView.RowSizeStyle>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .rowSizeStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectionHighlightStyle: BindingParser<Dynamic<NSTableView.SelectionHighlightStyle>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectionHighlightStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var userInterfaceLayoutDirection: BindingParser<Dynamic<NSUserInterfaceLayoutDirection>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .userInterfaceLayoutDirection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var usesAlternatingRowBackgroundColors: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .usesAlternatingRowBackgroundColors(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var usesAutomaticRowHeights: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .usesAutomaticRowHeights(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var verticalMotionCanBeginDrag: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .verticalMotionCanBeginDrag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var deselectAll: BindingParser<Signal<Void>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .deselectAll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var deselectColumn: BindingParser<Signal<NSUserInterfaceItemIdentifier>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .deselectColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var deselectRow: BindingParser<Signal<Int>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .deselectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var hideRowActions: BindingParser<Signal<Void>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .hideRowActions(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var hideRows: BindingParser<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .hideRows(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var highlightColumn: BindingParser<Signal<NSUserInterfaceItemIdentifier?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .highlightColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var moveColumn: BindingParser<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .moveColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var scrollColumnToVisible: BindingParser<Signal<NSUserInterfaceItemIdentifier>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .scrollColumnToVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var scrollRowToVisible: BindingParser<Signal<Int>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .scrollRowToVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectAll: BindingParser<Signal<Void>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectAll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectColumns: BindingParser<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectColumns(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectRows: BindingParser<Signal<(indexes: IndexSet, byExtendingSelection: Bool)>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectRows(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sizeLastColumnToFit: BindingParser<Signal<Void>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sizeLastColumnToFit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sizeToFit: BindingParser<Signal<Void>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sizeToFit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var unhideRows: BindingParser<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .unhideRows(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var columnMoved: BindingParser<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .columnMoved(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var columnResized: BindingParser<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .columnResized(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var doubleAction: BindingParser<TargetAction, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .doubleAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var visibleRowsChanged: BindingParser<SignalInput<CountableRange<Int>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .visibleRowsChanged(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var acceptDrop: BindingParser<(_ tableView: NSTableView, _ row: Int, _ data: Downcast.RowDataType?) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .acceptDrop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didClickTableColumn: BindingParser<(NSTableView, NSTableColumn) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didClickTableColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didDragTableColumn: BindingParser<(NSTableView, NSTableColumn) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didDragTableColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var draggingSessionEnded: BindingParser<(_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .draggingSessionEnded(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var draggingSessionWillBegin: BindingParser<(_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .draggingSessionWillBegin(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var groupRowCellConstructor: BindingParser<(Int) -> TableCellViewConvertible, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .groupRowCellConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var heightOfRow: BindingParser<(_ tableView: NSTableView, _ row: Int, _ rowData: Downcast.RowDataType?) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .heightOfRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var isGroupRow: BindingParser<(_ tableView: NSTableView, _ row: Int, _ rowData: Downcast.RowDataType?) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .isGroupRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var mouseDownInHeaderOfTableColumn: BindingParser<(NSTableView, NSTableColumn) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .mouseDownInHeaderOfTableColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var nextTypeSelectMatch: BindingParser<(_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .nextTypeSelectMatch(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var pasteboardWriter: BindingParser<(_ tableView: NSTableView, _ row: Int, _ data: Downcast.RowDataType?) -> NSPasteboardWriting, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .pasteboardWriter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var rowActionsForRow: BindingParser<(_ tableView: NSTableView, _ row: Int, _ data: Downcast.RowDataType?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction], TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .rowActionsForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var rowView: BindingParser<(_ tableView: NSTableView, _ row: Int, _ rowData: Downcast.RowDataType?) -> TableRowViewConvertible?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .rowView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectionDidChange: BindingParser<(Notification) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectionDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectionIndexesForProposedSelection: BindingParser<(_ tableView: NSTableView, IndexSet) -> IndexSet, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectionIndexesForProposedSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectionShouldChange: BindingParser<(_ tableView: NSTableView) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectionShouldChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldReorderColumn: BindingParser<(_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier, _ newIndex: Int) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldReorderColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldSelectRow: BindingParser<(_ tableView: NSTableView, _ row: Int, _ rowData: Downcast.RowDataType?) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldSelectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldSelectTableColumn: BindingParser<(_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldSelectTableColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldTypeSelectForEvent: BindingParser<(_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldTypeSelectForEvent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sizeToFitWidthOfColumn: BindingParser<(_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sizeToFitWidthOfColumn(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sortDescriptorsDidChange: BindingParser<(NSTableView, [NSSortDescriptor]) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sortDescriptorsDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var typeSelectString: BindingParser<(_ tableView: NSTableView, _ cell: TableCell<Downcast.RowDataType>) -> String?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .typeSelectString(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var updateDraggingItems: BindingParser<(_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .updateDraggingItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var validateDrop: BindingParser<(_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .validateDrop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
}

#endif
