//
//  CwlImageView.swift
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

public class ImageView: ConstructingBinder, ImageViewConvertible {
	public typealias Instance = UIImageView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiImageView() -> Instance { return instance() }
	
	public enum Binding: ImageViewBinding {
		public typealias EnclosingBinder = ImageView
		public static func imageViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
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
	
	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = ImageView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			return subclass.init(image: initialImage ?? nil, highlightedImage: initialHighlightedImage ?? nil)
		}
		
		var image = InitialSubsequent<UIImage?>()
		var initialImage: UIImage?? = nil
		var highlightedImage = InitialSubsequent<UIImage?>()
		var initialHighlightedImage: UIImage?? = nil
		
		public init() {}
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .image(let x):
				image = x.initialSubsequent()
				initialImage = image.initial()
			case .highlightedImage(let x):
				highlightedImage = x.initialSubsequent()
				initialHighlightedImage = highlightedImage.initial()
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .image: return image.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in i.image = v } }
			case .highlightedImage: return highlightedImage.subsequent.flatMap { $0.apply(instance, storage) { i, s, v in i.highlightedImage = v } }
			case .animationImages(let x): return x.apply(instance, storage) { i, s, v in i.animationImages = v }
			case .highlightedAnimationImages(let x): return x.apply(instance, storage) { i, s, v in i.highlightedAnimationImages = v }
			case .animationDuration(let x): return x.apply(instance, storage) { i, s, v in i.animationDuration = v }
			case .animationRepeatCount(let x): return x.apply(instance, storage) { i, s, v in i.animationRepeatCount = v }
			case .isHighlighted(let x): return x.apply(instance, storage) { i, s, v in i.isHighlighted = v }
			case .animating(let x):
				return x.apply(instance, storage) { i, s, v in
					if v && !i.isAnimating {
						i.startAnimating()
					} else if !v && i.isAnimating {
						i.stopAnimating()
					}
				}
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = View.Storage
}

extension BindingName where Binding: ImageViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .imageViewBinding(ImageView.Binding.$1(v)) }) }
	public static var image: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .imageViewBinding(ImageView.Binding.image(v)) }) }
	public static var highlightedImage: BindingName<Dynamic<UIImage?>, Binding> { return BindingName<Dynamic<UIImage?>, Binding>({ v in .imageViewBinding(ImageView.Binding.highlightedImage(v)) }) }
	public static var animationImages: BindingName<Dynamic<[UIImage]?>, Binding> { return BindingName<Dynamic<[UIImage]?>, Binding>({ v in .imageViewBinding(ImageView.Binding.animationImages(v)) }) }
	public static var highlightedAnimationImages: BindingName<Dynamic<[UIImage]?>, Binding> { return BindingName<Dynamic<[UIImage]?>, Binding>({ v in .imageViewBinding(ImageView.Binding.highlightedAnimationImages(v)) }) }
	public static var animationDuration: BindingName<Dynamic<TimeInterval>, Binding> { return BindingName<Dynamic<TimeInterval>, Binding>({ v in .imageViewBinding(ImageView.Binding.animationDuration(v)) }) }
	public static var animationRepeatCount: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .imageViewBinding(ImageView.Binding.animationRepeatCount(v)) }) }
	public static var isHighlighted: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .imageViewBinding(ImageView.Binding.isHighlighted(v)) }) }
	public static var animating: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .imageViewBinding(ImageView.Binding.animating(v)) }) }
}

public protocol ImageViewConvertible: ViewConvertible {
	func uiImageView() -> ImageView.Instance
}
extension ImageViewConvertible {
	public func uiView() -> View.Instance { return uiImageView() }
}
extension ImageView.Instance: ImageViewConvertible {
	public func uiImageView() -> ImageView.Instance { return self }
}

public protocol ImageViewBinding: ViewBinding {
	static func imageViewBinding(_ binding: ImageView.Binding) -> Self
}

extension ImageViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return imageViewBinding(.inheritedBinding(binding))
	}
}
