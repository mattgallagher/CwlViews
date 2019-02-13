//
//  CwlStackAdapter.swift
//  CwlViews_iOS
//
//  Created by Matt Gallagher on 2017/08/27.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

import Foundation

public typealias StackAdapter<PathElement: Codable> = Adapter<StackAdapterState<PathElement>>

/// This "Adapter" is a `ModelSignalValue` that manages a stack of navigation items as might be used by a UINavigationController. The adapter converts `push`, `popToCount` and `reload` messages into updates to the array of `PathElement`. The adapter includes convenient input signals, animated output signals and includes automatic implementation of coding and notification protocols.
public struct StackAdapterState<PathElement: Codable>: SingleValueAdapterState {
	public typealias Message = StackMutation<PathElement>
	public typealias Notification = StackMutation<PathElement>
	
	public let value: [PathElement]
	public init(value: [PathElement]) {
		self.value = value
	}
	
	public func reduce(message: Message, feedback: SignalMultiInput<Message>) -> Output {
		switch message {
		case .push(let e):
			let next = StackAdapterState<PathElement>(value: value.appending(e))
			return Output(state: next, notification: message)
		case .pop:
			let next = StackAdapterState<PathElement>(value: Array(value.dropLast()))
			return Output(state: next, notification: message)
		case .popToCount(let i):
			guard i >= 1 else { return Output(state: self, notification: nil) }
			let next = StackAdapterState<PathElement>(value: Array(value.prefix(i)))
			return Output(state: next, notification: message)
		case .reload(let newStack):
			let next = StackAdapterState<PathElement>(value: newStack)
			return Output(state: next, notification: message)
		}
	}
	
	public func resume() -> Notification? {
		return Message.reload(value)
	}
	
	public static func initialize(message: Message, feedback: SignalMultiInput<Message>) -> Output? {
		return StackAdapterState<PathElement>(value: []).reduce(message: message, feedback: feedback)
	}
}

extension StackAdapterState: Codable where PathElement: Codable {}

extension StackAdapterState: Lifetime where PathElement: Lifetime {
	public mutating func cancel() {
		for var l in value {
			l.cancel()
		}
		self = StackAdapterState(value: value.map { element in
			var e = element
			e.cancel()
			return e
		})
	}
}

extension StackAdapterState: CodableContainer where PathElement: CodableContainer {
	public var childCodableContainers: [CodableContainer] {
		return value.childCodableContainers
	}
	
	public var codableValueChanged: Signal<Void> {
		return value.codableValueChanged
	}
}

public extension Adapter {
	init<PathElement: Codable>( _ value: [PathElement]) where StackAdapterState<PathElement> == State {
		self.init(adapterState: StackAdapterState<PathElement>(value: value))
	}
}

extension Adapter {
	public func push<PathElement>() -> SignalInput<PathElement> where State.Message == StackMutation<PathElement> {
		return Signal<PathElement>.channel().map { State.Message.push($0) }.bind(to: input)
	}
	
	public func popToCount<PathElement>() -> SignalInput<Int> where State.Message == StackMutation<PathElement> {
		return Signal<Int>.channel().map { State.Message.popToCount($0) }.bind(to: input)
	}
}
