//
//  CwlTableRowMutation.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/29.
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

/// This data type models updates to the visible rows of a single-dimensional array in a scrolling view.
/// A combination of a `ArrayMutation` and an `AnimationType` which specifies how that mutation should be displayed, along with a local offset and global count which track a global array of which the `ArrayMutation` might merely be a subrange.
/// This type can communicate changes to rows in an `NSTableView` or sections in a `UITableView`. When `Value` is a `TableSectionMutation`, this type can model a two-tiered `UITableView` with multiple sections.
public struct TableRowMutation<Value>: ExpressibleByArrayLiteral {
	#if os(macOS)
		public typealias AnimationType = NSTableView.AnimationOptions
	#elseif os(iOS)
		public typealias AnimationType = UITableView.RowAnimation
	#else
		public typealias AnimationType = Int
	#endif
	
	/// A `TableRowMutation` is primarily an `ArrayMutation` with some additional features suitable for animating an 
	public let arrayMutation: ArrayMutation<Value>
	
	/// This is offset for the `arrayMutation` in greater array *after* the mutation is applied.
	public let localOffset: Int
	
	/// This is the length of the greater array *after* the mutation is applied.
	public let globalCount: Int
	
	/// This is the animation to use for the mutation
	public let animation: AnimationType
	
	public init(arrayMutation: ArrayMutation<Value>, localOffset: Int = 0, globalCount: Int? = nil, animation: AnimationType = defaultTableViewAnimation) {
		self.arrayMutation = arrayMutation
		self.localOffset = localOffset
		self.globalCount = globalCount ?? arrayMutation.values.count
		self.animation = animation
	}
	
	public init(arrayLiteral elements: Value...) {
		self.init(arrayMutation: ArrayMutation(reload: elements), localOffset: 0, globalCount: elements.count, animation: noTableViewAnimation)
	}
	
	public init(array elements: [Value]) {
		self.init(arrayMutation: ArrayMutation(reload: elements), localOffset: 0, globalCount: elements.count, animation: noTableViewAnimation)
	}
	
	public func apply(to rowState: inout TableRowState<Value>) {
		arrayMutation.apply(to: &rowState.rows)
		rowState.localOffset = localOffset
		rowState.globalCount = globalCount
	}
	
	public static func defaultAnimation(_ kind: ArrayMutationKind) -> AnimationType {
		switch kind {
		case .update: fallthrough
		case .reload: fallthrough
		case .scroll: return noTableViewAnimation
		default: return defaultTableViewAnimation
		}
	}
}

extension IndexSet {
	/// Maintaining an `ArrayMutation` with a local offset may require offsetting an `IndexSet`
	public func offset(by: Int) -> IndexSet {
		if by == 0 {
			return self
		}
		var result = IndexSet()
		for range in self.rangeView {
			result.insert(integersIn: (range.startIndex + by)..<(range.endIndex + by))
		}
		return result
	}
}

#if os(macOS)
	public let defaultTableViewAnimation = NSTableView.AnimationOptions.effectFade
#elseif os(iOS)
	public let defaultTableViewAnimation = UITableView.RowAnimation.automatic
#else
	public let defaultTableViewAnimation = 0
#endif

#if os(macOS)
	public let noTableViewAnimation = NSTableView.AnimationOptions()
#elseif os(iOS)
	public let noTableViewAnimation = UITableView.RowAnimation.none
#else
	public let noTableViewAnimation = 0
#endif

/// A data type that can be used to cache the destination end of a `TableRowMutation<Value>` change stream.
public struct TableRowState<Value> {
	public var rows: Deque<Value> = []
	public var localOffset: Int = 0
	public var globalCount: Int = 0
	public init() {}
}

private var associatedInputKey = NSObject()
public func getSignalInput<B>(for object: NSObject, valueType: B.Type) -> 
SignalInput<B>? {
	return objc_getAssociatedObject(object, &associatedInputKey) as? SignalInput<B>
}

public func setSignalInput<B>(for object: NSObject, to input: SignalInput<B>) {
	objc_setAssociatedObject(object, &associatedInputKey, input, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
}
