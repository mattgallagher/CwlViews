import UIKit

public class TestApplication: UIApplication {
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

public class TestApplicationDelegate: NSObject, UIApplicationDelegate {
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(TestApplication.self), NSStringFromClass(TestApplicationDelegate.self))
