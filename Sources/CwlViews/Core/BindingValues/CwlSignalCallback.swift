//
//  CwlSignalUtilities.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/04/29.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

public struct Callback<Value, CallbackValue> {
	public let value: Value
	public let callback: SignalInput<CallbackValue>
	
	public init(_ value: Value, _ callback: SignalInput<CallbackValue>) {
		self.value = value
		self.callback = callback
	}
}

extension SignalInterface {
	public func callbackBind<CallbackInputInterface: SignalInputInterface>(to callback: CallbackInputInterface) -> Signal<Callback<OutputValue, CallbackInputInterface.InputValue>> {
		return map { value in Callback(value, callback.input) }
	}

	public func ignoreCallback<CallbackValue>() -> Signal<Callback<OutputValue, CallbackValue>> {
		let (i, _) = Signal<CallbackValue>.create()
		return map { value in Callback(value, i) }
	}
}
