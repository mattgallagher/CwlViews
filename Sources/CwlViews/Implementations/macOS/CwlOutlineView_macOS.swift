//
//  CwlOutlineView_macOS.swift
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
public class OutlineView<NodeData>: Binder, OutlineViewConvertible {
	public static func scrollEmbedded(type: NSOutlineView.Type = NSOutlineView.self, _ bindings: Binding...) -> ScrollView {
		return ScrollView(
			.borderType -- .bezelBorder,
			.hasVerticalScroller -- true,
			.hasHorizontalScroller -- true,
			.autohidesScrollers -- true,
			.contentView -- ClipView(
				.documentView -- OutlineView<NodeData>(type: type, bindings: bindings)
			)
		)
	}

	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension OutlineView {
	enum Binding: OutlineViewBinding {
		public typealias NodeDataType = NodeData
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsColumnReordering(Dynamic<Bool>)
		case allowsColumnResizing(Dynamic<Bool>)
		case allowsColumnSelection(Dynamic<Bool>)
		case allowsEmptySelection(Dynamic<Bool>)
		case allowsMultipleSelection(Dynamic<Bool>)
		case allowsTypeSelect(Dynamic<Bool>)
		case autoresizesOutlineColumn(Dynamic<Bool>)
		case autosaveExpandedItems(Dynamic<Bool>)
		case autosaveName(Dynamic<NSTableView.AutosaveName?>)
		case autosaveTableColumns(Dynamic<Bool>)
		case backgroundColor(Dynamic<NSColor>)
		case columnAutoresizingStyle(Dynamic<NSTableView.ColumnAutoresizingStyle>)
		case columns(Dynamic<[TableColumn<NodeData>]>)
		case cornerView(Dynamic<ViewConvertible?>)
		case draggingDestinationFeedbackStyle(Dynamic<NSTableView.DraggingDestinationFeedbackStyle>)
		case floatsGroupRows(Dynamic<Bool>)
		case gridColor(Dynamic<NSColor>)
		case gridStyleMask(Dynamic<NSTableView.GridLineStyle>)
		case headerView(Dynamic<TableHeaderViewConvertible?>)
		case indentationMarkerFollowsCell(Dynamic<Bool>)
		case indentationPerLevel(Dynamic<CGFloat>)
		case intercellSpacing(Dynamic<NSSize>)
		case outlineTableColumnIdentifier(Dynamic<NSUserInterfaceItemIdentifier>)
		case rowHeight(Dynamic<CGFloat>)
		case rowSizeStyle(Dynamic<NSTableView.RowSizeStyle>)
		case selectionHighlightStyle(Dynamic<NSTableView.SelectionHighlightStyle>)
		case stronglyReferencesItems(Dynamic<Bool>)
		case treeData(Dynamic<TreeAnimation<NodeData>>)
		case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)
		case usesAlternatingRowBackgroundColors(Dynamic<Bool>)
		case verticalMotionCanBeginDrag(Dynamic<Bool>)
		
		// 2. Signal bindings are performed on the object after construction.
		case collapseIndexPath(Signal<(indexPath: IndexPath?, collapseChildren: Bool)>)
		case deselectAll(Signal<Void>)
		case deselectColumn(Signal<NSUserInterfaceItemIdentifier>)
		case deselectIndexPath(Signal<IndexPath>)
		case expandIndexPath(Signal<(indexPath: IndexPath?, expandChildren: Bool)>)
		case hideRowActions(Signal<Void>)
		case hideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		case highlightColumn(Signal<NSUserInterfaceItemIdentifier?>)
		case moveColumn(Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>)
		case scrollColumnToVisible(Signal<NSUserInterfaceItemIdentifier>)
		case scrollIndexPathToVisible(Signal<IndexPath>)
		case selectAll(Signal<Void>)
		case selectColumns(Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>)
		case selectIndexPaths(Signal<(indexPaths: Set<IndexPath>, byExtendingSelection: Bool)>)
		case setDropIndexPath(Signal<(indexPath: IndexPath?, dropChildIndex: Int)>)
		case sizeLastColumnToFit(Signal<Void>)
		case sizeToFit(Signal<Void>)
		case unhideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		
		// 3. Action bindings are triggered by the object after construction.
		case columnMoved(SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>)
		case columnResized(SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>)
		case didClickTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case didDragTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case doubleAction(TargetAction)
		case mouseDownInHeaderOfTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case selectionChanged(SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedIndexPaths: Set<IndexPath>)>)
		case selectionIsChanging(SignalInput<Void>)
		case sortDescriptorsDidChange(SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>)
		case indexPathDidCollapse(SignalInput<IndexPath>)
		case indexPathDidExpand(SignalInput<IndexPath>)
		case indexPathWillCollapse(SignalInput<IndexPath>)
		case indexPathWillExpand(SignalInput<IndexPath>)
		case visibleIndexPathsChanged(SignalInput<Set<IndexPath>>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case acceptDrop((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ indexPath: IndexPath?, _ childIndex: Int) -> Bool)
		case draggingSessionEnded((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void)
		case draggingSessionWillBegin((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [IndexPath]) -> Void)
		case groupRowCellConstructor((Int) -> TableCellViewConvertible)
		case heightOfRow((_ indexPath: IndexPath) -> CGFloat)
		case indexPathForPersistentObject((Any) -> IndexPath?)
		case isIndexPathExpandable((IndexPath) -> Bool)
		case nextTypeSelectMatch((_ outlineView: NSOutlineView, _ from: IndexPath, _ to: IndexPath, _ for: String) -> IndexPath?)
		case pasteboardWriter((_ outlineView: NSOutlineView, _ forIndexPath: IndexPath) -> NSPasteboardWriting?)
		case persistentObjectForIndexPath((IndexPath) -> Any?)
		case rowView((_ indexPath: IndexPath) -> TableRowViewConvertible?)
		case selectionIndexesForProposedSelection((_ proposedSelectionIndexes: Set<IndexPath>) -> Set<IndexPath>)
		case selectionShouldChange((_ outlineView: NSOutlineView) -> Bool)
		case shouldCollapse((_ indexPath: IndexPath) -> Bool)
		case shouldExpand((_ indexPath: IndexPath) -> Bool)
		case shouldReorderColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn, _ newIndex: Int) -> Bool)
		case shouldSelectTableColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn?) -> Bool)
		case shouldSelectIndexPath((_ outlineView: NSOutlineView, _ indexPath: IndexPath) -> Bool)
		case shouldTypeSelectForEvent((_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool)
		case sizeToFitWidthOfColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn) -> CGFloat)
		case typeSelectString((_ outlineView: NSOutlineView, _ column: NSTableColumn?, _ indexPath: IndexPath) -> String?)
		case updateDraggingItems((_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void)
		case validateDrop((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedIndexPath: IndexPath?, _ proposedChildIndex: Int) -> NSDragOperation)
	}
}

// MARK: - Binder Part 3: Preparer
public extension OutlineView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = OutlineView.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSOutlineView
		
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
		
		var singleAction: TargetAction?
		var doubleAction: TargetAction?
		var outlineColumn: NSUserInterfaceItemIdentifier? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension OutlineView.Preparer {
	var delegateIsRequired: Bool { return true }
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(.action(let x)): singleAction = x
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .acceptDrop(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:acceptDrop:item:childIndex:)))
		case .didClickTableColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:didClick:)))
		case .didDragTableColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:didDrag:)))
		case .doubleAction(let x): doubleAction = x
		case .draggingSessionEnded(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:draggingSession:endedAt:operation:)))
		case .heightOfRow(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:heightOfRowByItem:)))
		case .indexPathForPersistentObject(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:itemForPersistentObject:)))
		case .mouseDownInHeaderOfTableColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:mouseDownInHeaderOf:)))
		case .nextTypeSelectMatch(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:nextTypeSelectMatchFromItem:toItem:for:)))
		case .pasteboardWriter(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:pasteboardWriterForItem:)))
		case .persistentObjectForIndexPath(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:persistentObjectForItem:)))
		case .rowView(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:rowViewForItem:)))
		case .selectionIndexesForProposedSelection(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:selectionIndexesForProposedSelection:)))
		case .selectionShouldChange(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.selectionShouldChange(in:)))
		case .shouldCollapse(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldCollapseItem:)))
		case .shouldExpand(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldExpandItem:)))
		case .shouldReorderColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldReorderColumn:toColumn:)))
		case .shouldSelectTableColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldSelect:)))
		case .shouldSelectIndexPath(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldSelectItem:)))
		case .shouldTypeSelectForEvent(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldTypeSelectFor:withCurrentSearch:)))
		case .sizeToFitWidthOfColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:sizeToFitWidthOfColumn:)))
		case .sortDescriptorsDidChange(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:sortDescriptorsDidChange:)))
		case .typeSelectString(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:typeSelectStringFor:item:)))
		case .updateDraggingItems(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:updateDraggingItemsForDrag:)))
		case .validateDrop(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:validateDrop:proposedItem:proposedChildIndex:)))
		default: break
		}
	}
	
	// NOTE: due to the fact that `NSOutlineView` is a subclass of `NSTableView` but uses an *unrelated* delegate protocol type, we need to manually re-implement `prepareDelegate` here since the delegate does *not* conform to the `NSTableViewDelegate` protocol specified in the `HasDelegate` conformance.
	func prepareDelegate(instance: Instance, storage: Storage) {
		if delegateIsRequired {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			if dynamicDelegate != nil {
				storage.dynamicDelegate = dynamicDelegate
			}
			instance.delegate = storage
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)
		instance.dataSource = storage
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(.action): return nil
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowsColumnReordering(let x): return x.apply(instance) { i, v in i.allowsColumnReordering = v }
		case .allowsColumnResizing(let x): return x.apply(instance) { i, v in i.allowsColumnResizing = v }
		case .allowsColumnSelection(let x): return x.apply(instance) { i, v in i.allowsColumnSelection = v }
		case .allowsEmptySelection(let x): return x.apply(instance) { i, v in i.allowsEmptySelection = v }
		case .allowsMultipleSelection(let x): return x.apply(instance) { i, v in i.allowsMultipleSelection = v }
		case .allowsTypeSelect(let x): return x.apply(instance) { i, v in i.allowsTypeSelect = v }
		case .autoresizesOutlineColumn(let x): return x.apply(instance) { i, v in i.autoresizesOutlineColumn = v }
		case .autosaveExpandedItems(let x): return x.apply(instance) { i, v in i.autosaveExpandedItems = v }
		case .autosaveName(let x): return x.apply(instance) { i, v in i.autosaveName = v }
		case .autosaveTableColumns(let x): return x.apply(instance) { i, v in i.autosaveTableColumns = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .columnAutoresizingStyle(let x): return x.apply(instance) { i, v in i.columnAutoresizingStyle = v }
		case .columns(let x): return x.apply(instance, storage) { i, s, v in s.applyColumns(v.map { $0.construct() }, to: i) }
		case .cornerView(let x): return x.apply(instance) { i, v in i.cornerView = v?.nsView() }
		case .draggingDestinationFeedbackStyle(let x): return x.apply(instance) { i, v in i.draggingDestinationFeedbackStyle = v }
		case .floatsGroupRows(let x): return x.apply(instance) { i, v in i.floatsGroupRows = v }
		case .gridColor(let x): return x.apply(instance) { i, v in i.gridColor = v }
		case .gridStyleMask(let x): return x.apply(instance) { i, v in i.gridStyleMask = v }
		case .headerView(let x): return x.apply(instance) { i, v in i.headerView = v?.nsTableHeaderView() }
		case .indentationMarkerFollowsCell(let x): return x.apply(instance) { i, v in i.indentationMarkerFollowsCell = v }
		case .indentationPerLevel(let x): return x.apply(instance) { i, v in i.indentationPerLevel = v }
		case .intercellSpacing(let x): return x.apply(instance) { i, v in i.intercellSpacing = v }
		case .outlineTableColumnIdentifier(let x): return x.apply(instance, storage) { i, s, v in s.outlineColumnIdentifier = v }
		case .rowHeight(let x): return x.apply(instance) { i, v in i.rowHeight = v }
		case .rowSizeStyle(let x): return x.apply(instance) { i, v in i.rowSizeStyle = v }
		case .selectionHighlightStyle(let x): return x.apply(instance) { i, v in i.selectionHighlightStyle = v }
		case .treeData(let x): return x.apply(instance, storage) { i, s, v in s.applyTreeAnimation(v, to: i) }
		case .userInterfaceLayoutDirection(let x): return x.apply(instance) { i, v in i.userInterfaceLayoutDirection = v }
		case .usesAlternatingRowBackgroundColors(let x): return x.apply(instance) { i, v in i.usesAlternatingRowBackgroundColors = v }
		case .verticalMotionCanBeginDrag(let x): return x.apply(instance) { i, v in i.verticalMotionCanBeginDrag = v }

		case .stronglyReferencesItems(let x): return x.apply(instance) { i, v in i.stronglyReferencesItems = v }
		
		// 2. Signal bindings are performed on the object after construction.
		case .collapseIndexPath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let indexPath = v.indexPath, let item = s.item(forIndexPath: indexPath, in: i) {
					i.collapseItem(item, collapseChildren: v.collapseChildren)
				} else {
					i.collapseItem(nil, collapseChildren: v.collapseChildren)
				}
			}
		case .deselectAll(let x): return x.apply(instance) { i, v in i.deselectAll(nil) }
		case .deselectColumn(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
					i.deselectColumn(index)
				}
			}
		case .deselectIndexPath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let row: Int = s.row(forIndexPath: v, in: i) {
					i.deselectRow(row)
				}
			}
		case .expandIndexPath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let indexPath = v.indexPath, let item = s.item(forIndexPath: indexPath, in: i) {
					i.expandItem(item, expandChildren: v.expandChildren)
				} else {
					i.expandItem(nil, expandChildren: v.expandChildren)
				}
			}
		case .hideRowActions(let x): return x.apply(instance) { i, v in i.rowActionsVisible = false }
		case .hideRows(let x): return x.apply(instance) { i, v in i.hideRows(at: v.indexes, withAnimation: v.withAnimation) }
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
		case .scrollColumnToVisible(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
					i.scrollColumnToVisible(index)
				}
			}
		case .scrollIndexPathToVisible(let x):
			return x.apply(instance, storage) { i, s, v in
				if let row: Int = s.row(forIndexPath: v, in: i) {
					i.scrollRowToVisible(row)
				}
			}
		case .selectAll(let x): return x.apply(instance) { i, v in i.selectAll(nil) }
		case .selectColumns(let x):
			return x.apply(instance) { i, v in
				let indexes = v.identifiers.compactMap { identifier in i.tableColumns.enumerated().first(where: { $0.element.identifier == identifier })?.offset }
				let indexSet = IndexSet(indexes)
				i.selectColumnIndexes(indexSet, byExtendingSelection: v.byExtendingSelection)
			}
		case .selectIndexPaths(let x):
			return x.apply(instance, storage) { i, s, v in
				let indexes = v.indexPaths.compactMap { s.row(forIndexPath: $0, in: i) }
				i.selectRowIndexes(IndexSet(indexes), byExtendingSelection: v.byExtendingSelection)
			}
		case .setDropIndexPath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let indexPath = v.indexPath, let item = s.item(forIndexPath: indexPath, in: i) {
					i.setDropItem(item, dropChildIndex: v.dropChildIndex)
				} else {
					i.setDropItem(nil, dropChildIndex: v.dropChildIndex)
				}
			}
		case .sizeLastColumnToFit(let x): return x.apply(instance) { i, v in i.sizeLastColumnToFit() }
		case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }
		case .unhideRows(let x): return x.apply(instance) { i, v in i.unhideRows(at: v.indexes, withAnimation: v.withAnimation) }

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
			return Signal.notifications(name: NSTableView.selectionDidChangeNotification, object: instance).compactMap { [weak instance, weak storage] n -> (selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedIndexPaths: Set<IndexPath>)? in
				guard let i = instance else {
					return nil
				}
				let selectedColumns = Set<NSUserInterfaceItemIdentifier>(i.selectedColumnIndexes.compactMap { i.tableColumns.at($0)?.identifier })
				let selectedIndexPaths = Set(i.selectedRowIndexes.compactMap { storage?.indexPath(forRow: $0, in: i) })
				return (selectedColumns: selectedColumns, selectedIndexPaths: selectedIndexPaths)
				}.cancellableBind(to: x)
		case .selectionIsChanging(let x):
			return Signal.notifications(name: NSTableView.selectionIsChangingNotification, object: instance).map { notification -> Void in () }.cancellableBind(to: x)
		case .sortDescriptorsDidChange: return nil
		case .indexPathDidCollapse(let x):
			return Signal.notifications(name: NSOutlineView.itemDidCollapseNotification, object: instance).compactMap { [weak instance, weak storage] notification -> IndexPath? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.indexPath(forItem: $0, in: i) }
				}.cancellableBind(to: x)
		case .indexPathDidExpand(let x):
			return Signal.notifications(name: NSOutlineView.itemDidExpandNotification, object: instance).compactMap { [weak instance, weak storage] notification -> IndexPath? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.indexPath(forItem: $0, in: i) }
			}.cancellableBind(to: x)
		case .indexPathWillCollapse(let x):
			return Signal.notifications(name: NSOutlineView.itemWillCollapseNotification, object: instance).compactMap { [weak instance, weak storage] notification -> IndexPath? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.indexPath(forItem: $0, in: i) }
			}.cancellableBind(to: x)
		case .indexPathWillExpand(let x):
			return Signal.notifications(name: NSOutlineView.itemWillExpandNotification, object: instance).compactMap { [weak instance, weak storage] notification -> IndexPath? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.indexPath(forItem: $0, in: i) }
				}.cancellableBind(to: x)
		case .visibleIndexPathsChanged(let x):
			storage.visibleIndexPathsSignalInput = x
			return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .acceptDrop: return nil
		case .draggingSessionEnded: return nil
		case .draggingSessionWillBegin: return nil
		case .groupRowCellConstructor(let x):
			storage.groupRowCellConstructor = x
			return nil
		case .heightOfRow: return nil
		case .indexPathForPersistentObject: return nil
		case .isIndexPathExpandable: return nil
		case .nextTypeSelectMatch: return nil
		case .pasteboardWriter: return nil
		case .persistentObjectForIndexPath: return nil
		case .rowView: return nil
		case .selectionIndexesForProposedSelection: return nil
		case .selectionShouldChange: return nil
		case .shouldCollapse: return nil
		case .shouldExpand: return nil
		case .shouldReorderColumn: return nil
		case .shouldSelectTableColumn: return nil
		case .shouldSelectIndexPath: return nil
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
extension OutlineView.Preparer {
	open class Storage: View.Preparer.Storage, NSOutlineViewDelegate, NSOutlineViewDataSource {
		open override var isInUse: Bool { return true }
		
		open var actionTarget: SignalDoubleActionTarget? = nil
		open var treeState = TreeSubrangeState<NodeData>(parent: nil)
		open var visibleIndexPaths: Set<IndexPath> = []
		open var visibleIndexPathsSignalInput: SignalInput<Set<IndexPath>>? = nil
		open var groupRowCellConstructor: ((Int) -> TableCellViewConvertible)?
		open var columns: [TableColumn<NodeData>.Preparer.Storage] = []
		open var outlineColumnIdentifier: NSUserInterfaceItemIdentifier? = nil
		
		open func columnForIdentifier(_ identifier: NSUserInterfaceItemIdentifier) -> (offset: Int, element: TableColumn<NodeData>.Preparer.Storage)? {
			return columns.enumerated().first { (tuple: (offset: Int, element: TableColumn<NodeData>.Preparer.Storage)) -> Bool in
				tuple.element.tableColumn.identifier == identifier
			}
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didAdd: NSTableRowView, forRow: Int) {
			if let vrsi = visibleIndexPathsSignalInput, let path = indexPath(forRow: forRow, in: outlineView) {
				if visibleIndexPaths.insert(path).inserted {
					vrsi.send(value: visibleIndexPaths)
				}
			}
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didRemove: NSTableRowView, forRow: Int) {
			if let vrsi = visibleIndexPathsSignalInput, let path = indexPath(forRow: forRow, in: outlineView) {
				if visibleIndexPaths.insert(path).inserted {
					vrsi.send(value: visibleIndexPaths)
				}
			}
		}
		
		open func outlineView(_ outlineView: NSOutlineView, child: Int, ofItem: Any?) -> Any {
			if ofItem == nil {
				return treeState.state.values?.at(child) ?? TreeSubrangeState<NodeData>(parent: nil)
			}
			return (ofItem as? TreeSubrangeState<NodeData>)?.state.values?.at(child) ?? TreeSubrangeState<NodeData>(parent: nil)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
			return ((item as? TreeSubrangeState<NodeData>)?.state.values ?? nil) != nil
		}
		
		open func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
			if item == nil {
				return treeState.state.globalCount
			}
			return (item as? TreeSubrangeState<NodeData>)?.state.globalCount ?? 0
		}
		
		open func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
			return item
		}
		
		open func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
			if let tc = tableColumn {
				if let col = columnForIdentifier(tc.identifier) {
					let leaf = (item as? TreeSubrangeState<NodeData>)?.state.leaf
					let identifier = col.element.cellIdentifier?(leaf) ?? tc.identifier
					
					let cellView: NSTableCellView
					let cellInput: SignalInput<NodeData>?
					if let reusedView = outlineView.makeView(withIdentifier: identifier, owner: outlineView), let downcast = reusedView as? NSTableCellView {
						cellView = downcast
						cellInput = cellView.associatedRowInput(valueType: NodeData.self)
					} else if let cc = col.element.cellConstructor {
						let dataTuple = Signal<NodeData>.create()
						let constructed = cc(identifier, dataTuple.signal.multicast()).nsTableCellView()
						if constructed.identifier == nil {
							constructed.identifier = identifier
						}
						cellView = constructed
						cellInput = dataTuple.input
						cellView.setAssociatedRowInput(to: dataTuple.input)
					} else {
						return col.element.dataMissingCell?()?.nsTableCellView()
					}
					
					if let l = leaf {
						_ = cellInput?.send(value: l)
					}
					return cellView
				}
			} else {
				return groupRowCellConstructor?(outlineView.row(forItem: item)).nsTableCellView()
			}
			return nil
		}
		
		open var outlineTableColumn: TableColumn<NodeData>.Preparer.Storage?
		open func applyOutlineTableColumn(_ outlineTableColumn: TableColumn<NodeData>.Preparer.Storage, to outlineView: NSOutlineView) {
			self.outlineTableColumn = outlineTableColumn
			applyColumns(columns, to: outlineView)
		}
		
		open func applyColumns(_ v: [TableColumn<NodeData>.Preparer.Storage], to outlineView: NSOutlineView) {
			columns = v
			let columnsArray = v.map { $0.tableColumn }
			var newColumnSet = Set(columnsArray)
			if let otc = outlineTableColumn?.tableColumn ?? outlineView.outlineTableColumn {
				newColumnSet.insert(otc)
			}
			let oldColumnSet = Set(outlineView.tableColumns)
			
			for c in columnsArray {
				if !oldColumnSet.contains(c) {
					outlineView.addTableColumn(c)
				}
				if !newColumnSet.contains(c) {
					outlineView.removeTableColumn(c)
				}
			}
			if let oci = outlineColumnIdentifier, let tc = columnForIdentifier(oci)?.element.tableColumn {
				outlineView.outlineTableColumn = tc
			} else {
				outlineView.outlineTableColumn = outlineView.tableColumns.first
			}
		}
		
		open func applyTreeAnimation(_ treeAnimation: TreeAnimation<NodeData>, to outlineView: NSOutlineView) {
			treeAnimation.value.mutations.apply(toTreeSubrange: treeState)
			outlineView.animate(treeAnimation.value, in: treeState, animation: treeAnimation.animation ?? [])
		}
		
		open func indexPath(forItem: Any, in outlineView: NSOutlineView) -> IndexPath? {
			var indexes = IndexPath()
			let next = { (item: inout TreeSubrangeState<NodeData>?) -> (parent: TreeSubrangeState<NodeData>, item: TreeSubrangeState<NodeData>)? in
				if let parent = item?.parent, let next = item {
					item = parent
					return (parent, next)
				}
				return nil
			}
			for (parent, item) in sequence(state: forItem as? TreeSubrangeState<NodeData>, next: next) {
				if let i = parent.state.values?.firstIndex(where: { $0 === item }) {
					indexes.append(i)
				} else {
					return nil
				}
			}
			return indexes
		}
		
		open func indexPath(forRow row: Int, in outlineView: NSOutlineView) -> IndexPath? {
			if let item = outlineView.item(atRow: row) {
				return indexPath(forItem: item, in: outlineView)
			}
			return nil
		}
		
		open func row(forIndexPath indexPath: IndexPath, in outlineView: NSOutlineView) -> Int? {
			if let i = item(forIndexPath: indexPath, in: outlineView) {
				return outlineView.row(forItem: i)
			}
			return nil
		}
		
		open func item(forIndexPath indexPath: IndexPath, in: NSOutlineView) -> Any? {
			var node = treeState
			for index in sequence(state: indexPath, next: { $0.popFirst() }) {
				guard let next = node.state.values?.at(index) else { return nil }
				node = next
			}
			return node
		}
	}
	
	open class Delegate: DynamicDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource {
		private func storage(for outlineView: NSOutlineView) -> Storage? {
			return outlineView.delegate as? Storage
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didDrag tableColumn: NSTableColumn) {
			handler(ofType: SignalInput<NSUserInterfaceItemIdentifier>.self)!.send(value: tableColumn.identifier)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didClick tableColumn: NSTableColumn) {
			handler(ofType: SignalInput<NSUserInterfaceItemIdentifier>.self)!.send(value: tableColumn.identifier)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
			handler(ofType: SignalInput<NSUserInterfaceItemIdentifier>.self)!.send(value: tableColumn.identifier)
		}
		
		open var rowView: ((_ indexPath: IndexPath) -> TableRowViewConvertible?)?
		open func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: item, in: outlineView) {
				return rowView!(indexPath)?.nsTableRowView()
			}
			return nil
		}
		
		open var heightOfRow: ((_ indexPath: IndexPath) -> CGFloat)?
		open func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: item, in: outlineView) {
				return heightOfRow!(indexPath)
			}
			return outlineView.rowHeight
		}
		
		open func outlineView(_ outlineView: NSOutlineView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
			if let column = outlineView.tableColumns.at(columnIndex) {
				return handler(ofType: ((NSTableView, NSUserInterfaceItemIdentifier, Int) -> Bool).self)!(outlineView, column.identifier, newColumnIndex)
			}
			return false
		}
		
		open func outlineView(_ outlineView: NSOutlineView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
			if let column = outlineView.tableColumns.at(column) {
				return handler(ofType: ((NSTableView, NSUserInterfaceItemIdentifier) -> CGFloat).self)!(outlineView, column.identifier)
			}
			return 0
		}
		
		open func outlineView(_ outlineView: NSOutlineView, shouldTypeSelectFor event: NSEvent, withCurrentSearch searchString: String?) -> Bool {
			return handler(ofType: ((NSOutlineView, NSEvent, String?) -> Bool).self)!(outlineView, event, searchString)
		}
		
		open var typeSelectString: ((_ outlineView: NSOutlineView, _ tableColumn: NSTableColumn?, _ indexPath: IndexPath) -> String?)?
		open func outlineView(_ outlineView: NSOutlineView, typeSelectStringFor tableColumn: NSTableColumn?, item: Any) -> String? {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: item, in: outlineView) {
				return typeSelectString!(outlineView, tableColumn, indexPath)
			}
			return nil
		}
		
		open var nextTypeSelectMatch: ((_ outlineView: NSOutlineView, _ startIndexPath: IndexPath, _ endIndexPath: IndexPath, _ searchString: String) -> IndexPath?)?
		open func outlineView(_ outlineView: NSOutlineView, nextTypeSelectMatchFromItem startItem: Any, toItem endItem: Any, for searchString: String) -> Any? {
			if let startIndexPath = storage(for: outlineView)?.indexPath(forItem: startItem, in: outlineView), let endIndexPath = storage(for: outlineView)?.indexPath(forItem: endItem, in: outlineView) {
				if let indexPath = nextTypeSelectMatch!(outlineView, startIndexPath, endIndexPath, searchString) {
					return storage(for: outlineView)?.item(forIndexPath: indexPath, in: outlineView)
				}
			}
			return nil
		}
		
		open func outlineView(_ outlineView: NSOutlineView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
			return handler(ofType: ((NSOutlineView, NSTableColumn?) -> Bool).self)!(outlineView, tableColumn)
		}
		
		open var selectionIndexesForProposedSelection: ((_ proposedSelectionIndexes: Set<IndexPath>) -> Set<IndexPath>)?
		open func outlineView(_ outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
			var indexPaths = Set<IndexPath>()
			for index in proposedSelectionIndexes {
				if let path = storage(for: outlineView)?.indexPath(forRow: index, in: outlineView) {
					indexPaths.insert(path)
				}
			}
			let indexPathResult = selectionIndexesForProposedSelection!(indexPaths)
			var result = IndexSet()
			for indexPath in indexPathResult {
				if let index = storage(for: outlineView)?.row(forIndexPath: indexPath, in: outlineView) {
					result.insert(index)
				}
			}
			return result
		}
		
		open var shouldSelectIndexPath: ((_ outlineView: NSOutlineView, _ indexPath: IndexPath) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: item, in: outlineView) {
				return shouldSelectIndexPath!(outlineView, indexPath)
			}
			return false
		}
		
		open func selectionShouldChange(in outlineView: NSOutlineView) -> Bool {
			return handler(ofType: ((NSOutlineView) -> Bool).self)!(outlineView)
		}
		
		open var shouldExpand: ((_ indexPath: IndexPath) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: item, in: outlineView) {
				return shouldExpand!(indexPath)
			}
			return false
		}
		
		open var shouldCollapse: ((_ indexPath: IndexPath) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: item, in: outlineView) {
				return shouldCollapse!(indexPath)
			}
			return false
		}
		
		open var acceptDrop: ((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ indexPath: IndexPath?, _ childIndex: Int) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
			if let i = item {
				if let indexPath = storage(for: outlineView)?.indexPath(forItem: i, in: outlineView) {
					return acceptDrop!(outlineView, info, indexPath, index)
				} else {
					return false
				}
			}
			return acceptDrop!(outlineView, info, nil, index)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
			handler(ofType: SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>.self)!.send(value: (new: outlineView.sortDescriptors, old: oldDescriptors))
		}
		
		open func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
			return handler(ofType: ((NSOutlineView, NSDraggingSession, NSPoint, NSDragOperation) -> Void).self)!(outlineView, session, screenPoint, operation)
		}
		
		open var draggingSessionWillBegin: ((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [IndexPath]) -> Void)?
		open func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
			let indexPaths = draggedItems.compactMap { storage(for: outlineView)?.indexPath(forItem: $0, in: outlineView) }
			return draggingSessionWillBegin!(outlineView, session, screenPoint, indexPaths)
		}
		
		open var isIndexPathExpandable: ((_ indexPath: IndexPath) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, isItemExpandable: Any) -> Bool {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: isItemExpandable, in: outlineView) {
				return isIndexPathExpandable!(indexPath)
			}
			return false
		}
		
		open func outlineView(_ outlineView: NSOutlineView, itemForPersistentObject object: Any) -> Any? {
			return handler(ofType: ((Any) -> IndexPath?).self)!(object).flatMap { storage(for: outlineView)?.item(forIndexPath: $0, in: outlineView) }
		}
		
		open var persistentObjectForIndexPath: ((_ indexPath: IndexPath) -> Any?)?
		open func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
			if let i = item, let indexPath = storage(for: outlineView)?.indexPath(forItem: i, in: outlineView) {
				return persistentObjectForIndexPath!(indexPath)
			}
			return nil
		}
		
		open var pasteboardWriter: ((_ outlineView: NSOutlineView, _ forIndexPath: IndexPath) -> NSPasteboardWriting?)?
		open func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
			if let indexPath = storage(for: outlineView)?.indexPath(forItem: item, in: outlineView) {
				return pasteboardWriter!(outlineView, indexPath)
			}
			return nil
		}
		
		open func outlineView(_ outlineView: NSOutlineView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
			handler(ofType: ((NSOutlineView, NSDraggingInfo) -> Void).self)!(outlineView, draggingInfo)
		}
		
		open var validateDrop: ((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedIndexPath: IndexPath?, _ proposedChildIndex: Int) -> NSDragOperation)?
		open func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
			if let i = item {
				if let indexPath = storage(for: outlineView)?.indexPath(forItem: i, in: outlineView) {
					return validateDrop!(outlineView, info, indexPath, index)
				} else {
					return []
				}
			}
			return validateDrop!(outlineView, info, nil, index)
		}
	}
}

private extension NSOutlineView {
	func animate<NodeData>(_ treeMutation: TreeSubrangeMutation<NodeData>, in treeState: TreeSubrangeState<NodeData>, animation: NSTableView.AnimationOptions) {
		let indices = treeMutation.mutations.indexSet.offset(by: treeState.state.localOffset)
		
		switch treeMutation.mutations.kind {
		case .delete:
			removeItems(at: indices, inParent: treeState, withAnimation: animation)
		case .move(let destination):
			beginUpdates()
			for (count, index) in indices.enumerated() {
				moveItem(at: index, inParent: treeState, to: destination + count, inParent: treeState)
			}
			endUpdates()
		case .insert:
			insertItems(at: indices, inParent: treeState, withAnimation: animation)
		case .scroll:
			beginUpdates()
			for i in indices {
				guard let item = treeState.state.values?.at(i) else { continue }
				reloadItem(item, reloadChildren: true)
			}
			endUpdates()
		case .update:
			beginUpdates()
			for (mutationIndex, valueIndex) in indices.enumerated() {
				guard let childAnimation = treeMutation.mutations.values.at(mutationIndex), let childState = treeState.state.values?.at(valueIndex) else { continue }
				animate(childAnimation, in: childState, animation: animation)
			}
			endUpdates()
		case .reload:
			reloadData()
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: OutlineViewBinding {
	public typealias OutlineViewName<V> = BindingName<V, OutlineView<Binding.NodeDataType>.Binding, Binding>
	private typealias B = OutlineView<Binding.NodeDataType>.Binding
	private static func name<V>(_ source: @escaping (V) -> OutlineView<Binding.NodeDataType>.Binding) -> OutlineViewName<V> {
		return OutlineViewName<V>(source: source, downcast: Binding.outlineViewBinding)
	}
}
public extension BindingName where Binding: OutlineViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: OutlineViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsColumnReordering: OutlineViewName<Dynamic<Bool>> { return .name(B.allowsColumnReordering) }
	static var allowsColumnResizing: OutlineViewName<Dynamic<Bool>> { return .name(B.allowsColumnResizing) }
	static var allowsColumnSelection: OutlineViewName<Dynamic<Bool>> { return .name(B.allowsColumnSelection) }
	static var allowsEmptySelection: OutlineViewName<Dynamic<Bool>> { return .name(B.allowsEmptySelection) }
	static var allowsMultipleSelection: OutlineViewName<Dynamic<Bool>> { return .name(B.allowsMultipleSelection) }
	static var allowsTypeSelect: OutlineViewName<Dynamic<Bool>> { return .name(B.allowsTypeSelect) }
	static var autoresizesOutlineColumn: OutlineViewName<Dynamic<Bool>> { return .name(B.autoresizesOutlineColumn) }
	static var autosaveExpandedItems: OutlineViewName<Dynamic<Bool>> { return .name(B.autosaveExpandedItems) }
	static var autosaveName: OutlineViewName<Dynamic<NSTableView.AutosaveName?>> { return .name(B.autosaveName) }
	static var autosaveTableColumns: OutlineViewName<Dynamic<Bool>> { return .name(B.autosaveTableColumns) }
	static var backgroundColor: OutlineViewName<Dynamic<NSColor>> { return .name(B.backgroundColor) }
	static var columnAutoresizingStyle: OutlineViewName<Dynamic<NSTableView.ColumnAutoresizingStyle>> { return .name(B.columnAutoresizingStyle) }
	static var columns: OutlineViewName<Dynamic<[TableColumn<Binding.NodeDataType>]>> { return .name(B.columns) }
	static var cornerView: OutlineViewName<Dynamic<ViewConvertible?>> { return .name(B.cornerView) }
	static var draggingDestinationFeedbackStyle: OutlineViewName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>> { return .name(B.draggingDestinationFeedbackStyle) }
	static var floatsGroupRows: OutlineViewName<Dynamic<Bool>> { return .name(B.floatsGroupRows) }
	static var gridColor: OutlineViewName<Dynamic<NSColor>> { return .name(B.gridColor) }
	static var gridStyleMask: OutlineViewName<Dynamic<NSTableView.GridLineStyle>> { return .name(B.gridStyleMask) }
	static var headerView: OutlineViewName<Dynamic<TableHeaderViewConvertible?>> { return .name(B.headerView) }
	static var indentationMarkerFollowsCell: OutlineViewName<Dynamic<Bool>> { return .name(B.indentationMarkerFollowsCell) }
	static var indentationPerLevel: OutlineViewName<Dynamic<CGFloat>> { return .name(B.indentationPerLevel) }
	static var intercellSpacing: OutlineViewName<Dynamic<NSSize>> { return .name(B.intercellSpacing) }
	static var outlineTableColumnIdentifier: OutlineViewName<Dynamic<NSUserInterfaceItemIdentifier>> { return .name(B.outlineTableColumnIdentifier) }
	static var rowHeight: OutlineViewName<Dynamic<CGFloat>> { return .name(B.rowHeight) }
	static var rowSizeStyle: OutlineViewName<Dynamic<NSTableView.RowSizeStyle>> { return .name(B.rowSizeStyle) }
	static var selectionHighlightStyle: OutlineViewName<Dynamic<NSTableView.SelectionHighlightStyle>> { return .name(B.selectionHighlightStyle) }
	static var stronglyReferencesItems: OutlineViewName<Dynamic<Bool>> { return .name(B.stronglyReferencesItems) }
	static var treeData: OutlineViewName<Dynamic<TreeAnimation<Binding.NodeDataType>>> { return .name(B.treeData) }
	static var userInterfaceLayoutDirection: OutlineViewName<Dynamic<NSUserInterfaceLayoutDirection>> { return .name(B.userInterfaceLayoutDirection) }
	static var usesAlternatingRowBackgroundColors: OutlineViewName<Dynamic<Bool>> { return .name(B.usesAlternatingRowBackgroundColors) }
	static var verticalMotionCanBeginDrag: OutlineViewName<Dynamic<Bool>> { return .name(B.verticalMotionCanBeginDrag) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var collapseIndexPath: OutlineViewName<Signal<(indexPath: IndexPath?, collapseChildren: Bool)>> { return .name(B.collapseIndexPath) }
	static var deselectAll: OutlineViewName<Signal<Void>> { return .name(B.deselectAll) }
	static var deselectColumn: OutlineViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(B.deselectColumn) }
	static var deselectIndexPath: OutlineViewName<Signal<IndexPath>> { return .name(B.deselectIndexPath) }
	static var expandIndexPath: OutlineViewName<Signal<(indexPath: IndexPath?, expandChildren: Bool)>> { return .name(B.expandIndexPath) }
	static var hideRowActions: OutlineViewName<Signal<Void>> { return .name(B.hideRowActions) }
	static var hideRows: OutlineViewName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>> { return .name(B.hideRows) }
	static var highlightColumn: OutlineViewName<Signal<NSUserInterfaceItemIdentifier?>> { return .name(B.highlightColumn) }
	static var moveColumn: OutlineViewName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>> { return .name(B.moveColumn) }
	static var scrollColumnToVisible: OutlineViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(B.scrollColumnToVisible) }
	static var scrollIndexPathToVisible: OutlineViewName<Signal<IndexPath>> { return .name(B.scrollIndexPathToVisible) }
	static var selectAll: OutlineViewName<Signal<Void>> { return .name(B.selectAll) }
	static var selectColumns: OutlineViewName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>> { return .name(B.selectColumns) }
	static var selectIndexPaths: OutlineViewName<Signal<(indexPaths: Set<IndexPath>, byExtendingSelection: Bool)>> { return .name(B.selectIndexPaths) }
	static var setDropIndexPath: OutlineViewName<Signal<(indexPath: IndexPath?, dropChildIndex: Int)>> { return .name(B.setDropIndexPath) }
	static var sizeLastColumnToFit: OutlineViewName<Signal<Void>> { return .name(B.sizeLastColumnToFit) }
	static var sizeToFit: OutlineViewName<Signal<Void>> { return .name(B.sizeToFit) }
	static var unhideRows: OutlineViewName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>> { return .name(B.unhideRows) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var columnMoved: OutlineViewName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>> { return .name(B.columnMoved) }
	static var columnResized: OutlineViewName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>> { return .name(B.columnResized) }
	static var didClickTableColumn: OutlineViewName<SignalInput<NSUserInterfaceItemIdentifier>> { return .name(B.didClickTableColumn) }
	static var didDragTableColumn: OutlineViewName<SignalInput<NSUserInterfaceItemIdentifier>> { return .name(B.didDragTableColumn) }
	static var doubleAction: OutlineViewName<TargetAction> { return .name(B.doubleAction) }
	static var mouseDownInHeaderOfTableColumn: OutlineViewName<SignalInput<NSUserInterfaceItemIdentifier>> { return .name(B.mouseDownInHeaderOfTableColumn) }
	static var selectionChanged: OutlineViewName<SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedIndexPaths: Set<IndexPath>)>> { return .name(B.selectionChanged) }
	static var selectionIsChanging: OutlineViewName<SignalInput<Void>> { return .name(B.selectionIsChanging) }
	static var sortDescriptorsDidChange: OutlineViewName<SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>> { return .name(B.sortDescriptorsDidChange) }
	static var indexPathDidCollapse: OutlineViewName<SignalInput<IndexPath>> { return .name(B.indexPathDidCollapse) }
	static var indexPathDidExpand: OutlineViewName<SignalInput<IndexPath>> { return .name(B.indexPathDidExpand) }
	static var indexPathWillCollapse: OutlineViewName<SignalInput<IndexPath>> { return .name(B.indexPathWillCollapse) }
	static var indexPathWillExpand: OutlineViewName<SignalInput<IndexPath>> { return .name(B.indexPathWillExpand) }
	static var visibleIndexPathsChanged: OutlineViewName<SignalInput<Set<IndexPath>>> { return .name(B.visibleIndexPathsChanged) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var acceptDrop: OutlineViewName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ indexPath: IndexPath?, _ childIndex: Int) -> Bool> { return .name(B.acceptDrop) }
	static var draggingSessionEnded: OutlineViewName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void> { return .name(B.draggingSessionEnded) }
	static var draggingSessionWillBegin: OutlineViewName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [IndexPath]) -> Void> { return .name(B.draggingSessionWillBegin) }
	static var groupRowCellConstructor: OutlineViewName<(Int) -> TableCellViewConvertible> { return .name(B.groupRowCellConstructor) }
	static var heightOfRow: OutlineViewName<(_ indexPath: IndexPath) -> CGFloat> { return .name(B.heightOfRow) }
	static var indexPathForPersistentObject: OutlineViewName<(Any) -> IndexPath?> { return .name(B.indexPathForPersistentObject) }
	static var isIndexPathExpandable: OutlineViewName<(IndexPath) -> Bool> { return .name(B.isIndexPathExpandable) }
	static var nextTypeSelectMatch: OutlineViewName<(_ outlineView: NSOutlineView, _ from: IndexPath, _ to: IndexPath, _ for: String) -> IndexPath?> { return .name(B.nextTypeSelectMatch) }
	static var pasteboardWriter: OutlineViewName<(_ outlineView: NSOutlineView, _ forIndexPath: IndexPath) -> NSPasteboardWriting?> { return .name(B.pasteboardWriter) }
	static var persistentObjectForIndexPath: OutlineViewName<(IndexPath) -> Any?> { return .name(B.persistentObjectForIndexPath) }
	static var rowView: OutlineViewName<(_ indexPath: IndexPath) -> TableRowViewConvertible?> { return .name(B.rowView) }
	static var selectionIndexesForProposedSelection: OutlineViewName<(_ proposedSelectionIndexes: Set<IndexPath>) -> Set<IndexPath>> { return .name(B.selectionIndexesForProposedSelection) }
	static var selectionShouldChange: OutlineViewName<(_ outlineView: NSOutlineView) -> Bool> { return .name(B.selectionShouldChange) }
	static var shouldCollapse: OutlineViewName<(_ indexPath: IndexPath) -> Bool> { return .name(B.shouldCollapse) }
	static var shouldExpand: OutlineViewName<(_ indexPath: IndexPath) -> Bool> { return .name(B.shouldExpand) }
	static var shouldReorderColumn: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn, _ newIndex: Int) -> Bool> { return .name(B.shouldReorderColumn) }
	static var shouldSelectTableColumn: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?) -> Bool> { return .name(B.shouldSelectTableColumn) }
	static var shouldSelectIndexPath: OutlineViewName<(_ outlineView: NSOutlineView, _ indexPath: IndexPath) -> Bool> { return .name(B.shouldSelectIndexPath) }
	static var shouldTypeSelectForEvent: OutlineViewName<(_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool> { return .name(B.shouldTypeSelectForEvent) }
	static var sizeToFitWidthOfColumn: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn) -> CGFloat> { return .name(B.sizeToFitWidthOfColumn) }
	static var typeSelectString: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?, _ indexPath: IndexPath) -> String?> { return .name(B.typeSelectString) }
	static var updateDraggingItems: OutlineViewName<(_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void> { return .name(B.updateDraggingItems) }
	static var validateDrop: OutlineViewName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedIndexPath: IndexPath?, _ proposedChildIndex: Int) -> NSDragOperation> { return .name(B.validateDrop) }

	// Composite binding names
	static func doubleAction<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> OutlineViewName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, OutlineView.Binding.doubleAction, Binding.outlineViewBinding)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol OutlineViewConvertible: ControlConvertible {
	func nsOutlineView() -> NSOutlineView
}
extension NSOutlineView: OutlineViewConvertible {
	public func nsOutlineView() -> NSOutlineView { return self }
}
public extension OutlineViewConvertible {
	func nsControl() -> Control.Instance { return nsOutlineView() }
}
public extension OutlineView {
	func nsOutlineView() -> NSOutlineView { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol OutlineViewBinding: ControlBinding {
	associatedtype NodeDataType
	static func outlineViewBinding(_ binding: OutlineView<NodeDataType>.Binding) -> Self
}
public extension OutlineViewBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return outlineViewBinding(OutlineView<NodeDataType>.Binding.inheritedBinding(binding))
	}
}
public extension OutlineView.Binding {
	typealias Preparer = OutlineView.Preparer
	static func outlineViewBinding(_ binding: OutlineView<NodeDataType>.Binding) -> OutlineView<NodeDataType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public typealias TreeAnimation<NodeData> = Animatable<TreeSubrangeMutation<NodeData>, NSTableView.AnimationOptions>

public struct OutlineCell<NodeData> {
	public let row: Int
	public let column: Int
	public let columnIdentifier: NSUserInterfaceItemIdentifier
	public let data: IndexPath?
	
	public init(row: Int, column: Int, outlineView: NSOutlineView) {
		self.row = row
		self.data = (outlineView.delegate as? OutlineView<NodeData>.Preparer.Storage)?.indexPath(forRow: row, in: outlineView)
		self.column = column
		self.columnIdentifier = outlineView.tableColumns[column].identifier
	}
	
	public init(row: Int, column: NSTableColumn, outlineView: NSOutlineView) {
		self.row = row
		self.column = outlineView.column(withIdentifier: column.identifier)
		self.columnIdentifier = column.identifier
		self.data = (outlineView.delegate as? OutlineView<NodeData>.Preparer.Storage)?.indexPath(forRow: row, in: outlineView)
	}
}

#endif
