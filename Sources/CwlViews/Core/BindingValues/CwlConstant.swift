//
//  CwlConstant.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

/// A simple wrapper around a value used to identify "static" bindings (bindings which are applied only at construction time)
public struct Constant<Value> {
	public typealias ValueType = Value
	public let value: Value
	public init(_ value: Value) {
		self.value = value
	}
	public static func constant(_ value: Value) -> Constant<Value> {
		return Constant<Value>(value)
	}
}

