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

public class OutlineView<NodeData>: Binder, OutlineViewConvertible {
	public static func scrollEmbedded(subclass: NSOutlineView.Type = NSOutlineView.self, _ bindings: Binding...) -> ScrollView {
		return ScrollView(
			.borderType -- .bezelBorder,
			.hasVerticalScroller -- true,
			.hasHorizontalScroller -- true,
			.autohidesScrollers -- true,
			.contentView -- ClipView(
				.documentView -- OutlineView<NodeData>(subclass: subclass, bindings: bindings)
			)
		)
	}

	public typealias Instance = NSOutlineView
	public typealias Inherited = Control
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsOutlineView() -> Instance { return instance() }

	enum Binding: OutlineViewBinding {
		public typealias NodeDataType = NodeData
		public typealias EnclosingBinder = OutlineView
		public static func outlineViewBinding(_ binding: Binding) -> Binding { return binding }
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
		case columns(Dynamic<[TableColumn<NodeData>]>)
		@available(macOS 10.12, *)
		case stronglyReferencesItems(Dynamic<Bool>)
		case outlineTableColumnIdentifier(Dynamic<NSUserInterfaceItemIdentifier>)
		case autoresizesOutlineColumn(Dynamic<Bool>)
		case indentationPerLevel(Dynamic<CGFloat>)
		case indentationMarkerFollowsCell(Dynamic<Bool>)
		case autosaveExpandedItems(Dynamic<Bool>)
		case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)
		case treeData(Dynamic<TableRowMutation<TreeMutation<NodeData>>>)
		
		// 2. Signal bindings are performed on the object after construction.
		case highlightColumn(Signal<NSUserInterfaceItemIdentifier?>)
		case selectColumns(Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>)
		case selectTreePaths(Signal<(treePaths: Set<TreePath<NodeData>>, byExtendingSelection: Bool)>)
		case deselectColumn(Signal<NSUserInterfaceItemIdentifier>)
		case deselectTreePath(Signal<TreePath<NodeData>>)
		case selectAll(Signal<Void>)
		case deselectAll(Signal<Void>)
		case sizeLastColumnToFit(Signal<Void>)
		case sizeToFit(Signal<Void>)
		case scrollTreePathToVisible(Signal<TreePath<NodeData>>)
		case scrollColumnToVisible(Signal<NSUserInterfaceItemIdentifier>)
		case moveColumn(Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>)
		@available(macOS 10.11, *) case hideRowActions(Signal<Void>)
		@available(macOS 10.11, *) case hideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		@available(macOS 10.11, *) case unhideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		case expandTreePath(Signal<(treePath: TreePath<NodeData>?, expandChildren: Bool)>)
		case collapseTreePath(Signal<(treePath: TreePath<NodeData>?, collapseChildren: Bool)>)
		case setDropTreePath(Signal<(treePath: TreePath<NodeData>?, dropChildIndex: Int)>)
		
		// 3. Action bindings are triggered by the object after construction.
		case action(TargetAction)
		case doubleAction(TargetAction)
		case columnResized(SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>)
		case columnMoved(SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>)
		case didDragTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case didClickTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case mouseDownInHeaderOfTableColumn(SignalInput<NSUserInterfaceItemIdentifier>)
		case treePathWillExpand(SignalInput<TreePath<NodeData>>)
		case treePathDidExpand(SignalInput<TreePath<NodeData>>)
		case treePathWillCollapse(SignalInput<TreePath<NodeData>>)
		case treePathDidCollapse(SignalInput<TreePath<NodeData>>)
		case sortDescriptorsDidChange(SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>)
		case selectionChanged(SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedTreePaths: Set<TreePath<NodeData>>)>)
		case selectionIsChanging(SignalInput<Void>)
		case visibleTreePathsChanged(SignalInput<Set<TreePath<NodeData>>>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case groupRowCellConstructor((Int) -> TableCellViewConvertible)
		case rowView((_ treePath: TreePath<NodeData>) -> TableRowViewConvertible?)
		case heightOfRow((_ treePath: TreePath<NodeData>) -> CGFloat)
		case shouldExpand((_ treePath: TreePath<NodeData>) -> Bool)
		case shouldCollapse((_ treePath: TreePath<NodeData>) -> Bool)
		case typeSelectString((_ outlineView: NSOutlineView, _ column: NSTableColumn?, _ treePath: TreePath<NodeData>) -> String?)
		case nextTypeSelectMatch((_ outlineView: NSOutlineView, _ from: TreePath<NodeData>, _ to: TreePath<NodeData>, _ for: String) -> IndexPath?)
		case shouldTypeSelectForEvent((_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool)
		case shouldSelectTableColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn?) -> Bool)
		case shouldSelectTreePath((_ outlineView: NSOutlineView, _ treePath: TreePath<NodeData>) -> Bool)
		case selectionIndexesForProposedSelection((_ proposedSelectionIndexes: Set<TreePath<NodeData>>) -> Set<TreePath<NodeData>>)
		case selectionShouldChange((_ outlineView: NSOutlineView) -> Bool)
		case shouldReorderColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn, _ newIndex: Int) -> Bool)
		case sizeToFitWidthOfColumn((_ outlineView: NSOutlineView, _ column: NSTableColumn) -> CGFloat)
		case acceptDrop((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ treePath: TreePath<NodeData>?, _ childIndex: Int) -> Bool)
		case draggingSessionEnded((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void)
		case draggingSessionWillBegin((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [TreePath<NodeData>]) -> Void)
		case isTreePathExpandable((TreePath<NodeData>) -> Bool)
		case indexPathForPersistentObject((Any) -> IndexPath?)
		case persistentObjectForTreePath((TreePath<NodeData>) -> Any?)
		case pasteboardWriter((_ outlineView: NSOutlineView, _ forTreePath: TreePath<NodeData>) -> NSPasteboardWriting?)
		case updateDraggingItems((_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void)
		case validateDrop((_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedTreePath: TreePath<NodeData>?, _ proposedChildIndex: Int) -> NSDragOperation)
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = OutlineView
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
		
		var outlineColumn: NSUserInterfaceItemIdentifier? = nil
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .didDragTableColumn(let x):
				let s = #selector(NSOutlineViewDelegate.outlineView(_:didDrag:))
				delegate().addSelector(s).didDragTableColumn = { tc in x.send(value: tc.identifier) }
			case .didClickTableColumn(let x):
				let s = #selector(NSOutlineViewDelegate.outlineView(_:didClick:))
				delegate().addSelector(s).didClickTableColumn = { tc in x.send(value: tc.identifier) }
			case .mouseDownInHeaderOfTableColumn(let x):
				let s = #selector(NSOutlineViewDelegate.outlineView(_:mouseDownInHeaderOf:))
				delegate().addSelector(s).mouseDownInHeaderOfTableColumn = { tc in x.send(value: tc.identifier) }
			case .rowView(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:rowViewForItem:)))
			case .heightOfRow(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:heightOfRowByItem:)))
			case .sortDescriptorsDidChange(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:sortDescriptorsDidChange:)))
			case .shouldExpand(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldExpandItem:)))
			case .shouldCollapse(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldCollapseItem:)))
			case .typeSelectString(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:typeSelectStringFor:item:)))
			case .nextTypeSelectMatch(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:nextTypeSelectMatchFromItem:toItem:for:)))
			case .shouldTypeSelectForEvent(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldTypeSelectFor:withCurrentSearch:)))
			case .shouldSelectTableColumn(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldSelect:)))
			case .shouldSelectTreePath(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:shouldSelectItem:)))
			case .selectionIndexesForProposedSelection(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.outlineView(_:selectionIndexesForProposedSelection:)))
			case .selectionShouldChange(let x): delegate().addHandler(x, #selector(NSOutlineViewDelegate.selectionShouldChange(in:)))
			case .acceptDrop(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:acceptDrop:item:childIndex:)))
			case .shouldReorderColumn(let x):
				let s = #selector(NSOutlineViewDelegate.outlineView(_:shouldReorderColumn:toColumn:))
				delegate().addSelector(s).shouldReorderColumn = { (instance, sourceIndex, targetIndex) -> Bool in
					if let column = instance.tableColumns.at(sourceIndex) {
						return x(instance, column, targetIndex)
					}
					return false
				}
			case .sizeToFitWidthOfColumn(let x):
				let s = #selector(NSOutlineViewDelegate.outlineView(_:sizeToFitWidthOfColumn:))
				delegate().addSelector(s).sizeToFitWidthOfColumn = { (instance, index) -> CGFloat in
					if let column = instance.tableColumns.at(index) {
						return x(instance, column)
					}
					return 0
				}
			case .draggingSessionEnded(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:draggingSession:endedAt:operation:)))
			case .indexPathForPersistentObject(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:itemForPersistentObject:)))
			case .persistentObjectForTreePath(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:persistentObjectForItem:)))
			case .pasteboardWriter(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:pasteboardWriterForItem:)))
			case .updateDraggingItems(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:updateDraggingItemsForDrag:)))
			case .validateDrop(let x): delegate().addHandler(x, #selector(NSOutlineViewDataSource.outlineView(_:validateDrop:proposedItem:proposedChildIndex:)))
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}
		
		public func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil && instance.dataSource == nil, "Conflicting delegate applied to instance")
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
			case .headerView(let x): return x.apply(instance) { i, v in i.headerView = v?.nsTableHeaderView() }
			case .cornerView(let x): return x.apply(instance) { i, v in i.cornerView = v?.nsView() }
			case .columns(let x): return x.apply(instance) { i, v in s.applyColumns(v.map { $0.construct() }, to: i) }
			case .stronglyReferencesItems(let x):
				return x.apply(instance) { i, v in
					if #available(macOS 10.12, *) {
						i.stronglyReferencesItems = v
					}
				}
			case .outlineTableColumnIdentifier(let x): return x.apply(instance) { i, v in s.outlineColumnIdentifier = v }
			case .autoresizesOutlineColumn(let x): return x.apply(instance) { i, v in i.autoresizesOutlineColumn = v }
			case .indentationPerLevel(let x): return x.apply(instance) { i, v in i.indentationPerLevel = v }
			case .indentationMarkerFollowsCell(let x): return x.apply(instance) { i, v in i.indentationMarkerFollowsCell = v }
			case .autosaveExpandedItems(let x): return x.apply(instance) { i, v in i.autosaveExpandedItems = v }
			case .userInterfaceLayoutDirection(let x): return x.apply(instance) { i, v in i.userInterfaceLayoutDirection = v }
			case .treeData(let x): return x.apply(instance) { i, v in s.applyTableRowMutation(v, to: i) }
			case .highlightColumn(let x):
				return x.apply(instance) { i, v in
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
			case .selectTreePaths(let x):
				return x.apply(instance) { i, v in
					let indexes = v.treePaths.compactMap { s.row(forTreePath: $0, in: i) }
					i.selectRowIndexes(IndexSet(indexes), byExtendingSelection: v.byExtendingSelection)
				}
			case .deselectColumn(let x):
				return x.apply(instance) { i, v in
					if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
						i.deselectColumn(index)
					}
				}
			case .deselectTreePath(let x):
				return x.apply(instance) { i, v in
					if let row: Int = s.row(forTreePath: v, in: i) {
						i.deselectRow(row)
					}
				}
			case .selectAll(let x): return x.apply(instance) { i, v in i.selectAll(nil) }
			case .deselectAll(let x): return x.apply(instance) { i, v in i.deselectAll(nil) }
			case .sizeLastColumnToFit(let x): return x.apply(instance) { i, v in i.sizeLastColumnToFit() }
			case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }
			case .scrollTreePathToVisible(let x):
				return x.apply(instance) { i, v in
					if let row: Int = s.row(forTreePath: v, in: i) {
						i.scrollRowToVisible(row)
					}
				}
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
			case .expandTreePath(let x):
				return x.apply(instance) { i, v in
					if let treePath = v.treePath, let item = s.item(forTreePath: treePath, in: i) {
						i.expandItem(item, expandChildren: v.expandChildren)
					} else {
						i.expandItem(nil, expandChildren: v.expandChildren)
					}
				}
			case .collapseTreePath(let x):
				return x.apply(instance) { i, v in
					if let treePath = v.treePath, let item = s.item(forTreePath: treePath, in: i) {
						i.collapseItem(item, collapseChildren: v.collapseChildren)
					} else {
						i.collapseItem(nil, collapseChildren: v.collapseChildren)
					}
				}
			case .setDropTreePath(let x):
				return x.apply(instance) { i, v in
					if let treePath = v.treePath, let item = s.item(forTreePath: treePath, in: i) {
						i.setDropItem(item, dropChildIndex: v.dropChildIndex)
					} else {
						i.setDropItem(nil, dropChildIndex: v.dropChildIndex)
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
					
					return target.signal.map { sender -> (clickedRow: Int?, clickedColumn: NSUserInterfaceItemIdentifier?) in
						// Deliberately retain the "target" in this closure so it remains alive until the BinderStorage is closed.
						withExtendedLifetime(target) { }
						guard let outlineView = sender as? NSOutlineView else { return (nil, nil) }
						return (clickedRow: outlineView.clickedRow, clickedColumn: outlineView.tableColumns.at(outlineView.clickedColumn)?.identifier)
					}.cancellableBind(to: s)
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
					
					return target.secondSignal.map { sender -> (clickedRow: Int?, clickedColumn: NSUserInterfaceItemIdentifier?) in
						// Deliberately retain the "target" in this closure so it remains alive until the BinderStorage is closed.
						withExtendedLifetime(target) { }
						guard let outlineView = sender as? NSOutlineView else { return (nil, nil) }
						return (clickedRow: outlineView.clickedRow, clickedColumn: outlineView.tableColumns.at(outlineView.clickedColumn)?.identifier)
					}.cancellableBind(to: s)
				}
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
			case .didDragTableColumn: return nil
			case .didClickTableColumn: return nil
			case .mouseDownInHeaderOfTableColumn: return nil
			case .treePathWillExpand(let x):
				return Signal.notifications(name: NSOutlineView.itemWillExpandNotification, object: instance).compactMap { [weak instance, weak storage] notification -> TreePath<NodeData>? in
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
			case .treePathDidCollapse(let x):
				return Signal.notifications(name: NSOutlineView.itemDidCollapseNotification, object: instance).compactMap { [weak instance, weak storage] notification -> TreePath<NodeData>? in
					guard let b = storage, let i = instance else { return nil }
					return notification.userInfo?["NSObject"].flatMap { b.treePath(forItem: $0, in: i) }
				}.cancellableBind(to: x)
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
			case .visibleTreePathsChanged(let x):
				storage.visibleTreePathsSignalInput = x
				return nil
				
			case .groupRowCellConstructor(let x):
				storage.groupRowCellConstructor = x
				return nil
			case .sortDescriptorsDidChange: return nil
			case .rowView: return nil
			case .heightOfRow: return nil
			case .shouldExpand: return nil
			case .shouldCollapse: return nil
			case .typeSelectString: return nil
			case .nextTypeSelectMatch: return nil
			case .shouldTypeSelectForEvent: return nil
				
			case .shouldSelectTableColumn: return nil
			case .shouldSelectTreePath: return nil
			case .selectionIndexesForProposedSelection: return nil
			case .selectionShouldChange: return nil
			case .shouldReorderColumn: return nil
			case .sizeToFitWidthOfColumn: return nil
				
			case .acceptDrop: return nil
			case .draggingSessionEnded: return nil
			case .draggingSessionWillBegin: return nil
			case .isTreePathExpandable: return nil
			case .indexPathForPersistentObject: return nil
			case .persistentObjectForTreePath: return nil
			case .pasteboardWriter: return nil
			case .updateDraggingItems: return nil
			case .validateDrop: return nil
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	open class Storage: View.Storage, NSOutlineViewDelegate, NSOutlineViewDataSource {
		open override var inUse: Bool { return true }
		
		open var actionTarget: SignalDoubleActionTarget? = nil
		open var treeState = TableRowState<TreeState<NodeData>>()
		open var visibleTreePaths: Set<TreePath<NodeData>> = []
		open var visibleTreePathsSignalInput: SignalInput<Set<TreePath<NodeData>>>? = nil
		open var groupRowCellConstructor: ((Int) -> TableCellViewConvertible)?
		open var columns: [TableColumn<NodeData>.Storage] = []
		open var outlineColumnIdentifier: NSUserInterfaceItemIdentifier? = nil
		
		open func columnForIdentifier(_ identifier: NSUserInterfaceItemIdentifier) -> (offset: Int, element: TableColumn<NodeData>.Storage)? {
			return columns.enumerated().first { (tuple: (offset: Int, element: TableColumn<NodeData>.Storage)) -> Bool in
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
				return groupRowCellConstructor?(outlineView.row(forItem: item)).nsTableCellView()
			}
			return nil
		}
		
		open var outlineTableColumn: TableColumn<NodeData>.Storage?
		open func applyOutlineTableColumn(_ outlineTableColumn: TableColumn<NodeData>.Storage, to outlineView: NSOutlineView) {
			self.outlineTableColumn = outlineTableColumn
			applyColumns(columns, to: outlineView)
		}
		
		open func applyColumns(_ v: [TableColumn<NodeData>.Storage], to outlineView: NSOutlineView) {
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
		public required override init() {
			super.init()
		}
		
		private func storage(for outlineView: NSOutlineView) -> Storage? {
			return outlineView.delegate as? Storage
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didDrag tableColumn: NSTableColumn) {
			handler(ofType: ((NSTableColumn) -> Void).self)(tableColumn)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, didClick tableColumn: NSTableColumn) {
			handler(ofType: ((NSTableColumn) -> Void).self)(tableColumn)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
			handler(ofType: ((NSTableColumn) -> Void).self)(tableColumn)
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
			return handler(ofType: ((_ outlineView: NSOutlineView, _ sourceIndex: Int, _ targetIndex: Int) -> Bool).self)(outlineView, columnIndex, newColumnIndex)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
			return handler(ofType: ((_ outlineView: NSOutlineView, _ column: Int) -> CGFloat).self)(outlineView, column)
		}
		
		open func outlineView(_ outlineView: NSOutlineView, shouldTypeSelectFor event: NSEvent, withCurrentSearch searchString: String?) -> Bool {
			return handler(ofType: ((_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool).self)(outlineView, event, searchString)
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
			return handler(ofType: ((_ outlineView: NSOutlineView, _ tableColumn: NSTableColumn?) -> Bool).self)(outlineView, tableColumn)
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
			return handler(ofType: ((_ outlineView: NSOutlineView) -> Bool).self)(outlineView)
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
			handler(ofType: SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>.self).send(value: (new: outlineView.sortDescriptors, old: oldDescriptors))
		}
		
		open func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
			return handler(ofType: ((_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void).self)(outlineView, session, screenPoint, operation)
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
			return handler(ofType: ((_ persistentObject: Any) -> IndexPath?).self)(object).flatMap { storage(for: outlineView)?.item(forIndexPath: $0, in: outlineView) }
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
			handler(ofType: ((_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void).self)(outlineView, draggingInfo)
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

extension BindingName where Binding: OutlineViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsColumnReordering: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.allowsColumnReordering(v)) }) }
	public static var allowsColumnResizing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.allowsColumnResizing(v)) }) }
	public static var allowsMultipleSelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.allowsMultipleSelection(v)) }) }
	public static var allowsEmptySelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.allowsEmptySelection(v)) }) }
	public static var allowsColumnSelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.allowsColumnSelection(v)) }) }
	public static var intercellSpacing: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.intercellSpacing(v)) }) }
	public static var rowHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.rowHeight(v)) }) }
	public static var backgroundColor: BindingName<Dynamic<NSColor>, Binding> { return BindingName<Dynamic<NSColor>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.backgroundColor(v)) }) }
	public static var usesAlternatingRowBackgroundColors: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.usesAlternatingRowBackgroundColors(v)) }) }
	public static var selectionHighlightStyle: BindingName<Dynamic<NSTableView.SelectionHighlightStyle>, Binding> { return BindingName<Dynamic<NSTableView.SelectionHighlightStyle>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectionHighlightStyle(v)) }) }
	public static var gridColor: BindingName<Dynamic<NSColor>, Binding> { return BindingName<Dynamic<NSColor>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.gridColor(v)) }) }
	public static var gridStyleMask: BindingName<Dynamic<NSTableView.GridLineStyle>, Binding> { return BindingName<Dynamic<NSTableView.GridLineStyle>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.gridStyleMask(v)) }) }
	public static var rowSizeStyle: BindingName<Dynamic<NSTableView.RowSizeStyle>, Binding> { return BindingName<Dynamic<NSTableView.RowSizeStyle>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.rowSizeStyle(v)) }) }
	public static var allowsTypeSelect: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.allowsTypeSelect(v)) }) }
	public static var floatsGroupRows: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.floatsGroupRows(v)) }) }
	public static var columnAutoresizingStyle: BindingName<Dynamic<NSTableView.ColumnAutoresizingStyle>, Binding> { return BindingName<Dynamic<NSTableView.ColumnAutoresizingStyle>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.columnAutoresizingStyle(v)) }) }
	public static var autosaveName: BindingName<Dynamic<NSTableView.AutosaveName?>, Binding> { return BindingName<Dynamic<NSTableView.AutosaveName?>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.autosaveName(v)) }) }
	public static var autosaveTableColumns: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.autosaveTableColumns(v)) }) }
	public static var verticalMotionCanBeginDrag: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.verticalMotionCanBeginDrag(v)) }) }
	public static var draggingDestinationFeedbackStyle: BindingName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>, Binding> { return BindingName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.draggingDestinationFeedbackStyle(v)) }) }
	public static var headerView: BindingName<Dynamic<TableHeaderViewConvertible?>, Binding> { return BindingName<Dynamic<TableHeaderViewConvertible?>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.headerView(v)) }) }
	public static var cornerView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.cornerView(v)) }) }
	public static var columns: BindingName<Dynamic<[TableColumn<Binding.NodeDataType>]>, Binding> { return BindingName<Dynamic<[TableColumn<Binding.NodeDataType>]>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.columns(v)) }) }
	@available(macOS 10.12, *)
	public static var stronglyReferencesItems: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.stronglyReferencesItems(v)) }) }
	public static var outlineTableColumnIdentifier: BindingName<Dynamic<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<Dynamic<NSUserInterfaceItemIdentifier>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.outlineTableColumnIdentifier(v)) }) }
	public static var autoresizesOutlineColumn: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.autoresizesOutlineColumn(v)) }) }
	public static var indentationPerLevel: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.indentationPerLevel(v)) }) }
	public static var indentationMarkerFollowsCell: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.indentationMarkerFollowsCell(v)) }) }
	public static var autosaveExpandedItems: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.autosaveExpandedItems(v)) }) }
	public static var userInterfaceLayoutDirection: BindingName<Dynamic<NSUserInterfaceLayoutDirection>, Binding> { return BindingName<Dynamic<NSUserInterfaceLayoutDirection>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.userInterfaceLayoutDirection(v)) }) }
	public static var treeData: BindingName<Dynamic<TableRowMutation<TreeMutation<Binding.NodeDataType>>>, Binding> { return BindingName<Dynamic<TableRowMutation<TreeMutation<Binding.NodeDataType>>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.treeData(v)) }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var highlightColumn: BindingName<Signal<NSUserInterfaceItemIdentifier?>, Binding> { return BindingName<Signal<NSUserInterfaceItemIdentifier?>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.highlightColumn(v)) }) }
	public static var selectColumns: BindingName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>, Binding> { return BindingName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectColumns(v)) }) }
	public static var selectTreePaths: BindingName<Signal<(treePaths: Set<TreePath<Binding.NodeDataType>>, byExtendingSelection: Bool)>, Binding> { return BindingName<Signal<(treePaths: Set<TreePath<Binding.NodeDataType>>, byExtendingSelection: Bool)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectTreePaths(v)) }) }
	public static var deselectColumn: BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.deselectColumn(v)) }) }
	public static var deselectTreePath: BindingName<Signal<TreePath<Binding.NodeDataType>>, Binding> { return BindingName<Signal<TreePath<Binding.NodeDataType>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.deselectTreePath(v)) }) }
	public static var selectAll: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectAll(v)) }) }
	public static var deselectAll: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.deselectAll(v)) }) }
	public static var sizeLastColumnToFit: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.sizeLastColumnToFit(v)) }) }
	public static var sizeToFit: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.sizeToFit(v)) }) }
	public static var scrollTreePathToVisible: BindingName<Signal<TreePath<Binding.NodeDataType>>, Binding> { return BindingName<Signal<TreePath<Binding.NodeDataType>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.scrollTreePathToVisible(v)) }) }
	public static var scrollColumnToVisible: BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<Signal<NSUserInterfaceItemIdentifier>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.scrollColumnToVisible(v)) }) }
	public static var moveColumn: BindingName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>, Binding> { return BindingName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.moveColumn(v)) }) }
	@available(macOS 10.11, *) public static var hideRowActions: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.hideRowActions(v)) }) }
	@available(macOS 10.11, *) public static var hideRows: BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding> { return BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.hideRows(v)) }) }
	@available(macOS 10.11, *) public static var unhideRows: BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding> { return BindingName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.unhideRows(v)) }) }
	public static var expandTreePath: BindingName<Signal<(treePath: TreePath<Binding.NodeDataType>?, expandChildren: Bool)>, Binding> { return BindingName<Signal<(treePath: TreePath<Binding.NodeDataType>?, expandChildren: Bool)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.expandTreePath(v)) }) }
	public static var collapseTreePath: BindingName<Signal<(treePath: TreePath<Binding.NodeDataType>?, collapseChildren: Bool)>, Binding> { return BindingName<Signal<(treePath: TreePath<Binding.NodeDataType>?, collapseChildren: Bool)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.collapseTreePath(v)) }) }
	public static var setDropTreePath: BindingName<Signal<(treePath: TreePath<Binding.NodeDataType>?, dropChildIndex: Int)>, Binding> { return BindingName<Signal<(treePath: TreePath<Binding.NodeDataType>?, dropChildIndex: Int)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.setDropTreePath(v)) }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var action: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.action(v)) }) }
	public static var doubleAction: BindingName<TargetAction, Binding> { return BindingName<TargetAction, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.doubleAction(v)) }) }
	public static var columnResized: BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>, Binding> { return BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.columnResized(v)) }) }
	public static var columnMoved: BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>, Binding> { return BindingName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.columnMoved(v)) }) }
	public static var didDragTableColumn: BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.didDragTableColumn(v)) }) }
	public static var didClickTableColumn: BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.didClickTableColumn(v)) }) }
	public static var mouseDownInHeaderOfTableColumn: BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding> { return BindingName<SignalInput<NSUserInterfaceItemIdentifier>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.mouseDownInHeaderOfTableColumn(v)) }) }
	public static var treePathWillExpand: BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding> { return BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.treePathWillExpand(v)) }) }
	public static var treePathDidExpand: BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding> { return BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.treePathDidExpand(v)) }) }
	public static var treePathWillCollapse: BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding> { return BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.treePathWillCollapse(v)) }) }
	public static var treePathDidCollapse: BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding> { return BindingName<SignalInput<TreePath<Binding.NodeDataType>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.treePathDidCollapse(v)) }) }
	public static var sortDescriptorsDidChange: BindingName<SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>, Binding> { return BindingName<SignalInput<(new: [NSSortDescriptor], old: [NSSortDescriptor])>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.sortDescriptorsDidChange(v)) }) }
	public static var selectionChanged: BindingName<SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedTreePaths: Set<TreePath<Binding.NodeDataType>>)>, Binding> { return BindingName<SignalInput<(selectedColumns: Set<NSUserInterfaceItemIdentifier>, selectedTreePaths: Set<TreePath<Binding.NodeDataType>>)>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectionChanged(v)) }) }
	public static var selectionIsChanging: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectionIsChanging(v)) }) }
	public static var visibleTreePathsChanged: BindingName<SignalInput<Set<TreePath<Binding.NodeDataType>>>, Binding> { return BindingName<SignalInput<Set<TreePath<Binding.NodeDataType>>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.visibleTreePathsChanged(v)) }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var groupRowCellConstructor: BindingName<(Int) -> TableCellViewConvertible, Binding> { return BindingName<(Int) -> TableCellViewConvertible, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.groupRowCellConstructor(v)) }) }
	public static var rowView: BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> TableRowViewConvertible?, Binding> { return BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> TableRowViewConvertible?, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.rowView(v)) }) }
	public static var heightOfRow: BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> CGFloat, Binding> { return BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> CGFloat, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.heightOfRow(v)) }) }
	public static var shouldExpand: BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> Bool, Binding> { return BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.shouldExpand(v)) }) }
	public static var shouldCollapse: BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> Bool, Binding> { return BindingName<(_ treePath: TreePath<Binding.NodeDataType>) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.shouldCollapse(v)) }) }
	public static var typeSelectString: BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?, _ treePath: TreePath<Binding.NodeDataType>) -> String?, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?, _ treePath: TreePath<Binding.NodeDataType>) -> String?, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.typeSelectString(v)) }) }
	public static var nextTypeSelectMatch: BindingName<(_ outlineView: NSOutlineView, _ from: TreePath<Binding.NodeDataType>, _ to: TreePath<Binding.NodeDataType>, _ for: String) -> IndexPath?, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ from: TreePath<Binding.NodeDataType>, _ to: TreePath<Binding.NodeDataType>, _ for: String) -> IndexPath?, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.nextTypeSelectMatch(v)) }) }
	public static var shouldTypeSelectForEvent: BindingName<(_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ event: NSEvent, _ searchString: String?) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.shouldTypeSelectForEvent(v)) }) }
	public static var shouldSelectTableColumn: BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?) -> Bool, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn?) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.shouldSelectTableColumn(v)) }) }
	public static var shouldSelectTreePath: BindingName<(_ outlineView: NSOutlineView, _ treePath: TreePath<Binding.NodeDataType>) -> Bool, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ treePath: TreePath<Binding.NodeDataType>) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.shouldSelectTreePath(v)) }) }
	public static var selectionIndexesForProposedSelection: BindingName<(_ proposedSelectionIndexes: Set<TreePath<Binding.NodeDataType>>) -> Set<TreePath<Binding.NodeDataType>>, Binding> { return BindingName<(_ proposedSelectionIndexes: Set<TreePath<Binding.NodeDataType>>) -> Set<TreePath<Binding.NodeDataType>>, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectionIndexesForProposedSelection(v)) }) }
	public static var selectionShouldChange: BindingName<(_ outlineView: NSOutlineView) -> Bool, Binding> { return BindingName<(_ outlineView: NSOutlineView) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.selectionShouldChange(v)) }) }
	public static var shouldReorderColumn: BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn, _ newIndex: Int) -> Bool, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn, _ newIndex: Int) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.shouldReorderColumn(v)) }) }
	public static var sizeToFitWidthOfColumn: BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn) -> CGFloat, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ column: NSTableColumn) -> CGFloat, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.sizeToFitWidthOfColumn(v)) }) }
	public static var acceptDrop: BindingName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ treePath: TreePath<Binding.NodeDataType>?, _ childIndex: Int) -> Bool, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ treePath: TreePath<Binding.NodeDataType>?, _ childIndex: Int) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.acceptDrop(v)) }) }
	public static var draggingSessionEnded: BindingName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.draggingSessionEnded(v)) }) }
	public static var draggingSessionWillBegin: BindingName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [TreePath<Binding.NodeDataType>]) -> Void, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ draggingSession: NSDraggingSession, _ willBeginAt: NSPoint, _ forItems: [TreePath<Binding.NodeDataType>]) -> Void, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.draggingSessionWillBegin(v)) }) }
	public static var isTreePathExpandable: BindingName<(TreePath<Binding.NodeDataType>) -> Bool, Binding> { return BindingName<(TreePath<Binding.NodeDataType>) -> Bool, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.isTreePathExpandable(v)) }) }
	public static var indexPathForPersistentObject: BindingName<(Any) -> IndexPath?, Binding> { return BindingName<(Any) -> IndexPath?, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.indexPathForPersistentObject(v)) }) }
	public static var persistentObjectForTreePath: BindingName<(TreePath<Binding.NodeDataType>) -> Any?, Binding> { return BindingName<(TreePath<Binding.NodeDataType>) -> Any?, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.persistentObjectForTreePath(v)) }) }
	public static var pasteboardWriter: BindingName<(_ outlineView: NSOutlineView, _ forTreePath: TreePath<Binding.NodeDataType>) -> NSPasteboardWriting?, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ forTreePath: TreePath<Binding.NodeDataType>) -> NSPasteboardWriting?, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.pasteboardWriter(v)) }) }
	public static var updateDraggingItems: BindingName<(_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ forDrag: NSDraggingInfo) -> Void, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.updateDraggingItems(v)) }) }
	public static var validateDrop: BindingName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedTreePath: TreePath<Binding.NodeDataType>?, _ proposedChildIndex: Int) -> NSDragOperation, Binding> { return BindingName<(_ outlineView: NSOutlineView, _ info: NSDraggingInfo, _ proposedTreePath: TreePath<Binding.NodeDataType>?, _ proposedChildIndex: Int) -> NSDragOperation, Binding>({ v in .outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.validateDrop(v)) }) }
}

extension BindingName where Binding: OutlineViewBinding {
	// Additional helper binding names
	public static var rowAction: BindingName<SignalInput<OutlineCell<Binding.NodeDataType>?>, Binding> {
		return BindingName<SignalInput<OutlineCell<Binding.NodeDataType>?>, Binding> { (v: SignalInput<OutlineCell<Binding.NodeDataType>?>) in
			.outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.action(TargetAction.singleTarget(
				Input<Any?>().map { s in
					guard let outlineView = s as? NSOutlineView, outlineView.selectedRow >= 0, outlineView.selectedColumn >= 0 else { return nil }
					return OutlineCell<Binding.NodeDataType>(row: outlineView.selectedRow, column: outlineView.selectedColumn, outlineView: outlineView)
					}.bind(to: v)
			)))
		}
	}
	public static var rowDoubleAction: BindingName<SignalInput<OutlineCell<Binding.NodeDataType>?>, Binding> {
		return BindingName<SignalInput<OutlineCell<Binding.NodeDataType>?>, Binding> { (v: SignalInput<OutlineCell<Binding.NodeDataType>?>) in
			.outlineViewBinding(OutlineView<Binding.NodeDataType>.Binding.doubleAction(TargetAction.singleTarget(
				Input<Any?>().map { s in
					guard let outlineView = s as? NSOutlineView, outlineView.selectedRow >= 0, outlineView.selectedColumn >= 0 else { return nil }
					return OutlineCell<Binding.NodeDataType>(row: outlineView.selectedRow, column: outlineView.selectedColumn, outlineView: outlineView)
					}.bind(to: v)
			)))
		}
	}
}

public protocol OutlineViewConvertible: TableViewConvertible {
	func nsOutlineView() -> NSOutlineView
}
extension OutlineViewConvertible {
	public func nsTableView() -> NSTableView { return nsOutlineView() }
}
extension OutlineView.Instance: OutlineViewConvertible {
	public func nsOutlineView() -> NSOutlineView { return self }
}

public protocol OutlineViewBinding: ControlBinding {
	associatedtype NodeDataType
	static func outlineViewBinding(_ binding: OutlineView<NodeDataType>.Binding) -> Self
}

extension OutlineViewBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return outlineViewBinding(.inheritedBinding(binding))
	}
}

public struct OutlineCell<NodeData> {
	public let row: Int
	public let column: Int
	public let columnIdentifier: NSUserInterfaceItemIdentifier
	public let data: TreePath<NodeData>?
	
	public init(row: Int, column: Int, outlineView: NSOutlineView) {
		self.row = row
		self.data = (outlineView.delegate as? OutlineView<NodeData>.Storage)?.treePath(forRow: row, in: outlineView)
		self.column = column
		self.columnIdentifier = outlineView.tableColumns[column].identifier
	}
	
	public init(row: Int, column: NSTableColumn, outlineView: NSOutlineView) {
		self.row = row
		self.column = outlineView.column(withIdentifier: column.identifier)
		self.columnIdentifier = column.identifier
		self.data = (outlineView.delegate as? OutlineView<NodeData>.Storage)?.treePath(forRow: row, in: outlineView)
	}
}

#endif
