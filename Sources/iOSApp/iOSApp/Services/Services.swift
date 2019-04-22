//
//  Services.swift
//  iOSApp
//
//  Created by Matt Gallagher on 21/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import Foundation

struct Services {
	let fileService: FileService
}

protocol FileService {
	func applicationSupportURL() throws -> URL
	func data(contentsOf: URL) throws -> Data
	func writeData(_ data: Data, to: URL) throws
	func fileExists(at: URL) -> Bool
}

extension FileManager: FileService {
	func applicationSupportURL() throws -> URL {
		return try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
	}
	
	func data(contentsOf url: URL) throws -> Data {
		return try Data(contentsOf: url)
	}
	
	func writeData(_ data: Data, to url: URL) throws {
		try data.write(to: url)
	}
	
	func fileExists(at url: URL) -> Bool {
		var isDirectory: ObjCBool = false
		let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
		return exists && !isDirectory.boolValue
	}
}
