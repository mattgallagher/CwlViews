//
//  CwlTableView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/27.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class TableView<RowData>: Binder, TableViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableView {
	enum Binding: TableViewBinding {
		public typealias RowDataType = RowData
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case tableViewStyle(Constant<UITableView.Style>)

		//	1. Value bindings may be applied at construction and may subsequently change.
		case allowsMultipleSelection(Dynamic<Bool>)
		case allowsMultipleSelectionDuringEditing(Dynamic<Bool>)
		case allowsSelection(Dynamic<Bool>)
		case allowsSelectionDuringEditing(Dynamic<Bool>)
		case backgroundView(Dynamic<ViewConvertible?>)
		case cellLayoutMarginsFollowReadableWidth(Dynamic<Bool>)
		case estimatedRowHeight(Dynamic<CGFloat>)
		case estimatedSectionFooterHeight(Dynamic<CGFloat>)
		case estimatedSectionHeaderHeight(Dynamic<CGFloat>)
		case isEditing(Signal<SetOrAnimate<Bool>>)
		case remembersLastFocusedIndexPath(Dynamic<Bool>)
		case rowHeight(Dynamic<CGFloat>)
		case sectionFooterHeight(Dynamic<CGFloat>)
		case sectionHeaderHeight(Dynamic<CGFloat>)
		case sectionIndexBackgroundColor(Dynamic<UIColor?>)
		case sectionIndexColor(Dynamic<UIColor?>)
		case sectionIndexMinimumDisplayRowCount(Dynamic<Int>)
		case sectionIndexTitles(Dynamic<[String]?>)
		case sectionIndexTrackingBackgroundColor(Dynamic<UIColor?>)
		case separatorColor(Dynamic<UIColor?>)
		case separatorEffect(Dynamic<UIVisualEffect?>)
		case separatorInset(Dynamic<UIEdgeInsets>)
		case separatorInsetReference(Dynamic<UITableView.SeparatorInsetReference>)
		case separatorStyle(Dynamic<UITableViewCell.SeparatorStyle>)
		case tableData(Dynamic<TableSectionAnimatable<RowData>>)
		case tableFooterView(Dynamic<ViewConvertible?>)
		case tableHeaderView(Dynamic<ViewConvertible?>)
		
		//	2. Signal bindings are performed on the object after construction.
		case deselectRow(Signal<SetOrAnimate<IndexPath>>)
		case scrollToNearestSelectedRow(Signal<SetOrAnimate<UITableView.ScrollPosition>>)
		case scrollToRow(Signal<SetOrAnimate<TableScrollPosition>>)
		case selectRow(Signal<SetOrAnimate<TableScrollPosition?>>)
		
		//	3. Action bindings are triggered by the object after construction.
		case accessoryButtonTapped(SignalInput<TableRow<RowData>>)
		case commit(SignalInput<(editingStyle: UITableViewCell.EditingStyle, row: TableRow<RowData>)>)
		case didDeselectRow(SignalInput<TableRow<RowData>>)
		case didEndDisplayingFooter(SignalInput<Int>)
		case didEndDisplayingHeader(SignalInput<Int>)
		case didEndDisplayingRow(SignalInput<TableRow<RowData>>)
		case didEndEditingRow(SignalInput<TableRow<RowData>?>)
		case didHightlightRow(SignalInput<TableRow<RowData>>)
		case didSelectRow(SignalInput<TableRow<RowData>>)
		case didUnhighlightRow(SignalInput<TableRow<RowData>>)
		case moveRow(SignalInput<(from: TableRow<RowData>, to: IndexPath)>)
		case selectionDidChange(SignalInput<[TableRow<RowData>]?>)
		case userDidScrollToRow(SignalInput<TableRow<RowData>>)
		case visibleRowsChanged(SignalInput<[TableRow<RowData>]>)
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case canEditRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case canFocusRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case canMoveRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case canPerformAction((_ action: Selector, _ tableRowData: TableRow<RowData>, _ sender: Any?) -> Bool)
		case cellConstructor((_ identifier: String?, _ rowSignal: SignalMulti<RowData>) -> TableViewCellConvertible)
		case cellIdentifier((TableRow<RowData>) -> String?)
		case dataMissingCell((IndexPath) -> TableViewCellConvertible)
		case didUpdateFocus((UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void)
		case editActionsForRow((_ tableRowData: TableRow<RowData>) -> [UITableViewRowAction]?)
		case editingStyleForRow((_ tableRowData: TableRow<RowData>) -> UITableViewCell.EditingStyle)
		case estimatedHeightForFooter((_ section: Int) -> CGFloat)
		case estimatedHeightForHeader((_ section: Int) -> CGFloat)
		case estimatedHeightForRow((_ tableRowData: TableRow<RowData>) -> CGFloat)
		case footerHeight((_ section: Int) -> CGFloat)
		case footerView((_ section: Int, _ title: String?) -> ViewConvertible?)
		case headerHeight((_ section: Int) -> CGFloat)
		case headerView((_ section: Int, _ title: String?) -> ViewConvertible?)
		case heightForRow((_ tableRowData: TableRow<RowData>) -> CGFloat)
		case indentationLevelForRow((_ tableRowData: TableRow<RowData>) -> Int)
		case indexPathForPreferredFocusedView((UITableView) -> IndexPath)
		case shouldHighlightRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case shouldIndentWhileEditingRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case shouldShowMenuForRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case shouldUpdateFocus((UITableView, UITableViewFocusUpdateContext) -> Bool)
		case targetIndexPathForMoveFromRow((_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath)
		case titleForDeleteConfirmationButtonForRow((_ tableRowData: TableRow<RowData>) -> String?)
		case willBeginEditingRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Void)
		case willDeselectRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> IndexPath?)
		case willDisplayFooter((_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void)
		case willDisplayHeader((_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void)
		case willDisplayRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>, _ cell: UITableViewCell) -> Void)
		case willSelectRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> IndexPath?)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TableView.Binding
		public typealias Inherited = ScrollView.Preparer
		public typealias Instance = UITableView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage(cellIdentifier: cellIdentifier) }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		var cellIdentifier: (TableRow<RowData>) -> String? = { _ in nil }
		var rowsChangedInput: SignalInput<[TableRow<RowData>]>? = nil
		var tableViewStyle: UITableView.Style = .plain
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableView.Preparer {
	var delegateIsRequired: Bool { return true }
	
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		return type.init(frame: CGRect.zero, style: tableViewStyle)
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .tableViewStyle(let x): tableViewStyle = x.value
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		case .accessoryButtonTapped(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:)))
		case .commit(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:commit:forRowAt:)))
		case .didDeselectRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didDeselectRowAt:)))
		case .didEndDisplayingFooter(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:)))
		case .didEndDisplayingHeader(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:)))
		case .didEndDisplayingRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:)))
		case .didEndEditingRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndEditingRowAt:)))
		case .didHightlightRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:)))
		case .didSelectRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
		case .didUnhighlightRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:)))
		case .moveRow(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:moveRowAt:to:)))
		case .userDidScrollToRow(let x):
			delegate().userDidScrollToRow = x
			delegate().ensureHandler(for: #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:)))
			delegate().ensureHandler(for: #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
			delegate().ensureHandler(for: #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))
		case .visibleRowsChanged(let x):
			rowsChangedInput = x
			delegate().ensureHandler(for: #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:)))
			delegate().ensureHandler(for: #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:)))
			
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .canEditRow(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:canEditRowAt:)))
		case .canFocusRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:canFocusRowAt:)))
		case .canMoveRow(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:canMoveRowAt:)))
		case .canPerformAction(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:)))
		case .cellIdentifier(let x): cellIdentifier = x
		case .didUpdateFocus(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didUpdateFocusIn:with:)))
		case .editActionsForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:editActionsForRowAt:)))
		case .editingStyleForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:editingStyleForRowAt:)))
		case .estimatedHeightForFooter(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:)))
		case .estimatedHeightForHeader(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:)))
		case .estimatedHeightForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAt:)))
		case .footerHeight(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:)))
		case .footerView(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:)))
		case .headerHeight(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:)))
		case .headerView(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:)))
		case .heightForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:heightForRowAt:)))
		case .indentationLevelForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:indentationLevelForRowAt:)))
		case .indexPathForPreferredFocusedView(let x): delegate().addHandler(x, #selector(UITableViewDelegate.indexPathForPreferredFocusedView(in:)))
		case .shouldHighlightRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAt:)))
		case .shouldIndentWhileEditingRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAt:)))
		case .shouldShowMenuForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAt:)))
		case .shouldUpdateFocus(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldUpdateFocusIn:)))
		case .targetIndexPathForMoveFromRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:)))
		case .titleForDeleteConfirmationButtonForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:)))
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		storage.rowsChangedInput = rowsChangedInput
		
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)
		
		instance.dataSource = storage
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .tableViewStyle: return nil
		
		case .allowsMultipleSelection(let x): return x.apply(instance) { i, v in i.allowsMultipleSelection = v }
		case .allowsMultipleSelectionDuringEditing(let x): return x.apply(instance) { i, v in i.allowsMultipleSelectionDuringEditing = v }
		case .allowsSelection(let x): return x.apply(instance) { i, v in i.allowsSelection = v }
		case .allowsSelectionDuringEditing(let x): return x.apply(instance) { i, v in i.allowsSelectionDuringEditing = v }
		case .backgroundView(let x): return x.apply(instance) { i, v in i.backgroundView = v?.uiView() }
		case .cellLayoutMarginsFollowReadableWidth(let x): return x.apply(instance) { i, v in i.cellLayoutMarginsFollowReadableWidth = v }
		case .isEditing(let x): return x.apply(instance) { i, v in i.setEditing(v.value, animated: v.isAnimated) }
		case .estimatedRowHeight(let x): return x.apply(instance) { i, v in i.estimatedRowHeight = v }
		case .estimatedSectionFooterHeight(let x): return x.apply(instance) { i, v in i.estimatedSectionFooterHeight = v }
		case .estimatedSectionHeaderHeight(let x): return x.apply(instance) { i, v in i.estimatedSectionHeaderHeight = v }
		case .remembersLastFocusedIndexPath(let x): return x.apply(instance) { i, v in i.remembersLastFocusedIndexPath = v }
		case .rowHeight(let x): return x.apply(instance) { i, v in i.rowHeight = v }
		case .sectionFooterHeight(let x): return x.apply(instance) { i, v in i.sectionFooterHeight = v }
		case .sectionHeaderHeight(let x): return x.apply(instance) { i, v in i.sectionHeaderHeight = v }
		case .sectionIndexBackgroundColor(let x): return x.apply(instance) { i, v in i.sectionIndexBackgroundColor = v }
		case .sectionIndexColor(let x): return x.apply(instance) { i, v in i.sectionIndexColor = v }
		case .sectionIndexMinimumDisplayRowCount(let x): return x.apply(instance) { i, v in i.sectionIndexMinimumDisplayRowCount = v }
		case .sectionIndexTrackingBackgroundColor(let x): return x.apply(instance) { i, v in i.sectionIndexTrackingBackgroundColor = v }
		case .separatorColor(let x): return x.apply(instance) { i, v in i.separatorColor = v }
		case .separatorEffect(let x): return x.apply(instance) { i, v in i.separatorEffect = v }
		case .separatorInset(let x): return x.apply(instance) { i, v in i.separatorInset = v }
		case .separatorInsetReference(let x): return x.apply(instance) { i, v in i.separatorInsetReference = v }
		case .separatorStyle(let x): return x.apply(instance) { i, v in i.separatorStyle = v }
		case .tableFooterView(let x): return x.apply(instance) { i, v	in i.tableFooterView = v?.uiView() }
		case .tableHeaderView(let x): return x.apply(instance) { i, v in i.tableHeaderView = v?.uiView() }
		
		//	2. Signal bindings are performed on the object after construction.
		case .deselectRow(let x): return x.apply(instance) { i, v in i.deselectRow(at: v.value, animated: v.isAnimated) }
		case .scrollToNearestSelectedRow(let x): return x.apply(instance) { i, v in i.scrollToNearestSelectedRow(at: v.value, animated: v.isAnimated) }
		case .scrollToRow(let x):
			// You can't scroll a table view until *after* the number of sections and rows has been read from the data source.
			// This occurs on didAddToWindow but the easiest way to track it is by waiting for the contentSize to be set (which is set for the first time immediately after the row count is read). This makes assumptions about internal logic of UITableView – if this logic changes in future, scrolls set on load might be lost (not a catastrophic problem).
			// Capture the scroll signal to stall it
			let capture = x.capture()
			
			// Create a signal pair that will join the capture to the destination *after* the first `contentSize` change is observed
			let pair = Signal<SetOrAnimate<TableScrollPosition>>.create()
			var kvo: NSKeyValueObservation? = instance.observe(\.contentSize) { (i, change) in
				_ = try? capture.bind(to: pair.input, resend: true)
			}
			
			// Use the output of the pair to apply the effects as normal
			return pair.signal.apply(instance) { i, v in
				// Remove the key value observing after the first value is received.
				if let k = kvo {
					k.invalidate()
					kvo = nil
				}
				
				// Clamp to the number of actual sections and rows
				var indexPath = v.value.indexPath
				if indexPath.section >= i.numberOfSections {
					indexPath.section = i.numberOfSections - 1
				}
				if indexPath.section < 0 {
					return
				}
				if indexPath.row >= i.numberOfRows(inSection: indexPath.section) {
					indexPath.row = i.numberOfRows(inSection: indexPath.section) - 1
				}
				if indexPath.row < 0 {
					return
				}
				
				// Finally, perform the scroll
				i.scrollToRow(at: indexPath, at: v.value.position, animated: v.isAnimated)
			}
		case .selectRow(let x):
			return x.apply(instance) { i, v in
				i.selectRow(at: v.value?.indexPath, animated: v.isAnimated, scrollPosition: v.value?.position ?? .none)
			}
			
		//	3. Action bindings are triggered by the object after construction.
		case .accessoryButtonTapped: return nil
		case .commit: return nil
		case .didDeselectRow: return nil
		case .didEndDisplayingFooter: return nil
		case .didEndDisplayingHeader: return nil
		case .didEndDisplayingRow: return nil
		case .didEndEditingRow: return nil
		case .didHightlightRow: return nil
		case .didSelectRow: return nil
		case .didUnhighlightRow: return nil
		case .moveRow: return nil
		case .selectionDidChange(let x):
			return Signal.notifications(name: UITableView.selectionDidChangeNotification, object: instance).map { n -> ([TableRow<RowData>])? in
				if let tableView = n.object as? UITableView, let selection = tableView.indexPathsForSelectedRows {
					if let sections = (tableView.delegate as? Storage)?.sections.values {
						return selection.compactMap { indexPath in
							return TableRow<RowData>(indexPath: indexPath, data: sections.at(indexPath.section)?.values?.at(indexPath.row))
						}
					} else {
						return selection.map { indexPath in TableRow<RowData>(indexPath: indexPath, data: nil) }
					}
				} else {
					return nil
				}
			}.cancellableBind(to: x)
		case .userDidScrollToRow: return nil
		case .visibleRowsChanged: return nil
			
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .canEditRow: return nil
		case .canFocusRow: return nil
		case .canMoveRow: return nil
		case .canPerformAction: return nil
		case .cellConstructor(let x):
			storage.cellConstructor = x
			return nil
		case .cellIdentifier: return nil
		case .dataMissingCell(let x):
			storage.dataMissingCell = x
			return nil
		case .didUpdateFocus: return nil
		case .editActionsForRow: return nil
		case .editingStyleForRow: return nil
		case .estimatedHeightForFooter: return nil
		case .estimatedHeightForHeader: return nil
		case .estimatedHeightForRow: return nil
		case .footerHeight: return nil
		case .footerView: return nil
		case .headerHeight: return nil
		case .headerView: return nil
		case .heightForRow: return nil
		case .indentationLevelForRow: return nil
		case .indexPathForPreferredFocusedView: return nil
		case .sectionIndexTitles(let x):
			return x.apply(instance, storage) { i, s, v in
				s.indexTitles = v
				i.reloadSectionIndexTitles()
			}
		case .shouldHighlightRow: return nil
		case .shouldIndentWhileEditingRow: return nil
		case .shouldShowMenuForRow: return nil
		case .shouldUpdateFocus: return nil
		case .tableData(let x):
			return x.apply(instance, storage) { i, s, v in
				s.applySectionMutation(v, to: i)
			}
		case .targetIndexPathForMoveFromRow: return nil
		case .titleForDeleteConfirmationButtonForRow: return nil
		case .willBeginEditingRow: return nil
		case .willDeselectRow: return nil
		case .willDisplayFooter: return nil
		case .willDisplayHeader: return nil
		case .willDisplayRow: return nil
		case .willSelectRow: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableView.Preparer {
	open class Storage: ScrollView.Preparer.Storage, UITableViewDelegate, UITableViewDataSource {
		open override var isInUse: Bool { return true }
		
		open var sections = TableSectionState<RowData>()
		open var indexTitles: [String]? = nil
		open var scrollJunction: (SignalCapture<SetOrAnimate<(IndexPath, UITableView.ScrollPosition)>>, SignalInput<SetOrAnimate<(IndexPath, UITableView.ScrollPosition)>>)? = nil
		open var cellIdentifier: (TableRow<RowData>) -> String?
		open var cellConstructor: ((_ identifier: String?, _ rowSignal: SignalMulti<RowData>) -> TableViewCellConvertible)?
		open var dataMissingCell: (IndexPath) -> TableViewCellConvertible = { _ in return TableViewCell() }
		
		public init(cellIdentifier: @escaping (TableRow<RowData>) -> String?) {
			self.cellIdentifier = cellIdentifier
			super.init()
		}
		
		open func numberOfSections(in tableView: UITableView) -> Int {
			return sections.globalCount
		}
		
		open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return sections.values?.at(section)?.globalCount ?? 0
		}
		
		open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let data = sections.values?.at(indexPath.section).flatMap { section in section.values?.at(indexPath.row - section.localOffset) }
			let identifier = cellIdentifier(TableRow(indexPath: indexPath, data: data))
			
			let cellView: UITableViewCell
			let cellInput: SignalInput<RowData>?
			if let i = identifier, let reusedView = tableView.dequeueReusableCell(withIdentifier: i) {
				cellView = reusedView
				cellInput = reusedView.associatedRowInput(valueType: RowData.self)
			} else if let cc = cellConstructor {
				let dataTuple = Signal<RowData>.channel().multicast()
				let constructed = cc(identifier, dataTuple.signal).uiTableViewCell(reuseIdentifier: identifier)
				cellView = constructed
				cellInput = dataTuple.input
				constructed.setAssociatedRowInput(to: dataTuple.input)
			} else {
				return dataMissingCell(indexPath).uiTableViewCell(reuseIdentifier: nil)
			}
			
			if let d = data {
				_ = cellInput?.send(value: d)
			}
			
			return cellView
		}
		
		open func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
			return sections.values?.at(titleForHeaderInSection)?.leaf?.header
		}
		
		open func tableView(_ tableView: UITableView, titleForFooterInSection: Int) -> String? {
			return sections.values?.at(titleForFooterInSection)?.leaf?.footer
		}
		
		open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
			return indexTitles
		}
		
		open var rowsChangedInput: SignalInput<[TableRow<RowData>]>?
		open func notifyVisibleRowsChanged(in tableView: UITableView) {
			Exec.mainAsync.invoke {
				if let input = self.rowsChangedInput {
					if let indexPaths = tableView.indexPathsForVisibleRows, indexPaths.count > 0 {
						input.send(value: indexPaths.map { indexPath in TableRow<RowData>(indexPath: indexPath, data: self.sections.values?.at(indexPath.section)?.values?.at(indexPath.row)) })
					} else {
						input.send(value: [])
					}
				}
			}
		}
		
		open func applySectionMutation(_ sectionAnimatable: TableSectionAnimatable<RowData>, to i: UITableView) {
			let sectionMutation = sectionAnimatable.value
			guard !sectionMutation.hasNoEffectOnValues else { return }

			if case .update = sectionMutation.kind {
				for (mutationIndex, rowIndex) in sectionMutation.indexSet.enumerated() {
					sectionMutation.values[mutationIndex].apply(toSubrange: &sections.values![rowIndex])
				}
			} else {
				sectionMutation.mapValues { rowMutation -> TableRowState<RowData> in
					var rowState = TableRowState<RowData>()
					rowMutation.apply(toSubrange: &rowState)
					return rowState
				}.apply(toSubrange: &sections)
			}
			
			let animation = sectionAnimatable.animation ?? .none
			switch sectionMutation.kind {
			case .delete:
				i.deleteSections(sectionMutation.indexSet.offset(by: sections.localOffset), with: animation)
			case .move(let destination):
				i.performBatchUpdates({
					for (count, index) in sectionMutation.indexSet.offset(by: sections.localOffset).enumerated() {
						i.moveSection(index, toSection: destination + count)
					}
				}, completion: nil)
			case .insert:
				i.insertSections(sectionMutation.indexSet.offset(by: sections.localOffset), with: animation)
			case .scroll:
				i.reloadSections(sectionMutation.indexSet.offset(by: sections.localOffset), with: animation)
			case .update:
				i.performBatchUpdates({
					for (sectionIndex, change) in zip(sectionMutation.indexSet.offset(by: sections.localOffset), sectionMutation.values) {
						if change.metadata?.leaf != nil {
							i.reloadSections([sectionIndex], with: animation)
						} else {
							let mappedIndices = change.indexSet.map { rowIndex in IndexPath(row: rowIndex, section: sectionIndex) }
							switch change.kind {
							case .delete: i.deleteRows(at: mappedIndices, with: animation)
							case .move(let destination):
								for (count, index) in mappedIndices.enumerated() {
									i.moveRow(at: index, to: IndexPath(row: destination + count, section: sectionIndex))
								}
							case .insert: i.insertRows(at: mappedIndices, with: animation)
							case .scroll:
								i.reloadRows(at: mappedIndices, with: animation)
							case .update:
								guard let section = sections.values?.at(sectionIndex - sections.localOffset) else { continue }
								for indexPath in mappedIndices {
									guard let cell = i.cellForRow(at: indexPath), let value = section.values?.at(indexPath.row - sections.localOffset) else { continue }
									cell.associatedRowInput(valueType: RowData.self)?.send(value: value)
								}
								notifyVisibleRowsChanged(in: i)
							case .reload:
								i.reloadSections([sectionIndex], with: animation)
							}
						}
					}
				}, completion: nil)
			case .reload:
				i.reloadData()
			}
		}
	}

	open class Delegate: ScrollView.Preparer.Delegate, UITableViewDataSource, UITableViewDelegate {
		open var userDidScrollToRow: SignalInput<TableRow<RowData>>?

		open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
			super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
			guard !decelerate, let tableView = scrollView as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.last else { return }
			userDidScrollToRow?.send(value: tableRowData(at: topVisibleRow, in: tableView))
		}
		
		open override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
			super.scrollViewDidScrollToTop(scrollView)
			guard let tableView = scrollView as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.last else { return }
				userDidScrollToRow?.send(value: tableRowData(at: topVisibleRow, in: tableView))
		}
		
		open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
			super.scrollViewDidEndDecelerating(scrollView)
			guard let tableView = scrollView as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.last else { return }
			userDidScrollToRow?.send(value: tableRowData(at: topVisibleRow, in: tableView))
		}

		private func tableRowData(at indexPath: IndexPath, in tableView: UITableView) -> TableRow<RowData> {
			return TableRow<RowData>(indexPath: indexPath, data: (tableView.delegate as? Storage)?.sections.values?.at(indexPath.section)?.values?.at(indexPath.row))
		}
		
		open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			// This is a required method of UITableViewDataSource but is implemented by the storage
			return 0
		}
		
		open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			// This is a required method of UITableViewDelegate but is implemented by the storage
			return UITableViewCell()
		}
		
		open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self)!.send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((TableRow<RowData>) -> Bool).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((TableRow<RowData>) -> Bool).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((TableRow<RowData>) -> Bool).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
			return handler(ofType: ((Selector, TableRow<RowData>, Any?) -> Bool).self)!(action, tableRowData(at: indexPath, in: tableView), sender)
		}
		
		open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self)!.send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
			handler(ofType: SignalInput<Int>.self)!.send(value: section)
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
			handler(ofType: SignalInput<Int>.self)!.send(value: section)
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self)!.send(value: tableRowData(at: indexPath, in: tableView))
			(tableView.delegate as? Storage)?.notifyVisibleRowsChanged(in: tableView)
		}
		
		open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
			handler(ofType: SignalInput<TableRow<RowData>?>.self)!.send(value: indexPath.map { tableRowData(at: $0, in: tableView) })
		}
		
		open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self)!.send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self)!.send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self)!.send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
			return handler(ofType: ((UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void).self)!(tableView, context, coordinator)
		}
		
		open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
			return handler(ofType: ((TableRow<RowData>) -> [UITableViewRowAction]?).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
			return handler(ofType: ((TableRow<RowData>) -> UITableViewCell.EditingStyle).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
			return handler(ofType: ((Int) -> CGFloat).self)!(section)
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
			return handler(ofType: ((Int) -> CGFloat).self)!(section)
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
			return handler(ofType: ((TableRow<RowData>) -> CGFloat).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
			return handler(ofType: ((Int) -> CGFloat).self)!(section)
		}
		
		open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
			return handler(ofType: ((Int, String?) -> ViewConvertible?).self)!(section, tableView.dataSource?.tableView?(tableView, titleForFooterInSection: section))?.uiView()
		}
		
		open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
			return handler(ofType: ((Int) -> CGFloat).self)!(section)
		}
		
		open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
			return handler(ofType: ((Int, String?) -> ViewConvertible?).self)!(section, tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section))?.uiView()
		}
		
		open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
			return handler(ofType: ((TableRow<RowData>) -> CGFloat).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
			return handler(ofType: ((TableRow<RowData>) -> Int).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
			return handler(ofType: ((UITableView) -> IndexPath).self)!(tableView)
		}
		
		open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
			handler(ofType: SignalInput<(from: TableRow<RowData>, to: IndexPath)>.self)!.send(value: (from: tableRowData(at: sourceIndexPath, in: tableView), to: destinationIndexPath))
		}
		
		open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((TableRow<RowData>) -> Bool).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((TableRow<RowData>) -> Bool).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((TableRow<RowData>) -> Bool).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
			return handler(ofType: ((UITableView, UITableViewFocusUpdateContext) -> Bool).self)!(tableView, context)
		}
		
		open func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
			return handler(ofType: ((UITableView, IndexPath, IndexPath) -> IndexPath).self)!(tableView, sourceIndexPath, proposedDestinationIndexPath)
		}
		
		open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
			return handler(ofType: ((TableRow<RowData>) -> String?).self)!(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
			handler(ofType: ((UITableView, TableRow<RowData>) -> Void).self)!(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
			return handler(ofType: ((UITableView, TableRow<RowData>) -> IndexPath?).self)!(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
			handler(ofType: ((UITableView, Int, UIView) -> Void).self)!(tableView, section, view)
		}
		
		open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
			handler(ofType: ((UITableView, Int, UIView) -> Void).self)!(tableView, section, view)
		}
		
		open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
			handler(ofType: ((UITableView, IndexPath, UITableViewCell) -> Void).self)?(tableView, indexPath, cell)
			(tableView.delegate as? Storage)?.notifyVisibleRowsChanged(in: tableView)
		}
		
		open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
			return handler(ofType: ((UITableView, TableRow<RowData>) -> IndexPath?).self)!(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<(editingStyle: UITableViewCell.EditingStyle, row: TableRow<RowData>)>.self)!.send(value: (editingStyle, tableRowData(at: indexPath, in: tableView)))
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
public extension BindingName where Binding: TableViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var tableViewStyle: TableViewName<Constant<UITableView.Style>> { return .name(B.tableViewStyle) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var allowsMultipleSelection: TableViewName<Dynamic<Bool>> { return .name(B.allowsMultipleSelection) }
	static var allowsMultipleSelectionDuringEditing: TableViewName<Dynamic<Bool>> { return .name(B.allowsMultipleSelectionDuringEditing) }
	static var allowsSelection: TableViewName<Dynamic<Bool>> { return .name(B.allowsSelection) }
	static var allowsSelectionDuringEditing: TableViewName<Dynamic<Bool>> { return .name(B.allowsSelectionDuringEditing) }
	static var backgroundView: TableViewName<Dynamic<ViewConvertible?>> { return .name(B.backgroundView) }
	static var cellLayoutMarginsFollowReadableWidth: TableViewName<Dynamic<Bool>> { return .name(B.cellLayoutMarginsFollowReadableWidth) }
	static var estimatedRowHeight: TableViewName<Dynamic<CGFloat>> { return .name(B.estimatedRowHeight) }
	static var estimatedSectionFooterHeight: TableViewName<Dynamic<CGFloat>> { return .name(B.estimatedSectionFooterHeight) }
	static var estimatedSectionHeaderHeight: TableViewName<Dynamic<CGFloat>> { return .name(B.estimatedSectionHeaderHeight) }
	static var isEditing: TableViewName<Signal<SetOrAnimate<Bool>>> { return .name(B.isEditing) }
	static var remembersLastFocusedIndexPath: TableViewName<Dynamic<Bool>> { return .name(B.remembersLastFocusedIndexPath) }
	static var rowHeight: TableViewName<Dynamic<CGFloat>> { return .name(B.rowHeight) }
	static var sectionFooterHeight: TableViewName<Dynamic<CGFloat>> { return .name(B.sectionFooterHeight) }
	static var sectionHeaderHeight: TableViewName<Dynamic<CGFloat>> { return .name(B.sectionHeaderHeight) }
	static var sectionIndexBackgroundColor: TableViewName<Dynamic<UIColor?>> { return .name(B.sectionIndexBackgroundColor) }
	static var sectionIndexColor: TableViewName<Dynamic<UIColor?>> { return .name(B.sectionIndexColor) }
	static var sectionIndexMinimumDisplayRowCount: TableViewName<Dynamic<Int>> { return .name(B.sectionIndexMinimumDisplayRowCount) }
	static var sectionIndexTitles: TableViewName<Dynamic<[String]?>> { return .name(B.sectionIndexTitles) }
	static var sectionIndexTrackingBackgroundColor: TableViewName<Dynamic<UIColor?>> { return .name(B.sectionIndexTrackingBackgroundColor) }
	static var separatorColor: TableViewName<Dynamic<UIColor?>> { return .name(B.separatorColor) }
	static var separatorEffect: TableViewName<Dynamic<UIVisualEffect?>> { return .name(B.separatorEffect) }
	static var separatorInset: TableViewName<Dynamic<UIEdgeInsets>> { return .name(B.separatorInset) }
	static var separatorInsetReference: TableViewName<Dynamic<UITableView.SeparatorInsetReference>> { return .name(B.separatorInsetReference) }
	static var separatorStyle: TableViewName<Dynamic<UITableViewCell.SeparatorStyle>> { return .name(B.separatorStyle) }
	static var tableData: TableViewName<Dynamic<TableSectionAnimatable<Binding.RowDataType>>> { return .name(B.tableData) }
	static var tableFooterView: TableViewName<Dynamic<ViewConvertible?>> { return .name(B.tableFooterView) }
	static var tableHeaderView: TableViewName<Dynamic<ViewConvertible?>> { return .name(B.tableHeaderView) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var deselectRow: TableViewName<Signal<SetOrAnimate<IndexPath>>> { return .name(B.deselectRow) }
	static var scrollToNearestSelectedRow: TableViewName<Signal<SetOrAnimate<UITableView.ScrollPosition>>> { return .name(B.scrollToNearestSelectedRow) }
	static var scrollToRow: TableViewName<Signal<SetOrAnimate<TableScrollPosition>>> { return .name(B.scrollToRow) }
	static var selectRow: TableViewName<Signal<SetOrAnimate<TableScrollPosition?>>> { return .name(B.selectRow) }
	
	//	3. Action bindings are triggered by the object after construction.
	static var accessoryButtonTapped: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(B.accessoryButtonTapped) }
	static var commit: TableViewName<SignalInput<(editingStyle: UITableViewCell.EditingStyle, row: TableRow<Binding.RowDataType>)>> { return .name(B.commit) }
	static var didDeselectRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(B.didDeselectRow) }
	static var didEndDisplayingFooter: TableViewName<SignalInput<Int>> { return .name(B.didEndDisplayingFooter) }
	static var didEndDisplayingHeader: TableViewName<SignalInput<Int>> { return .name(B.didEndDisplayingHeader) }
	static var didEndDisplayingRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(B.didEndDisplayingRow) }
	static var didEndEditingRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>?>> { return .name(B.didEndEditingRow) }
	static var didHightlightRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(B.didHightlightRow) }
	static var didSelectRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(B.didSelectRow) }
	static var didUnhighlightRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(B.didUnhighlightRow) }
	static var moveRow: TableViewName<SignalInput<(from: TableRow<Binding.RowDataType>, to: IndexPath)>> { return .name(B.moveRow) }
	static var selectionDidChange: TableViewName<SignalInput<[TableRow<Binding.RowDataType>]?>> { return .name(B.selectionDidChange) }
	static var userDidScrollToRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(B.userDidScrollToRow) }
	static var visibleRowsChanged: TableViewName<SignalInput<[TableRow<Binding.RowDataType>]>> { return .name(B.visibleRowsChanged) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var canEditRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(B.canEditRow) }
	static var canFocusRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(B.canFocusRow) }
	static var canMoveRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(B.canMoveRow) }
	static var canPerformAction: TableViewName<(_ action: Selector, _ tableRowData: TableRow<Binding.RowDataType>, _ sender: Any?) -> Bool> { return .name(B.canPerformAction) }
	static var cellConstructor: TableViewName<(_ identifier: String?, _ rowSignal: SignalMulti<Binding.RowDataType>) -> TableViewCellConvertible> { return .name(B.cellConstructor) }
	static var cellIdentifier: TableViewName<(TableRow<Binding.RowDataType>) -> String?> { return .name(B.cellIdentifier) }
	static var dataMissingCell: TableViewName<(IndexPath) -> TableViewCellConvertible> { return .name(B.dataMissingCell) }
	static var didUpdateFocus: TableViewName<(UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void> { return .name(B.didUpdateFocus) }
	static var editActionsForRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> [UITableViewRowAction]?> { return .name(B.editActionsForRow) }
	static var editingStyleForRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> UITableViewCell.EditingStyle> { return .name(B.editingStyleForRow) }
	static var estimatedHeightForFooter: TableViewName<(_ section: Int) -> CGFloat> { return .name(B.estimatedHeightForFooter) }
	static var estimatedHeightForHeader: TableViewName<(_ section: Int) -> CGFloat> { return .name(B.estimatedHeightForHeader) }
	static var estimatedHeightForRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat> { return .name(B.estimatedHeightForRow) }
	static var footerHeight: TableViewName<(_ section: Int) -> CGFloat> { return .name(B.footerHeight) }
	static var footerView: TableViewName<(_ section: Int, _ title: String?) -> ViewConvertible?> { return .name(B.footerView) }
	static var headerHeight: TableViewName<(_ section: Int) -> CGFloat> { return .name(B.headerHeight) }
	static var headerView: TableViewName<(_ section: Int, _ title: String?) -> ViewConvertible?> { return .name(B.headerView) }
	static var heightForRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat> { return .name(B.heightForRow) }
	static var indentationLevelForRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Int> { return .name(B.indentationLevelForRow) }
	static var indexPathForPreferredFocusedView: TableViewName<(UITableView) -> IndexPath> { return .name(B.indexPathForPreferredFocusedView) }
	static var shouldHighlightRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(B.shouldHighlightRow) }
	static var shouldIndentWhileEditingRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(B.shouldIndentWhileEditingRow) }
	static var shouldShowMenuForRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(B.shouldShowMenuForRow) }
	static var shouldUpdateFocus: TableViewName<(UITableView, UITableViewFocusUpdateContext) -> Bool> { return .name(B.shouldUpdateFocus) }
	static var targetIndexPathForMoveFromRow: TableViewName<(_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath> { return .name(B.targetIndexPathForMoveFromRow) }
	static var titleForDeleteConfirmationButtonForRow: TableViewName<(_ tableRowData: TableRow<Binding.RowDataType>) -> String?> { return .name(B.titleForDeleteConfirmationButtonForRow) }
	static var willBeginEditingRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Void> { return .name(B.willBeginEditingRow) }
	static var willDeselectRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?> { return .name(B.willDeselectRow) }
	static var willDisplayFooter: TableViewName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void> { return .name(B.willDisplayFooter) }
	static var willDisplayHeader: TableViewName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void> { return .name(B.willDisplayHeader) }
	static var willDisplayRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>, _ cell: UITableViewCell) -> Void> { return .name(B.willDisplayRow) }
	static var willSelectRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?> { return .name(B.willSelectRow) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableViewConvertible: ScrollViewConvertible {
	func uiTableView() -> UITableView
}
extension TableViewConvertible {
	public func uiScrollView() -> ScrollView.Instance { return uiTableView() }
}
extension UITableView: TableViewConvertible {
	public func uiTableView() -> UITableView { return self }
}
public extension TableView {
	func uiTableView() -> UITableView { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableViewBinding: ScrollViewBinding {
	associatedtype RowDataType
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> Self
}
public extension TableViewBinding {
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self {
		return tableViewBinding(.inheritedBinding(binding))
	}
}
public extension TableView.Binding {
	typealias Preparer = TableView.Preparer
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> TableView<RowDataType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct TableSectionMetadata {
	public let header: String?
	public let footer: String?
	public init(header: String? = nil, footer: String? = nil) {
		(self.header, self.footer) = (header, footer)
	}
}

public typealias TableRowMutation<Element> = SubrangeMutation<Element, TableSectionMetadata>
public typealias TableRowAnimatable<Element> = Animatable<SubrangeMutation<Element, TableSectionMetadata>, UITableView.RowAnimation>
public typealias TableSectionMutation<Element> = SubrangeMutation<TableRowMutation<Element>, ()>
public typealias TableSectionAnimatable<Element> = Animatable<TableSectionMutation<Element>, UITableView.RowAnimation>

public typealias TableRowState<Element> = SubrangeState<Element, TableSectionMetadata>
public typealias TableSectionState<Element> = SubrangeState<TableRowState<Element>, ()>

public struct TableScrollPosition {
	public let indexPath: IndexPath
	public let position: UITableView.ScrollPosition
	public init(indexPath: IndexPath, position: UITableView.ScrollPosition = .none) {
		self.indexPath = indexPath
		self.position = position
	}
	
	public static func none(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .none)
	}
	
	public static func top(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .top)
	}
	
	public static func middle(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .middle)
	}
	
	public static func bottom(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .bottom)
	}
}

public struct TableRow<RowData> {
	public let indexPath: IndexPath
	public let data: RowData?
	
	public init(indexPath: IndexPath, data: RowData?) {
		self.indexPath = indexPath
		self.data = data
	}
}

// MARK: - Signal, adapter and array interop with table data and table rows
public extension Sequence {
	func tableData() -> TableSectionAnimatable<Element> {
		return .set(.reload([.reload(Array(self))]))
	}
}

public extension Signal {
	func tableData<RowData>(_ choice: AnimationChoice = .subsequent) -> Signal<TableSectionAnimatable<RowData>> where TableRowMutation<RowData> == OutputValue {
		return map(initialState: false) { (alreadyReceived: inout Bool, rowMutation: OutputValue) -> TableSectionAnimatable<RowData> in
			if alreadyReceived || choice == .always {
				return .animate(.updated(rowMutation, at: 0), animation: .automatic)
			} else {
				if choice == .subsequent {
					alreadyReceived = true
				}
				return .set(.reload([rowMutation]))
			}
		}
	}
}

public extension Adapter where State == VarState<IndexPath?> {
	func updateFirstRow<RowData>() -> SignalInput<[TableRow<RowData>]> {
		return Input().map { $0.first?.indexPath }.bind(to: update())
	}
}

extension SignalInterface where OutputValue == IndexPath? {
	public func restoreFirstRow() -> Signal<SetOrAnimate<TableScrollPosition>> {
		return compactMap { $0.map { .top($0) } }.animate(.never)
	}
}

#endif
