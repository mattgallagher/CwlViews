//
//  CwlTableSectionMutation_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/23.
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

#if os(iOS)

/// Storage for the string data associated with a `UITableView` section.
public struct TableSectionMetadata {
	public let header: String?
	public let footer: String?
	public init(header: String? = nil, footer: String? = nil) {
		(self.header, self.footer) = (header, footer)
	}
}

/// This data type models the most recent change to a section of a `UITableView`. When used as the `Value` type for a `TableRowMutation`, the combined data type can model all the section, header, footer and row data of an entire `UITableView`.
public struct TableSectionMutation<Value>: ExpressibleByArrayLiteral {
	public let metadata: TableSectionMetadata?
	public let rowMutation: TableRowMutation<Value>

	public init(metadata: TableSectionMetadata?, rowMutation: TableRowMutation<Value>) {
		self.metadata = metadata
		self.rowMutation = rowMutation
	}
	
	public init(header: String? = nil, footer: String? = nil, rowMutation: TableRowMutation<Value>) {
		let metadata = header != nil || footer != nil ? TableSectionMetadata(header: header, footer: footer) : nil
		self.init(metadata: metadata, rowMutation: rowMutation)
	}
	
	public init(arrayLiteral elements: Value...) {
		self.init(rowMutation: TableRowMutation(array: elements))
	}
	
	public init() {
		self.init(rowMutation: TableRowMutation())
	}
}

/// A data type that can be used to cache the destination end of a `TableSectionMutation<Value>` change stream.
public struct TableSectionState<Value> {
	public var rowState = TableRowState<Value>()
	public var metadata: TableSectionMetadata
	
	init(initial: TableSectionMutation<Value>) {
		self.metadata = initial.metadata ?? TableSectionMetadata()
		initial.rowMutation.apply(to: &rowState)
	}
	
	public var rows: Deque<Value> {
		get {
			return rowState.rows
		} set {
			rowState.rows = newValue
		}
	}
	
	public var localOffset: Int {
		get {
			return rowState.localOffset
		} set {
			rowState.localOffset = newValue
		}
	}
	
	public var globalCount: Int {
		get {
			return rowState.globalCount
		} set {
			rowState.globalCount = newValue
		}
	}
}

/// An extension of the same premise in `TableRowMutation.apply` for `TableRowMutation<TableSectionMutation<Value>>` that maps the `TableSectionMutation` onto a `TableSectionState` and correctly applies the mutation in the nested `TableSectionMutation` to the target on update.
extension TableRowMutation {
	public func apply<Row>(to sections: inout TableRowState<TableSectionState<Row>>) where TableSectionMutation<Row> == Value {
		sections.globalCount = self.globalCount
		sections.localOffset = self.localOffset
		let indexSet = self.arrayMutation.indexSet
		let values = self.arrayMutation.values
		switch self.arrayMutation.kind {
		case .delete:
			indexSet.rangeView.reversed().forEach { sections.rows.removeSubrange($0) }
		case .scroll(let offset):
			sections.rows.removeSubrange(offset > 0 ? sections.rows.startIndex..<offset : (sections.rows.endIndex + offset)..<sections.rows.endIndex)
			sections.rows.insert(contentsOf: values.map { TableSectionState<Row>(initial: $0) }, at: offset > 0 ? sections.rows.endIndex : sections.rows.startIndex)
		case .move(let index):
			let moving = indexSet.map { sections.rows[$0] }
			indexSet.rangeView.reversed().forEach { sections.rows.removeSubrange($0) }
			sections.rows.insert(contentsOf: moving, at: index)
		case .insert:
			for (i, v) in zip(indexSet, values) {
				sections.rows.insert(TableSectionState<Row>(initial: v), at: i)
			}
		case .update:
			for (valuesIndex, sectionIndex) in indexSet.enumerated() {
				var section = sections.rows[sectionIndex]
				let mutation = values[valuesIndex]
				if let m = mutation.metadata {
					section.metadata = m
				}
				mutation.rowMutation.apply(to: &section.rowState)
				sections.rows.replaceSubrange(sectionIndex..<(sectionIndex + 1), with: CollectionOfOne(section))
			}
		case .reload:
			sections.rows.replaceSubrange(sections.rows.startIndex..<sections.rows.endIndex, with: values.map { TableSectionState<Row>(initial: $0) })
		}
	}
}

#endif
