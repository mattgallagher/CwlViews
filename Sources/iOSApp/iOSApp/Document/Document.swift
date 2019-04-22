//
//  Document.swift
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

import UIKit

struct Document {
	struct Contents: Codable {
		var rows: [String]
		var lastAddedIndex: Int
	}

	let services: Services
	var contents: Contents
}

extension Document {
	enum Action {
		case add
		case save
		case removeAtIndex(Int)
	}
	enum Change {
		case addedRowIndex(Int)
		case removedRowIndex(Int)
		case reload
		case none
	}

	func save() throws {
		try services.fileService.writeData(JSONEncoder().encode(contents), to: Document.saveUrl(services: services))	
	}
	
	mutating func apply(_ change: Action) throws -> Change {
		switch change {
		case .add:
			contents.lastAddedIndex += 1
			contents.rows.append(String(describing: contents.lastAddedIndex))
			return .addedRowIndex(contents.rows.count - 1)
		case .removeAtIndex(let i):
			if contents.rows.indices.contains(i) {
				contents.rows.remove(at: i)
				return .removedRowIndex(i)
			}
			return .none
		case .save:
			try save()
			return .none
		}
	}
}

extension Document {
	
	init(services: Services) {
		self.services = services
		do {
			let url = try Document.saveUrl(services: services)
			if services.fileService.fileExists(at: url) {
				self.contents = try JSONDecoder().decode(Document.Contents.self, from: services.fileService.data(contentsOf: url))
				return
			}
		} catch {
		}
		
		self.contents = Document.initialContents()
	}
	
	static func initialContents() -> Document.Contents {
		return Document.Contents(rows: ["1", "2", "3"], lastAddedIndex: 3)
	}
	
	static func saveUrl(services: Services) throws -> URL {
		return try services.fileService.applicationSupportURL().appendingPathComponent(.documentFileName)
	}
	
}

private extension String {
	static let documentFileName = "document.json"
}
