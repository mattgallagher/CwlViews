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

public class TableView<RowData>: Binder, TableViewConvertible {
	public typealias Instance = UITableView
	public typealias Inherited = ScrollView
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiTableView() -> Instance { return instance() }

	enum Binding: TableViewBinding {
		public typealias RowDataType = RowData
		public typealias EnclosingBinder = TableView
		public static func tableViewBinding(_ binding: Binding) -> Binding { return binding }
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
		case isEditing(Signal<SetOrAnimate<Bool>>)
		case estimatedRowHeight(Dynamic<CGFloat>)
		case estimatedSectionFooterHeight(Dynamic<CGFloat>)
		case estimatedSectionHeaderHeight(Dynamic<CGFloat>)
		case remembersLastFocusedIndexPath(Dynamic<Bool>)
		case rowHeight(Dynamic<CGFloat>)
		case sectionFooterHeight(Dynamic<CGFloat>)
		case sectionHeaderHeight(Dynamic<CGFloat>)
		case sectionIndexBackgroundColor(Dynamic<UIColor?>)
		case sectionIndexColor(Dynamic<UIColor?>)
		case sectionIndexMinimumDisplayRowCount(Dynamic<Int>)
		case sectionIndexTrackingBackgroundColor(Dynamic<UIColor?>)
		case sectionIndexTitles(Dynamic<[String]?>)
		case separatorColor(Dynamic<UIColor?>)
		case separatorEffect(Dynamic<UIVisualEffect?>)
		case separatorInset(Dynamic<UIEdgeInsets>)
		case separatorStyle(Dynamic<UITableViewCell.SeparatorStyle>)
		case tableFooterView(Dynamic<ViewConvertible?>)
		case tableHeaderView(Dynamic<ViewConvertible?>)
		case tableData(Dynamic<TableData<RowData>>)
		
		//	2. Signal bindings are performed on the object after construction.
		case deselectRow(Signal<SetOrAnimate<IndexPath>>)
		case scrollToNearestSelectedRow(Signal<SetOrAnimate<UITableView.ScrollPosition>>)
		case scrollToRow(Signal<SetOrAnimate<TableScrollPosition>>)
		case selectRow(Signal<SetOrAnimate<TableScrollPosition?>>)
		
		//	3. Action bindings are triggered by the object after construction.
		case userDidScrollToRow(SignalInput<TableRow<RowData>>)
		case accessoryButtonTapped(SignalInput<TableRow<RowData>>)
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
		case visibleRowsChanged(SignalInput<[TableRow<RowData>]>)
		case commit(SignalInput<(editingStyle: UITableViewCell.EditingStyle, row: TableRow<RowData>)>)
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case cellIdentifier((TableRow<RowData>) -> String?)
		case canEditRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case canFocusRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case canMoveRow((_ tableRowData: TableRow<RowData>) -> Bool)
		case canPerformAction((_ action: Selector, _ tableRowData: TableRow<RowData>, _ sender: Any?) -> Bool)
		case cellConstructor((_ identifier: String?, _ rowSignal: SignalMulti<RowData>) -> TableViewCellConvertible)
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

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = TableView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage(cellIdentifier: cellIdentifier) }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			return subclass.init(frame: CGRect.zero, style: tableViewStyle)
		}
		
		// Actual delegate construction is handled by the scroll view preparer
		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init(delegateClass: Delegate.Type) {
			linkedPreparer = Inherited.Preparer(delegateClass: delegateClass)
		}
		var dynamicDelegate: Delegate? { return linkedPreparer.dynamicDelegate as? Delegate }
		mutating func delegate() -> Delegate { return linkedPreparer.delegate() as! Delegate }
		
		var tableViewStyle: UITableView.Style = .plain
		var rowsChangedInput: SignalInput<[TableRow<RowData>]>? = nil
		var cellIdentifier: (TableRow<RowData>) -> String? = { _ in nil }
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .cellIdentifier(let x): cellIdentifier = x
			case .tableViewStyle(let x): tableViewStyle = x.value
			case .userDidScrollToRow(let x):
				let s1 = #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:))
				let s2 = #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:))
				let s3 = #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:))
				delegate().addSelector(s1).userDidScrollToRow = x
				_ = delegate().addSelector(s2)
				_ = delegate().addSelector(s3)
			case .accessoryButtonTapped(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:)))
			case .canEditRow(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:canEditRowAt:)))
			case .canFocusRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:canFocusRowAt:)))
			case .canMoveRow(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:canMoveRowAt:)))
			case .canPerformAction(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:)))
			case .didDeselectRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didDeselectRowAt:)))
			case .didEndDisplayingFooter(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:)))
			case .didEndDisplayingHeader(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:)))
			case .didEndDisplayingRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:)))
			case .didEndEditingRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didEndEditingRowAt:)))
			case .didHightlightRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:)))
			case .commit(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:commit:forRowAt:)))
			case .didSelectRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
			case .didUnhighlightRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:)))
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
			case .moveRow(let x): delegate().addHandler(x, #selector(UITableViewDataSource.tableView(_:moveRowAt:to:)))
			case .shouldHighlightRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAt:)))
			case .shouldIndentWhileEditingRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAt:)))
			case .shouldShowMenuForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAt:)))
			case .shouldUpdateFocus(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:shouldUpdateFocusIn:)))
			case .targetIndexPathForMoveFromRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:)))
			case .titleForDeleteConfirmationButtonForRow(let x): delegate().addHandler(x, #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:)))
			case .visibleRowsChanged(let x):
				let s1 = #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))
				let s2 = #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:))
				delegate().addSelector(s1)
				delegate().addSelector(s2)
				rowsChangedInput = x
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .cellIdentifier: return nil
			case .tableViewStyle: return nil
			case .allowsMultipleSelection(let x): return x.apply(instance) { i, v in i.allowsMultipleSelection = v }
			case .allowsMultipleSelectionDuringEditing(let x): return x.apply(instance) { i, v in i.allowsMultipleSelectionDuringEditing = v }
			case .allowsSelection(let x): return x.apply(instance) { i, v in i.allowsSelection = v }
			case .allowsSelectionDuringEditing(let x): return x.apply(instance) { i, v in i.allowsSelectionDuringEditing = v }
			case .backgroundView(let x): return x.apply(instance) { i, v in i.backgroundView = v?.uiView() }
			case .cellLayoutMarginsFollowReadableWidth(let x): return x.apply(instance) { i, v in i.cellLayoutMarginsFollowReadableWidth = v }
			case .deselectRow(let x): return x.apply(instance) { i, v in i.deselectRow(at: v.value, animated: v.isAnimated) }
			case .isEditing(let x): return x.apply(instance) { i, v in i.setEditing(v.value, animated: v.isAnimated) }
			case .estimatedRowHeight(let x): return x.apply(instance) { i, v in i.estimatedRowHeight = v }
			case .estimatedSectionFooterHeight(let x): return x.apply(instance) { i, v in i.estimatedSectionFooterHeight = v }
			case .estimatedSectionHeaderHeight(let x): return x.apply(instance) { i, v in i.estimatedSectionHeaderHeight = v }
			case .remembersLastFocusedIndexPath(let x): return x.apply(instance) { i, v in i.remembersLastFocusedIndexPath = v }
			case .rowHeight(let x): return x.apply(instance) { i, v in i.rowHeight = v }
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
			case .sectionFooterHeight(let x): return x.apply(instance) { i, v in i.sectionFooterHeight = v }
			case .sectionHeaderHeight(let x): return x.apply(instance) { i, v in i.sectionHeaderHeight = v }
			case .sectionIndexBackgroundColor(let x): return x.apply(instance) { i, v in i.sectionIndexBackgroundColor = v }
			case .sectionIndexColor(let x): return x.apply(instance) { i, v in i.sectionIndexColor = v }
			case .sectionIndexMinimumDisplayRowCount(let x): return x.apply(instance) { i, v in i.sectionIndexMinimumDisplayRowCount = v }
			case .sectionIndexTrackingBackgroundColor(let x): return x.apply(instance) { i, v in i.sectionIndexTrackingBackgroundColor = v }
			case .selectRow(let x): return x.apply(instance) { i, v in i.selectRow(at: v.value?.indexPath, animated: v.isAnimated, scrollPosition: v.value?.position ?? .none) }
			case .separatorColor(let x): return x.apply(instance) { i, v in i.separatorColor = v }
			case .separatorEffect(let x): return x.apply(instance) { i, v in i.separatorEffect = v }
			case .separatorInset(let x): return x.apply(instance) { i, v in i.separatorInset = v }
			case .separatorStyle(let x): return x.apply(instance) { i, v in i.separatorStyle = v }
			case .tableFooterView(let x): return x.apply(instance) { i, v	in i.tableFooterView = v?.uiView() }
			case .tableHeaderView(let x): return x.apply(instance) { i, v in i.tableHeaderView = v?.uiView() }
			case .selectionDidChange(let x):
				return Signal.notifications(n: UITableView.selectionDidChangeNotification, object: instance).map { n -> ([TableRow<RowData>])? in
					if let tableView = n.object as? UITableView, let selection = tableView.indexPathsForSelectedRows {
						if let rows = (tableView.delegate as? Storage)?.sections.rows {
							return selection.map { TableRow<RowData>(indexPath: $0, data: rows.at($0.section)?.rows.at($0.row)) }
						} else {
							return selection.map { TableRow<RowData>(indexPath: $0, data: nil) }
						}
					} else {
						return nil
					}
				}.cancellableBind(to: x)
			case .sectionIndexTitles(let x):
				return x.apply(instance) { i, v in
					s.indexTitles = v
					i.reloadSectionIndexTitles()
				}
			case .tableData(let x):
				return x.apply(instance) { i, v in
					s.applyTableRowMutation(v, to: i)
				}
			case .cellConstructor(let x):
				storage.cellConstructor = x
				return nil
			case .dataMissingCell(let x):
				storage.dataMissingCell = x
				return nil
			case .userDidScrollToRow: return nil
			case .accessoryButtonTapped: return nil
			case .canEditRow: return nil
			case .canFocusRow: return nil
			case .canMoveRow: return nil
			case .canPerformAction: return nil
			case .didDeselectRow: return nil
			case .didEndDisplayingFooter: return nil
			case .didEndDisplayingHeader: return nil
			case .didEndDisplayingRow: return nil
			case .didEndEditingRow: return nil
			case .didHightlightRow: return nil
			case .didSelectRow: return nil
			case .commit: return nil
			case .didUnhighlightRow: return nil
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
			case .moveRow: return nil
			case .shouldHighlightRow: return nil
			case .shouldIndentWhileEditingRow: return nil
			case .shouldShowMenuForRow: return nil
			case .shouldUpdateFocus: return nil
			case .targetIndexPathForMoveFromRow: return nil
			case .titleForDeleteConfirmationButtonForRow: return nil
			case .visibleRowsChanged: return nil
			case .willBeginEditingRow: return nil
			case .willDeselectRow: return nil
			case .willDisplayFooter: return nil
			case .willDisplayHeader: return nil
			case .willDisplayRow: return nil
			case .willSelectRow: return nil
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}

		public func prepareInstance(_ instance: Instance, storage: Storage) {
			storage.rowsChangedInput = rowsChangedInput

			linkedPreparer.prepareInstance(instance, storage: storage)
			instance.dataSource = storage
		}
	}

	open class Storage: ScrollView.Preparer.Storage, UITableViewDelegate, UITableViewDataSource {
		open override var inUse: Bool { return true }
		open var sections = TableRowState<TableSectionState<RowData>>()
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
			return sections.rows.at(section)?.globalCount ?? 0
		}
		
		open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let data = sections.rows.at(indexPath.section).flatMap { s in s.rows.at(indexPath.row - s.localOffset) }
			let identifier = cellIdentifier(TableRow(indexPath: indexPath, data: data))
			
			let cellView: UITableViewCell
			let cellInput: SignalInput<RowData>?
			if let i = identifier, let reusedView = tableView.dequeueReusableCell(withIdentifier: i) {
				cellView = reusedView
				cellInput = getSignalInput(for: reusedView, valueType: RowData.self)
			} else if let cc = cellConstructor {
				let dataTuple = Signal<RowData>.channel().multicast()
				let constructed = cc(identifier, dataTuple.signal).uiTableViewCell(reuseIdentifier: identifier)
				cellView = constructed
				cellInput = dataTuple.input
				setSignalInput(for: constructed, to: dataTuple.input)
			} else {
				return dataMissingCell(indexPath).uiTableViewCell(reuseIdentifier: nil)
			}
			
			if let d = data {
				_ = cellInput?.send(value: d)
			}
			
			return cellView
		}
		
		open func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
			return sections.rows.at(titleForHeaderInSection)?.metadata.header
		}
		
		open func tableView(_ tableView: UITableView, titleForFooterInSection: Int) -> String? {
			return sections.rows.at(titleForFooterInSection)?.metadata.footer
		}
		
		open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
			return indexTitles
		}
		
		open var rowsChangedInput: SignalInput<[TableRow<RowData>]>?
		open func notifyVisibleRowsChanged(in tableView: UITableView) {
			Exec.mainAsync.invoke {
				if let input = self.rowsChangedInput {
					let indexPaths = tableView.indexPathsForVisibleRows
					if let ip = indexPaths, ip.count > 0 {
						input.send(value: ip.map { TableRow<RowData>(indexPath: $0, data: self.sections.rows.at($0.section)?.rows.at($0.row)) })
					} else {
						input.send(value: [])
					}
				}
			}
		}
		
		open func applyTableRowMutation(_ v: TableRowMutation<TableSectionMutation<RowData>>, to i: UITableView) {
			v.apply(to: &sections)
			
			switch v.arrayMutation.kind {
			case .delete:
				i.deleteSections(v.arrayMutation.indexSet.offset(by: sections.localOffset), with: v.animation)
			case .move(let destination):
				i.beginUpdates()
				for (count, index) in v.arrayMutation.indexSet.offset(by: sections.localOffset).enumerated() {
					i.moveSection(index, toSection: destination + count)
				}
				i.endUpdates()
			case .insert:
				i.insertSections(v.arrayMutation.indexSet.offset(by: sections.localOffset), with: v.animation)
			case .scroll:
				i.reloadSections(v.arrayMutation.indexSet.offset(by: sections.localOffset), with: v.animation)
			case .update:
				for (sectionIndex, change) in zip(v.arrayMutation.indexSet.offset(by: sections.localOffset), v.arrayMutation.values) {
					if change.metadata != nil {
						i.reloadSections([sectionIndex], with: v.animation)
					} else {
						let mappedIndices = change.rowMutation.arrayMutation.indexSet.map { IndexPath(row: $0, section: sectionIndex) }
						switch change.rowMutation.arrayMutation.kind {
						case .delete: i.deleteRows(at: mappedIndices, with: change.rowMutation.animation)
						case .move(let destination):
							for (count, index) in mappedIndices.enumerated() {
								i.moveRow(at: index, to: IndexPath(row: destination + count, section: sectionIndex))
							}
						case .insert: i.insertRows(at: mappedIndices, with: change.rowMutation.animation)
						case .scroll:
							i.reloadRows(at: mappedIndices, with: change.rowMutation.animation)
						case .update:
							guard let section = sections.rows.at(sectionIndex - sections.localOffset) else { continue }
							for indexPath in mappedIndices {
								guard let cell = i.cellForRow(at: indexPath), let value = section.rows.at(indexPath.row - section.rowState.localOffset) else { continue }
								getSignalInput(for: cell, valueType: RowData.self)?.send(value: value)
							}
							notifyVisibleRowsChanged(in: i)
						case .reload:
							i.reloadSections([sectionIndex], with: change.rowMutation.animation)
						}
					}
				}
			case .reload:
				i.reloadData()
			}
		}
	}

	open class Delegate: ScrollView.Delegate, UITableViewDataSource, UITableViewDelegate {
		public required init() {
			super.init()
		}
		
		open var userDidScrollToRow: SignalInput<TableRow<RowData>>?

		open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
			super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
			if !decelerate, let tableView = scrollView as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.last {
				userDidScrollToRow?.send(value: tableRowData(at: topVisibleRow, in: tableView))
			}
		}
		
		open override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
			super.scrollViewDidScrollToTop(scrollView)
			if let tableView = scrollView as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.last {
				userDidScrollToRow?.send(value: tableRowData(at: topVisibleRow, in: tableView))
			}
		}
		
		open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
			super.scrollViewDidEndDecelerating(scrollView)
			if let tableView = scrollView as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.last {
				userDidScrollToRow?.send(value: tableRowData(at: topVisibleRow, in: tableView))
			}
		}

		private func tableRowData(at indexPath: IndexPath, in tableView: UITableView) -> TableRow<RowData> {
			return TableRow<RowData>(indexPath: indexPath, data: (tableView.delegate as? Storage)?.sections.rows.at(indexPath.section)?.rows.at(indexPath.row))
		}
		
		open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return 0
		}
		open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			return UITableViewCell()
		}
		
		open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self).send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> Bool).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> Bool).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> Bool).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
			return handler(ofType: ((_ action: Selector, _ tableRowData: TableRow<RowData>, _ sender: Any?) -> Bool).self)(action, tableRowData(at: indexPath, in: tableView), sender)
		}
		
		open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self).send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
			handler(ofType: SignalInput<Int>.self).send(value: section)
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
			handler(ofType: SignalInput<Int>.self).send(value: section)
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self).send(value: tableRowData(at: indexPath, in: tableView))
			
			(tableView.delegate as? Storage)?.notifyVisibleRowsChanged(in: tableView)
		}
		
		open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
			handler(ofType: SignalInput<TableRow<RowData>?>.self).send(value: indexPath.map { tableRowData(at: $0, in: tableView) })
		}
		
		open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self).send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self).send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<TableRow<RowData>>.self).send(value: tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
			return handler(ofType: ((UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void).self)(tableView, context, coordinator)
		}
		
		open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> [UITableViewRowAction]?).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> UITableViewCell.EditingStyle).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
			return handler(ofType: ((_ section: Int) -> CGFloat).self)(section)
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
			return handler(ofType: ((_ section: Int) -> CGFloat).self)(section)
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> CGFloat).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
			return handler(ofType: ((_ section: Int) -> CGFloat).self)(section)
		}
		
		open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
			return handler(ofType: ((_ section: Int, _ title: String?) -> ViewConvertible?).self)(section, tableView.dataSource?.tableView?(tableView, titleForFooterInSection: section))?.uiView()
		}
		
		open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
			return handler(ofType: ((_ section: Int) -> CGFloat).self)(section)
		}
		
		open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
			return handler(ofType: ((_ section: Int, _ title: String?) -> ViewConvertible?).self)(section, tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section))?.uiView()
		}
		
		open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> CGFloat).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> Int).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
			return handler(ofType: ((UITableView) -> IndexPath).self)(tableView)
		}
		
		open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
			handler(ofType: SignalInput<(from: TableRow<RowData>, to: IndexPath)>.self).send(value: (from: tableRowData(at: sourceIndexPath, in: tableView), to: destinationIndexPath))
		}
		
		open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> Bool).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> Bool).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> Bool).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
			return handler(ofType: ((UITableView, UITableViewFocusUpdateContext) -> Bool).self)(tableView, context)
		}
		
		open func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
			return handler(ofType: ((_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath).self)(tableView, sourceIndexPath, proposedDestinationIndexPath)
		}
		
		open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
			return handler(ofType: ((_ tableRowData: TableRow<RowData>) -> String?).self)(tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
			handler(ofType: ((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Void).self)(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
			return handler(ofType: ((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> IndexPath?).self)(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
			handler(ofType: ((_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void).self)(tableView, section, view)
		}
		
		open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
			handler(ofType: ((_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void).self)(tableView, section, view)
		}
		
		open var willDisplayRow: ((_ tableView: UITableView, _ indexPath: IndexPath, _ cell: UITableViewCell) -> Void)?
		open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
			willDisplayRow?(tableView, indexPath, cell)
			(tableView.delegate as? Storage)?.notifyVisibleRowsChanged(in: tableView)
		}
		
		open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
			return handler(ofType: ((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> IndexPath?).self)(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
			handler(ofType: SignalInput<(editingStyle: UITableViewCell.EditingStyle, row: TableRow<RowData>)>.self).send(value: (editingStyle, tableRowData(at: indexPath, in: tableView)))
		}
	}
}

extension BindingName where Binding: TableViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tableViewBinding(TableView.Binding.$1(v)) }) }
	public static var cellIdentifier: BindingName<(TableRow<Binding.RowDataType>) -> String?, Binding> { return BindingName<(TableRow<Binding.RowDataType>) -> String?, Binding>({ v in .tableViewBinding(TableView.Binding.cellIdentifier(v)) }) }
	public static var tableViewStyle: BindingName<Constant<UITableView.Style>, Binding> { return BindingName<Constant<UITableView.Style>, Binding>({ v in .tableViewBinding(TableView.Binding.tableViewStyle(v)) }) }
	public static var allowsMultipleSelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView.Binding.allowsMultipleSelection(v)) }) }
	public static var allowsMultipleSelectionDuringEditing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView.Binding.allowsMultipleSelectionDuringEditing(v)) }) }
	public static var allowsSelection: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView.Binding.allowsSelection(v)) }) }
	public static var allowsSelectionDuringEditing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView.Binding.allowsSelectionDuringEditing(v)) }) }
	public static var backgroundView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .tableViewBinding(TableView.Binding.backgroundView(v)) }) }
	public static var cellLayoutMarginsFollowReadableWidth: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView.Binding.cellLayoutMarginsFollowReadableWidth(v)) }) }
	public static var isEditing: BindingName<Signal<SetOrAnimate<Bool>>, Binding> { return BindingName<Signal<SetOrAnimate<Bool>>, Binding>({ v in .tableViewBinding(TableView.Binding.isEditing(v)) }) }
	public static var estimatedRowHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewBinding(TableView.Binding.estimatedRowHeight(v)) }) }
	public static var estimatedSectionFooterHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewBinding(TableView.Binding.estimatedSectionFooterHeight(v)) }) }
	public static var estimatedSectionHeaderHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewBinding(TableView.Binding.estimatedSectionHeaderHeight(v)) }) }
	public static var remembersLastFocusedIndexPath: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewBinding(TableView.Binding.remembersLastFocusedIndexPath(v)) }) }
	public static var rowHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewBinding(TableView.Binding.rowHeight(v)) }) }
	public static var sectionFooterHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewBinding(TableView.Binding.sectionFooterHeight(v)) }) }
	public static var sectionHeaderHeight: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewBinding(TableView.Binding.sectionHeaderHeight(v)) }) }
	public static var sectionIndexBackgroundColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .tableViewBinding(TableView.Binding.sectionIndexBackgroundColor(v)) }) }
	public static var sectionIndexColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .tableViewBinding(TableView.Binding.sectionIndexColor(v)) }) }
	public static var sectionIndexMinimumDisplayRowCount: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .tableViewBinding(TableView.Binding.sectionIndexMinimumDisplayRowCount(v)) }) }
	public static var sectionIndexTrackingBackgroundColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .tableViewBinding(TableView.Binding.sectionIndexTrackingBackgroundColor(v)) }) }
	public static var sectionIndexTitles: BindingName<Dynamic<[String]?>, Binding> { return BindingName<Dynamic<[String]?>, Binding>({ v in .tableViewBinding(TableView.Binding.sectionIndexTitles(v)) }) }
	public static var separatorColor: BindingName<Dynamic<UIColor?>, Binding> { return BindingName<Dynamic<UIColor?>, Binding>({ v in .tableViewBinding(TableView.Binding.separatorColor(v)) }) }
	public static var separatorEffect: BindingName<Dynamic<UIVisualEffect?>, Binding> { return BindingName<Dynamic<UIVisualEffect?>, Binding>({ v in .tableViewBinding(TableView.Binding.separatorEffect(v)) }) }
	public static var separatorInset: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .tableViewBinding(TableView.Binding.separatorInset(v)) }) }
	public static var separatorStyle: BindingName<Dynamic<UITableViewCell.SeparatorStyle>, Binding> { return BindingName<Dynamic<UITableViewCell.SeparatorStyle>, Binding>({ v in .tableViewBinding(TableView.Binding.separatorStyle(v)) }) }
	public static var tableFooterView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .tableViewBinding(TableView.Binding.tableFooterView(v)) }) }
	public static var tableHeaderView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .tableViewBinding(TableView.Binding.tableHeaderView(v)) }) }
	public static var tableData: BindingName<Dynamic<TableData<Binding.RowDataType>>, Binding> { return BindingName<Dynamic<TableData<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.tableData(v)) }) }
	public static var deselectRow: BindingName<Signal<SetOrAnimate<IndexPath>>, Binding> { return BindingName<Signal<SetOrAnimate<IndexPath>>, Binding>({ v in .tableViewBinding(TableView.Binding.deselectRow(v)) }) }
	public static var scrollToNearestSelectedRow: BindingName<Signal<SetOrAnimate<UITableView.ScrollPosition>>, Binding> { return BindingName<Signal<SetOrAnimate<UITableView.ScrollPosition>>, Binding>({ v in .tableViewBinding(TableView.Binding.scrollToNearestSelectedRow(v)) }) }
	public static var scrollToRow: BindingName<Signal<SetOrAnimate<TableScrollPosition>>, Binding> { return BindingName<Signal<SetOrAnimate<TableScrollPosition>>, Binding>({ v in .tableViewBinding(TableView.Binding.scrollToRow(v)) }) }
	public static var selectRow: BindingName<Signal<SetOrAnimate<TableScrollPosition?>>, Binding> { return BindingName<Signal<SetOrAnimate<TableScrollPosition?>>, Binding>({ v in .tableViewBinding(TableView.Binding.selectRow(v)) }) }
	public static var userDidScrollToRow: BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.userDidScrollToRow(v)) }) }
	public static var accessoryButtonTapped: BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.accessoryButtonTapped(v)) }) }
	public static var didDeselectRow: BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.didDeselectRow(v)) }) }
	public static var didEndDisplayingFooter: BindingName<SignalInput<Int>, Binding> { return BindingName<SignalInput<Int>, Binding>({ v in .tableViewBinding(TableView.Binding.didEndDisplayingFooter(v)) }) }
	public static var didEndDisplayingHeader: BindingName<SignalInput<Int>, Binding> { return BindingName<SignalInput<Int>, Binding>({ v in .tableViewBinding(TableView.Binding.didEndDisplayingHeader(v)) }) }
	public static var didEndDisplayingRow: BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.didEndDisplayingRow(v)) }) }
	public static var didEndEditingRow: BindingName<SignalInput<TableRow<Binding.RowDataType>?>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>?>, Binding>({ v in .tableViewBinding(TableView.Binding.didEndEditingRow(v)) }) }
	public static var didHightlightRow: BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.didHightlightRow(v)) }) }
	public static var didSelectRow: BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.didSelectRow(v)) }) }
	public static var didUnhighlightRow: BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding> { return BindingName<SignalInput<TableRow<Binding.RowDataType>>, Binding>({ v in .tableViewBinding(TableView.Binding.didUnhighlightRow(v)) }) }
	public static var moveRow: BindingName<SignalInput<(from: TableRow<Binding.RowDataType>, to: IndexPath)>, Binding> { return BindingName<SignalInput<(from: TableRow<Binding.RowDataType>, to: IndexPath)>, Binding>({ v in .tableViewBinding(TableView.Binding.moveRow(v)) }) }
	public static var selectionDidChange: BindingName<SignalInput<[TableRow<Binding.RowDataType>]?>, Binding> { return BindingName<SignalInput<[TableRow<Binding.RowDataType>]?>, Binding>({ v in .tableViewBinding(TableView.Binding.selectionDidChange(v)) }) }
	public static var visibleRowsChanged: BindingName<SignalInput<[TableRow<Binding.RowDataType>]>, Binding> { return BindingName<SignalInput<[TableRow<Binding.RowDataType>]>, Binding>({ v in .tableViewBinding(TableView.Binding.visibleRowsChanged(v)) }) }
	public static var commit: BindingName<SignalInput<(editingStyle: UITableViewCell.EditingStyle, row: TableRow<Binding.RowDataType>)>, Binding> { return BindingName<SignalInput<(editingStyle: UITableViewCell.EditingStyle, row: TableRow<Binding.RowDataType>)>, Binding>({ v in .tableViewBinding(TableView.Binding.commit(v)) }) }
	public static var canEditRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.canEditRow(v)) }) }
	public static var canFocusRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.canFocusRow(v)) }) }
	public static var canMoveRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.canMoveRow(v)) }) }
	public static var canPerformAction: BindingName<(_ action: Selector, _ tableRowData: TableRow<Binding.RowDataType>, _ sender: Any?) -> Bool, Binding> { return BindingName<(_ action: Selector, _ tableRowData: TableRow<Binding.RowDataType>, _ sender: Any?) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.canPerformAction(v)) }) }
	public static var cellConstructor: BindingName<(_ identifier: String?, _ rowSignal: Signal<Binding.RowDataType>) -> TableViewCellConvertible, Binding> { return BindingName<(_ identifier: String?, _ rowSignal: Signal<Binding.RowDataType>) -> TableViewCellConvertible, Binding>({ v in .tableViewBinding(TableView.Binding.cellConstructor(v)) }) }
	public static var dataMissingCell: BindingName<(IndexPath) -> TableViewCellConvertible, Binding> { return BindingName<(IndexPath) -> TableViewCellConvertible, Binding>({ v in .tableViewBinding(TableView.Binding.dataMissingCell(v)) }) }
	public static var didUpdateFocus: BindingName<(UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void, Binding> { return BindingName<(UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void, Binding>({ v in .tableViewBinding(TableView.Binding.didUpdateFocus(v)) }) }
	public static var editActionsForRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> [UITableViewRowAction]?, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> [UITableViewRowAction]?, Binding>({ v in .tableViewBinding(TableView.Binding.editActionsForRow(v)) }) }
	public static var editingStyleForRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> UITableViewCell.EditingStyle, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> UITableViewCell.EditingStyle, Binding>({ v in .tableViewBinding(TableView.Binding.editingStyleForRow(v)) }) }
	public static var estimatedHeightForFooter: BindingName<(_ section: Int) -> CGFloat, Binding> { return BindingName<(_ section: Int) -> CGFloat, Binding>({ v in .tableViewBinding(TableView.Binding.estimatedHeightForFooter(v)) }) }
	public static var estimatedHeightForHeader: BindingName<(_ section: Int) -> CGFloat, Binding> { return BindingName<(_ section: Int) -> CGFloat, Binding>({ v in .tableViewBinding(TableView.Binding.estimatedHeightForHeader(v)) }) }
	public static var estimatedHeightForRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat, Binding>({ v in .tableViewBinding(TableView.Binding.estimatedHeightForRow(v)) }) }
	public static var footerHeight: BindingName<(_ section: Int) -> CGFloat, Binding> { return BindingName<(_ section: Int) -> CGFloat, Binding>({ v in .tableViewBinding(TableView.Binding.footerHeight(v)) }) }
	public static var footerView: BindingName<(_ section: Int, _ title: String?) -> ViewConvertible?, Binding> { return BindingName<(_ section: Int, _ title: String?) -> ViewConvertible?, Binding>({ v in .tableViewBinding(TableView.Binding.footerView(v)) }) }
	public static var headerHeight: BindingName<(_ section: Int) -> CGFloat, Binding> { return BindingName<(_ section: Int) -> CGFloat, Binding>({ v in .tableViewBinding(TableView.Binding.headerHeight(v)) }) }
	public static var headerView: BindingName<(_ section: Int, _ title: String?) -> ViewConvertible?, Binding> { return BindingName<(_ section: Int, _ title: String?) -> ViewConvertible?, Binding>({ v in .tableViewBinding(TableView.Binding.headerView(v)) }) }
	public static var heightForRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat, Binding>({ v in .tableViewBinding(TableView.Binding.heightForRow(v)) }) }
	public static var indentationLevelForRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Int, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Int, Binding>({ v in .tableViewBinding(TableView.Binding.indentationLevelForRow(v)) }) }
	public static var indexPathForPreferredFocusedView: BindingName<(UITableView) -> IndexPath, Binding> { return BindingName<(UITableView) -> IndexPath, Binding>({ v in .tableViewBinding(TableView.Binding.indexPathForPreferredFocusedView(v)) }) }
	public static var shouldHighlightRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.shouldHighlightRow(v)) }) }
	public static var shouldIndentWhileEditingRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.shouldIndentWhileEditingRow(v)) }) }
	public static var shouldShowMenuForRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.shouldShowMenuForRow(v)) }) }
	public static var shouldUpdateFocus: BindingName<(UITableView, UITableViewFocusUpdateContext) -> Bool, Binding> { return BindingName<(UITableView, UITableViewFocusUpdateContext) -> Bool, Binding>({ v in .tableViewBinding(TableView.Binding.shouldUpdateFocus(v)) }) }
	public static var targetIndexPathForMoveFromRow: BindingName<(_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath, Binding> { return BindingName<(_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath, Binding>({ v in .tableViewBinding(TableView.Binding.targetIndexPathForMoveFromRow(v)) }) }
	public static var titleForDeleteConfirmationButtonForRow: BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> String?, Binding> { return BindingName<(_ tableRowData: TableRow<Binding.RowDataType>) -> String?, Binding>({ v in .tableViewBinding(TableView.Binding.titleForDeleteConfirmationButtonForRow(v)) }) }
	public static var willBeginEditingRow: BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Void, Binding> { return BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Void, Binding>({ v in .tableViewBinding(TableView.Binding.willBeginEditingRow(v)) }) }
	public static var willDeselectRow: BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?, Binding> { return BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?, Binding>({ v in .tableViewBinding(TableView.Binding.willDeselectRow(v)) }) }
	public static var willDisplayFooter: BindingName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void, Binding> { return BindingName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void, Binding>({ v in .tableViewBinding(TableView.Binding.willDisplayFooter(v)) }) }
	public static var willDisplayHeader: BindingName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void, Binding> { return BindingName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void, Binding>({ v in .tableViewBinding(TableView.Binding.willDisplayHeader(v)) }) }
	public static var willDisplayRow: BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>, _ cell: UITableViewCell) -> Void, Binding> { return BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>, _ cell: UITableViewCell) -> Void, Binding>({ v in .tableViewBinding(TableView.Binding.willDisplayRow(v)) }) }
	public static var willSelectRow: BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?, Binding> { return BindingName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?, Binding>({ v in .tableViewBinding(TableView.Binding.willSelectRow(v)) }) }
}

public protocol TableViewConvertible: ScrollViewConvertible {
	func uiTableView() -> UITableView
}
extension TableViewConvertible {
	public func uiScrollView() -> ScrollView.Instance { return uiTableView() }
}
extension TableView.Instance: TableViewConvertible {
	public func uiTableView() -> UITableView { return self }
}

public protocol TableViewBinding: ScrollViewBinding {
	associatedtype RowDataType
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> Self
}
extension TableViewBinding {
	public static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self {
		return tableViewBinding(.inheritedBinding(binding))
	}
}

public typealias TableData<RowData> = TableRowMutation<TableSectionMutation<RowData>>

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

public func updateFirstRow<RowData>(_ storage: Var<IndexPath?>) -> SignalInput<[TableRow<RowData>]> {
	return Input().map { $0.first?.indexPath }.bind(to: storage.updatingInput)
}

extension SignalInterface where OutputValue == IndexPath? {
	public func restoreFirstRow() -> Signal<SetOrAnimate<TableScrollPosition>> {
		return compactMap { $0.map { .top($0) } }.animate(.none)
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

#endif
