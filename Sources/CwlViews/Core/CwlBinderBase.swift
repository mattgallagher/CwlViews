//
//  CwlBinderBase.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/06/04.
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

/// On its own, `BinderChain` is a description of the connecting structure of `Binder`.
public protocol BinderChain: class {
	/// The purpose of a binder is to construct and configure an underlying `Instance`
	associatedtype Instance

	/// Instances are configured with a set of properties and behaviors over time. These are called "bindings"
	associatedtype Binding: BaseBinding where Binding.EnclosingBinder == Self

	/// Bindings are applied to the instance by a helper preparer type. This type exists only during applying of bindings.
	associatedtype Preparer: BinderPreparer where Preparer.EnclosingBinder == Self

	/// Binders inherit from each other with `BaseBinder` usually being the last link in the chain
	associatedtype Inherited

	/// To maintain the lifetime of behaviors over time, binders typically need somewhere to store resources
	associatedtype Storage
}

/// This protocol converts a derived binding to a base binding. This type of up-conversion is how bindings simulate inheritance.
public protocol BaseBinding {
	associatedtype EnclosingBinder
	static func baseBinding(_ binding: BaseBinder.Binding) -> Self
}

/// The primary purpose of the base binder is to terminate the BinderChain but it also includes the `cancelOnClose` binding which can be used for tying lifetimes to the lifetime of the binder's storage.
public class BaseBinder: BinderChain {
	public typealias Instance = Any
	public typealias Storage = Any
	public typealias Inherited = ()
	
	/// BaseBinder bindings implement a single `cancelOnClose` binding to tie the lifetime of arbitrary `Cancellable`s to the lifetime of the bound instance.
	public enum Binding: BaseBinding {
		public typealias EnclosingBinder = BaseBinder
		public static func baseBinding(_ binding: Binding) -> Binding { return binding }

		case cancelOnClose(Dynamic<[Cancellable]>)
	}

	/// BaseBinder preparer appends the `cancelOnClose` cancellables to the bound instance's cancellables.
	public struct Preparer: BinderPreparer {
		public typealias EnclosingBinder = BaseBinder

		public init() {}
		public var linkedPreparer: () {
			get { return () }
			set { }
		}
		public mutating func prepareBinding(_ binding: Binding) {}
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {}
		public mutating func finalizeInstance(_ instance: Instance, storage: Storage) -> Cancellable? { return nil }
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Cancellable? {
			switch binding {
			case .cancelOnClose(let x):
				switch x {
				case .constant(let array): return ArrayOfCancellables(array)
				case .dynamic(let signal): return signal.continuous().subscribe { r in }
				}
			}
		}
	}
}

extension BindingName where Binding: BaseBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .baseBinding(BaseBinder.Binding.$1(v)) }) }

	/// Each value in the cancelOnClose will be cancelled when the `Storage` is released. This is guaranteed to be invoked on the main thread (if `Storage` is released on a non-main thread, the effect will occur asynchronously on the main thread).
	public static var cancelOnClose: BindingName<Dynamic<[Cancellable]>, Binding> { return BindingName<Dynamic<[Cancellable]>, Binding>({ v in .baseBinding(BaseBinder.Binding.cancelOnClose(v)) }) }
}

/// All bound instances are required to have a binder storage for storing lifetime bound instances of type `Cancellable`. This is the standard representation of `Signal` and `SignalInput` implemented bindings.
public protocol BinderStorage: class, Cancellable {
	/// The `BinderStorage` needs to maintain the lifetime of all the self-managing objects, the most common of which are `Signal` and `SignalInput` instances but others may include `DispatchSourceTimer`. Most of these objects implement `Cancellable` so maintaining their lifetime is as simple as retaining these `Cancellable` instances in an array.
	/// The `bindings` array should be set precisely once, at the end of construction and an assertion may be raised if subsequent mutations are attempted.
	func setCancellables(_ cancellables: [Cancellable])
	
	/// Since the `BinderStorage` object is a supporting instance for the stateful object and exists to manage interactions but it is possible that the stateful object is constructed without the intention of mutation or interaction – in which case, the `BinderStorage` is not needed. The `inUse` getter is provided to ask if the `BinderStorage` is really necessary (a result of `true` may result in the `BinderStorage` being immediately discarded).
	var inUse: Bool { get }
}
