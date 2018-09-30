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
	
#if os(iOS)
	public func sectionMutation(header: String? = nil, footer: String? = nil) -> TableSectionMutation<Element> {
		return rowMutation().sectionMutation(header: header, footer: footer)
	}
	public func tableData(header: String? = nil, footer: String? = nil) -> TableData<Element> {
		return rowMutation().sectionMutation(header: header, footer: footer).tableData()
	}
#endif
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
	
#if os(iOS)
	public func sectionMutation(header: String? = nil, footer: String? = nil) -> TableSectionMutation<Value> {
		return rowMutation().sectionMutation(header: header, footer: footer)
	}
	
	public func tableData(header: String? = nil, footer: String? = nil) -> TableData<Value> {
		return rowMutation().sectionMutation(header: header, footer: footer).tableData()
	}
#endif
}

#if os(iOS)
extension TableRowMutation {
	public func sectionMutation(header: String? = nil, footer: String? = nil) -> TableSectionMutation<Value> {
		return TableSectionMutation(header: header, footer: footer, rowMutation: self)
	}
	
	public func tableData(header: String? = nil, footer: String? = nil) -> TableData<Value> {
		return sectionMutation(header: header, footer: footer).tableData()
	}
}

extension TableSectionMutation {
	public func tableData() -> TableRowMutation<TableSectionMutation<Value>> {
		return TableRowMutation(array: [self])
	}
}

extension TableRowMutation {
	public static func tableData<RowData>(sections: [TableSectionMutation<RowData>]) -> TableData<RowData> where TableSectionMutation<RowData> == Value {
		return TableRowMutation(array: sections)
	}

	public static func tableDataFromSections<RowData>(_ sections: TableSectionMutation<RowData>...) -> TableData<RowData> where TableSectionMutation<RowData> == Value {
		return TableRowMutation(array: sections)
	}
}
#endif

extension SignalInterface {
	public func arrayMutationToRowMutation<Value>() -> Signal<TableRowMutation<Value>> where ArrayMutation<Value> == OutputValue {
		return map(initialState: 0) { (globalCount: inout Int, arrayMutation: ArrayMutation<Value>) -> TableRowMutation<Value> in
			arrayMutation.delta(&globalCount)
			return TableRowMutation(arrayMutation: arrayMutation, localOffset: 0, globalCount: globalCount)
		}
	}
	
#if os(iOS)
	public func arrayMutationToSectionMutation<Value>(header: String? = nil, footer: String? = nil) -> Signal<TableSectionMutation<Value>> where ArrayMutation<Value> == OutputValue {
		return map(initialState: 0) { (globalCount: inout Int, arrayMutation: ArrayMutation<Value>) -> TableSectionMutation<Value> in
			arrayMutation.delta(&globalCount)
			return TableSectionMutation(header: header, footer: footer, rowMutation: TableRowMutation(arrayMutation: arrayMutation, localOffset: 0, globalCount: globalCount))
		}
	}

	public func tableData<Value>() -> Signal<TableData<Value>> where ArrayMutation<Value> == OutputValue {
		return Signal.sections(Signal.section(rowSignal: signal.map(initialState: 0) { (globalCount: inout Int, arrayMutation: ArrayMutation<Value>) -> TableRowMutation<Value> in
				arrayMutation.delta(&globalCount)
				return TableRowMutation(arrayMutation: arrayMutation, localOffset: 0, globalCount: globalCount)
			})
		)
	}
	
	public static func sections<RowData>(signals: [Signal<TableSectionMutation<RowData>>]) -> Signal<TableRowMutation<TableSectionMutation<RowData>>> where TableRowMutation<TableSectionMutation<RowData>> == OutputValue {
		var result: [Signal<TableRowMutation<TableSectionMutation<RowData>>>] = []
		let count = signals.count
		for (index, sectionSignal) in signals.enumerated() {
			result += sectionSignal.map { section in
				let mutation = ArrayMutation<TableSectionMutation<RowData>>(updatedIndex: index, value: section)
				return TableRowMutation(arrayMutation: mutation, localOffset: 0, globalCount: count, animation: noTableViewAnimation)
			}
		}
		let sections = TableRowMutation<TableSectionMutation<RowData>>(arrayMutation: ArrayMutation(insertedRange: 0..<signals.count, values: Array<TableSectionMutation<RowData>>(repeating: TableSectionMutation<RowData>(), count: signals.count)), localOffset: 0, globalCount: signals.count)
		let (mergedInput, mergedSignal) = Signal<TableRowMutation<TableSectionMutation<RowData>>>.createMergedInput()
		for s in result {
			mergedInput.add(s)
		}
		return mergedSignal.startWith(sequence: [sections])
	}

	public static func sections<RowData>(_ signals: Signal<TableSectionMutation<RowData>>...) -> Signal<TableRowMutation<TableSectionMutation<RowData>>> where TableRowMutation<TableSectionMutation<RowData>> == OutputValue {
		return sections(signals: signals)
	}

	public static func section<Value>(header: String? = nil, footer: String? = nil, rowSignal: Signal<TableRowMutation<Value>>) -> Signal<OutputValue> where TableSectionMutation<Value> == OutputValue {
		return rowSignal.map(initialState: false) { (state: inout Bool, value: TableRowMutation<Value>) -> TableSectionMutation<Value> in
			if !state {
				state = true
				return TableSectionMutation<Value>(header: header, footer: footer, rowMutation: value)
			} else {
				return TableSectionMutation<Value>(rowMutation: value)
			}
		}
	}
#endif
}
