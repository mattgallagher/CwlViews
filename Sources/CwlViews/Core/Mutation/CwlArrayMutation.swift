//
//  CwlArrayMutation.swift
//  CwlUtils
//
//  Created by Matt Gallagher on 2015/02/03.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

/// This enum is intended to be embedded in an ArrayMutation<Value>. The ArrayMutation<Value> combines an IndexSet with this enum. This enum specifies what actions should be taken at the locations specified by the IndexSet.
///
/// 
public enum ArrayMutationKind {
	/// The values at the locations specified by the IndexSet should be deleted.
	/// NOTE: the IndexSet specifies the indexes *before* deletion (and must therefore be applied in reverse).
	case delete

	/// The associated Array<Value> contains values that should be inserted such that they have the indexes specified in IndexSet. The Array<Value> and IndexSet must have identical counts.
	/// NOTE: the IndexSet specifies the indexes *after* insertion (and must therefore be applied in forward order).
	case insert

	/// Values are deleted from one end and inserted onto the other. If `Int` is positive, values are deleted from the `startIndex` end and inserted at the `endIndex` end, if `Int` is negative, value are deleted from the `endIndex` end and inserted at the `startIndex`end.
	/// The magnitude of `Int` specifies the number of deleted rows and the sign specified the end.
	/// The Array<Value> contains values that should be inserted at the other end of the collection.
	/// The IndexSet contains the indexes of any revealed (scrolled into view) rows
	case scroll(Int)

	/// The associated Array<Value> contains updated values at locations specified by the IndexSet. Semantically, the item should be modelled as updated but not replaced. The Array<Value> and IndexSet must have identical counts.
	// In many cases, update and replace are the same. The only differences relate to scenarios where the items are considered to have "identity". An update *retains* the previous identity whereas a replace *discards* any previous identity.
	case update
	
	/// The values at the locations specified by the IndexSet should be removed from their locations and spliced back in at the location specified by the associated Int index. For scrolled subranges, items may not be moved from outside or to outside the visible range (items moved from outside the visible range must be inserted and items moved outside the visible range must be deleted)
	/// NOTE: the IndexSet specifies the indexes *before* removal (and must therefore be applied in reverse) and the Int index specifies an index *after* removal.
	case move(Int)

	/// Equivalent to a Deletion of all previous indexes and an Insertion of the new values. The associated Array<Value> contains the new state of the array. All previous values should be discarded and the entire array replaced with this new version. The Array<Value> and IndexSet must have identical counts.
	/// NOTE: the IndexSet specifies the indexes *after* insertion (and must therefore be applied in forward order).
	case reload
}

/// An `ArrayMutation` communicates changes to an array in one context so that another array, mirroring its contents in another context, can mimic the same changes.
/// Subscribing to a stream of `ArrayMutation`s is sufficient to communication the complete state and animatable transitions of an array between to parts of a program.
/// In most cases, the source and destination will need to keep their own complete copy of the array to correctly calculate the effect of the mutation.
public struct ArrayMutation<Value>: ExpressibleByArrayLiteral {
	/// Determines the meaning of this `ArrayMutation`
	public let kind: ArrayMutationKind

	/// The meaning of the indexSet is dependent on the `kind` – it may contain indexes in the array that will be deleted by this mutation or it may contain indexes that new entries will occupy after application of this mutation.
	public let indexSet: IndexSet
	
	/// New values that will be inserted at locations determined by the `kind` and the `indexSet`.
	public let values: Array<Value>
	
	/// Construct an empty array mutation that represents a no-op.
	public init() {
		self.kind = .update
		self.indexSet = IndexSet()
		self.values = []
	}
	
	/// Construct from components.
	public init<S>(indexSet: IndexSet, kind: ArrayMutationKind, values: S) where S: Sequence, S.Element == Value {
		self.kind = kind
		self.indexSet = indexSet
		self.values = Array(values)
	}
	
	/// Construct a mutation that represents the deletion of the values at a set of indices.
	public init(deletedIndexSet: IndexSet) {
		self.kind = .delete
		self.indexSet = deletedIndexSet
		self.values = []
	}
	
	/// Construct a mutation that represents the deletion of a value at an index.
	public init(deletedIndex: Int) {
		self.kind = .delete
		self.indexSet = IndexSet(integer: deletedIndex)
		self.values = []
	}
	
	/// Construct a mutation that represents the deletion of a value at an index.
	public static func deleted(at index: Int) -> ArrayMutation<Value> {
		return ArrayMutation(deletedIndex: index)
	}
	
	/// Construct a mutation that represents the deletion of the values within a range indices.
	public init(deletedRange: CountableRange<Int>) {
		self.kind = .delete
		self.indexSet = IndexSet(integersIn: deletedRange)
		self.values = []
	}
	
	/// Construct a mutation that represents the deletion of a value at an index.
	public init<S>(scrollForwardRevealing indexSet: IndexSet, values: S) where S: Sequence, S.Element == Value {
		let array = Array(values)
		assert(indexSet.count == array.count)
		self.kind = .scroll(indexSet.count)
		self.indexSet = indexSet
		self.values = Array(array)
	}
	
	/// Construct a mutation that represents the deletion of a value at an index.
	public init<S>(scrollBackwardRevealing indexSet: IndexSet, values: S) where S: Sequence, S.Element == Value {
		let array = Array(values)
		assert(indexSet.count == array.count)
		self.kind = .scroll(-indexSet.count)
		self.indexSet = indexSet
		self.values = array
	}
	
	/// Construct a mutation that represents the insertion of a number of values at a set of indices. The count of indices must match the count of values.
	public init<S>(insertedIndexSet: IndexSet, values: S) where S: Sequence, S.Element == Value {
		let array = Array(values)
		assert(insertedIndexSet.count == array.count)
		self.kind = .insert
		self.indexSet = insertedIndexSet
		self.values = array
	}
	
	/// Construct a mutation that represents the insertion of a value at an index.
	public init(insertedIndex: Int, value: Value) {
		self.kind = .insert
		self.indexSet = IndexSet(integer: insertedIndex)
		self.values = [value]
	}

	/// Construct a mutation that represents the insertion of a number of values within a range of indices. The count of the range must match the count of values.
	public init<S>(insertedRange: CountableRange<Int>, values: S) where S: Sequence, S.Element == Value {
		let array = Array(values)
		assert(insertedRange.count == array.count)
		self.kind = .insert
		self.indexSet = IndexSet(integersIn: insertedRange)
		self.values = array
	}
	
	/// Construct a mutation that discards any previous history and simply starts with a completely new array.
	public init<S>(reload values: S) where S: Sequence, S.Element == Value {
		let array = Array(values)
		self.kind = .reload
		self.indexSet = IndexSet(integersIn: array.indices)
		self.values = array
	}
	
	/// A .Reload mutation can be constructed from an array literal (since it is equivalent to an array assignment).
	public init(arrayLiteral elements: Value...) {
		self.init(reload: elements)
	}
	
	/// Construct a mutation that represents the update of a number of values at a set of indices. The count of indices must match the count of values.
	public init<S>(updatedIndexSet: IndexSet, values: S) where S: Sequence, S.Element == Value {
		let array = Array(values)
		assert(updatedIndexSet.count == array.count)
		self.kind = .update
		self.indexSet = updatedIndexSet
		self.values = array
	}
	
	/// Construct a mutation that represents the update of a value at an index.
	public init(updatedIndex: Int, value: Value) {
		self.kind = .update
		self.indexSet = IndexSet(integer: updatedIndex)
		self.values = [value]
	}
	
	/// Construct a mutation that represents the udpate of a number of values within a range of indices. The count of the range must match the count of values.
	public init<S>(updatedRange: CountableRange<Int>, values: S) where S: Sequence, S.Element == Value {
		let array = Array(values)
		assert(updatedRange.count == array.count)
		self.kind = .update
		self.indexSet = IndexSet(integersIn: updatedRange)
		self.values = array
	}
	
	/// Construct a mutation that represents the move of a number of values from a set of indices to a new range starting at targetIndex. NOTE: the order of values once inserted at targetIndex must be the same as the order in movedIndexSet.
	public init(movedIndexSet: IndexSet, targetIndex: Int) {
		self.kind = .move(targetIndex)
		self.indexSet = movedIndexSet
		self.values = []
	}

	/// Construct a mutation that represents the move of a value at movedIndex to a new range starting at targetIndex.
	public init(movedIndex: Int, targetIndex: Int) {
		self.kind = .move(targetIndex)
		self.indexSet = IndexSet(integer: movedIndex)
		self.values = []
	}

	/// Construct a mutation that represents the move of a range of values to a new range starting at targetIndex. NOTE: the order of values once inserted at targetIndex must be the same as the order in movedRange.
	public init(movedRange: CountableRange<Int>, targetIndex: Int) {
		self.kind = .move(targetIndex)
		self.indexSet = IndexSet(integersIn: movedRange)
		self.values = []
	}

	/// Apply the mutation described by this value to the provided array
	public func apply<C: RangeReplaceableCollection>(to a: inout C) where C.Index == Int, C.Iterator.Element == Value {
		switch kind {
		case .delete:
			indexSet.rangeView.reversed().forEach { a.removeSubrange($0) }
		case .scroll(let offset):
			a.removeSubrange(offset > 0 ? a.startIndex..<offset : (a.endIndex + offset)..<a.endIndex)
			a.insert(contentsOf: values, at: offset > 0 ? a.endIndex : a.startIndex)
		case .move(let index):
			let moving = indexSet.map { a[$0] }
			indexSet.rangeView.reversed().forEach { a.removeSubrange($0) }
			a.insert(contentsOf: moving, at: index)
		case .insert:
			for (i, v) in zip(indexSet, values) {
				a.insert(v, at: i)
			}
		case .update:
			for (i, v) in zip(indexSet, values) {
				a.insert(v, at: i)
			}
		case .reload:
			a.replaceSubrange(a.startIndex..<a.endIndex, with: values)
		}
	}
	
	public func map<Other>(_ transform: (Value) -> Other) -> ArrayMutation<Other> {
		return ArrayMutation<Other>(indexSet: indexSet, kind: kind, values: values.map(transform))
	}
	
	public func removed(previousIndices a: CountableRange<Int>) -> IndexSet {
		switch kind {
		case .delete: return indexSet
		case .scroll(let offset): return IndexSet(integersIn: offset > 0 ? (a.endIndex - offset)..<a.endIndex : a.startIndex..<(a.startIndex + offset))
		case .reload: return IndexSet(integersIn: a)
		case .move: fallthrough
		case .insert: fallthrough
		case .update: return IndexSet()
		}
	}
	
	public func inserted(subsequentIndices a: CountableRange<Int>) -> IndexSet {
		switch kind {
		case .insert: return indexSet
		case .scroll(let offset): return IndexSet(integersIn: offset > 0 ? a.startIndex..<offset : (a.endIndex + offset)..<a.endIndex)
		case .reload: return IndexSet(integersIn: a)
		case .delete: return indexSet
		case .move: fallthrough
		case .update: return IndexSet()
		}
	}
	
	/// Updates a row count due to this mutation.
	public func delta(_ rowCount: inout Int) {
		switch kind {
		case .reload: rowCount = values.count
		case .delete: rowCount -= indexSet.count
		case .scroll(let offset): rowCount += values.count - (offset > 0 ? offset : -offset)
		case .insert: rowCount += values.count
		case .move: return
		case .update: return
		}
	}
}
