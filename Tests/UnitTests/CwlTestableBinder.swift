//
//  CwlTestableBinder.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 4/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
@testable import CwlViews

protocol TestableBinder: Binder {
	static var testInstance: Preparer.Instance.Type { get }
	static var parameters: Preparer.Parameters { get }
	static var shoudPerformReleaseCheck: Bool { get }
	static func constructor(binding: Preparer.Binding) -> Preparer.Instance
}

extension TestableBinder {
	static var testInstance: Preparer.Instance.Type { return Preparer.Instance.self }
	static var shoudPerformReleaseCheck: Bool { return true }
}

extension TestableBinder where Preparer.Parameters == Void {
	static var parameters: Preparer.Parameters { return () }
}

extension TestableBinder where Preparer: BinderConstructor, Preparer.Instance == Preparer.Output {
	static func constructor(binding: Preparer.Binding) -> Preparer.Instance {
		return Self.init(type: testInstance, parameters: parameters, bindings: [binding]).instance()
	}
}

extension TestableBinder where Preparer.Instance: NSObject {
	static func testValueBinding<InputValue, OutputValue: Equatable>(name: BindingName<Dynamic<InputValue>, Preparer.Binding, Preparer.Binding>, inputs: (InputValue, InputValue), outputs: (OutputValue, OutputValue, OutputValue), getter: (Preparer.Instance) -> OutputValue, file: StaticString = #file, line: UInt = #line) {
		weak var weakInstance: Preparer.Instance? = nil
		autoreleasepool {
			let (i, s) = Signal<InputValue>.create()
			let binding = name.binding(with: Dynamic.dynamic(s))
			
			let instance = Self.constructor(binding: binding)
			weakInstance = instance
			XCTAssertEqual(getter(instance), outputs.0, "initial condition failed", file: file, line: line)
			
			autoreleasepool {
				i.send(inputs.0)
				XCTAssertEqual(getter(instance), outputs.1, "first condition failed", file: file, line: line)
				
				i.send(inputs.1)
			}
			XCTAssertEqual(getter(instance), outputs.2, "second condition failed", file: file, line: line)
			
			if !Self.shoudPerformReleaseCheck {
				EmbeddedObjectStorage.setEmbeddedStorage(nil, for: instance)
			}
		}
		if Self.shoudPerformReleaseCheck {
			XCTAssertNil(weakInstance, "release check failed", file: file, line: line)
		}
	}
	
	static func testSignalBinding<InputValue, OutputValue: Equatable>(name: BindingName<Signal<InputValue>, Preparer.Binding, Preparer.Binding>, inputs: (InputValue, InputValue), outputs: (OutputValue, OutputValue, OutputValue), getter: (Preparer.Instance) -> OutputValue, file: StaticString = #file, line: UInt = #line) {
		weak var weakInstance: Preparer.Instance? = nil
		autoreleasepool {
			let (i, s) = Signal<InputValue>.create()
			let binding = name.binding(with: s)
			
			let instance = Self.constructor(binding: binding)
			weakInstance = instance
			XCTAssertEqual(getter(instance), outputs.0, "initial condition failed", file: file, line: line)
			
			autoreleasepool {
				i.send(inputs.0)
				XCTAssertEqual(getter(instance), outputs.1, "first condition failed", file: file, line: line)
				
				i.send(inputs.1)
			}
			XCTAssertEqual(getter(instance), outputs.2, "second condition failed", file: file, line: line)
			
			if !Self.shoudPerformReleaseCheck {
				EmbeddedObjectStorage.setEmbeddedStorage(nil, for: instance)
			}
		}
		if Self.shoudPerformReleaseCheck {
			XCTAssertNil(weakInstance, file: file, line: line)
		}
	}
	
	static func testActionBinding<Value>(name: BindingName<SignalInput<Value>, Preparer.Binding, Preparer.Binding>, trigger: (Preparer.Instance) -> (), validate: (Value) -> Bool, file: StaticString = #file, line: UInt = #line) where Preparer.Instance: NSObject {
		weak var weakInstance: Preparer.Instance? = nil
		
		var results = [Result<Value, SignalEnd>]()
		var subscriptionLifetime: Lifetime?
		autoreleasepool {
			let (i, s) = Signal<Value>.create()
			let binding = name.binding(with: i)
			
			subscriptionLifetime = s.subscribe { r in results.append(r) }
			
			let instance = Self.constructor(binding: binding)
			weakInstance = instance
			
			XCTAssert(results.isEmpty, "value received before trigger", file: file, line: line)
			trigger(instance)
			
			let first = results.first?.value
			XCTAssertNotNil(first, "trigger produced no results", file: file, line: line)
			XCTAssert(first.map { validate($0) } == true, "validation failed", file: file, line: line)
			
			if !Self.shoudPerformReleaseCheck {
				EmbeddedObjectStorage.setEmbeddedStorage(nil, for: instance)
			}
		}
		withExtendedLifetime(subscriptionLifetime) {}
		if Self.shoudPerformReleaseCheck {
			XCTAssert(results.last?.error == .cancelled, file: file, line: line)
			XCTAssertNil(weakInstance, file: file, line: line)
		}
	}
	
	static func testDelegateBinding<Value>(name: BindingName<Value, Preparer.Binding, Preparer.Binding>, handler: Value, trigger: (Preparer.Instance) -> (), validate: () -> Bool, file: StaticString = #file, line: UInt = #line) where Preparer.Instance: NSObject {
		weak var weakInstance: Preparer.Instance? = nil
		
		autoreleasepool {
			let binding = name.binding(with: handler)
			
			let instance = Self.constructor(binding: binding)
			weakInstance = instance
			
			trigger(instance)
			
			XCTAssert(validate(), "validation failed", file: file, line: line)
			
			if !Self.shoudPerformReleaseCheck {
				EmbeddedObjectStorage.setEmbeddedStorage(nil, for: instance)
			}
		}
		if Self.shoudPerformReleaseCheck {
			XCTAssertNil(weakInstance, file: file, line: line)
		}
	}
	
}

struct TestError: Error, Equatable {
	let value: String
	init(_ value: String) {
		self.value = value
	}
}
