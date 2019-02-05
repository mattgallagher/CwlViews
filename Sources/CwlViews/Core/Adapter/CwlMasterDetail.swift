//
//  CwlMasterDetail.swift
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

/// An "Either" type for use in scenarios where "Equatable" and "Codable" are required but there's only ever a single "Master" instance so equality is implied. This is common in Navigation Controller stacks and Split Views.
public enum MasterDetail<Master: CodableContainer, Detail: CodableContainer>: CodableContainer {
	case master(Master)
	case detail(Detail)
	
	public var childCodableContainers: [CodableContainer] {
		switch self {
		case .master(let tvm): return [tvm]
		case .detail(let dvm): return [dvm]
		}
	}
	
	enum Keys: CodingKey { case master, detail }
	
	public func encode(to encoder: Encoder) throws {
		var c = encoder.container(keyedBy: Keys.self)
		switch self {
		case .master(let tvm): try c.encode(tvm, forKey: .master)
		case .detail(let dvm): try c.encode(dvm, forKey: .detail)
		}
	}
	
	public init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: Keys.self)
		if let tvm = try c.decodeIfPresent(Master.self, forKey: .master) {
			self = .master(tvm)
		} else {
			self = .detail(try c.decode(Detail.self, forKey: .detail))
		}
	}
}
