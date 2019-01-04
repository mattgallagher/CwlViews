//
//  main.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 4/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

applicationMain() {
	Application(
		.window -- Window(
			.rootViewController -- ViewController(.view -- View(.backgroundColor -- .white))
		)
	)
}
