//
//  CwlCodableContainer.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/01/09.
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

public protocol CodableContainer: Lifetime, Codable {
	var codableValueChanged: Signal<Void> { get }
	var childCodableContainers: [CodableContainer] { get }
}

extension CodableContainer {
	public var childCodableContainers: [CodableContainer] {
		return Mirror(reflecting: self).children.compactMap { $0.value as? CodableContainer }
	}
	
	public var codableValueChanged: Signal<Void> {
		let sequence = childCodableContainers.map { return $0.codableValueChanged }
		if sequence.isEmpty {
			return Signal<Void>.preclosed()
		} else if sequence.count == 1 {
			return sequence.first!
		} else {
			return Signal<Void>.merge(sequence: sequence)
		}
	}
	
	public mutating func cancel() {
		for var v in childCodableContainers {
			v.cancel()
		}
	}
}

extension Array: Lifetime where Element: CodableContainer {
	public mutating func cancel() {
		for var v in self {
			v.cancel()
		}
	}
}

extension Optional: Lifetime where Wrapped: CodableContainer {
	public mutating func cancel() {
		self?.cancel()
	}
}

extension Array: CodableContainer where Element: CodableContainer {
	public var childCodableContainers: [CodableContainer] {
		return flatMap { $0.childCodableContainers }
	}
}

extension Optional: CodableContainer where Wrapped: CodableContainer {
	public var childCodableContainers: [CodableContainer] {
		return self?.childCodableContainers ?? []
	}
}
