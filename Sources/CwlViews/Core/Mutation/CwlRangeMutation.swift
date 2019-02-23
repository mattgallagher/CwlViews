//
//  CwlRangeMutation.swift
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
/// A combination of a `ArrayMutation` and a local offset and global count which track a global array of which the `ArrayMutation` might merely be a subrange.
public struct RangeMutation<Element, Metadata>: ExpressibleByArrayLiteral {
	/// A `RangeMutation` is primarily an `ArrayMutation` with some additional features suitable for animating an 
	public let arrayMutation: ArrayMutation<Element>
	
	/// This is offset for the `arrayMutation` in greater array *after* the mutation is applied.
	public let localOffset: Int
	
	/// This is the length of the greater array *after* the mutation is applied.
	public let globalCount: Int

	/// To support their use as "tree" nodes, range mutation offers arbitrary storage about this node.
	public let metadata: Metadata?
	
	public init(metadata: Metadata? = nil, arrayMutation: ArrayMutation<Element>, localOffset: Int = 0, globalCount: Int? = nil) {
		self.arrayMutation = arrayMutation
		self.localOffset = localOffset
		self.globalCount = globalCount ?? arrayMutation.values.count
		self.metadata = metadata
	}
	
	public init(arrayLiteral elements: Element...) {
		self.init(arrayMutation: ArrayMutation(reload: elements), localOffset: 0, globalCount: elements.count)
	}
	
	public init(metadata: Metadata? = nil, array elements: [Element]) {
		self.init(metadata: metadata, arrayMutation: ArrayMutation(reload: elements), localOffset: 0, globalCount: elements.count)
	}
	
	public func apply(to rangeState: inout RangeMutationState<Element, Metadata>) {
		arrayMutation.apply(to: &rangeState.rows)
		rangeState.localOffset = localOffset
		rangeState.globalCount = globalCount
		rangeState.metadata = metadata
	}
}

extension IndexSet {
	/// Maintaining an `RangeMutation` with a local offset may require offsetting an `IndexSet`
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

public enum TreeMutation<Leaf> {
	indirect case node(RangeMutation<TreeMutation<Leaf>, Leaf>)
}

#if os(macOS)
	public typealias TableRowMutation<Element> = Animatable<Element, NSTableView.AnimationOptions>
	public extension Animatable where AnimationType == NSTableView.AnimationOptions {
		init<V>(arrayMutation: ArrayMutation<V>, localOffset: Int = 0, globalCount: Int? = nil, animation: NSTableView.AnimationOptions = .effectFade) where RangeMutation<V> == Element {
			self.init(value: RangeMutation(arrayMutation: arrayMutation, localOffset: localOffset, globalCount: globalCount), animation: animation)
		}
		init<V>(array elements: [V]) where RangeMutation<V> == Element {
			self.init(value: RangeMutation(arrayMutation: ArrayMutation(reload: elements), localOffset: 0, globalCount: elements.count), animation: nil)
		}
	}
	public enum TreeMutation<NodeData> {
		case leaf(NodeData)
		case leafAndChildren(RangeMutation<TreeMutation<NodeData>, NodeData>)
		case childrenOnly(RangeMutation<TreeMutation<NodeData>, ()>)
		case parentOnly(NodeData)
	}
#elseif os(iOS)
	public typealias TableRowMutation<Element> = Animatable<RangeMutation<Element, TableSectionMetadata>, UITableView.RowAnimation>
	public typealias TableSectionMutation<Element> = Animatable<RangeMutation<TableRowMutation<Element>, ()>, UITableView.RowAnimation>
	public extension Animatable where AnimationType == UITableView.RowAnimation {
		init<V, Metadata>(metadata: Metadata? = nil, arrayMutation: ArrayMutation<V>, localOffset: Int = 0, globalCount: Int? = nil, animation: UITableView.RowAnimation = .automatic) where RangeMutation<V, Metadata> == Value {
			self.init(value: RangeMutation<V, Metadata>(arrayMutation: arrayMutation, localOffset: localOffset, globalCount: globalCount), animation: animation)
		}
		init<V, Metadata>(metadata: Metadata? = nil, array elements: [V]) where RangeMutation<V, Metadata> == Value {
			self.init(value: RangeMutation(arrayMutation: ArrayMutation(reload: elements), localOffset: 0, globalCount: elements.count), animation: nil)
		}
	}
#endif

/// A data type that can be used to cache the destination end of a `RangeMutation<Element>` change stream.
public struct RangeMutationState<Element, Metadata> {
	public var rows: Deque<Element> = []
	public var localOffset: Int = 0
	public var globalCount: Int = 0
	public var metadata: Metadata?
	public init() {}
}

public typealias TableRowState<Element> = RangeMutationState<Element, TableSectionMetadata>
public typealias TableSectionState<Element> = RangeMutationState<Element, ()>

private var associatedInputKey = NSObject()
public func cellSignalInput<B>(for object: NSObject, valueType: B.Type) -> 
SignalInput<B>? {
	return objc_getAssociatedObject(object, &associatedInputKey) as? SignalInput<B>
}

public func setCellSignalInput<B>(for object: NSObject, to input: SignalInput<B>) {
	objc_setAssociatedObject(object, &associatedInputKey, input, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
}
