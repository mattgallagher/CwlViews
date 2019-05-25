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
		case pickerData(Dynamic<ArrayMutation<[ViewData]>>)
		case showsSelectionIndicator(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case selectLocation(Signal<SetOrAnimate<PickerLocation>>)

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case attributedTitle((_ data: Data) -> NSAttributedString?)
		case didSelectLocation((_ pickerView: UIPickerView, _ data: Data) -> Void)
		case rowHeightForComponent((_ pickerView: UIPickerView, _ component: Int, _ data: [ViewData]) -> CGFloat)
		case title((_ data: Data) -> String?)
		case viewConstructor((_ identifier: String?, _ rowSignal: SignalMulti<ViewData>) -> ViewConvertible)
		case viewIdentifier((_ data: Data) -> String?)
		case widthForComponent((_ pickerView: UIPickerView, _ component: Int, _ data: [ViewData]) -> CGFloat)
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
		case .attributedTitle(let x): delegate().addSingleHandler1(x, #selector(UIPickerViewDelegate.pickerView(_:attributedTitleForRow:forComponent:)))
		case .didSelectLocation(let x): delegate().addMultiHandler2(x, #selector(UIPickerViewDelegate.pickerView(_:didSelectRow:inComponent:)))
		case .title(let x): delegate().addSingleHandler1(x, #selector(UIPickerViewDelegate.pickerView(_:titleForRow:forComponent:)))
		case .viewConstructor(let x): delegate().addSingleHandler2(x, #selector(UIPickerViewDelegate.pickerView(_:viewForRow:forComponent:reusing:)))
		case .rowHeightForComponent(let x): delegate().addSingleHandler3(x, #selector(UIPickerViewDelegate.pickerView(_:rowHeightForComponent:)))
		case .widthForComponent(let x): delegate().addSingleHandler3(x, #selector(UIPickerViewDelegate.pickerView(_:widthForComponent:)))
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

		// 0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .showsSelectionIndicator(let x): return x.apply(instance) { i, v in i.showsSelectionIndicator = v }
		case .pickerData(let x): return x.apply(instance, storage) { i, s, v in s.applyComponents(v, to: i) }

		// 2. Signal bindings are performed on the object after construction.
		case .selectLocation(let x): return x.apply(instance) { i, v in i.selectRow(v.value.row, inComponent: v.value.component, animated: v.isAnimated) }

		// 3. Action bindings are triggered by the object after construction.
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .attributedTitle: return nil
		case .didSelectLocation(_): return nil
		case .rowHeightForComponent: return nil
		case .title: return nil
		case .viewConstructor: return nil
		case .viewIdentifier(let x):
			storage.viewIdentifier = x
			return nil
		case .widthForComponent: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension PickerView.Preparer {

	open class Storage: View.Preparer.Storage, UIPickerViewDelegate, UIPickerViewDataSource {
		open override var isInUse: Bool { return true }

		open var components = [[ViewData]]()
		open var viewIdentifier: ((PickerView.Data) -> String?)?

		open func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return components.count
		}
		
		open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
			return components.at(component)?.count ?? 0
		}

		open func applyComponents(_ componentMutation: ArrayMutation<[ViewData]>, to i: UIPickerView) {
			componentMutation.insertionsAndRemovals(length: components.count, insert: { index, component in
				components.insert(component, at: index)
				i.reloadComponent(index)
			}, remove: { index in
				components.remove(at: index)
				i.reloadAllComponents()
			})
		}

	}

	open class Delegate: DynamicDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
		private func storage(in pickerView: UIPickerView) -> Storage? {
			return pickerView.delegate as? PickerView<ViewData>.Preparer.Storage
		}
		
		private func data(at row: Int, component: Int, in pickerView: UIPickerView) -> ViewData? {
			return storage(in: pickerView)?.components.at(component)?.at(row)
		}

		open func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return 0
		}

		open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
			return 0
		}

		open func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
			guard let data = data(at: row, component: component, in: pickerView) else { return nil }
			return singleHandler(PickerView.Data(location: PickerLocation(row: row, component: component), data: data))
		}

		open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
			guard let data = data(at: row, component: component, in: pickerView) else { return nil }
			return singleHandler(PickerView.Data(location: PickerLocation(row: row, component: component), data: data))
		}

		open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing previousView: UIView?) -> UIView {
			guard let data = data(at: row, component: component, in: pickerView) else {
				return UIView()
			}
			let identifier: String?
			if let viewIdentifier = storage(in: pickerView)?.viewIdentifier {
				identifier = viewIdentifier(PickerView.Data(location: PickerLocation(row: row, component: component), data: data))
			} else {
				identifier = String(component)
			}
			if let identifier = identifier, let view = previousView, let (previousIdentifier, input) = view.associatedRowIdentifierAndInput(valueType: ViewData.self), previousIdentifier == identifier {
				input.send(value: data)
				return view
			}
			let dataTuple = Input<ViewData>().multicast()
			let constructed = (singleHandler(identifier, dataTuple.signal) as ViewConvertible).uiView()
			if let identifier = identifier {
				constructed.setAssociatedRowIdentifierAndInput(identifier: identifier, to: dataTuple.input)
			}
			dataTuple.input.send(value: data)
			return constructed
		}

		open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
			guard let storage = storage(in: pickerView), let data = storage.components.at(component) else {
				let defaultRowHeightIOS12: CGFloat = 32
				return defaultRowHeightIOS12
			}
			return singleHandler(pickerView, component, data)
		}

		open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
			guard let storage = storage(in: pickerView) else { return 0 }
			guard let data = storage.components.at(component) else {
				return pickerView.bounds.width / CGFloat(max(1, storage.components.count))
			}
			return singleHandler(pickerView, component, data)
		}

		open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
			let d = data(at: row, component: component, in: pickerView)!
			return multiHandler(pickerView, PickerView.Data(location: PickerLocation(row: row, component: component), data: d))
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
	
	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var pickerData: PickerViewName<Dynamic<ArrayMutation<[Binding.ViewDataType]>>> { return .name(PickerView.Binding.pickerData) }
	static var showsSelectionIndicator: PickerViewName<Dynamic<Bool>> { return .name(PickerView.Binding.showsSelectionIndicator) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var selectLocation: PickerViewName<Signal<SetOrAnimate<PickerLocation>>> { return .name(PickerView.Binding.selectLocation) }
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var attributedTitle: PickerViewName<(_ data: PickerView<Binding.ViewDataType>.Data) -> NSAttributedString?> { return .name(PickerView.Binding.attributedTitle) }
	static var didSelectLocation: PickerViewName<(_ pickerView: UIPickerView, _ data: PickerView<Binding.ViewDataType>.Data) -> Void> { return .name(PickerView.Binding.didSelectLocation) }
	static var rowHeightForComponent: PickerViewName<(_ pickerView: UIPickerView, _ component: Int, _ data: [Binding.ViewDataType]) -> CGFloat> { return .name(PickerView.Binding.rowHeightForComponent) }
	static var title: PickerViewName<(_ data: PickerView<Binding.ViewDataType>.Data) -> String?> { return .name(PickerView.Binding.title) }
	static var viewConstructor: PickerViewName<(_ identifier: String?, _ rowSignal: SignalMulti<Binding.ViewDataType>) -> ViewConvertible> { return .name(PickerView.Binding.viewConstructor) }
	static var viewIdentifier: PickerViewName<(_ data: PickerView<Binding.ViewDataType>.Data) -> String?> { return .name(PickerView.Binding.viewIdentifier) }
	static var widthForComponent: PickerViewName<(_ pickerView: UIPickerView, _ component: Int, _ data: [Binding.ViewDataType]) -> CGFloat> { return .name(PickerView.Binding.widthForComponent) }

	// Composite binding names
	static var rowSelected: PickerViewName<SignalInput<PickerView<Binding.ViewDataType>.Data>> {
		return Binding.compositeName(
			value: { input in { picker, data -> Void in input.send(value: data) } },
			binding: PickerView.Binding.didSelectLocation,
			downcast: Binding.pickerViewBinding
		)
	}
	static var selectionChanged: PickerViewName<SignalInput<[Binding.ViewDataType]>> {
		return Binding.compositeName(
			value: { input in { pickerView, _ -> Void in
				if let components = (pickerView.delegate as? PickerView<Binding.ViewDataType>.Preparer.Storage)?.components {
					input.send(value: (0..<pickerView.numberOfComponents).compactMap {
						components.at($0)?.at(pickerView.selectedRow(inComponent: $0))
					})
				}
			} },
			binding: PickerView.Binding.didSelectLocation,
			downcast: Binding.pickerViewBinding
		)
	}
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

public struct PickerLocation {
	public let row: Int
	public let component: Int

	public init(row: Int, component: Int) {
		self.row = row
		self.component = component
	}
}

public extension PickerView {
	struct Data {
		public let location: PickerLocation
		public let data: ViewData
	}
}

private var associatedRowIdentifierAndInputKey = NSObject()
private extension UIView {
	func associatedRowIdentifierAndInput<B>(valueType: B.Type) -> (String, SignalInput<B>)? {
		return objc_getAssociatedObject(self, &associatedRowIdentifierAndInputKey) as? (String, SignalInput<B>)
	}

	func setAssociatedRowIdentifierAndInput<B>(identifier: String, to input: SignalInput<B>) {
		objc_setAssociatedObject(self, &associatedRowIdentifierAndInputKey, (identifier, input), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
	}
}

#endif
