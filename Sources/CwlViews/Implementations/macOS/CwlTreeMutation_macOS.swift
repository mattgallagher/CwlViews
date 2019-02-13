//
//  CwlTreeMutation_macOS.swift
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

#if os(macOS)

public enum TreeMutation<NodeData> {
	case leaf(NodeData)
	indirect case branchAndChildren(NodeData, TableRowMutation<TreeMutation<NodeData>>)
	case childrenOnly(TableRowMutation<TreeMutation<NodeData>>)
	case parentOnly(NodeData)
}

public class TreeState<NodeData> {
	public weak var parent: TreeState<NodeData>?
	public var index: Int?
	public var data: NodeData?
	public var children: TableRowState<TreeState<NodeData>>?
	
	public init(parent: TreeState<NodeData>?, index: Int) {
		data = nil
		children = nil
		self.parent = parent
		self.index = index
	}

	public init(mutation: TreeMutation<NodeData>, parent: TreeState<NodeData>?) {
		self.parent = parent
		self.index = nil
		self.children = nil
		
		switch mutation {
		case .leaf(let d): self.data = d
		case .branchAndChildren(let d, let m):
			self.data = d
			self.children = TreeState<NodeData>.childState(from: m, ofParent: self)
		case .childrenOnly(let m):
			self.children = TreeState<NodeData>.childState(from: m, ofParent: self)
		case .parentOnly(let d): self.data = d
		}
	}
	
	public static func childState(from m: TableRowMutation<TreeMutation<NodeData>>, ofParent: TreeState<NodeData>) -> TableRowState<TreeState<NodeData>> {
		var newChildren = TableRowState<TreeState<NodeData>>()
		_ = apply(rowMutation: m, to: &newChildren, ofParent: ofParent)
		return newChildren
	}
}

public struct TreePath<NodeData>: Hashable {
	public typealias NodeIndex = (index: Int, data: NodeData?)
	public let indexes: [NodeIndex]
	public init(indexes: [NodeIndex]) {
		self.indexes = indexes
	}
	public func hash(into hasher: inout Hasher) {
		indexes.forEach { value in hasher.combine(value.index) }
	}
	public static func ==(lhs: TreePath<NodeData>, rhs: TreePath<NodeData>) -> Bool {
		if lhs.indexes.count != rhs.indexes.count {
			return false
		}
		return zip(lhs.indexes, rhs.indexes).first(where: {  $0.0.index != $0.1.index }) == nil
	}
}

public func apply<R>(rowMutation: TableRowMutation<TreeMutation<R>>, to treeState: inout TableRowState<TreeState<R>>, ofParent parent: TreeState<R>?) -> (NSOutlineView) -> Void {
	treeState.globalCount = rowMutation.globalCount
	treeState.localOffset = rowMutation.localOffset
	
	let indexSet = rowMutation.arrayMutation.indexSet
	let values = rowMutation.arrayMutation.values
	switch rowMutation.arrayMutation.kind {
	case .delete:
		// Update the array
		indexSet.rangeView.reversed().forEach { treeState.rows.removeSubrange($0) }
		
		// Fix the cached indices
		for index in (indexSet.min() ?? 0)..<treeState.rows.endIndex {
			treeState.rows[index].index = index + treeState.localOffset
		}
		
		// Report changes to the view
		return { (outlineView: NSOutlineView) in
			outlineView.removeItems(at: rowMutation.arrayMutation.indexSet.offset(by: rowMutation.localOffset), inParent: parent, withAnimation: rowMutation.animation)
		}
	case .move(let destination):
		// Update the array
		let moving = indexSet.map { treeState.rows[$0] }
		indexSet.rangeView.reversed().forEach { treeState.rows.removeSubrange($0) }
		treeState.rows.insert(contentsOf: moving, at: destination)

		// Fix the cached indices
		for index in min(indexSet.min() ?? 0, destination)..<treeState.rows.endIndex {
			treeState.rows[index].index = destination + treeState.localOffset
		}

		// Report changes to the view
		return { (outlineView: NSOutlineView) in
			outlineView.beginUpdates()
			for (count, index) in rowMutation.arrayMutation.indexSet.offset(by: rowMutation.localOffset).enumerated() {
				outlineView.moveItem(at: index, inParent: parent, to: destination + count, inParent: parent)
			}
			outlineView.endUpdates()
		}
	case .scroll(let offset):
		// Update the array
		treeState.rows.removeSubrange(offset > 0 ? treeState.rows.startIndex..<offset : (treeState.rows.endIndex + offset)..<treeState.rows.endIndex)

		// Fix the cached indices
		let insertStart = offset > 0 ? treeState.rows.endIndex : treeState.rows.startIndex
		treeState.rows.insert(contentsOf: values.map { TreeState(mutation: $0, parent: parent) }, at: insertStart)
		for index in insertStart..<(insertStart + values.count) {
			treeState.rows[index].index = index + treeState.localOffset
		}
		
		// Report changes to the view
		let rows = treeState.rows
		return { (outlineView: NSOutlineView) in
			for index in rowMutation.arrayMutation.indexSet {
				outlineView.reloadItem(rows[index], reloadChildren: true)
			}
		}
	case .insert:
		// Update the array
		for (i, v) in zip(indexSet, values) {
			treeState.rows.insert(TreeState(mutation: v, parent: parent), at: i)
		}

		// Fix the cached indices
		for index in (indexSet.min() ?? 0)..<treeState.rows.endIndex {
			treeState.rows[index].index = index + treeState.localOffset
		}
		
		// Report changes to the view
		return { (outlineView: NSOutlineView) in
			outlineView.insertItems(at: rowMutation.arrayMutation.indexSet.offset(by: rowMutation.localOffset), inParent: parent, withAnimation: rowMutation.animation)
		}
	case .update:
		var animations = [(NSOutlineView) -> Void]()
		for (valuesIndex, itemIndex) in indexSet.enumerated() {
			let item = treeState.rows[itemIndex]
			let mutation = values[valuesIndex]
			var needSignalUpdate = false

			switch mutation {
			case .leaf(let d):
				item.data = d
				if item.children != nil {
					item.children = nil
					animations.append { (outlineView: NSOutlineView) in outlineView.reloadItem(item, reloadChildren: true) }
				} else {
					needSignalUpdate = true
				}
			case .branchAndChildren(let d, let m):
				item.data = d
				if var c = item.children {
					animations.append(apply(rowMutation: m, to: &c, ofParent: item))
					item.children = c
					needSignalUpdate = true
				} else {
					item.children = TreeState<R>.childState(from: m, ofParent: item)
					animations.append { (outlineView: NSOutlineView) in outlineView.reloadItem(item, reloadChildren: true) }
				}
			case .childrenOnly(let m):
				if var c = item.children {
					animations.append(apply(rowMutation: m, to: &c, ofParent: item))
					item.children = c
				} else {
					item.children = TreeState<R>.childState(from: m, ofParent: item)
					animations.append { (outlineView: NSOutlineView) in outlineView.reloadItem(item, reloadChildren: true) }
				}
			case .parentOnly(let d):
				item.data = d
				if item.children == nil {
					item.children = TableRowState<TreeState<R>>()
					animations.append { (outlineView: NSOutlineView) in outlineView.reloadItem(item, reloadChildren: true) }
				} else {
					needSignalUpdate = true
				}
			}
			
			if needSignalUpdate {
				animations.append { (outlineView: NSOutlineView) in
					let row = outlineView.row(forItem: item)
					for columnIndex in 0..<outlineView.numberOfColumns {
						if let cell = outlineView.view(atColumn: columnIndex, row: row, makeIfNecessary: false), let data = item.data {
							getSignalInput(for: cell, valueType: R.self)?.send(value: data)
						}
					}
				}
			}
		}
		return { (outlineView: NSOutlineView) in
			animations.forEach { $0(outlineView) }
		}
	case .reload:
		// Update the array
		treeState.rows.replaceSubrange(treeState.rows.startIndex..<treeState.rows.endIndex, with: values.map { TreeState(mutation: $0, parent: parent) })

		// Fix the cached indices
		for index in treeState.rows.indices {
			treeState.rows[index].index = index + treeState.localOffset
		}

		// Report changes to the view
		return { (outlineView: NSOutlineView) in
			outlineView.reloadData()
		}
	}
}

#endif
