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
		if let data = interface.peekData() {
			_ = self.encode(data, forKey: forKey)
		}
	}

	/// Decodes the JSON data in self, associated with the provided key, and sends into the signal input.
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

extension SignalInterface where OutputValue == Data {
	public func decode<Target: Decodable>(as decodableType: Target.Type) -> Signal<Target> {
		return transformValues { v, n in n.send(result: Result { try JSONDecoder().decode(decodableType, from: v) }) }
	}
}

extension SignalInterface where OutputValue: Encodable {
	public func peekData() -> Data? {
		return peek().flatMap { try? JSONEncoder().encode($0) }
	}

	public func data() -> Signal<Data> {
		return transformValues { v, n in n.send(result: Result { try JSONEncoder().encode(v) }) }
	}

	/// This function subscribes to the signal and logs emitted values as JSON data to the console
	///
	/// - Parameter prefix: pre-pended to each JSON value
	/// - Returns: an endpoint which will keep this logger alive
	public func logJson(prefix: String = "", outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted) -> SignalOutput<OutputValue> {
		return subscribe { result in
			switch result {
			case .success(let v):
				let enc = JSONEncoder()
				enc.outputFormatting = outputFormatting
				if let data = try? enc.encode(v), let string = String(data: data, encoding: .utf8) {
					print("\(prefix)\(string)")
				}
			case .failure(let e):
				print("\(prefix)\(e)")
			}
		}
	}
}

extension String {
	public static let viewStateKey = "viewStateData"
}
