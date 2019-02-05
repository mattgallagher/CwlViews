//
//  CwlBinderEmbedderConstructor.swift
//  CwlViews
//
//  Created by Matt Gallagher on 31/12/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any purpose with or without
//  fee is hereby granted, provided that the above copyright notice and this permission notice
//  appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
//  SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
//  AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
//  NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
//  OF THIS SOFTWARE.
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
