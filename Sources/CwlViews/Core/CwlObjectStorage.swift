//
//  CwlBinderStorage.swift
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
open class ObjectBinderStorage: NSObject, BinderStorage {
	fileprivate var cancellables: [Cancellable]? = nil
	public func setCancellables(_ cancellables: [Cancellable]) {
		assert(self.cancellables == nil, "Bindings should be set once only")
		self.cancellables = cancellables
	}
	
	// An `ObjectBinderStorage` is an "internal" object but we don't need to keep it around if it isn't in-use. By default, that means: are we using the object for binding or delegation. Subclasses that store additional properties or implement delegate methods directly (without forwarding to the dynamic delegate) must override this with additional logic.
	open var inUse: Bool {
		return cancellables?.isEmpty == false || dynamicDelegate != nil
	}
	
	/// Explicitly invoke `cancel` on each of the bindings.
	///
	/// WARNING: if `cancel` is invoked outside the main thread, it will be *asynchronously* invoked on the main thread.
	/// Normally, a `cancel` effect is expected to have synchronous effect but it since `cancel` on EnclosingBinder objects is usually used for breaking reference counted loops, it is considered that the synchronous effect of cancel is less important than avoiding deadlocks – and deadlocks would be easy to accidentally trigger if this were synchronously invoked. If you need synchronous effect, ensure that cancel is invoked on the main thread.
	public func cancel() {
		if let cs = cancellables {
			if Thread.isMainThread {
				// `cancel` is mutating so we must use a `for var` (we can't use `forEach`)
				for var c in cs {
					c.cancel()
				}
			} else {
				DispatchQueue.main.async {
					// `cancel` is mutating so we must use a `for var` (we can't use `forEach`)
					for var c in cs {
						c.cancel()
					}
				}
			}
			cancellables?.removeAll()
		}
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
		if let dd = dynamicDelegate, dd.implementedSelectors.contains(selector) {
			return dd
		}
		return nil
	}
	
	/// An override of the NSObject method so that the dynamicDelegate can work.
	///
	/// - Parameter selector: Objective-C selector that may be implemented by the dynamicDelegate
	/// - Returns: true if the dynamicDelegate implements the selector, otherwise returns the super implementation
	open override func responds(to selector: Selector) -> Bool {
		if let dd = dynamicDelegate, dd.implementedSelectors.contains(selector) {
			return true
		}
		return super.responds(to: selector)
	}
}

/// Used in conjunction with `ObjectBinderStorage`, subclasses of `DynamicDelegate` can implement all delegate methods at compile time but have the `ObjectBinderStorage` report true to `responds(to:)` only in the cases where the delegate method is selected for enabling.
open class DynamicDelegate: NSObject {
	open var implementedSelectors = Set<Selector>()
	
	@discardableResult
	open func addSelector(_ selector: Selector) -> Self {
		implementedSelectors.insert(selector)
		return self
	}
}


/// Most objects managed by a `BinderStorage` are Objective-C objects (`NSView`/`UIView`, `NSApplication`/`UIApplication`, etc). For these objects, we can satisfy the requirement of tying the stateful and binder objects together by storing the binder in the Objective-C "associated object" storage.
private var associatedStorageKey = NSObject()
extension NSObject { 
	public func setBinderStorage(_ newValue: BinderStorage?) {
		objc_setAssociatedObject(self, &associatedStorageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
	}
	public func getBinderStorage<T: BinderStorage>(type: T.Type) -> T? {
		return objc_getAssociatedObject(self, &associatedStorageKey) as? T
	}
}

public func embedStorageIfInUse<Storage: BinderStorage>(_ instance: NSObject, _ storage: Storage, _ cancellables: [Cancellable]) {
	storage.setCancellables(cancellables)
	if storage.inUse {
		instance.setBinderStorage(storage)
	}
}
