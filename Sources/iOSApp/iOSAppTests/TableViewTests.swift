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
	
	var viewController: ViewControllerConvertible = ViewController()
	var bindings: [ViewController.Binding] = []
	var view: ViewConvertible = View()
	var tableBindings: [TableView<String>.Binding] = []
	
	override func setUp() {
		services = Services(fileService: MockFileService())
		doc = DocumentAdapter(document: Document(services: services))
		navState = NavViewState()
		tableState = TableViewState()

		viewController = tableViewController(tableState, navState, doc)
		bindings = try! ViewController.consumeBindings(from: viewController)
		view = try! ViewController.Binding.value(for: .view, in: bindings)
		tableBindings = try! TableView<String>.consumeBindings(from: view)
	}
	
	override func tearDown() {
	}
	
	func testInitialTableRows() throws {
		let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
		XCTAssertEqual(Array(tableState.values?.first?.values ?? []), Document.initialContents().rows)
	}
	
	func testCreateRow() throws {
		let navigationItem = try ViewController.Binding.value(for: .navigationItem, in: bindings)
		let navigationItemBindings = try NavigationItem.consumeBindings(from: navigationItem)
		let rightBarButtonItem = try NavigationItem.Binding.value(for: .rightBarButtonItems, in: navigationItemBindings).value.first!
		let rightBarButtonBindings = try BarButtonItem.consumeBindings(from: rightBarButtonItem)
		let targetAction = try BarButtonItem.Binding.argument(for: .action, in: rightBarButtonBindings)
		
		switch targetAction {
		case .singleTarget(let input): input.send(nil)
		default: fatalError()
		}
		
		let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
		XCTAssertEqual(Array(tableState.values?.first?.values ?? []), Document.initialContents().rows + ["4"])
	}
	
	func testDeleteRow() throws {
		let commit = try TableView<String>.Binding.argument(for: .commit, in: tableBindings)
		commit(UITableView(), .delete, TableRow<String>(indexPath: IndexPath(row: 0, section: 0), data: "1"))
		
		let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
		var expected = Document.initialContents().rows
		expected.remove(at: 0)
		XCTAssertEqual(Array(tableState.values?.first?.values ?? []), expected)
	}
}
