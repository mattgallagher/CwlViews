//
//  CwlBinderEmbedderConstructor.swift
//  CwlViews
//
//  Created by Matt Gallagher on 31/12/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

/// Preparers usually construct the `Instance` from a subclass type except in specific cases where additional non-binding parameters are required for instance construction.
public protocol BinderConstructor: BinderApplyable {
	/// Constructs the `Instance`
	///
	/// - Parameter subclass: subclass of the instance type to use for construction
	/// - Returns: the instance
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance
}

public extension BinderConstructor where Instance: DefaultConstructable {
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		return type.init()
	}
}

/// All NSObject instances can use EmbeddedObjectStorage which embeds lifetimes in the Objective-C associated object storage.
public protocol BinderEmbedder: BinderApplyable where Instance: NSObject, Storage: EmbeddedObjectStorage, Output == Instance {}
public extension BinderEmbedder {
	func combine(lifetimes: [Lifetime], instance: Instance, storage: Storage) -> Output {
		storage.embed(lifetimes: lifetimes, in: instance)
		return instance
	}
}

/// A `BinderEmbedderConstructor` is the standard configuration for a constructable NSObject.
public typealias BinderEmbedderConstructor = BinderEmbedder & BinderConstructor
