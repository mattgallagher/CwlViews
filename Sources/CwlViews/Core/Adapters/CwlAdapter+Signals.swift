//
//  CwlAdapter+Signals.swift
//  CwlViews
//
//  Created by Matt Gallagher on 15/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

extension Adapter {
	/// This function subscribes to the signal and logs emitted values as JSON data to the console
	///
	/// - Parameter prefix: pre-pended to each JSON value
	/// - Returns: an endpoint which will keep this logger alive
	public func logJson(prefix: String = "", outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted) -> SignalOutput<Void> {
		return codableValueChanged.startWith(()).subscribeValues {
			let enc = JSONEncoder()
			enc.outputFormatting = outputFormatting
			do {
				let data = try enc.encode(self)
				if let string = String(data: data, encoding: .utf8) {
					print("\(prefix)\(string)")
				}
			} catch {
				print(error)
			}
		}
	}
}

extension Adapter where State: SingleValueAdapterState {

	/// Access to `state` values emitted from `combinedSignal`.
	public var stateSignal: Signal<State> {
		return combinedSignal.compactMap { content in content.state }
	}
	
}
	
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
