//
//  LayersView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct LayersViewState: CodableContainer {
	let path: TempVar<CGPath>
	init() {
		path = TempVar()
	}
}

func layersView(_ layersViewState: LayersViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .fill(
				marginEdges: [],
				View(
					.layer -- Layer(
						.backgroundColor -- UIColor.lightGray.cgColor
					),
					.layout -- .vertical(
						align: .center,
						.space(),
						.view(
							length: .equalTo(ratio: 0.2),
							breadth: .equalTo(ratio: 1.0),
							relativity: .breadthRelativeToLength,
							View(
								type: GradientLayerView.self,
								.gradientLayer -- GradientLayer(
									.colors -- [
										UIColor.init(red: 1, green: 0, blue: 0, alpha: 1).cgColor,
										UIColor.init(red: 1, green: 1, blue: 0, alpha: 1).cgColor,
										UIColor.init(red: 0, green: 1, blue: 0, alpha: 1).cgColor,
										UIColor.init(red: 0, green: 1, blue: 1, alpha: 1).cgColor,
										UIColor.init(red: 0, green: 0, blue: 1, alpha: 1).cgColor,
										UIColor.init(red: 1, green: 0, blue: 1, alpha: 1).cgColor,
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
								type: ShapeLayerView.self,
								.sizeDidChange --> Input()
									.map { size in
										let path = CGMutablePath()
										path.addEllipse(in: CGRect(origin: .zero, size: size))
										return path
									}
									.bind(to: layersViewState.path),
								.shapeLayer -- ShapeLayer(
									.path <-- layersViewState.path,
									.fillColor -- UIColor.purple.cgColor,
									.strokeColor -- UIColor.white.cgColor,
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
									.backgroundColor -- UIColor.red.cgColor,
									.cornerRadius -- 40
								)
							)
						),
						.space(.fillRemaining)
					)
				)
			)
		)
	)
}

class GradientLayerView: UIView {
	override class var layerClass: AnyClass { return CAGradientLayer.self }
}

private extension BindingName where Binding: ViewBinding {
	static var gradientLayer: BinderBaseName<Constant<GradientLayer>> {
		return Binding.compositeName(
			value: { (layerBinding: Constant<GradientLayer>) -> (Any) -> Lifetime? in
				{ (instance: Any) -> Lifetime? in
					let gradientLayer = (instance as! UIView).layer as! CAGradientLayer
					layerBinding.value.apply(to: gradientLayer)
					return nil
				}
			},
			binding: BinderBase.Binding.adHocFinalize,
			downcast: Binding.binderBaseBinding
		)
	}
}

class ShapeLayerView: CwlExtendedView {
	override class var layerClass: AnyClass { return CAShapeLayer.self }
}

private extension BindingName where Binding: ViewBinding {
	static var shapeLayer: BinderBaseName<Constant<ShapeLayer>> {
		return Binding.compositeName(
			value: { (layerBinding: Constant<ShapeLayer>) -> (Any) -> Lifetime? in
				{ (instance: Any) -> Lifetime? in
					let shapeLayer = (instance as! UIView).layer as! CAShapeLayer
					layerBinding.value.apply(to: shapeLayer)
					return nil
				}
			},
			binding: BinderBase.Binding.adHocFinalize,
			downcast: Binding.binderBaseBinding
		)
	}
}
