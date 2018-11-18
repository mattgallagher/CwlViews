//
//  CwlApplication_macOSTests.swift
//  CwlViews_macOSTests
//
//  Created by Matt Gallagher on 3/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CloudKit
import XCTest
import CwlViews_macOSTestsHarness
@testable import CwlViews

func appConstructor(_ binding: Application.Binding) -> Application.Instance {
	NSApplication.shared.delegate = nil
	Application(binding).applyBindings(to: NSApplication.shared)
	return NSApplication.shared
}

class CwlApplicationTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	func testActivationPolicy() {
		testValueBinding(
			name: .activationPolicy,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: .regular,
			first: (.accessory, .accessory),
			second: (.regular, .regular),
			getter: { $0.activationPolicy() }
		)
	}
	func testApplicationIconImage() {
		let appImage = NSApplication.shared.applicationIconImage!
		let testImage = NSImage(size: NSSize(width: 3, height: 3))
		testValueBinding(
			name: .applicationIconImage,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: appImage.size.width,
			first: (testImage, 3),
			second: (nil, appImage.size.width),
			getter: { $0.applicationIconImage.size.width }
		)
	}
	func testDockMenu() {
		testValueBinding(
			name: .dockMenu,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: (Menu(.title -- "asdf") as MenuConvertible?, "asdf"),
			second: (nil, nil),
			getter: { $0.delegate?.applicationDockMenu?($0)?.title }
		)
	}
	func testMainMenu() {
		let originalMenu = NSApplication.shared.mainMenu as MenuConvertible?
		testValueBinding(
			name: .mainMenu,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: "Main Menu",
			first: (Menu(.title -- "asdf"), "asdf"),
			second: (originalMenu, "Main Menu"),
			getter: { $0.mainMenu?.title }
		)
	}
	func testMenuBarVisible() {
		testValueBinding(
			name: .menuBarVisible,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: true,
			first: (false, false),
			second: (true, true),
			getter: { _ in NSMenu.menuBarVisible() }
		)
	}
	func testPresentationOptions() {
		testValueBinding(
			name: .presentationOptions,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: [],
			first: (.disableAppleMenu, .disableAppleMenu),
			second: ([], []),
			getter: { $0.presentationOptions }
		)
	}
	func testRelauchOnLogin() {
		testValueBinding(
			name: .relauchOnLogin,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { ($0 as! ApplicationSubclass).relaunchOnLogin }
		)
	}
	func testRemoteNotifications() {
		testValueBinding(
			name: .remoteNotifications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: [],
			first: (.badge, .badge),
			second: ([], []),
			getter: { $0.enabledRemoteNotificationTypes }
		)
	}
	
	// MARK: - 2. Signal bindings
	
	func testActivate() {
		(NSApplication.shared as! ApplicationSubclass).testingActivate = true
		defer { (NSApplication.shared as! ApplicationSubclass).testingActivate = false }
		
		testSignalBinding(
			name: .activate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: (true, true),
			second: (false, false),
			getter: { ($0 as! ApplicationSubclass).activated }
		)
	}
	func testArrangeInFront() {
		testSignalBinding(
			name: .arrangeInFront,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).arrangeInFrontCount }
		)
	}
	func testDeactivate() {
		testSignalBinding(
			name: .deactivate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).deactivateCount }
		)
	}
	func testHide() {
		testSignalBinding(
			name: .hide,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).hideCount }
		)
	}
	func testHideOtherApplications() {
		testSignalBinding(
			name: .hideOtherApplications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).hideOtherApplicationsCount }
		)
	}
	func testMiniaturizeAll() {
		testSignalBinding(
			name: .miniaturizeAll,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).miniaturizeAllCount }
		)
	}
	func testOrderFrontCharacterPalette() {
		testSignalBinding(
			name: .orderFrontCharacterPalette,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).orderFrontCharacterPaletteCount }
		)
	}
	func testOrderFrontColorPanel() {
		testSignalBinding(
			name: .orderFrontColorPanel,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).orderFrontColorPanelCount }
		)
	}
	func testOrderFrontStandardAboutPanel() {
		testSignalBinding(
			name: .orderFrontStandardAboutPanel,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: ([.applicationName: "asdf"], [.applicationName: "asdf"]),
			second: ([.applicationName: "qwer"], [.applicationName: "qwer"]),
			getter: { ($0 as! ApplicationSubclass).orderFrontStandardAboutPanelOptions.last as? [NSApplication.AboutPanelOptionKey: String] }
		)
	}
	func testPresentError() {
		var received: Bool? = nil
		let dummy = undeclaredError()
		let input = Signal<Bool>.multiChannel().subscribeValuesUntilEnd { received = $0 }
		testSignalBinding(
			name: .presentError,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: nil as Bool?,
			first: (Callback(dummy, input), false as Bool?),
			second: (Callback(dummy, input), true as Bool?),
			getter: { _ in received }
		)
	} 
	func testRequestUserAttention() {
		let (input, signal) = Signal<Void>.channel().multicast().tuple
		testSignalBinding(
			name: .requestUserAttention,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: Set<NSApplication.RequestUserAttentionType>(),
			first: ((.informationalRequest, signal), Set([.informationalRequest])),
			second: ((.criticalRequest, signal), Set([.criticalRequest])),
			getter: { app in
				let value = (app as! ApplicationSubclass).outstandingUserAttentionRequests
				input.send(value: ())
				return value
			}
		)
	}
	func testTerminate() {
		testSignalBinding(
			name: .terminate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).terminateCount }
		)
	}
	func testUnhide() {
		testSignalBinding(
			name: .unhide,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: [],
			first: (true, [true]),
			second: (false, [true, false]),
			getter: { ($0 as! ApplicationSubclass).unhideCount }
		)
	}
	func testUnhideAllApplications() {
		testSignalBinding(
			name: .unhideAllApplications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ((), 1),
			second: ((), 2),
			getter: { ($0 as! ApplicationSubclass).unhideAllCount }
		)
	}
	
	// MARK: - 3. Action bindings
	func testDidBecomeActive() {
		testActionBinding(
			name: .didBecomeActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didBecomeActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidChangeOcclusionState() {
		testActionBinding(
			name: .didChangeOcclusionState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didChangeOcclusionStateNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidChangeScreenParameters() {
		testActionBinding(
			name: .didChangeScreenParameters,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didChangeScreenParametersNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidFailToContinueUserActivity() {
		testActionBinding(
			name: .didFailToContinueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didFailToContinueUserActivityWithType: "asdf", error: undeclaredError()) },
			validate: { (tuple: (userActivityType: String, error: Error)) in return tuple.userActivityType == "asdf" }
		)
	}
	func testDidFailToRegisterForRemoteNotifications() {
		testActionBinding(
			name: .didFailToRegisterForRemoteNotifications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didFailToRegisterForRemoteNotificationsWithError: undeclaredError()) },
			validate: { _ in true }
		)
	}
	func testDidFinishLaunching() {
		testActionBinding(
			name: .didFinishLaunching,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didFinishLaunchingNotification, object: $0, userInfo: ["asdf": "qwer"])) },
			validate: { (d: [AnyHashable: Any]) in d as? [String: String] == ["asdf": "qwer"] }
		)
	}
	func testDidFinishRestoringWindows() {
		testActionBinding(
			name: .didFinishRestoringWindows,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didFinishRestoringWindowsNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidHide() {
		testActionBinding(
			name: .didHide,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didHideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidReceiveRemoteNotification() {
		testActionBinding(
			name: .didReceiveRemoteNotification,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didReceiveRemoteNotification: ["asdf": "qwer"]) },
			validate: { $0 as? [String: String] == ["asdf": "qwer"] }
		)
	}
	func testDidRegisterForRemoteNotifications() {
		testActionBinding(
			name: .didRegisterForRemoteNotifications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didRegisterForRemoteNotificationsWithDeviceToken: "asdf".data(using: .utf8)!) },
			validate: { String(data: $0, encoding: .utf8) == "asdf" }
		)
	}
	func testDidResignActive() {
		testActionBinding(
			name: .didResignActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didResignActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidUnhide() {
		testActionBinding(
			name: .didUnhide,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didUnhideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidUpdate() {
		testActionBinding(
			name: .didUpdate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didUpdateNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillBecomeActive() {
		testActionBinding(
			name: .willBecomeActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willBecomeActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillFinishLaunching() {
		testActionBinding(
			name: .willFinishLaunching,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willFinishLaunchingNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillHide() {
		testActionBinding(
			name: .willHide,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willHideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillResignActive() {
		testActionBinding(
			name: .willResignActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willResignActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillUnhide() {
		testActionBinding(
			name: .willUnhide,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willUnhideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillUpdate() {
		testActionBinding(
			name: .willUpdate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willUpdateNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	
	// MARK: - 4. Delegate bindings
	
	func testUserDidAcceptCloudKitShare() {
		var received: Bool = false
		let handler = { (m: CKShare.Metadata) -> Void in
			received = true
		}
		testDelegateBinding(
			name: .userDidAcceptCloudKitShare,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { $0.delegate?.application?($0, userDidAcceptCloudKitShareWith: CKShare.Metadata()) },
			validate: { received }
		)
	}
	func testContinueUserActivity() {
		var received: Bool = false
		let handler = { (userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool in
			received = true
			return true
		}
		testDelegateBinding(
			name: .continueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, continue: NSUserActivity(activityType: "asdf"), restorationHandler: { (a: [NSUserActivityRestoring]) in }) },
			validate: { received }
		)
	}
	func testDidDecodeRestorableState() {
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		try! archiver.encodeEncodable("asdf", forKey: "qwer")
		
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Void in
			received = r
		}
		testDelegateBinding(
			name: .didDecodeRestorableState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { try! $0.delegate?.application?($0, didDecodeRestorableState: NSKeyedUnarchiver(forReadingFrom: archiver.encodedData)) },
			validate: { try! (received as? NSKeyedUnarchiver)?.decodeTopLevelDecodable(String.self, forKey: "qwer") == "asdf" }
		)
	}
	func testDidUpdateUserActivity() {
		var received: Bool = false
		let handler = { (userActivity: NSUserActivity) -> Void in
			received = true
		}
		testDelegateBinding(
			name: .didUpdateUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, didUpdate: NSUserActivity(activityType: "asdf")) },
			validate: { received }
		)
	}
	func testOpenFile() {
		var received: String? = nil
		let handler = { (_ filename: String) -> Bool in
			received = filename
			return true
		}
		testDelegateBinding(
			name: .openFile,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, openFile: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testOpenFiles() {
		var received: [String] = []
		let handler = { (_ filenames: [String]) -> Void in
			received = filenames
		}
		testDelegateBinding(
			name: .openFiles,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, openFiles: ["asdf"]) },
			validate: { received == ["asdf"] }
		)
	}
	func testOpenFileWithoutUI() {
		var received: String? = nil
		let handler = { (_ filename: String) -> Bool in
			received = filename
			return true
		}
		testDelegateBinding(
			name: .openFileWithoutUI,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, openFileWithoutUI: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testOpenTempFile() {
		var received: String? = nil
		let handler = { (_ filename: String) -> Bool in
			received = filename
			return true
		}
		testDelegateBinding(
			name: .openTempFile,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, openTempFile: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testOpenUntitledFile() {
		var received: Bool = false
		let handler = { () -> Bool in
			received = true
			return true
		}
		testDelegateBinding(
			name: .openUntitledFile,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.applicationOpenUntitledFile?($0) },
			validate: { received }
		)
	}
	func testPrintFile() {
		var received: String? = nil
		let handler = { (_ filename: String) -> Bool in
			received = filename
			return true
		}
		testDelegateBinding(
			name: .printFile,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, printFile: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testPrintFiles() {
		var received: [String] = []
		var receivedA: [NSPrintInfo.AttributeKey: Any] = [:]
		let handler = { (filenames: [String], a: [NSPrintInfo.AttributeKey: Any], p: Bool) -> NSApplication.PrintReply in
			received = filenames
			receivedA = a
			return .printingSuccess
		}
		testDelegateBinding(
			name: .printFiles,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, printFiles: ["asdf"], withSettings: [NSPrintInfo.AttributeKey.bottomMargin: 0.5], showPrintPanels: true) },
			validate: { received == ["asdf"] && receivedA as? [NSPrintInfo.AttributeKey: Double] == [NSPrintInfo.AttributeKey.bottomMargin: 0.5] }
		)
	}
	func testShouldHandleReopen() {
		var received: Bool? = nil
		let handler = { (_ hasVisibleWindows: Bool) -> Bool in
			received = hasVisibleWindows
			return true
		}
		testDelegateBinding(
			name: .shouldHandleReopen,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.applicationShouldHandleReopen?($0, hasVisibleWindows: true) },
			validate: { received == true }
		)
	}
	func testShouldOpenUntitledFile() {
		var received: Bool = false
		let handler = { () -> Bool in
			received = true
			return true
		}
		testDelegateBinding(
			name: .shouldOpenUntitledFile,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.applicationShouldOpenUntitledFile?($0) },
			validate: { received }
		)
	}
	func testShouldTerminate() {
		var received: Bool = false
		let handler = { () -> ApplicationTerminateReply in
			received = true
			return ApplicationTerminateReply.later(Signal.just(true))
		}
		testDelegateBinding(
			name: .shouldTerminate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.applicationShouldTerminate?($0) },
			validate: { received }
		)
	}
	func testShouldTerminateAfterLastWindowClosed() {
		var received: Bool = false
		let handler = { () -> Bool in
			received = true
			return true
		}
		testDelegateBinding(
			name: .shouldTerminateAfterLastWindowClosed,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.applicationShouldTerminateAfterLastWindowClosed?($0) },
			validate: { received }
		)
	}
	func testWillContinueUserActivity() {
		var received: String? = nil
		let handler = { (s: String) -> Bool in
			received = s
			return true
		}
		testDelegateBinding(
			name: .willContinueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willContinueUserActivityWithType: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testWillEncodeRestorableState() {
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Void in
			received = r
		}
		testDelegateBinding(
			name: .willEncodeRestorableState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willEncodeRestorableState: archiver) },
			validate: { received != nil }
		)
	}
	func testWillPresentError() {
		var received: Error? = nil
		let handler = { (e: Error) -> Error in
			received = e
			return e
		}
		let e = TestError("asdf")
		testDelegateBinding(
			name: .willPresentError,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willPresentError: e) },
			validate: { received as? TestError == TestError("asdf") }
		)
	}
	func testWillTerminate() {
		var received: Bool = false
		let handler = { () -> Void in
			received = true
		}
		testDelegateBinding(
			name: .willTerminate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willTerminateNotification, object: $0)) },
			validate: { received }
		)
	}
	
}
