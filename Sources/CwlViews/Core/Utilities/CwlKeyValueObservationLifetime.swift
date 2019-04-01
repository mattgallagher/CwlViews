//
//  CwlKeyValueObservationLifetime.swift
//  CwlViews
//
//  Created by Matt Gallagher on 25/3/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import Foundation

extension NSKeyValueObservation: Lifetime {
	public func cancel() {
		self.invalidate()
	}
}
