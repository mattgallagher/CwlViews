//
//  CwlBindingParser.swift
//  CwlViewsTesting_iOS
//
//  Created by Matt Gallagher on 2018/03/26.
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

public struct BindingParser<AssociatedValue, Binding> {
	public var parse: (Binding) -> AssociatedValue?
	public init(parse: @escaping (Binding) -> AssociatedValue?) {
		self.parse = parse
	}
}

public enum BindingParserErrors: Error {
	case multipleMatchesFound
	case noMatchesFound
	case unexpectedArgumentType
}

public extension Dynamic {
	var values: [Value] {
		switch self {
		case .constant(let v): return [v]
		case .dynamic(let s): return s.capture().values
		}
	}
	
	var signal: Signal<Value> {
		switch self {
		case .constant(let f): return Signal.just(f)
		case .dynamic(let s): return s
		}
	}
}

public extension Binding {
	static func value<AssociatedValue, S: Sequence>(for parser: BindingParser<Dynamic<AssociatedValue>, Self>, in bindings: S) throws -> AssociatedValue where S.Element == Self {
		var found: AssociatedValue? = nil
		for b in bindings {
			if let v = parser.parse(b) {
				if found != nil {
					throw BindingParserErrors.multipleMatchesFound
				}
				found = v.values.first
			}
		}
		if let f = found {
			return f
		}
		throw BindingParserErrors.noMatchesFound
	}
	
	static func valuesArray<AssociatedValue, S: Sequence>(for parser: BindingParser<Dynamic<AssociatedValue>, Self>, in bindings: S) throws -> [AssociatedValue] where S.Element == Self {
		var found: [AssociatedValue]? = nil
		for b in bindings {
			if let v = parser.parse(b) {
				if found != nil {
					throw BindingParserErrors.multipleMatchesFound
				}
				found = v.values
			}
		}
		if let f = found {
			return f
		}
		throw BindingParserErrors.noMatchesFound
	}
	
	static func value<AssociatedValue, S: Sequence>(for parser: BindingParser<Constant<AssociatedValue>, Self>, in bindings: S) throws -> AssociatedValue where S.Element == Self {
		var found: AssociatedValue? = nil
		for b in bindings {
			if let v = parser.parse(b) {
				if found != nil {
					throw BindingParserErrors.multipleMatchesFound
				}
				found = v.value
			}
		}
		if let f = found {
			return f
		}
		throw BindingParserErrors.noMatchesFound
	}
	
	static func signal<AssociatedValue, S: Sequence>(for parser: BindingParser<Dynamic<AssociatedValue>, Self>, in bindings: S) throws -> Signal<AssociatedValue> where S.Element == Self {
		var found: Signal<AssociatedValue>? = nil
		for b in bindings {
			if let v = parser.parse(b) {
				if found != nil {
					throw BindingParserErrors.multipleMatchesFound
				}
				found = v.signal
			}
		}
		if let f = found {
			return f
		}
		throw BindingParserErrors.noMatchesFound
	}
	
	static func argument<AssociatedValue, S: Sequence>(for parser: BindingParser<AssociatedValue, Self>, in bindings: S) throws -> AssociatedValue where S.Element == Self {
		var found: AssociatedValue? = nil
		for b in bindings {
			if let v = parser.parse(b) {
				if found != nil {
					throw BindingParserErrors.multipleMatchesFound
				}
				found = v
			}
		}
		if let f = found {
			return f
		}
		throw BindingParserErrors.noMatchesFound
	}
}
