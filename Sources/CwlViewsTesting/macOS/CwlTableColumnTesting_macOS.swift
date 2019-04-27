//
//  CwlTableColumn_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 29/10/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

#if os(macOS)

extension BindingParser where Downcast: TableColumnBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTableColumnBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var identifier: BindingParser<Constant<NSUserInterfaceItemIdentifier>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .identifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var headerCell: BindingParser<Dynamic<NSTableHeaderCell>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .headerCell(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var headerToolTip: BindingParser<Dynamic<String?>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .headerToolTip(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .isEditable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .isHidden(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var maxWidth: BindingParser<Dynamic<CGFloat>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .maxWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var minWidth: BindingParser<Dynamic<CGFloat>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .minWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var resizingMask: BindingParser<Dynamic<NSTableColumn.ResizingOptions>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .resizingMask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var sortDescriptorPrototype: BindingParser<Dynamic<NSSortDescriptor?>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sortDescriptorPrototype(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var sortFunction: BindingParser<Dynamic<(_ isRow: Downcast.RowDataType, _ orderedBefore: Downcast.RowDataType) -> Bool>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sortFunction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var title: BindingParser<Dynamic<String>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var width: BindingParser<Dynamic<CGFloat>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .width(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var sizeToFit: BindingParser<Signal<Void>, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .sizeToFit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var cellConstructor: BindingParser<(_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: SignalMulti<Downcast.RowDataType>) -> TableCellViewConvertible, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .cellConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var cellIdentifierForRow: BindingParser<(Downcast.RowDataType?) -> NSUserInterfaceItemIdentifier, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .cellIdentifierForRow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
	public static var dataMissingCell: BindingParser<() -> TableCellViewConvertible?, TableColumn<Downcast.RowDataType>.Binding, Downcast> { return .init(extract: { if case .dataMissingCell(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableColumnBinding() }) }
}

#endif
