//
//  CwlConstructingBinder.swift
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

/// A constructing binder can build the instance. As a simplification, this protocol requires that the `Output` and `Instance` types are the same (binders where this is not the case must be built on `Binder`).
public protocol ConstructingBinder: Binder where Output == Instance {
	/// Build the instance from the parameters in the binder state or return an already constructed instance. If state is `.consumed` this will trigger a fatal error.
	///
	/// - Parameter additional: ad hoc bindings (this is a chance to apply changes to the instance after construction and establish additional behaviors).
	/// - Returns: the constructed and configured instance (newly created if state was `.pending` or pre-existing if state was `.constructed`)
	func instance(additional: ((Instance) -> Cancellable?)?) -> Instance
}

extension ConstructingBinder where Parameters == BinderSubclassParameters<Instance, Binding>, Preparer: ConstructingPreparer, Instance: NSObject {
	/// Build the instance from the parameters in the binder state or return an already constructed instance. If state is `.consumed` this will trigger a fatal error.
	///
	/// - Parameter additional: ad hoc bindings (this is a chance to apply changes to the instance after construction and establish additional behaviors).
	/// - Returns: the constructed and configured instance (newly created if state was `.pending` or pre-existing if state was `.constructed`)
	public func instance(additional: ((Instance) -> Cancellable?)? = nil) -> Instance {
		return binderConstruct(
			additional: additional,
			storageConstructor: { prep, params, i in prep.constructStorage() },
			instanceConstructor: { prep, params in prep.constructInstance(subclass: params.subclass) },
			combine: embedStorageIfInUse,
			output: { i, s in i })
	}
}

