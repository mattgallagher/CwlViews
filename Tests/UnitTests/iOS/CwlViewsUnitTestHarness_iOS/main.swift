import CwlViews

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

applicationMain(type: TestApplication.self) {
	Application(
		.window -- Window(
			.rootViewController -- ViewController()
		)
	)
}
