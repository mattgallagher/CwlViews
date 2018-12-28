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

public class SearchBar: Binder, SearchBarConvertible {
	public typealias Instance = UISearchBar
	public typealias Inherited = View
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiSearchBar() -> Instance { return instance() }
	
	enum Binding: SearchBarBinding {
		public typealias EnclosingBinder = SearchBar
		public static func searchBarBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case textInputTraits(Constant<TextInputTraits>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case placeholder(Dynamic<String>)
		case prompt(Dynamic<String>)
		case text(Dynamic<String>)
		case barStyle(Dynamic<UIBarStyle>)
		case tintColor(Dynamic<UIColor>)
		case isTranslucent(Dynamic<Bool>)
		case showsBookmarkButton(Dynamic<Bool>)
		case showsSearchResultsButton(Dynamic<Bool>)
		case showCancelButton(Dynamic<SetOrAnimate<Bool>>)
		case scopeButtonTitles(Dynamic<[String]?>)
		case selectedScopeButtonIndex(Dynamic<Int>)
		case showsScopeBar(Dynamic<Bool>)
		case backgroundImage(Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>)
		case image(Dynamic<ScopedValues<IconAndControlState, UIImage?>>)
		case positionAdjustment(Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>)
		case inputAccessoryView(Dynamic<UIView?>)
		case scopeBarButtonBackgroundImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case scopeBarButtonDividerImage(Dynamic<ScopedValues<LeftRightControlState, UIImage?>>)
		case scopeBarButtonTitleTextAttributes(Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>)
		case searchFieldBackgroundImage(Dynamic<ScopedValues<UIControl.State, UIImage?>>)
		case searchFieldBackgroundPositionAdjustment(Dynamic<UIOffset>)
		case searchTextPositionAdjustment(Dynamic<UIOffset>)

		// 2. Signal bindings are performed on the object after construction.

		//	3. Action bindings are triggered by the object after construction.
		case didChange(SignalInput<String>)
		case didBeginEditing(SignalInput<Void>)
		case didEndEditing(SignalInput<Void>)
		case bookmarkButtonClicked(SignalInput<Void>)
		case cancelButtonClicked(SignalInput<Void>)
		case searchButtonClicked(SignalInput<String>)
		case resultsListButtonClicked(SignalInput<Void>)
		case selectedScopeButtonIndexDidChange(SignalInput<Int>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldChangeText((NSRange, String) -> Bool)
		case shouldBeginEditing((UISearchBar) -> Bool)
		case shouldEndEditing((UISearchBar) -> Bool)
		case position((UIBarPositioning) -> UIBarPosition)
	}

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = SearchBar
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }

		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var dynamicDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = dynamicDelegate {
				return d
			} else {
				let d = delegateClass.init()
				dynamicDelegate = d
				return d
			}
		}

		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .didChange(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBar(_:textDidChange:)))
			case .didBeginEditing(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarTextDidBeginEditing(_:)))
			case .didEndEditing(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarTextDidEndEditing(_:)))
			case .bookmarkButtonClicked(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarBookmarkButtonClicked(_:)))
			case .cancelButtonClicked(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarCancelButtonClicked(_:)))
			case .searchButtonClicked(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:)))
			case .resultsListButtonClicked(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarResultsListButtonClicked(_:)))
			case .selectedScopeButtonIndexDidChange(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBar(_:selectedScopeButtonIndexDidChange:)))
			case .shouldChangeText(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
			case .shouldBeginEditing(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarShouldBeginEditing(_:)))
			case .shouldEndEditing(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.searchBarShouldEndEditing(_:)))
			case .position(let x): delegate().addHandler(x, #selector(UISearchBarDelegate.position(for:)))
			case .inheritedBinding(let x): inherited.prepareBinding(x)
			default: break
			}
		}

		public func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = dynamicDelegate
			if storage.inUse {
				instance.delegate = storage
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .textInputTraits(let x):
				return AggregateLifetime(lifetimes: x.value.bindings.lazy.compactMap { trait in
					switch trait {
					case .autocapitalizationType(let y): return y.apply(instance) { i, v in i.autocapitalizationType = v }
					case .autocorrectionType(let y): return y.apply(instance) { i, v in i.autocorrectionType = v }
					case .spellCheckingType(let y): return y.apply(instance) { i, v in i.spellCheckingType = v }
					case .enablesReturnKeyAutomatically(let y): return y.apply(instance) { i, v in i.enablesReturnKeyAutomatically = v }
					case .keyboardAppearance(let y): return y.apply(instance) { i, v in i.keyboardAppearance = v }
					case .keyboardType(let y): return y.apply(instance) { i, v in i.keyboardType = v }
					case .returnKeyType(let y): return y.apply(instance) { i, v in i.returnKeyType = v }
					case .isSecureTextEntry(let y): return y.apply(instance) { i, v in i.isSecureTextEntry = v }
					case .textContentType(let y):
						return y.apply(instance) { i, v in
							if #available(iOS 10.0, *) {
								i.textContentType = v
							}
						}
					case .smartDashesType(let x):
						return x.apply(instance) { i, v in
							if #available(iOS 11.0, *) {
								i.smartDashesType = v
							}
						}
					case .smartQuotesType(let x):
						return x.apply(instance) { i, v in
							if #available(iOS 11.0, *) {
								i.smartQuotesType = v
							}
						}
					case .smartInsertDeleteType(let x):
						return x.apply(instance) { i, v in
							if #available(iOS 11.0, *) {
								i.smartInsertDeleteType = v
							}
						}
					}
				})
			case .placeholder(let x): return x.apply(instance) { i, v in i.placeholder = v }
			case .prompt(let x): return x.apply(instance) { i, v in i.prompt = v }
			case .text(let x): return x.apply(instance) { i, v in i.text = v }
			case .barStyle(let x): return x.apply(instance) { i, v in i.barStyle = v }
			case .tintColor(let x): return x.apply(instance) { i, v in i.tintColor = v }
			case .isTranslucent(let x): return x.apply(instance) { i, v in i.isTranslucent = v }
			case .showsBookmarkButton(let x): return x.apply(instance) { i, v in i.showsBookmarkButton = v }
			case .showsSearchResultsButton(let x): return x.apply(instance) { i, v in i.showsSearchResultsButton = v }
			case .showCancelButton(let x): return x.apply(instance) { i, v in i.setShowsCancelButton(v.value, animated: v.isAnimated) }
			case .scopeButtonTitles(let x): return x.apply(instance) { i, v in i.scopeButtonTitles = v }
			case .selectedScopeButtonIndex(let x): return x.apply(instance) { i, v in i.selectedScopeButtonIndex = v }
			case .showsScopeBar(let x): return x.apply(instance) { i, v in i.showsScopeBar = v }
			case .inputAccessoryView(let x): return x.apply(instance) { i, v in i.inputAccessoryView = v }
			case .searchFieldBackgroundPositionAdjustment(let x): return x.apply(instance) { i, v in i.searchFieldBackgroundPositionAdjustment = v }
			case .searchTextPositionAdjustment(let x): return x.apply(instance) { i, v in i.searchTextPositionAdjustment = v }
			
			case .backgroundImage(let x):
				var previous: ScopedValues<PositionAndMetrics, UIImage?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for conditions in p.pairs {
							if conditions.value != nil {
								i.setBackgroundImage(nil, for: conditions.scope.barPosition, barMetrics: conditions.scope.barMetrics)
							}
						}
					}
					previous = v
					for conditions in v.pairs {
						if let image = conditions.value {
							i.setBackgroundImage(image, for: conditions.scope.barPosition, barMetrics: conditions.scope.barMetrics)
						}
					}
				}
			case .image(let x):
				var previous: ScopedValues<IconAndControlState, UIImage?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for conditions in p.pairs {
							if conditions.value != nil {
								i.setImage(nil, for: conditions.scope.icon, state: conditions.scope.controlState)
							}
						}
					}
					previous = v
					for conditions in v.pairs {
						if let image = conditions.value {
							i.setImage(image, for: conditions.scope.icon, state: conditions.scope.controlState)
						}
					}
				}
			case .positionAdjustment(let x):
				var previous: ScopedValues<UISearchBar.Icon, UIOffset>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setPositionAdjustment(UIOffset(), for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setPositionAdjustment(c.1, for: c.0)
					}
				}
			case .scopeBarButtonBackgroundImage(let x):
				var previous: ScopedValues<UIControl.State, UIImage?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setScopeBarButtonBackgroundImage(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setScopeBarButtonBackgroundImage(c.1, for: c.0)
					}
				}
			case .scopeBarButtonDividerImage(let x):
				var previous: ScopedValues<LeftRightControlState, UIImage?>? = nil
				return x.apply(instance) { i, v -> Void in
					if let p = previous {
						for conditions in p.pairs {
							i.setScopeBarButtonDividerImage(nil, forLeftSegmentState: conditions.scope.left, rightSegmentState: conditions.scope.right)
						}
					}
					previous = v
					for conditions in v.pairs {
						i.setScopeBarButtonDividerImage(conditions.value, forLeftSegmentState: conditions.scope.left, rightSegmentState: conditions.scope.right)
					}
				}
			case .scopeBarButtonTitleTextAttributes(let x):
				var previous: ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setScopeBarButtonTitleTextAttributes(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setScopeBarButtonTitleTextAttributes(c.1, for: c.0)
					}
				}
			case .searchFieldBackgroundImage(let x):
				var previous: ScopedValues<UIControl.State, UIImage?>? = nil
				return x.apply(instance) { i, v in
					if let p = previous {
						for c in p.pairs {
							i.setScopeBarButtonBackgroundImage(nil, for: c.0)
						}
					}
					previous = v
					for c in v.pairs {
						i.setScopeBarButtonBackgroundImage(c.1, for: c.0)
					}
				}
			case .didChange: return nil
			case .didBeginEditing: return nil
			case .didEndEditing: return nil
			case .bookmarkButtonClicked: return nil
			case .cancelButtonClicked: return nil
			case .searchButtonClicked: return nil
			case .resultsListButtonClicked: return nil
			case .selectedScopeButtonIndexDidChange: return nil
			case .shouldChangeText: return nil
			case .shouldBeginEditing: return nil
			case .shouldEndEditing: return nil
			case .position: return nil
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: View.Preparer.Storage, UISearchBarDelegate {}
	
	open class Delegate: DynamicDelegate, UISearchBarDelegate {
		public required override init() {
			super.init()
		}
		
		open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			handler(ofType: SignalInput<String>.self).send(value: searchText)
		}
		
		open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
			handler(ofType: SignalInput<String>.self).send(value: searchBar.text ?? "")
		}
		
		open func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func searchBarSelectedScopeButtonIndexDidChange(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
			handler(ofType: SignalInput<Int>.self).send(value: selectedScope)
		}
		
		open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
			return handler(ofType: ((_ searchBar: UISearchBar) -> Bool).self)(searchBar)
		}
		
		open func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
			return handler(ofType: ((_ searchBar: UISearchBar) -> Bool).self)(searchBar)
		}
		
		open func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			return handler(ofType: ((_ range: NSRange, _ replacementString: String) -> Bool).self)(range, text)
		}
		
		open func position(for bar: UIBarPositioning) -> UIBarPosition {
			return handler(ofType: ((UIBarPositioning) -> UIBarPosition).self)(bar)
		}
	}
}

extension BindingName where Binding: SearchBarBinding {
	// You can easily convert the `Binding` cases to `BindingName` by copying them to here and using the following Xcode-style regex:
	// Find:    case ([^\(]+)\((.+)\)$
	// Replace: public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .searchBarBinding(SearchBar.Binding.$1(v)) }) }
	public static var textInputTraits: BindingName<Constant<TextInputTraits>, Binding> { return BindingName<Constant<TextInputTraits>, Binding>({ v in .searchBarBinding(SearchBar.Binding.textInputTraits(v)) }) }
	public static var placeholder: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .searchBarBinding(SearchBar.Binding.placeholder(v)) }) }
	public static var prompt: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .searchBarBinding(SearchBar.Binding.prompt(v)) }) }
	public static var text: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .searchBarBinding(SearchBar.Binding.text(v)) }) }
	public static var barStyle: BindingName<Dynamic<UIBarStyle>, Binding> { return BindingName<Dynamic<UIBarStyle>, Binding>({ v in .searchBarBinding(SearchBar.Binding.barStyle(v)) }) }
	public static var tintColor: BindingName<Dynamic<UIColor>, Binding> { return BindingName<Dynamic<UIColor>, Binding>({ v in .searchBarBinding(SearchBar.Binding.tintColor(v)) }) }
	public static var isTranslucent: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .searchBarBinding(SearchBar.Binding.isTranslucent(v)) }) }
	public static var showsBookmarkButton: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .searchBarBinding(SearchBar.Binding.showsBookmarkButton(v)) }) }
	public static var showsSearchResultsButton: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .searchBarBinding(SearchBar.Binding.showsSearchResultsButton(v)) }) }
	public static var showCancelButton: BindingName<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingName<Dynamic<SetOrAnimate<Bool>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.showCancelButton(v)) }) }
	public static var scopeButtonTitles: BindingName<Dynamic<[String]?>, Binding> { return BindingName<Dynamic<[String]?>, Binding>({ v in .searchBarBinding(SearchBar.Binding.scopeButtonTitles(v)) }) }
	public static var selectedScopeButtonIndex: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .searchBarBinding(SearchBar.Binding.selectedScopeButtonIndex(v)) }) }
	public static var showsScopeBar: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .searchBarBinding(SearchBar.Binding.showsScopeBar(v)) }) }
	public static var backgroundImage: BindingName<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.backgroundImage(v)) }) }
	public static var image: BindingName<Dynamic<ScopedValues<IconAndControlState, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<IconAndControlState, UIImage?>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.image(v)) }) }
	public static var positionAdjustment: BindingName<Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>, Binding> { return BindingName<Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.positionAdjustment(v)) }) }
	public static var inputAccessoryView: BindingName<Dynamic<UIView?>, Binding> { return BindingName<Dynamic<UIView?>, Binding>({ v in .searchBarBinding(SearchBar.Binding.inputAccessoryView(v)) }) }
	public static var scopeBarButtonBackgroundImage: BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.scopeBarButtonBackgroundImage(v)) }) }
	public static var scopeBarButtonDividerImage: BindingName<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.scopeBarButtonDividerImage(v)) }) }
	public static var scopeBarButtonTitleTextAttributes: BindingName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.scopeBarButtonTitleTextAttributes(v)) }) }
	public static var searchFieldBackgroundImage: BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingName<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>({ v in .searchBarBinding(SearchBar.Binding.searchFieldBackgroundImage(v)) }) }
	public static var searchFieldBackgroundPositionAdjustment: BindingName<Dynamic<UIOffset>, Binding> { return BindingName<Dynamic<UIOffset>, Binding>({ v in .searchBarBinding(SearchBar.Binding.searchFieldBackgroundPositionAdjustment(v)) }) }
	public static var searchTextPositionAdjustment: BindingName<Dynamic<UIOffset>, Binding> { return BindingName<Dynamic<UIOffset>, Binding>({ v in .searchBarBinding(SearchBar.Binding.searchTextPositionAdjustment(v)) }) }
	public static var didChange: BindingName<SignalInput<String>, Binding> { return BindingName<SignalInput<String>, Binding>({ v in .searchBarBinding(SearchBar.Binding.didChange(v)) }) }
	public static var didBeginEditing: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .searchBarBinding(SearchBar.Binding.didBeginEditing(v)) }) }
	public static var didEndEditing: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .searchBarBinding(SearchBar.Binding.didEndEditing(v)) }) }
	public static var bookmarkButtonClicked: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .searchBarBinding(SearchBar.Binding.bookmarkButtonClicked(v)) }) }
	public static var cancelButtonClicked: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .searchBarBinding(SearchBar.Binding.cancelButtonClicked(v)) }) }
	public static var searchButtonClicked: BindingName<SignalInput<String>, Binding> { return BindingName<SignalInput<String>, Binding>({ v in .searchBarBinding(SearchBar.Binding.searchButtonClicked(v)) }) }
	public static var resultsListButtonClicked: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .searchBarBinding(SearchBar.Binding.resultsListButtonClicked(v)) }) }
	public static var selectedScopeButtonIndexDidChange: BindingName<SignalInput<Int>, Binding> { return BindingName<SignalInput<Int>, Binding>({ v in .searchBarBinding(SearchBar.Binding.selectedScopeButtonIndexDidChange(v)) }) }
	public static var shouldChangeText: BindingName<(NSRange, String) -> Bool, Binding> { return BindingName<(NSRange, String) -> Bool, Binding>({ v in .searchBarBinding(SearchBar.Binding.shouldChangeText(v)) }) }
	public static var shouldBeginEditing: BindingName<(UISearchBar) -> Bool, Binding> { return BindingName<(UISearchBar) -> Bool, Binding>({ v in .searchBarBinding(SearchBar.Binding.shouldBeginEditing(v)) }) }
	public static var shouldEndEditing: BindingName<(UISearchBar) -> Bool, Binding> { return BindingName<(UISearchBar) -> Bool, Binding>({ v in .searchBarBinding(SearchBar.Binding.shouldEndEditing(v)) }) }
	public static var position: BindingName<(UIBarPositioning) -> UIBarPosition, Binding> { return BindingName<(UIBarPositioning) -> UIBarPosition, Binding>({ v in .searchBarBinding(SearchBar.Binding.position(v)) }) }
}

public protocol SearchBarConvertible: ViewConvertible {
	func uiSearchBar() -> SearchBar.Instance
}
extension SearchBarConvertible {
	public func uiView() -> View.Instance { return uiSearchBar() }
}
extension SearchBar.Instance: SearchBarConvertible {
	public func uiSearchBar() -> SearchBar.Instance { return self }
}

public protocol SearchBarBinding: ViewBinding {
	static func searchBarBinding(_ binding: SearchBar.Binding) -> Self
}
extension SearchBarBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return searchBarBinding(.inheritedBinding(binding))
	}
}

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
	@available(iOS 9.0, *)
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
