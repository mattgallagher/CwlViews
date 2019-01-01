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

extension Application: TestableBinder {
	static func constructor(binding: Application.Binding) -> Preparer.Instance {
		NSApplication.shared.delegate = nil
		Application(binding).apply(to: NSApplication.shared)
		return NSApplication.shared
	}
	static var shoudPerformReleaseCheck: Bool { return false }
}

class CwlApplicationTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	func testActivationPolicy() {
		Application.testValueBinding(
			name: .activationPolicy,
			inputs: (.accessory, .regular),
			outputs: (.regular, .accessory, .regular),
			getter: { $0.activationPolicy() }
		)
	}
	func testApplicationIconImage() {
		let appImage = NSApplication.shared.applicationIconImage!
		let testImage = NSImage(size: NSSize(width: 3, height: 3))
		Application.testValueBinding(
			name: .applicationIconImage,
			inputs: (testImage, nil),
			outputs: (appImage.size.width, 3, appImage.size.width),
			getter: { $0.applicationIconImage.size.width }
		)
	}
	func testDockMenu() {
		Application.testValueBinding(
			name: .dockMenu,
			inputs: (Menu(.title -- "asdf") as MenuConvertible?, nil),
			outputs: (nil, "asdf", nil),
			getter: {
				$0.delegate?.applicationDockMenu?($0)?.title
			}
		)
	}
	func testMainMenu() {
		let originalMenu = NSApplication.shared.mainMenu as MenuConvertible?
		Application.testValueBinding(
			name: .mainMenu,
			inputs: (Menu(.title -- "asdf"), originalMenu),
			outputs: ("Main Menu", "asdf", "Main Menu"),
			getter: { $0.mainMenu?.title }
		)
	}
	func testMenuBarVisible() {
		Application.testValueBinding(
			name: .menuBarVisible,
			inputs: (false, true),
			outputs: (true, false, true),
			getter: { _ in NSMenu.menuBarVisible() }
		)
	}
	func testPresentationOptions() {
		Application.testValueBinding(
			name: .presentationOptions,
			inputs: (.disableAppleMenu, []),
			outputs: ([], .disableAppleMenu, []),
			getter: { $0.presentationOptions }
		)
	}
	func testRelauchOnLogin() {
		Application.testValueBinding(
			name: .relauchOnLogin,
			inputs: (true, false),
			outputs: (false, true, false),
			getter: { ($0 as! TestApplication).relaunchOnLogin }
		)
	}
	func testRemoteNotifications() {
		Application.testValueBinding(
			name: .remoteNotifications,
			inputs: (.badge, []),
			outputs: ([], .badge, []),
			getter: { $0.enabledRemoteNotificationTypes }
		)
	}
	
	// MARK: - 2. Signal bindings
	
	func testActivate() {
		(NSApplication.shared as! TestApplication).testingActivate = true
		defer { (NSApplication.shared as! TestApplication).testingActivate = false }
		
		Application.testSignalBinding(
			name: .activate,
			inputs: (true, false),
			outputs: (nil, true, false),
			getter: { ($0 as! TestApplication).activated }
		)
	}
	func testArrangeInFront() {
		Application.testSignalBinding(
			name: .arrangeInFront,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).arrangeInFrontCount }
		)
	}
	func testDeactivate() {
		Application.testSignalBinding(
			name: .deactivate,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).deactivateCount }
		)
	}
	func testHide() {
		Application.testSignalBinding(
			name: .hide,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).hideCount }
		)
	}
	func testHideOtherApplications() {
		Application.testSignalBinding(
			name: .hideOtherApplications,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).hideOtherApplicationsCount }
		)
	}
	func testMiniaturizeAll() {
		Application.testSignalBinding(
			name: .miniaturizeAll,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).miniaturizeAllCount }
		)
	}
	func testOrderFrontCharacterPalette() {
		Application.testSignalBinding(
			name: .orderFrontCharacterPalette,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).orderFrontCharacterPaletteCount }
		)
	}
	func testOrderFrontColorPanel() {
		Application.testSignalBinding(
			name: .orderFrontColorPanel,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).orderFrontColorPanelCount }
		)
	}
	func testOrderFrontStandardAboutPanel() {
		Application.testSignalBinding(
			name: .orderFrontStandardAboutPanel,
			inputs: ([.applicationName: "asdf"], [.applicationName: "qwer"]),
			outputs: (nil, [.applicationName: "asdf"], [.applicationName: "qwer"]),
			getter: { ($0 as! TestApplication).orderFrontStandardAboutPanelOptions.last as? [NSApplication.AboutPanelOptionKey: String] }
		)
	}
	func testPresentError() {
		var received: Bool? = nil
		let dummy = undeclaredError()
		let input = Signal<Bool>.multiChannel().subscribeValuesUntilEnd { received = $0 }
		Application.testSignalBinding(
			name: .presentError,
			inputs: (Callback(dummy, input), Callback(dummy, input)),
			outputs: (nil as Bool?, false as Bool?, true as Bool?),
			getter: { _ in received }
		)
	} 
	func testRequestUserAttention() {
		let (input, signal) = Signal<Void>.channel().multicast().tuple
		Application.testSignalBinding(
			name: .requestUserAttention,
			inputs: ((.informationalRequest, signal), (.criticalRequest, signal)),
			outputs: (Set<NSApplication.RequestUserAttentionType>(), Set([.informationalRequest]), Set([.criticalRequest])),
			getter: { app in
				let value = (app as! TestApplication).outstandingUserAttentionRequests
				input.send(value: ())
				return value
			}
		)
	}
	func testTerminate() {
		Application.testSignalBinding(
			name: .terminate,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).terminateCount }
		)
	}
	func testUnhide() {
		Application.testSignalBinding(
			name: .unhide,
			inputs: (true, false),
			outputs: ([], [true], [true, false]),
			getter: { ($0 as! TestApplication).unhideCount }
		)
	}
	func testUnhideAllApplications() {
		Application.testSignalBinding(
			name: .unhideAllApplications,
			inputs: ((), ()),
			outputs: (0, 1, 2),
			getter: { ($0 as! TestApplication).unhideAllCount }
		)
	}
	
	// MARK: - 3. Action bindings
	func testDidBecomeActive() {
		Application.testActionBinding(
			name: .didBecomeActive,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didBecomeActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidChangeOcclusionState() {
		Application.testActionBinding(
			name: .didChangeOcclusionState,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didChangeOcclusionStateNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidChangeScreenParameters() {
		Application.testActionBinding(
			name: .didChangeScreenParameters,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didChangeScreenParametersNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidFailToContinueUserActivity() {
		Application.testActionBinding(
			name: .didFailToContinueUserActivity,
			trigger: { $0.delegate?.application?($0, didFailToContinueUserActivityWithType: "asdf", error: undeclaredError()) },
			validate: { (tuple: (userActivityType: String, error: Error)) in return tuple.userActivityType == "asdf" }
		)
	}
	func testDidFailToRegisterForRemoteNotifications() {
		Application.testActionBinding(
			name: .didFailToRegisterForRemoteNotifications,
			trigger: { $0.delegate?.application?($0, didFailToRegisterForRemoteNotificationsWithError: undeclaredError()) },
			validate: { _ in true }
		)
	}
	func testDidFinishLaunching() {
		Application.testActionBinding(
			name: .didFinishLaunching,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didFinishLaunchingNotification, object: $0, userInfo: ["asdf": "qwer"])) },
			validate: { (d: [AnyHashable: Any]) in d as? [String: String] == ["asdf": "qwer"] }
		)
	}
	func testDidFinishRestoringWindows() {
		Application.testActionBinding(
			name: .didFinishRestoringWindows,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didFinishRestoringWindowsNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidHide() {
		Application.testActionBinding(
			name: .didHide,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didHideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidReceiveRemoteNotification() {
		Application.testActionBinding(
			name: .didReceiveRemoteNotification,
			trigger: { $0.delegate?.application?($0, didReceiveRemoteNotification: ["asdf": "qwer"]) },
			validate: { $0 as? [String: String] == ["asdf": "qwer"] }
		)
	}
	func testDidRegisterForRemoteNotifications() {
		Application.testActionBinding(
			name: .didRegisterForRemoteNotifications,
			trigger: { $0.delegate?.application?($0, didRegisterForRemoteNotificationsWithDeviceToken: "asdf".data(using: .utf8)!) },
			validate: { String(data: $0, encoding: .utf8) == "asdf" }
		)
	}
	func testDidResignActive() {
		Application.testActionBinding(
			name: .didResignActive,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didResignActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidUnhide() {
		Application.testActionBinding(
			name: .didUnhide,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didUnhideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testDidUpdate() {
		Application.testActionBinding(
			name: .didUpdate,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.didUpdateNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillBecomeActive() {
		Application.testActionBinding(
			name: .willBecomeActive,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willBecomeActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillFinishLaunching() {
		Application.testActionBinding(
			name: .willFinishLaunching,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willFinishLaunchingNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillHide() {
		Application.testActionBinding(
			name: .willHide,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willHideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillResignActive() {
		Application.testActionBinding(
			name: .willResignActive,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willResignActiveNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillUnhide() {
		Application.testActionBinding(
			name: .willUnhide,
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willUnhideNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillUpdate() {
		Application.testActionBinding(
			name: .willUpdate,
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
		Application.testDelegateBinding(
			name: .userDidAcceptCloudKitShare,
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
		Application.testDelegateBinding(
			name: .continueUserActivity,
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
		Application.testDelegateBinding(
			name: .didDecodeRestorableState,
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
		Application.testDelegateBinding(
			name: .didUpdateUserActivity,
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
		Application.testDelegateBinding(
			name: .openFile,
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
		Application.testDelegateBinding(
			name: .openFiles,
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
		Application.testDelegateBinding(
			name: .openFileWithoutUI,
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
		Application.testDelegateBinding(
			name: .openTempFile,
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
		Application.testDelegateBinding(
			name: .openUntitledFile,
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
		Application.testDelegateBinding(
			name: .printFile,
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
		Application.testDelegateBinding(
			name: .printFiles,
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
		Application.testDelegateBinding(
			name: .shouldHandleReopen,
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
		Application.testDelegateBinding(
			name: .shouldOpenUntitledFile,
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
		Application.testDelegateBinding(
			name: .shouldTerminate,
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
		Application.testDelegateBinding(
			name: .shouldTerminateAfterLastWindowClosed,
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
		Application.testDelegateBinding(
			name: .willContinueUserActivity,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willContinueUserActivityWithType: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testWillEncodeRestorableState() {
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		var received: NSCoder? = nil
		Application.testDelegateBinding(
			name: .willEncodeRestorableState,
			handler: { r in received = r },
			trigger: { _ = $0.delegate?.application?($0, willEncodeRestorableState: archiver) },
			validate: { received != nil }
		)
	}
	func testWillPresentError() {
		var received: Error? = nil
		Application.testDelegateBinding(
			name: .willPresentError,
			handler: { e in received = e; return e },
			trigger: { _ = $0.delegate?.application?($0, willPresentError: TestError("asdf")) },
			validate: { received as? TestError == TestError("asdf") }
		)
	}
	func testWillTerminate() {
		var received: Bool = false
		Application.testDelegateBinding(
			name: .willTerminate,
			handler: { received = true },
			trigger: { NotificationCenter.default.post(Notification(name: NSApplication.willTerminateNotification, object: $0)) },
			validate: { received }
		)
	}
	
}
