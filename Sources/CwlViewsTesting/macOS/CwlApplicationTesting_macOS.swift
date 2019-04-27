//
//  CwlApplication_macOS.swift
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

#if os(macOS)

import CloudKit

extension BindingParser where Downcast: ApplicationBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Application.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asApplicationBinding() }) }
	
	//	0. Static styles are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var activationPolicy: BindingParser<Dynamic<NSApplication.ActivationPolicy>, Application.Binding, Downcast> { return .init(extract: { if case .activationPolicy(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var applicationIconImage: BindingParser<Dynamic<NSImage?>, Application.Binding, Downcast> { return .init(extract: { if case .applicationIconImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var dockMenu: BindingParser<Dynamic<MenuConvertible?>, Application.Binding, Downcast> { return .init(extract: { if case .dockMenu(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var mainMenu: BindingParser<Dynamic<MenuConvertible?>, Application.Binding, Downcast> { return .init(extract: { if case .mainMenu(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var menuBarVisible: BindingParser<Dynamic<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .menuBarVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var presentationOptions: BindingParser<Dynamic<NSApplication.PresentationOptions>, Application.Binding, Downcast> { return .init(extract: { if case .presentationOptions(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var relauchOnLogin: BindingParser<Dynamic<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .relauchOnLogin(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var remoteNotifications: BindingParser<Dynamic<NSApplication.RemoteNotificationType>, Application.Binding, Downcast> { return .init(extract: { if case .remoteNotifications(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	
	@available(macOS 10.14, *) public static var appearance: BindingParser<Dynamic<NSAppearance?>, Application.Binding, Downcast> { return .init(extract: { if case .appearance(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var activate: BindingParser<Signal<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .activate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var arrangeInFront: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .arrangeInFront(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var deactivate: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .deactivate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var hide: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .hide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var hideOtherApplications: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .hideOtherApplications(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var miniaturizeAll: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .miniaturizeAll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var orderFrontCharacterPalette: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .orderFrontCharacterPalette(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var orderFrontColorPanel: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .orderFrontColorPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var orderFrontStandardAboutPanel: BindingParser<Signal<Dictionary<NSApplication.AboutPanelOptionKey, Any>>, Application.Binding, Downcast> { return .init(extract: { if case .orderFrontStandardAboutPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var presentError: BindingParser<Signal<Callback<Error, Bool>>, Application.Binding, Downcast> { return .init(extract: { if case .presentError(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var requestUserAttention: BindingParser<Signal<(NSApplication.RequestUserAttentionType, Signal<Void>)>, Application.Binding, Downcast> { return .init(extract: { if case .requestUserAttention(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var terminate: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .terminate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var unhide: BindingParser<Signal<Bool>, Application.Binding, Downcast> { return .init(extract: { if case .unhide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var unhideAllApplications: BindingParser<Signal<Void>, Application.Binding, Downcast> { return .init(extract: { if case .unhideAllApplications(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBecomeActive: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didBecomeActive(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didChangeOcclusionState: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didChangeOcclusionState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didChangeScreenParameters: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didChangeScreenParameters(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didFinishLaunching: BindingParser<SignalInput<[AnyHashable: Any]>, Application.Binding, Downcast> { return .init(extract: { if case .didFinishLaunching(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didFinishRestoringWindows: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didFinishRestoringWindows(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didHide: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didHide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didResignActive: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didResignActive(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didUnhide: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didUnhide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didUpdate: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .didUpdate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willBecomeActive: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .willBecomeActive(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willFinishLaunching: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .willFinishLaunching(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willHide: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .willHide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willResignActive: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .willResignActive(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willUnhide: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .willUnhide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willUpdate: BindingParser<SignalInput<Void>, Application.Binding, Downcast> { return .init(extract: { if case .willUpdate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var continueUserActivity: BindingParser<(_ application: NSApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .continueUserActivity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didDecodeRestorableState: BindingParser<(_ application: NSApplication, NSCoder) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didDecodeRestorableState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didFailToContinueUserActivity: BindingParser<(_ application: NSApplication, _ userActivityType: String, _ error: Error) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didFailToContinueUserActivity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didFailToRegisterForRemoteNotifications: BindingParser<(_ application: NSApplication, _ error: Error) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didFailToRegisterForRemoteNotifications(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didReceiveRemoteNotification: BindingParser<(_ application: NSApplication, _ notification: [String: Any]) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didReceiveRemoteNotification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didRegisterForRemoteNotifications: BindingParser<(_ application: NSApplication, _ token: Data) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didRegisterForRemoteNotifications(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var didUpdateUserActivity: BindingParser<(_ application: NSApplication, NSUserActivity) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .didUpdateUserActivity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var openFile: BindingParser<(_ application: NSApplication, _ filename: String) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .openFile(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var openFiles: BindingParser<(_ application: NSApplication, _ filenames: [String]) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .openFiles(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var openFileWithoutUI: BindingParser<(_ application: Any, _ filename: String) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .openFileWithoutUI(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var openTempFile: BindingParser<(_ application: NSApplication, _ filename: String) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .openTempFile(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var openUntitledFile: BindingParser<(_ application: NSApplication) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .openUntitledFile(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var printFile: BindingParser<(_ application: NSApplication, _ filename: String) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .printFile(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var printFiles: BindingParser<(_ application: NSApplication, _ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply, Application.Binding, Downcast> { return .init(extract: { if case .printFiles(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var shouldHandleReopen: BindingParser<(_ application: NSApplication, _ hasVisibleWindows: Bool) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .shouldHandleReopen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var shouldOpenUntitledFile: BindingParser<(_ application: NSApplication) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .shouldOpenUntitledFile(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var shouldTerminate: BindingParser<(_ application: NSApplication) -> NSApplication.TerminateReply, Application.Binding, Downcast> { return .init(extract: { if case .shouldTerminate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var shouldTerminateAfterLastWindowClosed: BindingParser<(_ application: NSApplication) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .shouldTerminateAfterLastWindowClosed(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var userDidAcceptCloudKitShare: BindingParser<(_ application: NSApplication, CKShare.Metadata) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .userDidAcceptCloudKitShare(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willContinueUserActivity: BindingParser<(_ application: NSApplication, _ type: String) -> Bool, Application.Binding, Downcast> { return .init(extract: { if case .willContinueUserActivity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willEncodeRestorableState: BindingParser<(_ application: NSApplication, NSCoder) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .willEncodeRestorableState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willPresentError: BindingParser<(_ application: NSApplication, Error) -> Error, Application.Binding, Downcast> { return .init(extract: { if case .willPresentError(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
	public static var willTerminate: BindingParser<(_ notification: Notification) -> Void, Application.Binding, Downcast> { return .init(extract: { if case .willTerminate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asApplicationBinding() }) }
}

#endif
