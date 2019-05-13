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

extension BindingParser where Downcast: SearchBarBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, SearchBar.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asSearchBarBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var textInputTraits: BindingParser<Constant<TextInputTraits>, SearchBar.Binding, Downcast> { return .init(extract: { if case .textInputTraits(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .backgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, SearchBar.Binding, Downcast> { return .init(extract: { if case .barStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var image: BindingParser<Dynamic<ScopedValues<IconAndControlState, UIImage?>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var inputAccessoryView: BindingParser<Dynamic<UIView?>, SearchBar.Binding, Downcast> { return .init(extract: { if case .inputAccessoryView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, SearchBar.Binding, Downcast> { return .init(extract: { if case .isTranslucent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var placeholder: BindingParser<Dynamic<String>, SearchBar.Binding, Downcast> { return .init(extract: { if case .placeholder(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var positionAdjustment: BindingParser<Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .positionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var prompt: BindingParser<Dynamic<String>, SearchBar.Binding, Downcast> { return .init(extract: { if case .prompt(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var scopeBarButtonBackgroundImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .scopeBarButtonBackgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var scopeBarButtonDividerImage: BindingParser<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .scopeBarButtonDividerImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var scopeBarButtonTitleTextAttributes: BindingParser<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .scopeBarButtonTitleTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var scopeButtonTitles: BindingParser<Dynamic<[String]?>, SearchBar.Binding, Downcast> { return .init(extract: { if case .scopeButtonTitles(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var searchFieldBackgroundImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .searchFieldBackgroundImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var searchFieldBackgroundPositionAdjustment: BindingParser<Dynamic<UIOffset>, SearchBar.Binding, Downcast> { return .init(extract: { if case .searchFieldBackgroundPositionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var searchTextPositionAdjustment: BindingParser<Dynamic<UIOffset>, SearchBar.Binding, Downcast> { return .init(extract: { if case .searchTextPositionAdjustment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var selectedScopeButtonIndex: BindingParser<Dynamic<Int>, SearchBar.Binding, Downcast> { return .init(extract: { if case .selectedScopeButtonIndex(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var showCancelButton: BindingParser<Dynamic<SetOrAnimate<Bool>>, SearchBar.Binding, Downcast> { return .init(extract: { if case .showCancelButton(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var showsBookmarkButton: BindingParser<Dynamic<Bool>, SearchBar.Binding, Downcast> { return .init(extract: { if case .showsBookmarkButton(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var showsScopeBar: BindingParser<Dynamic<Bool>, SearchBar.Binding, Downcast> { return .init(extract: { if case .showsScopeBar(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var showsSearchResultsButton: BindingParser<Dynamic<Bool>, SearchBar.Binding, Downcast> { return .init(extract: { if case .showsSearchResultsButton(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var text: BindingParser<Dynamic<String>, SearchBar.Binding, Downcast> { return .init(extract: { if case .text(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var tintColor: BindingParser<Dynamic<UIColor>, SearchBar.Binding, Downcast> { return .init(extract: { if case .tintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	//	3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var bookmarkButtonClicked: BindingParser<(UISearchBar) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .bookmarkButtonClicked(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var cancelButtonClicked: BindingParser<(UISearchBar) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .cancelButtonClicked(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var textDidBeginEditing: BindingParser<(UISearchBar) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .textDidBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var textDidChange: BindingParser<(UISearchBar, String) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .textDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var textDidEndEditing: BindingParser<(UISearchBar) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .textDidEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var position: BindingParser<(UIBarPositioning) -> UIBarPosition, SearchBar.Binding, Downcast> { return .init(extract: { if case .position(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var resultsListButtonClicked: BindingParser<(UISearchBar) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .resultsListButtonClicked(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var searchButtonClicked: BindingParser<(UISearchBar) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .searchButtonClicked(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var selectedScopeButtonIndexDidChange: BindingParser<(UISearchBar, Int) -> Void, SearchBar.Binding, Downcast> { return .init(extract: { if case .selectedScopeButtonIndexDidChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var shouldBeginEditing: BindingParser<(UISearchBar) -> Bool, SearchBar.Binding, Downcast> { return .init(extract: { if case .shouldBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var shouldChangeText: BindingParser<(UISearchBar, NSRange, String) -> Bool, SearchBar.Binding, Downcast> { return .init(extract: { if case .shouldChangeText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
	public static var shouldEndEditing: BindingParser<(UISearchBar) -> Bool, SearchBar.Binding, Downcast> { return .init(extract: { if case .shouldEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asSearchBarBinding() }) }
}

#endif
