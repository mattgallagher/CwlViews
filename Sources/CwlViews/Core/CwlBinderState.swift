//
//  CwlBinderState.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/04/01.
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

/// A binder exists in one of three states, a pre-constructed state, a constructed state (with the constructed output cached) and a consumed state (bindings applied to another instance or removed for testing purposes).
///
/// - constructed: the output object was constructed and remains cached as long as the state is retained
/// - pending: the set of parameters for construction 
/// - consumed: this object is no longer valid
public enum BinderState<Output, Parameters> {
	case constructed(Output)
	case pending(Parameters)
	case consumed
	
	/// If the state is not `pending`, this will trigger a fatal error. State will be set to `consumed`.
	///
	/// - Returns: the parameters of the `pending` state. State will be set to `consumed`.
	public mutating func consume() -> Parameters {
		switch self {
		case .pending(let p): return p
		default: fatalError("Attempt to consume already consumed bindings")
		}
	}
	
	/// If the state is `consumed`, this will trigger a fatal error. If the state is `constructed`, this will return the already constructed output. Otherwise, the `generate` closure will be run to get a new `Output` and the state will be set to `constructed`.
	///
	/// - Parameters:
	///   - generate: a function that can create an `Output` with properties and behaviors from `Parameters`.
	/// - Returns: the parameters of the `pending` state
	public mutating func construct(generate: (Parameters) -> Output) -> Output {
		switch self {
		case .constructed(let i): return i
		case .pending(let p):
			self = .consumed
			let instance = generate(p)
			self = .constructed(instance)
			return instance
		default: fatalError("Attempt to apply already consumed bindings")
		}
	}

	/// If the state is not `pending`, this will trigger a fatal error. State will be set to `consumed`.
	///
	/// NOTE: this function is generic over `Instance`. The `Instance` and `Output` types are usually but not necessarily the same (e.g. when you're configuring an internal instance but you hold the instance using a separate output wrapper).
	///
	/// - Parameters:
	///   - instance: an existing `Instance` that will receive properties and behaviors from the `Parameters`
	///   - handle: a function that can configure `Instance` with properties and behaviors from `Parameters`.
	public mutating func apply<Instance>(instance: Instance, handle: (Instance, Parameters) -> Void) {
		switch self {
		case .pending(let p):
			self = .consumed
			handle(instance, p)
		default: fatalError("Attempt to apply already consumed bindings")
		}
	}
}

/// The standard parameters for constructing a subclass
public typealias ConstructingBinderState<Instance, Binding> = BinderState<Instance, BinderSubclassParameters<Instance, Binding>>
