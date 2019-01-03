//
//  CwlImageView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case image(Dynamic<UIImage?>)
		case highlightedImage(Dynamic<UIImage?>)
		case animationImages(Dynamic<[UIImage]?>)
		case highlightedAnimationImages(Dynamic<[UIImage]?>)
		case animationDuration(Dynamic<TimeInterval>)
		case animationRepeatCount(Dynamic<Int>)
		case isHighlighted(Dynamic<Bool>)
		
		// 2. Signal bindings are performed on the object after construction.
		case animating(Signal<Bool>)
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ImageView {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = ImageView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UIImageView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var image = InitialSubsequent<UIImage?>()
		var highlightedImage = InitialSubsequent<UIImage?>()
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ImageView.Preparer {
	func constructInstance(type: UIImageView.Type, parameters: Void) -> UIImageView {
		return type.init(image: image.initial ?? nil, highlightedImage: highlightedImage.initial ?? nil)
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .image(let x): image = x.initialSubsequent()
		case .highlightedImage(let x): highlightedImage = x.initialSubsequent()
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .animationDuration(let x): return x.apply(instance) { i, v in i.animationDuration = v }
		case .animationImages(let x): return x.apply(instance) { i, v in i.animationImages = v }
		case .animationRepeatCount(let x): return x.apply(instance) { i, v in i.animationRepeatCount = v }
		case .highlightedAnimationImages(let x): return x.apply(instance) { i, v in i.highlightedAnimationImages = v }
		case .highlightedImage: return highlightedImage.apply(instance) { i, v in i.highlightedImage = v }
		case .image: return image.apply(instance) { i, v in i.image = v }
		case .isHighlighted(let x): return x.apply(instance) { i, v in i.isHighlighted = v }
			
		// 2. Signal bindings are performed on the object after construction.
		case .animating(let x):
			return x.apply(instance) { i, v in
				if v && !i.isAnimating {
					i.startAnimating()
				} else if !v && i.isAnimating {
					i.stopAnimating()
				}
			}
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ImageView.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ImageViewBinding {
	public typealias ImageViewName<V> = BindingName<V, ImageView.Binding, Binding>
	private typealias B = ImageView.Binding
	private static func name<V>(_ source: @escaping (V) -> ImageView.Binding) -> ImageViewName<V> {
		return ImageViewName<V>(source: source, downcast: Binding.imageViewBinding)
	}
}
public extension BindingName where Binding: ImageViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ImageViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var image: ImageViewName<Dynamic<UIImage?>> { return .name(B.image) }
	static var highlightedImage: ImageViewName<Dynamic<UIImage?>> { return .name(B.highlightedImage) }
	static var animationImages: ImageViewName<Dynamic<[UIImage]?>> { return .name(B.animationImages) }
	static var highlightedAnimationImages: ImageViewName<Dynamic<[UIImage]?>> { return .name(B.highlightedAnimationImages) }
	static var animationDuration: ImageViewName<Dynamic<TimeInterval>> { return .name(B.animationDuration) }
	static var animationRepeatCount: ImageViewName<Dynamic<Int>> { return .name(B.animationRepeatCount) }
	static var isHighlighted: ImageViewName<Dynamic<Bool>> { return .name(B.isHighlighted) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var animating: ImageViewName<Signal<Bool>> { return .name(B.animating) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ImageViewConvertible: ViewConvertible {
	func uiImageView() -> ImageView.Instance
}
extension ImageViewConvertible {
	public func uiView() -> View.Instance { return uiImageView() }
}
extension UIImageView: ImageViewConvertible {
	public func uiImageView() -> ImageView.Instance { return self }
}
public extension ImageView {
	func uiImageView() -> ImageView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ImageViewBinding: ViewBinding {
	static func imageViewBinding(_ binding: ImageView.Binding) -> Self
}
public extension ImageViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return imageViewBinding(.inheritedBinding(binding))
	}
}
public extension ImageView.Binding {
	public typealias Preparer = ImageView.Preparer
	static func imageViewBinding(_ binding: ImageView.Binding) -> ImageView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
