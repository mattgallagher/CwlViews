//
//  CwlStepperTesting_iOS.swift
//  CwlViewsTesting
//
//  Created by Sye Boddeus on 13/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

#if os(iOS)

extension BindingParser where Downcast: StepperBinding {

	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var autorepeat: BindingParser<Dynamic<Bool>, Stepper.Binding, Downcast> { return .init(extract: { if case .autorepeat(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Stepper.Binding, Downcast> { return .init(extract: { if case .backgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var decrementImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Stepper.Binding, Downcast> { return .init(extract: { if case .decrementImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var dividerImage: BindingParser<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>, Stepper.Binding, Downcast> { return .init(extract: { if case .dividerImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var incrementImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Stepper.Binding, Downcast> { return .init(extract: { if case .incrementImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var isContinuous: BindingParser<Dynamic<Bool>, Stepper.Binding, Downcast> { return .init(extract: { if case .isContinuous(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var maximumValue: BindingParser<Dynamic<Double>, Stepper.Binding, Downcast> { return .init(extract: { if case .maximumValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var minimumValue: BindingParser<Dynamic<Double>, Stepper.Binding, Downcast> { return .init(extract: { if case .minimumValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var stepValue: BindingParser<Dynamic<Double>, Stepper.Binding, Downcast> { return .init(extract: { if case .stepValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var tintColor: BindingParser<Dynamic<UIColor?>, Stepper.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var value: BindingParser<Dynamic<Double>, Stepper.Binding, Downcast> { return .init(extract: { if case .value(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }
	public static var wraps: BindingParser<Dynamic<Bool>, Stepper.Binding, Downcast> { return .init(extract: { if case .wraps(let x) = $0 { return x } else { return nil } }, upcast: { $0.asStepperBinding() }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
