//
//  CwlPickerView_iOS.swift
//  CwlViews
//
//  Created by Sye Boddeus on 16/5/19.
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
public class PickerView<ViewData>: Binder, PickerViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension PickerView {
	enum Binding: PickerViewBinding {
		public typealias ViewDataType = ViewData
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case showsSelectionIndicator(Dynamic<Bool>)
		case pickerData(Dynamic<PickerComponentMutation<PickerComponent<ViewData>>>)

		// 2. Signal bindings are performed on the object after construction.
		case selectRowAndComponent(Signal<SetOrAnimate<PickerRowAndComponent>>)
		case reload(Signal<PickerView.Reload>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case didSelectRowAndComponent((_ pickerView: UIPickerView, _ rowAndComponent: PickerRowAndComponent) -> Void)
		// Do we want to make the below have view re-use? (some how) *****************************
		case viewConstructor((_ rowSignal: SignalMulti<ViewData>) -> ViewConvertible)
	}
}

// MARK: - Binder Part 3: Preparer
public extension PickerView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = PickerView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UIPickerView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}

		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension PickerView.Preparer {
	var delegateIsRequired: Bool { return true }

	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .didSelectRowAndComponent(let x): delegate().addMultiHandler2(x, #selector(UIPickerViewDelegate.pickerView(_:didSelectRow:inComponent:)))
		default: break
		}
	}

	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)

		prepareDelegate(instance: instance, storage: storage)
		instance.dataSource = storage
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		// 1.
		case .showsSelectionIndicator(let x): return x.apply(instance) { i, v in i.showsSelectionIndicator = v }
		case .pickerData(let x): return x.apply(instance, storage) { i, s, v in s.applyComponents(v, to: i) }

		// 2.
		case .selectRowAndComponent(let x): return x.apply(instance) { i, v in i.selectRow(v.value.row, inComponent: v.value.component, animated: v.isAnimated) }
		case .reload(let x): return x.apply(instance) { i, v in
			switch v {
			case .all:
				i.reloadAllComponents()
			case .component(let component):
				i.reloadComponent(component)
			}
		}

		// 4. Delegate Bindings
		case .didSelectRowAndComponent(_): return nil
		case .viewConstructor(let x):
			storage.viewConstructor = x
			return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PickerView.Preparer {

	open class Storage: View.Preparer.Storage, UIPickerViewDelegate, UIPickerViewDataSource {
		open override var isInUse: Bool { return true }

		open var components = PickerComponentState<PickerComponent<ViewData>>()
		open var viewConstructor: ((SignalMulti<ViewData>) -> ViewConvertible)?

		// Data Source
		open func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return components.count
		}

		open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
			return components.at(component)?.elements.count ?? 0
		}

		// Delegate
		open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
			if let element = components.at(component)?.elements.at(row) {
				switch element {
				case .text(let x):
					let label = UILabel()
					label.text = x
					label.textAlignment = .center
					return label
				case .attributedText(let x):
					let label = UILabel()
					label.attributedText = x
					label.textAlignment = .center
					return label
				case .view(let x): assertionFailure("Not yet implemented"); return UIView()
				}
			}
			// We don't seem to have such an element so return an view
			return UIView()
		}

		open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
			return components.at(component)?.rowHeight ?? 0
		}

		open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
			return components.at(component)?.width ?? 0
		}

		// Helpers
		open func applyComponents(_ componentMutation: PickerComponentMutation<PickerComponent<ViewData>>, to i: UIPickerView) {
			componentMutation.insertionsAndRemovals(length: components.count,
													insert: { index, component in
														components.insert(component, at: index)
														i.reloadComponent(index)
													},
													remove: { index in
														components.remove(at: index)
														i.reloadAllComponents()
			})
		}

	}

	open class Delegate: DynamicDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
		open func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return 0
		}

		open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
			return 0
		}

		// Delegate
		open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
			return nil
		}

		open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
			return UIView()
		}

		open func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
			return nil
		}

		open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
			return 0
		}

		open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
			return 0
		}

		open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
			return multiHandler(pickerView, PickerRowAndComponent(row, component))
		}
	}

}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: PickerViewBinding {
	public typealias PickerViewName<V> = BindingName<V, PickerView<Binding.ViewDataType>.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> PickerView<Binding.ViewDataType>.Binding) -> PickerViewName<V> {
		return PickerViewName<V>(source: source, downcast: Binding.pickerViewBinding)
	}
}
public extension BindingName where Binding: PickerViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: PickerViewName<$2> { return .name(PickerView.Binding.$1) }
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var showsSelectionIndicator: PickerViewName<Dynamic<Bool>> { return .name(PickerView.Binding.showsSelectionIndicator) }
	static var pickerData: PickerViewName<Dynamic<PickerComponentMutation<PickerComponent<Binding.ViewDataType>>>> { return .name(PickerView.Binding.pickerData) }

	// 2. Signal bindings are performed on the object after construction.
	static var selectRowAndComponent: PickerViewName<Signal<SetOrAnimate<PickerRowAndComponent>>> { return .name(PickerView.Binding.selectRowAndComponent) }
	static var reload: PickerViewName<Signal<PickerView<Binding.ViewDataType>.Reload>> { return .name(PickerView.Binding.reload) }

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var didSelectRowAndComponent: PickerViewName<(_ pickerView: UIPickerView, _ rowAndComponent: PickerRowAndComponent) -> Void> { return .name(PickerView.Binding.didSelectRowAndComponent) }
	// Do we want to make the below have view re-use? (some how) *****************************
	static var viewConstructor: PickerViewName<(_ rowSignal: SignalMulti<Binding.ViewDataType>) -> ViewConvertible> { return .name(PickerView.Binding.viewConstructor) }

	// Composite binding names
	static var rowSelected: PickerViewName<SignalInput<PickerRowAndComponent>> {
		return Binding.compositeName(
			value: { input in { picker, rowAndComponent -> Void in input.send(value: rowAndComponent) } },
			binding: PickerView.Binding.didSelectRowAndComponent,
			downcast: Binding.pickerViewBinding
		)
	}
//	static func rowSelected(_ void: Void = ()) -> PickerViewName<SignalInput<PickerRowAndComponent>> {
//		return Binding.compositeName(
//			value: { input in { picker, rowAndComponent -> Void in input.send(value: rowAndComponent) } },
//			binding: PickerView.Binding.didSelectRowAndComponent,
//			downcast: Binding.pickerViewBinding
//		)
//	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol PickerViewConvertible: ViewConvertible {
	func uiPickerView() -> UIPickerView
}
extension PickerViewConvertible {
	public func uiView() -> View.Instance { return uiPickerView() }
}
extension UIPickerView: PickerViewConvertible, HasDelegate {
	public func uiPickerView() -> UIPickerView { return self }
}
public extension PickerView {
	func uiPickerView() -> PickerView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol PickerViewBinding: ViewBinding {
	associatedtype ViewDataType
	static func pickerViewBinding(_ binding: PickerView<ViewDataType>.Binding) -> Self
	func asPickerViewBinding() -> PickerView<ViewDataType>.Binding?
}
public extension PickerViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return pickerViewBinding(.inheritedBinding(binding))
	}
}
public extension PickerViewBinding where Preparer.Inherited.Binding: PickerViewBinding, Preparer.Inherited.Binding.ViewDataType == ViewDataType {
	func asPickerViewBinding() -> PickerView<ViewDataType>.Binding? {
		return asInheritedBinding()?.asPickerViewBinding()
	}
}
public extension PickerView.Binding {
	typealias Preparer = PickerView.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asPickerViewBinding() -> PickerView.Binding? { return self }
	static func pickerViewBinding(_ binding: PickerView<ViewDataType>.Binding) -> PickerView<ViewDataType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public typealias PickerRowAndComponent = (row: Int, component: Int)

public extension PickerView {
	enum Reload {
		case all
		case component(Int)
	}
}

public typealias PickerComponentMutation<Element> = ArrayMutation<Element>

public typealias PickerComponentState<Element> = Array<Element>

public struct PickerComponent<ElementData> {
	public enum ComponentType {
		case text(String)
		case attributedText(NSAttributedString)
		case view(ElementData)
	}

	let width: CGFloat
	let rowHeight: CGFloat
	let elements: [PickerComponent.ComponentType]

	public init(width: CGFloat = 100,
				rowHeight: CGFloat = 50,
				elements: [PickerComponent.ComponentType]) {
		self.width = width
		self.rowHeight = rowHeight
		self.elements = elements
	}
}

#endif


// MARK: - Binder Part 10: Test support



//#if canImport(CwlViews)
//	extension BindingParser where Downcast: ViewSubclassBinding {
//		// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
//		// Replace: case ([^\(]+)\((.+)\)$
//		// With:    public static var $1: BindingParser<$2, ViewSubclass.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asViewSubclassBinding() }) }
//	}
//#endif
