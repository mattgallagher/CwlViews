//
//  BindingTestHelpers.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 4/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
@testable import CwlViews

func test<InputValue, Binding, Instance: NSObject, OutputValue>(dynamicBinding: BindingName<Dynamic<InputValue>, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, initial: OutputValue, first: @autoclosure () -> (InputValue, OutputValue), second: (InputValue, OutputValue), getter: (Instance) -> OutputValue) where OutputValue: Equatable {
	weak var weakInstance: Instance? = nil
	autoreleasepool {
		let (i, s) = Signal<InputValue>.create()
		let binding = dynamicBinding.constructor(Dynamic.dynamic(s))
		
		let instance = constructor(binding)
		weakInstance = instance
		XCTAssertNotNil(weakInstance)
		XCTAssertEqual(getter(instance), initial)
		
		autoreleasepool {
			let (input, output) = first()
			i.send(input)
			XCTAssertEqual(getter(instance), output)
			
			i.send(second.0)
		}
		XCTAssertEqual(getter(instance), second.1)
	}
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance)
	}
}

func test<InputValue, Binding, Instance: NSObject, OutputValue>(signalBinding: BindingName<Signal<InputValue>, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, initial: OutputValue, first: @autoclosure () -> (InputValue, OutputValue), second: (InputValue, OutputValue), getter: (Instance) -> OutputValue) where OutputValue: Equatable {
	weak var weakInstance: Instance? = nil
	autoreleasepool {
		let (i, s) = Signal<InputValue>.create()
		let binding = signalBinding.constructor(s)
		
		let instance = constructor(binding)
		weakInstance = instance
		XCTAssertNotNil(weakInstance)
		XCTAssertEqual(getter(instance), initial)
		
		autoreleasepool {
			let (input, output) = first()
			i.send(input)
			XCTAssertEqual(getter(instance), output)
			
			i.send(second.0)
		}
		XCTAssertEqual(getter(instance), second.1)
	}
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance)
	}
}

func test<Value, Binding, Instance: NSObject>(actionBinding: BindingName<SignalInput<Value>, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, trigger: (Instance) -> (), validate: (Value) -> Bool) {
	weak var weakInstance: Instance? = nil
	
	var results = [Result<Value>]()
	var subscriptionLifetime: Lifetime?
	autoreleasepool {
		let (i, s) = Signal<Value>.create()
		let binding = actionBinding.constructor(i)
		
		subscriptionLifetime = s.subscribe { r in results.append(r) }
		
		let instance = constructor(binding)
		weakInstance = instance
		
		XCTAssert(results.isEmpty)
		trigger(instance)
		
		let first = results.first?.value
		XCTAssertNotNil(first)
		XCTAssert(first.map { validate($0) } == true)
		
		if skipReleaseCheck {
			instance.setBinderStorage(nil)
		}
	}
	withExtendedLifetime(subscriptionLifetime) {}
	XCTAssert(results.last?.error as? SignalComplete == .cancelled)
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance)
	}
}

func test<Value, Binding, Instance: NSObject>(delegateBinding: BindingName<Value, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, handler: Value, trigger: (Instance) -> (), validate: () -> Bool) {
	weak var weakInstance: Instance? = nil
	
	autoreleasepool {
		let binding = delegateBinding.constructor(handler)
		
		let instance = constructor(binding)
		weakInstance = instance
		
		trigger(instance)
		
		XCTAssert(validate())
	}
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance)
	}
}

struct TestError: Error {}
