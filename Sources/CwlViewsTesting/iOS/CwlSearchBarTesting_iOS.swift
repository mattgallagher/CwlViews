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

extension BindingParser where Binding == SearchBar.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var textInputTraits: BindingParser<Constant<TextInputTraits>, Binding> { return BindingParser<Constant<TextInputTraits>, Binding>(parse: { binding -> Optional<Constant<TextInputTraits>> in if case .textInputTraits(let x) = binding { return x } else { return nil } }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var backgroundImage: BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<PositionAndMetrics, UIImage?>>> in if case .backgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var barStyle: BindingParser<Dynamic<UIBarStyle>, Binding> { return BindingParser<Dynamic<UIBarStyle>, Binding>(parse: { binding -> Optional<Dynamic<UIBarStyle>> in if case .barStyle(let x) = binding { return x } else { return nil } }) }
	public static var image: BindingParser<Dynamic<ScopedValues<IconAndControlState, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<IconAndControlState, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<IconAndControlState, UIImage?>>> in if case .image(let x) = binding { return x } else { return nil } }) }
	public static var inputAccessoryView: BindingParser<Dynamic<UIView?>, Binding> { return BindingParser<Dynamic<UIView?>, Binding>(parse: { binding -> Optional<Dynamic<UIView?>> in if case .inputAccessoryView(let x) = binding { return x } else { return nil } }) }
	public static var isTranslucent: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isTranslucent(let x) = binding { return x } else { return nil } }) }
	public static var placeholder: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .placeholder(let x) = binding { return x } else { return nil } }) }
	public static var positionAdjustment: BindingParser<Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>, Binding> { return BindingParser<Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UISearchBar.Icon, UIOffset>>> in if case .positionAdjustment(let x) = binding { return x } else { return nil } }) }
	public static var prompt: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .prompt(let x) = binding { return x } else { return nil } }) }
	public static var scopeBarButtonBackgroundImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIImage?>>> in if case .scopeBarButtonBackgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var scopeBarButtonDividerImage: BindingParser<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<LeftRightControlState, UIImage?>>> in if case .scopeBarButtonDividerImage(let x) = binding { return x } else { return nil } }) }
	public static var scopeBarButtonTitleTextAttributes: BindingParser<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, [NSAttributedString.Key: Any]?>>> in if case .scopeBarButtonTitleTextAttributes(let x) = binding { return x } else { return nil } }) }
	public static var scopeButtonTitles: BindingParser<Dynamic<[String]?>, Binding> { return BindingParser<Dynamic<[String]?>, Binding>(parse: { binding -> Optional<Dynamic<[String]?>> in if case .scopeButtonTitles(let x) = binding { return x } else { return nil } }) }
	public static var searchFieldBackgroundImage: BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding> { return BindingParser<Dynamic<ScopedValues<UIControl.State, UIImage?>>, Binding>(parse: { binding -> Optional<Dynamic<ScopedValues<UIControl.State, UIImage?>>> in if case .searchFieldBackgroundImage(let x) = binding { return x } else { return nil } }) }
	public static var searchFieldBackgroundPositionAdjustment: BindingParser<Dynamic<UIOffset>, Binding> { return BindingParser<Dynamic<UIOffset>, Binding>(parse: { binding -> Optional<Dynamic<UIOffset>> in if case .searchFieldBackgroundPositionAdjustment(let x) = binding { return x } else { return nil } }) }
	public static var searchTextPositionAdjustment: BindingParser<Dynamic<UIOffset>, Binding> { return BindingParser<Dynamic<UIOffset>, Binding>(parse: { binding -> Optional<Dynamic<UIOffset>> in if case .searchTextPositionAdjustment(let x) = binding { return x } else { return nil } }) }
	public static var selectedScopeButtonIndex: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .selectedScopeButtonIndex(let x) = binding { return x } else { return nil } }) }
	public static var showCancelButton: BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding> { return BindingParser<Dynamic<SetOrAnimate<Bool>>, Binding>(parse: { binding -> Optional<Dynamic<SetOrAnimate<Bool>>> in if case .showCancelButton(let x) = binding { return x } else { return nil } }) }
	public static var showsBookmarkButton: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsBookmarkButton(let x) = binding { return x } else { return nil } }) }
	public static var showsScopeBar: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsScopeBar(let x) = binding { return x } else { return nil } }) }
	public static var showsSearchResultsButton: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .showsSearchResultsButton(let x) = binding { return x } else { return nil } }) }
	public static var text: BindingParser<Dynamic<String>, Binding> { return BindingParser<Dynamic<String>, Binding>(parse: { binding -> Optional<Dynamic<String>> in if case .text(let x) = binding { return x } else { return nil } }) }
	public static var tintColor: BindingParser<Dynamic<UIColor>, Binding> { return BindingParser<Dynamic<UIColor>, Binding>(parse: { binding -> Optional<Dynamic<UIColor>> in if case .tintColor(let x) = binding { return x } else { return nil } }) }

	// 2. Signal bindings are performed on the object after construction.

	//	3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var bookmarkButtonClicked: BindingParser<(UISearchBar) -> Void, Binding> { return BindingParser<(UISearchBar) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar) -> Void> in if case .bookmarkButtonClicked(let x) = binding { return x } else { return nil } }) }
	public static var cancelButtonClicked: BindingParser<(UISearchBar) -> Void, Binding> { return BindingParser<(UISearchBar) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar) -> Void> in if case .cancelButtonClicked(let x) = binding { return x } else { return nil } }) }
	public static var textDidBeginEditing: BindingParser<(UISearchBar) -> Void, Binding> { return BindingParser<(UISearchBar) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar) -> Void> in if case .textDidBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var textDidChange: BindingParser<(UISearchBar) -> Void, Binding> { return BindingParser<(UISearchBar) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar) -> Void> in if case .textDidChange(let x) = binding { return x } else { return nil } }) }
	public static var textDidEndEditing: BindingParser<(UISearchBar) -> Void, Binding> { return BindingParser<(UISearchBar) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar) -> Void> in if case .textDidEndEditing(let x) = binding { return x } else { return nil } }) }
	public static var position: BindingParser<(UIBarPositioning) -> UIBarPosition, Binding> { return BindingParser<(UIBarPositioning) -> UIBarPosition, Binding>(parse: { binding -> Optional<(UIBarPositioning) -> UIBarPosition> in if case .position(let x) = binding { return x } else { return nil } }) }
	public static var resultsListButtonClicked: BindingParser<(UISearchBar) -> Void, Binding> { return BindingParser<(UISearchBar) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar) -> Void> in if case .resultsListButtonClicked(let x) = binding { return x } else { return nil } }) }
	public static var searchButtonClicked: BindingParser<(UISearchBar) -> Void, Binding> { return BindingParser<(UISearchBar) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar) -> Void> in if case .searchButtonClicked(let x) = binding { return x } else { return nil } }) }
	public static var selectedScopeButtonIndexDidChange: BindingParser<(UISearchBar, Int) -> Void, Binding> { return BindingParser<(UISearchBar, Int) -> Void, Binding>(parse: { binding -> Optional<(UISearchBar, Int) -> Void> in if case .selectedScopeButtonIndexDidChange(let x) = binding { return x } else { return nil } }) }
	public static var shouldBeginEditing: BindingParser<(UISearchBar) -> Bool, Binding> { return BindingParser<(UISearchBar) -> Bool, Binding>(parse: { binding -> Optional<(UISearchBar) -> Bool> in if case .shouldBeginEditing(let x) = binding { return x } else { return nil } }) }
	public static var shouldChangeText: BindingParser<(UISearchBar, NSRange, String) -> Bool, Binding> { return BindingParser<(UISearchBar, NSRange, String) -> Bool, Binding>(parse: { binding -> Optional<(UISearchBar, NSRange, String) -> Bool> in if case .shouldChangeText(let x) = binding { return x } else { return nil } }) }
	public static var shouldEndEditing: BindingParser<(UISearchBar) -> Bool, Binding> { return BindingParser<(UISearchBar) -> Bool, Binding>(parse: { binding -> Optional<(UISearchBar) -> Bool> in if case .shouldEndEditing(let x) = binding { return x } else { return nil } }) }
}

#endif
