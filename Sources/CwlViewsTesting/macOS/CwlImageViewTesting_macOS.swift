//
//  CwlImageView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 9/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Downcast: ImageViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, ImageView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asImageViewBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsCutCopyPaste: BindingParser<Dynamic<Bool>, ImageView.Binding, Downcast> { return .init(extract: { if case .allowsCutCopyPaste(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var animates: BindingParser<Dynamic<Bool>, ImageView.Binding, Downcast> { return .init(extract: { if case .animates(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var image: BindingParser<Dynamic<NSImage?>, ImageView.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var imageAlignment: BindingParser<Dynamic<NSImageAlignment>, ImageView.Binding, Downcast> { return .init(extract: { if case .imageAlignment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var imageFrameStyle: BindingParser<Dynamic<NSImageView.FrameStyle>, ImageView.Binding, Downcast> { return .init(extract: { if case .imageFrameStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var imageScaling: BindingParser<Dynamic<NSImageScaling>, ImageView.Binding, Downcast> { return .init(extract: { if case .imageScaling(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, ImageView.Binding, Downcast> { return .init(extract: { if case .isEditable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }
	@available(macOS 10.14, *) public static var contentTintColor: BindingParser<Dynamic<NSColor?>, ImageView.Binding, Downcast> { return .init(extract: { if case .contentTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asImageViewBinding() }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
