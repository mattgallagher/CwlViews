//
//  CwlTempVar.swift
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

public struct TempValue<Value>: NonPersistentAdapterState {
	public typealias Message = Value
	public typealias Notification = Value
	
	let temporaryValue: Value?
	public init() {
		temporaryValue = nil
	}
	
	fileprivate init(temporaryValue: Value) {
		self.temporaryValue = temporaryValue
	}
	
	public func reduce(message: Value, feedback: SignalMultiInput<Message>) -> Output {
		return Output(state: TempValue(temporaryValue: message), notification: message)
	}
	
	public func resume() -> Notification? {
		return temporaryValue
	}
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output? {
		return Output(state: TempValue(temporaryValue: message), notification: message)
	}
}

public typealias TempVar<Value> = Adapter<TempValue<Value>>

public extension Adapter {
	init<Value>(_ value: Value) where TempValue<Value> == State {
		self.init(adapterState: TempValue<Value>(temporaryValue: value))
	}
}
