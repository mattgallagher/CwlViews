//
//  CwlApplication_iOSTests.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 3/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
@testable import CwlViews

extension Application: TestableBinder {
	static func constructor(binding: Application.Binding) -> Preparer.Instance {
		EmbeddedObjectStorage.setEmbeddedStorage(nil, for: UIApplication.shared)
		Application.Preparer.Storage.storedApplicationConstructor = { Application(binding) }
		let storage = Application.Preparer.Storage()
		withExtendedLifetime(storage) {
			UIApplication.shared.delegate = storage
			storage.applyToSharedApplication()
		}
		return UIApplication.shared
	}
	static var shoudPerformReleaseCheck: Bool { return false }
}

class CwlApplicationTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	func testIconBadgeNumber() {
		Application.testValueBinding(
			name: .iconBadgeNumber,
			inputs: (1, 0),
			outputs: (0, 1, 0),
			getter: { $0.applicationIconBadgeNumber }
		)
	}
	func testIsIdleTimerDisabled() {
		Application.testValueBinding(
			name: .isIdleTimerDisabled,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isIdleTimerDisabled }
		)
	}
	func testIsNetworkActivityIndicatorVisible() {
		Application.testValueBinding(
			name: .isNetworkActivityIndicatorVisible,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isNetworkActivityIndicatorVisible }
		)
	}
	func testShortcutItems() {
		UIApplication.shared.shortcutItems = []
		Application.testValueBinding(
			name: .shortcutItems,
			inputs: ([UIApplicationShortcutItem(type: "a", localizedTitle: "b")], []),
			outputs: (0, 1, 0),
			getter: { $0.shortcutItems?.count ?? 0 }
		)
	}
	func testSupportShakeToEdit() {
		Application.testValueBinding(
			name: .supportShakeToEdit,
			inputs: (false, true),
			outputs: (true, false, true),
			getter: { $0.applicationSupportsShakeToEdit }
		)
	}
	func testWindow() {
		Application.testValueBinding(
			name: .window,
			inputs: (Window(.tag -- 1234), nil) as (WindowConvertible?, WindowConvertible?),
			outputs: (nil, 1234, nil),
			getter: { ($0.delegate as? Application.Preparer.Storage)?.window?.tag }
		)
	}
	
	// MARK: - 2. Signal bindings
	
	func testIgnoreInteractionEvents() {
		Application.testSignalBinding(
			name: .ignoreInteractionEvents,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isIgnoringInteractionEvents }
		)
	}
	func testRegisterForRemoteNotifications() {
		Application.testSignalBinding(
			name: .registerForRemoteNotifications,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { $0.isRegisteredForRemoteNotifications }
		)
	}

	// MARK: - 3. Action bindings
	func testDidBecomeActive() {
		Application.testActionBinding(
			name: .didBecomeActive,
			trigger: { $0.delegate?.applicationDidBecomeActive?($0) },
			validate: { _ in true }
		)
	}
	func testDidEnterBackground() {
		Application.testActionBinding(
			name: .didEnterBackground,
			trigger: { $0.delegate?.applicationDidEnterBackground?($0) },
			validate: { _ in true }
		)
	}
	func testDidFailToContinueUserActivity() {
		Application.testActionBinding(
			name: .didFailToContinueUserActivity,
			trigger: { $0.delegate?.application?($0, didFailToContinueUserActivityWithType: "abcd", error: TestError("efgh")) },
			validate: { tuple in tuple.0 == "abcd" && (tuple.1 as? TestError) == TestError("efgh") }
		)
	}
	func testDidReceiveMemoryWarning() {
		Application.testActionBinding(
			name: .didReceiveMemoryWarning,
			trigger: { $0.delegate?.applicationDidReceiveMemoryWarning?($0) },
			validate: { _ in true }
		)
	}
	func testDidReceiveRemoteNotification() {
		var result: UIBackgroundFetchResult? = nil
		let callback = { (r: UIBackgroundFetchResult) in
			result = r
		}
		Application.testActionBinding(
			name: .didReceiveRemoteNotification,
			trigger: { $0.delegate?.application?($0, didReceiveRemoteNotification: ["a": "b"], fetchCompletionHandler: callback) },
			validate: { tuple in
				tuple.callback.send(value: UIBackgroundFetchResult.noData)
				return result == UIBackgroundFetchResult.noData && tuple.value as? [String: String] == ["a": "b"]
			}
		)
	}
	func testDidRegisterRemoteNotifications() {
		Application.testActionBinding(
			name: .didRegisterRemoteNotifications,
			trigger: { $0.delegate?.application?($0, didRegisterForRemoteNotificationsWithDeviceToken: Data(base64Encoded: "1234")!) },
			validate: { token in token.value == Data(base64Encoded: "1234")! }
		)
	}
	func testHandleEventsForBackgroundURLSession() {
		var received = false
		let callback = { () -> Void in
			received = true
		}
		Application.testActionBinding(
			name: .handleEventsForBackgroundURLSession,
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
		Application.testActionBinding(
			name: .handleWatchKitExtensionRequest,
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
		Application.testActionBinding(
			name: .performAction,
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
		Application.testActionBinding(
			name: .performFetch,
			trigger: { $0.delegate?.application?($0, performFetchWithCompletionHandler: callback) },
			validate: { input in
				input.send(value: UIBackgroundFetchResult.noData)
				return result == .noData
			}
		)
	}
	func testProtectedDataDidBecomeAvailable() {
		Application.testActionBinding(
			name: .protectedDataDidBecomeAvailable,
			trigger: { $0.delegate?.applicationProtectedDataDidBecomeAvailable?($0) },
			validate: { _ in true }
		)
	}
	func testProtectedDataWillBecomeUnavailable() {
		Application.testActionBinding(
			name: .protectedDataWillBecomeUnavailable,
			trigger: { $0.delegate?.applicationProtectedDataWillBecomeUnavailable?($0) },
			validate: { _ in true }
		)
	}
	func testSignificantTimeChange() {
		Application.testActionBinding(
			name: .significantTimeChange,
			trigger: { NotificationCenter.default.post(Notification(name: UIApplication.significantTimeChangeNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillEnterForeground() {
		Application.testActionBinding(
			name: .willEnterForeground,
			trigger: { $0.delegate?.applicationWillEnterForeground?($0) },
			validate: { _ in true }
		)
	}
	func testWillResignActive() {
		Application.testActionBinding(
			name: .willResignActive,
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
		Application.testDelegateBinding(
			name: .continueUserActivity,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, continue: NSUserActivity(activityType: "asdf"), restorationHandler: callbackHandler) },
			validate: {
				received?.callback.send(value: [])
				return callbackCalled
			}
		)
	}
	func testDidDecodeRestorableState() {
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		try! archiver.encodeEncodable("asdf", forKey: "qwer")
		
		var received: NSKeyedUnarchiver? = nil
		let handler = { (r: NSKeyedUnarchiver) -> Void in
			received = r
		}
		Application.testDelegateBinding(
			name: .didDecodeRestorableState,
			handler: handler,
			trigger: { try! $0.delegate?.application?($0, didDecodeRestorableStateWith: NSKeyedUnarchiver(forReadingFrom: archiver.encodedData)) },
			validate: { try! received?.decodeTopLevelDecodable(String.self, forKey: "qwer") == "asdf" }
		)
	}
	func testDidFinishLaunching() {
		var received: [UIApplication.LaunchOptionsKey: Any]? = nil
		let handler = { (r: [UIApplication.LaunchOptionsKey: Any]?) -> Bool in
			received = r
			return true
		}
		Application.testDelegateBinding(
			name: .didFinishLaunching,
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
		Application.testDelegateBinding(
			name: .didUpdate,
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
		Application.testDelegateBinding(
			name: .open,
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
		Application.testDelegateBinding(
			name: .shouldAllowExtensionPointIdentifier,
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
		Application.testDelegateBinding(
			name: .shouldRequestHealthAuthorization,
			handler: handler,
			trigger: { $0.delegate?.applicationShouldRequestHealthAuthorization?($0) },
			validate: { received }
		)
	}
	func testViewControllerWithRestorationPath() {
		var received: [String] = []
		let handler = { (_ path: [String], _ coder: NSCoder) -> UIViewController in
			received = path
			return UIViewController(nibName: nil, bundle: nil)
		}
		Application.testDelegateBinding(
			name: .viewControllerWithRestorationPath,
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
		Application.testDelegateBinding(
			name: .willContinueUserActivity,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willContinueUserActivityWithType: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testWillEncodeRestorableState() {
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		var received: NSKeyedArchiver? = nil
		let handler = { (r: NSKeyedArchiver) -> Void in
			received = r
		}
		Application.testDelegateBinding(
			name: .willEncodeRestorableState,
			handler: handler,
			trigger: { $0.delegate?.application?($0, willEncodeRestorableStateWith: archiver) },
			validate: { received != nil }
		)
	}
	func testWillFinishLaunching() {
		var received: URL? = nil
		let handler = { (r: [UIApplication.LaunchOptionsKey: Any]?) -> Bool in
			received = r?[.url] as? URL
			return true
		}
		Application.testDelegateBinding(
			name: .willFinishLaunching,
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
		Application.testDelegateBinding(
			name: .willTerminate,
			handler: handler,
			trigger: { $0.delegate?.applicationWillTerminate?($0) },
			validate: { received }
		)
	}
	
}
