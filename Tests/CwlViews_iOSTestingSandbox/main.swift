//
//  main.swift
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

private let doc = DocumentAdapter(document: Document())
private let viewState = Var(NavViewState())

#if DEBUG
//	let docLog = doc.stateSignal.logJson(prefix: "Document changed: ")
	let viewLog = viewState.encoded().logJson(prefix: "View-state changed: ")
#endif

func application(_ viewState: Var<NavViewState>, _ doc: DocumentAdapter) -> Application {
	return Application(
		.window -- Window(
			.rootViewController <-- viewState.map { navState in
				navViewController(navState, doc)
			}
		),
		.didEnterBackground --> Input().map { .save }.bind(to: doc),
		.willEncodeRestorableState -- { $0.encodeLatest(from: viewState) },
		.didDecodeRestorableState -- { $0.decodeSend(to: viewState) }
	)
}

applicationMain { application(viewState, doc) }
