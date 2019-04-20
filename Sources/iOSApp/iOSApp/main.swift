//
//  main.swift
//  iOSApp
//
//  Created by Matt Gallagher on 19/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import UIKit

private let doc = DocumentAdapter(document: Document())
private let viewState = Var(NavViewState())

#if DEBUG
let docLog = doc.logJson(prefix: "Document changed: ")
let viewLog = viewState.logJson(prefix: "View-state changed: ")
#endif

applicationMain {
	Application(
		.window -- Window(
			.rootViewController <-- viewState.map { navState in
				navViewController(navState, doc)
			}
		),
		.didEnterBackground --> Input().map { .save }.bind(to: doc),
		.willEncodeRestorableState -- viewState.storeToArchive(),
		.didDecodeRestorableState -- viewState.loadFromArchive()
	)
}
