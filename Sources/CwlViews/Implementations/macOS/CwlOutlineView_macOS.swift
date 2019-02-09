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
		case treeData(Dynamic<TableRowMutation<TreeMutation<NodeData>>>)
		case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)
		case usesAlternatingRowBackgroundColors(Dynamic<Bool>)
		case verticalMotionCanBeginDrag(Dynamic<Bool>)
		
		// 2. Signal bindings are performed on the object after construction.
		case collapseTreePath(Signal<(treePath: TreePath<NodeData>?, collapseChildren: Bool)>)
		case deselectAll(Signal<Void>)
		case deselectColumn(Signal<NSUserInterfaceItemIdentifier>)
		case deselectTreePath(Signal<TreePath<NodeData>>)
		case expandTreePath(Signal<(treePath: TreePath<NodeData>?, expandChildren: Bool)>)
		case hideRowActions(Signal<Void>)
		case hideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		case highlightColumn(Signal<NSUserInterfaceItemIdentifier?>)
		case moveColumn(Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>)
		case scrollColumnToVisible(Signal<NSUserInterfaceItemIdentifier>)
		case scrollTreePathToVisible(Signal<TreePath<NodeData>>)
		case selectAll(Signal<Void>)
		case selectColumns(Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>)
		case selectTreePaths(Signal<(treePaths: Set<TreePath<NodeData>>, byExtendingSelection: Bool)>)
		case setDropTreePath(Signal<(treePath: TreePath<NodeData>?, dropChildIndex: Int)>)
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
		case selectionChanged(SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedTreePaths: Set<TreePath<NodeData>>)>)
		case selectionIsChanging(SignalInput<Void>)
		case sortDescriptorsDidChange(SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>)
		case treePathDidCollapse(SignalInput<TreePath<NodeData>>)
		case treePathDidExpand(SignalInput<TreePath<NodeData>>)
		case treePathWillCollapse(SignalInput<TreePath<NodeData>>)
		case treePathWillExpand(SignalInput<TreePath<NodeData>>)
		case visibleTreePathsChanged(SignalInput<Set<TreePath<NodeData>>>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case acceptDrop((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ treePath: TreePath<NodeData>?, _ childIndex: Int) -> Bool)
		case draggingSessionEnded((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void)
		case draggingSessionWillBegin((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [TreePath<NodeData>]) -> Void)
		case groupRowCellConstructor((Int) -> TableCellViewConvertible)
		case heightOfRow((_ treePath: TreePath<NodeData>) -> CGFloat)
		case indexPathForPersistentObject((Any) -> IndexPath?)
		case isTreePathExpandable((TreePath<NodeData>) -> Bool)
		case nextTypeSelectMatch((_ outlineView: NSOutlineView, _ from: TreePath<NodeData>, _ to: TreePath<NodeData>, _ for: String) -> IndexPath?)
		case pasteboardWriter((_ outlineView: NSOutlineView, _ forTreePath: TreePath<NodeData>) -> NSPasteboardWriting?)
		case persistentObjectForTreePath((TreePath<NodeData>) -> Any?)
		case rowView((_ treePath: TreePath<NodeData>) -> TableRowViewConvertible?)
		case selectionIndexesForProposedSelection((_ proposedSelectionIndexes: Set<TreePath<NodeData>>) -> Set<TreePath<NodeData>>)
		case selectionShouldChange((_ outlineView: NSOutlineView) -> Bool)
		case shouldCollapse((_ treePath: TreePath<NodeData>) -> Bool)
		case shouldExpand((_ treePath: TreePath<NodeData>) -> Bool)
		case shouldReorderColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn, _ newIndex: Int) -> Bool)
		case shouldSelectTableColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn?) -> Bool)
		case shouldSelectTreePath((_ outlineView: NSOutlineView, _ treePath: TreePath<NodeData>) -> Bool)
		case shouldTypeSelectForEvent((_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool)
		case sizeToFitWidthOfColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn) -> CGFloat)
		case typeSelectString((_ outlineView: NSOutlineView, _ column: NSTableColumn?, _ treePath: TreePath<NodeData>) -> String?)
		case updateDraggingItems((_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void)
		case validateDrop((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedTreePath: TreePath<NodeData>?, _ proposedChildIndex: Int) -> NSDragOperation)
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
		case .persistentObjectForTreePath(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:persistentObjectForItem:)))
		case .rowView(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:rowViewForItem:)))
		case .selectionIndexesForProposedSelection(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:selectionIndexesForProposedSelection:)))
		case .selectionShouldChange(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.selectionShouldChange(in:)))
		case .shouldCollapse(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldCollapseItem:)))
		case .shouldExpand(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldExpandItem:)))
		case .shouldReorderColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldReorderColumn:toColumn:)))
		case .shouldSelectTableColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldSelect:)))
		case .shouldSelectTreePath(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldSelectItem:)))
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
		case .treeData(let x): return x.apply(instance, storage) { i, s, v in s.applyTableRowMutation(v, to: i) }
		case .userInterfaceLayoutDirection(let x): return x.apply(instance) { i, v in i.userInterfaceLayoutDirection = v }
		case .usesAlternatingRowBackgroundColors(let x): return x.apply(instance) { i, v in i.usesAlternatingRowBackgroundColors = v }
		case .verticalMotionCanBeginDrag(let x): return x.apply(instance) { i, v in i.verticalMotionCanBeginDrag = v }

		case .stronglyReferencesItems(let x): return x.apply(instance) { i, v in i.stronglyReferencesItems = v }
		
		// 2. Signal bindings are performed on the object after construction.
		case .collapseTreePath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let treePath = v.treePath, let item = s.item(forTreePath: treePath, in: i) {
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
		case .deselectTreePath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let row: Int = s.row(forTreePath: v, in: i) {
					i.deselectRow(row)
				}
			}
		case .expandTreePath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let treePath = v.treePath, let item = s.item(forTreePath: treePath, in: i) {
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
		case .scrollTreePathToVisible(let x):
			return x.apply(instance, storage) { i, s, v in
				if let row: Int = s.row(forTreePath: v, in: i) {
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
		case .selectTreePaths(let x):
			return x.apply(instance, storage) { i, s, v in
				let indexes = v.treePaths.compactMap { s.row(forTreePath: $0, in: i) }
				i.selectRowIndexes(IndexSet(indexes), byExtendingSelection: v.byExtendingSelection)
			}
		case .setDropTreePath(let x):
			return x.apply(instance, storage) { i, s, v in
				if let treePath = v.treePath, let item = s.item(forTreePath: treePath, in: i) {
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
			return Signal.notifications(name: NSTableView.selectionDidChangeNotification, object: instance).compactMap { [weak instance, weak storage] n -> (selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedTreePaths: Set<TreePath<NodeData>>)? in
				guard let i = instance else {
					return nil
				}
				let selectedColumns = Set<NSUserInterfaceItemIdentifier>(i.selectedColumnIndexes.compactMap { i.tableColumns.at($0)?.identifier })
				let selectedTreePaths = Set(i.selectedRowIndexes.compactMap { storage?.treePath(forRow: $0, in: i) })
				return (selectedColumns: selectedColumns, selectedTreePaths: selectedTreePaths)
				}.cancellableBind(to: x)
		case .selectionIsChanging(let x):
			return Signal.notifications(name: NSTableView.selectionIsChangingNotification, object: instance).map { notification -> Void in () }.cancellableBind(to: x)
		case .sortDescriptorsDidChange: return nil
		case .treePathDidCollapse(let x):
			return Signal.notifications(name: NSOutlineView.itemDidCollapseNotification, object: instance).compactMap { [weak instance, weak storage] notification -> TreePath<NodeData>? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.treePath(forItem: $0, in: i) }
				}.cancellableBind(to: x)
		case .treePathDidExpand(let x):
			return Signal.notifications(name: NSOutlineView.itemDidExpandNotification, object: instance).compactMap { [weak instance, weak storage] notification -> TreePath<NodeData>? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.treePath(forItem: $0, in: i) }
			}.cancellableBind(to: x)
		case .treePathWillCollapse(let x):
			return Signal.notifications(name: NSOutlineView.itemWillCollapseNotification, object: instance).compactMap { [weak instance, weak storage] notification -> TreePath<NodeData>? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.treePath(forItem: $0, in: i) }
			}.cancellableBind(to: x)
		case .treePathWillExpand(let x):
			return Signal.notifications(name: NSOutlineView.itemWillExpandNotification, object: instance).compactMap { [weak instance, weak storage] notification -> TreePath<NodeData>? in
				guard let b = storage, let i = instance else { return nil }
				return notification.userInfo?["NSObject"].flatMap { b.treePath(forItem: $0, in: i) }
				}.cancellableBind(to: x)
		case .visibleTreePathsChanged(let x):
			storage.visibleTreePathsSignalInput = x
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
		case .isTreePathExpandable: return nil
		case .nextTypeSelectMatch: return nil
		case .pasteboardWriter: return nil
		case .persistentObjectForTreePath: return nil
		case .rowView: return nil
		case .selectionIndexesForProposedSelection: return nil
		case .selectionShouldChange: return nil
		case .shouldCollapse: return nil
		case .shouldExpand: return nil
		case .shouldReorderColumn: return nil
		case .shouldSelectTableColumn: return nil
		case .shouldSelectTreePath: return nil
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
		open var treeState = TableRowState<TreeState<NodeData>>()
		open var visibleTreePaths: Set<TreePath<NodeData>> = []
		open var visibleTreePathsSignalInput: SignalInput<Set<TreePath<NodeData>>>? = nil
		open var groupRowCellConstructor: ((Int) -> TableCellViewConvertible)?
		open var columns: [TableColumn<NodeData>.Preparer.Storage] = []
		open var outlineColumnIdentifier: NSUserInterfaceItemIdentifier? = nil
		
		open func columnForIdentifier(_ identifier: NSUserInterfaceItemIdentifier) -> (offset: Int, element: TableColumn<NodeData>.Preparer.Storage)? {
			return columns.enumerated().first { (tuple: (offset: Int, element: TableColumn<NodeData>.Preparer.Storage)) -> Bool in
				tuple.element.tableColumn.identifier == identifier
			}
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didAdd: NSTableRowView, forRow: Int) {
			if let vrsi = visibleTreePathsSignalInput, let path = treePath(forRow: forRow, in: outlineView) {
				if visibleTreePaths.insert(path).inserted {
					vrsi.send(value: visibleTreePaths)
				}
			}
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didRemove: NSTableRowView, forRow: Int) {
			if let vrsi = visibleTreePathsSignalInput, let path = treePath(forRow: forRow, in: outlineView) {
				if visibleTreePaths.insert(path).inserted {
					vrsi.send(value: visibleTreePaths)
				}
			}
		}
		
		open func outlineView(_ outlineView: NSOutlineView, child: Int, ofItem: Any?) -> Any {
			if ofItem == nil {
				return treeState.rows.at(child) ?? TreeState<NodeData>(parent: nil, index: child)
			}
			if let parent = ofItem as? TreeState<NodeData> {
				return parent.children?.rows.at(child) ?? TreeState<NodeData>(parent: parent, index: child)
			}
			return TreeState<NodeData>(parent: nil, index: child)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
			return ((item as? TreeState<NodeData>)?.children ?? nil) != nil
		}
		
		open func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
			if item == nil {
				return treeState.globalCount
			}
			return (item as? TreeState<NodeData>)?.children?.globalCount ?? 0
		}
		
		open func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
			return item
		}
		
		open func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
			if let tc = tableColumn {
				if let col = columnForIdentifier(tc.identifier) {
					let data = (item as? TreeState<NodeData>)?.data
					let identifier = col.element.cellIdentifier?(data) ?? tc.identifier
					
					let cellView: NSTableCellView
					let cellInput: SignalInput<NodeData>?
					if let reusedView = outlineView.makeView(withIdentifier: identifier, owner: outlineView), let downcast = reusedView as? NSTableCellView {
						cellView = downcast
						cellInput = getSignalInput(for: cellView, valueType: NodeData.self)
					} else if let cc = col.element.cellConstructor {
						let dataTuple = Signal<NodeData>.create()
						let constructed = cc(identifier, dataTuple.signal.multicast()).nsTableCellView()
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
		
		open func applyTableRowMutation(_ rowMutation: TableRowMutation<TreeMutation<NodeData>>, to outlineView: NSOutlineView) {
			let animation = apply(rowMutation: rowMutation, to: &treeState, ofParent: nil)
			animation(outlineView)
		}
		
		open func treePath(forItem: Any, in outlineView: NSOutlineView) -> TreePath<NodeData>? {
			var indexes = Array<TreePath<NodeData>.NodeIndex>()
			var parent = forItem as? TreeState<NodeData>
			while let item = parent {
				parent = item.parent
				if let i = item.index {
					indexes.append(TreePath<NodeData>.NodeIndex(index: i, data: item.data))
					if parent == nil, let check = treeState.rows.at(i), check === item {
					} else {
						return nil
					}
				} else {
					return nil
				}
			}
			return TreePath<NodeData>(indexes: indexes)
		}
		
		open func treePath(forRow row: Int, in outlineView: NSOutlineView) -> TreePath<NodeData>? {
			if let item = outlineView.item(atRow: row) {
				return treePath(forItem: item, in: outlineView)
			}
			return nil
		}
		
		open func row(forTreePath treePath: TreePath<NodeData>, in outlineView: NSOutlineView) -> Int? {
			if let i = item(forTreePath: treePath, in: outlineView) {
				return outlineView.row(forItem: i)
			}
			return nil
		}
		
		open func item(forTreePath treePath: TreePath<NodeData>, in: NSOutlineView) -> Any? {
			var state: TableRowState<TreeState<NodeData>>? = treeState
			
			// Walk the internal state structure, following the indicies in the tree path
			for node in treePath.indexes.dropLast() {
				guard let s = state else { return nil }
				state = s.rows.at(node.index)?.children
			}
			
			// Return the state item for the last index
			guard let last = treePath.indexes.last?.index else { return nil }
			return state?.rows.at(last)
		}
		
		open func item(forIndexPath indexPath: IndexPath, in: NSOutlineView) -> Any? {
			var state: TableRowState<TreeState<NodeData>>? = treeState
			
			// Walk the internal state structure, following the indicies in the tree path
			for index in indexPath.dropLast() {
				guard let s = state else { return nil }
				state = s.rows.at(index)?.children
			}
			
			// Return the state item for the last index
			guard let last = indexPath.last else { return nil }
			return state?.rows.at(last)
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
		
		open var rowView: ((_ treePath: TreePath<NodeData>) -> TableRowViewConvertible?)?
		open func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
			if let treePath = storage(for: outlineView)?.treePath(forItem: item, in: outlineView) {
				return rowView!(treePath)?.nsTableRowView()
			}
			return nil
		}
		
		open var heightOfRow: ((_ treePath: TreePath<NodeData>) -> CGFloat)?
		open func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
			if let treePath = storage(for: outlineView)?.treePath(forItem: item, in: outlineView) {
				return heightOfRow!(treePath)
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
		
		open var typeSelectString: ((_ outlineView: NSOutlineView, _ tableColumn: NSTableColumn?, _ treePath: TreePath<NodeData>) -> String?)?
		open func outlineView(_ outlineView: NSOutlineView, typeSelectStringFor tableColumn: NSTableColumn?, item: Any) -> String? {
			if let treePath = storage(for: outlineView)?.treePath(forItem: item, in: outlineView) {
				return typeSelectString!(outlineView, tableColumn, treePath)
			}
			return nil
		}
		
		open var nextTypeSelectMatch: ((_ outlineView: NSOutlineView, _ startTreePath: TreePath<NodeData>, _ endTreePath: TreePath<NodeData>, _ searchString: String) -> IndexPath?)?
		open func outlineView(_ outlineView: NSOutlineView, nextTypeSelectMatchFromItem startItem: Any, toItem endItem: Any, for searchString: String) -> Any? {
			if let startTreePath = storage(for: outlineView)?.treePath(forItem: startItem, in: outlineView), let endTreePath = storage(for: outlineView)?.treePath(forItem: endItem, in: outlineView) {
				if let indexPath = nextTypeSelectMatch!(outlineView, startTreePath, endTreePath, searchString) {
					return storage(for: outlineView)?.item(forIndexPath: indexPath, in: outlineView)
				}
			}
			return nil
		}
		
		open func outlineView(_ outlineView: NSOutlineView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
			return handler(ofType: ((NSOutlineView, NSTableColumn?) -> Bool).self)!(outlineView, tableColumn)
		}
		
		open var selectionIndexesForProposedSelection: ((_ proposedSelectionIndexes: Set<TreePath<NodeData>>) -> Set<TreePath<NodeData>>)?
		open func outlineView(_ outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
			var treePaths = Set<TreePath<NodeData>>()
			for index in proposedSelectionIndexes {
				if let path = storage(for: outlineView)?.treePath(forRow: index, in: outlineView) {
					treePaths.insert(path)
				}
			}
			let treePathResult = selectionIndexesForProposedSelection!(treePaths)
			var result = IndexSet()
			for treePath in treePathResult {
				if let index = storage(for: outlineView)?.row(forTreePath: treePath, in: outlineView) {
					result.insert(index)
				}
			}
			return result
		}
		
		open var shouldSelectTreePath: ((_ outlineView: NSOutlineView, _ treePath: TreePath<NodeData>) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
			if let treePath = storage(for: outlineView)?.treePath(forItem: item, in: outlineView) {
				return shouldSelectTreePath!(outlineView, treePath)
			}
			return false
		}
		
		open func selectionShouldChange(in outlineView: NSOutlineView) -> Bool {
			return handler(ofType: ((NSOutlineView) -> Bool).self)!(outlineView)
		}
		
		open var shouldExpand: ((_ treePath: TreePath<NodeData>) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
			if let treePath = storage(for: outlineView)?.treePath(forItem: item, in: outlineView) {
				return shouldExpand!(treePath)
			}
			return false
		}
		
		open var shouldCollapse: ((_ treePath: TreePath<NodeData>) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
			if let treePath = storage(for: outlineView)?.treePath(forItem: item, in: outlineView) {
				return shouldCollapse!(treePath)
			}
			return false
		}
		
		open var acceptDrop: ((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ treePath: TreePath<NodeData>?, _ childIndex: Int) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
			if let i = item {
				if let treePath = storage(for: outlineView)?.treePath(forItem: i, in: outlineView) {
					return acceptDrop!(outlineView, info, treePath, index)
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
		
		open var draggingSessionWillBegin: ((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [TreePath<NodeData>]) -> Void)?
		open func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
			let treePaths = draggedItems.compactMap { storage(for: outlineView)?.treePath(forItem: $0, in: outlineView) }
			return draggingSessionWillBegin!(outlineView, session, screenPoint, treePaths)
		}
		
		open var isTreePathExpandable: ((_ treePath: TreePath<NodeData>) -> Bool)?
		open func outlineView(_ outlineView: NSOutlineView, isItemExpandable: Any) -> Bool {
			if let treePath = storage(for: outlineView)?.treePath(forItem: isItemExpandable, in: outlineView) {
				return isTreePathExpandable!(treePath)
			}
			return false
		}
		
		open func outlineView(_ outlineView: NSOutlineView, itemForPersistentObject object: Any) -> Any? {
			return handler(ofType: ((Any) -> IndexPath?).self)!(object).flatMap { storage(for: outlineView)?.item(forIndexPath: $0, in: outlineView) }
		}
		
		open var persistentObjectForTreePath: ((_ treePath: TreePath<NodeData>) -> Any?)?
		open func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
			if let i = item, let treePath = storage(for: outlineView)?.treePath(forItem: i, in: outlineView) {
				return persistentObjectForTreePath!(treePath)
			}
			return nil
		}
		
		open var pasteboardWriter: ((_ outlineView: NSOutlineView, _ forTreePath: TreePath<NodeData>) -> NSPasteboardWriting?)?
		open func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
			if let treePath = storage(for: outlineView)?.treePath(forItem: item, in: outlineView) {
				return pasteboardWriter!(outlineView, treePath)
			}
			return nil
		}
		
		open func outlineView(_ outlineView: NSOutlineView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
			handler(ofType: ((NSOutlineView, NSDraggingInfo) -> Void).self)!(outlineView, draggingInfo)
		}
		
		open var validateDrop: ((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedTreePath: TreePath<NodeData>?, _ proposedChildIndex: Int) -> NSDragOperation)?
		open func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
			if let i = item {
				if let treePath = storage(for: outlineView)?.treePath(forItem: i, in: outlineView) {
					return validateDrop!(outlineView, info, treePath, index)
				} else {
					return []
				}
			}
			return validateDrop!(outlineView, info, nil, index)
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
	static var treeData: OutlineViewName<Dynamic<TableRowMutation<TreeMutation<Binding.NodeDataType>>>> { return .name(B.treeData) }
	static var userInterfaceLayoutDirection: OutlineViewName<Dynamic<NSUserInterfaceLayoutDirection>> { return .name(B.userInterfaceLayoutDirection) }
	static var usesAlternatingRowBackgroundColors: OutlineViewName<Dynamic<Bool>> { return .name(B.usesAlternatingRowBackgroundColors) }
	static var verticalMotionCanBeginDrag: OutlineViewName<Dynamic<Bool>> { return .name(B.verticalMotionCanBeginDrag) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var collapseTreePath: OutlineViewName<Signal<(treePath: TreePath<Binding.NodeDataType>?, collapseChildren: Bool)>> { return .name(B.collapseTreePath) }
	static var deselectAll: OutlineViewName<Signal<Void>> { return .name(B.deselectAll) }
	static var deselectColumn: OutlineViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(B.deselectColumn) }
	static var deselectTreePath: OutlineViewName<Signal<TreePath<Binding.NodeDataType>>> { return .name(B.deselectTreePath) }
	static var expandTreePath: OutlineViewName<Signal<(treePath: TreePath<Binding.NodeDataType>?, expandChildren: Bool)>> { return .name(B.expandTreePath) }
	static var hideRowActions: OutlineViewName<Signal<Void>> { return .name(B.hideRowActions) }
	static var hideRows: OutlineViewName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>> { return .name(B.hideRows) }
	static var highlightColumn: OutlineViewName<Signal<NSUserInterfaceItemIdentifier?>> { return .name(B.highlightColumn) }
	static var moveColumn: OutlineViewName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>> { return .name(B.moveColumn) }
	static var scrollColumnToVisible: OutlineViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(B.scrollColumnToVisible) }
	static var scrollTreePathToVisible: OutlineViewName<Signal<TreePath<Binding.NodeDataType>>> { return .name(B.scrollTreePathToVisible) }
	static var selectAll: OutlineViewName<Signal<Void>> { return .name(B.selectAll) }
	static var selectColumns: OutlineViewName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>> { return .name(B.selectColumns) }
	static var selectTreePaths: OutlineViewName<Signal<(treePaths: Set<TreePath<Binding.NodeDataType>>, byExtendingSelection: Bool)>> { return .name(B.selectTreePaths) }
	static var setDropTreePath: OutlineViewName<Signal<(treePath: TreePath<Binding.NodeDataType>?, dropChildIndex: Int)>> { return .name(B.setDropTreePath) }
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
	static var selectionChanged: OutlineViewName<SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedTreePaths: Set<TreePath<Binding.NodeDataType>>)>> { return .name(B.selectionChanged) }
	static var selectionIsChanging: OutlineViewName<SignalInput<Void>> { return .name(B.selectionIsChanging) }
	static var sortDescriptorsDidChange: OutlineViewName<SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>> { return .name(B.sortDescriptorsDidChange) }
	static var treePathDidCollapse: OutlineViewName<SignalInput<TreePath<Binding.NodeDataType>>> { return .name(B.treePathDidCollapse) }
	static var treePathDidExpand: OutlineViewName<SignalInput<TreePath<Binding.NodeDataType>>> { return .name(B.treePathDidExpand) }
	static var treePathWillCollapse: OutlineViewName<SignalInput<TreePath<Binding.NodeDataType>>> { return .name(B.treePathWillCollapse) }
	static var treePathWillExpand: OutlineViewName<SignalInput<TreePath<Binding.NodeDataType>>> { return .name(B.treePathWillExpand) }
	static var visibleTreePathsChanged: OutlineViewName<SignalInput<Set<TreePath<Binding.NodeDataType>>>> { return .name(B.visibleTreePathsChanged) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var acceptDrop: OutlineViewName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ treePath: TreePath<Binding.NodeDataType>?, _ childIndex: Int) -> Bool> { return .name(B.acceptDrop) }
	static var draggingSessionEnded: OutlineViewName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void> { return .name(B.draggingSessionEnded) }
	static var draggingSessionWillBegin: OutlineViewName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [TreePath<Binding.NodeDataType>]) -> Void> { return .name(B.draggingSessionWillBegin) }
	static var groupRowCellConstructor: OutlineViewName<(Int) -> TableCellViewConvertible> { return .name(B.groupRowCellConstructor) }
	static var heightOfRow: OutlineViewName<(_ treePath: TreePath<Binding.NodeDataType>) -> CGFloat> { return .name(B.heightOfRow) }
	static var indexPathForPersistentObject: OutlineViewName<(Any) -> IndexPath?> { return .name(B.indexPathForPersistentObject) }
	static var isTreePathExpandable: OutlineViewName<(TreePath<Binding.NodeDataType>) -> Bool> { return .name(B.isTreePathExpandable) }
	static var nextTypeSelectMatch: OutlineViewName<(_ outlineView: NSOutlineView, _ from: TreePath<Binding.NodeDataType>, _ to: TreePath<Binding.NodeDataType>, _ for: String) -> IndexPath?> { return .name(B.nextTypeSelectMatch) }
	static var pasteboardWriter: OutlineViewName<(_ outlineView: NSOutlineView, _ forTreePath: TreePath<Binding.NodeDataType>) -> NSPasteboardWriting?> { return .name(B.pasteboardWriter) }
	static var persistentObjectForTreePath: OutlineViewName<(TreePath<Binding.NodeDataType>) -> Any?> { return .name(B.persistentObjectForTreePath) }
	static var rowView: OutlineViewName<(_ treePath: TreePath<Binding.NodeDataType>) -> TableRowViewConvertible?> { return .name(B.rowView) }
	static var selectionIndexesForProposedSelection: OutlineViewName<(_ proposedSelectionIndexes: Set<TreePath<Binding.NodeDataType>>) -> Set<TreePath<Binding.NodeDataType>>> { return .name(B.selectionIndexesForProposedSelection) }
	static var selectionShouldChange: OutlineViewName<(_ outlineView: NSOutlineView) -> Bool> { return .name(B.selectionShouldChange) }
	static var shouldCollapse: OutlineViewName<(_ treePath: TreePath<Binding.NodeDataType>) -> Bool> { return .name(B.shouldCollapse) }
	static var shouldExpand: OutlineViewName<(_ treePath: TreePath<Binding.NodeDataType>) -> Bool> { return .name(B.shouldExpand) }
	static var shouldReorderColumn: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn, _ newIndex: Int) -> Bool> { return .name(B.shouldReorderColumn) }
	static var shouldSelectTableColumn: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?) -> Bool> { return .name(B.shouldSelectTableColumn) }
	static var shouldSelectTreePath: OutlineViewName<(_ outlineView: NSOutlineView, _ treePath: TreePath<Binding.NodeDataType>) -> Bool> { return .name(B.shouldSelectTreePath) }
	static var shouldTypeSelectForEvent: OutlineViewName<(_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool> { return .name(B.shouldTypeSelectForEvent) }
	static var sizeToFitWidthOfColumn: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn) -> CGFloat> { return .name(B.sizeToFitWidthOfColumn) }
	static var typeSelectString: OutlineViewName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?, _ treePath: TreePath<Binding.NodeDataType>) -> String?> { return .name(B.typeSelectString) }
	static var updateDraggingItems: OutlineViewName<(_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void> { return .name(B.updateDraggingItems) }
	static var validateDrop: OutlineViewName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedTreePath: TreePath<Binding.NodeDataType>?, _ proposedChildIndex: Int) -> NSDragOperation> { return .name(B.validateDrop) }

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
	public func nsOutlineView() -> NSOutlineView { return instance() }
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
	public typealias Preparer = OutlineView.Preparer
	static func outlineViewBinding(_ binding: OutlineView<NodeDataType>.Binding) -> OutlineView<NodeDataType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct OutlineCell<NodeData> {
	public let row: Int
	public let column: Int
	public let columnIdentifier: NSUserInterfaceItemIdentifier
	public let data: TreePath<NodeData>?
	
	public init(row: Int, column: Int, outlineView: NSOutlineView) {
		self.row = row
		self.data = (outlineView.delegate as? OutlineView<NodeData>.Preparer.Storage)?.treePath(forRow: row, in: outlineView)
		self.column = column
		self.columnIdentifier = outlineView.tableColumns[column].identifier
	}
	
	public init(row: Int, column: NSTableColumn, outlineView: NSOutlineView) {
		self.row = row
		self.column = outlineView.column(withIdentifier: column.identifier)
		self.columnIdentifier = column.identifier
		self.data = (outlineView.delegate as? OutlineView<NodeData>.Preparer.Storage)?.treePath(forRow: row, in: outlineView)
	}
}

#endif
