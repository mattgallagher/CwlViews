//
//  CwlIndexedMutationUtilities.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/12/23.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension IndexedMutation where Metadata == Void {
	/// Apply the mutation described by this value to the provided array
	func apply<C: RangeReplaceableCollection & MutableCollection>(to a: inout C) where C.Index == Int, C.Iterator.Element == Element {
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
				a[i] = v
			}
		case .reload:
			a.replaceSubrange(a.startIndex..<a.endIndex, with: values)
		}
	}
}

/// When used as the `Metadata` parameter to an `IndexedMutation`, then the indexed mutation can represent a locally visible subrange within a larger global array.
/// NOTE: when `nil` the following behaviors are implied for each IndexedMutation kind:
///	- reload: the localOffset is 0 and the globalCount is the reload count
///   - delete: the globalCount is reduced by the deletion count 
///   - insert: the globalCount is increased by the insertion count 
///   - scroll: the localOffset is changed by the scroll count
///   - update: neither localOffset nor globalCount are changed
///   - move: neither localOffset nor globalCount are changed
public struct Subrange<Metadata> {
	/// This is offset for the visible range.
	public let localOffset: Int
	
	/// This is the length of the greater array *after* the mutation is applied.
	public let globalCount: Int
	
	/// Additional metadata for this tier
	public let metadata: Metadata?
}

/// A data type that can be used to cache the destination end of a `Subrange<Leaf>` change stream.
public struct SubrangeState<Element, Metadata> {
	public var rows: Deque<Element>? = nil
	public var localOffset: Int = 0
	public var globalCount: Int = 0
	public var metadata: Metadata?
	public init() {}
}

extension IndexedMutation {
	public func updateMetadata<Value, Leaf>(_ state: inout SubrangeState<Value, Leaf>) where Subrange<Leaf> == Metadata {
		if let subrange = metadata {
			state.localOffset = subrange.localOffset
			state.globalCount = subrange.globalCount
			if let metadata = subrange.metadata {
				state.metadata = metadata
			}
		} else {
			switch kind {
			case .reload:
				state.localOffset = 0
				state.globalCount = values.count
				state.metadata = nil
			case .delete: state.globalCount -= indexSet.count
			case .insert: state.globalCount += indexSet.count
			case .scroll(let offset): state.localOffset += offset
			case .update: break
			case .move: break
			}
		}
	}
	
	public func apply<Leaf>(toSubrange state: inout SubrangeState<Element, Leaf>) where Subrange<Leaf> == Metadata {
		if !hasNoEffectOnRows {
			var rows = state.rows ?? []
			mapMetadata { _ in () }.apply(to: &rows)
			state.rows = rows
		}
		
		updateMetadata(&state)
	}
}

public struct TreeMutation<Leaf> {
	let mutations: IndexedMutation<TreeMutation<Leaf>, Leaf>
}

public struct TreeState<Metadata> {
	public var metadata: Metadata? = nil
	public var rows: Array<TreeState<Metadata>>? = nil
	
	public init() {}
	
	public init(tieredMutation: TreeMutation<Metadata>) {
		self.init()
		tieredMutation.mutations.apply(toTree: &self)
	}
}

extension IndexedMutation where Element == TreeMutation<Metadata> {
	public func apply(toTree tieredState: inout TreeState<Metadata>) {
		if let metadata = metadata {
			tieredState.metadata = metadata
		}
		
		if !hasNoEffectOnRows {
			var rows: Array<TreeState<Metadata>> = []
			mapValues(TreeState<Metadata>.init).mapMetadata { _ in () }.apply(to: &rows)
			tieredState.rows = rows
		}
	}
}

public typealias TreeSubrangeMutation<Leaf> = TreeMutation<Subrange<Leaf>>

public struct TreeSubrangeState<Leaf> {
	public var state = SubrangeState<TreeSubrangeState<Leaf>, Leaf>()

	public init() {}
	
	public init(tieredSubrangeMutation: TreeSubrangeMutation<Leaf>) {
		self.init()
		tieredSubrangeMutation.mutations.apply(toTreeSubrange: &self)
	}
}

extension IndexedMutation where Element == TreeMutation<Metadata> {
	public func apply<Leaf>(toTreeSubrange tieredSubrangeState: inout TreeSubrangeState<Leaf>) where Subrange<Leaf> == Metadata {
		if !hasNoEffectOnRows {
			var rows: Deque<TreeSubrangeState<Leaf>> = []
			mapValues(TreeSubrangeState<Leaf>.init).mapMetadata { _ in () }.apply(to: &rows)
			tieredSubrangeState.state.rows = rows
		}
		updateMetadata(&tieredSubrangeState.state)
	}
}

public typealias ArrayMutation<Element> = IndexedMutation<Element, Void>
public typealias RangeMutation<Element, Additional> = IndexedMutation<Element, Subrange<Additional>>
public typealias TreeRangeMutation<Leaf> = TreeMutation<Subrange<Leaf>>


//extension Sequence {
//	public func arrayMutation() -> ArrayMutation<Element> {
//		return .reload(self)
//	}
//	
//	public func rangeMutation<T>(metadata: T? = nil) -> RangeMutation<Element, T> {
//		return RangeMutation<Element, T>(metadata: metadata, arrayMutation: arrayMutation())
//	}
//	
//	#if os(macOS)
//		public func rowMutation() -> TableRowMutation<Element> {
//			return Animatable(value: RangeMutation<Element, ()>(arrayMutation: arrayMutation()), animation: .none)
//		}
//	#elseif os(iOS)
//		public func rowMutation(metadata: TableSectionMetadata? = nil) -> TableRowMutation<Element> {
//			return Animatable(value: rangeMutation(metadata: metadata), animation: .none)
//		}
//
//		public func tableData(metadata: TableSectionMetadata? = nil) -> TableSectionMutation<Element> {
//			return TableSectionMutation(arrayMutation: .reload([rowMutation(metadata: metadata)]))
//		}
//	#endif
//}
//
//extension ArrayMutation {
//	/// Construct a mutation that represents the insertion of a value at an index.
//	public static func inserted(_ value: Value, at index: Int) -> ArrayMutation<Value> {
//		return ArrayMutation(insertedIndex: index, value: value)
//	}
//
//	/// Construct a mutation that discards any previous history and simply starts with a completely new array.
//	public static func reload<S: Sequence>(_ values: S) -> ArrayMutation<Value> where S.Element == Value {
//		return ArrayMutation(reload: Array(values))
//	}
//
//	/// Construct a mutation that represents the update of a value at an index.
//	public static func updated(_ value: Value, at index: Int) -> ArrayMutation<Value> {
//		return ArrayMutation(updatedIndex: index, value: value)
//	}
//
//	/// Construct a mutation that represents the update of a value at an index.
//	public static func moved(from sourceIndex: Int, to targetIndex: Int) -> ArrayMutation<Value> {
//		return ArrayMutation(movedIndex: sourceIndex, targetIndex: targetIndex)
//	}
//	
//	public func rangeMutation<T>() -> RangeMutation<Value, T> {
//		return RangeMutation(arrayMutation: self)
//	}
//}
//
//extension SignalInterface {
//	public func rangeMutation<Value, T>() -> Signal<RangeMutation<Value, T>> where ArrayMutation<Value> == OutputValue {
//		return map(initialState: 0) { (globalCount: inout Int, arrayMutation: ArrayMutation<Value>) -> RangeMutation<Value, T> in
//			arrayMutation.delta(&globalCount)
//			return RangeMutation(arrayMutation: arrayMutation, localOffset: 0, globalCount: globalCount)
//		}
//	}
//}
