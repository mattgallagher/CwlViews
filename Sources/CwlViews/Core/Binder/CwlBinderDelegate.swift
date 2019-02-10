//
//  CwlBinderDelegate.swift
//  CwlViews
//
//  Created by Matt Gallagher on 16/12/18.
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

public protocol BinderDelegateEmbedder: BinderEmbedder where Instance: HasDelegate {
	associatedtype Delegate: DynamicDelegate
	init(delegateClass: Delegate.Type)
	var delegateClass: Delegate.Type { get }
	var dynamicDelegate: Delegate? { get set }
	var delegateIsRequired: Bool { get }
	func prepareDelegate(instance: Instance, storage: Storage)
}

public typealias BinderDelegateEmbedderConstructor = BinderDelegateEmbedder & BinderConstructor

public protocol HasDelegate: class {
	associatedtype DelegateProtocol
	var delegate: DelegateProtocol? { get set }
}

public extension BinderDelegateEmbedder {
	init() {
		self.init(delegateClass: Delegate.self)
	}
	
	var delegateIsRequired: Bool { return dynamicDelegate != nil }
	
	mutating func delegate() -> Delegate {
		if let d = dynamicDelegate {
			return d
		} else {
			let d = delegateClass.init()
			dynamicDelegate = d
			return d
		}
	}
}

public extension BinderDelegateEmbedder where Delegate: DynamicDelegate {
	func prepareDelegate(instance: Instance, storage: Storage) {
		if delegateIsRequired {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			if dynamicDelegate != nil {
				storage.dynamicDelegate = dynamicDelegate
			}
			instance.delegate = (storage as! Instance.DelegateProtocol)
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		prepareDelegate(instance: instance, storage: storage)
		inheritedPrepareInstance(instance, storage: storage)
	}
}

public protocol BinderDelegateDerived: BinderEmbedderConstructor where Inherited: BinderDelegateEmbedderConstructor {
	init(delegateClass: Inherited.Delegate.Type)
}

public extension BinderDelegateDerived {
	typealias Delegate = Inherited.Delegate
	init() {
		self.init(delegateClass: Inherited.Delegate.self)
	}
	var dynamicDelegate: Inherited.Delegate? {
		get { return inherited.dynamicDelegate }
		set { inherited.dynamicDelegate = newValue }
	}
}
