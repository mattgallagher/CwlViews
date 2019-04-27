//
//  CwlExtendedView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 12/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

extension BindingParser where Downcast: ExtendedViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ExtendedView<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asExtendedViewBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	@available(macOS 10.10, *) @available(iOS, unavailable) public static var backgroundColor: BindingParser<Dynamic<ExtendedView<Downcast.SubclassType>.NSColor?>, ExtendedView<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .backgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	public static var sizeDidChange: BindingParser<SignalInput<CGSize>, ExtendedView<Downcast.SubclassType>.Binding, Downcast> { return .init(extract: { if case .sizeDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asExtendedViewBinding() }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}
