//
//  CwlProgressView_iOS.swift
//  CwlViews
//
//  Created by Sye Boddeus on 14/5/19.
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class ProgressView: Binder, ProgressViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ProgressView {
	enum Binding: ProgressViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
        case progress(Dynamic<SetOrAnimate<Float>>)
        case observedProgress(Dynamic<Progress?>)
        case progressViewStyle(Dynamic<UIProgressView.Style>)
        case progressTintColor(Dynamic<UIColor?>)
        case progressImage(Dynamic<UIImage?>)
        case trackTintColor(Dynamic<UIColor?>)
        case trackImage(Dynamic<UIImage?>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension ProgressView {
	struct Preparer: BinderEmbedderConstructor /* or BinderDelegateEmbedderConstructor */ {
		public typealias Binding = ProgressView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UIProgressView

		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ProgressView.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
        case .progress(let x): return x.apply(instance) { i, v in i.setProgress(v.value, animated: v.isAnimated) }
        case .observedProgress(let x): return x.apply(instance) { i, v in i.observedProgress = v}
        case .progressViewStyle(let x): return x.apply(instance) { i, v in i.progressViewStyle = v }
        case .progressTintColor(let x): return x.apply(instance) { i, v in i.progressTintColor = v }
        case .progressImage(let x): return x.apply(instance) { i, v in i.progressImage = v }
        case .trackTintColor(let x): return x.apply(instance) { i, v in i.trackTintColor = v }
        case .trackImage(let x): return x.apply(instance) { i, v in i.trackImage = v }
        }
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ProgressView.Preparer {
	public typealias Storage = View.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ProgressViewBinding {
	public typealias ProgressViewName<V> = BindingName<V, ProgressView.Binding, Binding>
			private static func name<V>(_ source: @escaping (V) -> ProgressView.Binding) -> ProgressViewName<V> {
		return ProgressViewName<V>(source: source, downcast: Binding.ProgressViewBinding)
	}
}
public extension BindingName where Binding: ProgressViewBinding {
    static var progress: ProgressViewName<Dynamic<SetOrAnimate<Float>>> { return .name(ProgressView.Binding.progress) }
    static var observedProgress: ProgressViewName<Dynamic<Progress?>> { return .name(ProgressView.Binding.observedProgress) }
    static var progressViewStyle: ProgressViewName<Dynamic<UIProgressView.Style>> { return .name(ProgressView.Binding.progressViewStyle) }
    static var progressTintColor: ProgressViewName<Dynamic<UIColor?>> { return .name(ProgressView.Binding.progressTintColor) }
    static var progressImage: ProgressViewName<Dynamic<UIImage?>> { return .name(ProgressView.Binding.progressImage) }
    static var trackTintColor: ProgressViewName<Dynamic<UIColor?>> { return .name(ProgressView.Binding.trackTintColor) }
    static var trackImage: ProgressViewName<Dynamic<UIImage?>> { return .name(ProgressView.Binding.trackImage) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ProgressViewConvertible: ViewConvertible {
	func uiProgressView() -> ProgressView.Instance
}
extension ProgressViewConvertible {
	public func uiView() -> View.Instance { return uiProgressView() }
}
extension UIProgressView: ProgressViewConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func uiProgressView() -> ProgressView.Instance { return self }
}
public extension ProgressView {
	func uiProgressView() -> ProgressView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ProgressViewBinding: ViewBinding {
	static func ProgressViewBinding(_ binding: ProgressView.Binding) -> Self
	func asProgressViewBinding() -> ProgressView.Binding?
}
public extension ProgressViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return ProgressViewBinding(.inheritedBinding(binding))
	}
}
extension ProgressViewBinding where Preparer.Inherited.Binding: ProgressViewBinding {
	func asProgressViewBinding() -> ProgressView.Binding? {
		return asInheritedBinding()?.asProgressViewBinding()
	}
}
public extension ProgressView.Binding {
	typealias Preparer = ProgressView.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asProgressViewBinding() -> ProgressView.Binding? { return self }
	static func ProgressViewBinding(_ binding: ProgressView.Binding) -> ProgressView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
#endif
