//
//  PageView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
					breadth: .equalTo(ratio: 0.75),
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
