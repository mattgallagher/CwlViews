//
//  CwlBinderDelegate.swift
//  CwlViews
//
//  Created by Matt Gallagher on 16/12/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public protocol BinderDelegateEmbedder: BinderEmbedder where Instance: HasDelegate {
	associatedtype Delegate: DynamicDelegate
	init(delegateClass: Delegate.Type)
	var delegateClass: Delegate.Type { get }
	var possibleDelegate: Delegate? { get set }
}

public typealias BinderDelegateConstructor = BinderDelegateEmbedder & BinderConstructor

public protocol HasDelegate: class {
	associatedtype DelegateProtocol
	var delegate: DelegateProtocol? { get set }
}

public extension BinderDelegateEmbedder {
	public init() {
		self.init(delegateClass: Delegate.self)
	}
	
	mutating func delegate() -> Delegate {
		if let d = possibleDelegate {
			return d
		} else {
			let d = delegateClass.init()
			possibleDelegate = d
			return d
		}
	}
}

public extension BinderDelegateEmbedder where Delegate: DynamicDelegate {
	func prepareDelegate(instance: Instance, storage: Storage) {
		if possibleDelegate != nil {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			instance.delegate = (storage as! Instance.DelegateProtocol)
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		prepareDelegate(instance: instance, storage: storage)
		inheritedPrepareInstance(instance, storage: storage)
	}
}

public protocol BinderDelegateDerived: BinderEmbedderConstructor where Inherited: BinderDelegateConstructor {
	init(delegateClass: Inherited.Delegate.Type)
}

public extension BinderDelegateDerived {
	typealias Delegate = Inherited.Delegate
	init() {
		self.init(delegateClass: Inherited.Delegate.self)
	}
	var possibleDelegate: Inherited.Delegate? {
		get { return inherited.possibleDelegate }
		set { inherited.possibleDelegate = newValue }
	}
}
