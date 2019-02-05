//
//  CwlAdapter.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/08/09.
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

public struct Adapter<State: AdapterState>: SignalInterface {
	public typealias OutputValue = State.Notification
	public typealias InputValue = State.DefaultMessage
	private enum Keys: CodingKey { case `var` }
	
	let executionContext: Exec

	public let multiInput: SignalMultiInput<State.Message>
	public var message: SignalInput<State.Message> { return multiInput }
	
	let combinedSignal: SignalMulti<State.Output>
	public var signal: Signal<State.Notification> {
		return combinedSignal.compactMapActivation(select: .last, context: executionContext, activation: { $0.state.resume() }, remainder: { $0.notification })
	}
	
	public init(adapterState: State? = nil) {
		let (i, s) = Signal<State.Message>.multiChannel().tuple
		multiInput = i
		
		if let state = adapterState {
			let (ec, async) = state.instanceContext
			executionContext = ec
			let sig = async ? s.scheduleAsync(relativeTo: executionContext) : s
			combinedSignal = sig.reduce(initialState: (state, nil), context: executionContext) { (content: State.Output, message: State.Message) throws -> State.Output in
				try content.state.reduce(message: message, feedback: i)
			}
		} else {
			let initializer = { (message: State.Message) throws -> State.Output? in
				try State.initialize(message: message, feedback: i)
			}
			let (ec, async) = State.defaultContext
			executionContext = ec
			let sig = async ? s.scheduleAsync(relativeTo: executionContext) : s
			combinedSignal = sig.reduce(context: executionContext, initializer: initializer) { (content: State.Output, message: State.Message) throws -> State.Output in
				try content.state.reduce(message: message, feedback: i)
			}
		}
	}
}
