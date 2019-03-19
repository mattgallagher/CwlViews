//
//  CwlBinderBase.swift
//  CwlViews
//
//  Created by Matt Gallagher on 27/12/18.
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

public struct BinderBase: BinderPreparer {
	public typealias Instance = Any
	public typealias Storage = Any

	public enum Binding: BinderBaseBinding {
		case lifetimes(Dynamic<[Lifetime]>)
		case adHoc((Any) -> Lifetime?)
	}

	public var inherited: BinderBase { get { return self } set { } }

	public init() {}
	
	public func inheritedBinding(from: BinderBase.Binding) -> BinderBase.Binding? { return nil }
	public mutating func prepareBinding(_ binding: Binding) {}
	public func prepareInstance(_ instance: Instance, storage: Storage) {}
	public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .lifetimes(let x):
			switch x {
			case .constant(let value):
				return AggregateLifetime(lifetimes: value)
			case .dynamic(let signal): return signal.continuous().subscribe(context: .main) { _ in }
			}
		case .adHoc(let x):
			return x(instance)
		}
	}
	public func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? { return nil }
	public func combine(lifetimes: [Lifetime], instance: Any, storage: Any) -> Any { return () }
}

public protocol BinderBaseBinding: Binding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self
}
public extension BinderBase.Binding {
	typealias Preparer = BinderBase
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> BinderBase.Binding { return binding }
}

extension BindingName where Binding: BinderBaseBinding {
	public typealias BinderBaseName<V> = BindingName<V, BinderBase.Binding, Binding>
	private typealias B = BinderBase.Binding
	private static func name<V>(_ source: @escaping (V) -> BinderBase.Binding) -> BinderBaseName<V> {
		return BinderBaseName<V>(source: source, downcast: Binding.binderBaseBinding)
	}
}
public extension BindingName where Binding: BinderBaseBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: BinderBaseName<$2> { return .name(BinderBase.Binding.$1) }
	static var lifetimes: BinderBaseName<Dynamic<[Lifetime]>> { return .name(B.lifetimes) }
	static var adHocBinding: BinderBaseName<(Any) -> Lifetime?> { return .name(B.adHoc) }
}
