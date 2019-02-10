//
//  CwlVar.swift
//  CwlViews
//
//  Created by Matt Gallagher on 3/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

public typealias Var<Value: Codable> = Adapter<VarState<Value>>

public struct VarState<Value: Codable>: SingleValueAdapterState {
	public enum Message {
		case set(Value)
		case update(Value)
		case notify(Value)
	}
	public typealias DefaultMessage = Value
	public typealias Notification = Value
	
	public let value: Value
	public init(value: Value) {
		self.value = value
	}
	
	public static func message(from: Value) -> VarState<Value>.Message {
		return .set(from)
	}
	
	public func reduce(message: Message, feedback: SignalMultiInput<Message>) -> Output {
		switch message {
		case .set(let v): return Output(state: VarState<Value>(value: v), notification: v)
		case .update(let v): return Output(state: VarState<Value>(value: v), notification: nil)
		case .notify(let v): return Output(state: self, notification: v)
		}
	}
	
	public func resume() -> Notification? {
		return value
	}
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output? {
		switch message {
		case .set(let v): return Output(state: VarState<Value>(value: v), notification: v)
		case .update(let v): return Output(state: VarState<Value>(value: v), notification: nil)
		case .notify: return nil
		}
	}
}

extension VarState: Codable where Value: Codable {}

extension VarState: Lifetime where Value: Lifetime {
	public mutating func cancel() {
		var v = value
		v.cancel()
		self = VarState(value: v)
	}
}

extension VarState: CodableContainer where Value: CodableContainer {
	public var childCodableContainers: [CodableContainer] {
		return value.childCodableContainers
	}
	
	public var codableValueChanged: Signal<Void> {
		return value.codableValueChanged
	}
}

public extension Adapter {
	init<Value>(_ value: Value) where VarState<Value> == State {
		self.init(adapterState: VarState<Value>(value: value))
	}
}

public extension Adapter {
	func set<Value>() -> SignalInput<Value> where State.Message == VarState<Value>.Message {
		return Input().map { VarState<Value>.Message.set($0) }.bind(to: self)
	}
	
	func update<Value>() -> SignalInput<Value> where State.Message == VarState<Value>.Message {
		return Input().map { VarState<Value>.Message.update($0) }.bind(to: self)
	}
	
	func notify<Value>() -> SignalInput<Value> where State.Message == VarState<Value>.Message {
		return Input<Value>().map { VarState<Value>.Message.notify($0) }.bind(to: self)
	}
}

public extension SignalInterface {
	func bind<InputInterface>(to interface: InputInterface) where InputInterface: SignalInputInterface, InputInterface.InputValue == VarState<OutputValue>.Message {
		return map { VarState<OutputValue>.Message.set($0) }.bind(to: interface)
	}
}

public extension SignalChannel {
	func bind<Target>(to interface: Target) -> InputInterface where Target: SignalInputInterface, Target.InputValue == VarState<Interface.OutputValue>.Message {
		return final { $0.map { VarState<Interface.OutputValue>.Message.set($0) }.bind(to: interface) }.input
	}
}

public extension BindingName {
	/// Build an action binding (callbacks triggered by the instance) from a name and a signal input.
	///
	/// - Parameters:
	///   - name: the binding name
	///   - value: the binding argument
	/// - Returns: the binding
	static func --><A>(name: BindingName<Value, Source, Binding>, value: Adapter<VarState<A>>) -> Binding where SignalInput<A> == Value {
		return name.binding(with: value.set())
	}
}
