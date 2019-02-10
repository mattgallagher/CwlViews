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

// MARK: - Binder Part 1: Binder
public class TableCellView: Binder, TableCellViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableCellView {
	enum Binding: TableCellViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundStyle(Dynamic<NSView.BackgroundStyle>)
		case rowSizeStyle(Dynamic<NSTableView.RowSizeStyle>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableCellView {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = TableCellView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSTableCellView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableCellView.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .backgroundStyle(let x): return x.apply(instance) { i, v in i.backgroundStyle = v }
		case .rowSizeStyle(let x): return x.apply(instance) { i, v in i.rowSizeStyle = v }

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableCellView.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TableCellViewBinding {
	public typealias TableCellViewName<V> = BindingName<V, TableCellView.Binding, Binding>
	private typealias B = TableCellView.Binding
	private static func name<V>(_ source: @escaping (V) -> TableCellView.Binding) -> TableCellViewName<V> {
		return TableCellViewName<V>(source: source, downcast: Binding.tableCellViewBinding)
	}
}
public extension BindingName where Binding: TableCellViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableCellViewName<$2> { return .name(B.$1) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backgroundStyle: TableCellViewName<Dynamic<NSView.BackgroundStyle>> { return .name(B.backgroundStyle) }
	static var rowSizeStyle: TableCellViewName<Dynamic<NSTableView.RowSizeStyle>> { return .name(B.rowSizeStyle) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableCellViewConvertible: ViewConvertible {
	func nsTableCellView() -> TableCellView.Instance
}
extension TableCellViewConvertible {
	public func nsView() -> View.Instance { return nsTableCellView() }
}
extension NSTableCellView: TableCellViewConvertible {
	public func nsTableCellView() -> TableCellView.Instance { return self }
}
public extension TableCellView {
	func nsTableCellView() -> TableCellView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableCellViewBinding: ViewBinding {
	static func tableCellViewBinding(_ binding: TableCellView.Binding) -> Self
}
public extension TableCellViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return tableCellViewBinding(.inheritedBinding(binding))
	}
}
public extension TableCellView.Binding {
	typealias Preparer = TableCellView.Preparer
	static func tableCellViewBinding(_ binding: TableCellView.Binding) -> TableCellView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
