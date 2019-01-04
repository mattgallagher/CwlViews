//
//  AppDelegate.swift
//  CwlViews_macOSTestsHarness
//
//  Created by Matt Gallagher on 11/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import Cocoa

@objc(TestApplication)
public class TestApplication: NSApplication {
	public var relaunchOnLogin: Bool? = nil
	public override func enableRelaunchOnLogin() {
		relaunchOnLogin = true
	}
	public override func disableRelaunchOnLogin() {
		relaunchOnLogin = false
	}

	public var activated: Bool? = nil
	public var testingActivate: Bool = false
	public override func activate(ignoringOtherApps flag: Bool) {
		if testingActivate {
			activated = flag
		} else {
			super.activate(ignoringOtherApps: flag)
		}
	}

	public var arrangeInFrontCount: Int = 0
	public override func arrangeInFront(_ sender: Any?) {
		arrangeInFrontCount += 1
	}

	public var deactivateCount: Int = 0
	public override func deactivate() {
		deactivateCount += 1
	}

	public var hideCount: Int = 0
	public override func hide(_ sender: Any?) {
		hideCount += 1
	}

	public var hideOtherApplicationsCount: Int = 0
	public override func hideOtherApplications(_ sender: Any?) {
		hideOtherApplicationsCount += 1
	}

	public var miniaturizeAllCount: Int = 0
	public override func miniaturizeAll(_ sender: Any?) {
		miniaturizeAllCount += 1
	}

	public var orderFrontCharacterPaletteCount: Int = 0
	public override func orderFrontCharacterPalette(_ sender: Any?) {
		orderFrontCharacterPaletteCount += 1
	}

	public var orderFrontColorPanelCount: Int = 0
	public override func orderFrontColorPanel(_ sender: Any?) {
		orderFrontColorPanelCount += 1
	}

	public var orderFrontStandardAboutPanelOptions: [Dictionary<NSApplication.AboutPanelOptionKey, Any>] = []
	public override func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey : Any] = [:]) {
		orderFrontStandardAboutPanelOptions.append(optionsDictionary)
	}

	public var presentedErrors: [Error] = []
	public override func presentError(_ error: Error) -> Bool {
		presentedErrors.append(error)
		return presentedErrors.count % 2 == 0
	}

	public var outstandingUserAttentionRequests = Set<NSApplication.RequestUserAttentionType>()
	public override func requestUserAttention(_ requestType: NSApplication.RequestUserAttentionType) -> Int {
		outstandingUserAttentionRequests.insert(requestType)
		return Int(requestType.rawValue)
	}
	public override func cancelUserAttentionRequest(_ request: Int) {
		outstandingUserAttentionRequests.remove(NSApplication.RequestUserAttentionType(rawValue: UInt(request))!)
	}

	public var terminateCount: Int = 0
	public override func terminate(_ sender: Any?) {
		terminateCount += 1
	}

	public var unhideCount: [Bool] = []
	public override func unhide(_ sender: Any?) {
		unhideCount.append(true)
	}

	public var unhideWithoutActivationCount: Int = 0
	public override func unhideWithoutActivation() {
		unhideCount.append(false)
	}

	public var unhideAllCount: Int = 0
	public override func unhideAllApplications(_ sender: Any?) {
		unhideAllCount += 1
	}
}
