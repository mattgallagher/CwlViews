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
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var showsSelectionIndicator: BindingParser<Dynamic<Bool>, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .showsSelectionIndicator(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var pickerData: BindingParser<Dynamic<ArrayMutation<PickerComponent<Downcast.ViewDataType>>>, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .pickerData(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var selectRowAndComponent: BindingParser<Signal<SetOrAnimate<PickerView<Downcast.ViewDataType>.RowAndComponent>>, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .selectRowAndComponent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var reload: BindingParser<Signal<PickerView<Downcast.ViewDataType>.Reload>, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .reload(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	// Pass in the row signal instead of row and component index because passing in those would circumvent the need for the pickerData
	public static var attributedTitle: BindingParser<(_ rowComponentAndData: PickerView<Downcast.ViewDataType>.RowComponentAndData) -> NSAttributedString?, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .attributedTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var didSelectRowAndComponent: BindingParser<(_ pickerView: UIPickerView, _ rowComponentAndData: PickerView<Downcast.ViewDataType>.RowComponentAndData) -> Void, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .didSelectRowAndComponent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var title: BindingParser<(_ rowComponentAndData: PickerView<Downcast.ViewDataType>.RowComponentAndData) -> String?, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
	public static var viewConstructor: BindingParser<(_ rowSignal: SignalMulti<PickerView<Downcast.ViewDataType>.RowComponentAndData>) -> ViewConvertible, PickerView<Downcast.ViewDataType>.Binding, Downcast> { return .init(extract: { if case .viewConstructor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asPickerViewBinding() }) }
}

#endif
