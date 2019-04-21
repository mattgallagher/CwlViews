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

extension BindingParser where Binding: TableColumnBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<$2, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var identifier: BindingParser<Constant<NSUserInterfaceItemIdentifier>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Constant<NSUserInterfaceItemIdentifier>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Constant<NSUserInterfaceItemIdentifier>> in if case .identifier(let x) = binding { return x } else { return nil } }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var headerCell: BindingParser<Dynamic<NSTableHeaderCell>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<NSTableHeaderCell>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<NSTableHeaderCell>> in if case .headerCell(let x) = binding { return x } else { return nil } }) }
	public static var headerToolTip: BindingParser<Dynamic<String?>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<String?>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<String?>> in if case .headerToolTip(let x) = binding { return x } else { return nil } }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<Bool>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEditable(let x) = binding { return x } else { return nil } }) }
	public static var isHidden: BindingParser<Dynamic<Bool>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<Bool>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isHidden(let x) = binding { return x } else { return nil } }) }
	public static var maxWidth: BindingParser<Dynamic<CGFloat>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<CGFloat>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .maxWidth(let x) = binding { return x } else { return nil } }) }
	public static var minWidth: BindingParser<Dynamic<CGFloat>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<CGFloat>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .minWidth(let x) = binding { return x } else { return nil } }) }
	public static var resizingMask: BindingParser<Dynamic<NSTableColumn.ResizingOptions>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<NSTableColumn.ResizingOptions>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<NSTableColumn.ResizingOptions>> in if case .resizingMask(let x) = binding { return x } else { return nil } }) }
	public static var sortDescriptorPrototype: BindingParser<Dynamic<NSSortDescriptor?>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<NSSortDescriptor?>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<NSSortDescriptor?>> in if case .sortDescriptorPrototype(let x) = binding { return x } else { return nil } }) }
	public static var sortFunction: BindingParser<Dynamic<(_ isRow: Binding.RowDataType, _ orderedBefore: Binding.RowDataType) -> Bool>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<(_ isRow: Binding.RowDataType, _ orderedBefore: Binding.RowDataType) -> Bool>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<(_ isRow: Binding.RowDataType, _ orderedBefore: Binding.RowDataType) -> Bool>> in if case .sortFunction(let x) = binding { return x } else { return nil } }) }
	public static var title: BindingParser<Dynamic<String>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<String>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .title(let x) = binding { return x } else { return nil } }) }
	public static var width: BindingParser<Dynamic<CGFloat>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Dynamic<CGFloat>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .width(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var sizeToFit: BindingParser<Signal<Void>, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<Signal<Void>, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<Signal<Void>> in if case .sizeToFit(let x) = binding { return x } else { return nil } }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var cellConstructor: BindingParser<(_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: Signal<Binding.RowDataType>) -> TableCellViewConvertible, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<(_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: Signal<Binding.RowDataType>) -> TableCellViewConvertible, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<(_ identifier: NSUserInterfaceItemIdentifier, _ rowSignal: Signal<Binding.RowDataType>) -> TableCellViewConvertible> in if case .cellConstructor(let x) = binding { return x } else { return nil } }) }
	public static var cellIdentifierForRow: BindingParser<(Binding.RowDataType?) -> NSUserInterfaceItemIdentifier, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<(Binding.RowDataType?) -> NSUserInterfaceItemIdentifier, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<(Binding.RowDataType?) -> NSUserInterfaceItemIdentifier> in if case .cellIdentifierForRow(let x) = binding { return x } else { return nil } }) }
	public static var dataMissingCell: BindingParser<() -> TableCellViewConvertible?, TableColumn<Binding.RowDataType>.Binding> { return BindingParser<() -> TableCellViewConvertible?, TableColumn<Binding.RowDataType>.Binding>(parse: { binding -> Optional<() -> TableCellViewConvertible?> in if case .dataMissingCell(let x) = binding { return x } else { return nil } }) }
}

#endif
