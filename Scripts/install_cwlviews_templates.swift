#!/usr/bin/swift -swift-version 4
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

func run() {
	let templates: Dictionary<String, (URL) throws -> Void> = [
		"~/Library/Developer/Xcode/Templates/Project Templates/iOS/Application/CwlViews Application.xctemplate": installIosAppTemplate,
		"~/Library/Developer/Xcode/Templates/Project Templates/Mac/Application/CwlViews Application.xctemplate": installMacAppTemplate,
		"~/Library/Developer/Xcode/Templates/File Templates/Source/CwlViewsBinder.xctemplate": installCwlViewsTemplate,
	]

	do {
		for (destinationDirPath, installFunction) in templates {
			// Expand the tilde
			let destinationUrl = URL(fileURLWithPath: NSString(string: destinationDirPath).expandingTildeInPath)
			
			// Create the parent directory, if necessary
			try FileManager.default.createDirectory(at: destinationUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
			
			let display: String
			
			// If the destination already exists, move it to the Trash
			if FileManager.default.fileExists(atPath: destinationUrl.path) {
				try removeDirectory(url: destinationUrl)
				display = "Template at location:\n   \(destinationUrl.path)\nupdated successfully. Previous item has been moved to Trash."
			} else {
				display = "Template installed at location:\n   \(destinationUrl.path)"
			}
			
			// Create the destination director and install the template
			try FileManager.default.createDirectory(at: destinationUrl, withIntermediateDirectories: false)
			try installFunction(destinationUrl)
			print(display)
		}
	} catch {
		print("Failed with error: \(error)")
	}
}

func removeDirectory(url: URL) throws {
	var result: (urls: [URL: URL], error: Error?)? = nil
	NSWorkspace.shared.recycle([url]) { (urls, error) in result = (urls: urls, error: error) }
	while result == nil {
		RunLoop.main.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.01))
	}
	if let e = result?.error {
		throw e
	}
}

func installIosAppTemplate(_ url: URL) throws {
	try templateIconPng().write(to: url.appendingPathComponent("TemplateIcon.png"))
	try templateIconPngAt2x().write(to: url.appendingPathComponent("TemplateIcon@2x.png"))
	try PropertyListSerialization.data(fromPropertyList: iOSProjectTemplateInfo(), format: .xml, options: 0).write(to: url.appendingPathComponent("TemplateInfo.plist"))
	try iOSLaunchScreenStoryboard().data(using: .utf8)!.write(to: url.appendingPathComponent("LaunchScreen.storyboard"))
}

func installMacAppTemplate(_ url: URL) throws {
	try templateIconPng().write(to: url.appendingPathComponent("TemplateIcon.png"))
	try templateIconPngAt2x().write(to: url.appendingPathComponent("TemplateIcon@2x.png"))
	try PropertyListSerialization.data(fromPropertyList: macProjectTemplateInfo(), format: .xml, options: 0).write(to: url.appendingPathComponent("TemplateInfo.plist"))
}

func installCwlViewsTemplate(_ url: URL) throws {
	try templateIconPng().write(to: url.appendingPathComponent("TemplateIcon.png"))
	try templateIconPngAt2x().write(to: url.appendingPathComponent("TemplateIcon@2x.png"))
	try PropertyListSerialization.data(fromPropertyList: binderTemplateInfo(), format: .xml, options: 0).write(to: url.appendingPathComponent("TemplateInfo.plist"))
	try FileManager.default.createDirectory(at: url.appendingPathComponent("Swift"), withIntermediateDirectories: false, attributes: nil)
	try binderContent().data(using: .utf8)!.write(to: url.appendingPathComponent("Swift").appendingPathComponent("___FILEBASENAME___.swift"))
}

enum Platform {
	case macOS
	case iOS
	
	var oldName: String {
		switch self {
		case .macOS: return "Mac"
		case .iOS: return "iOS"
		}
	}
	var newName: String {
		switch self {
		case .macOS: return "macOS"
		case .iOS: return "iOS"
		}
	}
	var isIos: Bool {
		switch self {
		case .macOS: return false
		case .iOS: return true
		}
	}
}

func iOSLaunchScreenStoryboard() -> String {
	return """
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
		"""
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
			private typealias B = ___VARIABLE_basename___.Binding
			private static func name<V>(_ source: @escaping (V) -> ___VARIABLE_basename___.Binding) -> ___VARIABLE_basename___Name<V> {
				return ___VARIABLE_basename___Name<V>(source: source, downcast: Binding.___VARIABLE_lowercaseBasename___Binding)
			}
		}
		public extension BindingName where Binding: ___VARIABLE_basename___Binding {
			// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
			// Replace: case ([^\(]+)\((.+)\)$
			// With:    static var $1: ___VARIABLE_basename___Name<$2> { return .name(B.$1) }
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

func macProjectTemplateInfo() -> [String: Any] {
	return [
		"Identifier": "com.cocoawithlove.views-app-macOS",
		"Kind": "Xcode.Xcode3.ProjectTemplateUnitKind",
		"Targets": projectTargets(.macOS),
		"SortOrder": 1 as NSNumber,
		"Project": [
			"SDK": "macosx",
		] as [String: Any],
		"Ancestors": [
			"com.apple.dt.unit.bundleBase"
		] as [Any],
		"Options": projectOptions(.macOS),
		"Description": "Creates a Cocoa application using the CwlViews framework.",
		"Concrete": 1 as NSNumber,
		"Platforms": [
			"com.apple.platform.macosx"
			] as [Any],
		"Nodes": [
			"main.swift:comments",
			"main.swift:imports:importCwlViews",
			"main.swift:ApplicationModel",
			"main.swift:appModel",
			"main.swift:ApplicationRun",
			"MainWindow.swift:comments",
			"MainWindow.swift:imports:importCwlViews",
			"MainWindow.swift:content",
			"MainMenu.swift:comments",
			"MainMenu.swift:imports:importCwlViews",
			"MainMenu.swift:content",
			"CwlUtils.framework",
			"CwlSignal.framework",
			"CwlViews.framework"
		] as [Any],
		"Definitions": [
			"CwlViews.framework": frameworkDefinition("CwlViews", "com.apple.dt.cocoaApplicationTarget"),
			"CwlSignal.framework": frameworkDefinition("CwlSignal", "com.apple.dt.cocoaApplicationTarget"),
			"CwlUtils.framework": frameworkDefinition("CwlUtils", "com.apple.dt.cocoaApplicationTarget"),

			"*:imports:importCwlViews": "import CwlViews",
			"main.swift:ApplicationModel": """
				struct ApplicationModel {
					init() {}
					let (terminateInput, terminateSignal) = Signal<Void>.collectorAndSignal { s in s.multicast() }
				}
				
				""",
			"MainWindow.swift:content": macMainWindowContents(),
			"MainMenu.swift:content": macMainMenuContent(),
			"main.swift:content": macMainContent()
		] as [String: Any]
	] as [String: Any]
}

func iOSProjectTemplateInfo() -> [String: Any] {
	return [
		"Identifier": "com.cocoawithlove.views-app-iOS",
		"Kind": "Xcode.Xcode3.ProjectTemplateUnitKind",
		"Targets": projectTargets(.iOS),
		"SortOrder": 1 as NSNumber,
		"Project": [
			"Configurations": [
				"Release": [
					"VALIDATE_PRODUCT": "YES"
				] as [String: Any]
			] as [String: Any],
			"SDK": "iphoneos",
			"SharedSettings": [
				"IPHONEOS_DEPLOYMENT_TARGET": "latest_iphoneos",
				"CODE_SIGN_IDENTITY[sdk=iphoneos*]": "iPhone Developer"
			] as [String: Any]
		] as [String: Any],
		"Ancestors": [
			"com.apple.dt.unit.bundleBase"
		] as [Any],
		"Options": projectOptions(.iOS),
		"Description": "Creates a Cocoa application using the CwlViews framework.",
		"Nodes": [
			"Base.lproj/LaunchScreen.storyboard",
			"Info.plist:iPhone",
			"Info.plist:UIRequiredDeviceCapabilities:base",
			"Info.plist:LaunchScreen",
			"main.swift:comments",
			"main.swift:imports:importCwlViews",
			"main.swift:content",
			"NavView.swift:comments",
			"NavView.swift:imports:importCwlViews",
			"NavView.swift:content",
			"TableView.swift:comments",
			"TableView.swift:imports:importCwlViews",
			"TableView.swift:content",
			"DetailView.swift:comments",
			"DetailView.swift:imports:importCwlViews",
			"DetailView.swift:content",
			"DocumentAdapter.swift:comments",
			"DocumentAdapter.swift:imports:importCwlViews",
			"DocumentAdapter.swift:content",
			"Document.swift:comments",
			"Document.swift:imports:importFoundation",
			"Document.swift:content",
			"CwlUtils.framework",
			"CwlSignal.framework",
			"CwlViews.framework"
		] as [Any],
		"Concrete": 1 as NSNumber,
		"Platforms": [
			"com.apple.platform.iphoneos"
		] as [Any],
		"Definitions": [
			"CwlUtils.framework": frameworkDefinition("CwlUtils", "com.apple.dt.cocoaTouchApplicationTarget"),
			"CwlSignal.framework": frameworkDefinition("CwlSignal", "com.apple.dt.cocoaTouchApplicationTarget"),
			"CwlViews.framework": frameworkDefinition("CwlViews", "com.apple.dt.cocoaTouchApplicationTarget"),
			"Base.lproj/LaunchScreen.storyboard": [
				"TargetIdentifiers": [],
				"SortOrder": 101 as NSNumber,
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
			"*:imports:importFoundation": "import Foundation",
			"*:imports:importCwlViews": "import CwlViews",
			"main.swift:content": iOSMainContent(),
			"NavView.swift:content": iOSNavViewContent(),
			"TableView.swift:content": iOSTableViewContent(),
			"DetailView.swift:content": iOSDetailViewContent(),
			"DocumentAdapter.swift:content": documentAdapterContent(),
			"Document.swift:content": documentContent()
		] as [String: Any],
	] as [String: Any]
}

func projectOptions(_ platform: Platform) -> [Any] {
	var result = [
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
							"Identifier": "com.apple.dt.unit.cocoa\(platform.isIos ? "Touch" : "")ApplicationUnitTestBundle"
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
	
	if platform.isIos {
		result.append([
			"Description": "Which device family to create a project for",
			"Units": [
				"iPad": [
					"Nodes": [
						"Info.plist:UISupportedInterfaceOrientations~iPad"
					] as [Any],
					"Project": [
						"SharedSettings": [
							"TARGETED_DEVICE_FAMILY": "2"
						] as [String: Any]
					] as [String: Any]
				] as [String: Any],
				"Universal": [
					"Nodes": [
						"Info.plist:UISupportedInterfaceOrientations~iPhone",
						"Info.plist:UISupportedInterfaceOrientations~iPad"
					] as [Any],
					"Definitions": [:],
					"Project": [
						"SharedSettings": [
							"TARGETED_DEVICE_FAMILY": "1,2"
						] as [String: Any]
					] as [String: Any]
				] as [String: Any],
				"iPhone": [
					"Nodes": [
						"Info.plist:UISupportedInterfaceOrientations~iPhone"
					] as [Any]
				] as [String: Any]
			] as [String: Any],
			"Identifier": "universalDeviceFamily",
			"Name": "Devices:",
			"Values": [
				"Universal",
				"iPhone",
				"iPad"
			] as [Any],
			"SortOrder": 1 as NSNumber,
			"Type": "popup",
			"Default": "Universal"
		] as [String: Any])
	}
	
	return result
}

func sharedSettings(_ platform: Platform, name: String) -> [String: Any] {
	if platform.isIos {
		return [
			"IPHONEOS_DEPLOYMENT_TARGET": "latest_iphoneos",
			"PRODUCT_NAME": name
		] as [String: Any]
	} else {
		return [
			"PRODUCT_NAME": name
		] as [String: Any]
	}
}

func projectTargets(_ platform: Platform) -> [Any] {
	return [
		[
			"Dependencies": [
				"com.cocoawithlove.CwlViews-\(platform.newName)"
			] as [Any],
			"BuildPhases": [
				[
					"Class": "Sources"
				] as [String: Any],
				[
					"DstSubfolderSpec": 10 as NSNumber,
					"Class": "CopyFiles"
				] as [String: Any]
			] as [Any],
			"ProductType": "com.apple.product-type.application",
			"TargetIdentifier":
				platform.isIos ?
					"com.apple.dt.cocoaTouchApplicationTarget" :
					"com.apple.dt.cocoaApplicationTarget",
			"SharedSettings": [
				"ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
				"COMBINE_HIDPI_IMAGES": "YES",
				"LD_RUNPATH_SEARCH_PATHS": "$(inherited) @executable_path/Frameworks"
			] as [String: Any]
		] as [String: Any],
		[
			"TargetType": "Aggregate",
			"BuildPhases": [
				[
					"Class": "ShellScript",
					"InputFiles": [
						"$(SRCROOT)/Package.swift"
					] as [Any],
					"ShellScript": packageFetchScript(),
					"OutputFiles": [
						"$(OBJROOT)/dependencies-state.json"
					] as [Any],
					"ShellPath": "/usr/bin/xcrun --sdk macosx swift"
				] as [String: Any]
			] as [Any],
			"Name": "FetchDependencies",
			"TargetIdentifier": "com.cocoawithlove.fetchdependencies",
			"SharedSettings": [
				"PRODUCT_NAME": "$(TARGET_NAME)"
			] as [String: Any]
		] as [String: Any],
		[
			"Name": "CwlUtils_\(platform.newName)",
			"Dependencies": [
				"com.cocoawithlove.CwlViews-\(platform.newName)"
			] as [Any],
			"ProductType": "com.apple.product-type.framework",
			"TargetIdentifier": "com.cocoawithlove.CwlUtils-\(platform.newName)",
			"SharedSettings": sharedSettings(platform, name: "CwlUtils")
		] as [String: Any],
		[
			"Name": "CwlSignal_\(platform.newName)",
			"Dependencies": [
				"com.cocoawithlove.CwlViews-\(platform.newName)"
			] as [Any],
			"ProductType": "com.apple.product-type.framework",
			"TargetIdentifier": "com.cocoawithlove.CwlSignal-\(platform.newName)",
			"SharedSettings": sharedSettings(platform, name: "CwlSignal")
		] as [String: Any],
		[
			"Name": "CwlViews_\(platform.newName)",
			"Dependencies": [
				"com.cocoawithlove.fetchdependencies"
			] as [Any],
			"BuildPhases": [
				[
					"Class": "ShellScript",
					"InputFiles": [
						"$(OBJROOT)/dependencies-state.json"
					] as [Any],
					"ShellScript": """
						if [ "$CARTHAGE" == "YES" ]; then
							cp -R "$SRCROOT/Carthage/Build/\(platform.oldName)/CwlUtils.framework" "$BUILT_PRODUCTS_DIR/"
							cp -R "$SRCROOT/Carthage/Build/\(platform.oldName)/CwlSignal.framework" "$BUILT_PRODUCTS_DIR/"
							cp -R "$SRCROOT/Carthage/Build/\(platform.oldName)/CwlViews.framework" "$BUILT_PRODUCTS_DIR/"
							exit
						fi
						"$DEVELOPER_BIN_DIR/xcodebuild" -project "$OBJROOT/cwl_symlinks/CwlViews/CwlViews.xcodeproj" -target CwlViews_\(platform.newName) -sdk "$SDKROOT" -configuration "$CONFIGURATION" $ACTION SRCROOT="$SRCROOT" SYMROOT="$SYMROOT" OBJROOT="$OBJROOT" ARCHS="$ARCHS" ONLY_ACTIVE_ARCH="$ONLY_ACTIVE_ARCH" BITCODE_GENERATION_MODE="$BITCODE_GENERATION_MODE" MODULE_CACHE_DIR="$MODULE_CACHE_DIR" DSTROOT="$DSTROOT" CACHE_ROOT="$CACHE_ROOT"
						
						""",
					"OutputFiles": [
						"$(BUILT_PRODUCTS_DIR)/CwlViews.framework/CwlViews"
					] as [Any],
					"ShellPath": "/bin/sh"
				] as [String: Any]
			] as [Any],
			"ProductType": "com.apple.product-type.framework",
			"TargetIdentifier": "com.cocoawithlove.CwlViews-\(platform.newName)",
			"SharedSettings": sharedSettings(platform, name: "CwlViews")
		] as [String: Any]
	] as [Any]
}

func iOSMainContent() -> String {
	return """
		private let doc = DocumentAdapter(document: Document())
		private let viewState = Var(NavViewState())

		#if DEBUG
			let docLog = doc.stateSignal.logJson(prefix: "Document changed: ")
			let viewLog = viewState.logJson(prefix: "View-state changed: ")
		#endif

		func application(_ viewState: Var<NavViewState>, _ doc: DocumentAdapter) -> Application {
			return Application(
				.window -- Window(
					.rootViewController <-- viewState.map { navState in
						navViewController(navState, doc)
					}
				),
				.didEnterBackground --> Input().map { .save }.bind(to: doc),
				.willEncodeRestorableState -- { $0.encodeLatest(from: viewState) },
				.didDecodeRestorableState -- { $0.decodeSend(to: viewState) }
			)
		}

		applicationMain { application(viewState, doc) }
		"""
}

func iOSNavViewContent() -> String {
	return """
		typealias NavPathElement = MasterOrDetail<TableViewState, DetailViewState>
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
				.poppedToCount --> navState.navStack.poppedToCount,
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
		"""
}

func iOSTableViewContent() -> String {
	return """
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
				.cancelOnClose -- [
					tableState.selection
						.compactMap { $0.data }
						.map { .detail(DetailViewState(row: $0)) }
						.cancellableBind(to: navState.navStack.pushInput)
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
					.didSelectRow --> tableState.selection,
					.deselectRow <-- tableState.selection
						.debounce(interval: .milliseconds(250), context: .main)
						.map { .animate($0.indexPath) },
					.isEditing <-- tableState.isEditing.animate(),
					.commit --> Input()
						.map { .removeAtIndex($0.row.indexPath.row) }
						.bind(to: doc),
					.userDidScrollToRow --> Input()
						.map { $0.indexPath }
						.bind(to: tableState.firstRow.updatingInput),
					.scrollToRow <-- tableState.firstRow
						.map { .set(.none($0)) },
					.separatorInset -- UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
				)
			)
		}

		func navItem(tableState: TableViewState, doc: DocumentAdapter) -> NavigationItem {
			return NavigationItem(
				.title -- .helloWorld,
				.leftBarButtonItems <-- tableState.isEditing.map { e in
					[BarButtonItem(
						.barButtonSystemItem -- e ? .done : .edit,
						.action --> Input()
							.map { !e }
							.bind(to: tableState.isEditing)
					)]
				}.animate(),
				.rightBarButtonItems -- .set([BarButtonItem(
					.barButtonSystemItem -- .add,
					.action --> Input()
						.map { .add }
						.bind(to: doc)
				)])
			)
		}

		private extension String {
			static let textRowIdentifier = "TextRow"
			static let rowText = NSLocalizedString("This is row #%@", comment: "")
			static let helloWorld = NSLocalizedString("Hello, world!", comment: "")
		}
		"""
}

func iOSDetailViewContent() -> String {
	return """
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
		"""
}

func documentAdapterContent() -> String {
	return """
		struct DocumentAdapter: SignalInputInterface {
			enum Message {
				case add
				case removeAtIndex(Int)
				case save
			}
			typealias InputValue = Message
			
			let adapter: FilteredAdapter<Message, Document, Document.Notification>
			var input: SignalInput<Message> { return adapter.pair.input }
			var stateSignal: Signal<Document> { return adapter.stateSignal }
			
			init(document: Document) {
				self.adapter = FilteredAdapter(initialState: document) { (document: inout Document, change: Message) in
					switch change {
					case .add: return document.add()
					case .removeAtIndex(let i): return document.remove(index: i)
					case .save: return try document.save()
					}
				}
			}
			
			func rowsSignal() -> Signal<ArrayMutation<String>> {
				return adapter.filteredSignal { (document: Document, notification: Document.Notification?, next: SignalNext<ArrayMutation<String>>) in
					switch notification ?? .reload {
					case .addedRowIndex(let i): next.send(value: .inserted(document.rows[i], at: i))
					case .removedRowIndex(let i): next.send(value: .deleted(at: i))
					case .reload: next.send(value: .reload(document.rows))
					case .none: break
					}
				}
			}
		}
		"""
}

func documentContent() -> String {
	return """
		struct Document: Codable {
			enum Notification {
				case addedRowIndex(Int)
				case removedRowIndex(Int)
				case reload
				case none
			}
			
			var rows: [String]
			var lastAddedIndex: Int
			
			init() {
				do {
					self = try JSONDecoder().decode(Document.self, from: Data(contentsOf: Document.saveUrl()))
				} catch {
					lastAddedIndex = 3
					rows = ["1", "2", "3"]
				}
			}
			
			static func saveUrl() throws -> URL {
				return try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(.documentFileName)
			}
			
			func save() throws -> Notification {
				try JSONEncoder().encode(self).write(to: Document.saveUrl())
				return .none
			}
			
			mutating func add() -> Notification {
				lastAddedIndex += 1
				rows.append(String(describing: lastAddedIndex))
				return .addedRowIndex(rows.count - 1)
			}
			
			mutating func remove(index: Int) -> Notification {
				if rows.indices.contains(index) {
					rows.remove(at: index)
					return .removedRowIndex(index)
				}
				return .none
			}
		}

		private extension String {
			static let documentFileName = "document.json"
		}
		"""
}

func macMainContent() -> String {
	return """
		typealias AppModel = MainWindowModel
		private let viewModel = MainWindowModel()

		Application.run([
			Application.terminate <-- viewModel.terminate.signal,
			Application.mainMenu <-- mainMenu(appModel: viewModel),
			Application.content <-- [mainWindow(viewModel: viewModel)]
		])
		"""
}

func macMainWindowContents() -> String {
	return """
		struct MainWindowModel {
			static func load() -> String {
				return UserDefaults.standard.string(forKey: .mainWindowTextSaveKey) ?? .defaultText
			}
			let text = SimpleAdapter(initialValue: MainWindowModel.load()) { last, current in
				return (current, current)
			}
			let terminate = Variable<Void>(continuous: false)
			func save() {
				UserDefaults.standard.setValue(text.signal.poll, forKey: .mainWindowTextSaveKey)
			}
		}
		
		func mainWindow(viewModel: MainWindowModel) -> NSWindow {
			return Window.construct(
				Window.contentHeight <-- 150,
				Window.contentWidth <-- WindowSize(anchor: .screen, scale: 0.25),
				Window.frameAutosaveName <-- .mainWindowFrame,
				Window.frameHorizontal <-- WindowPlacement(windowAnchor: .center),
				Window.frameVertical <-- WindowPlacement(windowAnchor: .maxEdge, screenAnchor: .maxEdge, scale: 0.75),
				Window.title <-- viewModel.text.signal,
				View.layout <-- .vertical(
					.view(TextField.label(
						Control.value <-- .stringValue(.changeWindowTitle)
					), size: nil),
					.view(TextField.construct(
						Control.value <-- viewModel.text.signal.map { .stringValue($0) },
						Control.textDidChange -- { text in _ = viewModel.text.input.send(value: text.string) }
					), size: nil)
				),
				Window.shouldClose -- { _ in viewModel.save(); return true },
				Window.willClose --> viewModel.terminate.input
			)
		}
		
		extension String {
			static let mainWindowTextSaveKey = "mainWindowTextSaveKey"
			static let changeWindowTitle = NSLocalizedString("Change the window title:", comment: "")
			static let defaultText = NSLocalizedString("Hello world!", comment: "")
		}
		
		extension NSWindow.FrameAutosaveName {
			static let mainWindowFrame = NSWindow.FrameAutosaveName(rawValue: "mainWindowFrame")
		}
				
		"""
}

func macMainMenuContent() -> String {
	return """
		func mainMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.items <-- [
					MenuItem.construct(MenuItem.submenu <-- applicationMenu(appModel: appModel)),
					MenuItem.construct(MenuItem.submenu <-- fileMenu(appModel: appModel)),
					MenuItem.construct(MenuItem.submenu <-- editMenu(appModel: appModel)),
					MenuItem.construct(MenuItem.submenu <-- formatMenu(appModel: appModel)),
					MenuItem.construct(MenuItem.submenu <-- viewMenu(appModel: appModel)),
					MenuItem.construct(MenuItem.submenu <-- windowsMenu(appModel: appModel)),
					MenuItem.construct(MenuItem.submenu <-- helpMenu(appModel: appModel)),
				]
			)
		}
		
		fileprivate let executableName = (Bundle.main.localizedInfoDictionary?[kCFBundleNameKey as String] as? String) ?? (Bundle.main.localizedInfoDictionary?[kCFBundleExecutableKey as String] as? String) ?? ProcessInfo.processInfo.processName
		
		func applicationMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.title <-- executableName,
				Menu.systemMenu <-- .apple,
				Menu.items <-- [
					MenuItem.construct(
						MenuItem.title <-- .localizedStringWithFormat(.about, executableName),
						MenuItem.action --> #selector(NSApplication.orderFrontStandardAboutPanel(_:))
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .preferences,
						MenuItem.keyEquivalent <-- ","
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .services,
						MenuItem.submenu <-- Menu.construct(Menu.systemMenu <-- .services)
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .localizedStringWithFormat(.hide, executableName),
						MenuItem.action --> #selector(NSApplication.hide(_:)),
						MenuItem.keyEquivalent <-- "h"
					),
					MenuItem.construct(
						MenuItem.title <-- .hideOthers,
						MenuItem.action --> #selector(NSApplication.hideOtherApplications(_:)),
						MenuItem.keyEquivalent <-- "h",
						MenuItem.keyEquivalentModifierMask <-- [.option, .command]
					),
					MenuItem.construct(
						MenuItem.title <-- .showAll,
						MenuItem.action --> #selector(NSApplication.unhideAllApplications(_:))
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .localizedStringWithFormat(.quit, executableName),
						MenuItem.action --> #selector(NSApplication.terminate(_:)),
						MenuItem.keyEquivalent <-- "q"
					),
				]
			)
		}
		
		func fileMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.title <-- .file,
				Menu.items <-- [
					MenuItem.construct(
						MenuItem.title <-- .new,
						MenuItem.action --> #selector(NSDocumentController.newDocument(_:)),
						MenuItem.keyEquivalent <-- "n"
					),
					MenuItem.construct(
						MenuItem.title <-- .open,
						MenuItem.action --> #selector(NSDocumentController.openDocument(_:)),
						MenuItem.keyEquivalent <-- "o"
					),
					MenuItem.construct(
						MenuItem.title <-- .openRecent,
						MenuItem.submenu <-- Menu.construct(
							Menu.systemMenu <-- .recentDocuments,
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .clearMenu,
									MenuItem.action --> #selector(NSDocumentController.clearRecentDocuments(_:))
								),
							]
						)
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .close,
						MenuItem.action --> #selector(NSDocumentController.openDocument(_:)),
						MenuItem.keyEquivalent <-- "w"
					),
					MenuItem.construct(
						MenuItem.title <-- .save,
						MenuItem.action --> #selector(NSDocumentController.openDocument(_:)),
						MenuItem.keyEquivalent <-- "s"
					),
					MenuItem.construct(
						MenuItem.title <-- .saveAs,
						MenuItem.action --> #selector(NSDocumentController.openDocument(_:)),
						MenuItem.keyEquivalent <-- "s",
						MenuItem.keyEquivalentModifierMask <-- [.shift, .command]
					),
					MenuItem.construct(
						MenuItem.title <-- .revertToSaved,
						MenuItem.action --> #selector(NSDocument.revertToSaved(_:)),
						MenuItem.keyEquivalent <-- "r"
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .pageSetup,
						MenuItem.action --> #selector(NSDocument.runPageLayout(_:)),
						MenuItem.keyEquivalent <-- "p",
						MenuItem.keyEquivalentModifierMask <-- [.shift, .command]
					),
					MenuItem.construct(
						MenuItem.title <-- .print,
						MenuItem.action --> #selector(NSDocument.printDocument(_:)),
						MenuItem.keyEquivalent <-- "p"
					),
				]
			)
		}
		
		func editMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.title <-- .edit,
				Menu.items <-- [
					MenuItem.construct(
						MenuItem.title <-- .undo,
						MenuItem.action --> Selector(("undo:")),
						MenuItem.keyEquivalent <-- "z"
					),
					MenuItem.construct(
						MenuItem.title <-- .redo,
						MenuItem.action --> Selector(("redo:")),
						MenuItem.keyEquivalent <-- "Z",
						MenuItem.keyEquivalentModifierMask <-- [.shift, .command]
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .cut,
						MenuItem.action --> #selector(NSText.cut(_:)),
						MenuItem.keyEquivalent <-- "x"
					),
					MenuItem.construct(
						MenuItem.title <-- .copy,
						MenuItem.action --> #selector(NSText.copy(_:)),
						MenuItem.keyEquivalent <-- "c"
					),
					MenuItem.construct(
						MenuItem.title <-- .paste,
						MenuItem.action --> #selector(NSText.paste(_:)),
						MenuItem.keyEquivalent <-- "v"
					),
					MenuItem.construct(
						MenuItem.title <-- .pasteAndMatchStyle,
						MenuItem.action --> #selector(NSTextView.pasteAsPlainText(_:)),
						MenuItem.keyEquivalent <-- "v",
						MenuItem.keyEquivalentModifierMask <-- [.shift, .option, .command]
					),
					MenuItem.construct(
						MenuItem.title <-- .delete,
						MenuItem.action --> #selector(NSText.delete(_:))
					),
					MenuItem.construct(
						MenuItem.title <-- .selectAll,
						MenuItem.action --> #selector(NSText.selectAll(_:)),
						MenuItem.keyEquivalent <-- "a"
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .find,
						MenuItem.submenu <-- Menu.construct(
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .findEllipsis,
									MenuItem.action --> #selector(NSTextView.performFindPanelAction(_:)),
									MenuItem.keyEquivalent <-- "f",
									MenuItem.tag <-- 1
								),
								MenuItem.construct(
									MenuItem.title <-- .findAndReplace,
									MenuItem.action --> #selector(NSTextView.performFindPanelAction(_:)),
									MenuItem.keyEquivalent <-- "f",
									MenuItem.keyEquivalentModifierMask <-- [.option, .command],
									MenuItem.tag <-- 12
								),
								MenuItem.construct(
									MenuItem.title <-- .findNext,
									MenuItem.action --> #selector(NSTextView.performFindPanelAction(_:)),
									MenuItem.keyEquivalent <-- "g",
									MenuItem.tag <-- 2
								),
								MenuItem.construct(
									MenuItem.title <-- .findPrevious,
									MenuItem.action --> #selector(NSTextView.performFindPanelAction(_:)),
									MenuItem.keyEquivalent <-- "g",
									MenuItem.keyEquivalentModifierMask <-- [.shift, .command],
									MenuItem.tag <-- 3
								),
								MenuItem.construct(
									MenuItem.title <-- .useSelectionForFind,
									MenuItem.action --> #selector(NSTextView.performFindPanelAction(_:)),
									MenuItem.keyEquivalent <-- "e",
									MenuItem.tag <-- 7
								),
								MenuItem.construct(
									MenuItem.title <-- .jumpToSelection,
									MenuItem.action --> #selector(NSResponder.centerSelectionInVisibleArea(_:)),
									MenuItem.keyEquivalent <-- "j"
								)
							]
						)
					),
					MenuItem.construct(
						MenuItem.title <-- .spellingAndGrammar,
						MenuItem.submenu <-- Menu.construct(
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .showSpellingAndGrammar,
									MenuItem.action --> #selector(NSText.showGuessPanel(_:)),
									MenuItem.keyEquivalent <-- ":"
								),
								MenuItem.construct(
									MenuItem.title <-- .checkDocumentNow,
									MenuItem.action --> #selector(NSText.checkSpelling(_:)),
									MenuItem.keyEquivalent <-- ";"
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .checkSpellingWhileTyping,
									MenuItem.action --> #selector(NSTextView.toggleContinuousSpellChecking(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .checkGrammarWithSpelling,
									MenuItem.action --> #selector(NSTextView.toggleGrammarChecking(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .correctSpellingAutomatically,
									MenuItem.action --> #selector(NSTextView.toggleAutomaticSpellingCorrection(_:))
								)
							]
						)
					),
					MenuItem.construct(
						MenuItem.title <-- .substitutions,
						MenuItem.submenu <-- Menu.construct(
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .showSubstitutions,
									MenuItem.action --> #selector(NSTextView.orderFrontSubstitutionsPanel(_:)),
									MenuItem.keyEquivalent <-- ":"
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .smartCopyPaste,
									MenuItem.action --> #selector(NSTextView.toggleSmartInsertDelete(_:))
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .smartQuotes,
									MenuItem.action --> #selector(NSTextView.toggleAutomaticQuoteSubstitution(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .smartDashes,
									MenuItem.action --> #selector(NSTextView.toggleAutomaticDashSubstitution(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .smartLinks,
									MenuItem.action --> #selector(NSTextView.toggleAutomaticLinkDetection(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .dataDetectors,
									MenuItem.action --> #selector(NSTextView.toggleAutomaticDataDetection(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .textReplacement,
									MenuItem.action --> #selector(NSTextView.toggleAutomaticTextReplacement(_:))
								),
							]
						)
					),
					MenuItem.construct(
						MenuItem.title <-- .transformations,
						MenuItem.submenu <-- Menu.construct(
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .makeUpperCase,
									MenuItem.action --> #selector(NSResponder.uppercaseWord(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .makeLowerCase,
									MenuItem.action --> #selector(NSResponder.lowercaseWord(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .capitalize,
									MenuItem.action --> #selector(NSResponder.capitalizeWord(_:))
								),
							]
						)
					),
					MenuItem.construct(
						MenuItem.title <-- .speech,
						MenuItem.submenu <-- Menu.construct(
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .startSpeaking,
									MenuItem.action --> #selector(NSTextView.startSpeaking(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .stopSpeaking,
									MenuItem.action --> #selector(NSTextView.stopSpeaking(_:))
								)
							]
						)
					),
				]
			)
		}
		
		func formatMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.title <-- .format,
				Menu.items <-- [
					MenuItem.construct(
						MenuItem.title <-- .font,
						MenuItem.submenu <-- Menu.construct(
							Menu.systemMenu <-- .font,
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .showFonts,
									MenuItem.action --> #selector(NSFontManager.orderFrontFontPanel(_:)),
									MenuItem.keyEquivalent <-- "t"
								),
								MenuItem.construct(
									MenuItem.title <-- .bold,
									MenuItem.action --> #selector(NSFontManager.addFontTrait(_:)),
									MenuItem.keyEquivalent <-- "b",
									MenuItem.tag <-- 2
								),
								MenuItem.construct(
									MenuItem.title <-- .italic,
									MenuItem.action --> #selector(NSFontManager.addFontTrait(_:)),
									MenuItem.keyEquivalent <-- "i",
									MenuItem.tag <-- 1
								),
								MenuItem.construct(
									MenuItem.title <-- .underline,
									MenuItem.action --> #selector(NSText.underline(_:)),
									MenuItem.keyEquivalent <-- "u"
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .bigger,
									MenuItem.action --> #selector(NSFontManager.modifyFont(_:)),
									MenuItem.keyEquivalent <-- "+",
									MenuItem.tag <-- 3
								),
								MenuItem.construct(
									MenuItem.title <-- .smaller,
									MenuItem.action --> #selector(NSFontManager.modifyFont(_:)),
									MenuItem.keyEquivalent <-- "-",
									MenuItem.tag <-- 4
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .kern,
									MenuItem.submenu <-- Menu.construct(
										Menu.items <-- [
											MenuItem.construct(
												MenuItem.title <-- .useDefault,
												MenuItem.action --> #selector(NSTextView.useStandardKerning(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .useNone,
												MenuItem.action --> #selector(NSTextView.turnOffKerning(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .tighten,
												MenuItem.action --> #selector(NSTextView.tightenKerning(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .loosen,
												MenuItem.action --> #selector(NSTextView.loosenKerning(_:))
											),
										]
									)
								),
								MenuItem.construct(
									MenuItem.title <-- .ligatures,
									MenuItem.submenu <-- Menu.construct(
										Menu.items <-- [
											MenuItem.construct(
												MenuItem.title <-- .useDefault,
												MenuItem.action --> #selector(NSTextView.useStandardLigatures(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .useNone,
												MenuItem.action --> #selector(NSTextView.turnOffLigatures(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .useAll,
												MenuItem.action --> #selector(NSTextView.useAllLigatures(_:))
											)
										]
									)
								),
								MenuItem.construct(
									MenuItem.title <-- .baseline,
									MenuItem.submenu <-- Menu.construct(
										Menu.items <-- [
											MenuItem.construct(
												MenuItem.title <-- .useDefault,
												MenuItem.action --> #selector(NSTextView.unscript(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .superscript,
												MenuItem.action --> #selector(NSTextView.superscript(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .subscript,
												MenuItem.action --> #selector(NSTextView.subscript(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .raise,
												MenuItem.action --> #selector(NSTextView.raiseBaseline(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .lower,
												MenuItem.action --> #selector(NSTextView.lowerBaseline(_:))
											)
										]
									)
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .showColors,
									MenuItem.action --> #selector(NSApplication.orderFrontColorPanel(_:)),
									MenuItem.keyEquivalent <-- "c",
									MenuItem.keyEquivalentModifierMask <-- [.shift, .command]
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .copyStyle,
									MenuItem.action --> #selector(NSText.copyFont(_:)),
									MenuItem.keyEquivalent <-- "c",
									MenuItem.keyEquivalentModifierMask <-- [.option, .command]
								),
								MenuItem.construct(
									MenuItem.title <-- .pasteStyle,
									MenuItem.action --> #selector(NSText.pasteFont(_:)),
									MenuItem.keyEquivalent <-- "v",
									MenuItem.keyEquivalentModifierMask <-- [.option, .command]
								)
							]
						)
					),
					MenuItem.construct(
						MenuItem.title <-- .text,
						MenuItem.submenu <-- Menu.construct(
							Menu.items <-- [
								MenuItem.construct(
									MenuItem.title <-- .alignLeft,
									MenuItem.action --> #selector(NSText.alignLeft(_:)),
									MenuItem.keyEquivalent <-- "{"
								),
								MenuItem.construct(
									MenuItem.title <-- .center,
									MenuItem.action --> #selector(NSText.alignCenter(_:)),
									MenuItem.keyEquivalent <-- "|"
								),
								MenuItem.construct(
									MenuItem.title <-- .justify,
									MenuItem.action --> #selector(NSTextView.alignJustified(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .alignRight,
									MenuItem.action --> #selector(NSText.alignLeft(_:)),
									MenuItem.keyEquivalent <-- "}"
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .writingDirection,
									MenuItem.submenu <-- Menu.construct(
										Menu.items <-- [
											MenuItem.construct(
												MenuItem.title <-- .paragraph,
												MenuItem.isEnabled <-- false
											),
											MenuItem.construct(
												MenuItem.title <-- .default,
												MenuItem.action --> #selector(NSResponder.makeBaseWritingDirectionNatural(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .letfToRight,
												MenuItem.action --> #selector(NSResponder.makeBaseWritingDirectionLeftToRight(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .rightToLeft,
												MenuItem.action --> #selector(NSResponder.makeBaseWritingDirectionRightToLeft(_:))
											),
											NSMenuItem.separator(),
											MenuItem.construct(
												MenuItem.title <-- .selection,
												MenuItem.isEnabled <-- false
											),
											MenuItem.construct(
												MenuItem.title <-- .default,
												MenuItem.action --> #selector(NSResponder.makeTextWritingDirectionNatural(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .letfToRight,
												MenuItem.action --> #selector(NSResponder.makeTextWritingDirectionLeftToRight(_:))
											),
											MenuItem.construct(
												MenuItem.title <-- .rightToLeft,
												MenuItem.action --> #selector(NSResponder.makeTextWritingDirectionRightToLeft(_:))
											),
										]
									)
								),
								NSMenuItem.separator(),
								MenuItem.construct(
									MenuItem.title <-- .showRuler,
									MenuItem.action --> #selector(NSText.toggleRuler(_:))
								),
								MenuItem.construct(
									MenuItem.title <-- .copyRuler,
									MenuItem.action --> #selector(NSText.copyRuler(_:)),
									MenuItem.keyEquivalent <-- "c",
									MenuItem.keyEquivalentModifierMask <-- [.control, .command]
								),
								MenuItem.construct(
									MenuItem.title <-- .pasteRuler,
									MenuItem.action --> #selector(NSText.pasteRuler(_:)),
									MenuItem.keyEquivalent <-- "v",
									MenuItem.keyEquivalentModifierMask <-- [.control, .command]
								)
							]
						)
					)
				]
			)
		}
		
		func viewMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.title <-- .view,
				Menu.items <-- [
					MenuItem.construct(
						MenuItem.title <-- .showToolbar,
						MenuItem.action --> #selector(NSWindow.toggleToolbarShown(_:)),
						MenuItem.keyEquivalent <-- "t",
						MenuItem.keyEquivalentModifierMask <-- [.option, .command]
					),
					MenuItem.construct(
						MenuItem.title <-- .customizeToolbar,
						MenuItem.action --> #selector(NSWindow.runToolbarCustomizationPalette(_:))
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .showSidebar,
						MenuItem.action --> NSSelectorFromString("toggleSourceList:"),
						MenuItem.keyEquivalent <-- "s",
						MenuItem.keyEquivalentModifierMask <-- [.control, .command]
					),
					MenuItem.construct(
						MenuItem.title <-- .enterFullScreen,
						MenuItem.action --> #selector(NSWindow.toggleFullScreen(_:)),
						MenuItem.keyEquivalent <-- "f",
						MenuItem.keyEquivalentModifierMask <-- [.control, .command]
					)
				]
			)
		}
		
		func windowsMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.title <-- .window,
				Menu.systemMenu <-- .windows,
				Menu.items <-- [
					MenuItem.construct(
						MenuItem.title <-- .minimize,
						MenuItem.action --> #selector(NSWindow.performMiniaturize(_:)),
						MenuItem.keyEquivalent <-- "m"
					),
					MenuItem.construct(
						MenuItem.title <-- .zoom,
						MenuItem.action --> #selector(NSWindow.performZoom(_:))
					),
					NSMenuItem.separator(),
					MenuItem.construct(
						MenuItem.title <-- .bringAllToFront,
						MenuItem.action --> #selector(NSApplication.arrangeInFront(_:)),
						MenuItem.keyEquivalent <-- "s",
						MenuItem.keyEquivalentModifierMask <-- [.control, .command]
					)
				]
			)
		}
		
		func helpMenu(appModel: AppModel) -> NSMenu {
			return Menu.construct(
				Menu.title <-- .help,
				Menu.systemMenu <-- .help,
				Menu.items <-- [
					MenuItem.construct(
						MenuItem.title <-- .localizedStringWithFormat(.appHelp, executableName),
						MenuItem.action --> #selector(NSApplication.showHelp(_:)),
						MenuItem.keyEquivalent <-- "?"
					)
				]
			)
		}
		
		private extension String {
			// Application menu
			static let about = NSLocalizedString("About %@", tableName: "MainMenu", comment: "")
			static let preferences = NSLocalizedString("Preferences…", tableName: "MainMenu", comment: "")
			static let services = NSLocalizedString("Services", tableName: "MainMenu", comment: "")
			static let hide = NSLocalizedString("Hide %@", tableName: "MainMenu", comment: "")
			static let hideOthers = NSLocalizedString("Hide Others", tableName: "MainMenu", comment: "")
			static let showAll = NSLocalizedString("Show All", tableName: "MainMenu", comment: "")
			static let quit = NSLocalizedString("Quit %@", tableName: "MainMenu", comment: "")
			
			// File menu
			static let file = NSLocalizedString("File", tableName: "MainMenu", comment: "")
			static let new = NSLocalizedString("New", tableName: "MainMenu", comment: "")
			static let open = NSLocalizedString("Open…", tableName: "MainMenu", comment: "")
			static let openRecent = NSLocalizedString("Open Recent", tableName: "MainMenu", comment: "")
			static let clearMenu = NSLocalizedString("Clear Menu", tableName: "MainMenu", comment: "")
			static let close = NSLocalizedString("Close", tableName: "MainMenu", comment: "")
			static let save = NSLocalizedString("Save…", tableName: "MainMenu", comment: "")
			static let saveAs = NSLocalizedString("Save As…", tableName: "MainMenu", comment: "")
			static let revertToSaved = NSLocalizedString("Revert to Saved", tableName: "MainMenu", comment: "")
			static let pageSetup = NSLocalizedString("Page Setup…", tableName: "MainMenu", comment: "")
			static let print = NSLocalizedString("Print…", tableName: "MainMenu", comment: "")
			
			// Edit menu
			static let edit = NSLocalizedString("Edit", tableName: "MainMenu", comment: "")
			static let undo = NSLocalizedString("Undo", tableName: "MainMenu", comment: "")
			static let redo = NSLocalizedString("Redo", tableName: "MainMenu", comment: "")
			static let cut = NSLocalizedString("Cut", tableName: "MainMenu", comment: "")
			static let copy = NSLocalizedString("Copy", tableName: "MainMenu", comment: "")
			static let paste = NSLocalizedString("Paste", tableName: "MainMenu", comment: "")
			static let pasteAndMatchStyle = NSLocalizedString("Paste and Match Style", tableName: "MainMenu", comment: "")
			static let delete = NSLocalizedString("Delete", tableName: "MainMenu", comment: "")
			static let selectAll = NSLocalizedString("Select All", tableName: "MainMenu", comment: "")
			static let find = NSLocalizedString("Find", tableName: "MainMenu", comment: "")
			static let findEllipsis = NSLocalizedString("Find…", tableName: "MainMenu", comment: "")
			static let findAndReplace = NSLocalizedString("Find and Replace…", tableName: "MainMenu", comment: "")
			static let findNext = NSLocalizedString("Find Next", tableName: "MainMenu", comment: "")
			static let findPrevious = NSLocalizedString("Find Previous", tableName: "MainMenu", comment: "")
			static let useSelectionForFind = NSLocalizedString("Use Selection for Find", tableName: "MainMenu", comment: "")
			static let jumpToSelection = NSLocalizedString("Jump to Selection", tableName: "MainMenu", comment: "")
			static let spellingAndGrammar = NSLocalizedString("Spelling and Grammar", tableName: "MainMenu", comment: "")
			static let showSpellingAndGrammar = NSLocalizedString("Show Spelling and Grammar", tableName: "MainMenu", comment: "")
			static let checkDocumentNow = NSLocalizedString("Check Document Now", tableName: "MainMenu", comment: "")
			static let checkSpellingWhileTyping = NSLocalizedString("Check Spelling While Typing", tableName: "MainMenu", comment: "")
			static let checkGrammarWithSpelling = NSLocalizedString("Check Grammar With Spelling", tableName: "MainMenu", comment: "")
			static let correctSpellingAutomatically = NSLocalizedString("Correct Spelling Automatically", tableName: "MainMenu", comment: "")
			static let substitutions = NSLocalizedString("Substitutions", tableName: "MainMenu", comment: "")
			static let showSubstitutions = NSLocalizedString("Show Substitutions", tableName: "MainMenu", comment: "")
			static let smartCopyPaste = NSLocalizedString("Smart Copy/Paste", tableName: "MainMenu", comment: "")
			static let smartQuotes = NSLocalizedString("Smart Quotes", tableName: "MainMenu", comment: "")
			static let smartDashes = NSLocalizedString("Smart Dashes", tableName: "MainMenu", comment: "")
			static let smartLinks = NSLocalizedString("Smart Links", tableName: "MainMenu", comment: "")
			static let dataDetectors = NSLocalizedString("Data Detectors", tableName: "MainMenu", comment: "")
			static let textReplacement = NSLocalizedString("Text Replacement", tableName: "MainMenu", comment: "")
			static let transformations = NSLocalizedString("Transformations", tableName: "MainMenu", comment: "")
			static let makeUpperCase = NSLocalizedString("Make Upper Case", tableName: "MainMenu", comment: "")
			static let makeLowerCase = NSLocalizedString("Make Lower Case", tableName: "MainMenu", comment: "")
			static let capitalize = NSLocalizedString("Capitalize", tableName: "MainMenu", comment: "")
			static let speech = NSLocalizedString("Speech", tableName: "MainMenu", comment: "")
			static let startSpeaking = NSLocalizedString("Start Speaking", tableName: "MainMenu", comment: "")
			static let stopSpeaking = NSLocalizedString("Stop Speaking", tableName: "MainMenu", comment: "")
			
			// Format menu
			static let format = NSLocalizedString("Format", tableName: "MainMenu", comment: "")
			static let font = NSLocalizedString("Font", tableName: "MainMenu", comment: "")
			static let showFonts = NSLocalizedString("Show Fonts", tableName: "MainMenu", comment: "")
			static let bold = NSLocalizedString("Bold", tableName: "MainMenu", comment: "")
			static let italic = NSLocalizedString("Italic", tableName: "MainMenu", comment: "")
			static let underline = NSLocalizedString("Underline", tableName: "MainMenu", comment: "")
			static let bigger = NSLocalizedString("Bigger", tableName: "MainMenu", comment: "")
			static let smaller = NSLocalizedString("Smaller", tableName: "MainMenu", comment: "")
			static let kern = NSLocalizedString("Kern", tableName: "MainMenu", comment: "")
			static let tighten = NSLocalizedString("Tighten", tableName: "MainMenu", comment: "")
			static let loosen = NSLocalizedString("Loosen", tableName: "MainMenu", comment: "")
			static let ligatures = NSLocalizedString("Ligatures", tableName: "MainMenu", comment: "")
			static let useNone = NSLocalizedString("Use None", tableName: "MainMenu", comment: "")
			static let useAll = NSLocalizedString("Use All", tableName: "MainMenu", comment: "")
			static let baseline = NSLocalizedString("Baseline", tableName: "MainMenu", comment: "")
			static let useDefault = NSLocalizedString("Use Default", tableName: "MainMenu", comment: "")
			static let superscript = NSLocalizedString("Superscript", tableName: "MainMenu", comment: "")
			static let `subscript` = NSLocalizedString("Subscript", tableName: "MainMenu", comment: "")
			static let raise = NSLocalizedString("Raise", tableName: "MainMenu", comment: "")
			static let lower = NSLocalizedString("Lower", tableName: "MainMenu", comment: "")
			static let showColors = NSLocalizedString("Show Colors", tableName: "MainMenu", comment: "")
			static let copyStyle = NSLocalizedString("Copy Style", tableName: "MainMenu", comment: "")
			static let pasteStyle = NSLocalizedString("Paste Style", tableName: "MainMenu", comment: "")
			static let text = NSLocalizedString("Text", tableName: "MainMenu", comment: "")
			static let alignLeft = NSLocalizedString("Align Left", tableName: "MainMenu", comment: "")
			static let center = NSLocalizedString("Center", tableName: "MainMenu", comment: "")
			static let justify = NSLocalizedString("Justify", tableName: "MainMenu", comment: "")
			static let alignRight = NSLocalizedString("Align Right", tableName: "MainMenu", comment: "")
			static let writingDirection = NSLocalizedString("Writing Direction", tableName: "MainMenu", comment: "")
			static let paragraph = NSLocalizedString("Paragraph", tableName: "MainMenu", comment: "")
			static let selection = NSLocalizedString("Selection", tableName: "MainMenu", comment: "")
			static let `default` = NSLocalizedString("\\tDefault", tableName: "MainMenu", comment: "")
			static let letfToRight = NSLocalizedString("\\tLeft to Right", tableName: "MainMenu", comment: "")
			static let rightToLeft = NSLocalizedString("\\tRight to Left", tableName: "MainMenu", comment: "")
			static let showRuler = NSLocalizedString("Show Ruler", tableName: "MainMenu", comment: "")
			static let copyRuler = NSLocalizedString("Copy Ruler", tableName: "MainMenu", comment: "")
			static let pasteRuler = NSLocalizedString("Paste Ruler", tableName: "MainMenu", comment: "")
			
			// View menu
			static let view = NSLocalizedString("View", tableName: "MainMenu", comment: "")
			static let showToolbar = NSLocalizedString("Show Toolbar", tableName: "MainMenu", comment: "")
			static let customizeToolbar = NSLocalizedString("Customize Toolbar…", tableName: "MainMenu", comment: "")
			static let showSidebar = NSLocalizedString("Show Sidebar", tableName: "MainMenu", comment: "")
			static let enterFullScreen = NSLocalizedString("Enter Full Screen", tableName: "MainMenu", comment: "")
			
			// Winow menu
			static let window = NSLocalizedString("Window", tableName: "MainMenu", comment: "")
			static let minimize = NSLocalizedString("Minimize", tableName: "MainMenu", comment: "")
			static let zoom = NSLocalizedString("Zoom", tableName: "MainMenu", comment: "")
			static let bringAllToFront = NSLocalizedString("Bring All to Front", tableName: "MainMenu", comment: "")
			
			// Help menu
			static let help = NSLocalizedString("Help", tableName: "MainMenu", comment: "")
			static let appHelp = NSLocalizedString("%@ Help", tableName: "MainMenu", comment: "")
		}
		
		"""
}

func packageFetchScript() -> String {
	return """
	//
	//  CwlPackageFetch.swift
	//  CwlPackageFetch
	//
	//  Created by Matt Gallagher on 2017/01/31.
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

	import Foundation

	extension FileHandle: TextOutputStream { public func write(_ string: String) { string.data(using: .utf8).map { write($0) } } }
	var stdErrStream = FileHandle.standardError

	if let carthage = ProcessInfo.processInfo.environment["CARTHAGE"], carthage == "YES" {
		print("Disabling swift package manager dependency management in favor of Carthage.")
		exit(0)
	}

	guard let toolchainDir = ProcessInfo.processInfo.environment["TOOLCHAIN_DIR"] else {
		print("error: variable TOOLCHAIN_DIR (the location of swift) must be set", to: &stdErrStream)
		exit(1)
	}
	guard let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"].map({ URL(fileURLWithPath: $0) }) else {
		print("error: Environment variable SRCROOT (the root of the source tree) must be set", to: &stdErrStream)
		exit(1)
	}
	guard let buildDir = ProcessInfo.processInfo.environment["OBJROOT"] else {
		print("error: Environment variable OBJROOT (the build intermediates directory) must be set", to: &stdErrStream)
		exit(1)
	}

	// Avoid downloading a further copy during an archive build.
	let buildDirUrl = URL(fileURLWithPath: buildDir)
	let nonArchiveBuildDir: String
	let pathOffset: String
	if buildDirUrl.lastPathComponent == "IntermediateBuildFilesPath" && buildDirUrl.deletingLastPathComponent().deletingLastPathComponent().lastPathComponent == "ArchiveIntermediates" {
		nonArchiveBuildDir = buildDirUrl.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().path
		pathOffset = "../../../../"
	} else {
		nonArchiveBuildDir = buildDir
		pathOffset = "../"
	}

	// Launch a process and run to completion, returning the standard out on success.
	func launch(_ command: String, _ arguments: [String], directory: URL? = nil) -> String? {
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

	// STEP 0: if the `Package.swift` file doesn't exist, create it.
	// For anything *except* a CwlViews project, you'll need to customize this before it is useful.
	let packageURL = srcRoot.appendingPathComponent("Package.swift")
	print("### Testing existence of \\(packageURL.path)")
	if !FileManager.default.fileExists(atPath: packageURL.path) {
		guard let projectName = ProcessInfo.processInfo.environment["PROJECT_NAME"] else {
			print("error: If Package.swift not present, environment variable PROJECT_NAME must be set (will be used as the main target name)", to: &stdErrStream)
			exit(1)
		}
		let defaultPackageManifest = "// swift-tools-version:4.0\\nimport PackageDescription\\n\\nlet package = Package(\\n\\tname: \\"\\(projectName)\\",\\n\\tdependencies: [.package(url: \\"https://github.com/mattgallagher/CwlViews.git\\", from: \\"0.1.0\\")]\\n)\\n"
		if let _ = try? defaultPackageManifest.write(to: packageURL, atomically: true, encoding: .utf8) {
			print("Wrote default Package.swift file to \\(packageURL.path)")
		} else {
			print("error: Unable to write manifest file.", to: &stdErrStream)
			exit(1)
		}
	}

	// STEP 1: use `swift package update` to get all dependencies
	print("### Starting package resolve into \\(nonArchiveBuildDir)")
	#if swift(>=4)
	let verb = "resolve"
	#else
	let verb = "update"
	#endif
	if let fetchResult = launch(toolchainDir + "/usr/bin/swift", ["package", "--build-path", "\\(nonArchiveBuildDir)", verb], directory: srcRoot) {
		if fetchResult == "" {
			print("### All dependencies up-to-date.")
		} else {
			print(fetchResult, terminator: "")
		}
	} else {
		print("error: swift package resolve failed", to: &stdErrStream)
		exit(1)
	}

	// STEP 1.5: ensure that "dependencies-state.json" exists when running under Swift 3
	#if swift(>=4)
	#else
	let newPath = nonArchiveBuildDir + "/dependencies-state.json"
	let oldPath = nonArchiveBuildDir + "/workspace-state.json"
	let attributesNew = try? FileManager.default.attributesOfItem(atPath: newPath)
	let attributesOld = try? FileManager.default.attributesOfItem(atPath: oldPath)
	do {
		if let an = attributesNew, let ao = attributesOld, let anm = an[FileAttributeKey.modificationDate] as? Date, let aom = ao[FileAttributeKey.modificationDate] as? Date, aom > anm {
			try FileManager.default.removeItem(atPath: newPath)
			try FileManager.default.copyItem(atPath: oldPath, toPath: newPath)
		} else if attributesOld != nil && attributesNew == nil {
			try FileManager.default.copyItem(atPath: oldPath, toPath: newPath)
		}
	} catch {
		print(error, to: &stdErrStream)
		print("error: Unable to update dependencies-state.json", to: &stdErrStream)
		exit(1)
	}
	#endif


	// Create a symlink only if it is not already present and pointing to the destination
	let symlinksName = "cwl_symlinks"
	let symlinksURL = URL(fileURLWithPath: buildDir).appendingPathComponent(symlinksName)
	func createSymlink(srcRoot: URL, name: String, destination: String) throws {
		let location = symlinksURL.appendingPathComponent(name)
		let link = URL(fileURLWithPath: "\\(pathOffset)\\(destination)", relativeTo: location)
		let current = try? FileManager.default.destinationOfSymbolicLink(atPath: location.path)
		if current == nil || current != link.relativePath {
			_ = try? FileManager.default.removeItem(at: location)
			try FileManager.default.createSymbolicLink(atPath: location.path, withDestinationPath:
				link.relativePath)
			print("Created symbolic link: \\(location.path) -> \\(link.relativePath)")
		}
	}

	// Recursively parse the dependency graph JSON, creating symlinks in our own location
	func createSymlinks(srcRoot: URL, description: Dictionary<String, Any>, topLevelPath: String) throws {
		guard let dependencies = description["dependencies"] as? [Dictionary<String, Any>] else { return }
		for dependency in dependencies {
			#if swift(>=4)
				guard let path = dependency["path"] as? String, let relativePath = (path.range(of: topLevelPath)?.upperBound).map({ String(path[$0...]) }), let name = dependency["name"] as? String else {
					throw NSError(domain: "CwlError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Unable to parse dependency structure"])
				}
			#else
				guard let path = dependency["path"] as? String, let relativePath = (path.range(of: topLevelPath)?.upperBound).map({ path[$0...] }), let name = dependency["name"] as? String else {
					throw NSError(domain: "CwlError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Unable to parse dependency structure"])
				}
			#endif
			try createSymlink(srcRoot: srcRoot, name: name, destination: relativePath)
			try createSymlinks(srcRoot: srcRoot, description: dependency, topLevelPath: topLevelPath)
		}
	}

	// STEP 2: create symlinks from our stable locations to the fetched locations
	guard let descriptionString = launch(toolchainDir + "/usr/bin/swift", ["package", "--build-path", "\\(nonArchiveBuildDir)", "show-dependencies", "--format", "json"], directory: srcRoot) else {
		print("error: swift package show-dependencies failed", to: &stdErrStream)
		exit(1)
	}
	do {
		// Note that despite asking for JSON formatting, there may be log information on STDOUT before the JSON starts.
		#if swift(>=4)
			guard let jsonStartIndex = descriptionString.index(of: "{"), let descriptionData = String(descriptionString[jsonStartIndex...]).data(using: .utf8), let description = try JSONSerialization.jsonObject(with: descriptionData, options: []) as? Dictionary<String, Any> else {
				throw NSError(domain: "CwlError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Unable to parse dependency structure"])
			}
		#else
			guard let jsonStartIndex = descriptionString.index(of: "{"), let descriptionData = descriptionString[jsonStartIndex...].data(using: .utf8), let description = try JSONSerialization.jsonObject(with: descriptionData, options: []) as? Dictionary<String, Any> else {
				throw NSError(domain: "CwlError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Unable to parse dependency structure"])
			}
		#endif
		try FileManager.default.createDirectory(at: symlinksURL, withIntermediateDirectories: true, attributes: nil)
		try createSymlinks(srcRoot: srcRoot, description: description, topLevelPath: nonArchiveBuildDir + "/")
		print("### Complete.")
	} catch {
		print("error: symlink creation failed: \\(error)", to: &stdErrStream)
		print("Package description was...", to: &stdErrStream)
		print(descriptionString, to: &stdErrStream)
		exit(1)
	}
	"""
}

func templateIconPng() -> Data {
	return Data(base64Encoded: """
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
	+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
	K7TwH3CMLqoN/nlmAAAAAElFTkSuQmCC
	""", options: .ignoreUnknownCharacters)!
}

func templateIconPngAt2x() -> Data {
	return Data(base64Encoded: """
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
	""", options: .ignoreUnknownCharacters)!
}

run()
