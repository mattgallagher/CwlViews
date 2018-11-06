//
//  CwlSetOrAnimate_iOS.swift
//  CwlViews_iOS
//
//  Created by Matt Gallagher on 2017/08/11.
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

#if os(iOS)

/// A value abstraction of the arguments to some AppKit/UIKit methods with a `setValue(_:,animated:)` structure.
public struct SetOrAnimate<Value> {
	public let value: Value
	public let isAnimated: Bool
	
	public static func set(_ value: Value) -> SetOrAnimate<Value> {
		return SetOrAnimate<Value>(value: value, isAnimated: false)
	}
	public static func animate(_ value: Value) -> SetOrAnimate<Value> {
		return SetOrAnimate<Value>(value: value, isAnimated: true)
	}
}

extension SignalInterface {
	/// A signal transformation which wraps the output in `SetOrAnimate` with the first value as in `set` but subsequent values as in `animate`
	public func animate(_ choice: AnimationChoice = .subsequent) -> Signal<SetOrAnimate<OutputValue>> {
		return map(initialState: false) { (alreadyReceived: inout Bool, value: OutputValue) in
			if alreadyReceived || choice == .all {
				return .animate(value)
			} else {
				if choice == .subsequent {
					alreadyReceived = true
				}
				return .set(value)
			}
		}
	}
}

/// This is currently used in PageViewController but I feel like it should replace SetOrAnimate and possibly the animation in TableRowMution, too.
public struct SetAnimatable<Value, Animation> {
	public let value: Value
	public let animation: Animation?
	
	public static func set(_ value: Value) -> SetAnimatable<Value, Animation> {
		return SetAnimatable<Value, Animation>(value: value, animation: nil)
	}
	public static func animate(_ value: Value, animation: Animation) -> SetAnimatable<Value, Animation> {
		return SetAnimatable<Value, Animation>(value: value, animation: animation)
	}
}

#endif
