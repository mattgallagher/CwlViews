//
//  CwlAdapterState.swift
//  CwlViews
//
//  Created by Matt Gallagher on 13/1/19.
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

public protocol AdapterState {
	associatedtype Message
	associatedtype Notification
	
	typealias Output = (state: Self, notification: Notification?)
	
	static var defaultContext: (Exec, Bool) { get }

	static func initialize(message: Message, feedback: SignalMultiInput<Message>) throws -> Output?

	var instanceContext: (Exec, Bool) { get }

	func reduce(message: Message, feedback: SignalMultiInput<Message>) throws -> Output
	func resume() -> Notification?
}

public extension AdapterState {
	static var defaultContext: (Exec, Bool) {
		return (.direct, false)
	}
	
	var instanceContext: (Exec, Bool) {
		return Self.defaultContext
	}
	
	static func initialize(message: Message, feedback: SignalMultiInput<Message>) throws -> Output? {
		return nil
	}
	
	func resume() -> Notification? {
		return nil
	}
}

public protocol NonPersistentAdapterState: AdapterState, Codable {
	init()
}

public extension NonPersistentAdapterState {
	init(from decoder: Decoder) throws {
		self.init()
	}
	
	func encode(to encoder: Encoder) throws {
	}
}

public extension Adapter {
	init<Value>() where TempValue<Value> == State {
		self.init(adapterState: TempValue<Value>())
	}
}

public protocol SingleValueAdapterState: AdapterState, Codable {
	associatedtype PersistentValue: Codable
	init(value: PersistentValue)
	var value: PersistentValue { get }
}

extension Adapter where State: SingleValueAdapterState {
	public var state: Signal<State> {
		return combinedSignal.compactMap { content in content.state }
	}
}

public extension SingleValueAdapterState {
	init(from decoder: Decoder) throws {
		let c = try decoder.singleValueContainer()
		let p = try c.decode(PersistentValue.self)
		self.init(value: p)
	}
	
	func encode(to encoder: Encoder) throws {
		var c = encoder.singleValueContainer()
		try c.encode(value)
	}
}

extension Adapter where State: SingleValueAdapterState {
	public func logJson(prefix: String = "", formatting: JSONEncoder.OutputFormatting = .prettyPrinted) -> Lifetime {
		return codableValueChanged
			.startWith(())
			.subscribe { _ in
				let enc = JSONEncoder()
				enc.outputFormatting = formatting
				if let data = try? enc.encode(self), let string = String(data: data, encoding: .utf8) {
					print("\(prefix)\(string)")
				}
		}
	}
}
