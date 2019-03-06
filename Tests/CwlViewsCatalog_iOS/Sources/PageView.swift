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
	init() {
	}
}

func pageView(_ pageViewState: PageViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(.backgroundColor -- .white),
		.children -- [
			PageViewController<Pages>(
				.pageData -- Pages.allCases
			)
		],
		.childrenLayout -- { views in
			.center(
				.view(Label(.text -- CatalogViewState.CodingKeys.pageViewController.rawValue)),
				.view(PageControl(
					.numberOfPages -- Pages.allCases.count
				))
			)
		}
	)
}
