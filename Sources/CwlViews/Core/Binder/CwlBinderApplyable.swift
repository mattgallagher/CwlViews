//
//  CwlBinderApplyable.swift
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

/// Preparers usually default construct the `Storage` except in specific cases where the storage needs a reference to the instance.
public protocol BinderApplyable: BinderPreparer {
	/// Constructs the `Storage`
	///
	/// - Returns: the storage
	func constructStorage(instance: Instance) -> Storage
	
	/// - Returns: the output, after tying the lifetimes of the instance and storage together
	func combine(lifetimes: [Lifetime], instance: Instance, storage: Storage) -> Output
}

public extension BinderApplyable {
	static func bind(_ bindings: [Binding], to source: (_ preparer: Self) -> Instance) -> (Self, Instance, Storage, [Lifetime]) {
		var preparer = Self()
		for b in bindings {
			preparer.prepareBinding(b)
		}
		
		var lifetimes = [Lifetime]()
		let instance = source(preparer)
		let storage = preparer.constructStorage(instance: instance)
		
		preparer.prepareInstance(instance, storage: storage)
		
		for b in bindings {
			lifetimes += preparer.applyBinding(b, instance: instance, storage: storage)
		}
		
		lifetimes += preparer.finalizeInstance(instance, storage: storage)
		
		return (preparer, instance, storage, lifetimes)
	}
}

