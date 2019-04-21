//
//  CwlApplication_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/08/2015.
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

#if os(iOS)

extension BindingParser where Binding == Application.Binding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Binding> { return BindingParser<$2, Binding>(parse: { binding -> Optional<$2> in if case .$1(let x) = binding { return x } else { return nil } }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var iconBadgeNumber: BindingParser<Dynamic<Int>, Binding> { return BindingParser<Dynamic<Int>, Binding>(parse: { binding -> Optional<Dynamic<Int>> in if case .iconBadgeNumber(let x) = binding { return x } else { return nil } }) }
	public static var isIdleTimerDisabled: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isIdleTimerDisabled(let x) = binding { return x } else { return nil } }) }
	public static var isNetworkActivityIndicatorVisible: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .isNetworkActivityIndicatorVisible(let x) = binding { return x } else { return nil } }) }
	public static var shortcutItems: BindingParser<Dynamic<[UIApplicationShortcutItem]?>, Binding> { return BindingParser<Dynamic<[UIApplicationShortcutItem]?>, Binding>(parse: { binding -> Optional<Dynamic<[UIApplicationShortcutItem]?>> in if case .shortcutItems(let x) = binding { return x } else { return nil } }) }
	public static var supportShakeToEdit: BindingParser<Dynamic<Bool>, Binding> { return BindingParser<Dynamic<Bool>, Binding>(parse: { binding -> Optional<Dynamic<Bool>> in if case .supportShakeToEdit(let x) = binding { return x } else { return nil } }) }
	public static var window: BindingParser<Dynamic<WindowConvertible?>, Binding> { return BindingParser<Dynamic<WindowConvertible?>, Binding>(parse: { binding -> Optional<Dynamic<WindowConvertible?>> in if case .window(let x) = binding { return x } else { return nil } }) }

	//	2. Signal bindings are performed on the object after construction.
	public static var ignoreInteractionEvents: BindingParser<Signal<Bool>, Binding> { return BindingParser<Signal<Bool>, Binding>(parse: { binding -> Optional<Signal<Bool>> in if case .ignoreInteractionEvents(let x) = binding { return x } else { return nil } }) }
	public static var registerForRemoteNotifications: BindingParser<Signal<Bool>, Binding> { return BindingParser<Signal<Bool>, Binding>(parse: { binding -> Optional<Signal<Bool>> in if case .registerForRemoteNotifications(let x) = binding { return x } else { return nil } }) }

	//	3. Action bindings are triggered by the object after construction.

	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var continueUserActivity: BindingParser<(_ application: UIApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool, Binding> { return BindingParser<(_ application: UIApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool, Binding>(parse: { binding -> Optional<(_ application: UIApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool> in if case .continueUserActivity(let x) = binding { return x } else { return nil } }) }
	public static var didBecomeActive: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .didBecomeActive(let x) = binding { return x } else { return nil } }) }
	public static var didDecodeRestorableState: BindingParser<(UIApplication, NSKeyedUnarchiver) -> Void, Binding> { return BindingParser<(UIApplication, NSKeyedUnarchiver) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, NSKeyedUnarchiver) -> Void> in if case .didDecodeRestorableState(let x) = binding { return x } else { return nil } }) }
	public static var didEnterBackground: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .didEnterBackground(let x) = binding { return x } else { return nil } }) }
	public static var didFailToContinueUserActivity: BindingParser<(UIApplication, String, Error) -> Void, Binding> { return BindingParser<(UIApplication, String, Error) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, String, Error) -> Void> in if case .didFailToContinueUserActivity(let x) = binding { return x } else { return nil } }) }
	public static var didFinishLaunching: BindingParser<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding> { return BindingParser<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding>(parse: { binding -> Optional<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool> in if case .didFinishLaunching(let x) = binding { return x } else { return nil } }) }
	public static var didReceiveMemoryWarning: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .didReceiveMemoryWarning(let x) = binding { return x } else { return nil } }) }
	public static var didReceiveRemoteNotification: BindingParser<(UIApplication, [AnyHashable: Any], @escaping (UIBackgroundFetchResult) -> Void) -> Void, Binding> { return BindingParser<(UIApplication, [AnyHashable: Any], @escaping (UIBackgroundFetchResult) -> Void) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, [AnyHashable: Any], @escaping (UIBackgroundFetchResult) -> Void) -> Void> in if case .didReceiveRemoteNotification(let x) = binding { return x } else { return nil } }) }
	public static var didRegisterRemoteNotifications: BindingParser<(UIApplication, Error) -> Void, Binding> { return BindingParser<(UIApplication, Error) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, Error) -> Void> in if case .didRegisterRemoteNotifications(let x) = binding { return x } else { return nil } }) }
	public static var didUpdate: BindingParser<(_ application: UIApplication, NSUserActivity) -> Void, Binding> { return BindingParser<(_ application: UIApplication, NSUserActivity) -> Void, Binding>(parse: { binding -> Optional<(_ application: UIApplication, NSUserActivity) -> Void> in if case .didUpdate(let x) = binding { return x } else { return nil } }) }
	public static var handleEventsForBackgroundURLSession: BindingParser<(UIApplication, String, @escaping () -> Void) -> Void, Binding> { return BindingParser<(UIApplication, String, @escaping () -> Void) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, String, @escaping () -> Void) -> Void> in if case .handleEventsForBackgroundURLSession(let x) = binding { return x } else { return nil } }) }
	public static var handleWatchKitExtensionRequest: BindingParser<(UIApplication, [AnyHashable : Any]?, @escaping ([AnyHashable : Any]?) -> Void) -> Void, Binding> { return BindingParser<(UIApplication, [AnyHashable : Any]?, @escaping ([AnyHashable : Any]?) -> Void) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, [AnyHashable : Any]?, @escaping ([AnyHashable : Any]?) -> Void) -> Void> in if case .handleWatchKitExtensionRequest(let x) = binding { return x } else { return nil } }) }
	public static var open: BindingParser<(_ application: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool, Binding> { return BindingParser<(_ application: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool, Binding>(parse: { binding -> Optional<(_ application: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool> in if case .open(let x) = binding { return x } else { return nil } }) }
	public static var performAction: BindingParser<(UIApplication, UIApplicationShortcutItem, @escaping (Bool) -> Void) -> Void, Binding> { return BindingParser<(UIApplication, UIApplicationShortcutItem, @escaping (Bool) -> Void) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, UIApplicationShortcutItem, @escaping (Bool) -> Void) -> Void> in if case .performAction(let x) = binding { return x } else { return nil } }) }
	public static var performFetch: BindingParser<(UIApplication, @escaping (UIBackgroundFetchResult) -> Void) -> Void, Binding> { return BindingParser<(UIApplication, @escaping (UIBackgroundFetchResult) -> Void) -> Void, Binding>(parse: { binding -> Optional<(UIApplication, @escaping (UIBackgroundFetchResult) -> Void) -> Void> in if case .performFetch(let x) = binding { return x } else { return nil } }) }
	public static var protectedDataDidBecomeAvailable: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .protectedDataDidBecomeAvailable(let x) = binding { return x } else { return nil } }) }
	public static var protectedDataWillBecomeUnavailable: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .protectedDataWillBecomeUnavailable(let x) = binding { return x } else { return nil } }) }
	public static var shouldAllowExtensionPointIdentifier: BindingParser<(_ application: UIApplication, UIApplication.ExtensionPointIdentifier) -> Bool, Binding> { return BindingParser<(_ application: UIApplication, UIApplication.ExtensionPointIdentifier) -> Bool, Binding>(parse: { binding -> Optional<(_ application: UIApplication, UIApplication.ExtensionPointIdentifier) -> Bool> in if case .shouldAllowExtensionPointIdentifier(let x) = binding { return x } else { return nil } }) }
	public static var shouldRequestHealthAuthorization: BindingParser<(_ application: UIApplication) -> Void, Binding> { return BindingParser<(_ application: UIApplication) -> Void, Binding>(parse: { binding -> Optional<(_ application: UIApplication) -> Void> in if case .shouldRequestHealthAuthorization(let x) = binding { return x } else { return nil } }) }
	public static var significantTimeChange: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .significantTimeChange(let x) = binding { return x } else { return nil } }) }
	public static var viewControllerWithRestorationPath: BindingParser<(_ application: UIApplication, _ path: [String], _ coder: NSCoder) -> UIViewController?, Binding> { return BindingParser<(_ application: UIApplication, _ path: [String], _ coder: NSCoder) -> UIViewController?, Binding>(parse: { binding -> Optional<(_ application: UIApplication, _ path: [String], _ coder: NSCoder) -> UIViewController?> in if case .viewControllerWithRestorationPath(let x) = binding { return x } else { return nil } }) }
	public static var willContinueUserActivity: BindingParser<(_ application: UIApplication, String) -> Bool, Binding> { return BindingParser<(_ application: UIApplication, String) -> Bool, Binding>(parse: { binding -> Optional<(_ application: UIApplication, String) -> Bool> in if case .willContinueUserActivity(let x) = binding { return x } else { return nil } }) }
	public static var willEncodeRestorableState: BindingParser<(_ application: UIApplication, NSKeyedArchiver) -> Void, Binding> { return BindingParser<(_ application: UIApplication, NSKeyedArchiver) -> Void, Binding>(parse: { binding -> Optional<(_ application: UIApplication, NSKeyedArchiver) -> Void> in if case .willEncodeRestorableState(let x) = binding { return x } else { return nil } }) }
	public static var willEnterForeground: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .willEnterForeground(let x) = binding { return x } else { return nil } }) }
	public static var willFinishLaunching: BindingParser<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding> { return BindingParser<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding>(parse: { binding -> Optional<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool> in if case .willFinishLaunching(let x) = binding { return x } else { return nil } }) }
	public static var willResignActive: BindingParser<(UIApplication) -> Void, Binding> { return BindingParser<(UIApplication) -> Void, Binding>(parse: { binding -> Optional<(UIApplication) -> Void> in if case .willResignActive(let x) = binding { return x } else { return nil } }) }
	public static var willTerminate: BindingParser<(_ application: UIApplication) -> Void, Binding> { return BindingParser<(_ application: UIApplication) -> Void, Binding>(parse: { binding -> Optional<(_ application: UIApplication) -> Void> in if case .willTerminate(let x) = binding { return x } else { return nil } }) }
}

#endif
