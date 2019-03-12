//
//  CwlView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 19/10/2015.
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

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class View: Binder, ViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension View {
	enum Binding: ViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case layer(Constant<Layer>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case alpha(Dynamic<(CGFloat)>)
		case backgroundColor(Dynamic<(UIColor?)>)
		case clearsContextBeforeDrawing(Dynamic<(Bool)>)
		case clipsToBounds(Dynamic<(Bool)>)
		case contentMode(Dynamic<(UIView.ContentMode)>)
		case gestureRecognizers(Dynamic<[GestureRecognizerConvertible]>)
		case horizontalContentCompressionResistancePriority(Dynamic<UILayoutPriority>)
		case horizontalContentHuggingPriority(Dynamic<UILayoutPriority>)
		case isExclusiveTouch(Dynamic<(Bool)>)
		case isHidden(Dynamic<(Bool)>)
		case isMultipleTouchEnabled(Dynamic<(Bool)>)
		case isOpaque(Dynamic<(Bool)>)
		case isUserInteractionEnabled(Dynamic<(Bool)>)
		case layout(Dynamic<Layout>)
		case layoutMargins(Dynamic<(UIEdgeInsets)>)
		case mask(Dynamic<(ViewConvertible?)>)
		case motionEffects(Dynamic<([UIMotionEffect])>)
		case preservesSuperviewLayoutMargins(Dynamic<(Bool)>)
		case restorationIdentifier(Dynamic<String?>)
		case semanticContentAttribute(Dynamic<(UISemanticContentAttribute)>)
		case tag(Dynamic<Int>)
		case tintAdjustmentMode(Dynamic<(UIView.TintAdjustmentMode)>)
		case tintColor(Dynamic<(UIColor)>)
		case verticalContentCompressionResistancePriority(Dynamic<UILayoutPriority>)
		case verticalContentHuggingPriority(Dynamic<UILayoutPriority>)

		// 2. Signal bindings are performed on the object after construction.
		case becomeFirstResponder(Signal<Void>)
		case endEditing(Signal<Bool>)
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension View {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = View.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = UIView
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension View.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .layer(let x):
			x.value.apply(to: instance.layer)
			return nil
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .alpha(let x): return x.apply(instance) { i, v in i.alpha = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .clearsContextBeforeDrawing(let x): return x.apply(instance) { i, v in i.clearsContextBeforeDrawing = v }
		case .clipsToBounds(let x): return x.apply(instance) { i, v in i.clipsToBounds = v }
		case .contentMode(let x): return x.apply(instance) { i, v in i.contentMode = v }
		case .gestureRecognizers(let x): return x.apply(instance) { i, v in i.gestureRecognizers = v.map { $0.uiGestureRecognizer() } }
		case .horizontalContentCompressionResistancePriority(let x): return x.apply(instance) { i, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Axis.horizontal) }
		case .horizontalContentHuggingPriority(let x): return x.apply(instance) { i, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Axis.horizontal) }
		case .isExclusiveTouch(let x): return x.apply(instance) { i, v in i.isExclusiveTouch = v }
		case .isHidden(let x): return x.apply(instance) { i, v in i.isHidden = v }
		case .isMultipleTouchEnabled(let x): return x.apply(instance) { i, v in i.isMultipleTouchEnabled = v }
		case .isOpaque(let x): return x.apply(instance) { i, v in i.isOpaque = v }
		case .isUserInteractionEnabled(let x): return x.apply(instance) { i, v in i.isUserInteractionEnabled = v }
		case .layout(let x): return x.apply(instance) { i, v in instance.applyLayout(v) }
		case .layoutMargins(let x): return x.apply(instance) { i, v in i.layoutMargins = v }
		case .mask(let x): return x.apply(instance) { i, v in i.mask = v?.uiView() }
		case .motionEffects(let x): return x.apply(instance) { i, v in i.motionEffects = v }
		case .preservesSuperviewLayoutMargins(let x): return x.apply(instance) { i, v in i.preservesSuperviewLayoutMargins = v }
		case .restorationIdentifier(let x): return x.apply(instance) { i, v in i.restorationIdentifier = v }
		case .semanticContentAttribute(let x): return x.apply(instance) { i, v in i.semanticContentAttribute = v }
		case .tag(let x): return x.apply(instance) { i, v in i.tag = v }
		case .tintAdjustmentMode(let x): return x.apply(instance) { i, v in i.tintAdjustmentMode = v }
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
		case .verticalContentCompressionResistancePriority(let x): return x.apply(instance) { i, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Axis.vertical) }
		case .verticalContentHuggingPriority(let x): return x.apply(instance) { i, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Axis.vertical) }

		// 2. Signal bindings are performed on the object after construction.
		case .becomeFirstResponder(let x): return x.apply(instance) { i, v in i.becomeFirstResponder() }
		case .endEditing(let x): return x.apply(instance) { i, v in i.endEditing(v) }
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension View.Preparer {
	public typealias Storage = AssociatedBinderStorage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ViewBinding {
	public typealias ViewName<V> = BindingName<V, View.Binding, Binding>
	private typealias B = View.Binding
	private static func name<V>(_ source: @escaping (V) -> View.Binding) -> ViewName<V> {
		return ViewName<V>(source: source, downcast: Binding.viewBinding)
	}
}
public extension BindingName where Binding: ViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var layer: ViewName<Constant<Layer>> { return .name(B.layer) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var alpha: ViewName<Dynamic<(CGFloat)>> { return .name(B.alpha) }
	static var backgroundColor: ViewName<Dynamic<(UIColor?)>> { return .name(B.backgroundColor) }
	static var clearsContextBeforeDrawing: ViewName<Dynamic<(Bool)>> { return .name(B.clearsContextBeforeDrawing) }
	static var clipsToBounds: ViewName<Dynamic<(Bool)>> { return .name(B.clipsToBounds) }
	static var contentMode: ViewName<Dynamic<(UIView.ContentMode)>> { return .name(B.contentMode) }
	static var gestureRecognizers: ViewName<Dynamic<[GestureRecognizerConvertible]>> { return .name(B.gestureRecognizers) }
	static var horizontalContentCompressionResistancePriority: ViewName<Dynamic<UILayoutPriority>> { return .name(B.horizontalContentCompressionResistancePriority) }
	static var horizontalContentHuggingPriority: ViewName<Dynamic<UILayoutPriority>> { return .name(B.horizontalContentHuggingPriority) }
	static var isExclusiveTouch: ViewName<Dynamic<(Bool)>> { return .name(B.isExclusiveTouch) }
	static var isHidden: ViewName<Dynamic<(Bool)>> { return .name(B.isHidden) }
	static var isMultipleTouchEnabled: ViewName<Dynamic<(Bool)>> { return .name(B.isMultipleTouchEnabled) }
	static var isOpaque: ViewName<Dynamic<(Bool)>> { return .name(B.isOpaque) }
	static var isUserInteractionEnabled: ViewName<Dynamic<(Bool)>> { return .name(B.isUserInteractionEnabled) }
	static var layout: ViewName<Dynamic<Layout>> { return .name(B.layout) }
	static var layoutMargins: ViewName<Dynamic<(UIEdgeInsets)>> { return .name(B.layoutMargins) }
	static var mask: ViewName<Dynamic<(ViewConvertible?)>> { return .name(B.mask) }
	static var motionEffects: ViewName<Dynamic<([UIMotionEffect])>> { return .name(B.motionEffects) }
	static var preservesSuperviewLayoutMargins: ViewName<Dynamic<(Bool)>> { return .name(B.preservesSuperviewLayoutMargins) }
	static var restorationIdentifier: ViewName<Dynamic<String?>> { return .name(B.restorationIdentifier) }
	static var semanticContentAttribute: ViewName<Dynamic<(UISemanticContentAttribute)>> { return .name(B.semanticContentAttribute) }
	static var tag: ViewName<Dynamic<Int>> { return .name(B.tag) }
	static var tintAdjustmentMode: ViewName<Dynamic<(UIView.TintAdjustmentMode)>> { return .name(B.tintAdjustmentMode) }
	static var tintColor: ViewName<Dynamic<(UIColor)>> { return .name(B.tintColor) }
	static var verticalContentCompressionResistancePriority: ViewName<Dynamic<UILayoutPriority>> { return .name(B.verticalContentCompressionResistancePriority) }
	static var verticalContentHuggingPriority: ViewName<Dynamic<UILayoutPriority>> { return .name(B.verticalContentHuggingPriority) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var becomeFirstResponder: ViewName<Signal<Void>> { return .name(B.becomeFirstResponder) }
	static var endEditing: ViewName<Signal<Bool>> { return .name(B.endEditing) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
extension UIView: DefaultConstructable {}
public extension View {
	func uiView() -> Layout.View { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ViewBinding: BinderBaseBinding {
	static func viewBinding(_ binding: View.Binding) -> Self
}
public extension ViewBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return viewBinding(.inheritedBinding(binding))
	}
}
public extension View.Binding {
	typealias Preparer = View.Preparer
	static func viewBinding(_ binding: View.Binding) -> View.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
