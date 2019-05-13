//
//  CwlSubrangeMutation.swift
//  CwlViews
//
//  Created by Matt Gallagher on 23/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

/// When used as the `Metadata` parameter to an `IndexedMutation`, then the indexed mutation can represent a locally visible subrange within a larger global array.
/// NOTE: when `nil` the following behaviors are implied for each IndexedMutation kind:
///	- reload: the localOffset is 0 and the globalCount is the reload count
///   - delete: the globalCount is reduced by the deletion count 
///   - insert: the globalCount is increased by the insertion count 
///   - scroll: the localOffset is changed by the scroll count
///   - update: neither localOffset nor globalCount are changed
///   - move: neither localOffset nor globalCount are changed
public struct Subrange<Leaf> {
	/// This is offset for the visible range. When not provided, the `localOffset` is automatically updated by `.scroll` and reset to `0` on `.reload`.
	/// NOTE: `localOffset` doesn't affect the `IndexedMutation` itself (since the mutation operates entirely in local coordinates) but for animation purposes (which typically needs to occur in global coordinates), the `localOffset` is considered to apply *before* the animation (e.g. the scroll position shifts first, then the values in the new locations are updated).
	public let localOffset: Int?
	
	/// This is the length of the greater array after the mutation is applied. When not provided, the `globalCount` is automatically updated by `.insert`, `.delete` and reset to the local count on `.reload`.
	public let globalCount: Int?
	
	/// Additional metadata for this tier
	public let leaf: Leaf?
	
	public init(localOffset: Int?, globalCount: Int?, leaf: Leaf?) {
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
		switch kind {
		case .reload:
			state.localOffset = metadata?.localOffset ?? 0
			state.globalCount = metadata?.globalCount ?? values.count
			state.leaf = metadata?.leaf ?? nil
		case .delete:
			if let localOffset = metadata?.localOffset {
				state.localOffset = localOffset
			}
			state.globalCount = metadata?.globalCount ?? (state.globalCount - indexSet.count)
			if let leaf = metadata?.leaf {
				state.leaf = leaf
			}
		case .insert:
			if let localOffset = metadata?.localOffset {
				state.localOffset = localOffset
			}
			state.globalCount = metadata?.globalCount ?? (state.globalCount + indexSet.count)
			if let leaf = metadata?.leaf {
				state.leaf = leaf
			}
		case .scroll(let offset):
			state.localOffset = metadata?.localOffset ?? (state.localOffset + offset)
			if let globalCount = metadata?.globalCount {
				state.globalCount = globalCount
			}
			if let leaf = metadata?.leaf {
				state.leaf = leaf
			}
		case .update: fallthrough
		case .move:
			if let localOffset = metadata?.localOffset {
				state.localOffset = localOffset
			}
			if let globalCount = metadata?.globalCount {
				state.globalCount = globalCount
			}
			if let leaf = metadata?.leaf {
				state.leaf = leaf
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
