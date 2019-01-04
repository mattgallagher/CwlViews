//
//  main.swift
//  CwlViews
//
//  Created by Matt Gallagher on 4/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

fileprivate let executableName = (Bundle.main.localizedInfoDictionary?[kCFBundleNameKey as String] as? String) ?? (Bundle.main.localizedInfoDictionary?[kCFBundleExecutableKey as String] as? String) ?? ProcessInfo.processInfo.processName

applicationMain(type: TestApplication.self) {
	Application(
		.mainMenu -- Menu(
			.title -- "Main Menu",
			.items -- [
				MenuItem(.submenu -- Menu(
					.systemName -- .apple,
					.title -- executableName,
					.items -- [
						MenuItem(
							.title -- String(format: NSLocalizedString("Quit %@", tableName: "MainMenu", comment: ""), executableName),
							.action --> #selector(NSApplication.terminate(_:)),
							.keyEquivalent -- "q"
						)
					]
				))
			]
		)
	)
}
