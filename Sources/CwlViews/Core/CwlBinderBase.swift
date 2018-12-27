//
//  CwlBinderBase.swift
//  CwlViews
//
//  Created by Matt Gallagher on 27/12/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public struct BinderBase: BinderPreparer {
	public typealias Instance = Any
	public typealias Storage = Any
	public var inherited: BinderBase { get { return self } set { } }
	public func inheritedBinding(from: BinderBase.Binding) -> BinderBase.Binding? { return nil }
	public init() {}

	public enum Binding: BinderBaseBinding {
		case lifetimes(Dynamic<[Lifetime]>)
		case adHoc((Any) -> Lifetime?)
	}

	public mutating func prepareBinding(_ binding: Binding) {}
	public func prepareInstance(_ instance: Instance, storage: Storage) {}
	public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .lifetimes(let x):
			switch x {
			case .constant(let value): return AggregateLifetime(lifetimes: value)
			case .dynamic(let signal): return signal.continuous().subscribe(context: .main) { _ in }
			}
		case .adHoc(let x):
			return x(instance)
		}
	}
	public func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? { return nil }
}

public protocol BinderBaseBinding: Binding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self
}
public extension BinderBase.Binding {
	public typealias Preparer = BinderBase
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
