//
//  CwlObjectBinderStorage.swift
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
open class ObjectBinderStorage: NSObject {
	public typealias Instance = NSObject
	private var lifetimes: [Lifetime]? = nil
	
	private static var associatedStorageKey = NSObject()
	
	/// The embed function will avoid embedding and let the ObjectBinderStorage release if this function returns false.
	/// Override and alter logic if a subclass may require the storage to persist when lifetimes is empty and the dynamic delegate is unused.
	open var isInUse: Bool {
		guard let ls = lifetimes else { fatalError("Embed must be called before isInUse") }
		return ls.isEmpty == false || dynamicDelegate != nil
	}
	
	/// Accessor for any embedded ObjectBinderStorage on an NSObject. This method is provided for debugging purposes; you should never normally need to access the storage obbject.
	///
	/// - Parameter for: an NSObject
	/// - Returns: the embedded ObjectBinderStorage (if any)
	public static func embeddedStorage(for: NSObject) -> ObjectBinderStorage? {
		return objc_getAssociatedObject(self, &ObjectBinderStorage.associatedStorageKey) as? ObjectBinderStorage
	}
	
	/// Implementation of the `BinderStorage` method to embed supplied lifetimes in an instance. This may be performed once-only for a given instance and storage (the storage should have the same lifetime as the instance and should not be disconnected once connected).
	///
	/// - Parameters:
	///   - lifetimes: lifetimes that will be stored in this storage
	///   - instance: an NSObject where this storage will embed itself
	public func embed(lifetimes: [Lifetime], in instance: NSObject) {
		assert(self.lifetimes == nil, "Bindings should be set once only")
		self.lifetimes = lifetimes
		guard isInUse else { return }
		
		assert(ObjectBinderStorage.embeddedStorage(for: instance) == nil, "Bindings should be set once only")
		objc_setAssociatedObject(instance, &ObjectBinderStorage.associatedStorageKey, self, .OBJC_ASSOCIATION_RETAIN)
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
		if let dd = dynamicDelegate, dd.implementedSelectors[selector] != nil {
			return true
		}
		return super.responds(to: selector)
	}
}

/// Used in conjunction with `ObjectBinderStorage`, subclasses of `DynamicDelegate` can implement all delegate methods at compile time but have the `ObjectBinderStorage` report true to `responds(to:)` only in the cases where the delegate method is selected for enabling.
open class DynamicDelegate: NSObject, DefaultConstructable {
	var implementedSelectors = Dictionary<Selector, Any>()
	var associatedHandler: Any?
	
	public required override init() {
		super.init()
	}
	
	open func handler<Value>(ofType: Value.Type) -> Value {
		let v = associatedHandler as! Value
		associatedHandler = nil
		return v
	}
	
	open func addHandler(_ value: Any, _ selector: Selector) {
		implementedSelectors[selector] = value
	}
}


/// Most objects managed by a `BinderStorage` are Objective-C objects (`NSView`/`UIView`, `NSApplication`/`UIApplication`, etc). For these objects, we can satisfy the requirement of tying the stateful and binder objects together by storing the binder in the Objective-C "associated object" storage.
private var associatedStorageKey = NSObject()
extension NSObject { 
	public func setBinderStorage(_ newValue: Any?) {
		objc_setAssociatedObject(self, &associatedStorageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
	}
	public func getBinderStorage<T: ObjectBinderStorage>(type: T.Type) -> T? {
		return objc_getAssociatedObject(self, &associatedStorageKey) as? T
	}
}
