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

public enum BinderState<Preparer: BinderPreparer> {
	case pending(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding])
	case constructed(Preparer.Output)
	case consumed
}

public protocol Binder: class {
	associatedtype Preparer: BinderPreparer
	
	var state: BinderState<Preparer> { get set }
	init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) 
}

public extension Binder {
 	typealias Instance = Preparer.Instance
	typealias Parameters = Preparer.Parameters
	typealias Output = Preparer.Output
	
	/// Invokes `consume` on the underlying state. If the state is not `pending`, this will trigger a fatal error. State will be set to `consumed`.
	///
	/// - Returns: the array of `Binding` from the state parameters.
	func consume() -> (type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		guard case .pending(let type, let parameters, let bindings) = state else {
			fatalError("Attempted to consume bindings from already constructed or consumed binder.")
		}
		state = .consumed
		return (type: type, parameters: parameters, bindings: bindings)
	}
}

extension Binder where Preparer.Parameters == Void {
	/// A constructor used when dynamically assembling arrays of bindings
	///
	/// - Parameters:
	///   - bindings: array of bindings
	public init(type: Preparer.Instance.Type = Preparer.Instance.self, bindings: [Preparer.Binding]) {
		self.init(type: type, parameters: (), bindings: bindings)
	}

	/// A constructor for a binder.
	///
	/// - Parameters:
	///   - bindings: list of bindings
	public init(type: Preparer.Instance.Type = Preparer.Instance.self, _ bindings: Preparer.Binding...) {
		self.init(type: type, parameters: (), bindings: bindings)
	}
}

private extension Binder where Preparer: BinderApplyable {
	var constructed: Preparer.Output? {
		guard case .constructed(let output) = state else { return nil }
		return output
	}
}

public extension Binder where Preparer: BinderApplyable {
	func apply(to instance: Preparer.Instance) {
		let (_, _, bindings) = consume()
		let (preparer, instance, storage, lifetimes) = Preparer.bind(bindings) { _ in instance }
		_ = preparer.combine(lifetimes: lifetimes, instance: instance, storage: storage)
	}
}

public extension Binder where Preparer: BinderConstructor, Preparer.Instance == Preparer.Output {
	func instance() -> Preparer.Instance {
		if let output = constructed { return output }
		let (type, parameters, bindings) = consume()
		let (preparer, instance, storage, lifetimes) = Preparer.bind(bindings) { preparer in
			preparer.constructInstance(type: type, parameters: parameters)
		}
		let output = preparer.combine(lifetimes: lifetimes, instance: instance, storage: storage)
		state = .constructed(instance)
		return output
	}

	func instance(parameters: Parameters) -> Preparer.Instance {
		if let output = constructed { return output }
		let (type, _, bindings) = consume()
		let (preparer, instance, storage, lifetimes) = Preparer.bind(bindings) { preparer in
			preparer.constructInstance(type: type, parameters: parameters)
		}
		let output = preparer.combine(lifetimes: lifetimes, instance: instance, storage: storage)
		state = .constructed(instance)
		return output
	}
}

public extension Binder where Preparer: BinderApplyable, Preparer.Storage == Preparer.Output {
	func wrap(instance: Preparer.Instance) -> Preparer.Output {
		if let output = constructed { return output }
		let (_, _, bindings) = consume()
		let (preparer, instance, storage, lifetimes) = Preparer.bind(bindings) { _ in instance }
		let output = preparer.combine(lifetimes: lifetimes, instance: instance, storage: storage)
		state = .consumed
		return output
	}
}

public extension Binder where Preparer: BinderConstructor, Preparer.Storage == Preparer.Output {
	func construct() -> Preparer.Output {
		let (type, parameters, bindings) = consume()
		let (preparer, instance, storage, lifetimes) = Preparer.bind(bindings) { preparer in
			preparer.constructInstance(type: type, parameters: parameters)
		}
		let output = preparer.combine(lifetimes: lifetimes, instance: instance, storage: storage)
		state = .constructed(output)
		return output
	}
	
	func construct(parameters: Parameters) -> Preparer.Output {
		let (type, _, bindings) = consume()
		let (preparer, instance, storage, lifetimes) = Preparer.bind(bindings) { preparer in
			preparer.constructInstance(type: type, parameters: parameters)
		}
		let output = preparer.combine(lifetimes: lifetimes, instance: instance, storage: storage)
		state = .constructed(output)
		return output
	}
}
