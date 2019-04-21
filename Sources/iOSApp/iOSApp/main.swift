//
//  main.swift
//  iOSApp
//
//  Created by Matt Gallagher on 19/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import UIKit

private let doc = DocumentAdapter(document: Document())
private let viewVar = Var(NavViewState())

#if DEBUG
let docLog = doc.logJson(prefix: "Document changed: ")
let viewLog = viewVar.logJson(prefix: "View-state changed: ")
#endif

applicationMain {
	Application(
		.window -- Window(
			.rootViewController <-- viewVar.map { navState in
				navViewController(navState, doc)
			}
		),
		.didEnterBackground -- { _ in doc.input.send(Document.Change.save) },
		.willEncodeRestorableState -- viewVar.storeToArchive(),
		.didDecodeRestorableState -- viewVar.loadFromArchive()
	)
}
