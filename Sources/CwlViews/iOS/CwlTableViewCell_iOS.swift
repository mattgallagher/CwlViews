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

public class TableViewCell: Binder, TableViewCellConvertible {
	public typealias Instance = UITableViewCell
	public typealias Inherited = View
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func construct(reuseIdentifier: String?, additional: ((Instance) -> Lifetime?)? = nil) -> UITableViewCell {
		return binderConstruct(
			additional: additional,
			storageConstructor: { prep, params, i in prep.constructStorage() },
			instanceConstructor: { prep, params in prep.constructInstance(reuseIdentifier: reuseIdentifier, subclass: params.subclass) },
			combine: embedStorageIfInUse,
			output: { i, s in i })
	}
	public func uiTableViewCell(reuseIdentifier: String?) -> UITableViewCell {
		return construct(reuseIdentifier: reuseIdentifier)
	}
	
	enum Binding: TableViewCellBinding {
		public typealias EnclosingBinder = TableViewCell
		public static func tableViewCellBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case cellStyle(Constant<UITableViewCell.CellStyle>)
		case textLabel(Constant<Label>)
		case detailLabel(Constant<Label>)
		case imageView(Constant<ImageView>)
		case contentView(Constant<View>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case backgroundView(Dynamic<ViewConvertible?>)
		case selectedBackgroundView(Dynamic<ViewConvertible?>)
		case multipleSelectionBackgroundView(Dynamic<ViewConvertible?>)
		case accessoryType(Dynamic<UITableViewCell.AccessoryType>)
		case accessoryView(Dynamic<ViewConvertible>)
		case editingAccessoryType(Dynamic<UITableViewCell.AccessoryType>)
		case editingAccessoryView(Dynamic<ViewConvertible>)
		case isSelected(Dynamic<SetOrAnimate<Bool>>)
		case isHighlighted(Dynamic<SetOrAnimate<Bool>>)
		case isEditing(Dynamic<SetOrAnimate<Bool>>)
		case showsReorderControl(Dynamic<Bool>)
		case indentationLevel(Dynamic<Int>)
		case indentationWidth(Dynamic<CGFloat>)
		case shouldIndentWhileEditing(Dynamic<Bool>)
		case separatorInset(Dynamic<UIEdgeInsets>)
		case focusStyle(Dynamic<UITableViewCell.FocusStyle>)
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = TableViewCell
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(style: cellStyle, reuseIdentifier: nil) }
		public func constructInstance(reuseIdentifier: String?, subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(style: cellStyle, reuseIdentifier: reuseIdentifier) }
		
		public init() {}
		
		var cellStyle: UITableViewCell.CellStyle = .default
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .cellStyle(let x): cellStyle = x.value
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .cellStyle: return nil
			case .textLabel(let x):
				if let l = instance.textLabel {
					x.value.applyBindings(to: l)
				}
				return nil
			case .detailLabel(let x):
				if let l = instance.detailTextLabel {
					x.value.applyBindings(to: l)
				}
				return nil
			case .imageView(let x):
				if let l = instance.imageView {
					x.value.applyBindings(to: l)
				}
				return nil
			case .contentView(let x):
				x.value.applyBindings(to: instance.contentView)
				return nil
			case .backgroundView(let x): return x.apply(instance) { i, v in i.backgroundView = v?.uiView() }
			case .selectedBackgroundView(let x): return x.apply(instance) { i, v in i.selectedBackgroundView = v?.uiView() }
			case .multipleSelectionBackgroundView(let x): return x.apply(instance) { i, v in i.multipleSelectionBackgroundView = v?.uiView() }
			case .accessoryType(let x): return x.apply(instance) { i, v in i.accessoryType = v }
			case .accessoryView(let x): return x.apply(instance) { i, v in i.accessoryView = v.uiView() }
			case .editingAccessoryType(let x): return x.apply(instance) { i, v in i.editingAccessoryType = v }
			case .editingAccessoryView(let x): return x.apply(instance) { i, v in i.editingAccessoryView = v.uiView() }
			case .isSelected(let x): return x.apply(instance) { i, v in i.setSelected(v.value, animated: v.isAnimated) }
			case .isHighlighted(let x): return x.apply(instance) { i, v in i.setHighlighted(v.value, animated: v.isAnimated) }
			case .isEditing(let x): return x.apply(instance) { i, v in i.setEditing(v.value, animated: v.isAnimated) }
			case .showsReorderControl(let x): return x.apply(instance) { i, v in i.showsReorderControl = v }
			case .indentationLevel(let x): return x.apply(instance) { i, v in i.indentationLevel = v }
			case .indentationWidth(let x): return x.apply(instance) { i, v in i.indentationWidth = v }
			case .shouldIndentWhileEditing(let x): return x.apply(instance) { i, v in i.shouldIndentWhileEditing = v }
			case .separatorInset(let x): return x.apply(instance) { i, v in i.separatorInset = v }
			case .focusStyle(let x): return x.apply(instance) { i, v in i.focusStyle = v }
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = View.Storage
}

extension BindingName where Binding: TableViewCellBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.$1(v)) }) }
	public static var cellStyle: BindingName<Constant<UITableViewCell.CellStyle>, Binding> { return BindingName<Constant<UITableViewCell.CellStyle>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.cellStyle(v)) }) }
	public static var textLabel: BindingName<Constant<Label>, Binding> { return BindingName<Constant<Label>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.textLabel(v)) }) }
	public static var detailLabel: BindingName<Constant<Label>, Binding> { return BindingName<Constant<Label>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.detailLabel(v)) }) }
	public static var imageView: BindingName<Constant<ImageView>, Binding> { return BindingName<Constant<ImageView>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.imageView(v)) }) }
	public static var contentView: BindingName<Constant<View>, Binding> { return BindingName<Constant<View>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.contentView(v)) }) }
	public static var backgroundView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.backgroundView(v)) }) }
	public static var selectedBackgroundView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.selectedBackgroundView(v)) }) }
	public static var multipleSelectionBackgroundView: BindingName<Dynamic<ViewConvertible?>, Binding> { return BindingName<Dynamic<ViewConvertible?>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.multipleSelectionBackgroundView(v)) }) }
	public static var accessoryType: BindingName<Dynamic<UITableViewCell.AccessoryType>, Binding> { return BindingName<Dynamic<UITableViewCell.AccessoryType>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.accessoryType(v)) }) }
	public static var accessoryView: BindingName<Dynamic<ViewConvertible>, Binding> { return BindingName<Dynamic<ViewConvertible>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.accessoryView(v)) }) }
	public static var editingAccessoryType: BindingName<Dynamic<UITableViewCell.AccessoryType>, Binding> { return BindingName<Dynamic<UITableViewCell.AccessoryType>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.editingAccessoryType(v)) }) }
	public static var editingAccessoryView: BindingName<Dynamic<ViewConvertible>, Binding> { return BindingName<Dynamic<ViewConvertible>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.editingAccessoryView(v)) }) }
	public static var isSelected: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.isSelected(v)) }) }
	public static var isHighlighted: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.isHighlighted(v)) }) }
	public static var isEditing: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.isEditing(v)) }) }
	public static var showsReorderControl: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.showsReorderControl(v)) }) }
	public static var indentationLevel: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.indentationLevel(v)) }) }
	public static var indentationWidth: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.indentationWidth(v)) }) }
	public static var shouldIndentWhileEditing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.shouldIndentWhileEditing(v)) }) }
	public static var separatorInset: BindingName<Dynamic<UIEdgeInsets>, Binding> { return BindingName<Dynamic<UIEdgeInsets>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.separatorInset(v)) }) }
	public static var focusStyle: BindingName<Dynamic<UITableViewCell.FocusStyle>, Binding> { return BindingName<Dynamic<UITableViewCell.FocusStyle>, Binding>({ v in .tableViewCellBinding(TableViewCell.Binding.focusStyle(v)) }) }
}

public protocol TableViewCellConvertible: ViewConvertible {
	func uiTableViewCell(reuseIdentifier: String?) -> UITableViewCell
}
extension TableViewCellConvertible {
	public func uiView() -> UIView { return uiTableViewCell(reuseIdentifier: nil) }
}
extension UITableViewCell: TableViewCellConvertible {
	public func uiTableViewCell(reuseIdentifier: String?) -> UITableViewCell {
		return self
	}
}

public protocol TableViewCellBinding: ViewBinding {
	static func tableViewCellBinding(_ binding: TableViewCell.Binding) -> Self
}
extension TableViewCellBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return tableViewCellBinding(.inheritedBinding(binding))
	}
}

#endif
