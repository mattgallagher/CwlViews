//
//  CwlInitialSubsequent.swift
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

public struct InitialSubsequent<Value> {
	public let initial: Value?
	public let subsequent: SignalCapture<Value>?
	
	init<Interface: SignalInterface>(signal: Interface) where Interface.OutputValue == Value {
		let capture = signal.capture()
		let values = capture.values
		self.init(initial: values.last, subsequent: capture)
	}
	
	init(initial: Value? = nil, subsequent: SignalCapture<Value>? = nil) {
		self.initial = initial
		self.subsequent = subsequent
	}
	
	public func resume() -> Signal<Value>? {
		return subsequent?.resume()
	}
	
	public func apply<I: AnyObject>(_ instance: I, handler: @escaping (I, Value) -> Void) -> Lifetime? {
		return resume().flatMap { $0.apply(instance, handler: handler) }
	}
	
	public func apply<I: AnyObject, Storage: AnyObject>(_ instance: I, _ storage: Storage, handler: @escaping (I, Storage, Value) -> Void) -> Lifetime? {
		return resume().flatMap { $0.apply(instance, storage, handler: handler) }
	}
}
