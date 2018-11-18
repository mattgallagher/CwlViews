//
//  CwlBindingTestHelpers.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 4/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
@testable import CwlViews

func testValueBinding<B: BaseBinding, InputValue, OutputValue: Equatable>(name: BindingName<Dynamic<InputValue>, B>, constructor: (B) -> B.EnclosingBinder.Instance, skipReleaseCheck: Bool = false, initial: OutputValue, first: @autoclosure () -> (InputValue, OutputValue), second: (InputValue, OutputValue), getter: (B.EnclosingBinder.Instance) -> OutputValue, file: StaticString = #file, line: UInt = #line) where B.EnclosingBinder: Binder, B.EnclosingBinder.Instance: NSObject {
	weak var weakInstance: B.EnclosingBinder.Instance? = nil
	autoreleasepool {
		let (i, s) = Signal<InputValue>.create()
		let binding = name.constructor(Dynamic.dynamic(s))
		
		let instance = constructor(binding)
		weakInstance = instance
		XCTAssertEqual(getter(instance), initial, "initial condition failed", file: file, line: line)
		
		autoreleasepool {
			let (input, output) = first()
			i.send(input)
			XCTAssertEqual(getter(instance), output, "first condition failed", file: file, line: line)
			
			i.send(second.0)
		}
		XCTAssertEqual(getter(instance), second.1, "second condition failed", file: file, line: line)
	}
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance, "release check failed", file: file, line: line)
	}
}

//func testValueBinding<B: BaseBinding, InputValue, OutputValue: Equatable>(name: BindingName<Dynamic<InputValue>, B>, constructor: (B) -> B.EnclosingBinder.Instance, skipReleaseCheck: Bool = false, initial: OutputValue, firstInput: @autoclosure () -> (InputValue), firstOutput: @autoclosure () -> (OutputValue), secondInput: InputValue, secondOutput: OutputValue, getter: (B.EnclosingBinder.Instance) -> OutputValue, file: StaticString = #file, line: UInt = #line) where B.EnclosingBinder: Binder, B.EnclosingBinder.Instance: NSObject {
//	weak var weakInstance: B.EnclosingBinder.Instance? = nil
//	autoreleasepool {
//		let (i, s) = Signal<InputValue>.create()
//		let binding = name.constructor(Dynamic.dynamic(s))
//		
//		let instance = constructor(binding)
//		weakInstance = instance
//		XCTAssertEqual(getter(instance), initial, "initial condition failed", file: file, line: line)
//		
//		autoreleasepool {
//			let input = firstInput()
//			let output = firstOutput()
//			i.send(input)
//			XCTAssertEqual(getter(instance), output, "first condition failed", file: file, line: line)
//			
//			i.send(secondInput)
//		}
//		XCTAssertEqual(getter(instance), secondOutput, "second condition failed", file: file, line: line)
//	}
//	if !skipReleaseCheck {
//		XCTAssertNil(weakInstance, "release check failed", file: file, line: line)
//	}
//}

func testSignalBinding<InputValue, Binding, Instance: NSObject, OutputValue>(name: BindingName<Signal<InputValue>, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, initial: OutputValue, first: @autoclosure () -> (InputValue, OutputValue), second: (InputValue, OutputValue), getter: (Instance) -> OutputValue, file: StaticString = #file, line: UInt = #line) where OutputValue: Equatable {
	weak var weakInstance: Instance? = nil
	autoreleasepool {
		let (i, s) = Signal<InputValue>.create()
		let binding = name.constructor(s)
		
		let instance = constructor(binding)
		weakInstance = instance
		XCTAssertEqual(getter(instance), initial, "initial condition failed", file: file, line: line)
		
		autoreleasepool {
			let (input, output) = first()
			i.send(input)
			XCTAssertEqual(getter(instance), output, "first condition failed", file: file, line: line)
			
			i.send(second.0)
		}
		XCTAssertEqual(getter(instance), second.1, "second condition failed", file: file, line: line)
	}
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance, file: file, line: line)
	}
}

func testSignalBinding<InputValue, Binding, Instance: NSObject, OutputValue>(name: BindingName<Signal<InputValue>, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, initial: OutputValue, firstInput: @autoclosure () -> (InputValue), firstOutput: @autoclosure () -> OutputValue, secondInput: InputValue, secondOutput: OutputValue, getter: (Instance) -> OutputValue, file: StaticString = #file, line: UInt = #line) where OutputValue: Equatable {
	weak var weakInstance: Instance? = nil
	autoreleasepool {
		let (i, s) = Signal<InputValue>.create()
		let binding = name.constructor(s)
		
		let instance = constructor(binding)
		weakInstance = instance
		XCTAssertEqual(getter(instance), initial, "initial condition failed", file: file, line: line)
		
		autoreleasepool {
			let input = firstInput()
			let output = firstOutput()
			i.send(input)
			XCTAssertEqual(getter(instance), output, "first condition failed", file: file, line: line)
			
			i.send(secondInput)
		}
		XCTAssertEqual(getter(instance), secondOutput, "second condition failed", file: file, line: line)
	}
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance, file: file, line: line)
	}
}

func testActionBinding<Value, Binding, Instance: NSObject>(name: BindingName<SignalInput<Value>, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, trigger: (Instance) -> (), validate: (Value) -> Bool, file: StaticString = #file, line: UInt = #line) {
	weak var weakInstance: Instance? = nil
	
	var results = [Result<Value>]()
	var subscriptionLifetime: Lifetime?
	autoreleasepool {
		let (i, s) = Signal<Value>.create()
		let binding = name.constructor(i)
		
		subscriptionLifetime = s.subscribe { r in results.append(r) }
		
		let instance = constructor(binding)
		weakInstance = instance
		
		XCTAssert(results.isEmpty, "value received before trigger", file: file, line: line)
		trigger(instance)
		
		let first = results.first?.value
		XCTAssertNotNil(first, "trigger produced no results", file: file, line: line)
		XCTAssert(first.map { validate($0) } == true, "validation failed", file: file, line: line)
		
		if skipReleaseCheck {
			instance.setBinderStorage(nil)
		}
	}
	withExtendedLifetime(subscriptionLifetime) {}
	XCTAssert(results.last?.error as? SignalComplete == .cancelled, file: file, line: line)
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance, file: file, line: line)
	}
}

func testDelegateBinding<Value, Binding, Instance: NSObject>(name: BindingName<Value, Binding>, constructor: (Binding) -> Instance, skipReleaseCheck: Bool = false, handler: Value, trigger: (Instance) -> (), validate: () -> Bool, file: StaticString = #file, line: UInt = #line) {
	weak var weakInstance: Instance? = nil
	
	autoreleasepool {
		let binding = name.constructor(handler)
		
		let instance = constructor(binding)
		weakInstance = instance
		
		trigger(instance)
		
		XCTAssert(validate(), "validation failed", file: file, line: line)
	}
	if !skipReleaseCheck {
		XCTAssertNil(weakInstance, file: file, line: line)
	}
}

struct TestError: Error, Equatable {
	let value: String
	init(_ value: String) {
		self.value = value
	}
}
