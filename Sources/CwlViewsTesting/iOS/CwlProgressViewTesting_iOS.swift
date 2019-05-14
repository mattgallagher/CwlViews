//
//  CwlProgressViewTesting_iOS.swift
//  CwlViewsTesting
//
//  Created by Sye Boddeus on 14/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

extension BindingParser where Downcast: ProgressViewBinding {

	//    0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var progress: BindingParser<Dynamic<SetOrAnimate<Float>>, ProgressView.Binding, Downcast> { return .init(extract: { if case .progress(let x) = $0 { return x } else { return nil } }, upcast: { $0.asProgressViewBinding() }) }
	public static var observedProgress: BindingParser<Dynamic<Progress?>, ProgressView.Binding, Downcast> { return .init(extract: { if case .observedProgress(let x) = $0 { return x } else { return nil } }, upcast: { $0.asProgressViewBinding() }) }
	public static var progressViewStyle: BindingParser<Dynamic<UIProgressView.Style>, ProgressView.Binding, Downcast> { return .init(extract: { if case .progressViewStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asProgressViewBinding() }) }
	public static var progressTintColor: BindingParser<Dynamic<UIColor?>, ProgressView.Binding, Downcast> { return .init(extract: { if case .progressTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asProgressViewBinding() }) }
	public static var progressImage: BindingParser<Dynamic<UIImage?>, ProgressView.Binding, Downcast> { return .init(extract: { if case .progressImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asProgressViewBinding() }) }
	public static var trackTintColor: BindingParser<Dynamic<UIColor?>, ProgressView.Binding, Downcast> { return .init(extract: { if case .trackTintColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asProgressViewBinding() }) }
	public static var trackImage: BindingParser<Dynamic<UIImage?>, ProgressView.Binding, Downcast> { return .init(extract: { if case .trackImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asProgressViewBinding() }) }

	// 2. Signal bindings are performed on the object after construction.

	// 3. Action bindings are triggered by the object after construction.

	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif
