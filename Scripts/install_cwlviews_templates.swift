#!/usr/bin/swift
//
//  install_cwlviews_templates.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2018/06/14.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

import AppKit

extension FileHandle: TextOutputStream {
	public func write(_ string: String) { string.data(using: .utf8).map { write($0) } }
	static var err = FileHandle.standardError
}

func run() {
	var isDirectory: ObjCBool = false
	guard FileManager.default.fileExists(atPath: "../CwlViews.xcodeproj", isDirectory: &isDirectory), isDirectory.boolValue else {
		print("\u{01b}[1mError: install_cwlviews_templates.swift must be run from inside the Scripts directory of the CwlViews repository.\u{01b}[0m", to: &FileHandle.err)
		exit(1)
	}
	
	guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
		fatalError("Unable to locate user library directory.")
	}
	let templates: Dictionary<URL, (URL, URL) throws -> Void> = [
		libraryDirectory.appendingPathComponent("Developer/Xcode/Templates/Project Templates/iOS/Application/CwlViews Application Unit Tests.xctemplate"): installIosAppTestsTemplate,
		libraryDirectory.appendingPathComponent("Developer/Xcode/Templates/Project Templates/Mac/Application/CwlViews Application Unit Tests.xctemplate"): installMacAppTestsTemplate,
		libraryDirectory.appendingPathComponent("Developer/Xcode/Templates/Project Templates/iOS/Application/CwlViews Application.xctemplate"): installIosAppTemplate,
		libraryDirectory.appendingPathComponent("Developer/Xcode/Templates/Project Templates/Mac/Application/CwlViews Application.xctemplate"): installMacAppTemplate,
		libraryDirectory.appendingPathComponent("Developer/Xcode/Templates/File Templates/Source/CwlViewsBinder.xctemplate"): installCwlViewsTemplate,
		libraryDirectory.appendingPathComponent("Developer/Xcode/Templates/File Templates/Playground/CwlViews Playground macOS.xctemplate"): installMacPlayground,
		libraryDirectory.appendingPathComponent("Developer/Xcode/Templates/File Templates/Playground/CwlViews Playground iOS.xctemplate"): installIosPlayground
	]

	do {
		let temporaryLocation = try FileManager.default.url(
			for: .itemReplacementDirectory,
			in: .userDomainMask,
			appropriateFor: libraryDirectory,
			create: true
		)
		_ = launch("/usr/bin/xcodebuild", [
			"-project",
			"../CwlViews.xcodeproj",
			"-scheme",
			"CwlViewsConcat",
			"-sdk",
			"macosx",
			"build",
			"-derivedDataPath",
			temporaryLocation.path,
			"-configuration",
			"Debug"
		])
		let cwlViewsProducts = temporaryLocation.appendingPathComponent("Build/Products/Debug")

		for (destinationUrl, installFunction) in templates {
			// Create the parent directory, if necessary
			try FileManager.default.createDirectory(at: destinationUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
			
			let display: String
			
			// If the destination already exists, move it to the Trash
			if FileManager.default.fileExists(atPath: destinationUrl.path) {
				try removeDirectory(url: destinationUrl)
				display = "Installing template at location:\n   \(destinationUrl.path)\nPrevious item has been moved to Trash."
			} else {
				display = "Installing template at location:\n   \(destinationUrl.path)"
			}
			
			// Create the destination director and install the template
			print(display)
			try FileManager.default.createDirectory(at: destinationUrl, withIntermediateDirectories: false)
			try installFunction(destinationUrl, cwlViewsProducts)
		}
		print("\u{01b}[1mCompleted successfully.\u{01b}[0m")
	} catch {
		print("\u{01b}[1mFailed with error: \(error)\u{01b}[0m")
		exit(1)
	}
}

func launch(_ command: String, _ arguments: [String], directory: URL? = nil) -> String? {
	print("Running command \(command) with arguments \(arguments)")
	
	let proc = Process()
	proc.launchPath = command
	proc.arguments = arguments
	_ = directory.map { proc.currentDirectoryPath = $0.path }
	let pipe = Pipe()
	proc.standardOutput = pipe
	proc.launch()
	let result = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
	proc.waitUntilExit()
	return proc.terminationStatus != 0 ? nil : result
}

func removeDirectory(url: URL) throws {
	var result: (urls: [URL: URL], error: Error?)? = nil
	NSWorkspace.shared.recycle([url]) { (urls, error) in result = (urls: urls, error: error) }
	while result == nil {
		RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.01))
	}
	if let e = result?.error {
		throw e
	}
}

func installIcons(_ destination: URL) throws {
	try templateIconPng().write(to: destination.appendingPathComponent("TemplateIcon.png"))
	try templateIconPngAt2x().write(to: destination.appendingPathComponent("TemplateIcon@2x.png"))
}

func installAssets(_ destination: URL) throws {
	try installIcons(destination)
	try FileManager.default.createDirectory(at: destination.appendingPathComponent("Images.xcassets"), withIntermediateDirectories: true, attributes: nil)
	try contentsJson().data(using: .utf8)!.write(to: destination.appendingPathComponent("Images.xcassets/Contents.json"))
}

func installIosAppTemplate(_ destination: URL, _ cwlViewsProducts: URL) throws {
	try installAssets(destination)
	try PropertyListSerialization.data(fromPropertyList: iOSProjectTemplateInfo(cwlViewsProducts), format: .xml, options: 0).write(to: destination.appendingPathComponent("TemplateInfo.plist"))
	try iOSLaunchScreenStoryboard().data(using: .utf8)!.write(to: destination.appendingPathComponent("LaunchScreen.storyboard"))
}

func installIosAppTestsTemplate(_ destination: URL, _ cwlViewsProducts: URL) throws {
	try PropertyListSerialization.data(fromPropertyList: testTemplateInfo(cwlViewsProducts, .iOS), format: .xml, options: 0).write(to: destination.appendingPathComponent("TemplateInfo.plist"))
}

func installMacAppTemplate(_ destination: URL, _ cwlViewsProducts: URL) throws {
	try installAssets(destination)
	try PropertyListSerialization.data(fromPropertyList: macProjectTemplateInfo(cwlViewsProducts), format: .xml, options: 0).write(to: destination.appendingPathComponent("TemplateInfo.plist"))
}

func installMacAppTestsTemplate(_ destination: URL, _ cwlViewsProducts: URL) throws {
	try PropertyListSerialization.data(fromPropertyList: testTemplateInfo(cwlViewsProducts, .macOS), format: .xml, options: 0).write(to: destination.appendingPathComponent("TemplateInfo.plist"))
}

func installCwlViewsTemplate(_ destination: URL, _ cwlViewsProducts: URL) throws {
	try installIcons(destination)
	try PropertyListSerialization.data(fromPropertyList: binderTemplateInfo(), format: .xml, options: 0).write(to: destination.appendingPathComponent("TemplateInfo.plist"))
	try FileManager.default.createDirectory(at: destination.appendingPathComponent("Swift"), withIntermediateDirectories: false, attributes: nil)
	try binderContent().data(using: .utf8)!.write(to: destination.appendingPathComponent("Swift").appendingPathComponent("___FILEBASENAME___.swift"))
}

func installMacPlayground(_ destination: URL, _ cwlViewsProducts: URL) throws {
	try installIcons(destination)
	try PropertyListSerialization.data(fromPropertyList: playgroundTemplateInfo(.macOS), format: .xml, options: 0).write(to: destination.appendingPathComponent("TemplateInfo.plist"))
	
	try FileManager.default.createDirectory(at: destination.appendingPathComponent("___FILEBASENAME___.playground"), withIntermediateDirectories: false, attributes: nil)
	
	let sources = destination.appendingPathComponent("___FILEBASENAME___.playground").appendingPathComponent("Sources")
	try FileManager.default.createDirectory(at: sources, withIntermediateDirectories: false, attributes: nil)
	try cwlUtilsContent(cwlViewsProducts, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlUtils.swift"))
	try cwlSignalContent(cwlViewsProducts, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlSignal.swift"))
	try cwlViewsCoreContent(cwlViewsProducts, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlViewsCore.swift"))
	try cwlViewsContent(cwlViewsProducts, .macOS, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlViews_macOS.swift"))
	
	try macPlaygroundContent().data(using: .utf8)!.write(to: destination.appendingPathComponent("___FILEBASENAME___.playground").appendingPathComponent("Contents.swift"))
	try xcplaygroundContent(.macOS).data(using: .utf8)!.write(to: destination.appendingPathComponent("___FILEBASENAME___.playground").appendingPathComponent("contents.xcplayground"))
}

func installIosPlayground(_ destination: URL, _ cwlViewsProducts: URL) throws {
	try installIcons(destination)
	try PropertyListSerialization.data(fromPropertyList: playgroundTemplateInfo(.iOS), format: .xml, options: 0).write(to: destination.appendingPathComponent("TemplateInfo.plist"))
	
	try FileManager.default.createDirectory(at: destination.appendingPathComponent("___FILEBASENAME___.playground"), withIntermediateDirectories: false, attributes: nil)
	
	let sources = destination.appendingPathComponent("___FILEBASENAME___.playground").appendingPathComponent("Sources")
	try FileManager.default.createDirectory(at: sources, withIntermediateDirectories: false, attributes: nil)
	try cwlUtilsContent(cwlViewsProducts, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlUtils.swift"))
	try cwlSignalContent(cwlViewsProducts, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlSignal.swift"))
	try cwlViewsCoreContent(cwlViewsProducts, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlViewsCore.swift"))
	try cwlViewsContent(cwlViewsProducts, .iOS, internal: false).data(using: .utf8)!.write(to: sources.appendingPathComponent("CwlViews_iOS.swift"))
	
	try iOSPlaygroundContent().data(using: .utf8)!.write(to: destination.appendingPathComponent("___FILEBASENAME___.playground").appendingPathComponent("Contents.swift"))
	try xcplaygroundContent(.iOS).data(using: .utf8)!.write(to: destination.appendingPathComponent("___FILEBASENAME___.playground").appendingPathComponent("contents.xcplayground"))
}

enum Platform: String {
	case macOS
	case iOS
	
	var isIos: Bool {
		switch self {
		case .macOS: return false
		case .iOS: return true
		}
	}
}

func iOSLaunchScreenStoryboard() -> String {
	return #"""
		<?xml version="1.0" encoding="UTF-8"?>
		<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="13189.4" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
			 <device id="retina4_7" orientation="portrait">
					<adaptation id="fullscreen"/>
			 </device>
			 <dependencies>
					<deployment identifier="iOS"/>
					<plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="13165.3"/>
					<capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
			 </dependencies>
			 <scenes>
					<!--View Controller-->
					<scene sceneID="EHf-IW-A2E">
						<objects>
							 <viewController id="01J-lp-oVM" sceneMemberID="viewController">
									<layoutGuides>
										<viewControllerLayoutGuide type="top" id="Llm-lL-Icb"/>
										<viewControllerLayoutGuide type="bottom" id="xb3-aO-Qok"/>
									</layoutGuides>
									<view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
										<rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
										<autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
										<subviews>
											 <view contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO" id="Ilo-2J-HnV">
													<rect key="frame" x="0.0" y="0.0" width="375" height="20"/>
													<color key="backgroundColor" red="0.58671200275421143" green="0.45805174112319946" blue="0.40488135814666748" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
											 </view>
											 <navigationBar contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO" id="KER-g4-TUS">
													<rect key="frame" x="0.0" y="20" width="375" height="44"/>
													<color key="barTintColor" red="0.52133625745773315" green="0.36783450841903687" blue="0.30591660737991333" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
													<textAttributes key="titleTextAttributes">
														<color key="textColor" red="1" green="1" blue="1" alpha="1" colorSpace="calibratedRGB"/>
													</textAttributes>
													<items>
														<navigationItem title="Hello, world!" id="hxk-eu-Ttl">
															 <barButtonItem key="rightBarButtonItem" title="•••" id="2pN-zF-GVh">
																	<color key="tintColor" red="0.24383053183555603" green="0.25354817509651184" blue="0.33036026358604431" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
															 </barButtonItem>
														</navigationItem>
													</items>
											 </navigationBar>
										</subviews>
										<color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="calibratedRGB"/>
										<constraints>
											 <constraint firstItem="KER-g4-TUS" firstAttribute="top" secondItem="Ilo-2J-HnV" secondAttribute="bottom" id="1ny-Xm-OFA"/>
											 <constraint firstItem="Ilo-2J-HnV" firstAttribute="leading" secondItem="Ze5-6b-2t3" secondAttribute="leading" id="9JC-Jz-GFc"/>
											 <constraint firstAttribute="trailing" secondItem="Ilo-2J-HnV" secondAttribute="trailing" id="DDd-fW-xa1"/>
											 <constraint firstItem="KER-g4-TUS" firstAttribute="leading" secondItem="Ze5-6b-2t3" secondAttribute="leading" id="FyK-f0-tSm"/>
											 <constraint firstItem="KER-g4-TUS" firstAttribute="top" secondItem="Llm-lL-Icb" secondAttribute="bottom" id="OJG-f1-aCz"/>
											 <constraint firstAttribute="trailing" secondItem="KER-g4-TUS" secondAttribute="trailing" id="U58-DS-ymh"/>
											 <constraint firstItem="Ilo-2J-HnV" firstAttribute="top" secondItem="Ze5-6b-2t3" secondAttribute="top" id="dXy-B8-7Ws"/>
										</constraints>
									</view>
							 </viewController>
							 <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
						</objects>
						<point key="canvasLocation" x="52" y="374.66266866566718"/>
					</scene>
			 </scenes>
		</document>
		"""#
}

func frameworkDefinition(_ name: String, _ targetIdentifier: String) -> [String: Any] {
	return [
		"Group": "Dependencies",
		"TargetIdentifiers": [
			targetIdentifier
		] as [Any],
		"PathType": "BuildProduct",
		"Path": "\(name).framework"
	] as [String: Any]
}

func binderContent() -> String {
	return #"""
		//
		//  ___FILENAME___
		//  ___PROJECTNAME___
		//
		//  Created by ___FULLUSERNAME___ on ___DATE___.
		//  ___COPYRIGHT___
		//

		#if os(macOS)
			import AppKit
		#else
			import UIKit
		#endif

		import CwlViews
		
		// MARK: - Binder Part 1: Binder
		public class ___VARIABLE_basename___: Binder, ___VARIABLE_basename___Convertible {
			public var state: BinderState<Preparer>
			public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
				state = .pending(type: type, parameters: parameters, bindings: bindings)
			}
		}
		
		// MARK: - Binder Part 2: Binding
		public extension ___VARIABLE_basename___ {
			enum Binding: ___VARIABLE_basename___Binding {
				case inheritedBinding(Preparer.Inherited.Binding)
				
				// 0. Static bindings are applied at construction and are subsequently immutable.
				/* case someProperty(Constant<PropertyType>) */

				// 1. Value bindings may be applied at construction and may subsequently change.
				/* case someProperty(Dynamic<PropertyType>) */

				// 2. Signal bindings are performed on the object after construction.
				/* case someFunction(Signal<FunctionParametersAsTuple>) */

				// 3. Action bindings are triggered by the object after construction.
				/* case someAction(SignalInput<CallbackParameters>) */

				// 4. Delegate bindings require synchronous evaluation within the object's context.
				/* case someDelegateFunction((Param) -> Result)) */
			}
		}

		// MARK: - Binder Part 3: Preparer
		public extension ___VARIABLE_basename___ {
			struct Preparer: BinderEmbedderConstructor /* or BinderDelegateEmbedderConstructor */ {
				public typealias Binding = ___VARIABLE_basename___.Binding
				public typealias Inherited = ___VARIABLE_linkedBasename___.Preparer
				public typealias Instance = ___VARIABLE_platformPrefix______VARIABLE_basename___
				
				/*
				// If instance construction requires parameters, uncomment this
				public typealias Parameters = (paramOne, paramTwo)
				*/
				
				public var inherited = Inherited()
				public init() {}
				
				/*
				// If Preparer is BinderDelegateEmbedderConstructor, use these instead of the `init` on the previous line
				public var dynamicDelegate: Delegate? = nil
				public let delegateClass: Delegate.Type
				public init(delegateClass: Delegate.Type) {
					self.delegateClass = delegateClass
				}
				*/
				
				public func constructStorage(instance: Instance) -> Storage { return Storage() }
				public func inheritedBinding(from: Binding) -> Inherited.Binding? {
					if case .inheritedBinding(let b) = from { return b } else { return nil }
				}
			}
		}

		// MARK: - Binder Part 4: Preparer overrides
		public extension ___VARIABLE_basename___.Preparer {
			/* If instance construction requires parameters, uncomment this
			func constructInstance(type: Instance.Type, parameters: Preparer.Parameters) -> Instance {
				return type.init(paramOne: parameters.0, paramTwo: parameters.1)
			}
			*/
		
			/* Enable if delegate bindings used or setup prior to other bindings required 
			mutating func prepareBinding(_ binding: Binding) {
				switch binding {
				case .inheritedBinding(let x): inherited.prepareBinding(x)
				case .someDelegate(let x): delegate().addMultiHandler(x, #selector(someDelegateFunction))
				default: break
				}
			}
			*/
		
			func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
				switch binding {
				case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
				/* All bindings should have an "apply" (although some might simply return nil). Here are some typical examples... */
				/* case .someStatic(let x): instance.someStatic = x.value */
				/* case .someProperty(let x): return x.apply(instance) { i, v in i.someProperty = v } */
				/* case .someSignal(let x): return x.apply(instance) { i, v in i.something(v) } */
				/* case .someAction(let x): return instance.addListenerAndReturnLifetime(x) */
				/* case .someDelegate(let x): return nil */
				}
			}
		}
		
		// MARK: - Binder Part 5: Storage and Delegate
		extension ___VARIABLE_basename___.Preparer {
			public typealias Storage = ___VARIABLE_linkedBasename___.Preparer.Storage
			/*
			// Use instead of previous line if additional runtime storage is required
			open class Storage: ___VARIABLE_linkedBasename___.Preparer.Storage {}
			*/
			
			/*
			// Enable if Preparer is BinderDelegateEmbedderConstructor
			open class Delegate: DynamicDelegate, ___VARIABLE_platformPrefix______VARIABLE_basename___Delegate {
				open func someDelegateFunction(_ ___VARIABLE_lowercaseBasename___: ___VARIABLE_platformPrefix______VARIABLE_basename___Delegate) -> Bool {
					return singleHandler(___VARIABLE_lowercaseBasename___)
				}
			}
			*/
		}
		
		// MARK: - Binder Part 6: BindingNames
		extension BindingName where Binding: ___VARIABLE_basename___Binding {
			public typealias ___VARIABLE_basename___Name<V> = BindingName<V, ___VARIABLE_basename___.Binding, Binding>
					private static func name<V>(_ source: @escaping (V) -> ___VARIABLE_basename___.Binding) -> ___VARIABLE_basename___Name<V> {
				return ___VARIABLE_basename___Name<V>(source: source, downcast: Binding.___VARIABLE_lowercaseBasename___Binding)
			}
		}
		public extension BindingName where Binding: ___VARIABLE_basename___Binding {
			// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
			// Replace: case ([^\(]+)\((.+)\)$
			// With:    static var $1: ___VARIABLE_basename___Name<$2> { return .name(___VARIABLE_basename___.Binding.$1) }
		}
		
		// MARK: - Binder Part 7: Convertible protocols (if constructible)
		public protocol ___VARIABLE_basename___Convertible: ___VARIABLE_linkedBasename___Convertible {
			func ___VARIABLE_lowercasePlatformPrefix______VARIABLE_basename___() -> ___VARIABLE_basename___.Instance
		}
		extension ___VARIABLE_basename___Convertible {
			public func ___VARIABLE_lowercasePlatformPrefix______VARIABLE_linkedBasename___() -> ___VARIABLE_linkedBasename___.Instance { return ___VARIABLE_lowercasePlatformPrefix______VARIABLE_basename___() }
		}
		extension ___VARIABLE_platformPrefix______VARIABLE_basename___: ___VARIABLE_basename___Convertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
			public func ___VARIABLE_lowercasePlatformPrefix______VARIABLE_basename___() -> ___VARIABLE_basename___.Instance { return self }
		}
		public extension ___VARIABLE_basename___ {
			func ___VARIABLE_lowercasePlatformPrefix______VARIABLE_basename___() -> ___VARIABLE_basename___.Instance { return instance() }
		}

		// MARK: - Binder Part 8: Downcast protocols
		public protocol ___VARIABLE_basename___Binding: ___VARIABLE_linkedBasename___Binding {
			static func ___VARIABLE_lowercaseBasename___Binding(_ binding: ___VARIABLE_basename___.Binding) -> Self
			func as___VARIABLE_basename___Binding() -> ___VARIABLE_basename___.Binding?
		}
		public extension ___VARIABLE_basename___Binding {
			static func ___VARIABLE_lowercaseLinkedBasename___Binding(_ binding: ___VARIABLE_linkedBasename___.Binding) -> Self {
				return ___VARIABLE_lowercaseBasename___Binding(.inheritedBinding(binding))
			}
		}
		public extension ___VARIABLE_basename___.Binding {
			typealias Preparer = ___VARIABLE_basename___.Preparer
			static func ___VARIABLE_lowercaseBasename___Binding(_ binding: ___VARIABLE_basename___.Binding) -> ___VARIABLE_basename___.Binding {
				return binding
			}
		}

		// MARK: - Binder Part 9: Other supporting types
		
		// MARK: - Binder Part 10: Test support
		extension BindingParser where Downcast: ___VARIABLE_basename___Binding {
			// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
			// Replace: case ([^\(]+)\((.+)\)$
			// With:    public static var $1: BindingParser<$2, ___VARIABLE_basename___.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.as___VARIABLE_basename___Binding() }) }
		
		}
		"""#
}

func binderTemplateInfo() -> [String: Any] {
	return [
		"Options": [
			[
				"Description": "This is the name use for the \"struct\" type and the base used for the protocols.",
				"Identifier": "basename",
				"Name": "Binder name:",
				"Required": 1 as NSNumber,
				"Type": "text",
				"NotPersisted": 1 as NSNumber,
				"Default": "ViewSubclass"
			] as [String: Any],
			[
				"Description": "EnclosingBinder name with lowercase initial letter used for function names.",
				"Identifier": "lowercaseBasename",
				"Name": "Name with lowercase initial:",
				"Required": 1 as NSNumber,
				"Type": "text",
				"NotPersisted": 1 as NSNumber,
				"Default": "viewSubclass"
			] as [String: Any],
			[
				"Description": "The platform prefix.",
				"Identifier": "platformPrefix",
				"Name": "Platform prefix:",
				"Required": 1 as NSNumber,
				"Type": "text",
				"NotPersisted": 1 as NSNumber,
				"Default": "NS"
			] as [String: Any],
			[
				"Description": "The lowercased platform prefix.",
				"Identifier": "lowercasePlatformPrefix",
				"Name": "Lowercase platform prefix:",
				"Required": 1 as NSNumber,
				"Type": "text",
				"NotPersisted": 1 as NSNumber,
				"Default": "ns"
			] as [String: Any],
			[
				"Description": "The previous binder in the inheritance chain (the binder for the Instance's superclass or `BaseBinder`).",
				"Identifier": "linkedBasename",
				"Name": "Inherited binder:",
				"Required": 1 as NSNumber,
				"Type": "text",
				"NotPersisted": 1 as NSNumber,
				"Default": "View"
			] as [String: Any],
			[
				"Description": "The lowercase prefixed version of the previous binding in the inheritance chain.",
				"Identifier": "lowercaseLinkedBasename",
				"Name": "Inherited with lowercase initial:",
				"Required": 1 as NSNumber,
				"Type": "text",
				"NotPersisted": 1 as NSNumber,
				"Default": "view"
			] as [String: Any],
			[
				"Description": "The implementation language",
				"AllowedTypes": [
					"Swift": [
						"public.swift-source"
					] as [Any]
				] as [String: Any],
				"MainTemplateFiles": [
					"Swift": "___FILEBASENAME___.swift"
				] as [String: Any],
				"Identifier": "languageChoice",
				"Name": "Language:",
				"Values": [
					"Swift"
				] as [Any],
				"Required": 1 as NSNumber,
				"Type": "popup",
				"Default": "Swift"
			] as [String: Any]
		] as [Any],
		"Summary": "An implementation of a CwlViews binder cluster.",
		"DefaultCompletionName": "MyView",
		"Platforms": [
			"com.apple.platform.iphoneos",
			"com.apple.platform.macosx"
		] as [Any],
		"Kind": "Xcode.IDEFoundation.TextSubstitutionFileTemplateKind",
		"SortOrder": "1",
		"Description": "An implementation of a CwlViews binder cluster."
	] as [String: Any]
}

func macProjectTemplateInfo(_ cwlViewsProducts: URL) throws -> [String: Any] {
	return [
		"Kind": "Xcode.Xcode3.ProjectTemplateUnitKind",
		"Identifier": "com.cocoawithlove.views-app-macOS",
		"Ancestors": [
			"com.apple.dt.unit.cocoaApplicationBase",
			"com.apple.dt.unit.osxBase"
		] as [Any],
		"Targets": projectTargets(.macOS),
		"SortOrder": 1 as NSNumber,
		"Project": [
			"SDK": "macosx",
		] as [String: Any],
		"Options": projectOptions(.macOS),
		"Name": "CwlViews",
		"Description": "Creates an AppKit Mac application using the CwlViews framework.",
		"Concrete": 1 as NSNumber,
		"Platforms": [
			"com.apple.platform.macosx"
		] as [Any],
		"Nodes": [
			"main.swift:comments",
			"main.swift:imports:importAppKit",
			"main.swift:content",
			"Services.swift:comments",
			"Services.swift:imports:importFoundation",
			"Services.swift:content",
			"Model/Document.swift:comments",
			"Model/Document.swift:imports:importFoundation",
			"Model/Document.swift:content",
			"Model/DocumentAdapter.swift:comments",
			"Model/DocumentAdapter.swift:imports:importFoundation",
			"Model/DocumentAdapter.swift:content",
			"View/Window.swift:comments",
			"View/Window.swift:imports:importAppKit",
			"View/Window.swift:content",
			"View/DetailView.swift:comments",
			"View/DetailView.swift:imports:importAppKit",
			"View/DetailView.swift:content",
			"View/MainMenu.swift:comments",
			"View/MainMenu.swift:imports:importAppKit",
			"View/MainMenu.swift:content",
			"Dependencies/CwlUtils.swift",
			"Dependencies/CwlSignal.swift",
			"Dependencies/CwlViewsCore.swift",
			"Dependencies/CwlViews_macOS.swift",
			"Assets.xcassets",
			"Info.plist:Icon",
			"Info.plist:DeploymentTarget",
			"Info.plist:PrincipalClass",
			"Info.plist:NSHumanReadableCopyright",
		] as [Any],
		"Definitions": [
			"Assets.xcassets": [
				"Path": "Images.xcassets",
				"AssetGeneration": [
					[
						"Type": "appicon",
						"Name": "AppIcon",
						"Platforms": [
							"macOS": "true"
							] as [String: Any]
						] as [String: Any]
					] as [Any],
				"SortOrder": 100,
				] as [String: Any],
			"Info.plist:DeploymentTarget": "<key>LSMinimumSystemVersion</key><string>$(MACOSX_DEPLOYMENT_TARGET)</string>",
			"Info.plist:PrincipalClass": "<key>NSPrincipalClass</key><string>NSApplication</string>",
			"Info.plist:Icon": "<key>CFBundleIconFile</key><string>NSApplication</string>",
			"Info.plist:MainNib": "",
			"*:imports:importFoundation": "import Foundation",
			"*:imports:importAppKit": "import AppKit",
			"main.swift:content": macMainContent(),
			"Model/DocumentAdapter.swift": ["Group": "Model"] as [String: Any],
			"Model/DocumentAdapter.swift:content": documentAdapterContent(),
			"Model/Document.swift": ["Group": "Model"] as [String: Any],
			"Model/Document.swift:content": documentContent(),
			"View/MainMenu.swift": ["Group": "View"] as [String: Any],
			"View/MainMenu.swift:content": macMainMenuContent(),
			"View/Window.swift": ["Group": "View"] as [String: Any],
			"View/Window.swift:content": macMainWindowContent(),
			"View/DetailView.swift": ["Group": "View"] as [String: Any],
			"View/DetailView.swift:content": macDetailContent(),
			"Services.swift:content": servicesContent(),
			"Dependencies/CwlUtils.swift": [
				"Beginning": try cwlUtilsContent(cwlViewsProducts, internal: true),
				"Group": "Dependencies"
			] as [String: Any],
			"Dependencies/CwlSignal.swift": [
				"Beginning": try cwlSignalContent(cwlViewsProducts, internal: true),
				"Group": "Dependencies"
			] as [String: Any], 
			"Dependencies/CwlViewsCore.swift": [
				"Beginning": try cwlViewsCoreContent(cwlViewsProducts, internal: true),
				"Group": "Dependencies"
			] as [String: Any],
			"Dependencies/CwlViews_macOS.swift": [
				"Beginning": try cwlViewsContent(cwlViewsProducts, .macOS, internal: true),
				"Group": "Dependencies"
			] as [String: Any]
		] as [String: Any]
	] as [String: Any]
}

func playgroundTemplateInfo(_ platform: Platform) throws -> [String: Any] {
	return [
		"Kind": "Xcode.IDEFoundation.TextSubstitutionPlaygroundTemplateKind",
		"Name": "CwlViews",
		"Summary": "An \(platform.isIos ? "iOS" : "macOS") Playground",
		"Description": "An interactive environment for experimenting with CwlViews",
		"SortOrder": "20",
		"MainTemplateFile": "___FILEBASENAME___.playground",
		"AllowedTypes": [
			"com.apple.dt.playground"
		] as [Any],
		"DefaultCompletionName": "MyPlayground",
		"Platforms": [
			"com.apple.platform.\(platform.isIos ? "iphoneos" : "macosx")"
		] as [Any]
	]
}

func testTemplateInfo(_ cwlViewsProducts: URL, _ platform: Platform) throws -> [String: Any] {
	return [
		"Kind": "Xcode.Xcode3.ProjectTemplateUnitKind",
		"Identifier": "com.cocoawithlove.views-unit.cocoa\(platform.isIos ? "Touch" : "")ApplicationUnitTestBundle",
		"Ancestors": [
			"com.apple.dt.unit.\(platform.isIos ? "ios" : "osx")UnitTestBundleBase"
		] as [Any],
		"Targets": [
			[
				"TargetIdentifier": "com.apple.dt.cocoa\(platform.isIos ? "Touch" : "")ApplicationUnitTestBundleTarget",
				"TargetIdentifierToBeTested": "com.apple.dt.cocoa\(platform.isIos ? "Touch" : "")ApplicationTarget",
			] as [String: Any],
		] as [Any],
		"Nodes": [
			"CwlViews_\(platform.rawValue)Testing.swift:comments",
			"CwlViews_\(platform.rawValue)Testing.swift:imports:importProject",
			"CwlViews_\(platform.rawValue)Testing.swift:content",
			"MockServices.swift:comments",
			"MockServices.swift:imports:importProject",
			"MockServices.swift:content",
			"TableViewTests.swift:comments",
			"TableViewTests.swift:imports:importProject",
			"TableViewTests.swift:content"
		] as [Any],
		"Definitions": [
			"*:imports:importProject": "@testable import ___VARIABLE_productName:identifier___",
			"CwlViews_\(platform.rawValue)Testing.swift:content": try cwlViewsTesting(cwlViewsProducts, platform, internal: false),
			"MockServices.swift:content": mockServices(),
			"TableViewTests.swift:content": platform.isIos ? iOSTableViewTests() : macOSTableViewTests()
		] as [String: Any]
	] as [String: Any]
}

func iOSProjectTemplateInfo(_ cwlViewsProducts: URL) throws -> [String: Any] {
	return [
		"Identifier": "com.cocoawithlove.views-app-iOS",
		"Kind": "Xcode.Xcode3.ProjectTemplateUnitKind",
		"Targets": projectTargets(.iOS),
		"SortOrder": 1 as NSNumber,
		"Ancestors": [
			"com.apple.dt.unit.applicationBase",
			"com.apple.dt.unit.iosBase"
		] as [Any],
		"Options": projectOptions(.iOS),
		"Name": "CwlViews",
		"Description": "Creates a UIKit iOS application using the CwlViews framework.",
		"Nodes": [
			"main.swift:comments",
			"main.swift:imports:importUIKit",
			"main.swift:content",
			"Services.swift:comments",
			"Services.swift:imports:importFoundation",
			"Services.swift:content",
			"Model/Document.swift:comments",
			"Model/Document.swift:imports:importFoundation",
			"Model/Document.swift:content",
			"Model/DocumentAdapter.swift:comments",
			"Model/DocumentAdapter.swift:imports:importUIKit",
			"Model/DocumentAdapter.swift:content",
			"View/NavView.swift:comments",
			"View/NavView.swift:imports:importUIKit",
			"View/NavView.swift:content",
			"View/TableView.swift:comments",
			"View/TableView.swift:imports:importUIKit",
			"View/TableView.swift:content",
			"View/DetailView.swift:comments",
			"View/DetailView.swift:imports:importUIKit",
			"View/DetailView.swift:content",
			"Dependencies/CwlUtils.swift",
			"Dependencies/CwlSignal.swift",
			"Dependencies/CwlViewsCore.swift",
			"Dependencies/CwlViews_iOS.swift",
			"Base.lproj/LaunchScreen.storyboard",
			"Assets.xcassets",
			"Info.plist:iPhone",
			"Info.plist:UIRequiredDeviceCapabilities:base",
			"Info.plist:LaunchScreen",
		] as [Any],
		"Concrete": 1 as NSNumber,
		"Platforms": [
			"com.apple.platform.iphoneos"
		] as [Any],
		"Definitions": [
			"Base.lproj/LaunchScreen.storyboard": [
				"TargetIdentifiers": [],
				"Path": "LaunchScreen.storyboard"
			] as [String: Any],
			"Info.plist:UIRequiredDeviceCapabilities": [
				"End": "</array>",
				"Beginning": """
					<key>UIRequiredDeviceCapabilities</key>
					<array>
					""",
				"Indent": 1 as NSNumber
			] as [String: Any],
			"Info.plist:UISupportedInterfaceOrientations~iPad": """
				<key>UISupportedInterfaceOrientations~ipad</key>
				<array>
					<string>UIInterfaceOrientationPortrait</string>
					<string>UIInterfaceOrientationPortraitUpsideDown</string>
					<string>UIInterfaceOrientationLandscapeLeft</string>
					<string>UIInterfaceOrientationLandscapeRight</string>
				</array>
				""",
			"Info.plist:UIRequiredDeviceCapabilities:base": "<string>armv7</string>",
			"Info.plist:statusBarTintForNavBar": """
				<key>UIStatusBarTintParameters</key>
				<dict>
					<key>UINavigationBar</key>
					<dict>
						<key>Binding</key>
						<string>UIBarStyleDefault</string>
						<key>Translucent</key>
						<false/>
					</dict>
				</dict>
				""",
			"Info.plist:iPhone": """
				<key>LSRequiresIPhoneOS</key>
				<true/>
				""",
			"Info.plist:UISupportedInterfaceOrientations~iPhone": """
				<key>UISupportedInterfaceOrientations</key>
				<array>
					<string>UIInterfaceOrientationPortrait</string>
					<string>UIInterfaceOrientationLandscapeLeft</string>
					<string>UIInterfaceOrientationLandscapeRight</string>
				</array>
				""",
			"Info.plist:LaunchScreen": """
				<key>UILaunchStoryboardName</key>
				<string>LaunchScreen</string>
				""",
			"Assets.xcassets": [
				"Path": "Images.xcassets",
				"AssetGeneration": [
					[
						"Type": "appicon",
						"Name": "AppIcon",
						"Platforms": [
							"iOS": "true"
						] as [String: Any]
					] as [String: Any]
				] as [Any]
			] as [String: Any],
			"*:imports:importFoundation": "import Foundation",
			"*:imports:importUIKit": "import UIKit",
			"main.swift:content": iOSMainContent(),
			"Services.swift:content": servicesContent(),
			"View/NavView.swift": ["Group": "View"] as [String: Any],
			"View/NavView.swift:content": iOSNavViewContent(),
			"View/TableView.swift": ["Group": "View"] as [String: Any],
			"View/TableView.swift:content": iOSTableViewContent(),
			"View/DetailView.swift": ["Group": "View"] as [String: Any],
			"View/DetailView.swift:content": iOSDetailViewContent(),
			"Model/DocumentAdapter.swift": ["Group": "Model"] as [String: Any],
			"Model/DocumentAdapter.swift:content": documentAdapterContent(),
			"Model/Document.swift": ["Group": "Model"] as [String: Any],
			"Model/Document.swift:content": documentContent(),
			"Dependencies/CwlUtils.swift": [
				"Beginning": try cwlUtilsContent(cwlViewsProducts, internal: true),
				"Group": "Dependencies"
			] as [String: Any],
			"Dependencies/CwlSignal.swift": [
				"Beginning": try cwlSignalContent(cwlViewsProducts, internal: true),
				"Group": "Dependencies"
			] as [String: Any], 
			"Dependencies/CwlViewsCore.swift": [
				"Beginning": try cwlViewsCoreContent(cwlViewsProducts, internal: true),
				"Group": "Dependencies"
			] as [String: Any],
			"Dependencies/CwlViews_iOS.swift": [
				"Beginning": try cwlViewsContent(cwlViewsProducts, .iOS, internal: true),
				"Group": "Dependencies"
			] as [String: Any]
		] as [String: Any],
	] as [String: Any]
}

func projectOptions(_ platform: Platform) -> [Any] {
	return [
		[
			"Description": "The implementation language",
			"Identifier": "languageChoice",
			"Name": "Language:",
			"Values": [
				"Swift"
			] as [Any],
			"Required": 1 as NSNumber,
			"Type": "popup",
			"Variables": [
				"Swift": [
					"moduleNamePrefixForClasses": "$(PRODUCT_MODULE_NAME).",
					"ibCustomModuleProvider": "target"
				] as [String: Any]
			] as [String: Any],
			"Default": "Swift"
		] as [String: Any],
		[
			"Units": [
				"true": [
					"Components": [
						[
							"Name": "___PACKAGENAME___Tests",
							"Identifier": "com.cocoawithlove.views-unit.cocoa\(platform.isIos ? "Touch" : "")ApplicationUnitTestBundle"
						] as [String: Any]
					] as [Any]
				] as [String: Any]
			] as [String: Any],
			"Identifier": "hasUnitTests",
			"Name": "Include Unit Tests",
			"SortOrder": 100 as NSNumber,
			"Type": "checkbox",
			"NotPersisted": 0 as NSNumber,
			"Default": "true"
		] as [String: Any],
		[
			"Units": [
				"true": [
					"Components": [
						[
							"Name": "___PACKAGENAME___UITests",
							"Identifier": "com.apple.dt.unit.cocoa\(platform.isIos ? "Touch" : "")ApplicationUITestBundle"
						] as [String: Any]
					] as [Any]
				] as [String: Any]
			] as [String: Any],
			"Identifier": "hasUITests",
			"Name": "Include UI Tests",
			"SortOrder": 101 as NSNumber,
			"Type": "checkbox",
			"NotPersisted": 0 as NSNumber,
			"Default": "true"
		] as [String: Any]
	] as [Any]
}

func projectTargets(_ platform: Platform) -> [Any] {
	return [
		[
			"TargetIdentifier": "com.apple.dt.cocoa\(platform.isIos ? "Touch" : "")ApplicationTarget",
			"SharedSettings": [
				"ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
				"COMBINE_HIDPI_IMAGES": "YES",
				"LD_RUNPATH_SEARCH_PATHS": "$(inherited) @executable_path/Frameworks",
				"TARGETED_DEVICE_FAMILY": "1,2"
			] as [String: Any]
		] as [String: Any]
	] as [Any]
}

func iOSMainContent() -> String {
	return #"""
		func application(_ viewVar: Var<NavViewState>, _ doc: DocumentAdapter) -> Application {
			return Application(
				.window -- Window(
					.rootViewController <-- viewVar.map { navState in
						navViewController(navState, doc)
					}
				),
				.didEnterBackground -- { _ in doc.input.send(Document.Action.save) },
				.willEncodeRestorableState -- viewVar.storeToArchive(),
				.didDecodeRestorableState -- viewVar.loadFromArchive()
			)
		}

		private let services = Services(fileService: FileManager.default)
		private let doc = DocumentAdapter(document: Document(services: services))
		private let viewVar = Var(NavViewState())

		#if DEBUG
			let docLog = doc.logJson(keyPath: \.contents, prefix: "Document changed: ")
			let viewLog = viewVar.logJson(prefix: "View-state changed: ")
		#endif

		applicationMain { application(viewVar, doc) }
		"""#
}

func iOSNavViewContent() -> String {
	return #"""
		typealias NavPathElement = MasterDetail<TableViewState, DetailViewState>
		struct NavViewState: CodableContainer {
			let navStack: StackAdapter<NavPathElement>
			init () {
				navStack = StackAdapter([.master(TableViewState())])
			}
			var childCodableContainers: [CodableContainer] { return [navStack] }
		}

		func navViewController(_ navState: NavViewState, _ doc: DocumentAdapter) -> ViewControllerConvertible {
			return NavigationController(
				.stack <-- navState.navStack.stackMap { element in
					switch element {
					case .master(let tableState):
						return tableViewController(tableState, navState, doc)
					case .detail(let detailState):
						return detailViewController(detailState, doc)
					}
				},
				.poppedToCount --> navState.navStack.popToCount(),
				.navigationBar -- NavigationBar(
					.barTintColor -- .barTint,
					.titleTextAttributes -- [.foregroundColor: UIColor.white],
					.tintColor -- .barText
				)
			)
		}

		fileprivate extension UIColor {
			static let barTint = UIColor(red: 0.521, green: 0.368, blue: 0.306, alpha: 1)
			static let barText = UIColor(red: 0.244, green: 0.254, blue: 0.330, alpha: 1)
		}
		"""#
}

func iOSTableViewContent() -> String {
	return #"""
		struct TableViewState: CodableContainer {
			let isEditing: Var<Bool>
			let firstRow: Var<IndexPath>
			let selection: TempVar<TableRow<String>>
			
			init() {
				isEditing = Var(false)
				firstRow = Var(IndexPath(row: 0, section: 0))
				selection = TempVar()
			}
			var childCodableContainers: [CodableContainer] { return [isEditing, firstRow] }
		}

		func tableViewController(_ tableState: TableViewState, _ navState: NavViewState, _ doc: DocumentAdapter) -> ViewControllerConvertible {
			return ViewController(
				.lifetimes -- [
					tableState.selection
						.compactMap { $0.data }
						.map { .detail(DetailViewState(row: $0)) }
						.cancellableBind(to: navState.navStack.push())
				],
				.navigationItem -- navItem(tableState: tableState, doc: doc),
				.view -- TableView<String>(
					.cellIdentifier -- { row in .textRowIdentifier },
					.cellConstructor -- { reuseIdentifier, cellData in
						return TableViewCell(
							.textLabel -- Label(
								.text <-- cellData.map { .localizedStringWithFormat(.rowText, $0) }
							)
						)
					},
					.tableData <-- doc.rowsSignal().tableData(),
					.rowSelected() --> tableState.selection,
					.deselectRow <-- tableState.selection
						.debounce(interval: .milliseconds(250), context: .main)
						.map { .animate($0.indexPath) },
					.isEditing <-- tableState.isEditing.animate(),
					.commit(\.tableRow.indexPath.row) --> Input()
						.map { .removeAtIndex($0) }
						.bind(to: doc),
					.userDidScrollToRow --> Input()
						.map { $0.indexPath }
						.bind(to: tableState.firstRow.update()),
					.scrollToRow <-- tableState.firstRow
						.map { .set(.none($0)) },
					.separatorInset -- UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
				)
			)
		}

		func navItem(tableState: TableViewState, doc: DocumentAdapter) -> NavigationItem {
			return NavigationItem(
				.title -- .helloWorld,
				.leftBarButtonItems() <-- tableState.isEditing
					.map { e in
						[BarButtonItem(
							.systemItem -- e ? .done : .edit,
							.action --> Input()
								.map { _ in !e }
								.bind(to: tableState.isEditing)
							)]
				},
				.rightBarButtonItems() -- [BarButtonItem(
					.systemItem -- .add,
					.action --> Input()
						.map { _ in .add }
						.bind(to: doc)
					)]
			)
		}

		private extension String {
			static let textRowIdentifier = "TextRow"
			static let rowText = NSLocalizedString("This is row #%@", comment: "")
			static let helloWorld = NSLocalizedString("Hello, world!", comment: "")
		}
		"""#
}

func iOSDetailViewContent() -> String {
	return #"""
		struct DetailViewState: CodableContainer {
			let row: String
		}

		func detailViewController(_ detailState: DetailViewState, _ doc: DocumentAdapter) -> ViewControllerConvertible {
			return ViewController(
				.title -- .localizedStringWithFormat(.titleText, detailState.row),
				.view -- View(
					.backgroundColor -- .white,
					.layout -- .vertical(align: .center,
						.space(),
						.view(Label(.text -- .localizedStringWithFormat(.detailText, detailState.row))),
						.space(),
						.view(Button(
							.action(.primaryActionTriggered) --> Input().subscribeValuesUntilEnd { print($0) }
						)),
						.space(.fillRemaining)
					)
				)
			)
		}

		private extension String {
			static let titleText = NSLocalizedString("Row #%@", comment: "")
			static let detailText = NSLocalizedString("Detail view for row #%@", comment: "")
		}
		"""#
}

func iOSTableViewTests() -> String {
	return #"""
		import XCTest

		class TableViewTests: XCTestCase {
			
			var services: Services!
			var doc: DocumentAdapter!
			var navState: NavViewState!
			var tableState: TableViewState!
			
			var tableBindings: [TableView<String>.Binding] = []
			var rightBarButtonBindings: [BarButtonItem.Binding] = []
			
			override func setUp() {
				services = Services(fileService: MockFileService())
				doc = DocumentAdapter(document: Document(services: services))
				navState = NavViewState()
				tableState = TableViewState()

				let viewControllerBindings = try! ViewController.consumeBindings(from: tableViewController(tableState, navState, doc))
				let navigationItemBindings = try! NavigationItem.consumeBindings(from: ViewController.constantValue(for: .navigationItem, in: viewControllerBindings))
				rightBarButtonBindings = try! BarButtonItem.consumeBindings(from: NavigationItem.dynamicValue(for: .rightBarButtonItems, in: navigationItemBindings).value.first!)
				tableBindings = try! TableView<String>.consumeBindings(from: ViewController.dynamicValue(for: .view, in: viewControllerBindings))
			}
			
			override func tearDown() {
			}
			
			func testInitialTableRows() throws {
				let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
				XCTAssertEqual(Array(tableState.values?.first?.values ?? []), Document.initialContents().rows)
			}
			
			func testCreateRow() throws {
				let targetAction = try BarButtonItem.argument(for: .action, in: rightBarButtonBindings)
				
				switch targetAction {
				case .singleTarget(let input): input.send(nil)
				default: fatalError()
				}
				
				let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
				XCTAssertEqual(Array(tableState.values?.first?.values ?? []), Document.initialContents().rows + ["4"])
			}
			
			func testDeleteRow() throws {
				let commit = try TableView<String>.argument(for: .commit, in: tableBindings)
				commit(UITableView(), .delete, TableRow<String>(indexPath: IndexPath(row: 0, section: 0), data: "1"))
				
				let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
				var expected = Document.initialContents().rows
				expected.remove(at: 0)
				XCTAssertEqual(Array(tableState.values?.first?.values ?? []), expected)
			}
		}
		"""#
}

func macOSTableViewTests() -> String {
	return #"""
		import XCTest

		class TableViewTests: XCTestCase {
			
			var services: Services!
			var doc: DocumentAdapter!
			var windowState: WindowState!
			
			var tableBindings: [TableView<String>.Binding] = []
			var addButtonBindings: [Button.Binding] = []
			var removeButtonBindings: [Button.Binding] = []
			
			override func setUp() {
				services = Services(fileService: MockFileService())
				doc = DocumentAdapter(document: Document(services: services))
				windowState = WindowState()

				let windowBindings = try! Window.consumeBindings(from: window(windowState, doc))
				let splitViewBindings = try! SplitView.consumeBindings(from: Window.dynamicValue(for: .contentView, in: windowBindings))
				let masterViewBindings = try! View.consumeBindings(from: SplitView.dynamicValue(for: .arrangedSubviews, in: splitViewBindings).values.first!.view)
				let layout = try! View.dynamicValue(for: .layout, in: masterViewBindings)
				let scrollViewBindings = try! ScrollView.consumeBindings(from: layout.view(at: 0)!)
				let clipViewBindings = try! ClipView.consumeBindings(from: ScrollView.dynamicValue(for: .contentView, in: scrollViewBindings))
				let tableView = try! ClipView.dynamicValue(for: .documentView, in: clipViewBindings)!
				
				tableBindings = try! TableView<String>.consumeBindings(from: tableView)
				addButtonBindings = try! Button.consumeBindings(from: layout.view(at: 1)!)
				removeButtonBindings = try! Button.consumeBindings(from: layout.view(at: 2)!)
			}
			
			override func tearDown() {
			}
			
			func testInitialTableRows() throws {
				let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
				XCTAssertEqual(Array(tableState.values?.map { $0 } ?? []), Document.initialContents().rows)
			}
			
			func testCreateRow() throws {
				let targetAction = try! Control.argument(for: .action, in: addButtonBindings)
				
				switch targetAction {
				case .singleTarget(let input): input.send(nil)
				default: fatalError()
				}
				
				let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
				XCTAssertEqual(Array(tableState.values ?? []), Document.initialContents().rows + ["4"])
			}
			
			func testDeleteRow() throws {
				let targetAction = try! Control.argument(for: .action, in: removeButtonBindings)
				
				windowState.rowSelection.set().send(DetailState(index: 0, value: ""))
				
				switch targetAction {
				case .singleTarget(let input): input.send(nil)
				default: fatalError()
				}
				
				let tableState = try TableView<String>.Binding.tableStructure(in: tableBindings)
				var expected = Document.initialContents().rows
				expected.remove(at: 0)

				XCTAssertEqual(Array(tableState.values ?? []), expected)
			}
		}
		"""#
}

func mockServices() -> String {
	return #"""
		import Foundation
		
		class MockFileService: FileService {
			enum FileError: Error {
				case notFound
			}
			static let appSupport = URL(fileURLWithPath: "/Application Support/")
			var files: [URL: Data] = [:]
			
			func applicationSupportURL() throws -> URL {
				return MockFileService.appSupport
			}
			
			func data(contentsOf url: URL) throws -> Data {
				guard let file = files[url] else { throw FileError.notFound }
				return file
			}
			
			func writeData(_ data: Data, to url: URL) throws {
				files[url] = data
			}
			
			func fileExists(at url: URL) -> Bool {
				return files[url] != nil
			}
		}
		"""#
}

func documentAdapterContent() -> String {
	return #"""
		typealias DocumentAdapter = Adapter<ModelState<Document, Document.Action, Document.Change>>
		extension Adapter where State == ModelState<Document, Document.Action, Document.Change> {
			init(document: Document) {
				self.init(adapterState: ModelState(
					async: false,
					initial: document,
					resumer: { model -> Document.Change? in
						.reload
					},
					reducer: { model, message, feedback -> Document.Change? in try? model.apply(message) }
				))
			}
			
			func rowsSignal() -> Signal<TableRowMutation<String>> {
				return slice(resume: .reload) { document, notification -> Signal<TableRowMutation<String>>.Next in
					switch notification {
					case .addedRowIndex(let i): return .value(.inserted(document.contents.rows[i], at: i))
					case .removedRowIndex(let i): return .value(.deleted(at: i))
					case .reload: return .value(.reload(document.contents.rows))
					case .none: return .none
					}
				}
			}
		}
		"""#
}

func documentContent() -> String {
	return #"""
		struct Document {
			struct Contents: Codable {
				var rows: [String]
				var lastAddedIndex: Int
			}
			
			let services: Services
			var contents: Contents
		}

		extension Document {
			enum Action {
				case add
				case save
				case removeAtIndex(Int)
			}
			enum Change {
				case addedRowIndex(Int)
				case removedRowIndex(Int)
				case reload
				case none
			}
			
			func save() throws {
				try services.fileService.writeData(JSONEncoder().encode(contents), to: Document.saveUrl(services: services))	
			}
			
			mutating func apply(_ change: Action) throws -> Change {
				switch change {
				case .add:
					contents.lastAddedIndex += 1
					contents.rows.append(String(describing: contents.lastAddedIndex))
					return .addedRowIndex(contents.rows.count - 1)
				case .removeAtIndex(let i):
					if contents.rows.indices.contains(i) {
						contents.rows.remove(at: i)
						return .removedRowIndex(i)
					}
					return .none
				case .save:
					try save()
					return .none
				}
			}
		}

		extension Document {
			
			init(services: Services) {
				self.services = services
				do {
					let url = try Document.saveUrl(services: services)
					if services.fileService.fileExists(at: url) {
						self.contents = try JSONDecoder().decode(Document.Contents.self, from: services.fileService.data(contentsOf: url))
						return
					}
				} catch {
				}
				
				self.contents = Document.initialContents()
			}
			
			static func initialContents() -> Document.Contents {
				return Document.Contents(rows: ["1", "2", "3"], lastAddedIndex: 3)
			}
			
			static func saveUrl(services: Services) throws -> URL {
				return try services.fileService.applicationSupportURL().appendingPathComponent(.documentFileName)
			}
			
		}

		private extension String {
			static let documentFileName = "document.json"
		}
		"""#
}

func servicesContent() -> String {
	return #"""
		struct Services {
			let fileService: FileService
		}

		protocol FileService {
			func applicationSupportURL() throws -> URL
			func data(contentsOf: URL) throws -> Data
			func writeData(_ data: Data, to: URL) throws
			func fileExists(at: URL) -> Bool
		}

		extension FileManager: FileService {
			func applicationSupportURL() throws -> URL {
				return try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			}
			
			func data(contentsOf url: URL) throws -> Data {
				return try Data(contentsOf: url)
			}
			
			func writeData(_ data: Data, to url: URL) throws {
				try data.write(to: url)
			}
			
			func fileExists(at url: URL) -> Bool {
				var isDirectory: ObjCBool = false
				let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
				return exists && !isDirectory.boolValue
			}
		}
		"""#
}

func cwlUtilsContent(_ cwlViewsProducts: URL, internal i: Bool) throws -> String {
	return try String(contentsOf: cwlViewsProducts.appendingPathComponent(i ? "Concat_internal" : "Concat_public").appendingPathComponent("CwlUtils.swift"), encoding: .utf8)
}

func cwlSignalContent(_ cwlViewsProducts: URL, internal i: Bool) throws -> String {
	return try String(contentsOf: cwlViewsProducts.appendingPathComponent(i ? "Concat_internal" : "Concat_public").appendingPathComponent("CwlSignal.swift"), encoding: .utf8)
}

func cwlViewsCoreContent(_ cwlViewsProducts: URL, internal i: Bool) throws -> String {
	return try String(contentsOf: cwlViewsProducts.appendingPathComponent(i ? "Concat_internal" : "Concat_public").appendingPathComponent("CwlViewsCore.swift"), encoding: .utf8)
}

func cwlViewsContent(_ cwlViewsProducts: URL, _ platform: Platform, internal i: Bool) throws -> String {
	return try String(contentsOf: cwlViewsProducts.appendingPathComponent(i ? "Concat_internal" : "Concat_public").appendingPathComponent("CwlViews_\(platform.rawValue).swift"), encoding: .utf8)
}

func cwlViewsTesting(_ cwlViewsProducts: URL, _ platform: Platform, internal i: Bool) throws -> String {
	return try String(contentsOf: cwlViewsProducts.appendingPathComponent(i ? "Concat_internal" : "Concat_public").appendingPathComponent("CwlViewsTesting_\(platform.rawValue).swift"), encoding: .utf8)
}

func macMainContent() -> String {
	return #"""
		func application(_ windowVar: Var<WindowState>, _ doc: DocumentAdapter) -> Application {
			return Application(
				.mainMenu -- mainMenu(),
				.lifetimes <-- windowVar.map {[
					window($0, doc).nsWindow()
				]},
				.willEncodeRestorableState -- windowVar.storeToArchive(),
				.didDecodeRestorableState -- windowVar.loadFromArchive(),
				.shouldTerminateAfterLastWindowClosed() -- true
			)
		}

		private let services = Services(fileService: FileManager.default)
		private let doc = DocumentAdapter(document: Document(services: services))
		private let windowVar = Var(WindowState())

		#if DEBUG
			let docLog = doc.logJson(keyPath: \.contents, prefix: "Document changed: ")
			let viewLog = windowVar.logJson(prefix: "View-state changed: ")
		#endif

		applicationMain { application(windowVar, doc) }
		"""#
}

func macMainWindowContent() -> String {
	return #"""
		struct WindowState: CodableContainer {
			let rowSelection: Var<DetailState?>
			init() {
				rowSelection = Var(nil)
			}
		}

		func window(_ windowState: WindowState, _ doc: DocumentAdapter) -> WindowConvertible {
			return Window(
				.contentWidth -- 650,
				.contentHeight -- 350,
				.frameAutosaveName -- Bundle.main.bundleIdentifier! + ".window",
				.frameHorizontal -- 15,
				.frameVertical -- 15,
				.styleMask -- [.titled, .resizable, .closable, .miniaturizable],
				.title -- .windowTitle,
				.contentView -- SplitView.verticalThin(
					.autosaveName -- Bundle.main.bundleIdentifier! + ".split",
					.arrangedSubviews -- [
						.subview(
							masterView(windowState, doc),
							holdingPriority: .layoutMid,
							constraints: .equalTo(ratio: 0.3, priority: .layoutLow)
						),
						.subview(
							detailContainer(windowState)
						)
					]
				)
			)
		}

		private func masterView(_ windowState: WindowState, _ doc: DocumentAdapter) -> ViewConvertible {
			return View(
				.layout -- .vertical(
					align: .fill,
					.view(
						length: .fillRemaining,
						TableView<String>.scrollEmbedded(
							.rows <-- doc.rowsSignal().tableData(),
							.focusRingType -- .none,
							.usesAutomaticRowHeights -- true,
							.columns -- [
								TableColumn<String>(
									.title -- .rowsColumnTitle,
									.cellConstructor(cellView)
								)
							],
							.cellSelected() --> Input().map(DetailState.init).bind(to: windowState.rowSelection)
						)
					),
					.space(),
					.horizontal(
						.space(),
						.pair(
							.view(Button(
								.bezelStyle -- .rounded,
								.title -- "Add",
								.action() --> Input().map { .add }.bind(to: doc)
							)),
							.view(Button(
								.bezelStyle -- .rounded,
								.title -- "Remove",
								.isEnabled <-- windowState.rowSelection.map { $0 != nil },
								.action() --> Input()
									.withLatestFrom(windowState.rowSelection)
									.compactMap { detail in (detail?.index).map { .removeAtIndex($0) } }
									.bind(to: doc)
							))
						),
						.space()
					),
					.space()
				)
			)
		}

		private func cellView(_ identifier: NSUserInterfaceItemIdentifier, _ cellData: SignalMulti<String>) -> TableCellViewConvertible {
			return TableCellView(
				.layout -- .inset(
					margins: NSEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
					.view(
						TextField.label(
							.stringValue <-- cellData.map { .rowLabel($0) },
							.font -- .preferredFont(forTextStyle: .label, size: .controlRegular)
						)
					)
				)
			)
		}

		private extension DetailState {
			init?(possibleCell: TableCell<String>?) {
				guard let cell = possibleCell, let data = cell.data else { return nil }
				self.init(index: cell.row, value: data)
			}
		}

		private extension String {
			static func rowLabel(_ row: String) -> String {
				return String.localizedStringWithFormat(NSLocalizedString("Row %@", comment: ""), row)
			}
			
			static let rowsColumnTitle = NSLocalizedString("Rows", comment: "")
			static let windowTitle = NSLocalizedString("My Window", comment: "Window title")
		}
		"""#
}

func macMainMenuContent() -> String {
	return #"""
		import CoreMedia

		func mainMenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(.submenu -- applicationMenu()),
					MenuItem(.submenu -- fileMenu()),
					MenuItem(.submenu -- editMenu()),
					MenuItem(.submenu -- formatMenu()),
					MenuItem(.submenu -- viewMenu()),
					MenuItem(.submenu -- windowsMenu()),
					MenuItem(.submenu -- helpMenu()),
				]
			)
		}

		fileprivate let executableName = (Bundle.main.localizedInfoDictionary?[kCFBundleNameKey as String] as? String) ?? (Bundle.main.localizedInfoDictionary?[kCFBundleExecutableKey as String] as? String) ?? ProcessInfo.processInfo.processName

		func applicationMenu() -> Menu {
			return Menu(
				.systemName -- .apple,
				.title -- executableName,
				.items -- [
					MenuItem(
						.title -- String(format: NSLocalizedString("About %@", tableName: "MainMenu", comment: "Application menu item"), executableName),
						.action --> #selector(NSApplication.orderFrontStandardAboutPanel(_:))
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Preferences…", tableName: "MainMenu", comment: "Application menu item"),
						.keyEquivalent -- ","
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Services", tableName: "MainMenu", comment: "Application menu item"),
						.submenu -- Menu(.systemName -- .services)
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- String(format: NSLocalizedString("Hide %@", tableName: "MainMenu", comment: "Application menu item"), executableName),
						.action --> #selector(NSApplication.hide(_:)),
						.keyEquivalent -- "h"
					),
					MenuItem(
						.title -- NSLocalizedString("Hide Others", tableName: "MainMenu", comment: "Application menu item"),
						.action --> #selector(NSApplication.hideOtherApplications(_:)),
						.keyEquivalent -- "h",
						.keyEquivalentModifierMask -- [.option, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Show All", tableName: "MainMenu", comment: "Application menu item"),
						.action --> #selector(NSApplication.unhideAllApplications(_:))
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- String(format: NSLocalizedString("Quit %@", tableName: "MainMenu", comment: "Application menu item"), executableName),
						.action --> #selector(NSApplication.terminate(_:)),
						.keyEquivalent -- "q"
					)
				]
			)
		}

		func fileMenu() -> Menu {
			return Menu(
				.title -- NSLocalizedString("File", tableName: "MainMenu", comment: "Standard menu title"),
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("New", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSDocumentController.newDocument(_:)),
						.keyEquivalent -- "n"
					),
					MenuItem(
						.title -- NSLocalizedString("Open…", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSDocumentController.openDocument(_:)),
						.keyEquivalent -- "o"
					),
					MenuItem(
						.title -- NSLocalizedString("Open Recent", tableName: "MainMenu", comment: "File menu item"),
						.submenu -- Menu(
							.systemName -- .recentDocuments,
							.items -- [
								MenuItem(
									.title -- NSLocalizedString("Clear Menu", tableName: "MainMenu", comment: "File menu item"),
									.action --> #selector(NSDocumentController.clearRecentDocuments(_:))
								)
							]
						)
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Close", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSWindow.performClose(_:)),
						.keyEquivalent -- "w"
					),
					MenuItem(
						.title -- NSLocalizedString("Save…", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSDocument.save(_:)),
						.keyEquivalent -- "s"
					),
					MenuItem(
						.title -- NSLocalizedString("Save As…", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSDocument.saveAs(_:)),
						.keyEquivalent -- "s",
						.keyEquivalentModifierMask -- [.shift, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Revert to Saved", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSDocument.revertToSaved(_:)),
						.keyEquivalent -- "r"
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Page Setup…", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSDocument.runPageLayout(_:)),
						.keyEquivalent -- "p",
						.keyEquivalentModifierMask -- [.shift, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Print…", tableName: "MainMenu", comment: "File menu item"),
						.action --> #selector(NSDocument.printDocument),
						.keyEquivalent -- "p"
					)
				]
			)
		}

		func editMenu() -> Menu {
			return Menu(
				.title -- NSLocalizedString("Edit", tableName: "MainMenu", comment: "Standard menu title"),
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Undo", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> Selector(("undo:")),
						.keyEquivalent -- "z"
					),
					MenuItem(
						.title -- NSLocalizedString("Redo", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> Selector(("redo:")),
						.keyEquivalent -- "Z",
						.keyEquivalentModifierMask -- [.shift, .command]
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Cut", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> #selector(NSText.cut(_:)),
						.keyEquivalent -- "x"
					),
					MenuItem(
						.title -- NSLocalizedString("Copy", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> #selector(NSText.copy(_:)),
						.keyEquivalent -- "c"
					),
					MenuItem(
						.title -- NSLocalizedString("Paste", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> #selector(NSText.paste(_:)),
						.keyEquivalent -- "v"
					),
					MenuItem(
						.title -- NSLocalizedString("Paste and Match Style", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> #selector(NSTextView.pasteAsPlainText(_:)),
						.keyEquivalent -- "v",
						.keyEquivalentModifierMask -- [.shift, .option, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Delete", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> #selector(NSText.delete(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Select All", tableName: "MainMenu", comment: "Edit menu item"),
						.action --> #selector(NSText.selectAll(_:)),
						.keyEquivalent -- "a"
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Find", tableName: "MainMenu", comment: "Edit menu item"),
						.submenu -- findSubmenu()
					),
					MenuItem(
						.title -- NSLocalizedString("Spelling and Grammar", tableName: "MainMenu", comment: "Edit menu item"),
						.submenu -- spellingAndGrammarSubmenu()
					),
					MenuItem(
						.title -- NSLocalizedString("Substitutions", tableName: "MainMenu", comment: "Edit menu item"),
						.submenu -- substitutionsSubmenu()
					),
					MenuItem(
						.title -- NSLocalizedString("Transformations", tableName: "MainMenu", comment: "Edit menu item"),
						.submenu -- transformationsSubmenu()
					),
					MenuItem(
						.title -- NSLocalizedString("Speech", tableName: "MainMenu", comment: "Edit menu item"),
						.submenu -- speechSubmenu() 
					)
				]
			)
		}

		func formatMenu() -> Menu {
			return Menu(
				.title -- NSLocalizedString("Format", tableName: "MainMenu", comment: "Standard menu title"),
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Font", tableName: "MainMenu", comment: "Format menu item"),
						.submenu -- fontSubmenu()
					),
					MenuItem(
						.title -- NSLocalizedString("Text", tableName: "MainMenu", comment: "Format menu item"),
						.submenu -- textSubmenu()
					)
				]
			)
		}

		func viewMenu() -> Menu {
			return Menu(
				.title -- NSLocalizedString("View", tableName: "MainMenu", comment: "Standard menu title"),
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Show Toolbar", tableName: "MainMenu", comment: "View menu item"),
						.action --> #selector(NSWindow.toggleToolbarShown(_:)),
						.keyEquivalent -- "t",
						.keyEquivalentModifierMask -- [.option, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Customize Toolbar…", tableName: "MainMenu", comment: "View menu item"),
						.action --> #selector(NSWindow.runToolbarCustomizationPalette(_:))
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Show Sidebar", tableName: "MainMenu", comment: "View menu item"),
						.action --> NSSelectorFromString("toggleSourceList:"),
						.keyEquivalent -- "s",
						.keyEquivalentModifierMask -- [.control, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Enter Full Screen", tableName: "MainMenu", comment: "View menu item"),
						.action --> #selector(NSWindow.toggleFullScreen(_:)),
						.keyEquivalent -- "f",
						.keyEquivalentModifierMask -- [.control, .command]
					)
				]
			)
		}

		func windowsMenu() -> Menu {
			return Menu(
				.systemName -- .windows,
				.title -- NSLocalizedString("Window", tableName: "MainMenu", comment: "Standard menu title"),
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Minimize", tableName: "MainMenu", comment: "Window menu item"),
						.action --> #selector(NSWindow.performMiniaturize(_:)),
						.keyEquivalent -- "m"
					),
					MenuItem(
						.title -- NSLocalizedString("Zoom", tableName: "MainMenu", comment: "Window menu item"),
						.action --> #selector(NSWindow.performZoom(_:))
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Bring All to Front", tableName: "MainMenu", comment: "Window menu item"),
						.action --> #selector(NSApplication.arrangeInFront(_:)),
						.keyEquivalent -- "s",
						.keyEquivalentModifierMask -- [.control, .command]
					)
				]
			)
		}

		func helpMenu() -> Menu {
			return Menu(
				.systemName -- .help,
				.title -- NSLocalizedString("Help", tableName: "MainMenu", comment: "Standard menu title"),
				.items -- [
					MenuItem(
						.title -- String(format: NSLocalizedString("%@ Help", tableName: "MainMenu", comment: "Help menu item"), executableName),
						.action --> #selector(NSApplication.showHelp(_:)),
						.keyEquivalent -- "?"
					)
				]
			)
		}

		func findSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Find…", tableName: "MainMenu", comment: "Find menu item"),
						.action --> #selector(NSTextView.performFindPanelAction(_:)),
						.keyEquivalent -- "f",
						.tag -- 1
					),
					MenuItem(
						.title -- NSLocalizedString("Find and Replace…", tableName: "MainMenu", comment: "Find menu item"),
						.action --> #selector(NSTextView.performFindPanelAction(_:)),
						.keyEquivalent -- "f",
						.keyEquivalentModifierMask -- [.option, .command],
						.tag -- 12
					),
					MenuItem(
						.title -- NSLocalizedString("Find Next", tableName: "MainMenu", comment: "Find menu item"),
						.action --> #selector(NSTextView.performFindPanelAction(_:)),
						.keyEquivalent -- "g",
						.tag -- 2
					),
					MenuItem(
						.title -- NSLocalizedString("Find Previous", tableName: "MainMenu", comment: "Find menu item"),
						.action --> #selector(NSTextView.performFindPanelAction(_:)),
						.keyEquivalent -- "g",
						.keyEquivalentModifierMask -- [.shift, .command],
						.tag -- 3
					),
					MenuItem(
						.title -- NSLocalizedString("Use Selection for Find", tableName: "MainMenu", comment: "Find menu item"),
						.action --> #selector(NSTextView.performFindPanelAction(_:)),
						.keyEquivalent -- "e",
						.tag -- 7
					),
					MenuItem(
						.title -- NSLocalizedString("Jump to Selection", tableName: "MainMenu", comment: "Find menu item"),
						.action --> #selector(NSResponder.centerSelectionInVisibleArea(_:)),
						.keyEquivalent -- "j"
					)
				]
			)
		}

		func spellingAndGrammarSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Show Spelling and Grammar", tableName: "MainMenu", comment: "Spelling menu item"),
						.action --> #selector(NSText.showGuessPanel(_:)),
						.keyEquivalent -- ":"
					),
					MenuItem(
						.title -- NSLocalizedString("Check Document Now", tableName: "MainMenu", comment: "Spelling menu item"),
						.action --> #selector(NSText.checkSpelling(_:)),
						.keyEquivalent -- ";"
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Check Spelling While Typing", tableName: "MainMenu", comment: "Spelling menu item"),
						.action --> #selector(NSTextView.toggleContinuousSpellChecking(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Check Grammar With Spelling", tableName: "MainMenu", comment: "Spelling menu item"),
						.action --> #selector(NSTextView.toggleGrammarChecking(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Correct Spelling Automatically", tableName: "MainMenu", comment: "Spelling menu item"),
						.action --> #selector(NSTextView.toggleAutomaticSpellingCorrection(_:))
					)
				]
			)
		}

		func substitutionsSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Show Substitutions", tableName: "MainMenu", comment: "Substitutions menu item"),
						.action --> #selector(NSTextView.orderFrontSubstitutionsPanel(_:)),
						.keyEquivalent -- ":"
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Smart Copy/Paste", tableName: "MainMenu", comment: "Substitutions menu item"),
						.action --> #selector(NSTextView.toggleSmartInsertDelete(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Smart Quotes", tableName: "MainMenu", comment: "Substitutions menu item"),
						.action --> #selector(NSTextView.toggleAutomaticQuoteSubstitution(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Smart Dashes", tableName: "MainMenu", comment: "Substitutions menu item"),
						.action --> #selector(NSTextView.toggleAutomaticDashSubstitution(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Smart Links", tableName: "MainMenu", comment: "Substitutions menu item"),
						.action --> #selector(NSTextView.toggleAutomaticLinkDetection(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Data Detectors", tableName: "MainMenu", comment: "Substitutions menu item"),
						.action --> #selector(NSTextView.toggleAutomaticDataDetection(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Text Replacement", tableName: "MainMenu", comment: "Substitutions menu item"),
						.action --> #selector(NSTextView.toggleAutomaticTextReplacement(_:))
					)
				]
			)
		}

		func transformationsSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Make Upper Case", tableName: "MainMenu", comment: "Tubstitutions menu item"),
						.action --> #selector(NSResponder.uppercaseWord(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Make Lower Case", tableName: "MainMenu", comment: "Tubstitutions menu item"),
						.action --> #selector(NSResponder.lowercaseWord(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Capitalize", tableName: "MainMenu", comment: "Tubstitutions menu item"),
						.action --> #selector(NSResponder.capitalizeWord(_:))
					)
				]
			)
		}

		func speechSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Start Speaking", tableName: "MainMenu", comment: "Speech menu item"),
						.action --> #selector(NSTextView.startSpeaking(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Stop Speaking", tableName: "MainMenu", comment: "Speech menu item"),
						.action --> #selector(NSTextView.stopSpeaking(_:))
					)
				]
			)
		}

		func fontSubmenu() -> Menu {
			return Menu(
				.systemName -- .font,
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Show Fonts", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSFontManager.orderFrontFontPanel(_:)),
						.keyEquivalent -- "t"
					),
					MenuItem(
						.title -- NSLocalizedString("Bold", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSFontManager.addFontTrait(_:)),
						.keyEquivalent -- "b",
						.tag -- 2
					),
					MenuItem(
						.title -- NSLocalizedString("Italic", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSFontManager.addFontTrait(_:)),
						.keyEquivalent -- "i",
						.tag -- 1
					),
					MenuItem(
						.title -- NSLocalizedString("Underline", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSText.underline(_:)),
						.keyEquivalent -- "u"
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Bigger", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSFontManager.modifyFont(_:)),
						.keyEquivalent -- "+",
						.tag -- 3
					),
					MenuItem(
						.title -- NSLocalizedString("Smaller", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSFontManager.modifyFont(_:)),
						.keyEquivalent -- "-",
						.tag -- 4
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Kern", tableName: "MainMenu", comment: "Font menu item"),
						.submenu -- kernSubmenu()
					),
					MenuItem(
						.title -- NSLocalizedString("Ligatures", tableName: "MainMenu", comment: "Font menu item"),
						.submenu -- ligaturesSubmenu()
					),
					MenuItem(
						.title -- NSLocalizedString("Baseline", tableName: "MainMenu", comment: "Font menu item"),
						.submenu -- baselineSubmenu()
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Show Colors", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSApplication.orderFrontColorPanel(_:)),
						.keyEquivalent -- "c",
						.keyEquivalentModifierMask -- [.shift, .command]
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Copy Style", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSText.copyFont(_:)),
						.keyEquivalent -- "c",
						.keyEquivalentModifierMask -- [.option, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Paste Style", tableName: "MainMenu", comment: "Font menu item"),
						.action --> #selector(NSText.pasteFont(_:)),
						.keyEquivalent -- "v",
						.keyEquivalentModifierMask -- [.option, .command]
					)
				]
			)
		}

		func textSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Align Left", tableName: "MainMenu", comment: "Text menu item"),
						.action --> #selector(NSText.alignLeft(_:)),
						.keyEquivalent -- "{"
					),
					MenuItem(
						.title -- NSLocalizedString("Center", tableName: "MainMenu", comment: "Text menu item"),
						.action --> #selector(NSText.alignCenter(_:)),
						.keyEquivalent -- "|"
					),
					MenuItem(
						.title -- NSLocalizedString("Justify", tableName: "MainMenu", comment: "Text menu item"),
						.action --> #selector(NSTextView.alignJustified(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Align Right", tableName: "MainMenu", comment: "Text menu item"),
						.action --> #selector(NSText.alignLeft(_:)),
						.keyEquivalent -- "}"
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Writing Direction", tableName: "MainMenu", comment: "Text menu item"),
						.submenu -- writingDirectionSubmenu()
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Show Ruler", tableName: "MainMenu", comment: "Text menu item"),
						.action --> #selector(NSText.toggleRuler(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Copy Ruler", tableName: "MainMenu", comment: "Text menu item"),
						.action --> #selector(NSText.copyRuler(_:)),
						.keyEquivalent -- "c",
						.keyEquivalentModifierMask -- [.control, .command]
					),
					MenuItem(
						.title -- NSLocalizedString("Paste Ruler", tableName: "MainMenu", comment: "Text menu item"),
						.action --> #selector(NSText.pasteRuler(_:)),
						.keyEquivalent -- "v",
						.keyEquivalentModifierMask -- [.control, .command]
					)
				]
			)
		}

		func kernSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Use Default", tableName: "MainMenu", comment: "Kern menu item"),
						.action --> #selector(NSTextView.useStandardKerning(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Use None", tableName: "MainMenu", comment: "Kern menu item"),
						.action --> #selector(NSTextView.turnOffKerning(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Tighten", tableName: "MainMenu", comment: "Kern menu item"),
						.action --> #selector(NSTextView.tightenKerning(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Loosen", tableName: "MainMenu", comment: "Kern menu item"),
						.action --> #selector(NSTextView.loosenKerning(_:))
					)
				]
			)
		}

		func ligaturesSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Use Default", tableName: "MainMenu", comment: "Ligatures menu item"),
						.action --> #selector(NSTextView.useStandardLigatures(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Use None", tableName: "MainMenu", comment: "Ligatures menu item"),
						.action --> #selector(NSTextView.turnOffLigatures(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Use All", tableName: "MainMenu", comment: "Ligatures menu item"),
						.action --> #selector(NSTextView.useAllLigatures(_:))
					)
				]
			)
		}

		func baselineSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Use Default", tableName: "MainMenu", comment: "Baseline menu item"),
						.action --> #selector(NSTextView.unscript(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Superscript", tableName: "MainMenu", comment: "Baseline menu item"),
						.action --> #selector(NSTextView.superscript(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Subscript", tableName: "MainMenu", comment: "Baseline menu item"),
						.action --> #selector(NSTextView.subscript(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Raise", tableName: "MainMenu", comment: "Baseline menu item"),
						.action --> #selector(NSTextView.raiseBaseline(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("Lower", tableName: "MainMenu", comment: "Baseline menu item"),
						.action --> #selector(NSTextView.lowerBaseline(_:))
					)
				]
			)
		}

		func writingDirectionSubmenu() -> Menu {
			return Menu(
				.items -- [
					MenuItem(
						.title -- NSLocalizedString("Paragraph", tableName: "MainMenu", comment: "Writing direction menu item"),
						.isEnabled -- false
					),
					MenuItem(
						.title -- NSLocalizedString("\tDefault", tableName: "MainMenu", comment: "Writing direction menu item"),
						.action --> #selector(NSResponder.makeBaseWritingDirectionNatural(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("\tLeft to Right", tableName: "MainMenu", comment: "Writing direction menu item"),
						.action --> #selector(NSResponder.makeBaseWritingDirectionLeftToRight(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("\tRight to Left", tableName: "MainMenu", comment: "Writing direction menu item"),
						.action --> #selector(NSResponder.makeBaseWritingDirectionRightToLeft(_:))
					),
					NSMenuItem.separator(),
					MenuItem(
						.title -- NSLocalizedString("Selection", tableName: "MainMenu", comment: "Writing direction menu item"),
						.isEnabled -- false
					),
					MenuItem(
						.title -- NSLocalizedString("\tDefault", tableName: "MainMenu", comment: "Writing direction menu item"),
						.action --> #selector(NSResponder.makeTextWritingDirectionNatural(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("\tLeft to Right", tableName: "MainMenu", comment: "Writing direction menu item"),
						.action --> #selector(NSResponder.makeTextWritingDirectionLeftToRight(_:))
					),
					MenuItem(
						.title -- NSLocalizedString("\tRight to Left", tableName: "MainMenu", comment: "Writing direction menu item"),
						.action --> #selector(NSResponder.makeTextWritingDirectionRightToLeft(_:))
					)
				]
			)
		}
		"""#
}

func macDetailContent() -> String {
	return #"""
		struct DetailState: CodableContainer {
			let index: Int
			let value: String
		}

		func detailContainer(_ windowState: WindowState) -> ViewConvertible {
			return View(
				.layout <-- windowState.rowSelection.map { selection in
					.vertical(
						animation: Layout.Animation(style: .fade, duration: 0.1),
						.inset(
							margins: NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
							.view(selection.map(detailView) ?? emptyDetail())
						)
					)
				}
			)
		}

		func emptyDetail() -> ViewConvertible {
			return TextField.label(
				.stringValue -- .noItemSelected,
				.verticalContentHuggingPriority -- .layoutLow
			)
		}

		private func detailView(_ detailState: DetailState) -> ViewConvertible {
			return TextField.label(
				.stringValue -- .contentLabel(detailState.value),
				.verticalContentHuggingPriority -- .layoutLow
			)
		}

		private extension String {
			static func contentLabel(_ row: String) -> String {
				return String.localizedStringWithFormat(NSLocalizedString("Row %@ selected", comment: ""), row)
			}
			static let noItemSelected = NSLocalizedString("No item selected", comment: "")
		}
		"""#
}

func templateIconPng() -> Data {
	return Data(base64Encoded: #"""
	iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAAAVlpVFh0
	WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0
	YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJo
	dHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJk
	ZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0
	cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlv
	bj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9y
	ZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAACS9JREFUaAXtWmtsk9cZfmwnduLcbyTOTbmQ
	lEtvEXShg7VTlQ7aVXQtarWBuh+TVn5MZBPStB+IP/zYBJsQ01hBqhQxifFjoz9WLROdSFck
	low2oEJTSLKEhtwTk5tjx7Hj+NvzHvtLHccOtpMwadqLXp/znXO+c97nvJfzni8YEJkMbDaT
	C8nJZHmOlbTgQD9LH9lDdpPnyNKm97O6doommJFT542MjIzHs4SmaRD2+/0LJPf8/Pz41NRU
	V09Pz7XGxsYPZmZmRjmfgFk3EJEASFsSuWxiYqKXZUykCy+DgyAECAgCc3NzMJlM3SdPnvzp
	hQsX/skhLrJoY80UDYCYTeXs7GxnrCuI0EI6EB3E4uIivF4vHA4HUlJSJk6dOnX4/PnzVzl0
	lrxmENEAiP1Xud3uuyxjokgApE0A6CBoQkhLS3OcOXPmJ6dPn27mxA7yYkwLRBm0KgDuXMwA
	ZP5wEGJCwjoIahQGgwGpqalzZ8+ePXrixInLfG2anDAIsfWoZDSKL8dOoQDkLRFWWEj6LBYL
	PB4PMjIyrEeOHPktn63Hjh27yO4pskSsuGlVAPricc8afIGOuwRANJGcnKz8QTYmPT3dcvjw
	4VPURtrRo0ff5ysTZNHEmiOUbJmFvJWLavEyzUUT9vl8ihlONUYizel0apOTk1p/f7/qpyY0
	+pjGSLd47ty5X3E9G1k2NJJZszl2WgJAtcdNoYB1MAJChKUTa4ODg2pO6RMQAo5nhb+pqel3
	FLGEHO/BuQLZmgCIdDoIHYBoQ4SlE2ujo6NLmyL9DBSqjyC0S5cuNVGasnhARFKXtKkwypXi
	ikL6VvA9vbosMokD65FI6nLISSkk/mG1WtHe3n754MGDP2ffMJsXyF9PJgPDaEMAyBqRQHDH
	ldDUCGhWiuWQC2V5b2xs7G+HDh1qpMkNcKpVQWwYgFAQoWBoXkpwASGApJQ2YamLRgSQ3W7/
	aN++fT+m70j+JCE2oibiC/QiVQIUGo4lhIq5yJkgzPRCMcOphFbk5OQgMzMTxcXFe+nYjVwu
	jRxpo5UkGwpAP8ikFMH1Z6nLGSFAzGazYqknJSWpNgHClAP19fXvksspadTwuqEA1BaF/IQD
	0IEIGBE+lAUEtZJ5/PjxA5wihRxRC6uexCFrx1V1OJzo/qoPLqcL257YjIL8PPV+x71udHb3
	IpkCb2V7bU3VkrOLnwhAvZQ6Uw6UlZXt5svvkSUFX0GRUEnbo8OohMpgnhM665WWa7j9yXXU
	pFuRajHjpn0Kr33/TbTfuAmz3Y49W2tg4m63dHSidEcdvvPyt9XruiPLg9QFiPD09PQDm832
	IpuHyCtSjcQ1EEH4z7+8h6GPr+EXu+pAI6flmvC8cw4/++VpvFRbjR/ufYHxhDKYjPhRwx68
	1/wxtlAT5eWlykdEeBFaTEsHQFPKZXPU0zlxALJaGLW2foYf1FaCwT7QQxDZdM7zb38XZpaY
	dYLSBTRHQZ+rLMfdrh4FQF7QBRcN6ObESJXOLu7GY/ABD+O3QQRckNhAS6QgwimiDcZ4bmtA
	M8ExbpcLyYxCoaQ7urQFQYhJC0ekdY1CdXVP4fpXPDz9FHSBAhPQEvPkXV5fQNuDQTxJnwgn
	0YQOREpSVBDrCuCFXc9hpLQM/+h5wN2mrfvJIrjOogXRCukv7XdQ+816FG4qUM/RfoIAonVH
	VI2gfXQUijol8OGVq+hq+QQNuZmoK8wP2D0d2rWwiNv2SXw640L5N3bgzddfXWWWr7sIYhuf
	7pOp0uUpxZqcWHIW2SE5RYV67/dhYGAYfs8CUqpr0NTXj8LBu3j3iQrcGJtA64KGwWkHtjPy
	VFWUY3JyCrm5OerdRH+UgYW9/EgNdHd3o6WlFQ8G7EwDLCgqzMLMzCRys7OQn22F5pmFb57s
	duLq9TZMuKxI9juw98UdyCmwwWBJg8dvhpsWlZ2djdf371PpRJgcS4/rpgHJFC/+8TJufT6I
	vMIa5G4qZxRhMpYhkfMORro+Q0fvTbhnp6gZxnJaqFHzI93PxM3gxadXBwI2yy3KyslH1fY6
	XLtlRGlpMZ7ftXNJ4HgqcZnQX5s/wu0vZ1BU+rQ6aB7a++F0cufzSlBV9Sy6/j2OIU8xDD4j
	UuFUQhsprIVfEzXNwMDEVIH//Kw7xqbR5+iEOX8LeBuLR+ZlY2MGILen1rYOZGZvYc7uxuR4
	F15+6SkUFj6N95v+TE1YUVGzm+CeoUAjmH44CLdjCL45Csf4L+eDycRs05wKS1oe8vMrUGDb
	jEWfV316XCZVHA8xA1BXQI8PZqYCXq8LtZtz8MYbr3FxN7NGC88pCRDMHpKSYSuqRnFJDXg5
	ZtT0KUc3GU0wMoUwGZNYBpxexk9PDXNcJFeU3kdTzADkwmFNSaatuyiACXe+GMCvf/N72B9O
	wZjEUAkjfIz3RqN8ShShjSo1kLESqcQfxIxUoqaiodwRTOoWZrXSiRKkmA8yuXg0NOyGfaxH
	LAI5m7ZhaDwFflMFMjILMe92MU/zKYEWeWAFeIGgvAqYz8e64sAYPd9xTI/BZpM/QyRGMWtA
	pm9o+BZj9ySu/L0N5pQCpKZlw0t/GOy7zWuhFUUl28DPWWrnDfReoz+gBT/tX+qqZLtBtXMX
	SL6FCVRXV6p6Ij+RjE/aVj2Jh4eH0dbWjp7eft5hs5CXm4EPm/+F/KInlbnIBOK0xqAZBerB
	a2WwPZnnx+hQN/bsKsFbb31vVdnX7RzQV+GFGwcO7NcfVZmaasUfLjaj0LYdZh5U2iIvJQYJ
	mf7g7suZYFJ5sfjF6HAPNuV5sX//K8vmifchIQ1EW+SLOx340+Vm9NyfQGaWDSnWTEYls7rA
	qxOMUcnjnYPLMYj6nZvxzjtvqy8S0ebT21fTwLoCkAXlJnXvXidu3LilTGzew28/TK1NTOZy
	czJ4A6vEzh3PoKKyQobHRI8VQLhEcn7IByz58iDfgRKh1QDEFYUSWTxRoWNdK+ZzINYJH/e4
	/wN43Dsevt7/rAbknA+kl+GQ/zvPK+7CuhjRopAAcDB8PcsyixxtnD7PRpW8dGKGLH8QDyRP
	YStFOshkiJiW5EOpwVLGRRvLrg0hEVi3BPkPIqKFwDeZkOWiCaULrH/SizYuZKoNqeog9I+6
	K7TwH3CMLqoN/nlmAAAAAElFTkSuQmCC
	"""#, options: .ignoreUnknownCharacters)!
}

func templateIconPngAt2x() -> Data {
	return Data(base64Encoded: #"""
	iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAYAAADimHc4AAAAAXNSR0IArs4c6QAAAVlpVFh0
	WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0
	YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJo
	dHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJk
	ZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0
	cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlv
	bj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9y
	ZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAF89JREFUeAHtXQl0VUWa/l/25WUhJGSBEAgQ
	dhBlU1RQUNthcKXxDEdHprE9os5RRhr1KGpPY9vS0zMel9ZRG9H2OD22ymnREURbaXEUWWUL
	a0iAACH7vufN99V7P7k8HiHvJXl5YfJLperWcuvW91X9Vfevuk+beC82FAmGC3H5vPanOFCZ
	uhaErY7xPUoIordC8CPhYuEi4HjtL7EC34xKm+AaXa7B5TNO8yEY2OItAeztLBNTUlJyvLGR
	be9ccThaO7GGW1rYyYF2U1Ntc3NzQ319fXldXV1xeXl5XkFBwf5t27Z99/zzz+9ClhqXq4fP
	hwt4IrxVH0FoVDRcChp/AIAg2LmioKvPu5MAXlsd40CGSautrRW4oydPnly9bNmyVTt27DiJ
	YlVwJIIjpZVVXASS+EJADBowsKqqaicB8CQEymazGcDUZz738PnKMl7B9hTWepmHYbqGhgZB
	p5Do6OiitWvXPrt48eKPULYMjqMiYEnwhQDq/oyampodCgSuO0UIqIp72EqIjgirbyUB93Dk
	5OS8MXfu3OcRLoYjCTo3IBg44gsBcXj8DOjg7f4mgLApEQo+rxmmUxIqKio4X0h+fv6f5s2b
	9xTmjEIUrYYLOBJ8JgCN2s5Gd6a493q9t8Yr+OorCUoA40kCnk1IQlRUlBw+fPjjW265ZSni
	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
	"""#, options: .ignoreUnknownCharacters)!
}

func contentsJson() -> String {
	return #"""
		{
		  "info" : {
			 "version" : 1,
			 "author" : "xcode"
		  }
		}
		"""#
}

func macPlaygroundContent() -> String {
	return #"""
		import AppKit
		import PlaygroundSupport
		import NaturalLanguage

		struct TextFieldViewState: CodableContainer {
			let text: Var<String>
			init() {
				text = Var("")
			}
		}

		func textFieldView(_ textFieldViewState: TextFieldViewState) -> ViewConvertible {
			return View(
				.layout -- .center(
					.view(
						TextField.wrappingLabel(
							.font -- .preferredFont(forTextStyle: .label, size: .controlSmall, weight: .semibold),
							.stringValue <-- textFieldViewState.text.allChanges().keyPath(\.statistics)
						)
					),
					.space(),
					.view(
						breadth: .ratio(1.0, constant: -16),
						TextField(
							.stringValue <-- textFieldViewState.text,
							.stringChanged() --> textFieldViewState.text.update()
						)
					)
				)
			)
		}

		private extension String {
			var statistics: String {
				let labelFormat = NSLocalizedString("Field contains %ld characters and %ld words.", comment: "")
				let tokenizer = NLTokenizer(unit: .word)
				tokenizer.string = self
				let wordCount = tokenizer.tokens(for: startIndex..<endIndex).count
				return .localizedStringWithFormat(labelFormat, count, wordCount)
			}
		}

		PlaygroundPage.current.liveView = textFieldView(TextFieldViewState()).nsView(width: 400, height: 300)
		"""#
}

func iOSPlaygroundContent() -> String {
	return #"""
		import UIKit
		import PlaygroundSupport
		import NaturalLanguage

		struct TextFieldViewState: CodableContainer {
			let text: Var<String>
			init() {
				text = Var("")
			}
		}

		func textFieldView(_ textFieldViewState: TextFieldViewState) -> ViewControllerConvertible {
			return ViewController(
				.view -- View(
					.backgroundColor -- .white,
					.layout -- .center(
						alignment: .center,
						marginEdges: .allLayout,
						breadth: .equalTo(ratio: 1.0),
						.view(
							Label(
								.font -- UIFont.preferredFont(forTextStyle: .callout, weight: .semibold),
								.text <-- textFieldViewState.text.allChanges().keyPath(\.statistics)
							)
						),
						.space(),
						.view(
							breadth: .equalTo(ratio: 1.0),
							TextField(
								.text <-- textFieldViewState.text,
								.textChanged() --> textFieldViewState.text.update(),
								.borderStyle -- .roundedRect
							)
						)
					)
				)
			)
		}

		private extension String {
			var statistics: String {
				let labelFormat = NSLocalizedString("Field contains %ld characters and %ld words.", comment: "")
				let tokenizer = NLTokenizer(unit: .word)
				tokenizer.string = self
				let wordCount = tokenizer.tokens(for: startIndex..<endIndex).count
				return .localizedStringWithFormat(labelFormat, count, wordCount)
			}
		}

		PlaygroundPage.current.liveView = textFieldView(TextFieldViewState()).uiViewController()
		"""#
}

func xcplaygroundContent(_ platform: Platform) -> String {
	return """
		<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
		<playground version='5.0' target-platform='\(platform.isIos ? "ios" : "macos")' executeOnSourceChanges='false'>
			 <timeline fileName='timeline.xctimeline'/>
		</playground>
		"""
}

run()
