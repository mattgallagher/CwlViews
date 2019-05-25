//
//  CwlPickerViewTesting_iOS.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 22/5/19.
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

extension BindingParser where Downcast: PickerViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asPickerViewBinding() }) }
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var pickerData: BindingParser<Dynamic<ArrayMutation<[Downcast.ViewDataType]>>, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .pickerData(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var showsSelectionIndicator: BindingParser<Dynamic<Bool>, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .showsSelectionIndicator(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var selectLocation: BindingParser<Signal<SetOrAnimate<PickerLocation>>, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .selectLocation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var attributedTitle: BindingParser<(_ data: PickerView<Downcast.ViewDataType>.Data) -> NSAttributedString?, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .attributedTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var didSelectLocation: BindingParser<(_ pickerView: UIPickerView, _ data: PickerView<Downcast.ViewDataType>.Data) -> Void, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .didSelectLocation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var rowHeightForComponent: BindingParser<(_ pickerView: UIPickerView, _ component: Int, _ data: [Downcast.ViewDataType]) -> CGFloat, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .rowHeightForComponent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var title: BindingParser<(_ data: PickerView<Downcast.ViewDataType>.Data) -> String?, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var viewConstructor: BindingParser<(_ identifier: String?, _ rowSignal: SignalMulti<Downcast.ViewDataType>) -> ViewConvertible, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .viewConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var viewIdentifier: BindingParser<(_ data: PickerView<Downcast.ViewDataType>.Data) -> String?, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .viewIdentifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var widthForComponent: BindingParser<(_ pickerView: UIPickerView, _ component: Int, _ data: [Downcast.ViewDataType]) -> CGFloat, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .widthForComponent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
}

#endif
