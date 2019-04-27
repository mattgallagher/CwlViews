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

extension BindingParser where Downcast: ApplicationBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Application.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asApplicationBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var iconBadgeNumber: BindingParser<Dynamic<Int>, Application.Binding, Downcast> { return .init(extract: { if case .iconBadgeNumber(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var isIdleTimerDisabled: BindingParser<Dynamic<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .isIdleTimerDisabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var isNetworkActivityIndicatorVisible: BindingParser<Dynamic<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .isNetworkActivityIndicatorVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var shortcutItems: BindingParser<Dynamic<[UIApplicationShortcutItem]?>, Application.Binding, Downcast> { return .init(extract: { if case .shortcutItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var supportShakeToEdit: BindingParser<Dynamic<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .supportShakeToEdit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var window: BindingParser<Dynamic<WindowConvertible?>, Application.Binding, Downcast> { return .init(extract: { if case .window(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var ignoreInteractionEvents: BindingParser<Signal<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .ignoreInteractionEvents(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var registerForRemoteNotifications: BindingParser<Signal<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .registerForRemoteNotifications(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var continueUserActivity: BindingParser<(_ application: UIApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .continueUserActivity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didBecomeActive: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didBecomeActive(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didDecodeRestorableState: BindingParser<(UIApplication, NSKeyedUnarchiver) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didDecodeRestorableState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didEnterBackground: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didEnterBackground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didFailToContinueUserActivity: BindingParser<(UIApplication, String, Error) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didFailToContinueUserActivity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didFinishLaunching: BindingParser<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .didFinishLaunching(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didReceiveMemoryWarning: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didReceiveMemoryWarning(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didReceiveRemoteNotification: BindingParser<(UIApplication, [AnyHashable: Any], @escaping (UIBackgroundFetchResult) -> Void) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didReceiveRemoteNotification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didRegisterRemoteNotifications: BindingParser<(UIApplication, Error) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didRegisterRemoteNotifications(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didUpdate: BindingParser<(_ application: UIApplication, NSUserActivity) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didUpdate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var handleEventsForBackgroundURLSession: BindingParser<(UIApplication, String, @escaping () -> Void) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .handleEventsForBackgroundURLSession(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var handleWatchKitExtensionRequest: BindingParser<(UIApplication, [AnyHashable : Any]?, @escaping ([AnyHashable : Any]?) -> Void) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .handleWatchKitExtensionRequest(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var open: BindingParser<(_ application: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .open(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var performAction: BindingParser<(UIApplication, UIApplicationShortcutItem, @escaping (Bool) -> Void) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .performAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var performFetch: BindingParser<(UIApplication, @escaping (UIBackgroundFetchResult) -> Void) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .performFetch(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var protectedDataDidBecomeAvailable: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .protectedDataDidBecomeAvailable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var protectedDataWillBecomeUnavailable: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .protectedDataWillBecomeUnavailable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var shouldAllowExtensionPointIdentifier: BindingParser<(_ application: UIApplication, UIApplication.ExtensionPointIdentifier) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .shouldAllowExtensionPointIdentifier(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var shouldRequestHealthAuthorization: BindingParser<(_ application: UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .shouldRequestHealthAuthorization(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var significantTimeChange: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .significantTimeChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var viewControllerWithRestorationPath: BindingParser<(_ application: UIApplication, _ path: [String], _ coder: NSCoder) -> UIViewController?, Application.Binding, Downcast> { return .init(extract: { if case .viewControllerWithRestorationPath(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willContinueUserActivity: BindingParser<(_ application: UIApplication, String) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .willContinueUserActivity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willEncodeRestorableState: BindingParser<(_ application: UIApplication, NSKeyedArchiver) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .willEncodeRestorableState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willEnterForeground: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .willEnterForeground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willFinishLaunching: BindingParser<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .willFinishLaunching(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willResignActive: BindingParser<(UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .willResignActive(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willTerminate: BindingParser<(_ application: UIApplication) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .willTerminate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
}

#endif
