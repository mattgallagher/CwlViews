//
//  TableViewTests.swift
//  iOSAppTests
//
//  Created by Matt Gallagher on 19/4/19.
//  Copyright © 2019 Matt Gallagher. All rights reserved.
//

import XCTest
@testable import iOSApp

class TableViewTests: XCTestCase {
	
	var services: Services!
	var doc: DocumentAdapter!
	var navState: NavViewState!
	var tableState: TableViewState!
	
	override func setUp() {
		services = Services(fileService: MockFileService())
		doc = DocumentAdapter(document: Document(services: services))
//		navState = NavViewState()
//		tableState = TableViewState()
	}
	
	override func tearDown() {
	}
	
	func testDocSignal() {
		let y = doc.rowsSignal().capture()
		print("Capture is \(y)")
		let x = y.values
		XCTAssert(x.count == 1)
	}
	
	func testInitialTableRows() throws {
//		let viewController = tableViewController(tableState, navState, doc)
//		let bindings = try ViewController.consumeBindings(from: viewController)
//		let view = try ViewController.Binding.value(for: .view, in: bindings)
//		let tableBindings = try TableView<String>.consumeBindings(from: view)
//		let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
//		
//		XCTAssertEqual(Array(tableState.values?.first?.values ?? []), Document.initialContents().rows)
	}
}
