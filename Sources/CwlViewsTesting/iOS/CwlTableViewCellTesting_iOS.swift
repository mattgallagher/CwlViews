//
//  CwlTableViewCell_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/27.
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

#if os(iOS)

extension BindingParser where Downcast: TableViewCellBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TableViewCell.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTableViewCellBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var cellStyle: BindingParser<Constant<UITableViewCell.CellStyle>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .cellStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var contentView: BindingParser<Constant<View>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .contentView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var detailLabel: BindingParser<Constant<Label>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .detailLabel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var imageView: BindingParser<Constant<ImageView>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .imageView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var textLabel: BindingParser<Constant<Label>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .textLabel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var accessoryType: BindingParser<Dynamic<UITableViewCell.AccessoryType>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .accessoryType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var accessoryView: BindingParser<Dynamic<ViewConvertible>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .accessoryView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var backgroundView: BindingParser<Dynamic<ViewConvertible?>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .backgroundView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var editingAccessoryType: BindingParser<Dynamic<UITableViewCell.AccessoryType>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .editingAccessoryType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var editingAccessoryView: BindingParser<Dynamic<ViewConvertible>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .editingAccessoryView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var focusStyle: BindingParser<Dynamic<UITableViewCell.FocusStyle>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .focusStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var indentationLevel: BindingParser<Dynamic<Int>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .indentationLevel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var indentationWidth: BindingParser<Dynamic<CGFloat>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .indentationWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var isEditing: BindingParser<Dynamic<SetOrAnimate<Bool>>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .isEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var isHighlighted: BindingParser<Dynamic<SetOrAnimate<Bool>>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .isHighlighted(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var isSelected: BindingParser<Dynamic<SetOrAnimate<Bool>>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .isSelected(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var multipleSelectionBackgroundView: BindingParser<Dynamic<ViewConvertible?>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .multipleSelectionBackgroundView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var selectedBackgroundView: BindingParser<Dynamic<ViewConvertible?>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .selectedBackgroundView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var separatorInset: BindingParser<Dynamic<UIEdgeInsets>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .separatorInset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var shouldIndentWhileEditing: BindingParser<Dynamic<Bool>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .shouldIndentWhileEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	public static var showsReorderControl: BindingParser<Dynamic<Bool>, TableViewCell.Binding, Downcast> { return .init(extract: { if case .showsReorderControl(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTableViewCellBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
