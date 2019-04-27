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

extension TableViewBinding {
	public static func tableStructure<S: Sequence>(in bindings: S) throws -> TableSectionState<RowDataType> where S.Element == TableView<RowDataType>.Binding {
		var found: TableSectionState<RowDataType>? = nil
		for b in bindings {
			if case .tableData(let x) = b {
				if found != nil {
					throw BindingParserErrors.multipleMatchesFound
				}
				let values = x.values
				var sections = TableSectionState<RowDataType>()
				for v in values {
					v.value.apply(to: &sections)
				}
				found = sections
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
	public static var tableViewStyle: BindingParser<Constant<UITableView.Style>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .tableViewStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsMultipleSelection: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsMultipleSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsMultipleSelectionDuringEditing: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsMultipleSelectionDuringEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsSelection: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var allowsSelectionDuringEditing: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .allowsSelectionDuringEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var backgroundView: BindingParser<Dynamic<ViewConvertible?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .backgroundView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var cellLayoutMarginsFollowReadableWidth: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .cellLayoutMarginsFollowReadableWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var estimatedRowHeight: BindingParser<Dynamic<CGFloat>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .estimatedRowHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var estimatedSectionFooterHeight: BindingParser<Dynamic<CGFloat>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .estimatedSectionFooterHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var estimatedSectionHeaderHeight: BindingParser<Dynamic<CGFloat>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .estimatedSectionHeaderHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var isEditing: BindingParser<Signal<SetOrAnimate<Bool>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .isEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var remembersLastFocusedIndexPath: BindingParser<Dynamic<Bool>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .remembersLastFocusedIndexPath(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var rowHeight: BindingParser<Dynamic<CGFloat>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .rowHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sectionFooterHeight: BindingParser<Dynamic<CGFloat>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sectionFooterHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sectionHeaderHeight: BindingParser<Dynamic<CGFloat>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sectionHeaderHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sectionIndexBackgroundColor: BindingParser<Dynamic<UIColor?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sectionIndexBackgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sectionIndexColor: BindingParser<Dynamic<UIColor?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sectionIndexColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sectionIndexMinimumDisplayRowCount: BindingParser<Dynamic<Int>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sectionIndexMinimumDisplayRowCount(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sectionIndexTitles: BindingParser<Dynamic<[String]?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sectionIndexTitles(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var sectionIndexTrackingBackgroundColor: BindingParser<Dynamic<UIColor?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sectionIndexTrackingBackgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var separatorColor: BindingParser<Dynamic<UIColor?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .separatorColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var separatorEffect: BindingParser<Dynamic<UIVisualEffect?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .separatorEffect(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var separatorInset: BindingParser<Dynamic<UIEdgeInsets>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .separatorInset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var separatorInsetReference: BindingParser<Dynamic<UITableView.SeparatorInsetReference>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .separatorInsetReference(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var separatorStyle: BindingParser<Dynamic<UITableViewCell.SeparatorStyle>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .separatorStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var tableData: BindingParser<Dynamic<TableSectionAnimatable<Downcast.RowDataType>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .tableData(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var tableFooterView: BindingParser<Dynamic<ViewConvertible?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .tableFooterView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var tableHeaderView: BindingParser<Dynamic<ViewConvertible?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .tableHeaderView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var deselectRow: BindingParser<Signal<SetOrAnimate<IndexPath>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .deselectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var scrollToNearestSelectedRow: BindingParser<Signal<SetOrAnimate<UITableView.ScrollPosition>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .scrollToNearestSelectedRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var scrollToRow: BindingParser<Signal<SetOrAnimate<TableScrollPosition>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .scrollToRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var selectRow: BindingParser<Signal<SetOrAnimate<TableScrollPosition?>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	
	//	3. Action bindings are triggered by the object after construction.
	public static var selectionDidChange: BindingParser<SignalInput<[TableRow<Downcast.RowDataType>]?>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .selectionDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var userDidScrollToRow: BindingParser<SignalInput<TableRow<Downcast.RowDataType>>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .userDidScrollToRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var visibleRowsChanged: BindingParser<SignalInput<[TableRow<Downcast.RowDataType>]>, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .visibleRowsChanged(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var accessoryButtonTapped: BindingParser<(UITableView, TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .accessoryButtonTapped(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var canEditRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .canEditRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var canFocusRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .canFocusRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var canMoveRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .canMoveRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var canPerformAction: BindingParser<(_ tableView: UITableView, _ action: Selector, _ tableRowData: TableRow<Downcast.RowDataType>, _ sender: Any?) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .canPerformAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var cellConstructor: BindingParser<(_ identifier: String?, _ rowSignal: SignalMulti<Downcast.RowDataType>) -> TableViewCellConvertible, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .cellConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var cellIdentifier: BindingParser<(TableRow<Downcast.RowDataType>) -> String?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .cellIdentifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var commit: BindingParser<(UITableView, UITableViewCell.EditingStyle, TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .commit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var dataMissingCell: BindingParser<(IndexPath) -> TableViewCellConvertible, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .dataMissingCell(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didDeselectRow: BindingParser<(UITableView, TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didDeselectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didEndDisplayingCell: BindingParser<(UITableView, UITableViewCell, TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didEndDisplayingCell(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didEndDisplayingFooter: BindingParser<(UITableView, UIView, Int) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didEndDisplayingFooter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didEndDisplayingHeader: BindingParser<(UITableView, UIView, Int) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didEndDisplayingHeader(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didEndEditingRow: BindingParser<(UITableView, TableRow<Downcast.RowDataType>?) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didEndEditingRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didHightlightRow: BindingParser<(UITableView, TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didHightlightRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didSelectRow: BindingParser<(UITableView, TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didSelectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didUnhighlightRow: BindingParser<(UITableView, TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didUnhighlightRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var didUpdateFocus: BindingParser<(UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .didUpdateFocus(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var editActionsForRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> [UITableViewRowAction]?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .editActionsForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var editingStyleForRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> UITableViewCell.EditingStyle, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .editingStyleForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var estimatedHeightForFooter: BindingParser<(_ tableView: UITableView, _ section: Int) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .estimatedHeightForFooter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var estimatedHeightForHeader: BindingParser<(_ tableView: UITableView, _ section: Int) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .estimatedHeightForHeader(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var estimatedHeightForRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .estimatedHeightForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var footerHeight: BindingParser<(_ tableView: UITableView, _ section: Int) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .footerHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var footerView: BindingParser<(_ tableView: UITableView, _ section: Int, _ title: String?) -> ViewConvertible?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .footerView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var headerHeight: BindingParser<(_ tableView: UITableView, _ section: Int) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .headerHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var headerView: BindingParser<(_ tableView: UITableView, _ section: Int, _ title: String?) -> ViewConvertible?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .headerView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var heightForRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> CGFloat, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .heightForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var indentationLevelForRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Int, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .indentationLevelForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var indexPathForPreferredFocusedView: BindingParser<(UITableView) -> IndexPath, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .indexPathForPreferredFocusedView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var moveRow: BindingParser<(UITableView, TableRow<Downcast.RowDataType>, IndexPath) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .moveRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldHighlightRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldHighlightRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldIndentWhileEditingRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldIndentWhileEditingRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldShowMenuForRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldShowMenuForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var shouldUpdateFocus: BindingParser<(UITableView, UITableViewFocusUpdateContext) -> Bool, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .shouldUpdateFocus(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var targetIndexPathForMoveFromRow: BindingParser<(_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .targetIndexPathForMoveFromRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var titleForDeleteConfirmationButtonForRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> String?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .titleForDeleteConfirmationButtonForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var willBeginEditingRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .willBeginEditingRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var willDeselectRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> IndexPath?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .willDeselectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var willDisplayFooter: BindingParser<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .willDisplayFooter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var willDisplayHeader: BindingParser<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .willDisplayHeader(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var willDisplayRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>, _ cell: UITableViewCell) -> Void, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .willDisplayRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
	public static var willSelectRow: BindingParser<(_ tableView: UITableView, _ tableRowData: TableRow<Downcast.RowDataType>) -> IndexPath?, TableView<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .willSelectRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewBinding() }) }
}

#endif
