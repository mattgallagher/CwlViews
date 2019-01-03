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

/// This "StateAdapter" is a `ModelSignalValue` that manages a stack of navigation items as might be used by a UINavigationController. The adapter converts `push`, `popToCount` and `reload` messages into updates to the array of `PathElement`. The adapter includes convenient input signals, animated output signals and includes automatic implementation of coding and notification protocols.
public struct StackAdapterBehavior<PathElement: Codable>: StateAdapterBehavior {
	public typealias State = [PathElement]
	public typealias Message = StackMutation<PathElement>
	public typealias Notification = StackMutation<PathElement>
	public typealias PersistentState = State
	
	public static func reducer(state: inout State, message: Message) -> Notification? {
		switch message {
		case .push(let e):
			state.append(e)
			return message
		case .pop:
			_ = state.popLast()
			return message
		case .popToCount(let i):
			if i >= 1, i < state.count {
				state.removeLast(state.count - i)
				return message
			}
			return nil
		case .reload(let newStack):
			state = newStack
			return message
		}
	}
	
	public static func resume(state: State) -> Notification? {
		return .reload(state)
	}
	
	public static func initialize(message: Message) -> (State?, Notification?) {
		var state = [PathElement]()
		let n = reducer(state: &state, message: message)
		return (state, n)
	}
}

extension StateAdapter where RB.State: Collection, RB.Message == StackMutation<RB.State.Element> {
	public var pushInput: SignalInput<RB.State.Element> {
		return Signal<RB.State.Element>.channel().map { RB.Message.push($0) }.bind(to: input)
	}

	public var poppedToCount: SignalInput<Int> {
		return Signal<Int>.channel().map { RB.Message.popToCount($0) }.bind(to: input)
	}
}

public typealias StackAdapter<PathElement: Codable> = StateAdapter<StackAdapterBehavior<PathElement>>
