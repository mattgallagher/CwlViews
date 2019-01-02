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

// MARK: - Binder Part 1: Binder
public class TableViewCell: Binder, TableViewCellConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}
extension Binder where Preparer.Binding: TableViewCellBinding, Preparer.Parameters == String? {
	public init(type: Preparer.Instance.Type = Preparer.Instance.self, reuseIdentifier: String? = nil, _ bindings: Preparer.Binding...) {
		self.init(type: type, parameters: reuseIdentifier, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableViewCell {
	enum Binding: TableViewCellBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case cellStyle(Constant<UITableViewCell.CellStyle>)
		case contentView(Constant<View>)
		case detailLabel(Constant<Label>)
		case imageView(Constant<ImageView>)
		case textLabel(Constant<Label>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case accessoryType(Dynamic<UITableViewCell.AccessoryType>)
		case accessoryView(Dynamic<ViewConvertible>)
		case backgroundView(Dynamic<ViewConvertible?>)
		case editingAccessoryType(Dynamic<UITableViewCell.AccessoryType>)
		case editingAccessoryView(Dynamic<ViewConvertible>)
		case focusStyle(Dynamic<UITableViewCell.FocusStyle>)
		case indentationLevel(Dynamic<Int>)
		case indentationWidth(Dynamic<CGFloat>)
		case isEditing(Dynamic<SetOrAnimate<Bool>>)
		case isHighlighted(Dynamic<SetOrAnimate<Bool>>)
		case isSelected(Dynamic<SetOrAnimate<Bool>>)
		case multipleSelectionBackgroundView(Dynamic<ViewConvertible?>)
		case selectedBackgroundView(Dynamic<ViewConvertible?>)
		case separatorInset(Dynamic<UIEdgeInsets>)
		case shouldIndentWhileEditing(Dynamic<Bool>)
		case showsReorderControl(Dynamic<Bool>)
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableViewCell {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = TableViewCell.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UITableViewCell
		public typealias Parameters = String?
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var cellStyle: UITableViewCell.CellStyle = .default
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableViewCell.Preparer {
	func constructInstance(type: Instance.Type, parameters: String?) -> Instance {
		return type.init(style: cellStyle, reuseIdentifier: parameters)
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .cellStyle(let x): cellStyle = x.value
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .cellStyle: return nil
		case .contentView(let x):
			x.value.apply(to: instance.contentView)
			return nil
		case .detailLabel(let x):
			if let l = instance.detailTextLabel {
				x.value.apply(to: l)
			}
			return nil
		case .imageView(let x):
			if let l = instance.imageView {
				x.value.apply(to: l)
			}
			return nil
		case .textLabel(let x):
			if let l = instance.textLabel {
				x.value.apply(to: l)
			}
			return nil
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .accessoryType(let x): return x.apply(instance) { i, v in i.accessoryType = v }
		case .accessoryView(let x): return x.apply(instance) { i, v in i.accessoryView = v.uiView() }
		case .backgroundView(let x): return x.apply(instance) { i, v in i.backgroundView = v?.uiView() }
		case .editingAccessoryType(let x): return x.apply(instance) { i, v in i.editingAccessoryType = v }
		case .editingAccessoryView(let x): return x.apply(instance) { i, v in i.editingAccessoryView = v.uiView() }
		case .focusStyle(let x): return x.apply(instance) { i, v in i.focusStyle = v }
		case .indentationLevel(let x): return x.apply(instance) { i, v in i.indentationLevel = v }
		case .indentationWidth(let x): return x.apply(instance) { i, v in i.indentationWidth = v }
		case .isEditing(let x): return x.apply(instance) { i, v in i.setEditing(v.value, animated: v.isAnimated) }
		case .isHighlighted(let x): return x.apply(instance) { i, v in i.setHighlighted(v.value, animated: v.isAnimated) }
		case .isSelected(let x): return x.apply(instance) { i, v in i.setSelected(v.value, animated: v.isAnimated) }
		case .multipleSelectionBackgroundView(let x): return x.apply(instance) { i, v in i.multipleSelectionBackgroundView = v?.uiView() }
		case .selectedBackgroundView(let x): return x.apply(instance) { i, v in i.selectedBackgroundView = v?.uiView() }
		case .separatorInset(let x): return x.apply(instance) { i, v in i.separatorInset = v }
		case .shouldIndentWhileEditing(let x): return x.apply(instance) { i, v in i.shouldIndentWhileEditing = v }
		case .showsReorderControl(let x): return x.apply(instance) { i, v in i.showsReorderControl = v }
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableViewCell.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TableViewCellBinding {
	public typealias TableViewCellName<V> = BindingName<V, TableViewCell.Binding, Binding>
	private typealias B = TableViewCell.Binding
	private static func name<V>(_ source: @escaping (V) -> TableViewCell.Binding) -> TableViewCellName<V> {
		return TableViewCellName<V>(source: source, downcast: Binding.tableViewCellBinding)
	}
}
public extension BindingName where Binding: TableViewCellBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableViewCellName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var cellStyle: TableViewCellName<Constant<UITableViewCell.CellStyle>> { return .name(B.cellStyle) }
	static var contentView: TableViewCellName<Constant<View>> { return .name(B.contentView) }
	static var detailLabel: TableViewCellName<Constant<Label>> { return .name(B.detailLabel) }
	static var imageView: TableViewCellName<Constant<ImageView>> { return .name(B.imageView) }
	static var textLabel: TableViewCellName<Constant<Label>> { return .name(B.textLabel) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var accessoryType: TableViewCellName<Dynamic<UITableViewCell.AccessoryType>> { return .name(B.accessoryType) }
	static var accessoryView: TableViewCellName<Dynamic<ViewConvertible>> { return .name(B.accessoryView) }
	static var backgroundView: TableViewCellName<Dynamic<ViewConvertible?>> { return .name(B.backgroundView) }
	static var editingAccessoryType: TableViewCellName<Dynamic<UITableViewCell.AccessoryType>> { return .name(B.editingAccessoryType) }
	static var editingAccessoryView: TableViewCellName<Dynamic<ViewConvertible>> { return .name(B.editingAccessoryView) }
	static var focusStyle: TableViewCellName<Dynamic<UITableViewCell.FocusStyle>> { return .name(B.focusStyle) }
	static var indentationLevel: TableViewCellName<Dynamic<Int>> { return .name(B.indentationLevel) }
	static var indentationWidth: TableViewCellName<Dynamic<CGFloat>> { return .name(B.indentationWidth) }
	static var isEditing: TableViewCellName<Dynamic<SetOrAnimate<Bool>>> { return .name(B.isEditing) }
	static var isHighlighted: TableViewCellName<Dynamic<SetOrAnimate<Bool>>> { return .name(B.isHighlighted) }
	static var isSelected: TableViewCellName<Dynamic<SetOrAnimate<Bool>>> { return .name(B.isSelected) }
	static var multipleSelectionBackgroundView: TableViewCellName<Dynamic<ViewConvertible?>> { return .name(B.multipleSelectionBackgroundView) }
	static var selectedBackgroundView: TableViewCellName<Dynamic<ViewConvertible?>> { return .name(B.selectedBackgroundView) }
	static var separatorInset: TableViewCellName<Dynamic<UIEdgeInsets>> { return .name(B.separatorInset) }
	static var shouldIndentWhileEditing: TableViewCellName<Dynamic<Bool>> { return .name(B.shouldIndentWhileEditing) }
	static var showsReorderControl: TableViewCellName<Dynamic<Bool>> { return .name(B.showsReorderControl) }
	
	//	2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableViewCellConvertible: ViewConvertible {
	func uiTableViewCell(reuseIdentifier: String?) -> TableViewCell.Instance
}
extension TableViewCellConvertible {
	public func uiTableViewCell() -> TableViewCell.Instance { return uiTableViewCell(reuseIdentifier: nil) }
	public func uiView() -> View.Instance { return uiTableViewCell() }
}
extension UITableViewCell: TableViewCellConvertible {
	public func uiTableViewCell(reuseIdentifier: String?) -> TableViewCell.Instance { return self }
}
public extension TableViewCell {
	func uiTableViewCell(reuseIdentifier: String?) -> TableViewCell.Instance { return instance(parameters: reuseIdentifier) }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableViewCellBinding: ViewBinding {
	static func tableViewCellBinding(_ binding: TableViewCell.Binding) -> Self
}
public extension TableViewCellBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return tableViewCellBinding(.inheritedBinding(binding))
	}
}
public extension TableViewCell.Binding {
	public typealias Preparer = TableViewCell.Preparer
	static func tableViewCellBinding(_ binding: TableViewCell.Binding) -> TableViewCell.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
