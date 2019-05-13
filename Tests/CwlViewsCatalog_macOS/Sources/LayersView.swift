//
//  LayersView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
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

import CwlViews

struct LayersViewState: CodableContainer {
	let path: TempVar<CGPath>
	init() {
		path = TempVar()
	}
}

func layersView(_ layersViewState: LayersViewState) -> ViewConvertible {
	return View(
		.layout -- .fill(
			View(
				.layer -- Layer(
					.backgroundColor -- NSColor.lightGray.cgColor
				),
				.layout -- .vertical(
					align: .center,
					.space(),
					.view(
						length: .equalTo(ratio: 0.2),
						breadth: .equalTo(ratio: 1.0),
						relativity: .breadthRelativeToLength,
						View(
							.gradientLayer -- GradientLayer(
								.colors -- [
									NSColor.init(red: 1, green: 0, blue: 0, alpha: 1).cgColor,
									NSColor.init(red: 1, green: 1, blue: 0, alpha: 1).cgColor,
									NSColor.init(red: 0, green: 1, blue: 0, alpha: 1).cgColor,
									NSColor.init(red: 0, green: 1, blue: 1, alpha: 1).cgColor,
									NSColor.init(red: 0, green: 0, blue: 1, alpha: 1).cgColor,
									NSColor.init(red: 1, green: 0, blue: 1, alpha: 1).cgColor,
								]
							)
						)
					),
					.space(),
					.view(
						length: .equalTo(ratio: 0.2),
						breadth: .equalTo(ratio: 1.0),
						relativity: .breadthRelativeToLength,
						ExtendedView(
							.sizeDidChange --> Input()
								.map { size in
									let path = CGMutablePath()
									path.addEllipse(in: CGRect(origin: .zero, size: size).insetBy(dx: 6, dy: 6))
									return path
								}
								.bind(to: layersViewState.path),
							.shapeLayer -- ShapeLayer(
								.path <-- layersViewState.path,
								.fillColor -- NSColor.purple.cgColor,
								.strokeColor -- NSColor.white.cgColor,
								.lineWidth -- 12
							)
						)
					),
					.space(),
					.view(
						length: .equalTo(ratio: 0.2),
						breadth: .equalTo(ratio: 1.0),
						relativity: .breadthRelativeToLength,
						View(
							.layer -- Layer(
								.backgroundColor -- NSColor.red.cgColor,
								.cornerRadius -- 40
							)
						)
					),
					.space(.fillRemaining)
				)
			)
		)
	)
}

private extension BindingName where Binding: ViewBinding {
	static var gradientLayer: BinderBaseName<Constant<GradientLayer>> {
		return Binding.compositeName(
			value: { (layerBinding: Constant<GradientLayer>) -> (Any) -> Lifetime? in
				{ (instance: Any) -> Lifetime? in
					(instance as! NSView).layer = layerBinding.value.caGradientLayer()
					return nil
				}
			},
			binding: BinderBase.Binding.adHocFinalize,
			downcast: Binding.binderBaseBinding
		)
	}
}

private extension BindingName where Binding: ViewBinding {
	static var shapeLayer: BinderBaseName<Constant<ShapeLayer>> {
		return Binding.compositeName(
			value: { (layerBinding: Constant<ShapeLayer>) -> (Any) -> Lifetime? in
				{ (instance: Any) -> Lifetime? in
					(instance as! NSView).layer = layerBinding.value.caShapeLayer()
					return nil
				}
			},
			binding: BinderBase.Binding.adHocFinalize,
			downcast: Binding.binderBaseBinding
		)
	}
}
