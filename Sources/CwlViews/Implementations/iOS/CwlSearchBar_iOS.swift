//
//  CwlSearchBar_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/12/25.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

// MARK: - Binder Part 1: Binder
public class SearchBar: Binder, SearchBarConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension SearchBar {
	enum Binding: SearchBarBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case textInputTraits(Constant<TextInputTraits>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case backgroundImage(Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>)
		case barStyle(Dynamic<UIBarStyle>)
		case image(Dynamic<ScopedValues<IconAndControlState, UIImage?>>)
		case inputAccessoryView(Dynamic<UIView?>)
		case isTranslucent(Dynamic<Bool>)
		case placeholder(Dynamic<String>)
		case positionAdjustment(Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>)
		case prompt(Dynamic<String>)
		case scopeBarButtonBackgroundImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case scopeBarButtonDividerImage(Dynamic<ScopedValues<LeftRightControlState, UIImage?>>)
		case scopeBarButtonTitleTextAttributes(Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>)
		case scopeButtonTitles(Dynamic<[String]?>)
		case searchFieldBackgroundImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case searchFieldBackgroundPositionAdjustment(Dynamic<UIOffset>)
		case searchTextPositionAdjustment(Dynamic<UIOffset>)
		case selectedScopeButtonIndex(Dynamic<Int>)
		case showCancelButton(Dynamic<SetOrAnimate<Bool>>)
		case showsBookmarkButton(Dynamic<Bool>)
		case showsScopeBar(Dynamic<Bool>)
		case showsSearchResultsButton(Dynamic<Bool>)
		case text(Dynamic<String>)
		case tintColor(Dynamic<UIColor>)

		// 2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case bookmarkButtonClicked((UISearchBar) -> Void)
		case cancelButtonClicked((UISearchBar) -> Void)
		case didBeginEditing((UISearchBar) -> Void)
		case didChange((UISearchBar) -> Void)
		case didEndEditing((UISearchBar) -> Void)
		case position((UIBarPositioning) -> UIBarPosition)
		case resultsListButtonClicked((UISearchBar) -> Void)
		case searchButtonClicked((UISearchBar) -> Void)
		case selectedScopeButtonIndexDidChange((UISearchBar, Int) -> Void)
		case shouldBeginEditing((UISearchBar) -> Bool)
		case shouldChangeText((UISearchBar, NSRange, String) -> Bool)
		case shouldEndEditing((UISearchBar) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension SearchBar {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = SearchBar.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UISearchBar
		
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
public extension SearchBar.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .bookmarkButtonClicked(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBarBookmarkButtonClicked(_:)))
		case .cancelButtonClicked(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBarCancelButtonClicked(_:)))
		case .didBeginEditing(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBarTextDidBeginEditing(_:)))
		case .didChange(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBar(_:textDidChange:)))
		case .didEndEditing(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBarTextDidEndEditing(_:)))
		case .position(let x): delegate().addSingleHandler(x, #selector(UISearchBarDelegate.position(for:)))
		case .resultsListButtonClicked(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBarResultsListButtonClicked(_:)))
		case .searchButtonClicked(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:)))
		case .selectedScopeButtonIndexDidChange(let x): delegate().addMultiHandler(x, #selector(UISearchBarDelegate.searchBar(_:selectedScopeButtonIndexDidChange:)))
		case .shouldBeginEditing(let x): delegate().addSingleHandler(x, #selector(UISearchBarDelegate.searchBarShouldBeginEditing(_:)))
		case .shouldChangeText(let x): delegate().addSingleHandler(x, #selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
		case .shouldEndEditing(let x): delegate().addSingleHandler(x, #selector(UISearchBarDelegate.searchBarShouldEndEditing(_:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .textInputTraits(let x): return x.value.apply(to: instance)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .backgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setBackgroundImage(nil, for: scope.barPosition, barMetrics: scope.barMetrics) },
				applyNew: { i, scope, v in i.setBackgroundImage(v, for: scope.barPosition, barMetrics: scope.barMetrics) }
			)
		case .barStyle(let x): return x.apply(instance) { i, v in i.barStyle = v }
		case .image(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setImage(nil, for: scope.icon, state: scope.controlState) },
				applyNew: { i, scope, v in i.setImage(v, for: scope.icon, state: scope.controlState) }
			)
		case .inputAccessoryView(let x): return x.apply(instance) { i, v in i.inputAccessoryView = v }
		case .isTranslucent(let x): return x.apply(instance) { i, v in i.isTranslucent = v }
		case .placeholder(let x): return x.apply(instance) { i, v in i.placeholder = v }
		case .positionAdjustment(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setPositionAdjustment(UIOffset(), for: scope) },
				applyNew: { i, scope, v in i.setPositionAdjustment(v, for: scope) }
			)
		case .prompt(let x): return x.apply(instance) { i, v in i.prompt = v }
		case .scopeBarButtonBackgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setScopeBarButtonBackgroundImage(nil, for: scope) },
				applyNew: { i, scope, v in i.setScopeBarButtonBackgroundImage(v, for: scope) }
			)
		case .scopeBarButtonDividerImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setScopeBarButtonDividerImage(nil, forLeftSegmentState: scope.left, rightSegmentState: scope.right) },
				applyNew: { i, scope, v in i.setScopeBarButtonDividerImage(v, forLeftSegmentState: scope.left, rightSegmentState: scope.right) }
			)
		case .scopeBarButtonTitleTextAttributes(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setScopeBarButtonTitleTextAttributes(nil, for: scope) },
				applyNew: { i, scope, v in i.setScopeBarButtonTitleTextAttributes(v, for: scope) }
			)
		case .scopeButtonTitles(let x): return x.apply(instance) { i, v in i.scopeButtonTitles = v }
		case .searchFieldBackgroundImage(let x):
			return x.apply(
				instance: instance,
				removeOld: { i, scope, v in i.setScopeBarButtonBackgroundImage(nil, for: scope) },
				applyNew: { i, scope, v in i.setScopeBarButtonBackgroundImage(v, for: scope) }
			)
		case .searchFieldBackgroundPositionAdjustment(let x): return x.apply(instance) { i, v in i.searchFieldBackgroundPositionAdjustment = v }
		case .searchTextPositionAdjustment(let x): return x.apply(instance) { i, v in i.searchTextPositionAdjustment = v }
		case .selectedScopeButtonIndex(let x): return x.apply(instance) { i, v in i.selectedScopeButtonIndex = v }
		case .showCancelButton(let x): return x.apply(instance) { i, v in i.setShowsCancelButton(v.value, animated: v.isAnimated) }
		case .showsBookmarkButton(let x): return x.apply(instance) { i, v in i.showsBookmarkButton = v }
		case .showsScopeBar(let x): return x.apply(instance) { i, v in i.showsScopeBar = v }
		case .showsSearchResultsButton(let x): return x.apply(instance) { i, v in i.showsSearchResultsButton = v }
		case .text(let x): return x.apply(instance) { i, v in i.text = v }
		case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }

		// 2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.
		case .didChange: return nil
		case .didBeginEditing: return nil
		case .didEndEditing: return nil
		case .bookmarkButtonClicked: return nil
		case .cancelButtonClicked: return nil
		case .searchButtonClicked: return nil
		case .resultsListButtonClicked: return nil
		case .selectedScopeButtonIndexDidChange: return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .position: return nil
		case .shouldChangeText: return nil
		case .shouldBeginEditing: return nil
		case .shouldEndEditing: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SearchBar.Preparer {
	open class Storage: View.Preparer.Storage, UISearchBarDelegate {}
	
	open class Delegate: DynamicDelegate, UISearchBarDelegate {
		open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			multiHandler(searchBar, searchText)
		}
		
		open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
			multiHandler(searchBar)
		}
		
		open func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
			multiHandler(searchBar)
		}
		
		open func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
			multiHandler(searchBar)
		}
		
		open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
			multiHandler(searchBar)
		}
		
		open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
			multiHandler(searchBar)
		}
		
		open func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
			multiHandler(searchBar)
		}
		
		open func searchBarSelectedScopeButtonIndexDidChange(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
			multiHandler(searchBar, selectedScope)
		}
		
		open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
			return singleHandler(searchBar)
		}
		
		open func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
			return singleHandler(searchBar)
		}
		
		open func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			return singleHandler(searchBar, range, text)
		}
		
		open func position(for bar: UIBarPositioning) -> UIBarPosition {
			return singleHandler(bar)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SearchBarBinding {
	public typealias SearchBarName<V> = BindingName<V, SearchBar.Binding, Binding>
	private typealias B = SearchBar.Binding
	private static func name<V>(_ source: @escaping (V) -> SearchBar.Binding) -> SearchBarName<V> {
		return SearchBarName<V>(source: source, downcast: Binding.searchBarBinding)
	}
}
public extension BindingName where Binding: SearchBarBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SearchBarName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var textInputTraits: SearchBarName<Constant<TextInputTraits>> { return .name(B.textInputTraits) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var backgroundImage: SearchBarName<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>> { return .name(B.backgroundImage) }
	static var barStyle: SearchBarName<Dynamic<UIBarStyle>> { return .name(B.barStyle) }
	static var image: SearchBarName<Dynamic<ScopedValues<IconAndControlState, UIImage?>>> { return .name(B.image) }
	static var inputAccessoryView: SearchBarName<Dynamic<UIView?>> { return .name(B.inputAccessoryView) }
	static var isTranslucent: SearchBarName<Dynamic<Bool>> { return .name(B.isTranslucent) }
	static var placeholder: SearchBarName<Dynamic<String>> { return .name(B.placeholder) }
	static var positionAdjustment: SearchBarName<Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>> { return .name(B.positionAdjustment) }
	static var prompt: SearchBarName<Dynamic<String>> { return .name(B.prompt) }
	static var scopeBarButtonBackgroundImage: SearchBarName<Dynamic<ScopedValues<UIControl.State, UIImage?>>> { return .name(B.scopeBarButtonBackgroundImage) }
	static var scopeBarButtonDividerImage: SearchBarName<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>> { return .name(B.scopeBarButtonDividerImage) }
	static var scopeBarButtonTitleTextAttributes: SearchBarName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>> { return .name(B.scopeBarButtonTitleTextAttributes) }
	static var scopeButtonTitles: SearchBarName<Dynamic<[String]?>> { return .name(B.scopeButtonTitles) }
	static var searchFieldBackgroundImage: SearchBarName<Dynamic<ScopedValues<UIControl.State, UIImage?>>> { return .name(B.searchFieldBackgroundImage) }
	static var searchFieldBackgroundPositionAdjustment: SearchBarName<Dynamic<UIOffset>> { return .name(B.searchFieldBackgroundPositionAdjustment) }
	static var searchTextPositionAdjustment: SearchBarName<Dynamic<UIOffset>> { return .name(B.searchTextPositionAdjustment) }
	static var selectedScopeButtonIndex: SearchBarName<Dynamic<Int>> { return .name(B.selectedScopeButtonIndex) }
	static var showCancelButton: SearchBarName<Dynamic<SetOrAnimate<Bool>>> { return .name(B.showCancelButton) }
	static var showsBookmarkButton: SearchBarName<Dynamic<Bool>> { return .name(B.showsBookmarkButton) }
	static var showsScopeBar: SearchBarName<Dynamic<Bool>> { return .name(B.showsScopeBar) }
	static var showsSearchResultsButton: SearchBarName<Dynamic<Bool>> { return .name(B.showsSearchResultsButton) }
	static var text: SearchBarName<Dynamic<String>> { return .name(B.text) }
	static var tintColor: SearchBarName<Dynamic<UIColor>> { return .name(B.tintColor) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var bookmarkButtonClicked: SearchBarName<(UISearchBar) -> Void> { return .name(B.bookmarkButtonClicked) }
	static var cancelButtonClicked: SearchBarName<(UISearchBar) -> Void> { return .name(B.cancelButtonClicked) }
	static var didBeginEditing: SearchBarName<(UISearchBar) -> Void> { return .name(B.didBeginEditing) }
	static var didChange: SearchBarName<(UISearchBar) -> Void> { return .name(B.didChange) }
	static var didEndEditing: SearchBarName<(UISearchBar) -> Void> { return .name(B.didEndEditing) }
	static var position: SearchBarName<(UIBarPositioning) -> UIBarPosition> { return .name(B.position) }
	static var resultsListButtonClicked: SearchBarName<(UISearchBar) -> Void> { return .name(B.resultsListButtonClicked) }
	static var searchButtonClicked: SearchBarName<(UISearchBar) -> Void> { return .name(B.searchButtonClicked) }
	static var selectedScopeButtonIndexDidChange: SearchBarName<(UISearchBar, Int) -> Void> { return .name(B.selectedScopeButtonIndexDidChange) }
	static var shouldBeginEditing: SearchBarName<(UISearchBar) -> Bool> { return .name(B.shouldBeginEditing) }
	static var shouldChangeText: SearchBarName<(UISearchBar, NSRange, String) -> Bool> { return .name(B.shouldChangeText) }
	static var shouldEndEditing: SearchBarName<(UISearchBar) -> Bool> { return .name(B.shouldEndEditing) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SearchBarConvertible: ViewConvertible {
	func uiSearchBar() -> SearchBar.Instance
}
extension SearchBarConvertible {
	public func uiView() -> View.Instance { return uiSearchBar() }
}
extension UISearchBar: SearchBarConvertible, HasDelegate {
	public func uiSearchBar() -> SearchBar.Instance { return self }
}
public extension SearchBar {
	func uiSearchBar() -> SearchBar.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SearchBarBinding: ViewBinding {
	static func searchBarBinding(_ binding: SearchBar.Binding) -> Self
}
public extension SearchBarBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return searchBarBinding(.inheritedBinding(binding))
	}
}
public extension SearchBar.Binding {
	typealias Preparer = SearchBar.Preparer
	static func searchBarBinding(_ binding: SearchBar.Binding) -> SearchBar.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct LeftRightControlState {
	public let left: UIControl.State
	public let right: UIControl.State
	public init(left: UIControl.State = .normal, right: UIControl.State = .normal) {
		self.left = left
		self.right = right
	}
}

public struct IconAndControlState {
	public let icon: UISearchBar.Icon
	public let controlState: UIControl.State
	public init(icon: UISearchBar.Icon = .search, state: UIControl.State = .normal) {
		self.icon = icon
		self.controlState = state
	}
}

extension ScopedValues where Scope == LeftRightControlState {
	public static func normal(right: UIControl.State = .normal, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: LeftRightControlState(left: .normal, right: right))
	}
	public static func highlighted(right: UIControl.State = .highlighted, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: LeftRightControlState(left: .highlighted, right: right))
	}
	public static func disabled(right: UIControl.State = .disabled, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: LeftRightControlState(left: .disabled, right: right))
	}
	public static func selected(right: UIControl.State = .selected, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: LeftRightControlState(left: .selected, right: right))
	}
	public static func focused(right: UIControl.State = .focused, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: LeftRightControlState(left: .focused, right: right))
	}
	public static func application(right: UIControl.State = .application, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: LeftRightControlState(left: .application, right: right))
	}
	public static func reserved(right: UIControl.State = .reserved, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: LeftRightControlState(left: .reserved, right: right))
	}
}

extension ScopedValues where Scope == IconAndControlState {
	public static func search(state: UIControl.State = .normal, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: IconAndControlState(icon: .search, state: state))
	}
	public static func clear(state: UIControl.State = .normal, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: IconAndControlState(icon: .clear, state: state))
	}
	public static func bookmark(state: UIControl.State = .normal, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: IconAndControlState(icon: .bookmark, state: state))
	}
	public static func resultsList(state: UIControl.State = .normal, _ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: IconAndControlState(icon: .resultsList, state: state))
	}
}

extension ScopedValues where Scope == UISearchBar.Icon {
	public static func search(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .search)
	}
	public static func clear(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .clear)
	}
	public static func bookmark(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .bookmark)
	}
	public static func resultsList(_ value: Value) -> ScopedValues<Scope, Value> {
		return .value(value, for: .resultsList)
	}
}

#endif
