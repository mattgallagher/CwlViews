//
//  CwlSubrangeMutation.swift
//  CwlViews
//
//  Created by Matt Gallagher on 23/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

/// When used as the `Metadata` parameter to an `IndexedMutation`, then the indexed mutation can represent a locally visible subrange within a larger global array.
/// NOTE: when `nil` the following behaviors are implied for each IndexedMutation kind:
///	- reload: the localOffset is 0 and the globalCount is the reload count
///   - delete: the globalCount is reduced by the deletion count 
///   - insert: the globalCount is increased by the insertion count 
///   - scroll: the localOffset is changed by the scroll count
///   - update: neither localOffset nor globalCount are changed
///   - move: neither localOffset nor globalCount are changed
public struct Subrange<Leaf> {
	/// This is offset for the visible range.
	public let localOffset: Int
	
	/// This is the length of the greater array *after* the mutation is applied.
	public let globalCount: Int
	
	/// Additional metadata for this tier
	public let leaf: Leaf?
	
	public init(localOffset: Int, globalCount: Int, leaf: Leaf?) {
		self.localOffset = localOffset
		self.globalCount = globalCount
		self.leaf = leaf
	}
}

/// A data type that can be used to cache the destination end of a `Subrange<Leaf>` change stream.
public struct SubrangeState<Element, Leaf> {
	public var values: Deque<Element>?
	public var localOffset: Int = 0
	public var globalCount: Int = 0
	public var leaf: Leaf?

	public init(values: Deque<Element>? = nil, localOffset: Int = 0, globalCount: Int? = nil, leaf: Leaf? = nil) {
		self.values = values
		self.localOffset = localOffset
		self.globalCount = globalCount ?? values?.count ?? 0
		self.leaf = leaf
	}
}

public typealias SubrangeMutation<Element, Additional> = IndexedMutation<Element, Subrange<Additional>>

extension IndexedMutation {
	public func updateMetadata<Value, Leaf>(_ state: inout SubrangeState<Value, Leaf>) where Subrange<Leaf> == Metadata {
		if let subrange = metadata {
			state.localOffset = subrange.localOffset
			state.globalCount = subrange.globalCount
			if let metadata = subrange.leaf {
				state.leaf = metadata
			}
		} else {
			switch kind {
			case .reload:
				state.localOffset = 0
				state.globalCount = values.count
				state.leaf = nil
			case .delete: state.globalCount -= indexSet.count
			case .insert: state.globalCount += indexSet.count
			case .scroll(let offset): state.localOffset += offset
			case .update: break
			case .move: break
			}
		}
	}
	
	public func apply<Submetadata>(toSubrange state: inout SubrangeState<Element, Submetadata>) where Subrange<Submetadata> == Metadata {
		if !hasNoEffectOnValues {
			var rows = state.values ?? []
			mapMetadata { _ in () }.apply(to: &rows)
			state.values = rows
		}
		
		updateMetadata(&state)
	}
}

extension IndexSet {
	/// Maintaining an `SubrangeOffset` with a local offset may require offsetting an `IndexSet`
	public func offset(by: Int) -> IndexSet {
		if by == 0 {
			return self
		}
		var result = IndexSet()
		for range in self.rangeView {
			result.insert(integersIn: (range.startIndex + by)..<(range.endIndex + by))
		}
		return result
	}
}
