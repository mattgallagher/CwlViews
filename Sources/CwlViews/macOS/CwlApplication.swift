//
//  CwlApplication.swift
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

import CloudKit
import simd

public func applicationMain(application: @escaping () -> Application) {
	application().applyBindings(to: NSApplication.shared)
	NSApplication.shared.run()
}

public class Application: Binder {
	public typealias Inherited = BaseBinder
	public typealias Instance = NSApplication
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	
	public enum Binding: ApplicationBinding {
		public typealias EnclosingBinder = Application
		public static func applicationBinding(_ binding: Application.Binding) -> Application.Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static styles are applied at construction and are subsequently immutable.
	
		// 1. Value bindings may be applied at construction and may subsequently change.
		case mainMenu(Dynamic<MenuConvertible?>)
		case dockMenu(Dynamic<MenuConvertible?>)
		case applicationIconImage(Dynamic<NSImage>)
		case activationPolicy(Dynamic<NSApplication.ActivationPolicy>)
		case presentationOptions(Dynamic<NSApplication.PresentationOptions>)
		case relauchOnLogin(Dynamic<Bool>)
		case menuBarVisible(Dynamic<Bool>)
		case remoteNotifications(Dynamic<NSApplication.RemoteNotificationType>)
		
		// 2. Signal bindings are performed on the object after construction.
		case hide(Signal<Void>)
		case unhide(Signal<Bool>)
		case deactivate(Signal<Void>)
		case activate(Signal<Bool>)
		case hideOtherApplications(Signal<Void>)
		case unhideAllApplications(Signal<Void>)
		case arrangeInFront(Signal<Void>)
		case miniaturizeAll(Signal<Void>)
		case terminate(Signal<Void>)
		case requestUserAttention(Signal<(NSApplication.RequestUserAttentionType, Signal<Void>)>)
		case orderFrontCharacterPalette(Signal<Void>)
		case orderFrontColorPanel(Signal<Void>)
		case orderFrontStandardAboutPanel(Signal<Dictionary<String, Any>>)
		case presentError(Signal<Callback<Error, Bool>>)
		
		// 3. Action bindings are triggered by the object after construction.
		case didBecomeActive(SignalInput<Void>)
		case didChangeOcclusionState(SignalInput<Void>)
		case didChangeScreenParameters(SignalInput<Void>)
		case didHide(SignalInput<Void>)
		case didFailToContinueUserActivity(SignalInput<(userActivityType: String, error: Error)>)
		case didFinishLaunching(SignalInput<(isDefaultLaunch: Bool, userNotification: NSUserNotification)>)
		case didFinishRestoringWindows(SignalInput<Void>)
		case didReceiveRemoteNotification(SignalInput<[String: Any]>)
		case didResignActive(SignalInput<Void>)
		case didRegisterForRemoteNotifications(SignalInput<Data>)
		case didFailToRegisterForRemoteNotifications(SignalInput<Error>)
		case didUnhide(SignalInput<Void>)
		case didUpdate(SignalInput<Void>)
		case willBecomeActive(SignalInput<Void>)
		case willHide(SignalInput<Void>)
		case willFinishLaunching(SignalInput<Void>)
		case willResignActive(SignalInput<Void>)
		case willUnhide(SignalInput<Void>)
		case willUpdate(SignalInput<Void>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldTerminate(() -> ApplicationTerminateReply)
		case shouldTerminateAfterLastWindowClosed(() -> Bool)
		case shouldHandleReopen((_ hasVisibleWindows: Bool) -> Bool)
		case continueUserActivity((_ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool)
		case didUpdateUserActivity((NSUserActivity) -> Void)
		@available(macOS 10.12, *) case userDidAcceptCloudKitShare((CKShare.Metadata) -> Void)
		case willPresentError((Error) -> Error)
		case willContinueUserActivity((_ type: String) -> Bool)
		case openFileWithoutUI((_ filename: String) -> Bool)
		case openFile((_ filename: String) -> Bool)
		case openFiles((_ filenames: [String]) -> Void)
		case printFile((_ filename: String) -> Bool)
		case printFiles((_ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply)
		case openTempFile((_ filename: String) -> Bool)
		case openUntitledFile(() -> Bool)
		case shouldOpenUntitledFile(() -> Bool)
		case willTerminate(() -> Void)
		case didDecodeRestorableState((NSCoder) -> Void)
		case willEncodeRestorableState((NSCoder) -> Void)
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Application
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var possibleDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .shouldTerminate(let x):
				let s = #selector(NSApplicationDelegate.applicationShouldTerminate(_:))
				delegate().addSelector(s).shouldTerminate = { app -> NSApplication.TerminateReply in
					let result = x()
					switch result {
					case .now: return NSApplication.TerminateReply.terminateNow
					case .cancel: return NSApplication.TerminateReply.terminateCancel
					case .later(let c):
						// Run as a keep alive (effectively, owned by the input)
						c.subscribeUntilEnd { [weak app] result in
							app?.reply(toApplicationShouldTerminate: result.value == true)
						}
						return NSApplication.TerminateReply.terminateLater
					}
				}
			case .shouldTerminateAfterLastWindowClosed(let x):
				let s = #selector(NSApplicationDelegate.applicationShouldTerminateAfterLastWindowClosed(_:))
				delegate().addSelector(s).shouldTerminateAfterLastWindowClosed = x
			case .shouldHandleReopen(let x):
				let s = #selector(NSApplicationDelegate.applicationShouldHandleReopen(_:hasVisibleWindows:))
				delegate().addSelector(s).shouldHandleReopen = x
			case .continueUserActivity(let x):
				let s = #selector(NSApplicationDelegate.application(_:continue:restorationHandler:))
				delegate().addSelector(s).continueUserActivity = x
			case .didUpdateUserActivity(let x):
				let s = #selector(NSApplicationDelegate.application(_:didUpdate:))
				delegate().addSelector(s).didUpdateUserActivity = x
			case .userDidAcceptCloudKitShare(let x):
				if #available(macOS 10.12, *) {
					let s = #selector(NSApplicationDelegate.application(_:userDidAcceptCloudKitShareWith:))
					delegate().addSelector(s).userDidAcceptCloudKitShare = x
				}
			case .willPresentError(let x):
				let s = #selector(NSApplicationDelegate.application(_:willPresentError:))
				delegate().addSelector(s).willPresentError = x
			case .willContinueUserActivity(let x):
				let s = #selector(NSApplicationDelegate.application(_:willContinueUserActivityWithType:))
				delegate().addSelector(s).willContinueUserActivity = x
			case .openFiles(let x):
				let s = #selector(NSApplicationDelegate.application(_:openFiles:))
				delegate().addSelector(s).openFiles = x
			case .openFile(let x):
				let s = #selector(NSApplicationDelegate.application(_:openFile:))
				delegate().addSelector(s).openFile = x
			case .openFileWithoutUI(let x):
				let s = #selector(NSApplicationDelegate.application(_:openFileWithoutUI:))
				delegate().addSelector(s).openFileWithoutUI = x
			case .openTempFile(let x):
				let s = #selector(NSApplicationDelegate.application(_:openTempFile:))
				delegate().addSelector(s).openTempFile = x
			case .openUntitledFile(let x):
				let s = #selector(NSApplicationDelegate.applicationOpenUntitledFile(_:))
				delegate().addSelector(s).openUntitledFile = x
			case .shouldOpenUntitledFile(let x):
				let s = #selector(NSApplicationDelegate.applicationShouldOpenUntitledFile(_:))
				delegate().addSelector(s).shouldOpenUntitledFile = x
			case .printFiles(let x):
				let s = #selector(NSApplicationDelegate.application(_:printFiles:withSettings:showPrintPanels:))
				delegate().addSelector(s).printFiles = x
			case .printFile(let x):
				let s = #selector(NSApplicationDelegate.application(_:printFile:))
				delegate().addSelector(s).printFile = x
			case .willTerminate(let x):
				let s = #selector(NSApplicationDelegate.applicationWillTerminate(_:))
				delegate().addSelector(s).willTerminate = x
			case .willEncodeRestorableState(let x):
				let s = #selector(NSApplicationDelegate.application(_:willEncodeRestorableState:))
				delegate().addSelector(s).willEncodeRestorableState = x
			case .didDecodeRestorableState(let x):
				let s = #selector(NSApplicationDelegate.application(_:didDecodeRestorableState:))
				delegate().addSelector(s).didDecodeRestorableState = x
			case .didFailToContinueUserActivity:
				delegate().addSelector(#selector(NSApplicationDelegate.application(_:didFailToContinueUserActivityWithType:error:)))
			case .didReceiveRemoteNotification:
				delegate().addSelector(#selector(NSApplicationDelegate.application(_:didReceiveRemoteNotification:)))
			case .didRegisterForRemoteNotifications:
				delegate().addSelector(#selector(NSApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)))
			case .didFailToRegisterForRemoteNotifications:
				delegate().addSelector(#selector(NSApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:)))
			case .inheritedBinding(let preceeding): linkedPreparer.prepareBinding(preceeding)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			if storage.inUse {
				instance.delegate = storage
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .remoteNotifications(let x): return x.apply(instance, storage) { i, s, v in
				if v.isEmpty {
					i.unregisterForRemoteNotifications()
				} else {
					i.registerForRemoteNotifications(matching: v)
				}
				}
			case .mainMenu(let x): return x.apply(instance, storage) { i, s, v in i.mainMenu = v?.nsMenu() }
			case .dockMenu(let x): return x.apply(instance, storage) { i, s, v in s.dockMenu = v?.nsMenu() }
			case .applicationIconImage(let x): return x.apply(instance, storage) { i, s, v in i.applicationIconImage = v }
			case .activationPolicy(let x): return x.apply(instance, storage) { i, s, v in i.setActivationPolicy(v) }
			case .presentationOptions(let x): return x.apply(instance, storage) { i, s, v in i.presentationOptions = v }
			case .relauchOnLogin(let x):
				return x.apply(instance, storage) { i, s, v in
					if v {
						i.enableRelaunchOnLogin()
					} else {
						i.disableRelaunchOnLogin()
					}
				}
			case .menuBarVisible(let x): return x.apply(instance, storage) { i, s, v in NSMenu.setMenuBarVisible(v) }
				
			// Incoming actions <--
			case .hide(let x): return x.apply(instance, storage) { i, s, v in i.hide(nil) }
			case .unhide(let x): return x.apply(instance, storage) { i, s, v in i.unhide(nil) }
			case .deactivate(let x): return x.apply(instance, storage) { i, s, v in i.deactivate() }
			case .activate(let x): return x.apply(instance, storage) { i, s, v in i.activate(ignoringOtherApps: v) }
			case .hideOtherApplications(let x): return x.apply(instance, storage) { i, s, v in i.hideOtherApplications(nil) }
			case .unhideAllApplications(let x): return x.apply(instance, storage) { i, s, v in i.unhideAllApplications(nil) }
			case .arrangeInFront(let x): return x.apply(instance, storage) { i, s, v in i.arrangeInFront(nil) }
			case .miniaturizeAll(let x): return x.apply(instance, storage) { i, s, v in i.miniaturizeAll(nil) }
			case .terminate(let x): return x.apply(instance, storage) { i, s, v in i.terminate(nil) }
			case .requestUserAttention(let x):
				var outstandingRequests = [Lifetime]()
				return x.apply(instance, storage) { i, s, v in
					let requestIndex = i.requestUserAttention(v.0)
					outstandingRequests += v.1.subscribe { [weak i] r in i?.cancelUserAttentionRequest(requestIndex) }
				}
			case .orderFrontCharacterPalette(let x): return x.apply(instance, storage) { i, s, v in i.orderFrontCharacterPalette(nil) }
			case .orderFrontColorPanel(let x): return x.apply(instance, storage) { i, s, v in i.orderFrontColorPanel(nil) }
			case .orderFrontStandardAboutPanel(let x): return x.apply(instance, storage) { i, s, v in i.orderFrontStandardAboutPanel(v) }
			case .presentError(let x):
				return x.apply(instance, storage) { i, s, v in
					let handled = i.presentError(v.value)
					_ = v.callback?.send(value: handled)
				}
				
			// Outgoing actions -->
			case .didBecomeActive(let x):
				return Signal.notifications(name: NSApplication.didBecomeActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didChangeOcclusionState(let x):
				return Signal.notifications(name: NSApplication.didChangeOcclusionStateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didChangeScreenParameters(let x):
				return Signal.notifications(name: NSApplication.didChangeScreenParametersNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didHide(let x):
				return Signal.notifications(name: NSApplication.didHideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didFailToContinueUserActivity(let x):
				if let d = possibleDelegate {
					let s = #selector(NSApplicationDelegate.application(_:didFailToContinueUserActivityWithType:error:))
					let (input, signal) = Signal<(userActivityType: String, error: Error)>.create()
					d.addSelector(s).didFailToContinueUserActivity = { t, e in input.send(value: (t, e)) }
					return signal.cancellableBind(to: x)
				}
				return nil
			case .didFinishLaunching(let x):
				return Signal.notifications(name: NSApplication.didFinishLaunchingNotification, object: instance).compactMap { n -> (isDefaultLaunch: Bool, userNotification: NSUserNotification)? in
					if let d = (n.userInfo?[NSApplication.launchIsDefaultUserInfoKey] as? NSNumber)?.boolValue, let n = n.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? NSUserNotification {
						return (d, n)
					}
					return nil
					}.cancellableBind(to: x)
			case .didFinishRestoringWindows(let x):
				return Signal.notifications(name: NSApplication.didFinishRestoringWindowsNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didReceiveRemoteNotification(let x):
				if let d = possibleDelegate {
					let s = #selector(NSApplicationDelegate.application(_:didReceiveRemoteNotification:))
					let (input, signal) = Signal<[String: Any]>.create()
					d.addSelector(s).didReceiveRemoteNotification = { userInfo in input.send(value: userInfo) }
					return signal.cancellableBind(to: x)
				}
				return nil
			case .didResignActive(let x):
				return Signal.notifications(name: NSApplication.didResignActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didRegisterForRemoteNotifications(let x):
				if let d = possibleDelegate {
					let s = #selector(NSApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:))
					let (input, signal) = Signal<Data>.create()
					d.addSelector(s).didRegisterForRemoteNotifications = { data in input.send(value: data) }
					return signal.cancellableBind(to: x)
				}
				return nil
			case .didFailToRegisterForRemoteNotifications(let x):
				if let d = possibleDelegate {
					let s = #selector(NSApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:))
					let (input, signal) = Signal<Error>.create()
					d.addSelector(s).didFailToRegisterForRemoteNotifications = { err in input.send(value: err) }
					return signal.cancellableBind(to: x)
				}
				return nil
			case .didUnhide(let x):
				return Signal.notifications(name: NSApplication.didUnhideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didUpdate(let x):
				return Signal.notifications(name: NSApplication.didUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willBecomeActive(let x):
				return Signal.notifications(name: NSApplication.willBecomeActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willHide(let x):
				return Signal.notifications(name: NSApplication.willHideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willFinishLaunching(let x):
				return Signal.notifications(name: NSApplication.willFinishLaunchingNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willResignActive(let x):
				return Signal.notifications(name: NSApplication.willResignActiveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willUnhide(let x):
				return Signal.notifications(name: NSApplication.willUnhideNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willUpdate(let x):
				return Signal.notifications(name: NSApplication.willUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
				
			// Delegates <-->
			case .shouldTerminate: return nil
			case .shouldTerminateAfterLastWindowClosed: return nil
			case .shouldHandleReopen: return nil
			case .continueUserActivity: return nil
			case .didUpdateUserActivity: return nil
			case .userDidAcceptCloudKitShare: return nil
			case .willPresentError: return nil
			case .willContinueUserActivity: return nil
			case .openFiles: return nil
			case .openFile: return nil
			case .openFileWithoutUI: return nil
			case .openTempFile: return nil
			case .openUntitledFile: return nil
			case .shouldOpenUntitledFile: return nil
			case .printFiles: return nil
			case .printFile: return nil
			case .willTerminate: return nil
			case .willEncodeRestorableState: return nil
			case .didDecodeRestorableState: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ObjectBinderStorage, NSApplicationDelegate {
		open var dockMenu: NSMenu?
		
		open override var inUse: Bool {
			return super.inUse || dockMenu != nil
		}
		
		open func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
			return dockMenu
		}
	}
	
	open class Delegate: DynamicDelegate, NSApplicationDelegate {
		public required override init() {
			super.init()
		}
		
		open var shouldTerminate: ((NSApplication) -> NSApplication.TerminateReply)?
		open func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
			return shouldTerminate!(sender)
		}
		
		open var shouldTerminateAfterLastWindowClosed: (() -> Bool)?
		open func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
			return shouldTerminateAfterLastWindowClosed!()
		}
		
		open var shouldHandleReopen: ((Bool) -> Bool)?
		open func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
			return shouldHandleReopen!(hasVisibleWindows)
		}
		
		open var continueUserActivity: ((NSUserActivity, @escaping ([NSUserActivityRestoring]) -> Void) -> Bool)?
		open func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
			return continueUserActivity!(userActivity, restorationHandler)
		}
		
		open var willPresentError: ((Error) -> Error)?
		open func application(_ application: NSApplication, willPresentError error: Error) -> Error {
			return willPresentError!(error)
		}
		
		open var willContinueUserActivity: ((String) -> Bool)?
		open func application(_ application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
			return willContinueUserActivity!(userActivityType)
		}
		
		open var openFileWithoutUI: ((String) -> Bool)?
		open func application(_ sender: Any, openFileWithoutUI filename: String) -> Bool {
			return openFileWithoutUI!(filename)
		}
		
		open var openFile: ((String) -> Bool)?
		open func application(_ sender: NSApplication, openFile filename: String) -> Bool {
			return openFile!(filename)
		}
		
		open var openFiles: (([String]) -> Void)?
		open func application(_ sender: NSApplication, openFiles filenames: [String]) {
			openFiles!(filenames)
		}
		
		open var printFile: ((String) -> Bool)?
		open func application(_ sender: NSApplication, printFile filename: String) -> Bool {
			return printFile!(filename)
		}
		
		open var printFiles: (([String], [NSPrintInfo.AttributeKey: Any], Bool) -> NSApplication.PrintReply)?
		open func application(_ application: NSApplication, printFiles filenames: [String], withSettings printSettings: [NSPrintInfo.AttributeKey: Any], showPrintPanels: Bool) -> NSApplication.PrintReply {
			return printFiles!(filenames, printSettings, showPrintPanels)
		}
		
		open var openTempFile: ((String) -> Bool)?
		open func application(_ sender: NSApplication, openTempFile filename: String) -> Bool {
			return openTempFile!(filename)
		}
		
		open var openUntitledFile: (() -> Bool)?
		open func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
			return openUntitledFile!()
		}
		
		open var shouldOpenUntitledFile: (() -> Bool)?
		open func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
			return shouldOpenUntitledFile!()
		}
		
		open var willTerminate: (() -> Void)?
		open func applicationWillTerminate(_ notification: Notification) {
			willTerminate!()
		}
		
		open var didUpdateUserActivity: ((NSUserActivity) -> Void)?
		open func application(_ application: NSApplication, didUpdate userActivity: NSUserActivity) {
			return didUpdateUserActivity!(userActivity)
		}
		
		open var willEncodeRestorableState: ((NSCoder) -> Void)?
		open func application(_ application: NSApplication, willEncodeRestorableState coder: NSCoder) {
			return willEncodeRestorableState!(coder)
		}
		
		open var didDecodeRestorableState: ((NSCoder) -> Void)?
		open func application(_ application: NSApplication, didDecodeRestorableState coder: NSCoder) {
			return didDecodeRestorableState!(coder)
		}
		
		open var didFailToContinueUserActivity: ((String, Error) -> Void)?
		open func application(_ application: NSApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
			didFailToContinueUserActivity!(userActivityType, error)
		}
		
		open var didReceiveRemoteNotification: (([String: Any]) -> Void)?
		open func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
			didReceiveRemoteNotification!(userInfo)
		}
		
		open var didRegisterForRemoteNotifications: ((Data) -> Void)?
		open func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken token: Data) {
			didRegisterForRemoteNotifications!(token)
		}
		
		open var didFailToRegisterForRemoteNotifications: ((Error) -> Void)?
		open func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
			didFailToRegisterForRemoteNotifications!(error)
		}
		
		open var userDidAcceptCloudKitShare: Any?
		@available(macOS 10.12, *)
		open func application(_ application: NSApplication, userDidAcceptCloudKitShareWith metadata: CKShare.Metadata) {
			(userDidAcceptCloudKitShare as! (CKShare.Metadata) -> Void)(metadata)
		}
	}
}

extension BindingName where Binding: ApplicationBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .applicationBinding(Application.Binding.$1(v)) }) }

	//	0. Static styles are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var mainMenu: BindingName<Dynamic<MenuConvertible?>, Binding> { return BindingName<Dynamic<MenuConvertible?>, Binding>({ v in .applicationBinding(Application.Binding.mainMenu(v)) }) }
	public static var dockMenu: BindingName<Dynamic<MenuConvertible?>, Binding> { return BindingName<Dynamic<MenuConvertible?>, Binding>({ v in .applicationBinding(Application.Binding.dockMenu(v)) }) }
	public static var applicationIconImage: BindingName<Dynamic<NSImage>, Binding> { return BindingName<Dynamic<NSImage>, Binding>({ v in .applicationBinding(Application.Binding.applicationIconImage(v)) }) }
	public static var activationPolicy: BindingName<Dynamic<NSApplication.ActivationPolicy>, Binding> { return BindingName<Dynamic<NSApplication.ActivationPolicy>, Binding>({ v in .applicationBinding(Application.Binding.activationPolicy(v)) }) }
	public static var presentationOptions: BindingName<Dynamic<NSApplication.PresentationOptions>, Binding> { return BindingName<Dynamic<NSApplication.PresentationOptions>, Binding>({ v in .applicationBinding(Application.Binding.presentationOptions(v)) }) }
	public static var relauchOnLogin: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .applicationBinding(Application.Binding.relauchOnLogin(v)) }) }
	public static var menuBarVisible: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .applicationBinding(Application.Binding.menuBarVisible(v)) }) }
	public static var remoteNotifications: BindingName<Dynamic<NSApplication.RemoteNotificationType>, Binding> { return BindingName<Dynamic<NSApplication.RemoteNotificationType>, Binding>({ v in .applicationBinding(Application.Binding.remoteNotifications(v)) }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var hide: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.hide(v)) }) }
	public static var unhide: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .applicationBinding(Application.Binding.unhide(v)) }) }
	public static var deactivate: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.deactivate(v)) }) }
	public static var activate: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .applicationBinding(Application.Binding.activate(v)) }) }
	public static var hideOtherApplications: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.hideOtherApplications(v)) }) }
	public static var unhideAllApplications: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.unhideAllApplications(v)) }) }
	public static var arrangeInFront: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.arrangeInFront(v)) }) }
	public static var miniaturizeAll: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.miniaturizeAll(v)) }) }
	public static var terminate: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.terminate(v)) }) }
	public static var requestUserAttention: BindingName<Signal<(NSApplication.RequestUserAttentionType, Signal<Void>)>, Binding> { return BindingName<Signal<(NSApplication.RequestUserAttentionType, Signal<Void>)>, Binding>({ v in .applicationBinding(Application.Binding.requestUserAttention(v)) }) }
	public static var orderFrontCharacterPalette: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.orderFrontCharacterPalette(v)) }) }
	public static var orderFrontColorPanel: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .applicationBinding(Application.Binding.orderFrontColorPanel(v)) }) }
	public static var orderFrontStandardAboutPanel: BindingName<Signal<Dictionary<String, Any>>, Binding> { return BindingName<Signal<Dictionary<String, Any>>, Binding>({ v in .applicationBinding(Application.Binding.orderFrontStandardAboutPanel(v)) }) }
	public static var presentError: BindingName<Signal<Callback<Error, Bool>>, Binding> { return BindingName<Signal<Callback<Error, Bool>>, Binding>({ v in .applicationBinding(Application.Binding.presentError(v)) }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBecomeActive: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didBecomeActive(v)) }) }
	public static var didChangeOcclusionState: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didChangeOcclusionState(v)) }) }
	public static var didChangeScreenParameters: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didChangeScreenParameters(v)) }) }
	public static var didHide: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didHide(v)) }) }
	public static var didFailToContinueUserActivity: BindingName<SignalInput<(userActivityType: String, error: Error)>, Binding> { return BindingName<SignalInput<(userActivityType: String, error: Error)>, Binding>({ v in .applicationBinding(Application.Binding.didFailToContinueUserActivity(v)) }) }
	public static var didFinishLaunching: BindingName<SignalInput<(isDefaultLaunch: Bool, userNotification: NSUserNotification)>, Binding> { return BindingName<SignalInput<(isDefaultLaunch: Bool, userNotification: NSUserNotification)>, Binding>({ v in .applicationBinding(Application.Binding.didFinishLaunching(v)) }) }
	public static var didFinishRestoringWindows: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didFinishRestoringWindows(v)) }) }
	public static var didReceiveRemoteNotification: BindingName<SignalInput<[String: Any]>, Binding> { return BindingName<SignalInput<[String: Any]>, Binding>({ v in .applicationBinding(Application.Binding.didReceiveRemoteNotification(v)) }) }
	public static var didResignActive: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didResignActive(v)) }) }
	public static var didRegisterForRemoteNotifications: BindingName<SignalInput<Data>, Binding> { return BindingName<SignalInput<Data>, Binding>({ v in .applicationBinding(Application.Binding.didRegisterForRemoteNotifications(v)) }) }
	public static var didFailToRegisterForRemoteNotifications: BindingName<SignalInput<Error>, Binding> { return BindingName<SignalInput<Error>, Binding>({ v in .applicationBinding(Application.Binding.didFailToRegisterForRemoteNotifications(v)) }) }
	public static var didUnhide: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didUnhide(v)) }) }
	public static var didUpdate: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didUpdate(v)) }) }
	public static var willBecomeActive: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willBecomeActive(v)) }) }
	public static var willHide: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willHide(v)) }) }
	public static var willFinishLaunching: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willFinishLaunching(v)) }) }
	public static var willResignActive: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willResignActive(v)) }) }
	public static var willUnhide: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willUnhide(v)) }) }
	public static var willUpdate: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willUpdate(v)) }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var shouldTerminate: BindingName<() -> ApplicationTerminateReply, Binding> { return BindingName<() -> ApplicationTerminateReply, Binding>({ v in .applicationBinding(Application.Binding.shouldTerminate(v)) }) }
	public static var shouldTerminateAfterLastWindowClosed: BindingName<() -> Bool, Binding> { return BindingName<() -> Bool, Binding>({ v in .applicationBinding(Application.Binding.shouldTerminateAfterLastWindowClosed(v)) }) }
	public static var shouldHandleReopen: BindingName<(_ hasVisibleWindows: Bool) -> Bool, Binding> { return BindingName<(_ hasVisibleWindows: Bool) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.shouldHandleReopen(v)) }) }
	public static var continueUserActivity: BindingName<(_ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool, Binding> { return BindingName<(_ userActivity: NSUserActivity, _ restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.continueUserActivity(v)) }) }
	public static var didUpdateUserActivity: BindingName<(NSUserActivity) -> Void, Binding> { return BindingName<(NSUserActivity) -> Void, Binding>({ v in .applicationBinding(Application.Binding.didUpdateUserActivity(v)) }) }
	@available(macOS 10.12, *) public static var userDidAcceptCloudKitShare: BindingName<(CKShare.Metadata) -> Void, Binding> { return BindingName<(CKShare.Metadata) -> Void, Binding>({ v in .applicationBinding(Application.Binding.userDidAcceptCloudKitShare(v)) }) }
	public static var willPresentError: BindingName<(Error) -> Error, Binding> { return BindingName<(Error) -> Error, Binding>({ v in .applicationBinding(Application.Binding.willPresentError(v)) }) }
	public static var willContinueUserActivity: BindingName<(_ type: String) -> Bool, Binding> { return BindingName<(_ type: String) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.willContinueUserActivity(v)) }) }
	public static var openFileWithoutUI: BindingName<(_ filename: String) -> Bool, Binding> { return BindingName<(_ filename: String) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.openFileWithoutUI(v)) }) }
	public static var openFile: BindingName<(_ filename: String) -> Bool, Binding> { return BindingName<(_ filename: String) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.openFile(v)) }) }
	public static var openFiles: BindingName<(_ filenames: [String]) -> Void, Binding> { return BindingName<(_ filenames: [String]) -> Void, Binding>({ v in .applicationBinding(Application.Binding.openFiles(v)) }) }
	public static var printFile: BindingName<(_ filename: String) -> Bool, Binding> { return BindingName<(_ filename: String) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.printFile(v)) }) }
	public static var printFiles: BindingName<(_ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply, Binding> { return BindingName<(_ filenames: [String], _ settings: [NSPrintInfo.AttributeKey: Any], _ showPrintPanels: Bool) -> NSApplication.PrintReply, Binding>({ v in .applicationBinding(Application.Binding.printFiles(v)) }) }
	public static var openTempFile: BindingName<(_ filename: String) -> Bool, Binding> { return BindingName<(_ filename: String) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.openTempFile(v)) }) }
	public static var openUntitledFile: BindingName<() -> Bool, Binding> { return BindingName<() -> Bool, Binding>({ v in .applicationBinding(Application.Binding.openUntitledFile(v)) }) }
	public static var shouldOpenUntitledFile: BindingName<() -> Bool, Binding> { return BindingName<() -> Bool, Binding>({ v in .applicationBinding(Application.Binding.shouldOpenUntitledFile(v)) }) }
	public static var willTerminate: BindingName<() -> Void, Binding> { return BindingName<() -> Void, Binding>({ v in .applicationBinding(Application.Binding.willTerminate(v)) }) }
	public static var didDecodeRestorableState: BindingName<(NSCoder) -> Void, Binding> { return BindingName<(NSCoder) -> Void, Binding>({ v in .applicationBinding(Application.Binding.didDecodeRestorableState(v)) }) }
	public static var willEncodeRestorableState: BindingName<(NSCoder) -> Void, Binding> { return BindingName<(NSCoder) -> Void, Binding>({ v in .applicationBinding(Application.Binding.willEncodeRestorableState(v)) }) }
}

public protocol ApplicationBinding: BaseBinding {
	static func applicationBinding(_ binding: Application.Binding) -> Self
}
public extension ApplicationBinding {
	static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return applicationBinding(.inheritedBinding(binding))
	}
}

public enum ApplicationTerminateReply {
	case now
	case cancel
	case later(Signal<Bool>)
}
