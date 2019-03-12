//
//  SearchBarView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SearchBarViewState: CodableContainer {
	let search: Var<String>
	let firstRow: Var<IndexPath?>
	let selectedRow: TempVar<IndexPath>
	
	init() {
		search = Var("")
		firstRow = Var(IndexPath(row: 0, section: 0))
		selectedRow = TempVar()
	}
}

func searchBarView(_ searchBarViewState: SearchBarViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.layout -- .vertical(marginEdges: .topLayout,
				.view(SearchBar(
					.placeholder -- .searchTimezones,
					.text <-- searchBarViewState.search,
					.didChange --> searchBarViewState.search
				)),
				.view(length: .fillRemaining,
					tableView(searchBarViewState)
				)
			)
		)
	)
}

fileprivate func tableView(_ searchBarViewState: SearchBarViewState) -> TableView<String> {
	return TableView<String>(
		.tableData <-- searchBarViewState.search.map { val in
			TimeZone.knownTimeZoneIdentifiers.sorted().filter { timezone in
				val.isEmpty ? true : timezone.localizedCaseInsensitiveContains(val)
			}.tableData()
		},
		.cellIdentifier -- { rowDescription in "TextRow" },
		.cellConstructor -- { reuseIdentifier, cellData in
			return TableViewCell(
				.textLabel -- Label(.text <-- cellData)
			)
		},
		.scrollToRow <-- searchBarViewState.firstRow.restoreFirstRow(),
		.userDidScrollToRow --> Input().keyPath(\.indexPath).optional().bind(to: searchBarViewState.firstRow.update()),
		.didSelectRow --> Input().keyPath(\.indexPath).bind(to: searchBarViewState.selectedRow),
		.deselectRow <-- searchBarViewState.selectedRow.animate(.always)
	)
}

private extension String {
	static let searchTimezones = NSLocalizedString("Search timezones...", comment: "")
}
