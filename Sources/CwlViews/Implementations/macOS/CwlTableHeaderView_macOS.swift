//
//  CwlTableHeaderView_macOS.swift
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

// MARK: - Binder Part 1: Binder
public class TableHeaderView: Binder, TableHeaderViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableHeaderView {
	enum Binding: TableHeaderViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableHeaderView {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = TableHeaderView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSTableHeaderView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableHeaderView {
}


// MARK: - Binder Part 5: Storage and Delegate
extension TableHeaderView.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TableHeaderViewBinding {
	public typealias TableHeaderViewName<V> = BindingName<V, TableHeaderView.Binding, Binding>
	private typealias B = TableHeaderView.Binding
	private static func name<V>(_ source: @escaping (V) -> TableHeaderView.Binding) -> TableHeaderViewName<V> {
		return TableHeaderViewName<V>(source: source, downcast: Binding.tableHeaderViewBinding)
	}
}
public extension BindingName where Binding: TableHeaderViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableHeaderViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableHeaderViewConvertible: ViewConvertible {
	func nsTableHeaderView() -> TableHeaderView.Instance
}
extension TableHeaderViewConvertible {
	public func nsView() -> View.Instance { return nsTableHeaderView() }
}
extension NSTableHeaderView: TableHeaderViewConvertible {
	public func nsTableHeaderView() -> TableHeaderView.Instance { return self }
}
public extension TableHeaderView {
	func nsTableHeaderView() -> TableHeaderView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableHeaderViewBinding: ViewBinding {
	static func tableHeaderViewBinding(_ binding: TableHeaderView.Binding) -> Self
}
public extension TableHeaderViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return tableHeaderViewBinding(.inheritedBinding(binding))
	}
}
public extension TableHeaderView.Binding {
	public typealias Preparer = TableHeaderView.Preparer
	static func tableHeaderViewBinding(_ binding: TableHeaderView.Binding) -> TableHeaderView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
