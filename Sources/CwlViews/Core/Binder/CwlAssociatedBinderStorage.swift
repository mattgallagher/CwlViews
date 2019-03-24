//
//  CwlAssociatedBinderStorage.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/08/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

/// Implementation for `BinderStorage` that wraps Cocoa objects.
open class AssociatedBinderStorage: NSObject {
	public typealias Instance = NSObject
	private var lifetimes: [Lifetime]? = nil
	
	/// The embed function will avoid embedding and let the AssociatedBinderStorage release if this function returns false.
	/// Override and alter logic if a subclass may require the storage to persist when lifetimes is empty and the dynamic delegate is unused.
	open var isInUse: Bool {
		guard let ls = lifetimes else { fatalError("Embed must be called before isInUse") }
		return ls.isEmpty == false || dynamicDelegate != nil
	}
	
	/// Implementation of the `BinderStorage` method to embed supplied lifetimes in an instance. This may be performed once-only for a given instance and storage (the storage should have the same lifetime as the instance and should not be disconnected once connected).
	///
	/// - Parameters:
	///   - lifetimes: lifetimes that will be stored in this storage
	///   - instance: an NSObject where this storage will embed itself
	public func embed(lifetimes: [Lifetime], in instance: NSObjectProtocol) {
		assert(self.lifetimes == nil, "Bindings should be set once only")
		self.lifetimes = lifetimes
		guard isInUse else { return }
		
		assert(instance.associatedBinderStorage(subclass: AssociatedBinderStorage.self) == nil, "Bindings should be set once only")
		instance.setAssociatedBinderStorage(self)
	}
	
	/// Explicitly invoke `cancel` on each of the bindings.
	///
	/// WARNING: if `cancel` is invoked outside the main thread, it will be *asynchronously* invoked on the main thread.
	/// Normally, a `cancel` effect is expected to have synchronous effect but it since `cancel` on Binder objects is usually used for breaking reference counted loops, it is considered that the synchronous effect of cancel is less important than avoiding deadlocks – and deadlocks would be easy to accidentally trigger if this were synchronously invoked. If you need synchronous effect, ensure that cancel is invoked on the main thread.
	public func cancel() {
		guard Thread.isMainThread else { DispatchQueue.main.async(execute: self.cancel); return }
		
		// `cancel` is mutating so we must use a `for var` (we can't use `forEach`)
		for var l in lifetimes ?? [] {
			l.cancel()
		}
		
		dynamicDelegate?.implementedSelectors = [:]
		dynamicDelegate = nil
	}
	
	deinit {
		cancel()
	}
	
	/// The `dynamicDelegate` is a work-around for the fact that some Cocoa objects change their behavior if you have a delegate that implements a given delegate method. Since Binders will likely implement *all* of their delegate methods, the dynamicDelegate can be used to selectively respond to particular selectors at runtime.
	public var dynamicDelegate: DynamicDelegate?
	
	/// An override of the NSObject method so that the dynamicDelegate can work. When the dynamicDelegate states that it can respond to a given selector, that selector is directed to the dynamicDelegate instead. This function will only be involved if Objective-C message sends are sent to the BinderStorage – a rare occurrence outside of deliberate delegate invocations.
	///
	/// - Parameter selector: Objective-C selector that may be implemented by the dynamicDelegate
	/// - Returns: the dynamicDelegate, if it implements the selector
	open override func forwardingTarget(for selector: Selector) -> Any? {
		if let dd = dynamicDelegate, let value = dd.implementedSelectors[selector] {
			dd.associatedHandler = value
			return dd
		}
		return nil
	}
	
	/// An override of the NSObject method so that the dynamicDelegate can work.
	///
	/// - Parameter selector: Objective-C selector that may be implemented by the dynamicDelegate
	/// - Returns: true if the dynamicDelegate implements the selector, otherwise returns the super implementation
	open override func responds(to selector: Selector) -> Bool {
		if let dd = dynamicDelegate, let value = dd.implementedSelectors[selector] {
			dd.associatedHandler = value
			return true
		}
		return super.responds(to: selector)
	}
}

/// Used in conjunction with `AssociatedBinderStorage`, subclasses of `DynamicDelegate` can implement all delegate methods at compile time but have the `AssociatedBinderStorage` report true to `responds(to:)` only in the cases where the delegate method is selected for enabling.
open class DynamicDelegate: NSObject, DefaultConstructable {
	var implementedSelectors = Dictionary<Selector, Any>()
	var associatedHandler: Any?
	
	public required override init() {
		super.init()
	}
	
	public func handlesSelector(_ selector: Selector) -> Bool {
		return implementedSelectors[selector] != nil
	}
	
	public func multiHandler<T>(_ t: T) {
		defer { associatedHandler = nil }
		(associatedHandler as! [(T) -> Void]).forEach { f in f(t) }
	}
	
	public func multiHandler<T, U>(_ t: T, _ u: U) {
		defer { associatedHandler = nil }
		(associatedHandler as! [(T, U) -> Void]).forEach { f in f(t, u) }
	}
	
	public func multiHandler<T, U, V>(_ t: T, _ u: U, _ v: V) {
		defer { associatedHandler = nil }
		(associatedHandler as! [(T, U, V) -> Void]).forEach { f in f(t, u, v) }
	}
	
	public func multiHandler<T, U, V, W>(_ t: T, _ u: U, _ v: V, _ w: W) {
		defer { associatedHandler = nil }
		(associatedHandler as! [(T, U, V, W) -> Void]).forEach { f in f(t, u, v, w) }
	}
	
	public func multiHandler<T, U, V, W, X>(_ t: T, _ u: U, _ v: V, _ w: W, _ x: X) {
		defer { associatedHandler = nil }
		(associatedHandler as! [(T, U, V, W, X) -> Void]).forEach { f in f(t, u, v, w, x) }
	}
	
	public func singleHandler<T, R>(_ t: T) -> R {
		defer { associatedHandler = nil }
		return (associatedHandler as! ((T) -> R))(t)
	}
	
	public func singleHandler<T, U, R>(_ t: T, _ u: U) -> R {
		defer { associatedHandler = nil }
		return (associatedHandler as! ((T, U) -> R))(t, u)
	}
	
	public func singleHandler<T, U, V, R>(_ t: T, _ u: U, _ v: V) -> R {
		defer { associatedHandler = nil }
		return (associatedHandler as! ((T, U, V) -> R))(t, u, v)
	}
	
	public func singleHandler<T, U, V, W, R>(_ t: T, _ u: U, _ v: V, _ w: W) -> R {
		defer { associatedHandler = nil }
		return (associatedHandler as! ((T, U, V, W) -> R))(t, u, v, w)
	}
	
	public func singleHandler<T, U, V, W, X, R>(_ t: T, _ u: U, _ v: V, _ w: W, _ x: X) -> R {
		defer { associatedHandler = nil }
		return (associatedHandler as! ((T, U, V, W, X) -> R))(t, u, v, w, x)
	}
	
	public func addSingleHandler1<T, R>(_ value: @escaping (T) -> R, _ selector: Selector) {
		precondition(implementedSelectors[selector] == nil, "It is not possible to add multiple handlers to a delegate that returns a value.")
		implementedSelectors[selector] = value
	}
	
	public func addSingleHandler2<T, U, R>(_ value: @escaping (T, U) -> R, _ selector: Selector) {
		precondition(implementedSelectors[selector] == nil, "It is not possible to add multiple handlers to a delegate that returns a value.")
		implementedSelectors[selector] = value
	}
	
	public func addSingleHandler3<T, U, V, R>(_ value: @escaping (T, U, V) -> R, _ selector: Selector) {
		precondition(implementedSelectors[selector] == nil, "It is not possible to add multiple handlers to a delegate that returns a value.")
		implementedSelectors[selector] = value
	}
	
	public func addSingleHandler4<T, U, V, W, R>(_ value: @escaping (T, U, V, W) -> R, _ selector: Selector) {
		precondition(implementedSelectors[selector] == nil, "It is not possible to add multiple handlers to a delegate that returns a value.")
		implementedSelectors[selector] = value
	}
	
	public func addSingleHandler5<T, U, V, W, X, R>(_ value: @escaping (T, U, V, W, X) -> R, _ selector: Selector) {
		precondition(implementedSelectors[selector] == nil, "It is not possible to add multiple handlers to a delegate that returns a value.")
		implementedSelectors[selector] = value
	}
	
	public func addMultiHandler1<T>(_ value: @escaping (T) -> Void, _ selector: Selector) {
		if let existing = implementedSelectors[selector] {
			var existingArray = existing as! [(T) -> Void]
			existingArray.append(value)
		} else {
			implementedSelectors[selector] = [value] as [(T) -> Void]
		}
	}
	
	public func addMultiHandler2<T, U>(_ value: @escaping (T, U) -> Void, _ selector: Selector) {
		if let existing = implementedSelectors[selector] {
			var existingArray = existing as! [(T, U) -> Void]
			existingArray.append(value)
		} else {
			implementedSelectors[selector] = [value] as [(T, U) -> Void]
		}
	}
	
	public func addMultiHandler3<T, U, V>(_ value: @escaping (T, U, V) -> Void, _ selector: Selector) {
		if let existing = implementedSelectors[selector] {
			var existingArray = existing as! [(T, U, V) -> Void]
			existingArray.append(value)
		} else {
			implementedSelectors[selector] = [value] as [(T, U, V) -> Void]
		}
	}
	
	public func addMultiHandler4<T, U, V, W>(_ value: @escaping (T, U, V, W) -> Void, _ selector: Selector) {
		if let existing = implementedSelectors[selector] {
			var existingArray = existing as! [(T, U, V, W) -> Void]
			existingArray.append(value)
		} else {
			implementedSelectors[selector] = [value] as [(T, U, V, W) -> Void]
		}
	}
	
	public func addMultiHandler5<T, U, V, W, X>(_ value: @escaping (T, U, V, W, X) -> Void, _ selector: Selector) {
		if let existing = implementedSelectors[selector] {
			var existingArray = existing as! [(T, U, V, W, X) -> Void]
			existingArray.append(value)
		} else {
			implementedSelectors[selector] = [value] as [(T, U, V, W, X) -> Void]
		}
	}
}

private var associatedBinderStorageKey = NSObject()
public extension NSObjectProtocol {
	/// Accessor for any embedded AssociatedBinderStorage on an NSObject. This method is provided for debugging purposes; you should never normally need to access the storage obbject.
	///
	/// - Parameter for: an NSObject
	/// - Returns: the embedded AssociatedBinderStorage (if any)
	func associatedBinderStorage<S: AssociatedBinderStorage>(subclass: S.Type) -> S? {
		return objc_getAssociatedObject(self, &associatedBinderStorageKey) as? S
	}

	/// Accessor for any embedded AssociatedBinderStorage on an NSObject. This method is provided for debugging purposes; you should never normally need to access the storage obbject.
	///
	/// - Parameter newValue: an AssociatedBinderStorage or nil (if clearinging storage)
	func setAssociatedBinderStorage(_ newValue: AssociatedBinderStorage?) {
		objc_setAssociatedObject(self, &associatedBinderStorageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
	}
}
