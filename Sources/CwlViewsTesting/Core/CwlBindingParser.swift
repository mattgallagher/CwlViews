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

public struct BindingParser<Value, Binding, Downcast> {
	public var extract: (Binding) -> Value?
	public var upcast: (Downcast) -> Binding?
	public init(extract: @escaping (Binding) -> Value?, upcast: @escaping (Downcast) -> Binding?) {
		self.extract = extract
		self.upcast = upcast
	}
	public func parse(_ downcast: Downcast) -> Value? {
		return upcast(downcast).flatMap { extract($0) }
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

extension Binder {
	static func consume(from possibleBinder: Any) throws -> (type: Self.Preparer.Instance.Type, parameters: Self.Preparer.Parameters, bindings: [Self.Preparer.Binding]) {
		if let b = possibleBinder as? Self {
			return b.consume()
		}
		throw BindingParserErrors.unexpectedArgumentType
	}
	
	static func consumeBindings(from possibleBinder: Any) throws -> [Self.Preparer.Binding] {
		return try consume(from: possibleBinder).bindings
	}
	
	static func latestValue<Downcast, V, S: Sequence>(for parser: BindingParser<Dynamic<V>, Preparer.Binding, Downcast>, in bindings: S) throws -> V where S.Element == Downcast {
		var found: V? = nil
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
	
	static func latestArray<Downcast, V, S: Sequence>(for parser: BindingParser<Dynamic<V>, Preparer.Binding, Downcast>, in bindings: S) throws -> [V] where S.Element == Downcast {
		var found: [V]? = nil
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
	
	static func constantValue<Downcast, V, S: Sequence>(for parser: BindingParser<Constant<V>, Preparer.Binding, Downcast>, in bindings: S) throws -> V where S.Element == Downcast {
		var found: V? = nil
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
	
	static func valueSignal<Downcast, V, S: Sequence>(for parser: BindingParser<Dynamic<V>, Preparer.Binding, Downcast>, in bindings: S) throws -> Signal<V> where S.Element == Downcast {
		var found: Signal<V>? = nil
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
	
	static func argument<Downcast, V, S: Sequence>(for parser: BindingParser<V, Preparer.Binding, Downcast>, in bindings: S) throws -> V where S.Element == Downcast {
		var found: V? = nil
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
