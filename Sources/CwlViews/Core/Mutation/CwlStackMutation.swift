//
//  CwlStackMutation.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/10/22.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

public enum StackMutation<Value>: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Value...) {
		self = .reload(elements)
	}
	
	public typealias ArrayLiteralElement = Value
	
	case push(Value)
	case pop
	case popToCount(Int)
	case reload([Value])
	
	func apply(to stack: inout Array<Value>) {
		switch self {
		case .push(let v): stack.append(v)
		case .pop: stack.removeLast()
		case .popToCount(let c): stack.removeLast(stack.count - c)
		case .reload(let newStack): stack = newStack
		}
	}
}

extension SignalInterface {
	public func stackMap<A, B>(_ transform: @escaping (A) -> B) -> Signal<StackMutation<B>> where OutputValue == StackMutation<A> {
		return map { m in
			switch m {
				case .push(let a): return StackMutation<B>.push(transform(a))
				case .pop: return StackMutation<B>.pop
				case .popToCount(let i): return StackMutation<B>.popToCount(i)
				case .reload(let array): return StackMutation<B>.reload(array.map { transform($0) })
			}
		}
	}
}
