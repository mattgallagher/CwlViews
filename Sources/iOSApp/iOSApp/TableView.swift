//
//  TableView.swift
//  iOSApp
//
//  Created by Matt Gallagher on 19/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import UIKit

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
					.systemItem -- e ? .done : .edit,
					.action --> Input()
						.map { _ in !e }
						.bind(to: tableState.isEditing)
					)]
		},
		.rightBarButtonItems() -- [BarButtonItem(
			.systemItem -- .add,
			.action --> Input()
				.map { _ in .add }
				.bind(to: doc)
			)]
	)
}

private extension String {
	static let textRowIdentifier = "TextRow"
	static let rowText = NSLocalizedString("This is row #%@", comment: "")
	static let helloWorld = NSLocalizedString("Hello, world!", comment: "")
}
