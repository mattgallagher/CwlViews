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

import UIKit

public func applicationMain(type: UIApplication.Type = UIApplication.self, application: @escaping () -> Application) -> Never {
	Application.Preparer.Storage.storedApplicationConstructor = application
	_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(type), NSStringFromClass(Application.Preparer.Storage.self))
	fatalError("UIApplicationMain completed unexpectedly")
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
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case iconBadgeNumber(Dynamic<Int>)
		case isIdleTimerDisabled(Dynamic<Bool>)
		case isNetworkActivityIndicatorVisible(Dynamic<Bool>)
		case shortcutItems(Dynamic<[UIApplicationShortcutItem]?>)
		case supportShakeToEdit(Dynamic<Bool>)
		case window(Dynamic<WindowConvertible?>)

		//	2. Signal bindings are performed on the object after construction.
		case ignoreInteractionEvents(Signal<Bool>)
		case registerForRemoteNotifications(Signal<Bool>)

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case continueUserActivity((_ application: UIApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool)
		case didBecomeActive((UIApplication) -> Void)
		case didDecodeRestorableState((UIApplication, NSKeyedUnarchiver) -> Void)
		case didEnterBackground((UIApplication) -> Void)
		case didFailToContinueUserActivity((UIApplication, String, Error) -> Void)
		case didFinishLaunching((_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool)
		case didReceiveMemoryWarning((UIApplication) -> Void)
		case didReceiveRemoteNotification((UIApplication, [AnyHashable: Any], @escaping (UIBackgroundFetchResult) -> Void) -> Void)
		case didRegisterRemoteNotifications((UIApplication, Error) -> Void)
		case didUpdate((_ application: UIApplication, NSUserActivity) -> Void)
		case handleEventsForBackgroundURLSession((UIApplication, String, @escaping () -> Void) -> Void)
		case handleWatchKitExtensionRequest((UIApplication, [AnyHashable : Any]?, @escaping ([AnyHashable : Any]?) -> Void) -> Void)
		case open((_ application: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool)
		case performAction((UIApplication, UIApplicationShortcutItem, @escaping (Bool) -> Void) -> Void)
		case performFetch((UIApplication, @escaping (UIBackgroundFetchResult) -> Void) -> Void)
		case protectedDataDidBecomeAvailable((UIApplication) -> Void)
		case protectedDataWillBecomeUnavailable((UIApplication) -> Void)
		case shouldAllowExtensionPointIdentifier((_ application: UIApplication, UIApplication.ExtensionPointIdentifier) -> Bool)
		case shouldRequestHealthAuthorization((_ application: UIApplication) -> Void)
		case significantTimeChange((UIApplication) -> Void)
		case viewControllerWithRestorationPath((_ application: UIApplication, _ path: [String], _ coder: NSCoder) -> UIViewController?)
		case willContinueUserActivity((_ application: UIApplication, String) -> Bool)
		case willEncodeRestorableState((_ application: UIApplication, NSKeyedArchiver) -> Void)
		case willEnterForeground((UIApplication) -> Void)
		case willFinishLaunching((_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool)
		case willResignActive((UIApplication) -> Void)
		case willTerminate((_ application: UIApplication) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension Application {
	struct Preparer: BinderDelegateEmbedder {
		public typealias Binding = Application.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = UIApplication
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage.storedStorage! }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Application.Preparer {
	var delegateIsRequired: Bool { return true }

	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let s): inherited.prepareBinding(s)

		case .continueUserActivity(let x): delegate().addSingleHandler3(x, #selector(UIApplicationDelegate.application(_:continue:restorationHandler:)))
		case .didBecomeActive(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
		case .didDecodeRestorableState(let x):
			delegate().addMultiHandler2(x, #selector(UIApplicationDelegate.application(_:didDecodeRestorableStateWith:)))
			delegate().addSingleHandler2({ (a: UIApplication, c: NSCoder) in true }, #selector(UIApplicationDelegate.application(_:shouldRestoreApplicationState:)))
		case .didEnterBackground(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
		case .didFailToContinueUserActivity(let x): delegate().addMultiHandler3(x, #selector(UIApplicationDelegate.application(_:didFailToContinueUserActivityWithType:error:)))
		case .didFinishLaunching(let x): delegate().addSingleHandler2(x, #selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)))
		case .didReceiveMemoryWarning(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationDidReceiveMemoryWarning(_:)))
		case .didReceiveRemoteNotification(let x): delegate().addMultiHandler3(x, #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
		case .didRegisterRemoteNotifications(let x):
			delegate().addMultiHandler2(x, #selector(UIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)))
			delegate().addMultiHandler2(x, #selector(UIApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:)))
		case .didUpdate(let x): delegate().addMultiHandler2(x, #selector(UIApplicationDelegate.application(_:didUpdate:)))
		case .handleEventsForBackgroundURLSession(let x): delegate().addMultiHandler3(x, #selector(UIApplicationDelegate.application(_:handleEventsForBackgroundURLSession:completionHandler:)))
		case .handleWatchKitExtensionRequest(let x): delegate().addMultiHandler3(x, #selector(UIApplicationDelegate.application(_:handleWatchKitExtensionRequest:reply:)))
		case .open(let x): delegate().addSingleHandler3(x, #selector(UIApplicationDelegate.application(_:open:options:)))
		case .performAction(let x): delegate().addMultiHandler3(x, #selector(UIApplicationDelegate.application(_:performActionFor:completionHandler:)))
		case .performFetch(let x): delegate().addMultiHandler2(x, #selector(UIApplicationDelegate.application(_:performFetchWithCompletionHandler:)))
		case .protectedDataWillBecomeUnavailable(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationProtectedDataWillBecomeUnavailable(_:)))
		case .protectedDataDidBecomeAvailable(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationProtectedDataDidBecomeAvailable(_:)))
		case .shouldAllowExtensionPointIdentifier(let x): delegate().addSingleHandler2(x, #selector(UIApplicationDelegate.application(_:shouldAllowExtensionPointIdentifier:)))
		case .shouldRequestHealthAuthorization(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationShouldRequestHealthAuthorization(_:)))
		case .significantTimeChange(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationSignificantTimeChange(_:)))
		case .viewControllerWithRestorationPath(let x): delegate().addSingleHandler3(x, #selector(UIApplicationDelegate.application(_:viewControllerWithRestorationIdentifierPath:coder:)))
		case .willContinueUserActivity(let x): delegate().addSingleHandler2(x, #selector(UIApplicationDelegate.application(_:willContinueUserActivityWithType:)))
		case .willEncodeRestorableState(let x):
			delegate().addMultiHandler2(x, #selector(UIApplicationDelegate.application(_:willEncodeRestorableStateWith:)))
			delegate().addSingleHandler2({ (a: UIApplication, c: NSCoder) in true }, #selector(UIApplicationDelegate.application(_:shouldSaveApplicationState:)))
		case .willEnterForeground(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
		case .willResignActive(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationWillResignActive(_:)))
		case .willTerminate(let x): delegate().addMultiHandler1(x, #selector(UIApplicationDelegate.applicationWillTerminate(_:)))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .iconBadgeNumber(let x): return x.apply(instance) { i, v in i.applicationIconBadgeNumber = v }
		case .isIdleTimerDisabled(let x): return x.apply(instance) { i, v in i.isIdleTimerDisabled = v }
		case .isNetworkActivityIndicatorVisible(let x): return x.apply(instance) { i, v in i.isNetworkActivityIndicatorVisible = v }
		case .shortcutItems(let x): return x.apply(instance) { i, v in i.shortcutItems = v }
		case .supportShakeToEdit(let x): return x.apply(instance) { i, v in i.applicationSupportsShakeToEdit = v }
		case .window(let x): return x.apply(instance, storage) { i, s, v in s.window = v?.uiWindow() }

		//	2. Signal bindings are performed on the object after construction.
		case .ignoreInteractionEvents(let x):
			return x.apply(instance) { i, v in
				switch (i.isIgnoringInteractionEvents, v) {
				case (false, true): i.beginIgnoringInteractionEvents()
				case (true, false): i.endIgnoringInteractionEvents()
				default: break
				}
			}
		case .registerForRemoteNotifications(let x):
			return x.apply(instance) { i, v in
				switch (i.isRegisteredForRemoteNotifications, v) {
				case (false, true): i.registerForRemoteNotifications()
				case (true, false): i.unregisterForRemoteNotifications()
				default: break
				}
			}

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .didBecomeActive: return nil
		case .didEnterBackground: return nil
		case .didFailToContinueUserActivity: return nil
		case .didReceiveMemoryWarning: return nil
		case .didReceiveRemoteNotification: return nil
		case .didRegisterRemoteNotifications: return nil
		case .handleEventsForBackgroundURLSession: return nil
		case .handleWatchKitExtensionRequest: return nil
		case .performAction: return nil
		case .performFetch: return nil
		case .protectedDataDidBecomeAvailable: return nil
		case .protectedDataWillBecomeUnavailable: return nil
		case .significantTimeChange: return nil
		case .willEnterForeground: return nil
		case .willResignActive: return nil
		case .continueUserActivity: return nil
		case .didDecodeRestorableState: return nil
		case .didFinishLaunching: return nil
		case .didUpdate: return nil
		case .open: return nil
		case .shouldAllowExtensionPointIdentifier: return nil
		case .shouldRequestHealthAuthorization: return nil
		case .viewControllerWithRestorationPath: return nil
		case .willContinueUserActivity: return nil
		case .willEncodeRestorableState: return nil
		case .willFinishLaunching(let x):
			storage.willFinishLaunching = x
			return nil
		case .willTerminate: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Application.Preparer {
	open class Storage: AssociatedBinderStorage, UIApplicationDelegate {
		static var storedApplicationConstructor: (() -> Application)? = nil
		static var storedStorage: Storage? = nil
		
		open var window: UIWindow? = nil
		open var additionalWindows: [UIWindow] = []
		open var willFinishLaunching: ((UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool)?

		open override var isInUse: Bool {
			return true
		}
		
		open func applyToSharedApplication() {
			// If the storageApplicationConstructor is not set, this function is a no-op. This is useful during testing.
			guard let application = Storage.storedApplicationConstructor else { return }
			
			// Disconnect the delegate since we're about to change the handled delegate methods
			UIApplication.shared.delegate = nil
			Application.Preparer.Storage.storedStorage = self
			
			// Apply the styles to the application and delegate.
			application().apply(to: UIApplication.shared)
			
			Application.Preparer.Storage.storedApplicationConstructor = nil
			Application.Preparer.Storage.storedStorage = nil
			
			// Ensure that the delegate was reapplied
			assert(UIApplication.shared.delegate === self, "Failed to reconnect delegate")
			
			// Apply the view hierarchy
			window?.makeKeyAndVisible()
		}
		
		public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
			applyToSharedApplication()
			
			// Invoke any user-supplied code
			return willFinishLaunching?(application, launchOptions) ?? true
		}
	}

	open class Delegate: DynamicDelegate, UIApplicationDelegate {
		public func applicationDidBecomeActive(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func applicationWillResignActive(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func applicationDidEnterBackground(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func applicationWillEnterForeground(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
			return singleHandler(application, launchOptions)
		}
		
		public func applicationWillTerminate(_ application: UIApplication) {
			return singleHandler(application)
		}
		
		public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
			return multiHandler(application, coder as! NSKeyedArchiver)
		}
		
		public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
			return multiHandler(application, coder as! NSKeyedUnarchiver)
		}
		
		public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
			multiHandler(application, completionHandler)
		}
		
		public func application(_ application: UIApplication, handleEventsForBackgroundURLSession session: String, completionHandler: @escaping () -> Void) {
			multiHandler(application, session, completionHandler)
		}
		
		public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
			multiHandler(application, deviceToken)
		}
		
		public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
			multiHandler(application, error)
		}
		
		public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
			multiHandler(application, userInfo, completionHandler)
		}
		
		public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
			multiHandler(application, identifier, userInfo, completionHandler)
		}
		
		public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
			multiHandler(application, identifier, userInfo, responseInfo, completionHandler)
		}
		
		public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
			multiHandler(application, userActivityType, error)
		}
		
		public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
			multiHandler(application, userInfo, reply)
		}
		
		public func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
			return singleHandler(application, userActivityType)
		}
		
		public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
			return singleHandler(application, userActivity, restorationHandler)
		}
		
		public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
			multiHandler(application, userActivity)
		}
		
		public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
			// The existence of this selector on the dynamic delegate triggers an always true response
			return true
		}
		
		public func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
			// The existence of this selector on the dynamic delegate triggers an always true response
			return true
		}
		
		public func applicationSignificantTimeChange(_ application: UIApplication) {
			multiHandler(application)
		}
		
		public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
			return singleHandler(application, identifierComponents, coder)
		}
		
		public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
			return singleHandler(application, url, options)
		}
		
		public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
			return singleHandler(application, extensionPointIdentifier)
		}
		
		public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
			multiHandler(application, shortcutItem, completionHandler)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ApplicationBinding {
	public typealias ApplicationName<V> = BindingName<V, Application.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> Application.Binding) -> ApplicationName<V> {
		return ApplicationName<V>(source: source, downcast: Binding.applicationBinding)
	}
}
public extension BindingName where Binding: ApplicationBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ApplicationName<$2> { return .name(Application.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var iconBadgeNumber: ApplicationName<Dynamic<Int>> { return .name(Application.Binding.iconBadgeNumber) }
	static var isIdleTimerDisabled: ApplicationName<Dynamic<Bool>> { return .name(Application.Binding.isIdleTimerDisabled) }
	static var isNetworkActivityIndicatorVisible: ApplicationName<Dynamic<Bool>> { return .name(Application.Binding.isNetworkActivityIndicatorVisible) }
	static var shortcutItems: ApplicationName<Dynamic<[UIApplicationShortcutItem]?>> { return .name(Application.Binding.shortcutItems) }
	static var supportShakeToEdit: ApplicationName<Dynamic<Bool>> { return .name(Application.Binding.supportShakeToEdit) }
	static var window: ApplicationName<Dynamic<WindowConvertible?>> { return .name(Application.Binding.window) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var ignoreInteractionEvents: ApplicationName<Signal<Bool>> { return .name(Application.Binding.ignoreInteractionEvents) }
	static var registerForRemoteNotifications: ApplicationName<Signal<Bool>> { return .name(Application.Binding.registerForRemoteNotifications) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var continueUserActivity: ApplicationName<(_ application: UIApplication, _ userActivity: NSUserActivity, _ restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool> { return .name(Application.Binding.continueUserActivity) }
	static var didBecomeActive: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.didBecomeActive) }
	static var didDecodeRestorableState: ApplicationName<(_ application: UIApplication, NSKeyedUnarchiver) -> Void> { return .name(Application.Binding.didDecodeRestorableState) }
	static var didEnterBackground: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.didEnterBackground) }
	static var didFailToContinueUserActivity: ApplicationName<(UIApplication, String, Error) -> Void> { return .name(Application.Binding.didFailToContinueUserActivity) }
	static var didFinishLaunching: ApplicationName<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool> { return .name(Application.Binding.didFinishLaunching) }
	static var didReceiveMemoryWarning: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.didReceiveMemoryWarning) }
	static var didReceiveRemoteNotification: ApplicationName<(UIApplication, [AnyHashable: Any], @escaping (UIBackgroundFetchResult) -> Void) -> Void> { return .name(Application.Binding.didReceiveRemoteNotification) }
	static var didRegisterRemoteNotifications: ApplicationName<(UIApplication, Error) -> Void> { return .name(Application.Binding.didRegisterRemoteNotifications) }
	static var didUpdate: ApplicationName<(_ application: UIApplication, NSUserActivity) -> Void> { return .name(Application.Binding.didUpdate) }
	static var handleEventsForBackgroundURLSession: ApplicationName<(UIApplication, String, @escaping () -> Void) -> Void> { return .name(Application.Binding.handleEventsForBackgroundURLSession) }
	static var handleWatchKitExtensionRequest: ApplicationName<(UIApplication, [AnyHashable : Any]?, @escaping ([AnyHashable : Any]?) -> Void) -> Void> { return .name(Application.Binding.handleWatchKitExtensionRequest) }
	static var open: ApplicationName<(_ application: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool> { return .name(Application.Binding.open) }
	static var performAction: ApplicationName<(UIApplication, UIApplicationShortcutItem, @escaping (Bool) -> Void) -> Void> { return .name(Application.Binding.performAction) }
	static var performFetch: ApplicationName<(UIApplication, @escaping (UIBackgroundFetchResult) -> Void) -> Void> { return .name(Application.Binding.performFetch) }
	static var protectedDataDidBecomeAvailable: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.protectedDataDidBecomeAvailable) }
	static var protectedDataWillBecomeUnavailable: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.protectedDataWillBecomeUnavailable) }
	static var shouldAllowExtensionPointIdentifier: ApplicationName<(_ application: UIApplication, UIApplication.ExtensionPointIdentifier) -> Bool> { return .name(Application.Binding.shouldAllowExtensionPointIdentifier) }
	static var shouldRequestHealthAuthorization: ApplicationName<(_ application: UIApplication) -> Void> { return .name(Application.Binding.shouldRequestHealthAuthorization) }
	static var significantTimeChange: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.significantTimeChange) }
	static var viewControllerWithRestorationPath: ApplicationName<(_ application: UIApplication, _ path: [String], _ coder: NSCoder) -> UIViewController?> { return .name(Application.Binding.viewControllerWithRestorationPath) }
	static var willContinueUserActivity: ApplicationName<(_ application: UIApplication, String) -> Bool> { return .name(Application.Binding.willContinueUserActivity) }
	static var willEncodeRestorableState: ApplicationName<(_ application: UIApplication, NSKeyedArchiver) -> Void> { return .name(Application.Binding.willEncodeRestorableState) }
	static var willEnterForeground: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.willEnterForeground) }
	static var willFinishLaunching: ApplicationName<(_ application: UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool> { return .name(Application.Binding.willFinishLaunching) }
	static var willResignActive: ApplicationName<(UIApplication) -> Void> { return .name(Application.Binding.willResignActive) }
	static var willTerminate: ApplicationName<(_ application: UIApplication) -> Void> { return .name(Application.Binding.willTerminate) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
extension UIApplication: HasDelegate {}

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
