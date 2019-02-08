//
//  main.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 4/1/19.
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

struct Services {}
struct Document {}
extension Adapter where State == ModelState<Document, Void, Void> {
	init(document: Document) {
		self.init(adapterState: ModelState(initial: document, resumer: { _ in nil }, reducer: { _, _, _ in nil }))
	}
}
typealias DocumentAdapter = Adapter<ModelState<Document, Void, Void>>

private let services = Services()
private let doc = DocumentAdapter(document: Document())
private let viewVar = Var<SplitViewState>(SplitViewState())

applicationMain {
	Application(
		.window -- Window(
			.rootViewController <-- viewVar.map { viewState in splitViewController(viewState, doc, services) }
		)
	)
}
