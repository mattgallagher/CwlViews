//
//  ProgressView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 14/5/19.
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
import QuartzCore

struct ProgressViewState: CodableContainer {
    init() {
    }
}

private class ProgressGenerator {
    private var displayLink: CADisplayLink!
    private var ticker: Float

    let value: Var<Float>

    init() {
        ticker = 0
        value = Var(ticker)
        displayLink = CADisplayLink(target: self, selector: #selector(tick(displayLink:)))
        displayLink.add(to: .current, forMode: .common)
        displayLink.preferredFramesPerSecond = 60
    }

    @objc func tick(displayLink: CADisplayLink) {
        ticker += 1/300 // ~ Fill up after 5 seconds
        if ticker >= 1 {
            ticker = 0
        }

        value.send(value: .notify(ticker))
    }
}

func progressView(_ viewState: ProgressViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
    return ViewController(
        .navigationItem -- navigationItem,
        .view -- View(
            .backgroundColor -- .white,
            .layout -- .center(
                length: 20,
                .view(
                    ProgressView(
                        .trackTintColor -- .green,
                        .progressImage -- .drawn(width: 10, height: 10) { $0.fillEllipse(in: $1) },
                        .progress <-- ProgressGenerator().value.map { $0 == 0 ? .set($0) : .animate($0) }
                    )
                )
            )
        )
    )
}
