//
//  SearchBarView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
					.textChanged() --> searchBarViewState.search
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
		.rowSelected(\.indexPath) --> searchBarViewState.selectedRow,
		.deselectRow <-- searchBarViewState.selectedRow.animate(.always)
	)
}

private extension String {
	static let searchTimezones = NSLocalizedString("Search timezones...", comment: "")
}
