//
//  CwlIndexedMutationUtilities.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/12/23.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

public struct TreeMutation<Leaf> {
	let mutations: IndexedMutation<TreeMutation<Leaf>, Leaf>
}

public struct TreeState<Metadata> {
	public var metadata: Metadata? = nil
	public var rows: Array<TreeState<Metadata>>? = nil
	
	public init() {}
	
	public init(treeMutation: TreeMutation<Metadata>) {
		self.init()
		treeMutation.mutations.apply(toTree: &self)
	}
}

public typealias TreeSubrangeMutation<Leaf> = TreeMutation<Subrange<Leaf>>

extension IndexedMutation where Element == TreeMutation<Metadata> {
	public func apply(toTree treeState: inout TreeState<Metadata>) {
		if let metadata = metadata {
			treeState.metadata = metadata
		}
		
		if !hasNoEffectOnValues {
			var rows: Array<TreeState<Metadata>> = []
			if case .update = kind {
				for (mutationIndex, rowIndex) in indexSet.enumerated() {
					values[mutationIndex].mutations.apply(toTree: &rows[rowIndex])
				}
			} else {
				mapValues(TreeState<Metadata>.init).mapMetadata { _ in () }.apply(to: &rows)
			}
			treeState.rows = rows
		}
	}
}

public typealias TreeRangeMutation<Leaf> = TreeMutation<Subrange<Leaf>>

public struct TreeSubrangeState<Leaf> {
	public var state = SubrangeState<TreeSubrangeState<Leaf>, Leaf>()

	public init() {}
	
	public init(treeSubrangeMutation: TreeSubrangeMutation<Leaf>) {
		self.init()
		treeSubrangeMutation.mutations.apply(toTreeSubrange: &self)
	}
}

extension IndexedMutation where Element == TreeMutation<Metadata> {
	public func apply<Leaf>(toTreeSubrange treeSubrangeState: inout TreeSubrangeState<Leaf>) where Subrange<Leaf> == Metadata {
		if !hasNoEffectOnValues {
			if case .update = kind {
				for (mutationIndex, rowIndex) in indexSet.enumerated() {
					values[mutationIndex].mutations.apply(toTreeSubrange: &treeSubrangeState.state.values![rowIndex])
				}
			} else {
				mapValues(TreeSubrangeState<Leaf>.init).apply(toSubrange: &treeSubrangeState.state)
			}
		}
		updateMetadata(&treeSubrangeState.state)
	}
}
