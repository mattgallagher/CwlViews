//
//  CwlArrayMutationUtilities.swift
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

extension Sequence {
	public func arrayMutation() -> ArrayMutation<Element> {
		return .reload(self)
	}
	
	public func rowMutation() -> TableRowMutation<Element> {
		return TableRowMutation(arrayMutation: arrayMutation())
	}
}

extension ArrayMutation {
	/// Construct a mutation that represents the insertion of a value at an index.
	public static func inserted(_ value: Value, at index: Int) -> ArrayMutation<Value> {
		return ArrayMutation(insertedIndex: index, value: value)
	}

	/// Construct a mutation that discards any previous history and simply starts with a completely new array.
	public static func reload<S: Sequence>(_ values: S) -> ArrayMutation<Value> where S.Element == Value {
		return ArrayMutation(reload: Array(values))
	}

	/// Construct a mutation that represents the update of a value at an index.
	public static func updated(_ value: Value, at index: Int) -> ArrayMutation<Value> {
		return ArrayMutation(updatedIndex: index, value: value)
	}

	/// Construct a mutation that represents the update of a value at an index.
	public static func moved(from sourceIndex: Int, to targetIndex: Int) -> ArrayMutation<Value> {
		return ArrayMutation(movedIndex: sourceIndex, targetIndex: targetIndex)
	}
	
	public func rowMutation() -> TableRowMutation<Value> {
		return TableRowMutation(arrayMutation: self)
	}
}

extension SignalInterface {
	public func arrayMutationToRowMutation<Value>() -> Signal<TableRowMutation<Value>> where ArrayMutation<Value> == OutputValue {
		return map(initialState: 0) { (globalCount: inout Int, arrayMutation: ArrayMutation<Value>) -> TableRowMutation<Value> in
			arrayMutation.delta(&globalCount)
			return TableRowMutation(arrayMutation: arrayMutation, localOffset: 0, globalCount: globalCount)
		}
	}
}
