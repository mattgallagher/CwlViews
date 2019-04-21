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

extension BindingParser where Binding == TableViewCell.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var cellStyle: BindingParser<Constant<UITableViewCell.CellStyle>, Binding> { return BindingParser<Constant<UITableViewCell.CellStyle>, Binding>(parse: { binding -> Optional<Constant<UITableViewCell.CellStyle>> in if case .cellStyle(let x) = binding { return x } else { return nil } }) }
	public static var contentView: BindingParser<Constant<View>, Binding> { return BindingParser<Constant<View>, Binding>(parse: { binding -> Optional<Constant<View>> in if case .contentView(let x) = binding { return x } else { return nil } }) }
	public static var detailLabel: BindingParser<Constant<Label>, Binding> { return BindingParser<Constant<Label>, Binding>(parse: { binding -> Optional<Constant<Label>> in if case .detailLabel(let x) = binding { return x } else { return nil } }) }
	public static var imageView: BindingParser<Constant<ImageView>, Binding> { return BindingParser<Constant<ImageView>, Binding>(parse: { binding -> Optional<Constant<ImageView>> in if case .imageView(let x) = binding { return x } else { return nil } }) }
	public static var textLabel: BindingParser<Constant<Label>, Binding> { return BindingParser<Constant<Label>, Binding>(parse: { binding -> Optional<Constant<Label>> in if case .textLabel(let x) = binding { return x } else { return nil } }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var accessoryType: BindingParser<Dynamic<UITableViewCell.AccessoryType>, Binding> { return BindingParser<Dynamic<UITableViewCell.AccessoryType>, Binding>(parse: { binding -> Optional<Dynamic<UITableViewCell.AccessoryType>> in if case .accessoryType(let x) = binding { return x } else { return nil } }) }
	public static var accessoryView: BindingParser<Dynamic<ViewConvertible>, Binding> { return BindingParser<Dynamic<ViewConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible>> in if case .accessoryView(let x) = binding { return x } else { return nil } }) }
	public static var backgroundView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .backgroundView(let x) = binding { return x } else { return nil } }) }
	public static var editingAccessoryType: BindingParser<Dynamic<UITableViewCell.AccessoryType>, Binding> { return BindingParser<Dynamic<UITableViewCell.AccessoryType>, Binding>(parse: { binding -> Optional<Dynamic<UITableViewCell.AccessoryType>> in if case .editingAccessoryType(let x) = binding { return x } else { return nil } }) }
	public static var editingAccessoryView: BindingParser<Dynamic<ViewConvertible>, Binding> { return BindingParser<Dynamic<ViewConvertible>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible>> in if case .editingAccessoryView(let x) = binding { return x } else { return nil } }) }
	public static var focusStyle: BindingParser<Dynamic<UITableViewCell.FocusStyle>, Binding> { return BindingParser<Dynamic<UITableViewCell.FocusStyle>, Binding>(parse: { binding -> Optional<Dynamic<UITableViewCell.FocusStyle>> in if case .focusStyle(let x) = binding { return x } else { return nil } }) }
	public static var indentationLevel: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .indentationLevel(let x) = binding { return x } else { return nil } }) }
	public static var indentationWidth: BindingParser<Dynamic<CGFloat>, Binding> { return BindingParser<Dynamic<CGFloat>, Binding>(parse: { binding -> Optional<Dynamic<CGFloat>> in if case .indentationWidth(let x) = binding { return x } else { return nil } }) }
	public static var isEditing: BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Bool>>> in if case .isEditing(let x) = binding { return x } else { return nil } }) }
	public static var isHighlighted: BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Bool>>> in if case .isHighlighted(let x) = binding { return x } else { return nil } }) }
	public static var isSelected: BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Bool>>> in if case .isSelected(let x) = binding { return x } else { return nil } }) }
	public static var multipleSelectionBackgroundView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .multipleSelectionBackgroundView(let x) = binding { return x } else { return nil } }) }
	public static var selectedBackgroundView: BindingParser<Dynamic<ViewConvertible?>, Binding> { return BindingParser<Dynamic<ViewConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<ViewConvertible?>> in if case .selectedBackgroundView(let x) = binding { return x } else { return nil } }) }
	public static var separatorInset: BindingParser<Dynamic<UIEdgeInsets>, Binding> { return BindingParser<Dynamic<UIEdgeInsets>, Binding>(parse: { binding -> Optional<Dynamic<UIEdgeInsets>> in if case .separatorInset(let x) = binding { return x } else { return nil } }) }
	public static var shouldIndentWhileEditing: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .shouldIndentWhileEditing(let x) = binding { return x } else { return nil } }) }
	public static var showsReorderControl: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsReorderControl(let x) = binding { return x } else { return nil } }) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
