//
//  CwlAdapter+Signals.swift
//  CwlViews
//
//  Created by Matt Gallagher on 15/1/19.
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

extension Adapter: Lifetime {
	public func cancel() {
		if State.self is CodableContainer.Type, let value = combinedSignal.peek()?.state, var sc = value as? CodableContainer {
			sc.cancel()
		}
		input.cancel()
	}
}

extension Adapter: Codable where State: Codable {
	public init(from decoder: Decoder) throws {
		let c = try decoder.singleValueContainer()
		let p = try c.decode(State.self)
		self.init(adapterState: p)
	}
	
	public func encode(to encoder: Encoder) throws {
		if let s = combinedSignal.peek()?.state {
			var c = encoder.singleValueContainer()
			try c.encode(s)
		}
	}
}

extension Adapter: CodableContainer where State: PersistentAdapterState {
	public var childCodableContainers: [CodableContainer] {
		if let state = combinedSignal.peek()?.state {
			return (state as? CodableContainer)?.childCodableContainers ?? []
		} else {
			return []
		}
	}
	
	public var codableValueChanged: Signal<Void> {
		if State.self is CodableContainer.Type {
			return combinedSignal.flatMapLatest { (content: State.Output) -> Signal<Void> in
				let cc = content.state as! CodableContainer
				return cc.codableValueChanged.startWith(())
			}.dropActivation()
		}
		return combinedSignal.map { _ in () }.dropActivation()
	}
}
