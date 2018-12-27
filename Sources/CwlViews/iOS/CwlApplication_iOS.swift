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

public func applicationMain(subclass: UIApplication.Type = UIApplication.self, application: @escaping () -> Application) -> Never {
	Application.Storage.storedConstruction = Application.Storage.storedBinderConstruction(application)
	
	_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(subclass), NSStringFromClass(Application.Storage.self))
	fatalError("UIApplicationMain completed unexpectedly")
}

public class Application: Binder {
	public typealias Inherited = BaseBinder
	public typealias Instance = UIApplication
	
	public var state: BinderState<Instance, BindingsOnlyParameters<Binding>>
	public required init(state: BinderState<Instance, BindingsOnlyParameters<Binding>>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}

	enum Binding: ApplicationBinding {
		public typealias EnclosingBinder = Application
		public static func applicationBinding(_ binding: Application.Binding) -> Application.Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case additionalWindows(Dynamic<[WindowConvertible]>)
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
		case didRegisterRemoteNotifications(SignalInput<Result<Data>>)
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
		case shouldRestoreApplicationState((_ coder: NSCoder) -> Bool)
		case shouldSaveApplicationState((_ coder: NSCoder) -> Bool)
		case viewControllerWithRestorationPath((_ path: [String], _ coder: NSCoder) -> UIViewController)
		case willContinueUserActivity((String) -> Bool)
		case willEncodeRestorableState((NSKeyedArchiver) -> Void)
		case willFinishLaunching(([UIApplication.LaunchOptionsKey: Any]?) -> Bool)
		case willTerminate(() -> Void)
	}

	struct Preparer: StoragePreparer {
		public typealias EnclosingBinder = Application
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage {
			return Storage.underConstruction!
		}
		
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
		
		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .didFinishLaunching(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)))
			case .willTerminate(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationWillTerminate(_:)))
			case .protectedDataWillBecomeUnavailable(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationProtectedDataWillBecomeUnavailable(_:)))
			case .protectedDataDidBecomeAvailable(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationProtectedDataDidBecomeAvailable(_:)))
			case .willEncodeRestorableState(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:willEncodeRestorableStateWith:)))
				
				// Automatically enable `shouldSaveApplicationState` if `willEncodeRestorableState` is isEnabled
				if delegate().shouldSaveApplicationState == nil {
					let shouldSave = #selector(UIApplicationDelegate.application(_:shouldSaveApplicationState:))
					delegate().addSelector(shouldSave).shouldSaveApplicationState = { _ in return true }
				}
			case .didDecodeRestorableState(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didDecodeRestorableStateWith:)))
				
				// Automatically enable `shouldRestoreApplicationState` if `didDecodeRestorableState` is isEnabled
				if delegate().shouldRestoreApplicationState == nil {
					let shouldRestore = #selector(UIApplicationDelegate.application(_:shouldRestoreApplicationState:))
					delegate().addSelector(shouldRestore).shouldRestoreApplicationState = { _ in return true }
				}
			case .performFetch(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:performFetchWithCompletionHandler:)))
			case .handleEventsForBackgroundURLSession(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:handleEventsForBackgroundURLSession:completionHandler:)))
			case .didRegisterRemoteNotifications(let x):
				let s1 = #selector(UIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:))
				let s2 = #selector(UIApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:))
				delegate().addSelector(s1).didRegisterRemoteNotifications = x
				delegate().addSelector(s2)
			case .didBecomeActive(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
			case .willResignActive(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationWillResignActive(_:)))
			case .didEnterBackground(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
			case .willEnterForeground(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
			case .didReceiveMemoryWarning(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationDidReceiveMemoryWarning(_:)))
			case .didReceiveRemoteNotification(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
			case .didFailToContinueUserActivity(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didFailToContinueUserActivityWithType:error:)))
			case .performAction(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:performActionFor:completionHandler:)))
			case .handleWatchKitExtensionRequest(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:handleWatchKitExtensionRequest:reply:)))
			case .shouldRequestHealthAuthorization(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.applicationShouldRequestHealthAuthorization(_:)))
			case .willContinueUserActivity(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:willContinueUserActivityWithType:)))
			case .continueUserActivity(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:continue:restorationHandler:)))
			case .didUpdate(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:didUpdate:)))
			case .shouldSaveApplicationState(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:shouldSaveApplicationState:)))
			case .shouldRestoreApplicationState(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:shouldRestoreApplicationState:)))
			case .viewControllerWithRestorationPath(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:viewControllerWithRestorationIdentifierPath:coder:)))
			case .open(let x):
				if #available(iOS 9.0, *) {
					let s = #selector(UIApplicationDelegate.application(_:open:options:))
					delegate().addSelector(s).open = x
				}
			case .shouldAllowExtensionPointIdentifier(let x): delegate().addHandler(x, #selector(UIApplicationDelegate.application(_:shouldAllowExtensionPointIdentifier:)))
			case .inheritedBinding(let s): inherited.prepareBinding(s)
			default: break
			}
		}
		
		public func prepareInstance(_ instance: Instance, storage: Storage) {
			// NOTE: delegate configuration occurs in Storage.constructStorageAndPrepareInstance due to inability to construct UIApplication using a normal constructor.

			linkedPreparer.prepareInstance(instance, storage: storage)
		}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .additionalWindows(let x):
				return x.apply(instance) { i, v in
					s.additionalWindows = v.map { $0.uiWindow() }
				}
			case .window(let x):
				return x.apply(instance) { i, v in
					s.window = v?.uiWindow()
				}
			case .ignoreInteractionEvents(let x):
				return x.apply(instance) { i, v in
					switch (i.isIgnoringInteractionEvents, v) {
					case (false, true): i.beginIgnoringInteractionEvents()
					case (true, false): i.endIgnoringInteractionEvents()
					default: break
					}
				}
			case .supportShakeToEdit(let x): return x.apply(instance) { i, v in i.applicationSupportsShakeToEdit = v }
			case .isIdleTimerDisabled(let x): return x.apply(instance) { i, v in i.isIdleTimerDisabled = v }
			case .shortcutItems(let x): return x.apply(instance) { i, v in i.shortcutItems = v }
			case .isNetworkActivityIndicatorVisible(let x): return x.apply(instance) { i, v in i.isNetworkActivityIndicatorVisible = v }
			case .iconBadgeNumber(let x): return x.apply(instance) { i, v in i.applicationIconBadgeNumber = v }
			case .registerForRemoteNotifications(let x):
				return x.apply(instance) { i, v in
					switch (i.isRegisteredForRemoteNotifications, v) {
					case (false, true): i.registerForRemoteNotifications()
					case (true, false): i.unregisterForRemoteNotifications()
					default: break
					}
				}
			case .didBecomeActive: return nil
			case .willResignActive: return nil
			case .didEnterBackground: return nil
			case .willEnterForeground: return nil
			case .didReceiveMemoryWarning: return nil
			case .significantTimeChange(let x):
				return Signal.notifications(n: UIApplication.significantTimeChangeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willFinishLaunching(let x):
				storage.willFinishLaunching = x
				return nil
			case .didFinishLaunching: return nil
			case .protectedDataWillBecomeUnavailable: return nil
			case .protectedDataDidBecomeAvailable: return nil
			case .performFetch: return nil
			case .handleEventsForBackgroundURLSession: return nil
			case .didRegisterRemoteNotifications: return nil
			case .didReceiveRemoteNotification: return nil
			case .didFailToContinueUserActivity: return nil
			case .performAction: return nil
			case .handleWatchKitExtensionRequest: return nil
			case .shouldRequestHealthAuthorization: return nil
				
			case .willContinueUserActivity: return nil
			case .continueUserActivity: return nil
			case .didUpdate: return nil
			case .willEncodeRestorableState: return nil
			case .didDecodeRestorableState: return nil
			case .willTerminate: return nil
			case .shouldSaveApplicationState: return nil
			case .shouldRestoreApplicationState: return nil
			case .viewControllerWithRestorationPath: return nil
			case .open: return nil
			case .shouldAllowExtensionPointIdentifier: return nil
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: ObjectBinderStorage, UIApplicationDelegate {
		fileprivate static var storedConstruction: (() -> Void)? = nil
		fileprivate static var underConstruction: Storage? = nil
		
		private static func constructStorageAndPrepareInstance(_ prep: Preparer, params: BindingsOnlyParameters<Binding>, i: Instance) -> Storage {
			let storage = prep.constructStorage()
			precondition(i.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = prep.possibleDelegate
			i.delegate = storage
			return storage
		}
		
		public static func storedBinderConstruction(_ construction: @escaping () -> Application) -> () -> Void {
			return { () -> Void in
				construction().binderApply(to: UIApplication.shared, additional: nil, storageConstructor: constructStorageAndPrepareInstance, combine: embedStorageIfInUse)
			}
		}
		
		public static func applyStoredBinderConstructionToGlobalDelegate(_ stored: (() -> Void)) {
			// Disconnect the delegate since we're about to change behavior
			let storage = UIApplication.shared.delegate as! Application.Storage
			underConstruction = storage
			UIApplication.shared.delegate = nil
			
			// Apply the styles to the application and delegate.
			stored()
			Storage.underConstruction = nil
			
			assert(UIApplication.shared.delegate === storage, "Failed to reconnect delegate")
		}
		
		open var window: UIWindow? = nil
		open var additionalWindows: [UIWindow] = []
		
		open var willFinishLaunching: (([UIApplication.LaunchOptionsKey: Any]?) -> Bool)?
		public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
			// Apply the bindings
			if let storedConstruction = Storage.storedConstruction {
				Storage.applyStoredBinderConstructionToGlobalDelegate(storedConstruction)
				Storage.storedConstruction = nil
			}
			
			// Apply the view hierarchy
			window?.makeKeyAndVisible()
			
			// Invoke any user-supplied code
			return willFinishLaunching?(launchOptions) ?? true
		}
		
		open override var inUse: Bool {
			return true
		}
	}

	open class Delegate: DynamicDelegate, UIApplicationDelegate {
		public required override init() {
			super.init()
		}

		open func applicationDidBecomeActive(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func applicationWillResignActive(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func applicationDidEnterBackground(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func applicationWillEnterForeground(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
			return handler(ofType: (([UIApplication.LaunchOptionsKey: Any]?) -> Bool).self)(launchOptions)
		}
		
		open func applicationWillTerminate(_ application: UIApplication) {
			return handler(ofType: (() -> Void).self)()
		}
		
		open func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
			return handler(ofType: ((NSKeyedArchiver) -> Void).self)(coder as! NSKeyedArchiver)
		}
		
		open func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
			return handler(ofType: ((NSKeyedUnarchiver) -> Void).self)(coder as! NSKeyedUnarchiver)
		}
		
		open var performFetch: SignalInput<SignalInput<UIBackgroundFetchResult>>?
		open func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
			let (input, _) = Signal<UIBackgroundFetchResult>.create { s in
				s.subscribeUntilEnd { r in
					switch r {
					case .success(let bfr): completionHandler(bfr)
					case .failure: completionHandler(UIBackgroundFetchResult.failed)
					}
				}
			}
			performFetch!.send(value: input)
		}
		
		open var handleEventsForBackgroundURLSession: SignalInput<Callback<String, ()>>?
		open func application(_ application: UIApplication, handleEventsForBackgroundURLSession session: String, completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			handleEventsForBackgroundURLSession!.send(value: Callback(session, input))
		}
		
		open var didRegisterUserNotifications: Any?
		@available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's UNNotificationSettings")
		open func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
			(didRegisterUserNotifications as! SignalInput<UIUserNotificationSettings>).send(value: notificationSettings)
		}
		
		open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
			handler(ofType: SignalInput<Result<Data>>.self).send(value: Result.success(deviceToken))
		}
		open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
			didRegisterRemoteNotifications!.send(value: Result.failure(error))
		}
		
		open var didReceiveLocalNotification: Any?
		@available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's UNNotificationSettings")
		open func application(_ application: UIApplication, didReceive: UILocalNotification) {
			(didReceiveLocalNotification as! SignalInput<UILocalNotification>).send(value: didReceive)
		}
		
		open var didReceiveRemoteNotification: SignalInput<Callback<[AnyHashable: Any], UIBackgroundFetchResult>>?
		open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
			let (input, _) = Signal<UIBackgroundFetchResult>.create { s in
				s.subscribeUntilEnd { r in
					switch r {
					case .success(let bfr): completionHandler(bfr)
					case .failure: completionHandler(UIBackgroundFetchResult.failed)
					}
				}
			}
			didReceiveRemoteNotification!.send(value: Callback(userInfo, input))
		}
		
		open var handleLocalNotificationAction: Any?
		@available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's UNNotificationSettings")
		open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for localNotification: UILocalNotification, completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			(handleLocalNotificationAction as! SignalInput<Callback<(String?, UILocalNotification), ()>>).send(value: Callback((identifier, localNotification), input))
		}
		
		open var handleRemoteNotificationAction: SignalInput<Callback<(String?, [AnyHashable: Any]), ()>>?
		open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			handleRemoteNotificationAction!.send(value: Callback((identifier, userInfo), input))
		}
		
		open var handleLocalNotificationResponseInfoAction: Any?
		@available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's UNNotificationSettings")
		open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for localNotification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			(handleLocalNotificationResponseInfoAction as! SignalInput<Callback<(String?, UILocalNotification, [AnyHashable : Any]), ()>>).send(value: Callback((identifier, localNotification, responseInfo), input))
		}
		
		open var handleRemoteNotificationResponseInfoAction: SignalInput<Callback<(String?, [AnyHashable: Any], [AnyHashable : Any]), ()>>?
		open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
			let (input, _) = Signal<Void>.create { s in s.subscribeWhile { r in completionHandler(); return false } }
			handleRemoteNotificationResponseInfoAction!.send(value: Callback((identifier, userInfo, responseInfo), input))
		}
		
		open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
			handler(ofType: SignalInput<(String, Error)>.self).send(value: (userActivityType, error))
		}
		
		open var handleWatchKitExtensionRequest: SignalInput<Callback<[AnyHashable: Any]?, [AnyHashable: Any]?>>?
		open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
			let (input, _) = Signal<[AnyHashable: Any]?>.create { s in s.subscribeWhile { r in reply(r.value ?? nil); return false } }
			handleWatchKitExtensionRequest!.send(value: Callback(userInfo, input))
		}
		
		open var shouldRequestHealthAuthorization: (() -> Void)?
		open func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
			shouldRequestHealthAuthorization!()
		}
		
		open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
			return handler(ofType: ((String) -> Bool).self)(userActivityType)
		}
		
		open var continueUserActivity: ((Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool)?
		open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
			let (input, _) = Signal<[UIUserActivityRestoring]?>.create { s in s.subscribeWhile { r in restorationHandler(r.value ?? nil); return false } }
			return continueUserActivity!(Callback(userActivity, input))
		}
		
		open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
			handler(ofType: ((NSUserActivity) -> Void).self)(userActivity)
		}
		
		open func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
			return handler(ofType: ((NSCoder) -> Bool).self)(coder)
		}
		
		open func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
			return handler(ofType: ((NSCoder) -> Bool).self)(coder)
		}
		
		open func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
			return handler(ofType: (([String], NSCoder) -> UIViewController?).self)(identifierComponents, coder)
		}
		
		open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
			return handler(ofType: ((URL, [UIApplication.OpenURLOptionsKey: Any]) -> Bool).self)(url, options)
		}
		
		open func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
			return handler(ofType: ((UIApplication.ExtensionPointIdentifier) -> Bool).self)(extensionPointIdentifier)
		}
		
		open var performAction: SignalInput<Callback<UIApplicationShortcutItem, Bool>>?
		open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
			let (input, _) = Signal<Bool>.create { s in s.subscribeWhile { r in completionHandler(r.value ?? false); return false } }
			performAction!.send(value: Callback(shortcutItem, input))
		}
	}
}

extension BindingName where Binding: ApplicationBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .applicationBinding(Application.Binding.$1(v)) }) }
	public static var ignoreInteractionEvents: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .applicationBinding(Application.Binding.ignoreInteractionEvents(v)) }) }
	public static var supportShakeToEdit: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .applicationBinding(Application.Binding.supportShakeToEdit(v)) }) }
	public static var isIdleTimerDisabled: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .applicationBinding(Application.Binding.isIdleTimerDisabled(v)) }) }
	public static var shortcutItems: BindingName<Dynamic<[UIApplicationShortcutItem]?>, Binding> { return BindingName<Dynamic<[UIApplicationShortcutItem]?>, Binding>({ v in .applicationBinding(Application.Binding.shortcutItems(v)) }) }
	public static var isNetworkActivityIndicatorVisible: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .applicationBinding(Application.Binding.isNetworkActivityIndicatorVisible(v)) }) }
	public static var iconBadgeNumber: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .applicationBinding(Application.Binding.iconBadgeNumber(v)) }) }
	public static var window: BindingName<Dynamic<WindowConvertible?>, Binding> { return BindingName<Dynamic<WindowConvertible?>, Binding>({ v in .applicationBinding(Application.Binding.window(v)) }) }
	public static var additionalWindows: BindingName<Dynamic<[WindowConvertible]>, Binding> { return BindingName<Dynamic<[WindowConvertible]>, Binding>({ v in .applicationBinding(Application.Binding.additionalWindows(v)) }) }
	public static var didBecomeActive: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didBecomeActive(v)) }) }
	public static var willResignActive: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willResignActive(v)) }) }
	public static var didEnterBackground: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didEnterBackground(v)) }) }
	public static var willEnterForeground: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.willEnterForeground(v)) }) }
	public static var protectedDataWillBecomeUnavailable: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.protectedDataWillBecomeUnavailable(v)) }) }
	public static var protectedDataDidBecomeAvailable: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.protectedDataDidBecomeAvailable(v)) }) }
	public static var didReceiveMemoryWarning: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.didReceiveMemoryWarning(v)) }) }
	public static var significantTimeChange: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .applicationBinding(Application.Binding.significantTimeChange(v)) }) }
	public static var performFetch: BindingName<SignalInput<SignalInput<UIBackgroundFetchResult>>, Binding> { return BindingName<SignalInput<SignalInput<UIBackgroundFetchResult>>, Binding>({ v in .applicationBinding(Application.Binding.performFetch(v)) }) }
	public static var handleEventsForBackgroundURLSession: BindingName<SignalInput<Callback<String, ()>>, Binding> { return BindingName<SignalInput<Callback<String, ()>>, Binding>({ v in .applicationBinding(Application.Binding.handleEventsForBackgroundURLSession(v)) }) }
	public static var registerForRemoteNotifications: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .applicationBinding(Application.Binding.registerForRemoteNotifications(v)) }) }
	public static var didRegisterRemoteNotifications: BindingName<SignalInput<Result<Data>>, Binding> { return BindingName<SignalInput<Result<Data>>, Binding>({ v in .applicationBinding(Application.Binding.didRegisterRemoteNotifications(v)) }) }
	public static var didReceiveRemoteNotification: BindingName<SignalInput<Callback<[AnyHashable: Any], UIBackgroundFetchResult>>, Binding> { return BindingName<SignalInput<Callback<[AnyHashable: Any], UIBackgroundFetchResult>>, Binding>({ v in .applicationBinding(Application.Binding.didReceiveRemoteNotification(v)) }) }
	public static var didFailToContinueUserActivity: BindingName<SignalInput<(String, Error)>, Binding> { return BindingName<SignalInput<(String, Error)>, Binding>({ v in .applicationBinding(Application.Binding.didFailToContinueUserActivity(v)) }) }
	public static var performAction: BindingName<SignalInput<Callback<UIApplicationShortcutItem, Bool>>, Binding> { return BindingName<SignalInput<Callback<UIApplicationShortcutItem, Bool>>, Binding>({ v in .applicationBinding(Application.Binding.performAction(v)) }) }
	public static var handleWatchKitExtensionRequest: BindingName<SignalInput<Callback<([AnyHashable: Any]?), [AnyHashable: Any]?>>, Binding> { return BindingName<SignalInput<Callback<([AnyHashable: Any]?), [AnyHashable: Any]?>>, Binding>({ v in .applicationBinding(Application.Binding.handleWatchKitExtensionRequest(v)) }) }
	public static var willContinueUserActivity: BindingName<(String) -> Bool, Binding> { return BindingName<(String) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.willContinueUserActivity(v)) }) }
	public static var continueUserActivity: BindingName<(Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool, Binding> { return BindingName<(Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.continueUserActivity(v)) }) }
	public static var didUpdate: BindingName<(NSUserActivity) -> Void, Binding> { return BindingName<(NSUserActivity) -> Void, Binding>({ v in .applicationBinding(Application.Binding.didUpdate(v)) }) }
	public static var willFinishLaunching: BindingName<([UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding> { return BindingName<([UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.willFinishLaunching(v)) }) }
	public static var didFinishLaunching: BindingName<([UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding> { return BindingName<([UIApplication.LaunchOptionsKey: Any]?) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.didFinishLaunching(v)) }) }
	public static var willEncodeRestorableState: BindingName<(NSKeyedArchiver) -> Void, Binding> { return BindingName<(NSKeyedArchiver) -> Void, Binding>({ v in .applicationBinding(Application.Binding.willEncodeRestorableState(v)) }) }
	public static var didDecodeRestorableState: BindingName<(NSKeyedUnarchiver) -> Void, Binding> { return BindingName<(NSKeyedUnarchiver) -> Void, Binding>({ v in .applicationBinding(Application.Binding.didDecodeRestorableState(v)) }) }
	public static var willTerminate: BindingName<() -> Void, Binding> { return BindingName<() -> Void, Binding>({ v in .applicationBinding(Application.Binding.willTerminate(v)) }) }
	public static var shouldSaveApplicationState: BindingName<(_ coder: NSCoder) -> Bool, Binding> { return BindingName<(_ coder: NSCoder) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.shouldSaveApplicationState(v)) }) }
	public static var shouldRestoreApplicationState: BindingName<(_ coder: NSCoder) -> Bool, Binding> { return BindingName<(_ coder: NSCoder) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.shouldRestoreApplicationState(v)) }) }
	public static var viewControllerWithRestorationPath: BindingName<(_ path: [String], _ coder: NSCoder) -> UIViewController, Binding> { return BindingName<(_ path: [String], _ coder: NSCoder) -> UIViewController, Binding>({ v in .applicationBinding(Application.Binding.viewControllerWithRestorationPath(v)) }) }
	public static var open: BindingName<(_ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool, Binding> { return BindingName<(_ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.open(v)) }) }
	public static var shouldAllowExtensionPointIdentifier: BindingName<(UIApplication.ExtensionPointIdentifier) -> Bool, Binding> { return BindingName<(UIApplication.ExtensionPointIdentifier) -> Bool, Binding>({ v in .applicationBinding(Application.Binding.shouldAllowExtensionPointIdentifier(v)) }) }
	public static var shouldRequestHealthAuthorization: BindingName<() -> Void, Binding> { return BindingName<() -> Void, Binding>({ v in .applicationBinding(Application.Binding.shouldRequestHealthAuthorization(v)) }) }
}

public protocol ApplicationBinding: BaseBinding {
	static func applicationBinding(_ binding: Application.Binding) -> Self
}
extension ApplicationBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return applicationBinding(.inheritedBinding(binding))
	}
}

#endif
