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
import simd

public func applicationMain(type: NSApplication.Type = NSApplication.self, application: @escaping () -> Application) {
	let instance = type.shared
	let bindings = application().consume().bindings
	let (preparer, _, storage, lifetimes) = Application.Preparer.bind(bindings, to: { _ in instance })
	_ = preparer.combine(lifetimes: lifetimes, instance: instance, storage: storage)
	_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

// MARK: - Binder Part 1: Binder
public class Application: Binder {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		precondition(type == Preparer.Instance.self, "Custom application subclass must be specified as parameter to `applicationMain`")
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Application {
	enum Binding: ApplicationBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static styles are applied at construction and are subsequently immutable.
	
		// 1. Value bindings may be applied at construction and may subsequently change.
		case activationPolicy(Dynamic<NSApplication.ActivationPolicy>)
		case applicationIconImage(Dynamic<NSImage?>)
		case dockMenu(Dynamic<MenuConvertible?>)
		case mainMenu(Dynamic<MenuConvertible?>)
		case menuBarVisible(Dynamic<Bool>)
		case presentationOptions(Dynamic<NSApplication.PresentationOptions>)
		case relauchOnLogin(Dynamic<Bool>)
		case remoteNotifications(Dynamic<NSApplication.RemoteNotificationType>)
		
		// 2. Signal bindings are performed on the object after construction.
		case activate(Signal<Bool>)
		case arrangeInFront(Signal<Void>)
		case deactivate(Signal<Void>)
		case hide(Signal<Void>)
		case hideOtherApplications(Signal<Void>)
		case miniaturizeAll(Signal<Void>)
		case orderFrontCharacterPalette(Signal<Void>)
		case orderFrontColorPanel(Signal<Void>)
		case orderFrontStandardAboutPanel(Signal<Dictionary<NSApplication.AboutPanelOptionKey, Any>>)
		case presentError(Signal<Callback<Error, Bool>>)
		case requestUserAttention(Signal<(NSApplication.RequestUserAttentionType, Signal<Void>)>)
		case terminate(Signal<Void>)
		case unhide(Signal<Bool>)
		case unhideAllApplications(Signal<Void>)
		
		// 3. Action bindings are triggered by the object after construction.
		case didBecomeActive(SignalInput<Void>)
		case didChangeOcclusionState(SignalInput<Void>)
		case didChangeScreenParameters(SignalInput<Void>)
		case didFinishLaunching(SignalInput<[AnyHashable: Any]>)
		case didFinishRestoringWindows(SignalInput<Void>)
		case didHide(SignalInput<Void>)
		case didResignActive(SignalInput<Void>)
		case didUnhide(SignalInput<Void>)
		case didUpdate(SignalInput<Void>)
		case willBecomeActive(SignalInput<Void>)
		case willFinishLaunching(SignalInput<Void>)
		case willHide(SignalInput<Void>)
		case willResignActive(SignalInput<Void>)
		case willUnhide(SignalInput<Void>)
		case willUpdate(SignalInput<Void>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case continueUserActivity((_ application: NSApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool)
		case didDecodeRestorableState((_ application: NSApplication, NSCoder) -> Void)
		case didFailToContinueUserActivity((_ application: NSApplication, _ userActivityType: String, _ error: Error) -> Void)
		case didFailToRegisterForRemoteNotifications((_ application: NSApplication, _ error: Error) -> Void)
		case didReceiveRemoteNotification((_ application: NSApplication, _ notification: [String: Any]) -> Void)
		case didRegisterForRemoteNotifications((_ application: NSApplication, _ token: Data) -> Void)
		case didUpdateUserActivity((_ application: NSApplication, NSUserActivity) -> Void)
		case openFile((_ application: NSApplication, _ filename: String) -> Bool)
		case openFiles((_ application: NSApplication, _ filenames: [String]) -> Void)
		case openFileWithoutUI((_ application: Any, _ filename: String) -> Bool)
		case openTempFile((_ application: NSApplication, _ filename: String) -> Bool)
		case openUntitledFile((_ application: NSApplication) -> Bool)
		case printFile((_ application: NSApplication, _ filename: String) -> Bool)
		case printFiles((_ application: NSApplication, _ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply)
		case shouldHandleReopen((_ application: NSApplication, _ hasVisibleWindows: Bool) -> Bool)
		case shouldOpenUntitledFile((_ application: NSApplication) -> Bool)
		case shouldTerminate((_ application: NSApplication) -> NSApplication.TerminateReply)
		case shouldTerminateAfterLastWindowClosed((_ application: NSApplication) -> Bool)
		case userDidAcceptCloudKitShare((_ application: NSApplication, CKShare.Metadata) -> Void)
		case willContinueUserActivity((_ application: NSApplication, _ type: String) -> Bool)
		case willEncodeRestorableState((_ application: NSApplication, NSCoder) -> Void)
		case willPresentError((_ application: NSApplication, Error) -> Error)
		case willTerminate((_ notification: Notification) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension Application {
	struct Preparer: BinderDelegateEmbedder {
		public typealias Binding = Application.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSApplication
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var dockMenuInUse: Bool = false
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Application.Preparer {
	var delegateIsRequired: Bool { return dynamicDelegate != nil || dockMenuInUse }
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .continueUserActivity(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:continue:restorationHandler:)))
		case .dockMenu: dockMenuInUse = true
		case .didDecodeRestorableState(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:didDecodeRestorableState:)))
		case .didFailToContinueUserActivity(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:didFailToContinueUserActivityWithType:error:)))
		case .didFailToRegisterForRemoteNotifications(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:)))
		case .didReceiveRemoteNotification(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:didReceiveRemoteNotification:)))
		case .didRegisterForRemoteNotifications(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)))
		case .didUpdateUserActivity(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:didUpdate:)))
		case .openFile(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:openFile:)))
		case .openFiles(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:openFiles:)))
		case .openFileWithoutUI(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:openFileWithoutUI:)))
		case .openTempFile(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:openTempFile:)))
		case .openUntitledFile(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.applicationOpenUntitledFile(_:)))
		case .printFile(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:printFile:)))
		case .printFiles(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:printFiles:withSettings:showPrintPanels:)))
		case .shouldHandleReopen(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.applicationShouldHandleReopen(_:hasVisibleWindows:)))
		case .shouldOpenUntitledFile(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.applicationShouldOpenUntitledFile(_:)))
		case .shouldTerminate(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.applicationShouldTerminate(_:)))
		case .shouldTerminateAfterLastWindowClosed(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.applicationShouldTerminateAfterLastWindowClosed(_:)))
		case .userDidAcceptCloudKitShare(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:userDidAcceptCloudKitShareWith:)))
		case .willContinueUserActivity(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:willContinueUserActivityWithType:)))
		case .willEncodeRestorableState(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.application(_:willEncodeRestorableState:)))
		case .willPresentError(let x): delegate().addSingleHandler(x, #selector(NSApplicationDelegate.application(_:willPresentError:)))
		case .willTerminate(let x): delegate().addMultiHandler(x, #selector(NSApplicationDelegate.applicationWillTerminate(_:)))
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		prepareDelegate(instance: instance, storage: storage)
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static styles are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .activationPolicy(let x): return x.apply(instance) { i, v in i.setActivationPolicy(v) }
		case .applicationIconImage(let x): return x.apply(instance) { i, v in i.applicationIconImage = v }
		case .dockMenu(let x): return x.apply(instance, storage) { i, s, v in s.dockMenu = v?.nsMenu() }
		case .mainMenu(let x): return x.apply(instance) { i, v in i.mainMenu = v?.nsMenu() }
		case .menuBarVisible(let x): return x.apply(instance) { i, v in NSMenu.setMenuBarVisible(v) }
		case .presentationOptions(let x): return x.apply(instance) { i, v in i.presentationOptions = v }
		case .relauchOnLogin(let x): return x.apply(instance) { i, v in v ? i.enableRelaunchOnLogin() : i.disableRelaunchOnLogin() }
		case .remoteNotifications(let x): return x.apply(instance) { i, v in v.isEmpty ? i.unregisterForRemoteNotifications() : i.registerForRemoteNotifications(matching: v) }
			
		// 2. Signal bindings are performed on the object after construction.
		case .activate(let x): return x.apply(instance) { i, v in i.activate(ignoringOtherApps: v) }
		case .arrangeInFront(let x): return x.apply(instance) { i, v in i.arrangeInFront(nil) }
		case .deactivate(let x): return x.apply(instance) { i, v in i.deactivate() }
		case .hide(let x): return x.apply(instance) { i, v in i.hide(nil) }
		case .hideOtherApplications(let x): return x.apply(instance) { i, v in i.hideOtherApplications(nil) }
		case .miniaturizeAll(let x): return x.apply(instance) { i, v in i.miniaturizeAll(nil) }
		case .orderFrontCharacterPalette(let x): return x.apply(instance) { i, v in i.orderFrontCharacterPalette(nil) }
		case .orderFrontColorPanel(let x): return x.apply(instance) { i, v in i.orderFrontColorPanel(nil) }
		case .orderFrontStandardAboutPanel(let x): return x.apply(instance) { i, v in i.orderFrontStandardAboutPanel(options: v) }
		case .presentError(let x):
			return x.apply(instance) { i, v in
				let handled = i.presentError(v.value)
				_ = v.callback.send(value: handled)
			}
		case .requestUserAttention(let x):
			var outstandingRequests = [Lifetime]()
			return x.apply(instance) { i, v in
				let requestIndex = i.requestUserAttention(v.0)
				outstandingRequests += v.1.subscribe { [weak i] r in i?.cancelUserAttentionRequest(requestIndex) }
			}
		case .terminate(let x): return x.apply(instance) { i, v in i.terminate(nil) }
		case .unhide(let x): return x.apply(instance) { i, v in v ? i.unhide(nil) : i.unhideWithoutActivation() }
		case .unhideAllApplications(let x): return x.apply(instance) { i, v in i.unhideAllApplications(nil) }
			
		// 3. Action bindings are triggered by the object after construction.
		case .didBecomeActive(let x): return Signal.notifications(name: NSApplication.didBecomeActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didChangeOcclusionState(let x): return Signal.notifications(name: NSApplication.didChangeOcclusionStateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didChangeScreenParameters(let x): return Signal.notifications(name: NSApplication.didChangeScreenParametersNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didFinishLaunching(let x): return Signal.notifications(name: NSApplication.didFinishLaunchingNotification, object: instance).compactMap { n -> [AnyHashable: Any] in n.userInfo ?? [:] }.cancellableBind(to: x)
		case .didFinishRestoringWindows(let x): return Signal.notifications(name: NSApplication.didFinishRestoringWindowsNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didHide(let x): return Signal.notifications(name: NSApplication.didHideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didResignActive(let x): return Signal.notifications(name: NSApplication.didResignActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didUnhide(let x): return Signal.notifications(name: NSApplication.didUnhideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didUpdate(let x): return Signal.notifications(name: NSApplication.didUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willBecomeActive(let x): return Signal.notifications(name: NSApplication.willBecomeActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willFinishLaunching(let x): return Signal.notifications(name: NSApplication.willFinishLaunchingNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willHide(let x): return Signal.notifications(name: NSApplication.willHideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willResignActive(let x): return Signal.notifications(name: NSApplication.willResignActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willUnhide(let x): return Signal.notifications(name: NSApplication.willUnhideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willUpdate(let x): return Signal.notifications(name: NSApplication.willUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)

		case .didFailToContinueUserActivity: return nil
		case .didFailToRegisterForRemoteNotifications: return nil
		case .didReceiveRemoteNotification: return nil
		case .didRegisterForRemoteNotifications: return nil
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .continueUserActivity: return nil
		case .didDecodeRestorableState: return nil
		case .didUpdateUserActivity: return nil
		case .openFile: return nil
		case .openFiles: return nil
		case .openFileWithoutUI: return nil
		case .openTempFile: return nil
		case .openUntitledFile: return nil
		case .printFile: return nil
		case .printFiles: return nil
		case .shouldHandleReopen: return nil
		case .shouldOpenUntitledFile: return nil
		case .shouldTerminate: return nil
		case .shouldTerminateAfterLastWindowClosed: return nil
		case .willContinueUserActivity: return nil
		case .willEncodeRestorableState: return nil
		case .willPresentError: return nil
		case .willTerminate: return nil

		case .userDidAcceptCloudKitShare: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Application.Preparer {
	open class Storage: AssociatedBinderStorage, NSApplicationDelegate {
		open var dockMenu: NSMenu?
		
		open override var isInUse: Bool {
			return super.isInUse || dockMenu != nil
		}
		
		open func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
			return dockMenu
		}
	}
	
	open class Delegate: DynamicDelegate, NSApplicationDelegate {
		open func applicationShouldTerminate(_ application: NSApplication) -> NSApplication.TerminateReply {
			return singleHandler(application)
		}
		
		open func applicationShouldTerminateAfterLastWindowClosed(_ application: NSApplication) -> Bool {
			return singleHandler(application)
		}
		
		open func applicationShouldHandleReopen(_ application: NSApplication, hasVisibleWindows: Bool) -> Bool {
			return singleHandler(application, hasVisibleWindows)
		}
		
		open func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
			return singleHandler(application, userActivity, restorationHandler)
		}
		
		open func application(_ application: NSApplication, willPresentError error: Error) -> Error {
			return singleHandler(application, error)
		}
		
		open func application(_ application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
			return singleHandler(application, userActivityType)
		}
		
		open func application(_ application: Any, openFileWithoutUI filename: String) -> Bool {
			return singleHandler(application, filename)
		}
		
		open func application(_ application: NSApplication, openFile filename: String) -> Bool {
			return singleHandler(application, filename)
		}
		
		open func application(_ application: NSApplication, openFiles filenames: [String]) {
			multiHandler(application, filenames)
		}
		
		open func application(_ application: NSApplication, printFile filename: String) -> Bool {
			return singleHandler(application, filename)
		}
		
		open func application(_ application: NSApplication, printFiles filenames: [String], withSettings printSettings: [NSPrintInfo.AttributeKey: Any], showPrintPanels: Bool) -> NSApplication.PrintReply {
			return singleHandler(application, filenames, printSettings, showPrintPanels)
		}
		
		open func application(_ application: NSApplication, openTempFile filename: String) -> Bool {
			return singleHandler(application, filename)
		}
		
		open func applicationOpenUntitledFile(_ application: NSApplication) -> Bool {
			return singleHandler(application)
		}
		
		open func applicationShouldOpenUntitledFile(_ application: NSApplication) -> Bool {
			return singleHandler(application)
		}
		
		open func applicationWillTerminate(_ notification: Notification) {
			multiHandler(notification)
		}
		
		open func application(_ application: NSApplication, didUpdate userActivity: NSUserActivity) {
			return singleHandler(application, userActivity)
		}
		
		open func application(_ application: NSApplication, willEncodeRestorableState coder: NSCoder) {
			return singleHandler(application, coder)
		}
		
		open func application(_ application: NSApplication, didDecodeRestorableState coder: NSCoder) {
			return singleHandler(application, coder)
		}
		
		open func application(_ application: NSApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
			multiHandler(application, userActivityType, error)
		}
		
		open func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
			multiHandler(application, userInfo)
		}
		
		open func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
			multiHandler(application, deviceToken)
		}
		
		open func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
			multiHandler(application, error)
		}
		
		open func application(_ application: NSApplication, userDidAcceptCloudKitShareWith metadata: CKShare.Metadata) {
			multiHandler(application, metadata)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ApplicationBinding {
	public typealias ApplicationName<V> = BindingName<V, Application.Binding, Binding>
	private typealias B = Application.Binding
	private static func name<V>(_ source: @escaping (V) -> Application.Binding) -> ApplicationName<V> {
		return ApplicationName<V>(source: source, downcast: Binding.applicationBinding)
	}
}
public extension BindingName where Binding: ApplicationBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ApplicationName<$2> { return .name(B.$1) }
	
	//	0. Static styles are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var activationPolicy: ApplicationName<Dynamic<NSApplication.ActivationPolicy>> { return .name(B.activationPolicy) }
	static var applicationIconImage: ApplicationName<Dynamic<NSImage?>> { return .name(B.applicationIconImage) }
	static var dockMenu: ApplicationName<Dynamic<MenuConvertible?>> { return .name(B.dockMenu) }
	static var mainMenu: ApplicationName<Dynamic<MenuConvertible?>> { return .name(B.mainMenu) }
	static var menuBarVisible: ApplicationName<Dynamic<Bool>> { return .name(B.menuBarVisible) }
	static var presentationOptions: ApplicationName<Dynamic<NSApplication.PresentationOptions>> { return .name(B.presentationOptions) }
	static var relauchOnLogin: ApplicationName<Dynamic<Bool>> { return .name(B.relauchOnLogin) }
	static var remoteNotifications: ApplicationName<Dynamic<NSApplication.RemoteNotificationType>> { return .name(B.remoteNotifications) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var activate: ApplicationName<Signal<Bool>> { return .name(B.activate) }
	static var arrangeInFront: ApplicationName<Signal<Void>> { return .name(B.arrangeInFront) }
	static var deactivate: ApplicationName<Signal<Void>> { return .name(B.deactivate) }
	static var hide: ApplicationName<Signal<Void>> { return .name(B.hide) }
	static var hideOtherApplications: ApplicationName<Signal<Void>> { return .name(B.hideOtherApplications) }
	static var miniaturizeAll: ApplicationName<Signal<Void>> { return .name(B.miniaturizeAll) }
	static var orderFrontCharacterPalette: ApplicationName<Signal<Void>> { return .name(B.orderFrontCharacterPalette) }
	static var orderFrontColorPanel: ApplicationName<Signal<Void>> { return .name(B.orderFrontColorPanel) }
	static var orderFrontStandardAboutPanel: ApplicationName<Signal<Dictionary<NSApplication.AboutPanelOptionKey, Any>>> { return .name(B.orderFrontStandardAboutPanel) }
	static var presentError: ApplicationName<Signal<Callback<Error, Bool>>> { return .name(B.presentError) }
	static var requestUserAttention: ApplicationName<Signal<(NSApplication.RequestUserAttentionType, Signal<Void>)>> { return .name(B.requestUserAttention) }
	static var terminate: ApplicationName<Signal<Void>> { return .name(B.terminate) }
	static var unhide: ApplicationName<Signal<Bool>> { return .name(B.unhide) }
	static var unhideAllApplications: ApplicationName<Signal<Void>> { return .name(B.unhideAllApplications) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didBecomeActive: ApplicationName<SignalInput<Void>> { return .name(B.didBecomeActive) }
	static var didChangeOcclusionState: ApplicationName<SignalInput<Void>> { return .name(B.didChangeOcclusionState) }
	static var didChangeScreenParameters: ApplicationName<SignalInput<Void>> { return .name(B.didChangeScreenParameters) }
	static var didFailToContinueUserActivity: ApplicationName<(NSApplication, String, Error) -> Void> { return .name(B.didFailToContinueUserActivity) }
	static var didFailToRegisterForRemoteNotifications: ApplicationName<(NSApplication, Error) -> Void> { return .name(B.didFailToRegisterForRemoteNotifications) }
	static var didFinishLaunching: ApplicationName<SignalInput<[AnyHashable: Any]>> { return .name(B.didFinishLaunching) }
	static var didFinishRestoringWindows: ApplicationName<SignalInput<Void>> { return .name(B.didFinishRestoringWindows) }
	static var didHide: ApplicationName<SignalInput<Void>> { return .name(B.didHide) }
	static var didReceiveRemoteNotification: ApplicationName<(NSApplication, [String: Any]) -> Void> { return .name(B.didReceiveRemoteNotification) }
	static var didRegisterForRemoteNotifications: ApplicationName<(NSApplication, Data) -> Void> { return .name(B.didRegisterForRemoteNotifications) }
	static var didResignActive: ApplicationName<SignalInput<Void>> { return .name(B.didResignActive) }
	static var didUnhide: ApplicationName<SignalInput<Void>> { return .name(B.didUnhide) }
	static var didUpdate: ApplicationName<SignalInput<Void>> { return .name(B.didUpdate) }
	static var willBecomeActive: ApplicationName<SignalInput<Void>> { return .name(B.willBecomeActive) }
	static var willFinishLaunching: ApplicationName<SignalInput<Void>> { return .name(B.willFinishLaunching) }
	static var willHide: ApplicationName<SignalInput<Void>> { return .name(B.willHide) }
	static var willResignActive: ApplicationName<SignalInput<Void>> { return .name(B.willResignActive) }
	static var willUnhide: ApplicationName<SignalInput<Void>> { return .name(B.willUnhide) }
	static var willUpdate: ApplicationName<SignalInput<Void>> { return .name(B.willUpdate) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var continueUserActivity: ApplicationName<(_ application: NSApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool> { return .name(B.continueUserActivity) }
	static var didDecodeRestorableState: ApplicationName<(_ application: NSApplication, NSCoder) -> Void> { return .name(B.didDecodeRestorableState) }
	static var didUpdateUserActivity: ApplicationName<(_ application: NSApplication, NSUserActivity) -> Void> { return .name(B.didUpdateUserActivity) }
	static var openFile: ApplicationName<(_ application: NSApplication, _ filename: String) -> Bool> { return .name(B.openFile) }
	static var openFiles: ApplicationName<(_ application: NSApplication, _ filenames: [String]) -> Void> { return .name(B.openFiles) }
	static var openFileWithoutUI: ApplicationName<(_ application: Any, _ filename: String) -> Bool> { return .name(B.openFileWithoutUI) }
	static var openTempFile: ApplicationName<(_ application: NSApplication, _ filename: String) -> Bool> { return .name(B.openTempFile) }
	static var openUntitledFile: ApplicationName<(_ application: NSApplication) -> Bool> { return .name(B.openUntitledFile) }
	static var printFile: ApplicationName<(_ application: NSApplication, _ filename: String) -> Bool> { return .name(B.printFile) }
	static var printFiles: ApplicationName<(_ application: NSApplication, _ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply> { return .name(B.printFiles) }
	static var shouldHandleReopen: ApplicationName<(_ application: NSApplication, _ hasVisibleWindows: Bool) -> Bool> { return .name(B.shouldHandleReopen) }
	static var shouldOpenUntitledFile: ApplicationName<(_ application: NSApplication) -> Bool> { return .name(B.shouldOpenUntitledFile) }
	static var shouldTerminate: ApplicationName<(_ application: NSApplication) -> NSApplication.TerminateReply> { return .name(B.shouldTerminate) }
	static var shouldTerminateAfterLastWindowClosed: ApplicationName<(_ application: NSApplication) -> Bool> { return .name(B.shouldTerminateAfterLastWindowClosed) }
	static var userDidAcceptCloudKitShare: ApplicationName<(_ application: NSApplication, CKShare.Metadata) -> Void> { return .name(B.userDidAcceptCloudKitShare) }
	static var willContinueUserActivity: ApplicationName<(_ application: NSApplication, _ type: String) -> Bool> { return .name(B.willContinueUserActivity) }
	static var willEncodeRestorableState: ApplicationName<(_ application: NSApplication, NSCoder) -> Void> { return .name(B.willEncodeRestorableState) }
	static var willPresentError: ApplicationName<(_ application: NSApplication, Error) -> Error> { return .name(B.willPresentError) }
	static var willTerminate: ApplicationName<(_ notification: Notification) -> Void> { return .name(B.willTerminate) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
extension NSApplication: HasDelegate {}

// MARK: - Binder Part 8: Downcast protocols
public protocol ApplicationBinding: BinderBaseBinding {
	static func applicationBinding(_ binding: Application.Binding) -> Self
}
public extension ApplicationBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return applicationBinding(.inheritedBinding(binding))
	}
}
public extension Application.Binding {
	typealias Preparer = Application.Preparer
	static func applicationBinding(_ binding: Application.Binding) -> Application.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
