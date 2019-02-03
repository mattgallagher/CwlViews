//
//  DocumentAdapter.swift
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

typealias DocumentAdapter = Adapter<ModelState<Document, Document.Change, Document.Notification>>
extension Adapter where State == ModelState<Document, Document.Change, Document.Notification> {
	init(document: Document) {
		self.init(adapterState: ModelState(
			async: true,
			initial: document,
			resumer: { model -> Document.Notification? in .reload },
			reducer: { model, message, feedback -> Document.Notification? in try? model.apply(message) }
		))
	}
	
	func rowsSignal() -> Signal<ArrayMutation<String>> {
		return slice(resume: .reload) { document, notification -> Signal<ArrayMutation<String>>.Next in
			switch notification {
			case .addedRowIndex(let i): return .value(.inserted(document.rows[i], at: i))
			case .removedRowIndex(let i): return .value(.deleted(at: i))
			case .reload: return .value(.reload(document.rows))
			case .none: return .none
			}
		}
	}
}
