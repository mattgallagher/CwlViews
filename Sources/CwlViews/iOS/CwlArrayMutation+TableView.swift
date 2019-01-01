//
//  CwlArrayMutation+TableView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 1/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)

extension Sequence {
	public func sectionMutation(header: String? = nil, footer: String? = nil) -> TableSectionMutation<Element> {
		return rowMutation().sectionMutation(header: header, footer: footer)
	}
	public func tableData(header: String? = nil, footer: String? = nil) -> TableData<Element> {
		return rowMutation().sectionMutation(header: header, footer: footer).tableData()
	}
}

extension ArrayMutation {
	public func sectionMutation(header: String? = nil, footer: String? = nil) -> TableSectionMutation<Value> {
		return rowMutation().sectionMutation(header: header, footer: footer)
	}
	
	public func tableData(header: String? = nil, footer: String? = nil) -> TableData<Value> {
		return rowMutation().sectionMutation(header: header, footer: footer).tableData()
	}
}

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

extension SignalInterface {
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
}

#endif
