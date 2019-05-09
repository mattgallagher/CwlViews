//
//  File.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 9/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct SegmentedViewState: CodableContainer {
    let value: Var<Bool>
    init() {
        value = Var(true)
    }
}

func segmentedControlView(_ viewState: SegmentedViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
    return ViewController(
        .navigationItem -- navigationItem,
        .view -- View(.backgroundColor -- .white,
        .layout -- .center(.view(SegmentedControl(
            .backgroundImage -- .drawn(width: 512, height: 512, drawIcon),
            .segments -- [SegmentDescriptor(title: "Hello", position: 0), SegmentDescriptor(title: "World", position: 1)])))))
}

// .drawn(width: 512, height: 512, drawIcon
//(StateAndMetrics(state: .normal, metrics: .default), .drawn(width: 512, height: 512, drawIcon))
