//
//  CwlFilteredAdapter.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/24.
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

public struct ModelState {
	
}

/// Instead of offering a single "notification" output signal, like a plain `Adapter`, the `FilteredAdapter` is optimized around the idea of multiple filtered views of the output, with subtle questions like "whether to notify immediately upon connecting" handled by the filtered view, rather than a behavior baked into the adapter.
/// A single shared `State` is shared between the `reduce` and filter stages of the pipeline using a manual synchronization context to ensure this remains threadsafe. The `withMutableState` function offers synchronous, threadsafe access to the same storage for serialization and other concerns that might require immediate access.
/// However, there are also some omissions. Unlike `Adapter`, this *requires* an initial `State`. There is also no built-in support for `Codable`, since this `FilteredAdapter` would typically be used on data where serialization and persistence are manually handled.
public struct FilteredAdapter<Message, State, Notification>: Lifetime, SignalInputInterface {	
	public typealias InputValue = Message
	public typealias OutputValue = State
	public enum PossibleNotification {
		case never
		case suppress
		case value(Notification)
	}
	
	public let pair: SignalChannel<SignalMultiInput<Message>, SignalMulti<PossibleNotification>>
	public var input: SignalInput<Message> { return pair.input }
	
	private let context: DispatchQueueContext
	private let state: MutableBox<State>
	
	/// Construction where the `reduce` function includes a `loopback` parameter
	///
	/// - Parameters:
	///   - initialState: used to initialize the adapter state
	///   - sync: the adapter's execution context can be synchronous or asychronous but otherwise can't be directly specified (true, by default)
	///   - reduce: the reducing function which combines the internal `State` and `Message` on each iteration, emitting a `Notification?` (or throwing in the case of unrecoverable error or close state). A `loopback` parameter is provided which allows the reducing function to schedule asynchronous tasks that may call back into the adapter at a later time.
	public init(initialState: State, sync: Bool = true, reduce: @escaping (_ state: inout State, _ message: Message, _ loopback: SignalMultiInput<Message>) throws -> Notification?) {
		state = MutableBox<State>(initialState)
		context = DispatchQueueContext(sync: sync)
		let channel = Signal<Message>.multiChannel()
		let loopback = channel.input
		pair = channel.reduce(initialState: .never, context: .custom(context)) { [state, loopback] (cache: PossibleNotification, message: Message) throws -> PossibleNotification in
			let notification = try reduce(&state.value, message, loopback)
			if let n = notification {
				return .value(n)
			}
			return .suppress
		}
	}
	
	
	/// Construction where the `reduce` function omits the `loopback` parameter
	///
	/// - Parameters:
	///   - initialState: used to initialize the adapter state
	///   - sync: the adapter's execution context can be synchronous or asychronous but otherwise can't be directly specified (true, by default)
	///   - reduce: the reducing function which combines the internal `State` and `Message` on each iteration, emitting a `Notification?` (or throwing in the case of unrecoverable error or close state).
	public init(initialState: State, sync: Bool = true, reduce: @escaping (_ state: inout State, _ input: Message) throws -> Notification?) {
		self.init(initialState: initialState, sync: sync) { (state: inout State, input: Message, collector: SignalMultiInput<Message>) -> Notification? in
			return try reduce(&state, input)
		}
	}
	
	/// Cancels the signal graph (no further actions will be possible).
	public func cancel() {
		pair.input.cancel()
	}
	
	/// Filters the `PossibleNotification` output signal down to `Notification`, turning the initial `never` into a value using the provided `initial` function. When `PossibleNotification` is `suppress` (i.e. the last reduce invocation returned `nil`) no notification signal will be emitted.
	///
	/// - Returns: the notificationSignal
	public func notificationSignal(initial: @escaping (State) -> Notification? = { _ in nil }) -> Signal<Notification> {
		return pair.signal.compactMap { [state] (possibleNotification: PossibleNotification) in
			switch possibleNotification {
			case .never: return initial(state.value)
			case .suppress: return nil
			case .value(let n): return n
			}
		}
	}
	
	public var stateSignal: Signal<State> {
		return pair.signal.compactMap { [state] (possibleNotification: PossibleNotification) -> State? in
			if case .suppress = possibleNotification {
				return nil
			}
			return state.value
		}
	}
	
	/// This is the canonical output of the `FilteredAdapter`. On initial connection and each non-nil returning invocation of the adapter, the `processor` provided to this function is given a chance to produce and emit a slice of the `State` to its listeners.
	///
	/// - initialValue: a context value passed into the processor on each invocation
	/// - processor: the function that produces and emits the slice of `State`. The `State` is provided as an `UnsafePointer`, since Swift doesn't have another way to indicate read-only pass-by-reference. The `Notification?` parameter will be `nil` on initial invocation but will never be `nil` again after that point – this distinction allows construction of a specialized slice on initial connection. Output from the function is via the `SignalNext<Processed>` parameter, allowing zero, one or more value outputs or a close, if desired.
	/// - Returns: the signal output from the `processor`
	public func filteredSignal<Value, Processed>(initialValue: Value, _ processor: @escaping (inout Value, State, Notification?, SignalNext<Processed>) throws -> Void) -> Signal<Processed> {
		return pair.signal.transform(initialState: initialValue) { [state] (value: inout Value, incoming: Signal<PossibleNotification>.Result, next: SignalNext<Processed>) in
			do {
				switch incoming {
				case .success(.never): try processor(&value, state.value, nil, next)
				case .success(.suppress): break
				case .success(.value(let n)): try processor(&value, state.value, n, next)
				case .failure(let e): next.send(end: e)
				}
			} catch {
				next.send(error: error)
			}
		}
	}
	
	/// Same as `filteredSignal(initialValue:_:)` minus the context value
	///
	/// - processor: the function that produces and emits the slice of `State`. The `State` is provided as an `UnsafePointer`, since Swift doesn't have another way to indicate read-only pass-by-reference. The `Notification?` parameter will be `nil` on initial invocation but will never be `nil` again after that point – this distinction allows construction of a specialized slice on initial connection. Output from the function is via the `SignalNext<Processed>` parameter, allowing zero, one or more value outputs or a close, if desired.
	/// - Returns: the signal output from the `processor`
	public func filteredSignal<Processed>(_ processor: @escaping (State, Notification?, SignalNext<Processed>) throws -> Void) -> Signal<Processed> {
		return filteredSignal(initialValue: ()) { (value: inout (), state: State, notification: Notification?, next: SignalNext<Processed>) throws in
			try processor(state, notification, next)
		}
	}
	
	/// Allows out-of-stream access to the `State` (for synchronous actions like save). Since this function acquires the context where the signal closures run, do *not* call this from one of the `filterSignal` or `notificationSignal` processing closures as it will deadlock attempting re-entrant access to the context.
	public func withMutableState<Value>(_ perform: (inout State) throws -> Value) rethrows -> Value {
		return try context.queue.sync {
			try perform(&state.value)
		}
	}
}
