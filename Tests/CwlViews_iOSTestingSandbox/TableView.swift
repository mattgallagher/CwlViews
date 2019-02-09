//
//  TableView.swift
//  CwlViewsHarness_iOS
//
//  Created by Matt Gallagher on 2017/07/30.
//  Copyright © 2017 Matt Gallagher. All rights reserved.
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

import CwlViews
import Darwin

struct TableViewState: CodableContainer {
	let isEditing: Var<Bool>
	let firstRow: Var<IndexPath>
	let selection: TempVar<TableRow<String>>

	init() {
		isEditing = Var(false)
		firstRow = Var(IndexPath(row: 0, section: 0))
		selection = TempVar()
	}
	var childCodableContainers: [CodableContainer] { return [isEditing, firstRow] }
}

func tableViewController(_ tableState: TableViewState, _ navState: NavViewState, _ doc: DocumentAdapter) -> ViewControllerConvertible {
	return ViewController(
		.lifetimes -- [
			tableState.selection
				.compactMap { $0.data }
				.map { .detail(DetailViewState(row: $0)) }
				.cancellableBind(to: navState.navStack.push())
		],
		.navigationItem -- navItem(tableState: tableState, doc: doc),
		.view -- TableView<String>(
			.cellIdentifier -- { row in .textRowIdentifier },
			.cellConstructor -- { reuseIdentifier, cellData in
				return TableViewCell(
					.textLabel -- Label(
						.text <-- cellData.map { .localizedStringWithFormat(.rowText, $0) }
					)
				)
			},
			.tableData <-- doc.rowsSignal().tableData(),
			.didSelectRow --> tableState.selection,
			.deselectRow <-- tableState.selection
				.debounce(interval: .milliseconds(250), context: .main)
				.map { .animate($0.indexPath) },
			.isEditing <-- tableState.isEditing.animate(),
			.commit --> Input()
				.map { .removeAtIndex($0.row.indexPath.row) }
				.bind(to: doc),
			.userDidScrollToRow --> Input()
				.map { $0.indexPath }
				.bind(to: tableState.firstRow.update()),
			.scrollToRow <-- tableState.firstRow
				.map { .set(.none($0)) },
			.separatorInset -- UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		)
	)
}

func navItem(tableState: TableViewState, doc: DocumentAdapter) -> NavigationItem {
	return NavigationItem(
		.title -- .helloWorld,
		.leftBarButtonItems() <-- tableState.isEditing
			.map { e in
				[BarButtonItem(
					.barButtonSystemItem -- e ? .done : .edit,
					.action --> Input()
						.map { _ in !e }
						.bind(to: tableState.isEditing)
				)]
			},
		.rightBarButtonItems() -- [BarButtonItem(
			.barButtonSystemItem -- .add,
			.action --> Input()
				.map { _ in .add }
				.bind(to: doc)
		)]
	)
}

fileprivate extension String {
	static let textRowIdentifier = "TextRow"
	static let rowText = NSLocalizedString("This is row #%@", comment: "")
	static let helloWorld = NSLocalizedString("Hello, world!", comment: "")
}
