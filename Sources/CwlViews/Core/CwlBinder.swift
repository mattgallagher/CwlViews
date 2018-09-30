//
//  CwlBinder.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/03/31.
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

/// This protocol is the minimum definition for a "binder". A binder takes a list of properties and behaviors (called bindings) and constructs an object with the properties and conforming to the behaviors.
public protocol Binder: BinderChain where Preparer: DerivedPreparer, Storage: BinderStorage, Inherited: BinderChain {
	associatedtype Parameters: BinderParameters where Parameters.Binding == Binding
	associatedtype Output
	var state: BinderState<Output, Parameters> { get set }
	
	static func bindingToInherited(_ binding: Binding) -> Inherited.Binding?
	func applyBindings(to instance: Instance)
	func consumeBindings() -> [Binding]
	init(state: BinderState<Output, Parameters>)
}

extension Binder where Parameters == BindingsOnlyParameters<Binding> {
	/// A constructor used when dynamically assembling arrays of bindings
	///
	/// - Parameters:
	///   - bindings: array of bindings
	public init(bindings: [Binding]) {
		self.init(state: .pending(BindingsOnlyParameters(bindings: bindings)))
	}

	/// A constructor for a binder.
	///
	/// - Parameters:
	///   - bindings: list of bindings
	public init(_ bindings: Binding...) {
		self.init(state: .pending(BindingsOnlyParameters(bindings: bindings)))
	}
}

extension Binder where Parameters == BinderSubclassParameters<Instance, Binding> {
	/// A constructor used when dynamically assembling arrays of bindings. Takes an optional subclass for the constructed instance.
	///
	/// - Parameters:
	///   - subclass: runtime subclass of the instance
	///   - bindings: array of bindings
	public init(subclass: Instance.Type = Instance.self, bindings: [Binding]) {
		let params = BinderSubclassParameters<Instance, Binding>(subclass: subclass, bindings: bindings)
		self.init(state: .pending(params))
	}
	
	/// The preferred constructor for binders. Takes an optional subclass for the constructed instance and a list of bindings as a variable argument list.
	///
	/// - Parameters:
	///   - subclass: runtime subclass of the instance
	///   - bindings: list of bindings
	public init(subclass: Instance.Type = Instance.self, _ bindings: Binding...) {
		let params = BinderSubclassParameters<Instance, Binding>(subclass: subclass, bindings: bindings)
		self.init(state: .pending(params))
	}
}

extension Binder {
	/// Invokes `consume` on the underlying state. If the state is not `pending`, this will trigger a fatal error. State will be set to `consumed`.
	///
	/// - Returns: the array of `Binding` from the state parameters.
	public func consumeBindings() -> [Binding] {
		return state.consume().bindings
	}

	/// A utility function that can be called from ConstructingBinder.instance or other functions to turn parameters from a BinderState into a Binder.Output using the Binder.Preparer. The default invocation in ConstructingBinder.instance is normally used unless special construction requirements are involved.
	///
	/// - Parameters:
	///   - additional: ad hoc bindings, applied after other bindings
	///   - storageConstructor: function to construct an empty BinderStorage, usually Preparer.constructStorage()
	///   - instanceConstructor: function to construct an unconfigured instance, usually Preparer.constructInstance(subclass:)
	///   - combine: function to link the instance, storage and generated Cancellables
	///   - output: chooses the instance or storage to return as the primary output
	/// - Returns: the output
	public func binderConstruct(
		additional: ((Instance) -> Cancellable?)?,
		storageConstructor: (Preparer, Parameters, Instance) -> Storage,
		instanceConstructor: (Preparer, Parameters) -> Instance,
		combine: (Instance, Storage, [Cancellable]) -> Void,
		output: (Instance, Storage) -> Output) -> Output {
		return state.construct { parameters in
			var preparer = Preparer.init()
			preparer.prepareBindings(parameters.bindings)
			let instance = instanceConstructor(preparer, parameters)
			let storage = storageConstructor(preparer, parameters, instance)
			preparer.applyBindings(parameters.bindings, instance: instance, storage: storage, additional: additional, combine: combine)
			return output(instance, storage)
		}
	}

	/// A utility function that can be called from Binder.applyBindings(to:) or other functions to turn parameters from a BinderState into a Binder.Output using the Binder.Preparer. The default implementation of Binder.applyBindings(to:) is normally used unless special construction requirements are involved.
	///
	/// - Parameters:
	///	- instance: the instance to which bindings should be applied
	///   - additional: ad hoc bindings, applied after other bindings
	///   - storageConstructor: function to construct an empty BinderStorage, usually Preparer.constructStorage()
	///   - combine: function to link the instance, storage and generated Cancellables
	/// - Returns: the output
	public func binderApply(to instance: Instance,
		additional: ((Instance) -> Cancellable?)?,
		storageConstructor: (Preparer, Parameters, Instance) -> Storage,
		combine: (Instance, Storage, [Cancellable]) -> Void) {
		state.apply(instance: instance) { inst, parameters in
			var preparer = Preparer.init()
			preparer.prepareBindings(parameters.bindings)
			let storage = storageConstructor(preparer, parameters, instance)
			preparer.applyBindings(parameters.bindings, instance: instance, storage: storage, additional: additional, combine: combine)
		}
	}
}

extension Binder where Preparer: StoragePreparer, Instance: NSObject, Output == Instance {
	/// A default implementation of `applyBindings` for the common case.
	///
	/// - Parameter instance: the instance to which bindings should be applied
	public func applyBindings(to instance: Instance) {
		binderApply(to: instance, additional: nil, storageConstructor: { prep, params, i in prep.constructStorage() }, combine: embedStorageIfInUse)
	}
}
