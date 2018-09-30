//
//  CwlBinderParameters.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/04/01.
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

/// The mandatory requirement of BinderParameters is that they include an array of bindings
public protocol BinderParameters {
	associatedtype Binding
	var bindings: [Binding] { get }
}

/// A minimalist implementation of `BinderParameters`
public struct BindingsOnlyParameters<Binding>: BinderParameters {
	public let bindings: [Binding]
	public init(bindings: [Binding]) {
		self.bindings = bindings
	}
}

public struct BinderSubclassParameters<Instance, Binding>: BinderParameters {
	public let subclass: Instance.Type
	public let bindings: [Binding]
	public init(subclass: Instance.Type, bindings: [Binding]) {
		self.subclass = subclass
		self.bindings = bindings
	}
}

public struct BinderAdditionalParameters<Instance, Binding, Additional>: BinderParameters {
	public let subclass: Instance.Type
	public let additional: Additional
	public let bindings: [Binding]
	public init(subclass: Instance.Type, additional: Additional, bindings: [Binding]) {
		self.subclass = subclass
		self.additional = additional
		self.bindings = bindings
	}
}

