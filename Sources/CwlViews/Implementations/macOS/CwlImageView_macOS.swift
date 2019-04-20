//
//  CwlImageView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 9/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class ImageView: Binder, ImageViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ImageView {
	enum Binding: ImageViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsCutCopyPaste(Dynamic<Bool>)
		case animates(Dynamic<Bool>)
		case image(Dynamic<NSImage?>)
		case imageAlignment(Dynamic<NSImageAlignment>)
		case imageFrameStyle(Dynamic<NSImageView.FrameStyle>)
		case imageScaling(Dynamic<NSImageScaling>)
		case isEditable(Dynamic<Bool>)
		@available(macOS 10.14, *) case contentTintColor(Dynamic<NSColor?>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ImageView {
	struct Preparer: BinderEmbedderConstructor /* or BinderDelegateEmbedderConstructor */ {
		public typealias Binding = ImageView.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSImageView
		
		public var inherited = Inherited()
		public init() {}
		
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ImageView.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		case .allowsCutCopyPaste(let x): return x.apply(instance) { i, v in i.allowsCutCopyPaste = v }
		case .animates(let x): return x.apply(instance) { i, v in i.animates = v }
		case .image(let x): return x.apply(instance) { i, v in i.image = v }
		case .imageAlignment(let x): return x.apply(instance) { i, v in i.imageAlignment = v }
		case .imageFrameStyle(let x): return x.apply(instance) { i, v in i.imageFrameStyle = v }
		case .imageScaling(let x): return x.apply(instance) { i, v in i.imageScaling = v }
		case .isEditable(let x): return x.apply(instance) { i, v in i.isEditable = v }
		case .contentTintColor(let x):
			return x.apply(instance) { i, v in
				if #available(OSX 10.14, *) {
					i.contentTintColor = v
				}
			}
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ImageView.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ImageViewBinding {
	public typealias ImageViewName<V> = BindingName<V, ImageView.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> ImageView.Binding) -> ImageViewName<V> {
		return ImageViewName<V>(source: source, downcast: Binding.imageViewBinding)
	}
}
public extension BindingName where Binding: ImageViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ImageViewName<$2> { return .name(ImageView.Binding.$1) }
	static var allowsCutCopyPaste: ImageViewName<Dynamic<Bool>> { return .name(ImageView.Binding.allowsCutCopyPaste) }
	static var animates: ImageViewName<Dynamic<Bool>> { return .name(ImageView.Binding.animates) }
	static var image: ImageViewName<Dynamic<NSImage?>> { return .name(ImageView.Binding.image) }
	static var imageAlignment: ImageViewName<Dynamic<NSImageAlignment>> { return .name(ImageView.Binding.imageAlignment) }
	static var imageFrameStyle: ImageViewName<Dynamic<NSImageView.FrameStyle>> { return .name(ImageView.Binding.imageFrameStyle) }
	static var imageScaling: ImageViewName<Dynamic<NSImageScaling>> { return .name(ImageView.Binding.imageScaling) }
	static var isEditable: ImageViewName<Dynamic<Bool>> { return .name(ImageView.Binding.isEditable) }
	@available(macOS 10.14, *) static var contentTintColor: ImageViewName<Dynamic<NSColor?>> { return .name(ImageView.Binding.contentTintColor) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ImageViewConvertible: ControlConvertible {
	func nsImageView() -> ImageView.Instance
}
extension ImageViewConvertible {
	public func nsControl() -> Control.Instance { return nsImageView() }
}
extension NSImageView: ImageViewConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func nsImageView() -> ImageView.Instance { return self }
}
public extension ImageView {
	func nsImageView() -> ImageView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ImageViewBinding: ControlBinding {
	static func imageViewBinding(_ binding: ImageView.Binding) -> Self
}
public extension ImageViewBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return imageViewBinding(.inheritedBinding(binding))
	}
}
public extension ImageView.Binding {
	typealias Preparer = ImageView.Preparer
	static func imageViewBinding(_ binding: ImageView.Binding) -> ImageView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
