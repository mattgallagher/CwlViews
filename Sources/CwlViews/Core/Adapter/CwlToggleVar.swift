//
//  CwlToggleVar.swift
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

public struct ToggleValue: PersistentAdapterState {
	public typealias Message = Void
	public typealias Notification = Bool
	
	public let value: Bool
	public init(value: Bool) {
		self.value = value
	}
	
	public func reduce(message: Void, feedback: SignalMultiInput<Message>) -> Output {
		return Output(state: ToggleValue(value: !value), notification: !value)
	}
	
	public func resume() -> Notification? { return value }
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output? {
		return nil
	}
}

public typealias ToggleVar = Adapter<ToggleValue>

public extension Adapter where State == ToggleValue {
	init(_ value: Bool) {
		self.init(adapterState: ToggleValue(value: value))
	}
}
