//
//  PageView.swift
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

enum Pages: String, CaseIterable {
	case first, second, third, fourth
}

struct PageViewState: CodableContainer {
	let selectedPageIndex: Var<Int>
	init() {
		selectedPageIndex = Var(0)
	}
}

func pageView(_ pageViewState: PageViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(.backgroundColor -- .white),
		.children -- [
			PageViewController<Pages>(
				.transitionStyle -- .pageCurl,
				.pageData -- Pages.allCases,
				.pageChanged --> Input().map { $0.index }.bind(to: pageViewState.selectedPageIndex),
				.changeCurrentPage <-- pageViewState.selectedPageIndex.map(initialState: nil as Int?, pageAnimation),
				.constructPage -- { data in
					ViewController(
						.view -- View(
							.backgroundColor -- .darkGray,
							.layout -- .center(
								.view(
									Label(
										.text -- "\(data.rawValue)",
										.textColor -- .white
									)
								)
							)
						)
					)
				}
			)
		],
		.childrenLayout -- { views in
			.center(
				.view(
					length: .equalTo(ratio: 1.0),
					breadth: .equalTo(ratio: 0.5),
					relativity: .lengthRelativeToBreadth,
					views.first ?? View()
				),
				.view(PageControl(
					.currentPage <-- pageViewState.selectedPageIndex,
					.currentPageIndicatorTintColor -- .blue,
					.pageIndicatorTintColor -- .lightGray,
					.numberOfPages -- Pages.allCases.count,
					.action(.valueChanged, \.currentPage) --> pageViewState.selectedPageIndex
				))
			)
		}
	)
}

func pageAnimation(prev: inout Int?, next: Int) -> Animatable<Int, UIPageViewController.NavigationDirection> {
	let result: Animatable<Int, UIPageViewController.NavigationDirection>
	if let p = prev, prev != nil {
		result = .animate(next, animation: p > next ? .reverse : .forward)
	} else {
		result = .set(next)
	}
	prev = next
	return result
}
