//
//  CwlView.swift
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

public class View: ConstructingBinder, ViewConvertible {
	public typealias Instance = UIView
	public typealias Inherited = BaseBinder
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiView() -> Instance { return instance() }

	public enum Binding: ViewBinding {
		public typealias EnclosingBinder = View
		public static func viewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case layer(Constant<BackingLayer>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case layout(Dynamic<Layout>)
		case backgroundColor(Dynamic<(UIColor?)>)
		case isHidden(Dynamic<(Bool)>)
		case alpha(Dynamic<(CGFloat)>)
		case isOpaque(Dynamic<(Bool)>)
		case tintColor(Dynamic<(UIColor)>)
		case tintAdjustmentMode(Dynamic<(UIView.TintAdjustmentMode)>)
		case clipsToBounds(Dynamic<(Bool)>)
		case clearsContextBeforeDrawing(Dynamic<(Bool)>)
		case mask(Dynamic<(ViewConvertible?)>)
		case isUserInteractionEnabled(Dynamic<(Bool)>)
		case isMultipleTouchEnabled(Dynamic<(Bool)>)
		case isExclusiveTouch(Dynamic<(Bool)>)
		case contentMode(Dynamic<(UIView.ContentMode)>)
		case horizontalContentCompressionResistancePriority(Dynamic<UILayoutPriority>)
		case verticalContentCompressionResistancePriority(Dynamic<UILayoutPriority>)
		case horizontalContentHuggingPriority(Dynamic<UILayoutPriority>)
		case verticalContentHuggingPriority(Dynamic<UILayoutPriority>)
		case semanticContentAttribute(Dynamic<(UISemanticContentAttribute)>)
		case layoutMargins(Dynamic<(UIEdgeInsets)>)
		case preservesSuperviewLayoutMargins(Dynamic<(Bool)>)
		case gestureRecognizers(Dynamic<[UIGestureRecognizer]>)
		case motionEffects(Dynamic<([UIMotionEffect])>)
		case tag(Dynamic<Int>)
		case restorationIdentifier(Dynamic<String?>)

		// 2. Signal bindings are performed on the object after construction.
		case endEditing(Signal<Bool>)
		case becomeFirstResponder(Signal<Void>)
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = View
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(frame: CGRect.zero) }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .layer(let x):
				x.value.applyBindings(to: instance.layer)
				return nil
			case .layout(let x):
				return x.apply(instance, storage) { i, s, v in
					instance.applyLayout(v)
				}
			case .backgroundColor(let x): return x.apply(instance, storage) { i, s, v in i.backgroundColor = v }
			case .isHidden(let x): return x.apply(instance, storage) { i, s, v in i.isHidden = v }
			case .alpha(let x): return x.apply(instance, storage) { i, s, v in i.alpha = v }
			case .isOpaque(let x): return x.apply(instance, storage) { i, s, v in i.isOpaque = v }
			case .tintColor(let x): return x.apply(instance, storage) { i, s, v in i.tintColor = v }
			case .tintAdjustmentMode(let x): return x.apply(instance, storage) { i, s, v in i.tintAdjustmentMode = v }
			case .clipsToBounds(let x): return x.apply(instance, storage) { i, s, v in i.clipsToBounds = v }
			case .clearsContextBeforeDrawing(let x): return x.apply(instance, storage) { i, s, v in i.clearsContextBeforeDrawing = v }
			case .mask(let x): return x.apply(instance, storage) { i, s, v in i.mask = v?.uiView() }
			case .isUserInteractionEnabled(let x): return x.apply(instance, storage) { i, s, v in i.isUserInteractionEnabled = v }
			case .isMultipleTouchEnabled(let x): return x.apply(instance, storage) { i, s, v in i.isMultipleTouchEnabled = v }
			case .isExclusiveTouch(let x): return x.apply(instance, storage) { i, s, v in i.isExclusiveTouch = v }
			case .restorationIdentifier(let x): return x.apply(instance, storage) { i, s, v in i.restorationIdentifier = v }
			case .contentMode(let x): return x.apply(instance, storage) { i, s, v in i.contentMode = v }
			case .horizontalContentCompressionResistancePriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Axis.horizontal) }
			case .verticalContentCompressionResistancePriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentCompressionResistancePriority(v, for: NSLayoutConstraint.Axis.vertical) }
			case .horizontalContentHuggingPriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Axis.horizontal) }
			case .verticalContentHuggingPriority(let x): return x.apply(instance, storage) { i, s, v in i.setContentHuggingPriority(v, for: NSLayoutConstraint.Axis.vertical) }
			case .semanticContentAttribute(let x): return x.apply(instance, storage) { i, s, v in i.semanticContentAttribute = v }
			case .layoutMargins(let x): return x.apply(instance, storage) { i, s, v in i.layoutMargins = v }
			case .preservesSuperviewLayoutMargins(let x): return x.apply(instance, storage) { i, s, v in i.preservesSuperviewLayoutMargins = v }
			case .gestureRecognizers(let x): return x.apply(instance, storage) { i, s, v in i.gestureRecognizers = v }
			case .motionEffects(let x): return x.apply(instance, storage) { i, s, v in i.motionEffects = v }
			case .tag(let x): return x.apply(instance, storage) { i, s, v in i.tag = v }
			case .endEditing(let x): return x.apply(instance, storage) { i, s, v in i.endEditing(v) }
			case .becomeFirstResponder(let x): return x.apply(instance, storage) { i, s, v in i.becomeFirstResponder() }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: (), storage: ())
			}
		}
	}

	public typealias Storage = ObjectBinderStorage
}

extension BindingName where Binding: ViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .viewBinding(View.Binding.$1(v)) }) }
	public static var layer: BindingName<Constant<BackingLayer>, Binding> { return BindingName<Constant<BackingLayer>, Binding>({ v in .viewBinding(View.Binding.layer(v)) }) }
	public static var layout: BindingName<Dynamic<Layout>, Binding> { return BindingName<Dynamic<Layout>, Binding>({ v in .viewBinding(View.Binding.layout(v)) }) }
	public static var backgroundColor: BindingName<Dynamic<(UIColor?)>, Binding> { return BindingName<Dynamic<(UIColor?)>, Binding>({ v in .viewBinding(View.Binding.backgroundColor(v)) }) }
	public static var isHidden: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.isHidden(v)) }) }
	public static var alpha: BindingName<Dynamic<(CGFloat)>, Binding> { return BindingName<Dynamic<(CGFloat)>, Binding>({ v in .viewBinding(View.Binding.alpha(v)) }) }
	public static var isOpaque: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.isOpaque(v)) }) }
	public static var tintColor: BindingName<Dynamic<(UIColor)>, Binding> { return BindingName<Dynamic<(UIColor)>, Binding>({ v in .viewBinding(View.Binding.tintColor(v)) }) }
	public static var tintAdjustmentMode: BindingName<Dynamic<(UIView.TintAdjustmentMode)>, Binding> { return BindingName<Dynamic<(UIView.TintAdjustmentMode)>, Binding>({ v in .viewBinding(View.Binding.tintAdjustmentMode(v)) }) }
	public static var clipsToBounds: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.clipsToBounds(v)) }) }
	public static var clearsContextBeforeDrawing: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.clearsContextBeforeDrawing(v)) }) }
	public static var mask: BindingName<Dynamic<(ViewConvertible?)>, Binding> { return BindingName<Dynamic<(ViewConvertible?)>, Binding>({ v in .viewBinding(View.Binding.mask(v)) }) }
	public static var isUserInteractionEnabled: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.isUserInteractionEnabled(v)) }) }
	public static var isMultipleTouchEnabled: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.isMultipleTouchEnabled(v)) }) }
	public static var isExclusiveTouch: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.isExclusiveTouch(v)) }) }
	public static var contentMode: BindingName<Dynamic<(UIView.ContentMode)>, Binding> { return BindingName<Dynamic<(UIView.ContentMode)>, Binding>({ v in .viewBinding(View.Binding.contentMode(v)) }) }
	public static var horizontalContentCompressionResistancePriority: BindingName<Dynamic<UILayoutPriority>, Binding> { return BindingName<Dynamic<UILayoutPriority>, Binding>({ v in .viewBinding(View.Binding.horizontalContentCompressionResistancePriority(v)) }) }
	public static var verticalContentCompressionResistancePriority: BindingName<Dynamic<UILayoutPriority>, Binding> { return BindingName<Dynamic<UILayoutPriority>, Binding>({ v in .viewBinding(View.Binding.verticalContentCompressionResistancePriority(v)) }) }
	public static var horizontalContentHuggingPriority: BindingName<Dynamic<UILayoutPriority>, Binding> { return BindingName<Dynamic<UILayoutPriority>, Binding>({ v in .viewBinding(View.Binding.horizontalContentHuggingPriority(v)) }) }
	public static var verticalContentHuggingPriority: BindingName<Dynamic<UILayoutPriority>, Binding> { return BindingName<Dynamic<UILayoutPriority>, Binding>({ v in .viewBinding(View.Binding.verticalContentHuggingPriority(v)) }) }
	public static var semanticContentAttribute: BindingName<Dynamic<(UISemanticContentAttribute)>, Binding> { return BindingName<Dynamic<(UISemanticContentAttribute)>, Binding>({ v in .viewBinding(View.Binding.semanticContentAttribute(v)) }) }
	public static var layoutMargins: BindingName<Dynamic<(UIEdgeInsets)>, Binding> { return BindingName<Dynamic<(UIEdgeInsets)>, Binding>({ v in .viewBinding(View.Binding.layoutMargins(v)) }) }
	public static var preservesSuperviewLayoutMargins: BindingName<Dynamic<(Bool)>, Binding> { return BindingName<Dynamic<(Bool)>, Binding>({ v in .viewBinding(View.Binding.preservesSuperviewLayoutMargins(v)) }) }
	public static var gestureRecognizers: BindingName<Dynamic<[UIGestureRecognizer]>, Binding> { return BindingName<Dynamic<[UIGestureRecognizer]>, Binding>({ v in .viewBinding(View.Binding.gestureRecognizers(v)) }) }
	public static var motionEffects: BindingName<Dynamic<([UIMotionEffect])>, Binding> { return BindingName<Dynamic<([UIMotionEffect])>, Binding>({ v in .viewBinding(View.Binding.motionEffects(v)) }) }
	public static var tag: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .viewBinding(View.Binding.tag(v)) }) }
	public static var restorationIdentifier: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .viewBinding(View.Binding.restorationIdentifier(v)) }) }
	public static var endEditing: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .viewBinding(View.Binding.endEditing(v)) }) }
	public static var becomeFirstResponder: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .viewBinding(View.Binding.becomeFirstResponder(v)) }) }
}

public protocol ViewBinding: BaseBinding {
	static func viewBinding(_ binding: View.Binding) -> Self
}
extension ViewBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return viewBinding(.inheritedBinding(binding))
	}
}

