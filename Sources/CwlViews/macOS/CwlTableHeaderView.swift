//
//  CwlTableHeaderView.swift
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

public class TableHeaderView: ConstructingBinder, TableHeaderViewConvertible {
	public typealias Instance = NSTableHeaderView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsTableHeaderView() -> Instance { return instance() }
	
	public enum Binding: TableHeaderViewBinding {
		public typealias EnclosingBinder = TableHeaderView
		public static func tableHeaderViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		// 1. Value bindings may be applied at construction and may subsequently change.

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = TableHeaderView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
	}

	public typealias Storage = View.Storage
}

extension BindingName where Binding: TableHeaderViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .tableHeaderViewBinding(TableHeaderView.Binding.$1(v)) }) }
}

public protocol TableHeaderViewConvertible: ViewConvertible {
	func nsTableHeaderView() -> TableHeaderView.Instance
}
extension TableHeaderViewConvertible {
	public func nsView() -> View.Instance { return nsTableHeaderView() }
}
extension TableHeaderView.Instance: TableHeaderViewConvertible {
	public func nsTableHeaderView() -> TableHeaderView.Instance { return self }
}

public protocol TableHeaderViewBinding: ViewBinding {
	static func tableHeaderViewBinding(_ binding: TableHeaderView.Binding) -> Self
}
extension TableHeaderViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return tableHeaderViewBinding(.inheritedBinding(binding))
	}
}

