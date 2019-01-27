//
//  CwlSetMutation.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/12/25.
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

import Foundation

public enum SetMutationKind {
	case delete
	case insert
	case update
	case reload
}

public struct SetMutation<Element> {
	public let kind: SetMutationKind
	public let values: Array<Element>
	
	public init(kind: SetMutationKind, values: Array<Element>) {
		self.kind = kind
		self.values = values
	}
	
	public static func delete(_ values: Array<Element>) -> SetMutation<Element> {
		return SetMutation(kind: .delete, values: values)
	}
	
	public static func insert(_ values: Array<Element>) -> SetMutation<Element> {
		return SetMutation(kind: .insert, values: values)
	}
	
	public static func update(_ values: Array<Element>) -> SetMutation<Element> {
		return SetMutation(kind: .update, values: values)
	}
	
	public static func reload(_ values: Array<Element>) -> SetMutation<Element> {
		return SetMutation(kind: .reload, values: values)
	}
	
	public func apply(to array: inout Array<Element>, equate: @escaping (Element, Element) -> Bool, compare: @escaping (Element, Element) -> Bool) -> [ArrayMutation<Element>] {
		switch kind {
		case .delete:
			var sorted = values.sorted(by: compare)
			var oldIndices = IndexSet()
			var arrayIndex = 0
			var sortedIndex = 0
			while arrayIndex < array.count && sortedIndex < sorted.count {
				if !equate(array[arrayIndex], sorted[sortedIndex]) {
					arrayIndex += 1
				} else {
					oldIndices.insert(arrayIndex)
					sortedIndex += 1
					arrayIndex += 1
				}
			}
			precondition(sortedIndex == sorted.count, "Unable to find deleted items.")
			oldIndices.reversed().forEach { array.remove(at: $0) }
			return [ArrayMutation<Element>(deletedIndexSet: oldIndices)]
		case .insert:
			var sorted = values.sorted(by: compare)
			var newIndices = IndexSet()
			var arrayIndex = 0
			var sortedIndex = 0
			while arrayIndex < array.count && sortedIndex < sorted.count {
				if compare(array[arrayIndex], sorted[sortedIndex]) {
					arrayIndex += 1
				} else {
					newIndices.insert(arrayIndex)
					array.insert(sorted[sortedIndex], at: arrayIndex)
					sortedIndex += 1
					arrayIndex += 1
				}
			}
			while sortedIndex < sorted.count {
				newIndices.insert(arrayIndex)
				array.insert(sorted[sortedIndex], at: arrayIndex)
				sortedIndex += 1
				arrayIndex += 1
			}
			return [ArrayMutation<Element>(insertedIndexSet: newIndices, values: sorted)]
		case .update:
			// It would be nice if this was better than n squared complexity and aggregated the updates, rather than issueing updates for individual rows.
			var result = Array<ArrayMutation<Element>>()
			for v in values {
				let oldIndex = array.index { u in equate(v, u) }!
				array.remove(at: oldIndex)
				let newIndex = array.index { u in compare(v, u) } ?? array.count
				array.insert(v, at: newIndex)
				if newIndex == oldIndex {
					result.append(.updated(v, at: oldIndex))
				} else {
					// This ordering (moved, then updated) is required to make UITableView animations work correctly.
					result.append(.moved(from: oldIndex, to: newIndex))
					result.append(.updated(v, at: newIndex))
				}
			}
			return result
		case .reload:
			array = values.sorted(by: compare)
			return [ArrayMutation<Element>(reload: array)]
		}
	}
}

extension SignalInterface {
	public func sortedArrayMutation<Element>(equate: @escaping (Element, Element) -> Bool, compare: @escaping (Element, Element) -> Bool) -> Signal<ArrayMutation<Element>> where SetMutation<Element> == OutputValue {
		return transform(initialState: Array<Element>()) { (array: inout Array<Element>, result: Signal<SetMutation<Element>>.Result) in
			switch result {
			case .success(let m): return .values(sequence: m.apply(to: &array, equate: equate, compare: compare))
			case .failure(let e): return .end(e)
			}
		}
	}
}
