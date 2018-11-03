//
//  main.swift
//  CwlViews
//
//  Created by Matt Gallagher on 1/22/17.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

import AppKit
import CwlViews

struct Document {
	struct Row {
		let stringValue: String
		let intValue: Int
		
		init(count: Int) {
			intValue = count
			stringValue = "This row was the #\(count) created row."
		}
	}
	enum Action {
		struct Result {
			let arrayMutation: ArrayMutation<Document.Row>
			let nonFatalError: Document.Error?
		}
		
		case setContents(Document)
		case createRow
		case fatalError
		case deleteRow(Int)
	}
	enum Error: Swift.Error {
		case rowIndexOutOfBounds
		case fatalError
	}
	
	var rows: [Document.Row]
	var creationCount: Int
	
	init() {
		rows = []
		creationCount = 0
	}
	
	mutating func applyAction(_ action: Document.Action) throws -> Document.Action.Result {
		switch action {
		case .setContents(let other):
			rows = other.rows
			creationCount = other.creationCount
			return Document.Action.Result(arrayMutation: ArrayMutation(reload: rows), nonFatalError: nil)
		case .createRow:
			creationCount += 1
			let value = Row(count: creationCount)
			rows.append(value)
			return Document.Action.Result(arrayMutation: ArrayMutation(insertedIndex: rows.count - 1, value: value), nonFatalError: nil)
		case .deleteRow(let index):
			if rows.indices.contains(index) {
				rows.remove(at: index)
				return Document.Action.Result(arrayMutation: ArrayMutation(deletedIndex: index), nonFatalError: nil)
			} else {
				return Document.Action.Result(arrayMutation: ArrayMutation(), nonFatalError: Document.Error.rowIndexOutOfBounds)
			}
		case .fatalError:
			throw Document.Error.fatalError
		}
	}
}

class DocumentAdapter: SignalInterface {
	let document: FilteredAdapter<Document.Action, Document, Document.Action.Result>
	
	var signal: Signal<Document.Action.Result> { return document.filteredSignal { (state: Document, output: Document.Action.Result?, next: SignalNext<Document.Action.Result>) -> Void in _ = output.map { next.send(value: $0) } } }
	
	init(loadOperation: Document.Action) {
		document = FilteredAdapter(initialState: Document()) { (document: inout Document, operation: Document.Action) throws -> Document.Action.Result? in
			// Update the `document`, returning an `ArrayMutation` of the specific rows that changed.
			return try document.applyAction(operation)
		}
	}
}

class ViewModel {
	private let doc: DocumentAdapter
	private let selectionInput: SignalInput<IndexSet>
	private let removeInput: SignalInput<Void>
	private let removeEndpoint: SignalOutput<Document.Action>
	
	let selectionOutput: SignalMulti<IndexSet>
	let (animateInput, animateOutput) = Signal<Any?>.create()
	
	init(doc: DocumentAdapter) {
		self.doc = doc
		
		// Allow tracking of the selected rows so when a remove is received, we can apply the operation to the appropriate rows
		let (si, so) = Signal<IndexSet>.create { $0.continuous(initialValue: []) }
		(self.selectionInput, self.selectionOutput) = (si, so)
		
		// When a remove instruction is received, apply it to each the selected rows
		(self.removeInput, self.removeEndpoint) = Signal<Void>.create { s -> SignalOutput<Document.Action> in
			so.sample(s).transform { (r: Result<IndexSet>, n: SignalNext<Document.Action>) in
				switch r {
				case .success(let v): v.forEach { n.send(value: .deleteRow($0)) }
				case .failure(let e): n.send(error: e)
				}
			}.subscribeValues { v in doc.document.input.send(value: v) }
		}
	}
	
	// NOTE: we're returning a `Signal`, not a `SignalMulti` because each result is a new `Signal` mapped from the `SignalMulti` on the document model.
	var rowSignal: Signal<ArrayMutation<Document.Row>> { return doc.signal.map { $0.arrayMutation } }
	var informationalErrorSignal: Signal<Error> {
		return doc.signal.compactMap {
			guard let e = $0.nonFatalError else { return nil }
			switch e {
			case .rowIndexOutOfBounds:
				let title = NSLocalizedString("Oops, that didn't work.", comment: "")
				let detail = NSLocalizedString("Unable to deleted selected row (it could not be found).", comment: "")
				let userInfo = [NSLocalizedRecoverySuggestionErrorKey: detail, NSLocalizedDescriptionKey: title]
				return NSError(domain: (e as NSError).domain, code: (e as NSError).code, userInfo: userInfo)
			default: return e
			}
		}
	}
	
	func addRow() {
		doc.document.input.send(value: .createRow)
	}
	
	func removeSelectedRows() {
		removeInput.send(value: ())
	}
	
	func selectionChanged(selectedRows: IndexSet) {
		selectionInput.send(value: selectedRows)
	}
	
	func attemptToRemoveNonExistentRow() {
		doc.document.input.send(value: .deleteRow(-1))
	}
	
	func fatalError() {
		doc.document.input.send(value: .fatalError)
	}
}

func mainWindow(model: DocumentAdapter) -> Window {
	let viewModel = ViewModel(doc: model)
	
	let window = Window(
		.contentWidth -- 800,
		.contentHeight -- 800,
		.title -- "FirstWindow",
		.frameAutosaveName -- NSWindow.FrameAutosaveName("MyWindow"),
		.frameHorizontal -- 5,
		.frameVertical -- -15,
		.errorSheet <-- viewModel.informationalErrorSignal.map { Callback($0, nil) },
		.toolbar -- Toolbar(
			identifier: NSToolbar.Identifier("toolbar"),
			.displayMode -- .iconAndLabel,
			.sizeMode -- .small,
			.itemDescriptions -- [
				ToolbarItemDescription(identifier: NSToolbarItem.Identifier(rawValue: "softError")) { identifier, willBeInserted -> ToolbarItemConvertible? in
					ToolbarItem(
						itemIdentifier: identifier,
						.image -- NSImage(named: NSImage.addTemplateName),
						.label -- NSLocalizedString("Soft Error", comment: ""),
						.action --> Input().subscribeValuesUntilEnd { _ in viewModel.attemptToRemoveNonExistentRow() }
					)
				},
				ToolbarItemDescription(identifier: NSToolbarItem.Identifier(rawValue: "hardError")) { identifier, willBeInserted -> ToolbarItemConvertible? in
					ToolbarItem(
						itemIdentifier: identifier,
						.image -- NSImage(named: NSImage.cautionName),
						.label -- NSLocalizedString("Hard Error", comment: ""),
						.action --> Input().subscribeValuesUntilEnd { _ in viewModel.fatalError() }
					)
				},
				ToolbarItemDescription(identifier: NSToolbarItem.Identifier(rawValue: "animate")) { identifier, willBeInserted -> ToolbarItemConvertible? in
					ToolbarItem(
						itemIdentifier: identifier,
						.image -- NSImage(named: NSImage.computerName),
						.label -- NSLocalizedString("Animate", comment: ""),
						.action --> viewModel.animateInput
					)
				}
			]
		),
		.contentView -- View(
			.layer -- BackingLayer(
				.addAnimation <-- viewModel.animateOutput.map { _ in .push(from: .left) },
				.sublayers -- [
					GradientLayer(
						.colors -- [NSColor.red.cgColor, NSColor.yellow.cgColor, NSColor.green.cgColor, NSColor.blue.cgColor]
					)
				]
			),
			.layout -- .horizontal(.view(StackView(
				.axis -- NSUserInterfaceLayoutOrientation.vertical,
				.edgeInsets -- NSEdgeInsets(top: 5, left: 5, bottom: 15, right: 5),
				.views -- [
					TableView<Document.Row>.scrollEmbedded(
						.layer -- BackingLayer(
							.shadowOpacity -- 1,
							.shadowRadius -- 3,
							.shadowOffset -- CGSize(width: 0, height: 2)
						),
						.rowHeight -- 22,
						.columnAutoresizingStyle -- .lastColumnOnlyAutoresizingStyle,
						.rows <-- viewModel.rowSignal.arrayMutationToRowMutation(),
						.selectionChanged --> Input().subscribeValuesUntilEnd { selection in viewModel.selectionChanged(selectedRows: selection.selectedRows) },
						.columns -- [
							TableColumn<Document.Row>(
								identifier: NSUserInterfaceItemIdentifier("int"),
								.title -- NSLocalizedString("Integer", comment: ""),
								.cellConstructor -- { (identifier, rows) -> TableCellView in
									TableCellView(
										.layout -- .horizontal(
											.view(TextField(
												.integerValue <-- rows.compactMap { $0 }.map { $0.intValue }
											))
										)
									)
								}
							),
							TableColumn<Document.Row>(
								identifier: NSUserInterfaceItemIdentifier("string"),
								.title -- NSLocalizedString("String", comment: ""),
								.cellConstructor -- { (identifier, rows) -> TableCellView in
									TableCellView(
										.layout -- .horizontal(
											.view(TextField(
												.stringValue <-- rows.compactMap { $0 }.map { $0.stringValue }
											))
										)
									)
								}
							)
						]
					),
					StackView(
						.axis -- NSUserInterfaceLayoutOrientation.horizontal,
						.views -- [
							Button(
								.bezelStyle -- NSButton.BezelStyle.rounded,
								.title -- NSLocalizedString("Add row", comment: ""),
								.action --> Input().subscribeValuesUntilEnd { _ in viewModel.addRow() }
							),
							Button(
								.bezelStyle -- NSButton.BezelStyle.rounded,
								.title -- NSLocalizedString("Remove row", comment: ""),
								.action --> Input().subscribeValuesUntilEnd { _ in viewModel.removeSelectedRows() },
								.isEnabled <-- viewModel.selectionOutput.map { !$0.isEmpty }
							)
						]
					)
				]
			)))
		)
	)
	
	return window
}

func secondWindow(model: DocumentAdapter) -> Window {
	return Window(
		.contentWidth -- 800,
		.contentHeight -- 800,
		.title -- "SecondWindow",
		.frameHorizontal -- -5,
		.frameVertical -- 5,
		.contentView -- View(
			.layout -- .horizontal(
				.view(OutlineView<String>.scrollEmbedded(
					.rowHeight -- 22,
					.treeData -- [
						.leaf("One"),
						.branchAndChildren("Hello", [
							.leaf("Three")
						]),
						.leaf("Two")
					],
					.columns -- [
						TableColumn<String>(
							identifier: NSUserInterfaceItemIdentifier("TextColumn"),
							.title -- NSLocalizedString("Text", comment: ""),
							.cellConstructor -- { identifier, rowSignal in
								TableCellView(
									.layout -- .horizontal(
										.view(TextField(labelStyled:
											.stringValue <-- rowSignal.compactMap { $0 }
										))
									)
								)
							}
						)
					]
				))
			)
		)
	)
}

func thirdWindow() -> Window {
	return Window(
		.title -- "ThirdWindow",
		.contentWidth -- .screenRatio(0.25),
		.contentHeight -- 150,
		.contentView -- View(
			.layout -- .horizontal(
				.view(TextField(
					.stringValue -- "Some basic text",
					.action(\.stringValue) --> Input().subscribeValuesUntilEnd { print($0) }
				))
			)
		)
	)
}

let doc = DocumentAdapter(loadOperation: .setContents(Document()))
let (fatalErrorInput, fatalErrorSignal) = Signal<Bool>.create()

let x = Foundation.NSString()

applicationMain { Application(
	.mainMenu -- mainMenu(),
	.presentError <-- doc.ignoreElements().catchError { err in
		let e = err as NSError
		let title = NSLocalizedString("Uh-oh, a fatal error has occurred.", comment: "")
		let detail = NSLocalizedString("Hate to do this do you but the program is going to quit, now.", comment: "")
		let userInfo = [NSLocalizedRecoverySuggestionErrorKey: detail, NSLocalizedDescriptionKey: title]
		return .just(Callback(NSError(domain: e.domain, code: e.code, userInfo: userInfo), fatalErrorInput))
	},
	.terminate <-- fatalErrorSignal.map { _ in () },
	.lifetimes -- [
		mainWindow(model: doc).nsWindow(),
		secondWindow(model: doc).nsWindow(),
		thirdWindow().nsWindow()
	]
) }
