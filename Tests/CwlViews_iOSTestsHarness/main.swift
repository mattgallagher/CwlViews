import UIKit

public class ApplicationSubclass: UIApplication {
	var mockRegisteredForRemoteNotifications: Bool = false
	public override var isRegisteredForRemoteNotifications: Bool {
		return mockRegisteredForRemoteNotifications
	}
	
	public override func registerForRemoteNotifications() {
		mockRegisteredForRemoteNotifications = true
	}

	public override func unregisterForRemoteNotifications() {
		mockRegisteredForRemoteNotifications = false
	}
}

public class ApplicationSubclassDelegate: NSObject, UIApplicationDelegate {
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(ApplicationSubclass.self), NSStringFromClass(ApplicationSubclassDelegate.self))
