//
//  CwlApplicationTests.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 3/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
@testable import CwlViews

func appConstructor(_ binding: Application.Binding) -> Application.Instance {
	let storedConstruction = Application.Storage.storedBinderConstruction { Application(binding) }
	let storage = Application.Storage()
	withExtendedLifetime(storage) {
		UIApplication.shared.delegate = storage
		Application.Storage.applyStoredBinderConstructionToGlobalDelegate(storedConstruction)
	}
	return UIApplication.shared
}

class CwlApplicationTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	func testAdditionalWindows() {
		test(
			dynamicBinding: .additionalWindows,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ([Window()], 1),
			second: ([], 0),
			getter: { $0.windows.count }
		)
	}
	func testIconBadgeNumber() {
		test(
			dynamicBinding: .iconBadgeNumber,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (1, 1),
			second: (0, 0),
			getter: { $0.applicationIconBadgeNumber }
		)
	}
	func testIsIdleTimerDisabled() {
		test(
			dynamicBinding: .isIdleTimerDisabled,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isIdleTimerDisabled }
		)
	}
	func testIsNetworkActivityIndicatorVisible() {
		test(
			dynamicBinding: .isNetworkActivityIndicatorVisible,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isNetworkActivityIndicatorVisible }
		)
	}
	func testShortcutItems() {
		test(
			dynamicBinding: .shortcutItems,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ([UIApplicationShortcutItem(type: "a", localizedTitle: "b")], 1),
			second: ([], 0),
			getter: { $0.shortcutItems?.count ?? 0 }
		)
	}
	func testSupportShakeToEdit() {
		test(
			dynamicBinding: .supportShakeToEdit,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: true,
			first: (false, false),
			second: (true, true),
			getter: { $0.applicationSupportsShakeToEdit }
		)
	}
	func testWindow() {
		test(
			dynamicBinding: .window,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: (Window(.tag -- 1234), 1234),
			second: (nil, nil),
			getter: { ($0.delegate as? Application.Storage)?.window?.tag }
		)
	}
	
	// MARK: - 2. Signal bindings
	
	func testIgnoreInteractionEvents() {
		test(
			signalBinding: .ignoreInteractionEvents,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isIgnoringInteractionEvents }
		)
	}
	func testRegisterForRemoteNotifications() {
		test(
			signalBinding: .registerForRemoteNotifications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isRegisteredForRemoteNotifications }
		)
	}

	// MARK: - 3. Action bindings
	func testDidBecomeActive() {
		test(
			actionBinding: .didBecomeActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationDidBecomeActive?($0) },
			validate: { _ in true }
		)
	}
	func testDidEnterBackground() {
		test(
			actionBinding: .didEnterBackground,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationDidEnterBackground?($0) },
			validate: { _ in true }
		)
	}
	func testDidFailToContinueUserActivity() {
		test(
			actionBinding: .didFailToContinueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didFailToContinueUserActivityWithType: "abcd", error: NSError(domain: "efgh", code: 1, userInfo: nil)) },
			validate: { tuple in tuple.0 == "abcd" && (tuple.1 as NSError).domain == "efgh" }
		)
	}
	func testDidReceiveMemoryWarning() {
		test(
			actionBinding: .didReceiveMemoryWarning,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationDidReceiveMemoryWarning?($0) },
			validate: { _ in true }
		)
	}
	func testDidReceiveRemoteNotification() {
		var result: UIBackgroundFetchResult? = nil
		let callback = { (r: UIBackgroundFetchResult) in
			result = r
		}
		test(
			actionBinding: .didReceiveRemoteNotification,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didReceiveRemoteNotification: ["a": "b"], fetchCompletionHandler: callback) },
			validate: { tuple in
				tuple.callback.send(value: UIBackgroundFetchResult.noData)
				return result == UIBackgroundFetchResult.noData && tuple.value as? [String: String] == ["a": "b"]
			}
		)
	}
	func testDidRegisterRemoteNotifications() {
		test(
			actionBinding: .didRegisterRemoteNotifications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didRegisterForRemoteNotificationsWithDeviceToken: Data(base64Encoded: "1234")!) },
			validate: { token in token.value == Data(base64Encoded: "1234")! }
		)
	}
	func testHandleEventsForBackgroundURLSession() {
		var received = false
		let callback = { () -> Void in
			received = true
		}
		test(
			actionBinding: .handleEventsForBackgroundURLSession,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, handleEventsForBackgroundURLSession: "abcd", completionHandler: callback) },
			validate: { tuple in
				tuple.callback.send(value: ())
				return received == true && tuple.value == "abcd"
		}
		)
	}
	func testHandleWatchKitExtensionRequest() {
		var result: [AnyHashable: Any]? = nil
		let callback = { (r: [AnyHashable: Any]?) -> Void in
			result = r
		}
		test(
			actionBinding: .handleWatchKitExtensionRequest,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, handleWatchKitExtensionRequest: ["b": "c"], reply: callback) },
			validate: { tuple in
				tuple.callback.send(value: ["d": "e"])
				return result as? [String: String] == ["d": "e"] && tuple.value as? [String: String] == ["b": "c"]
			}
		)
	}
	func testPerformAction() {
		var result: Bool? = nil
		let callback = { (r: Bool) -> Void in
			result = r
		}
		test(
			actionBinding: .performAction,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, performActionFor: UIApplicationShortcutItem(type: "a", localizedTitle: "b"), completionHandler: callback) },
			validate: { tuple in
				tuple.callback.send(value: true)
				return result == true && tuple.value.localizedTitle == "b"
		}
		)
	}
	func testPerformFetch() {
		var result: UIBackgroundFetchResult? = nil
		let callback = { (r: UIBackgroundFetchResult) -> Void in
			result = r
		}
		test(
			actionBinding: .performFetch,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, performFetchWithCompletionHandler: callback) },
			validate: { input in
				input.send(value: UIBackgroundFetchResult.noData)
				return result == .noData
			}
		)
	}
	func testProtectedDataDidBecomeAvailable() {
		test(
			actionBinding: .protectedDataDidBecomeAvailable,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationProtectedDataDidBecomeAvailable?($0) },
			validate: { _ in true }
		)
	}
	func testProtectedDataWillBecomeUnavailable() {
		test(
			actionBinding: .protectedDataWillBecomeUnavailable,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationProtectedDataWillBecomeUnavailable?($0) },
			validate: { _ in true }
		)
	}
	func testSignificantTimeChange() {
		test(
			actionBinding: .significantTimeChange,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: UIApplication.significantTimeChangeNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillEnterForeground() {
		test(
			actionBinding: .willEnterForeground,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationWillEnterForeground?($0) },
			validate: { _ in true }
		)
	}
	func testWillResignActive() {
		test(
			actionBinding: .willResignActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationWillResignActive?($0) },
			validate: { _ in true }
		)
	}

	// MARK: - 4. Delegate bindings
	
	func testContinueUserActivity() {
		var callbackCalled: Bool = false
		let callbackHandler = { (a: [UIUserActivityRestoring]?) -> Void in
			callbackCalled = true
		}
		var received: Callback<NSUserActivity, [UIUserActivityRestoring]?>? = nil
		let handler = { (r: Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool in
			received = r
			return true
		}
		test(
			delegateBinding: .continueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, continue: NSUserActivity(activityType: "asdf"), restorationHandler: callbackHandler) },
			validate: {
				received?.callback.send(value: [])
				return callbackCalled
			}
		)
	}
	func testDidDecodeRestorableState() {
		let data = NSKeyedArchiver.archivedData(withRootObject: "hello")
		var received: NSKeyedUnarchiver? = nil
		let handler = { (r: NSKeyedUnarchiver) -> Void in
			received = r
		}
		test(
			delegateBinding: .didDecodeRestorableState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { try! $0.delegate?.application?($0, didDecodeRestorableStateWith: NSKeyedUnarchiver(forReadingFrom: data)) },
			validate: { received != nil }
		)
	}
	func testDidFinishLaunching() {
		var received: [UIApplication.LaunchOptionsKey: Any]? = nil
		let handler = { (r: [UIApplication.LaunchOptionsKey: Any]?) -> Bool in
			received = r
			return true
		}
		test(
			delegateBinding: .didFinishLaunching,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, didFinishLaunchingWithOptions: [.url: URL(fileURLWithPath: "qwer")]) },
			validate: { received?[.url] as? URL == URL(fileURLWithPath: "qwer") }
		)
	}
	func testDidUpdate() {
		var received: NSUserActivity? = nil
		let handler = { (r: NSUserActivity) -> Void in
			received = r
		}
		test(
			delegateBinding: .didUpdate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, didUpdate: NSUserActivity(activityType: "xcvb")) },
			validate: { received?.activityType == "xcvb" }
		)
	}
	func testOpen() {
		var url: URL? = nil
		var options: [UIApplication.OpenURLOptionsKey: Any]? = nil
		let handler = { (u: URL, o: [UIApplication.OpenURLOptionsKey: Any]) -> Bool in
			url = u
			options = o
			return true
		}
		test(
			delegateBinding: .open,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, open: URL(fileURLWithPath: "asdf"), options: [UIApplication.OpenURLOptionsKey.annotation: "qwer"]) },
			validate: { url == URL(fileURLWithPath: "asdf") && options?[.annotation] as? String == "qwer" }
		)
	}
	func testShouldAllowExtensionPointIdentifier() {
		var received: UIApplication.ExtensionPointIdentifier? = nil
		let handler = { (r: UIApplication.ExtensionPointIdentifier) -> Bool in
			received = r
			return true
		}
		test(
			delegateBinding: .shouldAllowExtensionPointIdentifier,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, shouldAllowExtensionPointIdentifier: .keyboard) },
			validate: { received == .keyboard }
		)
	}
	func testShouldRequestHealthAuthorization() {
		var received: Bool = false
		let handler = { () -> Void in
			received = true
		}
		test(
			delegateBinding: .shouldRequestHealthAuthorization,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { $0.delegate?.applicationShouldRequestHealthAuthorization?($0) },
			validate: { received }
		)
	}
	func testShouldRestoreApplicationState() {
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Bool in
			received = r
			return true
		}
		test(
			delegateBinding: .shouldRestoreApplicationState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, shouldRestoreApplicationState: NSKeyedArchiver(forWritingWith: NSMutableData())) },
			validate: { received != nil }
		)
	}
	func testShouldSaveApplicationState() {
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Bool in
			received = r
			return true
		}
		test(
			delegateBinding: .shouldSaveApplicationState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, shouldSaveApplicationState: NSKeyedArchiver(forWritingWith: NSMutableData())) },
			validate: { received != nil }
		)
	}
	func testViewControllerWithRestorationPath() {
		var received: [String] = []
		let handler = { (_ path: [String], _ coder: NSCoder) -> UIViewController in
			received = path
			return UIViewController(nibName: nil, bundle: nil)
		}
		test(
			delegateBinding: .viewControllerWithRestorationPath,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, viewControllerWithRestorationIdentifierPath: ["asdf"], coder: NSKeyedArchiver(forWritingWith: NSMutableData())) },
			validate: { received == ["asdf"] }
		)
	}
	func testWillContinueUserActivity() {
		var received: String? = nil
		let handler = { (r: String) -> Bool in
			received = r
			return true
		}
		test(
			delegateBinding: .willContinueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willContinueUserActivityWithType: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testWillEncodeRestorableState() {
		var received: NSKeyedArchiver? = nil
		let handler = { (r: NSKeyedArchiver) -> Void in
			received = r
		}
		test(
			delegateBinding: .willEncodeRestorableState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { $0.delegate?.application?($0, willEncodeRestorableStateWith: NSKeyedArchiver(forWritingWith: NSMutableData())) },
			validate: { received != nil }
		)
	}
	func testWillFinishLaunching() {
		var received: URL? = nil
		let handler = { (r: [UIApplication.LaunchOptionsKey: Any]?) -> Bool in
			received = r?[.url] as? URL
			return true
		}
		test(
			delegateBinding: .willFinishLaunching,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: URL(fileURLWithPath: "asdf")]) },
			validate: { received == URL(fileURLWithPath: "asdf") }
		)
	}
	func testWillTerminate() {
		var received: Bool = false
		let handler = { () -> Void in
			received = true
		}
		test(
			delegateBinding: .willTerminate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { $0.delegate?.applicationWillTerminate?($0) },
			validate: { received }
		)
	}
	
}
