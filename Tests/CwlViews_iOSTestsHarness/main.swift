import UIKit

public class MockApplication: UIApplication {
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

public class MockApplicationDelegate: NSObject, UIApplicationDelegate {
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(MockApplication.self), NSStringFromClass(MockApplicationDelegate.self))
