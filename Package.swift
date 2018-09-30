// swift-tools-version:4.0
import PackageDescription

let package = Package(
   name: "CwlViews",
   products: [
   	.library(name: "CwlViews", type: .dynamic, targets: ["CwlViews"])
	],
	dependencies: [
		.package(url: "https://github.com/mattgallagher/CwlSignal.git", .branch("xcode10")),
		.package(url: "https://github.com/mattgallagher/CwlUtils.git", .branch("xcode10")),
	],
	targets: [
		.target(
			name: "CwlViews",
			dependencies: [
				.product(name: "CwlSignal"),
				.product(name: "CwlUtils")
			]
		)
	]
)
