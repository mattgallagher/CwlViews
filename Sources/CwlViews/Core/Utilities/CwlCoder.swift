//
//  CwlCoder.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/09/11.
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

extension NSCoder {
	/// Gets the latest value from the signal and encodes the value as JSON data into self using the provided key
	///
	/// - Parameters:
	///   - interface: exposes the signal
	///   - forKey: key used for encoding (is `String.viewStateKey` by default)
	public func encodeLatest<Interface>(from interface: Interface, forKey: String = .viewStateKey) where Interface: SignalInterface, Interface.OutputValue: Codable {
		if let data = try? JSONEncoder().encode(interface.peek()) {
			_ = self.encode(data, forKey: forKey)
		}
	}

	/// Decodes the JSON data in self, associated with the provided key, and sends into the signal input.
	///
	/// NOTE: this function does not send errors.
	///
	/// - Parameters:
	///   - inputInterface: exposes the signal input
	///   - forKey: key used for decoding (is `String.viewStateKey` by default)
	public func decodeSend<InputInterface>(to inputInterface: InputInterface, forKey: String = .viewStateKey) where InputInterface: SignalInputInterface, InputInterface.InputValue: Codable {
		if let data = self.decodeObject(forKey: forKey) as? Data, let value = try? JSONDecoder().decode(InputInterface.InputValue.self, from: data) {
			inputInterface.input.send(value: value)
		}
	}
}

extension String {
	public static let viewStateKey = "viewStateData"
}
