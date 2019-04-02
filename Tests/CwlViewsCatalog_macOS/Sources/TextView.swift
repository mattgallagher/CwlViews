//
//  TextView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews
import NaturalLanguage

struct TextViewState: CodableContainer {
	var text: Var<String>
	init() {
		text = Var("")
	}
}
