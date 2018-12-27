//
//  CwlScreenEdgePanGestureRecognizer_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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

public class ScreenEdgePanGestureRecognizer: Binder, ScreenEdgePanGestureRecognizerConvertible {
	public typealias Instance = UIScreenEdgePanGestureRecognizer
	public typealias Inherited = GestureRecognizer
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func uiScreenEdgePanGestureRecognizer() -> Instance { return instance() }
	
	enum Binding: ScreenEdgePanGestureRecognizerBinding {
		public typealias EnclosingBinder = ScreenEdgePanGestureRecognizer
		public static func screenEdgePanGestureRecognizerBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case edges(Dynamic<UIRectEdge>)
		
		// 2. Signal bindings are performed on the object after construction.
		
		// 3. Action bindings are triggered by the object after construction.
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		
		public struct Name<Value> {
			// You can easily convert the `Binding` cases to `Binding.Name` using the following Xcode-style regex:
			// Replace: case ([^\(]+)\((.+)\)$
			// With:    public static var $1: Name<$2> { return Name<$2>(Binding.$1) }
			public static var edges: Name<Dynamic<UIRectEdge>> { return Name<Dynamic<UIRectEdge>>(Binding.edges) }
			
			let binding: (Value) -> Binding
			init(_ binding: @escaping (Value) -> Binding) {
				self.binding = binding
			}
		}
	}
	
	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = ScreenEdgePanGestureRecognizer
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .edges(let x): return x.apply(instance) { i, v in i.edges = v }
			case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			}
		}
	}
	
	public typealias Storage = GestureRecognizer.Storage
}

extension BindingName where Binding: ScreenEdgePanGestureRecognizerBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .screenEdgePanGestureRecognizerBinding(ScreenEdgePanGestureRecognizer.Binding.$1(v)) }) }
	public static var edges: BindingName<Dynamic<UIRectEdge>, Binding> { return BindingName<Dynamic<UIRectEdge>, Binding>({ v in .screenEdgePanGestureRecognizerBinding(ScreenEdgePanGestureRecognizer.Binding.edges(v)) }) }
}

public protocol ScreenEdgePanGestureRecognizerConvertible: GestureRecognizerConvertible {
	func uiScreenEdgePanGestureRecognizer() -> ScreenEdgePanGestureRecognizer.Instance
}
extension ScreenEdgePanGestureRecognizerConvertible {
	public func uiGestureRecognizer() -> GestureRecognizer.Instance { return uiScreenEdgePanGestureRecognizer() }
}
extension ScreenEdgePanGestureRecognizer.Instance: ScreenEdgePanGestureRecognizerConvertible {
	public func uiScreenEdgePanGestureRecognizer() -> ScreenEdgePanGestureRecognizer.Instance { return self }
}

public protocol ScreenEdgePanGestureRecognizerBinding: GestureRecognizerBinding {
	static func screenEdgePanGestureRecognizerBinding(_ binding: ScreenEdgePanGestureRecognizer.Binding) -> Self
}
extension ScreenEdgePanGestureRecognizerBinding {
	public static func gestureRecognizerBinding(_ binding: GestureRecognizer.Binding) -> Self {
		return screenEdgePanGestureRecognizerBinding(.inheritedBinding(binding))
	}
}

#endif
