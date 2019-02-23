//
//  CwlIndexedMutation.swift
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

/// This enum is intended to be embedded in an ArrayMutation<Element>. The ArrayMutation<Element> combines an IndexSet with this enum. This enum specifies what actions should be taken at the locations specified by the IndexSet.
///
/// 
public enum IndexedMutationKind {
	/// The values at the locations specified by the IndexSet should be deleted.
	/// NOTE: the IndexSet specifies the indexes *before* deletion (and must therefore be applied in reverse).
	case delete

	/// The associated Array<Element> contains values that should be inserted such that they have the indexes specified in IndexSet. The Array<Element> and IndexSet must have identical counts.
	/// NOTE: the IndexSet specifies the indexes *after* insertion (and must therefore be applied in forward order).
	case insert

	/// Elements are deleted from one end and inserted onto the other. If `Int` is positive, values are deleted from the `startIndex` end and inserted at the `endIndex` end, if `Int` is negative, value are deleted from the `endIndex` end and inserted at the `startIndex`end.
	/// The magnitude of `Int` specifies the number of deleted rows and the sign specified the end.
	/// The Array<Element> contains values that should be inserted at the other end of the collection.
	/// The IndexSet contains the indexes of any revealed (scrolled into view) rows
	case scroll(Int)

	/// The associated Array<Element> contains updated values at locations specified by the IndexSet. Semantically, the item should be modelled as updated but not replaced. The Array<Element> and IndexSet must have identical counts.
	// In many cases, update and replace are the same. The only differences relate to scenarios where the items are considered to have "identity". An update *retains* the previous identity whereas a replace *discards* any previous identity.
	case update
	
	/// The values at the locations specified by the IndexSet should be removed from their locations and spliced back in at the location specified by the associated Int index. For scrolled subranges, items may not be moved from outside or to outside the visible range (items moved from outside the visible range must be inserted and items moved outside the visible range must be deleted)
	/// NOTE: the IndexSet specifies the indexes *before* removal (and must therefore be applied in reverse) and the Int index specifies an index *after* removal.
	case move(Int)

	/// Equivalent to a Deletion of all previous indexes and an Insertion of the new values. The associated Array<Element> contains the new state of the array. All previous values should be discarded and the entire array replaced with this new version. The Array<Element> and IndexSet must have identical counts.
	/// NOTE: the IndexSet specifies the indexes *after* insertion (and must therefore be applied in forward order).
	case reload
}

/// An `ArrayMutation` communicates changes to an array in one context so that another array, mirroring its contents in another context, can mimic the same changes.
/// Subscribing to a stream of `ArrayMutation`s is sufficient to communication the complete state and animatable transitions of an array between to parts of a program.
/// In most cases, the source and destination will need to keep their own complete copy of the array to correctly calculate the effect of the mutation.
public struct IndexedMutation<Element, Metadata>: ExpressibleByArrayLiteral {
	/// Determines the meaning of this `ArrayMutation`
	public let kind: IndexedMutationKind

	/// The metadats type is typically `Void` for plain array mutations since application of an indexed mutation to an array leaves no storage for metadata.
	/// Subrange and tree mutations use the metadata for subrange details and "leaf" data but require specialized storage structures to receive that data. The semantics of the metadata is specific to the respective `apply` functions.
	/// NOTE: Any non-nil metadata is typically set buy the mutation but a metadata value of `nil` doesn't clear the metadata, it usually just has no effect. The exception is `.reload` operations which function like re-creating the storage and explicitly set the value in all cases.
	public let metadata: Metadata?
	
	/// The meaning of the indexSet is dependent on the `kind` – it may contain indexes in the array that will be deleted by this mutation or it may contain indexes that new entries will occupy after application of this mutation.
	public let indexSet: IndexSet
	
	/// New values that will be inserted at locations determined by the `kind` and the `indexSet`.
	public let values: Array<Element>
	
	/// Construct from components.
	public init(kind: IndexedMutationKind, metadata: Metadata?, indexSet: IndexSet, values: Array<Element>) {
		self.kind = kind
		self.metadata = metadata
		self.indexSet = indexSet
		self.values = values
	}
}

public extension IndexedMutation {
	/// Construct an empty array mutation that represents a no-op.
	init() {
		self.init(kind: .update, metadata: nil, indexSet: IndexSet(), values: [])
	}
	
	/// A .reload mutation can be constructed from an array literal (since it is equivalent to an array assignment).
	init(arrayLiteral elements: Element...) {
		self.init(kind: .reload, metadata: nil, indexSet: IndexSet(integersIn: elements.indices), values: elements)
	}

	/// Construct a mutation that discards any previous history and simply starts with a completely new array.
	init(metadata: Metadata? = nil, reload values: Array<Element>) {
		self.init(kind: .reload, metadata: metadata, indexSet: IndexSet(integersIn: values.indices), values: values)
	}

	/// Construct a mutation that represents a metadata-only change.
	init(metadata: Metadata) {
		self.init(kind: .update, metadata: metadata, indexSet: IndexSet(), values: [])
	}

	/// Construct a mutation that represents the deletion of the values at a set of indices.
	init(metadata: Metadata? = nil, deletedIndexSet: IndexSet) {
		self.init(kind: .delete, metadata: metadata, indexSet: deletedIndexSet, values: [])
	}
	
	/// Construct a mutation that represents advancing the visible window through a larger array.
	init(metadata: Metadata? = nil, scrollForwardRevealing indexSet: IndexSet, values: Array<Element>) {
		precondition(indexSet.count == values.count)
		self.init(kind: .scroll(indexSet.count), metadata: metadata, indexSet: indexSet, values: values)
	}
	
	/// Construct a mutation that represents retreating the visible window through a larger array.
	init(metadata: Metadata? = nil, scrollBackwardRevealing indexSet: IndexSet, values: Array<Element>) {
		precondition(indexSet.count == values.count)
		self.init(kind: .scroll(-indexSet.count), metadata: metadata, indexSet: indexSet, values: values)
	}
	
	/// Construct a mutation that represents the insertion of a number of values at a set of indices. The count of indices must match the count of values.
	init(metadata: Metadata? = nil, insertedIndexSet: IndexSet, values: Array<Element>) {
		precondition(insertedIndexSet.count == values.count)
		self.init(kind: .insert, metadata: metadata, indexSet: insertedIndexSet, values: values)
	}
	
	/// Construct a mutation that represents the insertion of a number of values at a set of indices. The count of indices must match the count of values.
	init(metadata: Metadata? = nil, updatedIndexSet: IndexSet, values: Array<Element>) {
		precondition(updatedIndexSet.count == values.count)
		self.init(kind: .update, metadata: metadata, indexSet: updatedIndexSet, values: values)
	}
	
	/// Construct a mutation that represents the insertion of a number of values at a set of indices. The count of indices must match the count of values.
	init(metadata: Metadata? = nil, movedIndexSet: IndexSet, targetIndex: Int) {
		self.init(kind: .move(targetIndex), metadata: metadata, indexSet: movedIndexSet, values: [])
	}
	

	/// Convenience constructor for deleting a single element
	static func deleted(at index: Int) -> IndexedMutation<Element, Metadata> {
		return IndexedMutation<Element, Metadata>(deletedIndexSet: IndexSet(integer: index))
	}
	
	/// Convenience constructor for inserting a single element
	static func inserted(_ value: Element, at index: Int) -> IndexedMutation<Element, Metadata> {
		return IndexedMutation<Element, Metadata>(insertedIndexSet: IndexSet(integer: index), values: [value])
	}
	
	/// Convenience constructor for inserting a single element
	static func updated(_ value: Element, at index: Int) -> IndexedMutation<Element, Metadata> {
		return IndexedMutation<Element, Metadata>(updatedIndexSet: IndexSet(integer: index), values: [value])
	}
	
	/// Convenience constructor for inserting a single element
	static func moved(from oldIndex: Int, to newIndex: Int) -> IndexedMutation<Element, Metadata> {
		return IndexedMutation<Element, Metadata>(movedIndexSet: IndexSet(integer: oldIndex), targetIndex: newIndex)
	}
	
	/// Creates a new IndexedMutation by mapping the values array from this transform. NOTE: metdata is passed through unchanged.
	func mapValues<Other>(_ transform: (Element) -> Other) -> IndexedMutation<Other, Metadata> {
		return IndexedMutation<Other, Metadata>(kind: kind, metadata: metadata, indexSet: indexSet, values: values.map(transform))
	}
	
	/// Creates a new IndexedMutation by mapping the values array from this transform. NOTE: metdata is passed through unchanged.
	func mapMetadata<Alternate>(_ transform: (Metadata) -> Alternate) -> IndexedMutation<Element, Alternate> {
		return IndexedMutation<Element, Alternate>(kind: kind, metadata: metadata.map(transform), indexSet: indexSet, values: values)
	}
	
	/// Given a previous row count, returns the new row count after this mutation
	///
	/// - Parameter rowCount: old number of rows
	func delta(_ rowCount: inout Int) {
		switch kind {
		case .reload: rowCount = values.count
		case .delete: rowCount -= indexSet.count
		case .scroll(let offset): rowCount += values.count - (offset > 0 ? offset : -offset)
		case .insert: rowCount += values.count
		case .move: return
		case .update: return
		}
	}
	
	/// A no-op on rows is explicitly defined as an `.update` with an empty `values` array. Note that metadata may still be non-nil.
	var hasNoEffectOnRows: Bool {
		if case .update = kind, values.count == 0 {
			return true
		}
		return false
	}
}
