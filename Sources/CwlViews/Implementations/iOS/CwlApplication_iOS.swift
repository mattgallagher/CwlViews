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
		case didBecomeActive(SignalInput<Void>)
		case didEnterBackground(SignalInput<Void>)
		case didFailToContinueUserActivity(SignalInput<(String, Error)>)
		case didReceiveMemoryWarning(SignalInput<Void>)
		case didReceiveRemoteNotification(SignalInput<Callback<[AnyHashable: Any], UIBackgroundFetchResult>>)
		case didRegisterRemoteNotifications(SignalInput<Result<Data, Error>>)
		case handleEventsForBackgroundURLSession(SignalInput<Callback<String, ()>>)
		case handleWatchKitExtensionRequest(SignalInput<Callback<[AnyHashable: Any]?, [AnyHashable: Any]?>>)
		case performAction(SignalInput<Callback<UIApplicationShortcutItem, Bool>>)
		case performFetch(SignalInput<SignalInput<UIBackgroundFetchResult>>)
		case protectedDataDidBecomeAvailable(SignalInput<Void>)
		case protectedDataWillBecomeUnavailable(SignalInput<Void>)
		case significantTimeChange(SignalInput<Void>)
		case willEnterForeground(SignalInput<Void>)
		case willResignActive(SignalInput<Void>)

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case continueUserActivity((Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool)
		case didDecodeRestorableState((NSKeyedUnarchiver) -> Void)
		case didFinishLaunching(([UIApplication.LaunchOptionsKey: Any]?) -> Bool)
		case didUpdate((NSUserActivity) -> Void)
		case open((_ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool)
		case shouldAllowExtensionPointIdentifier((UIApplication.ExtensionPointIdentifier) -> Bool)
		case shouldRequestHealthAuthorization(() -> Void)
		case viewControllerWithRestorationPath((_ path: [String], _ coder: NSCoder) -> UIViewController?)
		case willContinueUserActivity((String) -> Bool)
		case willEncodeRestorableState((NSKeyedArchiver) -> Void)
		case willFinishLaunching(([UIApplication.LaunchOptionsKey: Any]?) -> Bool)
		case willTerminate(() -> Void)
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

		case .continueUserActivity(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:continue:restorationHandler:)))
		case .didBecomeActive(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
		case .didDecodeRestorableState(let x):
			delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didDecodeRestorableStateWith:)))
			delegate().ensureHandler(for: #selector(UIApplicationDelegate.application(_:shouldRestoreApplicationState:)))
		case .didEnterBackground(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
		case .didFailToContinueUserActivity(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didFailToContinueUserActivityWithType:error:)))
		case .didFinishLaunching(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)))
		case .didReceiveMemoryWarning(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationDidReceiveMemoryWarning(_:)))
		case .didReceiveRemoteNotification(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
		case .didRegisterRemoteNotifications(let x):
			delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)))
			delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:)))
		case .didUpdate(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didUpdate:)))
		case .handleEventsForBackgroundURLSession(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:handleEventsForBackgroundURLSession:completionHandler:)))
		case .handleWatchKitExtensionRequest(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:handleWatchKitExtensionRequest:reply:)))
		case .open(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:open:options:)))
		case .performAction(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:performActionFor:completionHandler:)))
		case .performFetch(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:performFetchWithCompletionHandler:)))
		case .protectedDataWillBecomeUnavailable(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationProtectedDataWillBecomeUnavailable(_:)))
		case .protectedDataDidBecomeAvailable(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationProtectedDataDidBecomeAvailable(_:)))
		case .shouldAllowExtensionPointIdentifier(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:shouldAllowExtensionPointIdentifier:)))
		case .shouldRequestHealthAuthorization(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationShouldRequestHealthAuthorization(_:)))
		case .viewControllerWithRestorationPath(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:viewControllerWithRestorationIdentifierPath:coder:)))
		case .willContinueUserActivity(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:willContinueUserActivityWithType:)))
		case .willEncodeRestorableState(let x):
			delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:willEncodeRestorableStateWith:)))
			delegate().ensureHandler(for: #selector(UIApplicationDelegate.application(_:shouldSaveApplicationState:)))
		case .willEnterForeground(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
		case .willResignActive(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationWillResignActive(_:)))
		case .willTerminate(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationWillTerminate(_:)))
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
		case .significantTimeChange(let x): return Signal.notifications(name: UIApplication.significantTimeChangeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willEnterForeground: return nil
		case .willResignActive: return nil

		//	4. Delegate bindings require synchronous evaluation within the object's context.
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
	open class Storage: EmbeddedObjectStorage, UIApplicationDelegate {
		static var storedApplicationConstructor: (() -> Application)? = nil
		static var storedStorage: Storage? = nil
		
		open override var isInUse: Bool {
			return true
		}
		
		open var window: UIWindow? = nil
		open var additionalWindows: [UIWindow] = []
		
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
		
		open var willFinishLaunching: (([UIApplication.LaunchOptionsKey: Any]?) -> Bool)?
		public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
			applyToSharedApplication()
			
			// Invoke any user-supplied code
			return willFinishLaunching?(launchOptions) ?? true
		}
	}

	open class Delegate: DynamicDelegate, UIApplicationDelegate {
		open func applicationDidBecomeActive(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func applicationWillResignActive(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func applicationDidEnterBackground(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func applicationWillEnterForeground(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
			return handler(ofType: (([UIApplication.LaunchOptionsKey: Any]?) -> Bool).self)!(launchOptions)
		}
		
		open func applicationWillTerminate(_ application: UIApplication) {
			return handler(ofType: (() -> Void).self)!()
		}
		
		open func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
			return handler(ofType: ((NSKeyedArchiver) -> Void).self)!(coder as! NSKeyedArchiver)
		}
		
		open func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
			return handler(ofType: ((NSKeyedUnarchiver) -> Void).self)!(coder as! NSKeyedUnarchiver)
		}
		
		open func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
			let (input, _) = Signal<UIBackgroundFetchResult>.create { s in
				s.subscribeUntilEnd { r in
					switch r {
					case .success(let bfr): completionHandler(bfr)
					case .failure: completionHandler(UIBackgroundFetchResult.failed)
					}
				}
			}
			handler(ofType: SignalInput<SignalInput<UIBackgroundFetchResult>>.self)!.send(value: input)
		}
		
		open func application(_ application: UIApplication, handleEventsForBackgroundURLSession session: String, completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			handler(ofType: SignalInput<Callback<String, ()>>.self)!.send(value: Callback(session, input))
		}
		
		open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
			handler(ofType: SignalInput<Result<Data, Error>>.self)!.send(value: Result.success(deviceToken))
		}
		
		open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
			handler(ofType: SignalInput<Result<Data, Error>>.self)!.send(value: Result.failure(error))
		}
		
		open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
			let (input, _) = Signal<UIBackgroundFetchResult>.create { s in
				s.subscribeUntilEnd { r in
					switch r {
					case .success(let bfr): completionHandler(bfr)
					case .failure: completionHandler(UIBackgroundFetchResult.failed)
					}
				}
			}
			handler(ofType: SignalInput<Callback<[AnyHashable: Any], UIBackgroundFetchResult>>.self)!.send(value: Callback(userInfo, input))
		}
		
		open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			handler(ofType: SignalInput<Callback<(String?, [AnyHashable: Any]), ()>>.self)!.send(value: Callback((identifier, userInfo), input))
		}
		
		open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			handler(ofType: SignalInput<Callback<(String?, [AnyHashable: Any], [AnyHashable : Any]), ()>>.self)!.send(value: Callback((identifier, userInfo, responseInfo), input))
		}
		
		open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
			handler(ofType: SignalInput<(String, Error)>.self)!.send(value: (userActivityType, error))
		}
		
		open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
			let (input, _) = Signal<[AnyHashable: Any]?>.create { s in s.subscribeWhile { r in reply(r.value ?? nil); return false } }
			handler(ofType: SignalInput<Callback<[AnyHashable: Any]?, [AnyHashable: Any]?>>.self)!.send(value: Callback(userInfo, input))
		}
		
		open func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
			handler(ofType: (() -> Void).self)!()
		}
		
		open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
			return handler(ofType: ((String) -> Bool).self)!(userActivityType)
		}
		
		open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
			let (input, _) = Signal<[UIUserActivityRestoring]?>.create { s in s.subscribeWhile { r in restorationHandler(r.value ?? nil); return false } }
			return handler(ofType: ((Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool).self)!(Callback(userActivity, input))
		}
		
		open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
			handler(ofType: ((NSUserActivity) -> Void).self)!(userActivity)
		}
		
		open func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
			// The existence of this selector on the dynamic delegate triggers an always true response
			return true
		}
		
		open func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
			// The existence of this selector on the dynamic delegate triggers an always true response
			return true
		}
		
		open func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
			return handler(ofType: (([String], NSCoder) -> UIViewController?).self)!(identifierComponents, coder)
		}
		
		open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
			return handler(ofType: ((URL, [UIApplication.OpenURLOptionsKey: Any]) -> Bool).self)!(url, options)
		}
		
		open func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
			return handler(ofType: ((UIApplication.ExtensionPointIdentifier) -> Bool).self)!(extensionPointIdentifier)
		}
		
		open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
			let (input, _) = Signal<Bool>.create { s in s.subscribeWhile { r in completionHandler(r.value ?? false); return false } }
			handler(ofType: SignalInput<Callback<UIApplicationShortcutItem, Bool>>.self)!.send(value: Callback(shortcutItem, input))
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
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var iconBadgeNumber: ApplicationName<Dynamic<Int>> { return .name(B.iconBadgeNumber) }
	static var isIdleTimerDisabled: ApplicationName<Dynamic<Bool>> { return .name(B.isIdleTimerDisabled) }
	static var isNetworkActivityIndicatorVisible: ApplicationName<Dynamic<Bool>> { return .name(B.isNetworkActivityIndicatorVisible) }
	static var shortcutItems: ApplicationName<Dynamic<[UIApplicationShortcutItem]?>> { return .name(B.shortcutItems) }
	static var supportShakeToEdit: ApplicationName<Dynamic<Bool>> { return .name(B.supportShakeToEdit) }
	static var window: ApplicationName<Dynamic<WindowConvertible?>> { return .name(B.window) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var ignoreInteractionEvents: ApplicationName<Signal<Bool>> { return .name(B.ignoreInteractionEvents) }
	static var registerForRemoteNotifications: ApplicationName<Signal<Bool>> { return .name(B.registerForRemoteNotifications) }
	
	//	3. Action bindings are triggered by the object after construction.
	static var didBecomeActive: ApplicationName<SignalInput<Void>> { return .name(B.didBecomeActive) }
	static var didEnterBackground: ApplicationName<SignalInput<Void>> { return .name(B.didEnterBackground) }
	static var didFailToContinueUserActivity: ApplicationName<SignalInput<(String, Error)>> { return .name(B.didFailToContinueUserActivity) }
	static var didReceiveMemoryWarning: ApplicationName<SignalInput<Void>> { return .name(B.didReceiveMemoryWarning) }
	static var didReceiveRemoteNotification: ApplicationName<SignalInput<Callback<[AnyHashable: Any], UIBackgroundFetchResult>>> { return .name(B.didReceiveRemoteNotification) }
	static var didRegisterRemoteNotifications: ApplicationName<SignalInput<Result<Data, Error>>> { return .name(B.didRegisterRemoteNotifications) }
	static var handleEventsForBackgroundURLSession: ApplicationName<SignalInput<Callback<String, ()>>> { return .name(B.handleEventsForBackgroundURLSession) }
	static var handleWatchKitExtensionRequest: ApplicationName<SignalInput<Callback<[AnyHashable: Any]?, [AnyHashable: Any]?>>> { return .name(B.handleWatchKitExtensionRequest) }
	static var performAction: ApplicationName<SignalInput<Callback<UIApplicationShortcutItem, Bool>>> { return .name(B.performAction) }
	static var performFetch: ApplicationName<SignalInput<SignalInput<UIBackgroundFetchResult>>> { return .name(B.performFetch) }
	static var protectedDataDidBecomeAvailable: ApplicationName<SignalInput<Void>> { return .name(B.protectedDataDidBecomeAvailable) }
	static var protectedDataWillBecomeUnavailable: ApplicationName<SignalInput<Void>> { return .name(B.protectedDataWillBecomeUnavailable) }
	static var significantTimeChange: ApplicationName<SignalInput<Void>> { return .name(B.significantTimeChange) }
	static var willEnterForeground: ApplicationName<SignalInput<Void>> { return .name(B.willEnterForeground) }
	static var willResignActive: ApplicationName<SignalInput<Void>> { return .name(B.willResignActive) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var continueUserActivity: ApplicationName<(Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool> { return .name(B.continueUserActivity) }
	static var didDecodeRestorableState: ApplicationName<(NSKeyedUnarchiver) -> Void> { return .name(B.didDecodeRestorableState) }
	static var didFinishLaunching: ApplicationName<([UIApplication.LaunchOptionsKey: Any]?) -> Bool> { return .name(B.didFinishLaunching) }
	static var didUpdate: ApplicationName<(NSUserActivity) -> Void> { return .name(B.didUpdate) }
	static var open: ApplicationName<(_ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool> { return .name(B.open) }
	static var shouldAllowExtensionPointIdentifier: ApplicationName<(UIApplication.ExtensionPointIdentifier) -> Bool> { return .name(B.shouldAllowExtensionPointIdentifier) }
	static var shouldRequestHealthAuthorization: ApplicationName<() -> Void> { return .name(B.shouldRequestHealthAuthorization) }
	static var viewControllerWithRestorationPath: ApplicationName<(_ path: [String], _ coder: NSCoder) -> UIViewController> { return .name(B.viewControllerWithRestorationPath) }
	static var willContinueUserActivity: ApplicationName<(String) -> Bool> { return .name(B.willContinueUserActivity) }
	static var willEncodeRestorableState: ApplicationName<(NSKeyedArchiver) -> Void> { return .name(B.willEncodeRestorableState) }
	static var willFinishLaunching: ApplicationName<([UIApplication.LaunchOptionsKey: Any]?) -> Bool> { return .name(B.willFinishLaunching) }
	static var willTerminate: ApplicationName<() -> Void> { return .name(B.willTerminate) }
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
	public typealias Preparer = Application.Preparer
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
