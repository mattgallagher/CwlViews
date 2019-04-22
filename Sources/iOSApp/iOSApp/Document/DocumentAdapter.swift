//
//  DocumentAdapter.swift
//  iOSApp
//
//  Created by Matt Gallagher on 19/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import UIKit

typealias DocumentAdapter = Adapter<ModelState<Document, Document.Action, Document.Change>>
extension Adapter where State == ModelState<Document, Document.Action, Document.Change> {
	init(document: Document) {
		self.init(adapterState: ModelState(
			async: true,
			initial: document,
			resumer: { model -> Document.Change? in
				.reload
			},
			reducer: { model, message, feedback -> Document.Change? in try? model.apply(message) }
		))
	}
	
	func rowsSignal() -> Signal<TableRowMutation<String>> {
		return slice(resume: .reload) { document, notification -> Signal<TableRowMutation<String>>.Next in
			switch notification {
			case .addedRowIndex(let i): return .value(.inserted(document.contents.rows[i], at: i))
			case .removedRowIndex(let i): return .value(.deleted(at: i))
			case .reload: return .value(.reload(document.contents.rows))
			case .none: return .none
			}
		}
	}
}
