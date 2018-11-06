//
//  CwlTableCellView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 13/11/2015.
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

public class TableCellView: ConstructingBinder, TableCellViewConvertible {
	public typealias Instance = NSTableCellView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsTableCellView() -> Instance { return instance() }
	
	public enum Binding: TableCellViewBinding {
		public typealias EnclosingBinder = TableCellView
		public static func tableCellViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundStyle(Dynamic<NSView.BackgroundStyle>)
		case rowSizeStyle(Dynamic<NSTableView.RowSizeStyle>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = TableCellView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}

		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .backgroundStyle(let x): return x.apply(instance, storage) { i, s, v in i.backgroundStyle = v }
			case .rowSizeStyle(let x): return x.apply(instance, storage) { i, s, v in i.rowSizeStyle = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
}

	public typealias Storage = View.Storage
}

extension BindingName where Binding: TableCellViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tableCellViewBinding(TableCellView.Binding.$1(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundStyle: BindingName<Dynamic<NSView.BackgroundStyle>, Binding> { return BindingName<Dynamic<NSView.BackgroundStyle>, Binding>({ v in .tableCellViewBinding(TableCellView.Binding.backgroundStyle(v)) }) }
	public static var rowSizeStyle: BindingName<Dynamic<NSTableView.RowSizeStyle>, Binding> { return BindingName<Dynamic<NSTableView.RowSizeStyle>, Binding>({ v in .tableCellViewBinding(TableCellView.Binding.rowSizeStyle(v)) }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol TableCellViewConvertible: ViewConvertible {
	func nsTableCellView() -> TableCellView.Instance
}
extension TableCellViewConvertible {
	public func nsView() -> View.Instance { return nsTableCellView() }
}
extension TableCellView.Instance: TableCellViewConvertible {
	public func nsTableCellView() -> TableCellView.Instance { return self }
}

public protocol TableCellViewBinding: ViewBinding {
	static func tableCellViewBinding(_ binding: TableCellView.Binding) -> Self
}
extension TableCellViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return tableCellViewBinding(.inheritedBinding(binding))
	}
}

#endif
