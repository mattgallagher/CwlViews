//
//  CwlImageView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 9/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Binding == ImageView.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsCutCopyPaste: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .allowsCutCopyPaste(let x) = binding { return x } else { return nil } }) }
	public static var animates: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .animates(let x) = binding { return x } else { return nil } }) }
	public static var image: BindingParser<Dynamic<NSImage?>, Binding> { return BindingParser<Dynamic<NSImage?>, Binding>(parse: { binding -> Optional<Dynamic<NSImage?>> in if case .image(let x) = binding { return x } else { return nil } }) }
	public static var imageAlignment: BindingParser<Dynamic<NSImageAlignment>, Binding> { return BindingParser<Dynamic<NSImageAlignment>, Binding>(parse: { binding -> Optional<Dynamic<NSImageAlignment>> in if case .imageAlignment(let x) = binding { return x } else { return nil } }) }
	public static var imageFrameStyle: BindingParser<Dynamic<NSImageView.FrameStyle>, Binding> { return BindingParser<Dynamic<NSImageView.FrameStyle>, Binding>(parse: { binding -> Optional<Dynamic<NSImageView.FrameStyle>> in if case .imageFrameStyle(let x) = binding { return x } else { return nil } }) }
	public static var imageScaling: BindingParser<Dynamic<NSImageScaling>, Binding> { return BindingParser<Dynamic<NSImageScaling>, Binding>(parse: { binding -> Optional<Dynamic<NSImageScaling>> in if case .imageScaling(let x) = binding { return x } else { return nil } }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isEditable(let x) = binding { return x } else { return nil } }) }
	@available(macOS 10.14, *) public static var contentTintColor: BindingParser<Dynamic<NSColor?>, Binding> { return BindingParser<Dynamic<NSColor?>, Binding>(parse: { binding -> Optional<Dynamic<NSColor?>> in if case .contentTintColor(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
