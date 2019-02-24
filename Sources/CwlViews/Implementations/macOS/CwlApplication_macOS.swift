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
		case didFailToContinueUserActivity(SignalInput<(userActivityType: String, error: Error)>)
		case didFailToRegisterForRemoteNotifications(SignalInput<Error>)
		case didFinishLaunching(SignalInput<[AnyHashable: Any]>)
		case didFinishRestoringWindows(SignalInput<Void>)
		case didHide(SignalInput<Void>)
		case didReceiveRemoteNotification(SignalInput<[String: Any]>)
		case didRegisterForRemoteNotifications(SignalInput<Data>)
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
		case continueUserActivity((_ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool)
		case didDecodeRestorableState((NSCoder) -> Void)
		case didUpdateUserActivity((NSUserActivity) -> Void)
		case openFile((_ filename: String) -> Bool)
		case openFiles((_ filenames: [String]) -> Void)
		case openFileWithoutUI((_ filename: String) -> Bool)
		case openTempFile((_ filename: String) -> Bool)
		case openUntitledFile(() -> Bool)
		case printFile((_ filename: String) -> Bool)
		case printFiles((_ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply)
		case shouldHandleReopen((_ hasVisibleWindows: Bool) -> Bool)
		case shouldOpenUntitledFile(() -> Bool)
		case shouldTerminate(() -> ApplicationTerminateReply)
		case shouldTerminateAfterLastWindowClosed(() -> Bool)
		case userDidAcceptCloudKitShare((CKShare.Metadata) -> Void)
		case willContinueUserActivity((_ type: String) -> Bool)
		case willEncodeRestorableState((NSCoder) -> Void)
		case willPresentError((Error) -> Error)
		case willTerminate(() -> Void)
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
		
		case .continueUserActivity(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:continue:restorationHandler:)))
		case .dockMenu: dockMenuInUse = true
		case .didDecodeRestorableState(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:didDecodeRestorableState:)))
		case .didFailToContinueUserActivity(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:didFailToContinueUserActivityWithType:error:)))
		case .didFailToRegisterForRemoteNotifications(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:)))
		case .didReceiveRemoteNotification(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:didReceiveRemoteNotification:)))
		case .didRegisterForRemoteNotifications(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)))
		case .didUpdateUserActivity(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:didUpdate:)))
		case .openFile(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:openFile:)))
		case .openFiles(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:openFiles:)))
		case .openFileWithoutUI(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:openFileWithoutUI:)))
		case .openTempFile(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:openTempFile:)))
		case .openUntitledFile(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.applicationOpenUntitledFile(_:)))
		case .printFile(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:printFile:)))
		case .printFiles(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:printFiles:withSettings:showPrintPanels:)))
		case .shouldHandleReopen(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.applicationShouldHandleReopen(_:hasVisibleWindows:)))
		case .shouldOpenUntitledFile(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.applicationShouldOpenUntitledFile(_:)))
		case .shouldTerminate(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.applicationShouldTerminate(_:)))
		case .shouldTerminateAfterLastWindowClosed(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.applicationShouldTerminateAfterLastWindowClosed(_:)))
		case .userDidAcceptCloudKitShare(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:userDidAcceptCloudKitShareWith:)))
		case .willContinueUserActivity(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:willContinueUserActivityWithType:)))
		case .willEncodeRestorableState(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:willEncodeRestorableState:)))
		case .willPresentError(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.application(_:willPresentError:)))
		case .willTerminate(let x): delegate().addHandler(x, #selector(NSApplicationDelegate.applicationWillTerminate(_:)))
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
		case .didBecomeActive(let x): return Signal.notifications(name: NSApplication.didBecomeActiveNotification, object: instance).map { n in
				return ()
			}.cancellableBind(to: x)
		case .didChangeOcclusionState(let x): return Signal.notifications(name: NSApplication.didChangeOcclusionStateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didChangeScreenParameters(let x): return Signal.notifications(name: NSApplication.didChangeScreenParametersNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didFailToContinueUserActivity: return nil
		case .didFailToRegisterForRemoteNotifications: return nil
		case .didFinishLaunching(let x): return Signal.notifications(name: NSApplication.didFinishLaunchingNotification, object: instance).compactMap { n -> [AnyHashable: Any] in n.userInfo ?? [:] }.cancellableBind(to: x)
		case .didFinishRestoringWindows(let x): return Signal.notifications(name: NSApplication.didFinishRestoringWindowsNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didHide(let x): return Signal.notifications(name: NSApplication.didHideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didReceiveRemoteNotification: return nil
		case .didRegisterForRemoteNotifications: return nil
		case .didResignActive(let x): return Signal.notifications(name: NSApplication.didResignActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didUnhide(let x): return Signal.notifications(name: NSApplication.didUnhideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didUpdate(let x): return Signal.notifications(name: NSApplication.didUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willBecomeActive(let x): return Signal.notifications(name: NSApplication.willBecomeActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willFinishLaunching(let x): return Signal.notifications(name: NSApplication.willFinishLaunchingNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willHide(let x): return Signal.notifications(name: NSApplication.willHideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willResignActive(let x): return Signal.notifications(name: NSApplication.willResignActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willUnhide(let x): return Signal.notifications(name: NSApplication.willUnhideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willUpdate(let x): return Signal.notifications(name: NSApplication.willUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			
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
		open func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
			switch handler(ofType: (() -> ApplicationTerminateReply).self)!() {
			case .now: return NSApplication.TerminateReply.terminateNow
			case .cancel: return NSApplication.TerminateReply.terminateCancel
			case .later(let c):
				// Run as a keep alive (effectively, owned by the input)
				c.subscribeUntilEnd { [weak sender] result in
					sender?.reply(toApplicationShouldTerminate: result.value == true)
				}
				return NSApplication.TerminateReply.terminateLater
			}
		}
		
		open func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
			return handler(ofType: (() -> Bool).self)!()
		}
		
		open func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
			return handler(ofType: ((Bool) -> Bool).self)!(hasVisibleWindows)
		}
		
		open func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
			return handler(ofType: ((NSUserActivity, @escaping ([NSUserActivityRestoring]) -> Void) -> Bool).self)!(userActivity, restorationHandler)
		}
		
		open func application(_ application: NSApplication, willPresentError error: Error) -> Error {
			return handler(ofType: ((Error) -> Error).self)!(error)
		}
		
		open func application(_ application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
			return handler(ofType: ((String) -> Bool).self)!(userActivityType)
		}
		
		open func application(_ sender: Any, openFileWithoutUI filename: String) -> Bool {
			return handler(ofType: ((String) -> Bool).self)!(filename)
		}
		
		open func application(_ sender: NSApplication, openFile filename: String) -> Bool {
			return handler(ofType: ((String) -> Bool).self)!(filename)
		}
		
		open func application(_ sender: NSApplication, openFiles filenames: [String]) {
			handler(ofType: (([String]) -> Void).self)!(filenames)
		}
		
		open func application(_ sender: NSApplication, printFile filename: String) -> Bool {
			return handler(ofType: ((String) -> Bool).self)!(filename)
		}
		
		open func application(_ application: NSApplication, printFiles filenames: [String], withSettings printSettings: [NSPrintInfo.AttributeKey: Any], showPrintPanels: Bool) -> NSApplication.PrintReply {
			return handler(ofType: (([String], [NSPrintInfo.AttributeKey: Any], Bool) -> NSApplication.PrintReply).self)!(filenames, printSettings, showPrintPanels)
		}
		
		open func application(_ sender: NSApplication, openTempFile filename: String) -> Bool {
			return handler(ofType: ((String) -> Bool).self)!(filename)
		}
		
		open func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
			return handler(ofType: (() -> Bool).self)!()
		}
		
		open func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
			return handler(ofType: (() -> Bool).self)!()
		}
		
		open func applicationWillTerminate(_ notification: Notification) {
			handler(ofType: (() -> Void).self)!()
		}
		
		open func application(_ application: NSApplication, didUpdate userActivity: NSUserActivity) {
			return handler(ofType: ((NSUserActivity) -> Void).self)!(userActivity)
		}
		
		open func application(_ application: NSApplication, willEncodeRestorableState coder: NSCoder) {
			return handler(ofType: ((NSCoder) -> Void).self)!(coder)
		}
		
		open func application(_ application: NSApplication, didDecodeRestorableState coder: NSCoder) {
			return handler(ofType: ((NSCoder) -> Void).self)!(coder)
		}
		
		open func application(_ application: NSApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
			handler(ofType: SignalInput<(userActivityType: String, error: Error)>.self)!.send(value: (userActivityType, error))
		}
		
		open func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
			handler(ofType: SignalInput<[String: Any]>.self)!.send(value: userInfo)
		}
		
		open func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
			handler(ofType: SignalInput<Data>.self)!.send(value: deviceToken)
		}
		
		open func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
			handler(ofType: SignalInput<Error>.self)!.send(value: error)
		}
		
		open func application(_ application: NSApplication, userDidAcceptCloudKitShareWith metadata: CKShare.Metadata) {
			handler(ofType: ((CKShare.Metadata) -> Void).self)!(metadata)
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
	static var didFailToContinueUserActivity: ApplicationName<SignalInput<(userActivityType: String, error: Error)>> { return .name(B.didFailToContinueUserActivity) }
	static var didFailToRegisterForRemoteNotifications: ApplicationName<SignalInput<Error>> { return .name(B.didFailToRegisterForRemoteNotifications) }
	static var didFinishLaunching: ApplicationName<SignalInput<[AnyHashable: Any]>> { return .name(B.didFinishLaunching) }
	static var didFinishRestoringWindows: ApplicationName<SignalInput<Void>> { return .name(B.didFinishRestoringWindows) }
	static var didHide: ApplicationName<SignalInput<Void>> { return .name(B.didHide) }
	static var didReceiveRemoteNotification: ApplicationName<SignalInput<[String: Any]>> { return .name(B.didReceiveRemoteNotification) }
	static var didRegisterForRemoteNotifications: ApplicationName<SignalInput<Data>> { return .name(B.didRegisterForRemoteNotifications) }
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
	static var continueUserActivity: ApplicationName<(_ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool> { return .name(B.continueUserActivity) }
	static var didDecodeRestorableState: ApplicationName<(NSCoder) -> Void> { return .name(B.didDecodeRestorableState) }
	static var didUpdateUserActivity: ApplicationName<(NSUserActivity) -> Void> { return .name(B.didUpdateUserActivity) }
	static var openFile: ApplicationName<(_ filename: String) -> Bool> { return .name(B.openFile) }
	static var openFiles: ApplicationName<(_ filenames: [String]) -> Void> { return .name(B.openFiles) }
	static var openFileWithoutUI: ApplicationName<(_ filename: String) -> Bool> { return .name(B.openFileWithoutUI) }
	static var openTempFile: ApplicationName<(_ filename: String) -> Bool> { return .name(B.openTempFile) }
	static var openUntitledFile: ApplicationName<() -> Bool> { return .name(B.openUntitledFile) }
	static var printFile: ApplicationName<(_ filename: String) -> Bool> { return .name(B.printFile) }
	static var printFiles: ApplicationName<(_ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply> { return .name(B.printFiles) }
	static var shouldHandleReopen: ApplicationName<(_ hasVisibleWindows: Bool) -> Bool> { return .name(B.shouldHandleReopen) }
	static var shouldOpenUntitledFile: ApplicationName<() -> Bool> { return .name(B.shouldOpenUntitledFile) }
	static var shouldTerminate: ApplicationName<() -> ApplicationTerminateReply> { return .name(B.shouldTerminate) }
	static var shouldTerminateAfterLastWindowClosed: ApplicationName<() -> Bool> { return .name(B.shouldTerminateAfterLastWindowClosed) }
	static var userDidAcceptCloudKitShare: ApplicationName<(CKShare.Metadata) -> Void> { return .name(B.userDidAcceptCloudKitShare) }
	static var willContinueUserActivity: ApplicationName<(_ type: String) -> Bool> { return .name(B.willContinueUserActivity) }
	static var willEncodeRestorableState: ApplicationName<(NSCoder) -> Void> { return .name(B.willEncodeRestorableState) }
	static var willPresentError: ApplicationName<(Error) -> Error> { return .name(B.willPresentError) }
	static var willTerminate: ApplicationName<() -> Void> { return .name(B.willTerminate) }
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
public enum ApplicationTerminateReply {
	case now
	case cancel
	case later(Signal<Bool>)
}

#endif
