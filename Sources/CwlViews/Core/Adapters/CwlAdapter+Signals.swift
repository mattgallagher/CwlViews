//
//  CwlAdapter+Signals.swift
//  CwlViews
//
//  Created by Matt Gallagher on 15/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

extension Adapter {
	
//	public func filteredSignal<Value, Processed>(initialValue: Value, _ processor: @escaping (inout Value, State, State.Notification?, SignalNext<Processed>) throws -> Void) -> Signal<Processed> {
//		return signal.transform(initialState: (initialized: false, value: initialValue)) { (tuple, result, next) in
//			let content: (state: State?, notification: State.Notification?)
//			switch result {
//			case .success(let v): content = v 
//			case .failure(let e): next.send(end: e); return
//			}
//			guard tuple.initialized else {
//				guard let s = content.state else { return }
//				tuple.initialized = true
//				return
//			}
//			
//		}
//	}
	
}
