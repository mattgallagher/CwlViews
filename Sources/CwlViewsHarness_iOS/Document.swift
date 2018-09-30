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

import Foundation

struct Document: Codable {
	enum Change { case add, save, removeAtIndex(Int) }
	enum Notification {
		case addedRowIndex(Int)
		case removedRowIndex(Int)
		case reload
		case none
	}
	
	var rows: [String]
	var lastAddedIndex: Int
	
	init() {
		do {
			self = try JSONDecoder().decode(Document.self, from: Data(contentsOf: Document.saveUrl()))
		} catch {
			lastAddedIndex = 3
			rows = ["1", "2", "3"]
		}
	}
	
	static func saveUrl() throws -> URL {
		return try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(.documentFileName)
	}
	
	func save() throws {
		try JSONEncoder().encode(self).write(to: Document.saveUrl())
	}
	
	mutating func apply(_ change: Change) throws -> Notification {
		switch change {
		case .add:
			lastAddedIndex += 1
			rows.append(String(describing: lastAddedIndex))
			return .addedRowIndex(rows.count - 1)
		case .removeAtIndex(let i):
			if rows.indices.contains(i) {
				rows.remove(at: i)
				return .removedRowIndex(i)
			}
			return .none
		case .save:
			try save()
			return .none
		}
	}
}

fileprivate extension String {
	static let documentFileName = "document.json"
}
