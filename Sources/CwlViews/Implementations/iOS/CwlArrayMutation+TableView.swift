//
//  CwlArrayMutation+TableView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 1/1/19.
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

#if os(iOS)

extension ArrayMutation {
	public func rowMutation(header: String? = nil, footer: String? = nil) -> TableRowMutation<Element> {
		return rangeMutation(metadata: TableSectionMetadata(header: header, footer: footer))
	}
	
	public func tableData(header: String? = nil, footer: String? = nil) -> TableSectionMutation<Element> {
		return rangeMutation().tableData(header: header, footer: footer)
	}
}

extension RangeMutation {
	public func rowMutation(header: String? = nil, footer: String? = nil) -> TableRowMutation<Element> {
		return TableRowMutation(metadata: TableSectionMetadata(header: header, footer: footer), rangeMutation: self)
	}
	
	public func tableData(header: String? = nil, footer: String? = nil) -> TableSectionMutation<Element> {
		return sectionMutation(header: header, footer: footer).tableData()
	}
}

extension TableSectionMutation {
	public func tableData() -> RangeMutation<TableSectionMutation<Element>> {
		return RangeMutation(array: [self])
	}
}

extension RangeMutation {
	public static func tableData<RowData>(sections: [TableSectionMutation<RowData>]) -> TableData<RowData> where TableSectionMutation<RowData> == Element {
		return RangeMutation(array: sections)
	}
	
	public static func tableDataFromSections<RowData>(_ sections: TableSectionMutation<RowData>...) -> TableData<RowData> where TableSectionMutation<RowData> == Element {
		return RangeMutation(array: sections)
	}
}

extension SignalInterface {
	public func arrayMutationToSectionMutation<Element>(header: String? = nil, footer: String? = nil) -> Signal<TableSectionMutation<Element>> where ArrayMutation<Element> == OutputElement {
		return map(initialState: 0) { (globalCount: inout Int, arrayMutation: ArrayMutation<Element>) -> TableSectionMutation<Element> in
			arrayMutation.delta(&globalCount)
			return TableSectionMutation(header: header, footer: footer, rangeMutation: RangeMutation(arrayMutation: arrayMutation, localOffset: 0, globalCount: globalCount))
		}
	}
	
	public func tableData<Element>() -> Signal<TableData<Element>> where ArrayMutation<Element> == OutputElement {
		return Signal.sections(Signal.section(rowSignal: signal.map(initialState: 0) { (globalCount: inout Int, arrayMutation: ArrayMutation<Element>) -> RangeMutation<Element> in
			arrayMutation.delta(&globalCount)
			return RangeMutation(arrayMutation: arrayMutation, localOffset: 0, globalCount: globalCount)
		})
		)
	}
	
	public static func sections<RowData>(signals: [Signal<TableSectionMutation<RowData>>]) -> Signal<RangeMutation<TableSectionMutation<RowData>>> where RangeMutation<TableSectionMutation<RowData>> == OutputElement {
		var result: [Signal<RangeMutation<TableSectionMutation<RowData>>>] = []
		let count = signals.count
		for (index, sectionSignal) in signals.enumerated() {
			result += sectionSignal.map { section in
				let mutation = ArrayMutation<TableSectionMutation<RowData>>(updatedIndex: index, value: section)
				return RangeMutation(arrayMutation: mutation, localOffset: 0, globalCount: count)
			}
		}
		let sections = RangeMutation<TableSectionMutation<RowData>>(arrayMutation: ArrayMutation(insertedRange: 0..<signals.count, values: Array<TableSectionMutation<RowData>>(repeating: TableSectionMutation<RowData>(), count: signals.count)), localOffset: 0, globalCount: signals.count)
		let (mergedInput, mergedSignal) = Signal<RangeMutation<TableSectionMutation<RowData>>>.createMergedInput()
		for s in result {
			mergedInput.add(s)
		}
		return mergedSignal.startWith(sequence: [sections])
	}
	
	public static func sections<RowData>(_ signals: Signal<TableSectionMutation<RowData>>...) -> Signal<RangeMutation<TableSectionMutation<RowData>>> where RangeMutation<TableSectionMutation<RowData>> == OutputElement {
		return sections(signals: signals)
	}
	
	public static func section<Element>(header: String? = nil, footer: String? = nil, rowSignal: Signal<RangeMutation<Element>>) -> Signal<OutputElement> where TableSectionMutation<Element> == OutputElement {
		return rowSignal.map(initialState: false) { (state: inout Bool, value: RangeMutation<Element>) -> TableSectionMutation<Element> in
			if !state {
				state = true
				return TableSectionMutation<Element>(header: header, footer: footer, rangeMutation: value)
			} else {
				return TableSectionMutation<Element>(rangeMutation: value)
			}
		}
	}
}

#endif
