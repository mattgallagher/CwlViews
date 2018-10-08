//
//  CwlBinderPreparer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/23.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

/// A preparer interprets a set of bindings and applies them to an instance.
public protocol BinderPreparer {
	associatedtype EnclosingBinder: BinderChain

	// A preparer must be default constructible (the bindings are the parameters)
	init()
	
	/// A first scan of the bindings. Information about bindings present may be recorded during this time.
	///
	/// - Parameter binding: the binding to apply
	mutating func prepareBinding(_ binding: EnclosingBinder.Binding)
	
	/// Bindings which need to be applied before others can be applied at this special early stage
	///
	/// - Parameters:
	///   - instance: the instance
	///   - storage: the storage
	mutating func prepareInstance(_ instance: EnclosingBinder.Instance, storage: EnclosingBinder.Storage)
	
	/// Apply typical bindings.
	///
	/// - Parameters:
	///   - binding: the binding to apply
	///   - instance: the instance
	///   - storage: the storage
	/// - Returns: If maintaining bindings requires ongoing lifetime management, these lifetimes are maintained by returning instances of `Lifetime`.
	func applyBinding(_ binding: EnclosingBinder.Binding, instance: EnclosingBinder.Instance, storage: EnclosingBinder.Storage) -> Lifetime?
	
	/// Bindings which need to be applied after others can be applied at this last stage.
	///
	/// - Parameters:
	///   - instance: the instance
	///   - storage: the storage
	/// - Returns: If maintaining bindings requires ongoing lifetime management, these lifetimes are maintained by returning instances of `Lifetime`
	mutating func finalizeInstance(_ instance: EnclosingBinder.Instance, storage: EnclosingBinder.Storage) -> Lifetime?
}

/// Preparers are normally linked together in a chain, mimicking the chain of Binders, so Bindings from the linked Binder can be applied to current instance.
public protocol DerivedPreparer: BinderPreparer where EnclosingBinder: Binder {
	/// Inherited bindings will be applied by the inherited preparer
	var linkedPreparer: EnclosingBinder.Inherited.Preparer { get set }
}

/// Preparers usually default construct the `Storage` except in specific cases where the storage needs a reference to the instance.
public protocol StoragePreparer: DerivedPreparer {
	/// Constructs the `Storage`
	///
	/// - Returns: the storage
	func constructStorage() -> EnclosingBinder.Storage
}

/// Preparers usually construct the `Instance` from a subclass type except in specific cases where additional non-binding parameters are required for instance construction.
public protocol ConstructingPreparer: StoragePreparer {
	/// Constructs the `Instance`
	///
	/// - Parameter subclass: subclass of the instance type to use for construction
	/// - Returns: the instance
	func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance
}

extension DerivedPreparer {
	/// Invokes `prepareBinding` once with each element of the `bindings`
	///
	/// - Parameter bindings: prepareBinding will be invoked with each element
	public mutating func prepareBindings( _ bindings: [EnclosingBinder.Binding]) {
		for b in bindings {
			prepareBinding(b)
		}
	}
	
	/// The default prepare workflow – in either `Binder.binderConstruct` or `Binder.binderApply` is, in order: `prepareBindings` (`constructInstance` for `Binder.binderConstruct`), `constructStorage` and then this function.
	///
	/// - Parameters:
	///   - bindings: from the binder parameters
	///   - instance: the constructed or apply instance
	///   - storage: the constructed storage
	///   - additional: any ad hoc bindings
	///   - combine: link the instance, storage and lifetimes together
	public mutating func applyBindings(_ bindings: [EnclosingBinder.Binding], instance: EnclosingBinder.Instance, storage: EnclosingBinder.Storage, additional: ((EnclosingBinder.Instance) -> Lifetime?)?, combine: (EnclosingBinder.Instance, EnclosingBinder.Storage, [Lifetime]) -> Void) {
		// Prepare.
		prepareInstance(instance, storage: storage)
		
		// Apply styles that need to be applied after construction
		var lifetimes = [Lifetime]()
		for b in bindings {
			if let c = applyBinding(b, instance: instance, storage: storage) {
				lifetimes.append(c)
			}
		}
		
		// Finalize the instance
		if let c = finalizeInstance(instance, storage: storage) {
			lifetimes.append(c)
		}
		
		// Append adhoc bindings, if any
		if let a = additional, let c = a(instance) {
			lifetimes.append(c)
		}
		
		// Combine the instance and binder
		combine(instance, storage, lifetimes)
	}

	/// A first scan of the bindings. Information about bindings present may be recorded during this time.
	///
	/// - Parameter binding: the binding to apply
	public mutating func prepareBinding(_ binding: EnclosingBinder.Binding) {
		if let ls = EnclosingBinder.bindingToInherited(binding) {
			linkedPreparer.prepareBinding(ls)
		}
	}
	
	/// Bindings which need to be applied before others can be applied at this special early stage
	///
	/// - Parameters:
	///   - instance: the instance
	///   - storage: the storage
	public mutating func prepareInstance(_ instance: EnclosingBinder.Instance, storage: EnclosingBinder.Storage) {
		if let i = instance as? EnclosingBinder.Inherited.Instance, let s = storage as? EnclosingBinder.Inherited.Storage {
			linkedPreparer.prepareInstance(i, storage: s)
		}
	}

	/// Apply typical bindings.
	///
	/// - Parameters:
	///   - binding: the binding to apply
	///   - instance: the instance
	///   - storage: the storage
	/// - Returns: If maintaining bindings requires ongoing lifetime management, these lifetimes are maintained by returning instances of `Lifetime`.
	public func applyBinding(_ binding: EnclosingBinder.Binding, instance: EnclosingBinder.Instance, storage: EnclosingBinder.Storage) -> Lifetime? {
		if let ls = EnclosingBinder.bindingToInherited(binding), let i = instance as? EnclosingBinder.Inherited.Instance, let s = storage as? EnclosingBinder.Inherited.Storage {
			return linkedPreparer.applyBinding(ls, instance: i, storage: s)
		}
		return nil
	}
	
	/// Bindings which need to be applied after others can be applied at this last stage.
	///
	/// - Parameters:
	///   - instance: the instance
	///   - storage: the storage
	/// - Returns: If maintaining bindings requires ongoing lifetime management, these lifetimes are maintained by returning instances of `Lifetime`
	public mutating func finalizeInstance(_ instance: EnclosingBinder.Instance, storage: EnclosingBinder.Storage) -> Lifetime? {
		if let i = instance as? EnclosingBinder.Inherited.Instance, let s = storage as? EnclosingBinder.Inherited.Storage {
			return linkedPreparer.finalizeInstance(i, storage: s)
		}
		return nil
	}
}
