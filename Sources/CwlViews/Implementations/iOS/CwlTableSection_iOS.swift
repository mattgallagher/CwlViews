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

/// An extension of the same premise in `RangeMutation.apply` for `RangeMutation<TableSectionMutation<Value>>` that maps the `TableSectionMutation` onto a `TableSectionState` and correctly applies the mutation in the nested `TableSectionMutation` to the target on update.
extension RangeMutation {
	public func apply<Row>(to sections: inout TableSectionState<TableRowState<Row>>) where TableRowMutation<Row> == Value, Metadata == () {
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
				mutation.rangeMutation.apply(to: &section.rowState)
				sections.rows.replaceSubrange(sectionIndex..<(sectionIndex + 1), with: CollectionOfOne(section))
			}
		case .reload:
			sections.rows.replaceSubrange(sections.rows.startIndex..<sections.rows.endIndex, with: values.map { TableSectionState<Row>(initial: $0) })
		}
	}
}

#endif
