//
//  CwlSegmentedControl.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Downcast: SegmentedControlBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, SegmentedControl.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asSegmentedControlBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var isSpringLoaded: BindingParser<Dynamic<Bool>, SegmentedControl.Binding, Downcast> { return .init(extract: { if case .isSpringLoaded(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSegmentedControlBinding() }) }
	public static var distribution: BindingParser<Dynamic<NSSegmentedControl.Distribution>, SegmentedControl.Binding, Downcast> { return .init(extract: { if case .distribution(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSegmentedControlBinding() }) }
	public static var segments: BindingParser<Dynamic<[SegmentDescription]>, SegmentedControl.Binding, Downcast> { return .init(extract: { if case .segments(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSegmentedControlBinding() }) }
	public static var segmentStyle: BindingParser<Dynamic<NSSegmentedControl.Style>, SegmentedControl.Binding, Downcast> { return .init(extract: { if case .segmentStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSegmentedControlBinding() }) }
	public static var selectedSegment: BindingParser<Dynamic<Int>, SegmentedControl.Binding, Downcast> { return .init(extract: { if case .selectedSegment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSegmentedControlBinding() }) }
	public static var trackingMode: BindingParser<Dynamic<NSSegmentedControl.SwitchTracking>, SegmentedControl.Binding, Downcast> { return .init(extract: { if case .trackingMode(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSegmentedControlBinding() }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
