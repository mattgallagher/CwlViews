//
//  MockServices.swift
//  iOSAppTests
//
//  Created by Matt Gallagher on 21/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import Foundation
@testable import iOSApp

class MockFileService: FileService {
	enum FileError: Error {
		case notFound
	}
	static let appSupport = URL(fileURLWithPath: "/Application Support/")
	var files: [URL: Data] = [:]
	
	func applicationSupportURL() throws -> URL {
		return MockFileService.appSupport
	}
	
	func data(contentsOf url: URL) throws -> Data {
		guard let file = files[url] else { throw FileError.notFound }
		return file
	}
	
	func writeData(_ data: Data, to url: URL) throws {
		files[url] = data
	}
	
	func fileExists(at url: URL) -> Bool {
		return files[url] != nil
	}
}
