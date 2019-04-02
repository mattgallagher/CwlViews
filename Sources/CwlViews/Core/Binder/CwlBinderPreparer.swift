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

public protocol DefaultConstructable {
	init()
}

/// A preparer interprets a set of bindings and applies them to an instance.
public protocol BinderPreparer: DefaultConstructable {
	associatedtype Instance
	associatedtype Output = Instance
	associatedtype Parameters = Void
	associatedtype Binding
	associatedtype Storage
	associatedtype Inherited: BinderPreparer

	var inherited: Inherited { get set }
	
	func inheritedBinding(from: Binding) -> Inherited.Binding?
	
	/// A first scan of the bindings. Information about bindings present may be recorded during this time.
	///
	/// NOTE: you don't need to process all bindings at your own level but you should pass inherited bindings through
	/// to the inherited preparer (unless you're handling it at your own level)
	///
	/// - Parameter binding: the binding to apply
	mutating func prepareBinding(_ binding: Binding)
	
	/// Bindings which need to be applied before others can be applied at this special early stage
	///
	/// NOTE: the first step should be to call `inheritedPrepareInstance`. `BinderDelegate` should call `prepareDelegate`
	///
	/// - Parameters:
	///   - instance: the instance
	///   - storage: the storage
	func prepareInstance(_ instance: Instance, storage: Storage)
	
	/// Apply typical bindings.
	///
	/// NOTE: you should process all bindings and pass inherited bindings through to the inherited preparer
	///
	/// - Parameters:
	///   - binding: the binding to apply
	///   - instance: the instance
	///   - storage: the storage
	/// - Returns: If maintaining bindings requires ongoing lifetime management, these lifetimes are maintained by returning instances of `Lifetime`.
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime?
	
	/// Bindings which need to be applied after others can be applied at this last stage.
	///
	/// NOTE: the last step should be to call `inheritedFinalizedInstance`
	///
	/// - Parameters:
	///   - instance: the instance
	///   - storage: the storage
	/// - Returns: If maintaining bindings requires ongoing lifetime management, these lifetimes are maintained by returning instances of `Lifetime`
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime?
}

public extension BinderPreparer {
	mutating func inheritedPrepareBinding(_ binding: Binding) {
		guard let ls = inheritedBinding(from: binding) else { return }
		inherited.prepareBinding(ls)
	}

	mutating func prepareBinding(_ binding: Binding) {
		inheritedPrepareBinding(binding)
	}
	
	func inheritedPrepareInstance(_ instance: Instance, storage: Storage) {
		guard let i = instance as? Inherited.Instance, let s = storage as? Inherited.Storage else { return }
		inherited.prepareInstance(i, storage: s)
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)
	}
	
	func inheritedApplyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		guard let ls = inheritedBinding(from: binding), let i = instance as? Inherited.Instance, let s = storage as? Inherited.Storage else { return nil }
		return inherited.applyBinding(ls, instance: i, storage: s)
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		return inheritedApplyBinding(binding, instance: instance, storage: storage)
	}
	
	func inheritedFinalizedInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		guard let i = instance as? Inherited.Instance, let s = storage as? Inherited.Storage else { return nil }
		return inherited.finalizeInstance(i, storage: s)
	}
	
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		return inheritedFinalizedInstance(instance, storage: storage)
	}
}
