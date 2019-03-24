//
//  CwlWebView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
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

import WebKit

// MARK: - Binder Part 1: Binder
public class WebView: Binder, WebViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension WebView {
	enum Binding: WebViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case allowsAirPlayForMediaPlayback(Constant<Bool>)
		case allowsInlineMediaPlayback(Constant<Bool>)
		case allowsPictureInPictureForMediaPlayback(Constant<Bool>)
		case applicationNameForUserAgent(Constant<String?>)
		case dataDetectorTypes(Constant<WKDataDetectorTypes>)
		case ignoresViewportScaleLimits(Constant<Bool>)
		case javaScriptCanOpenWindowsAutomatically(Constant<Bool>)
		case javaScriptEnabled(Constant<Bool>)
		case mediaTypesRequiringUserActionForPlayback(Constant<WKAudiovisualMediaTypes>)
		case minimumFontSize(Constant<CGFloat>)
		case processPool(Constant<WKProcessPool>)
		case selectionGranularity(Constant<WKSelectionGranularity>)
		case suppressesIncrementalRendering(Constant<Bool>)
		case urlSchemeHandlers(Constant<[String: WKURLSchemeHandler]>)
		case userContentController(Constant<WKUserContentController>)

		@available(macOS 10.10, *) @available(iOS, unavailable) case javaEnabled(Constant<Bool>)
		@available(macOS 10.10, *) @available(iOS, unavailable) case plugInsEnabled(Constant<Bool>)
		@available(macOS 10.10, *) @available(iOS, unavailable) case tabFocusesLinks(Constant<Bool>)
		@available(macOS 10.12, *) @available(iOS, unavailable) case userInterfaceDirectionPolicy(Constant<WKUserInterfaceDirectionPolicy>)
		@available(macOS, unavailable) @available(iOS 9, *) case allowsPictureInPictureMediaPlayback(Constant<Bool>)
		@available(macOS, unavailable) @available(iOS 11, *) case scrollView(Constant<ScrollView>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case allowsBackForwardNavigationGestures(Dynamic<Bool>)
		case allowsLinkPreview(Dynamic<Bool>)
		case customUserAgent(Dynamic<String?>)
		
		@available(macOS 10.13, *) @available(iOS, unavailable) case allowsMagnification(Dynamic<Bool>)
		@available(macOS 10.13, *) @available(iOS, unavailable) case magnification(Dynamic<(factor: CGFloat, centeredAt: CGPoint)>)
		
		//	2. Signal bindings are performed on the object after construction.
		case evaluateJavaScript(Signal<Callback<String, (Any?, Error?)>>)
		case goBack(Signal<Callback<Void, WKNavigation?>>)
		case goForward(Signal<Callback<Void, WKNavigation?>>)
		case goTo(Signal<Callback<WKBackForwardListItem, WKNavigation?>>)
		case load(Signal<Callback<URLRequest, WKNavigation?>>)
		case loadData(Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>)
		case loadFile(Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>)
		case loadHTMLString(Signal<Callback<(string: String, baseURL: URL?), WKNavigation?>>)
		case reload(Signal<Callback<Void, WKNavigation?>>)
		case reloadFromOrigin(Signal<Callback<Void, WKNavigation?>>)
		case stopLoading(Signal<Void>)
		
		//	3. Action bindings are triggered by the object after construction.
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case createWebView((_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?)
		case didClose((WKWebView) -> Void)
		case didCommit((WKWebView, WKNavigation) -> Void)
		case didStartProvisionalNavigation((WKWebView, WKNavigation) -> Void)
		case didReceiveServerRedirectForProvisionalNavigation((WKWebView, WKNavigation) -> Void)
		case didFail((WKWebView, WKNavigation, Error) -> Void)
		case didFailProvisionalNavigation((WKWebView, WKNavigation, Error) -> Void)
		case didFinish((WKWebView, WKNavigation) -> Void)
		case contentProcessDidTerminate((WKWebView) -> Void)
		case decideActionPolicy((WKWebView, WKNavigationAction, (WKNavigationActionPolicy) -> Void) -> Void)
		case decideResponsePolicy((WKWebView, WKNavigationResponse, (WKNavigationActionPolicy) -> Void) -> Void)
		case didReceiveAuthenticationChallenge((WKWebView, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)
		case runJavaScriptAlertPanel((WKWebView, String, WKFrameInfo, () -> Void) -> Void)
		case runJavaScriptConfirmPanel((WKWebView, String, WKFrameInfo, (Bool) -> Void) -> Void)
		case runJavaScriptTextInputPanel((WKWebView, String, String?, WKFrameInfo, (String?) -> Void) -> Void)
		
		@available(macOS, unavailable) @available(iOS 10.0, *) case commitPreviewingViewController((_ webView: WKWebView, _ previewingViewController: UIViewController) -> Void)
		@available(macOS, unavailable) @available(iOS 10.0, *) case previewingViewController((_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo, _ previewActions: [WKPreviewActionItem]) -> UIViewController?)
		@available(macOS 10.12, *) @available(iOS, unavailable) case runOpenPanel((WKWebView, WKOpenPanelParameters, WKFrameInfo, ([URL]?) -> Void) -> Void)
		@available(macOS, unavailable) @available(iOS 10.0, *) case shouldPreviewElement((_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo) -> Bool)
	}

	#if os(macOS)
		typealias UIViewController = ()
		typealias WKDataDetectorTypes = ()
		typealias WKPreviewElementInfo = ()
		typealias WKPreviewActionItem = ()
		typealias WKOpenPanelParameters = WebKit.WKOpenPanelParameters
		typealias WKSelectionGranularity = ()
		typealias WKUserInterfaceDirectionPolicy = WebKit.WKUserInterfaceDirectionPolicy
	#else
		typealias UIViewController = UIKit.UIViewController
		typealias WKDataDetectorTypes = WebKit.WKDataDetectorTypes
		typealias WKOpenPanelParameters = ()
		typealias WKPreviewElementInfo = WebKit.WKPreviewElementInfo
		typealias WKPreviewActionItem = WebKit.WKPreviewActionItem
		typealias WKSelectionGranularity = WebKit.WKSelectionGranularity
		typealias WKUserInterfaceDirectionPolicy = ()
	#endif
}

// MARK: - Binder Part 3: Preparer
public extension WebView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = WebView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = WKWebView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		mutating func webConfiguration() -> WKWebViewConfiguration {
			if let pwc = possibleWebConfiguration {
				return pwc
			}
			let newConfiguration = WKWebViewConfiguration()
			possibleWebConfiguration = newConfiguration
			return newConfiguration
		}
		var possibleWebConfiguration: WKWebViewConfiguration?
		
		mutating func webPreferences() -> WKPreferences {
			return webConfiguration().preferences
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension WebView.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		
		case .allowsAirPlayForMediaPlayback(let x): webConfiguration().allowsAirPlayForMediaPlayback = x.value
		case .allowsInlineMediaPlayback(let x):
			#if os(iOS)
				webConfiguration().allowsInlineMediaPlayback = x.value
			#endif
		case .allowsPictureInPictureMediaPlayback(let x):
			#if os(iOS)
				webConfiguration().allowsPictureInPictureMediaPlayback = x.value
			#endif
		case .applicationNameForUserAgent(let x): webConfiguration().applicationNameForUserAgent = x.value
		case .dataDetectorTypes(let x): 
			#if os(iOS)
				webConfiguration().dataDetectorTypes = x.value
			#endif
		case .ignoresViewportScaleLimits(let x):
			#if os(iOS)
				webConfiguration().ignoresViewportScaleLimits = x.value
			#endif
		case .javaEnabled(let x):
			#if os(macOS)
				webPreferences().javaEnabled = x.value
			#endif
		case .javaScriptCanOpenWindowsAutomatically(let x): webPreferences().javaScriptCanOpenWindowsAutomatically = x.value
		case .javaScriptEnabled(let x): webPreferences().javaScriptEnabled = x.value
		case .mediaTypesRequiringUserActionForPlayback(let x): webConfiguration().mediaTypesRequiringUserActionForPlayback = x.value
		case .minimumFontSize(let x): webPreferences().minimumFontSize = x.value
		case .plugInsEnabled(let x):
			#if os(macOS)
				webPreferences().plugInsEnabled = x.value
			#endif
		case .processPool(let x): webConfiguration().processPool = x.value
		case .selectionGranularity(let x): 
			#if os(iOS)
				webConfiguration().selectionGranularity = x.value
			#endif
		case .suppressesIncrementalRendering(let x): webConfiguration().suppressesIncrementalRendering = x.value
		case .tabFocusesLinks(let x):
			#if os(macOS)
				webPreferences().tabFocusesLinks = x.value
			#endif
		case .urlSchemeHandlers(let x):
			for (key, value) in x.value {
				webConfiguration().setURLSchemeHandler(value, forURLScheme: key)
			}
		case .userContentController(let x): webConfiguration().userContentController = x.value

		case .didClose(let x): delegate().addMultiHandler1(x, #selector(WKUIDelegate.webViewDidClose(_:)))
		case .didCommit(let x): delegate().addMultiHandler2(x, #selector(WKNavigationDelegate.webView(_:didCommit:)))
		case .didStartProvisionalNavigation(let x): delegate().addMultiHandler2(x, #selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:)))
		case .didReceiveServerRedirectForProvisionalNavigation(let x): delegate().addMultiHandler2(x, #selector(WKNavigationDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:)))
		case .didFail(let x): delegate().addMultiHandler3(x, #selector(WKNavigationDelegate.webView(_:didFail:withError:)))
		case .didFailProvisionalNavigation(let x): delegate().addMultiHandler3(x, #selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:)))
		case .didFinish(let x): delegate().addMultiHandler2(x, #selector(WKNavigationDelegate.webView(_:didFinish:)))
		case .contentProcessDidTerminate(let x): delegate().addMultiHandler1(x, #selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:)))
		case .decideActionPolicy(let x): delegate().addMultiHandler3(x, #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView,WKNavigationAction, @escaping (WKNavigationActionPolicy) -> Void) -> Void)?))
		case .decideResponsePolicy(let x): delegate().addMultiHandler3(x, #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView, WKNavigationResponse, @escaping (WKNavigationResponsePolicy) -> Void) -> Void)?))
		case .didReceiveAuthenticationChallenge(let x): delegate().addMultiHandler3(x, #selector(WKNavigationDelegate.webView(_:didReceive:completionHandler:)))
		case .runJavaScriptAlertPanel(let x): delegate().addMultiHandler4(x, #selector(WKUIDelegate.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)))
		case .runJavaScriptConfirmPanel(let x): delegate().addMultiHandler4(x, #selector(WKUIDelegate.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)))
		case .runJavaScriptTextInputPanel(let x): delegate().addMultiHandler5(x, #selector(WKUIDelegate.webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)))
		case .createWebView(let x): delegate().addSingleHandler4(x, #selector(WKUIDelegate.webView(_:createWebViewWith:for:windowFeatures:)))
		case .runOpenPanel(let x):
			#if os(macOS)
				delegate().addMultiHandler4(x, #selector(WKUIDelegate.webView(_:runOpenPanelWith:initiatedByFrame:completionHandler:)))
			#endif
		case .shouldPreviewElement(let x):
			#if os(iOS)
				delegate().addSingleHandler2(x, #selector(WKUIDelegate.webView(_:shouldPreviewElement:)))
			#endif
		case .previewingViewController(let x):
			#if os(iOS)
				delegate().addSingleHandler3(x, #selector(WKUIDelegate.webView(_:previewingViewControllerForElement:defaultActions:)))
			#endif
		case .commitPreviewingViewController(let x):
			#if os(iOS)
				delegate().addMultiHandler2(x, #selector(WKUIDelegate.webView(_:commitPreviewingViewController:)))
			#endif
		default: break
		}
	}
	
	func constructInstance(type: WKWebView.Type, parameters: ()) -> WKWebView {
		if let configuration = possibleWebConfiguration {
			return type.init(frame: .zero, configuration: configuration)
		} else {
			return type.init(frame: .zero)
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		prepareDelegate(instance: instance, storage: storage)
		if delegateIsRequired {
			precondition(instance.uiDelegate == nil, "Conflicting delegate applied to instance")
			instance.uiDelegate = storage
		}
		inheritedPrepareInstance(instance, storage: storage)
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .allowsAirPlayForMediaPlayback: return nil
		case .allowsInlineMediaPlayback: return nil
		case .allowsPictureInPictureForMediaPlayback: return nil
		case .applicationNameForUserAgent: return nil
		case .dataDetectorTypes: return nil
		case .ignoresViewportScaleLimits: return nil
		case .javaScriptCanOpenWindowsAutomatically: return nil
		case .javaScriptEnabled: return nil
		case .mediaTypesRequiringUserActionForPlayback: return nil
		case .minimumFontSize: return nil
		case .processPool: return nil
		case .selectionGranularity: return nil
		case .suppressesIncrementalRendering: return nil
		case .urlSchemeHandlers: return nil
		case .userContentController: return nil
		case .javaEnabled: return nil
		case .plugInsEnabled: return nil
		case .tabFocusesLinks: return nil
		case .userInterfaceDirectionPolicy: return nil
		case .allowsPictureInPictureMediaPlayback: return nil
		
		case .scrollView(let x):
			#if os(macOS)
				return nil
			#else
				x.value.apply(to: instance.scrollView)
				return nil
			#endif
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .allowsBackForwardNavigationGestures(let x): return x.apply(instance) { i, v in i.allowsBackForwardNavigationGestures = v }
		
		case .allowsLinkPreview(let x):
			return x.apply(instance) { i, v in
				i.allowsLinkPreview = v
			}
		case .allowsMagnification(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.allowsMagnification = v }
			#else
				return nil
			#endif
		case .customUserAgent(let x):
			return x.apply(instance) { i, v in
				i.customUserAgent = v
			}
		case .magnification(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.setMagnification(v.factor, centeredAt: v.centeredAt) }
			#else
				return nil
			#endif
		
		//	2. Signal bindings are performed on the object after construction.
		case .evaluateJavaScript(let x): return x.apply(instance) { i, v in i.evaluateJavaScript(v.value) { (output, error) in v.callback.send(value: (output, error)) } }
		case .goBack(let x): return x.apply(instance) { i, v in v.callback.send(value: i.goBack()) }
		case .goForward(let x):return x.apply(instance) { i, v in v.callback.send(value: i.goForward()) }
		case .goTo(let x): return x.apply(instance) { i, v in v.callback.send(value: i.go(to: v.value)) }
		case .load(let x): return x.apply(instance) { i, v in v.callback.send(value: i.load(v.value)) }
		case .loadHTMLString(let x): return x.apply(instance) { i, v in v.callback.send(value: i.loadHTMLString(v.value.string, baseURL: v.value.baseURL)) }
		case .reload(let x): return x.apply(instance) { i, v in v.callback.send(value: i.reload()) }
		case .reloadFromOrigin(let x): return x.apply(instance) { i, v in v.callback.send(value: i.reloadFromOrigin()) }
		case .stopLoading(let x): return x.apply(instance) { i, v in i.stopLoading() }

		case .loadData(let x): return x.apply(instance) { i, v in v.callback.send(value: i.load(v.value.data, mimeType: v.value.mimeType, characterEncodingName: v.value.characterEncodingName, baseURL: v.value.baseURL)) }
		case .loadFile(let x): return x.apply(instance) { i, v in v.callback.send(value: i.loadFileURL(v.value.url, allowingReadAccessTo: v.value.allowingReadAccessTo)) }
			
		//	3. Action bindings are triggered by the object after construction.
		case .contentProcessDidTerminate: return nil
		case .decideActionPolicy: return nil
		case .decideResponsePolicy: return nil
		case .didCommit: return nil
		case .didFail: return nil
		case .didFailProvisionalNavigation: return nil
		case .didFinish: return nil
		case .didReceiveAuthenticationChallenge: return nil
		case .didReceiveServerRedirectForProvisionalNavigation: return nil
		case .didStartProvisionalNavigation: return nil
		case .runJavaScriptAlertPanel: return nil
		case .runJavaScriptConfirmPanel: return nil
		case .runJavaScriptTextInputPanel: return nil

		case .didClose: return nil
		case .runOpenPanel: return nil

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .createWebView: return nil
		
		case .commitPreviewingViewController: return nil
		case .previewingViewController: return nil
		case .shouldPreviewElement: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension WebView.Preparer {
	open class Storage: View.Preparer.Storage, WKUIDelegate, WKNavigationDelegate {}

	open class Delegate: DynamicDelegate, WKUIDelegate, WKNavigationDelegate {
		open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
			multiHandler(webView, navigation)
		}
		
		open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
			multiHandler(webView, navigation)
		}
		
		open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
			multiHandler(webView, navigation)
		}
		
		open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
			multiHandler(webView, (navigation, error))
		}
		
		open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
			multiHandler(webView, (navigation, error))
		}
		
		open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			multiHandler(webView, navigation)
		}
		
		open func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
			multiHandler(webView, ())
		}
		
		open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			multiHandler(webView, navigationAction, decisionHandler)
		}
		
		open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
			multiHandler(webView, navigationResponse, decisionHandler)
		}
		
		open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
			multiHandler(webView, challenge, completionHandler)
		}
		
		open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
			multiHandler(webView, message, frame, completionHandler)
		}
		
		open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
			multiHandler(webView, message, frame, completionHandler)
		}
		
		open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
			multiHandler(webView, prompt, defaultText, frame)
		}
		
		open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
			return singleHandler(webView, configuration, navigationAction, windowFeatures)
		}

		open func webViewDidClose(_ webView: WKWebView) {
			multiHandler(webView)
		}

		#if os(iOS)
			open func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
				return singleHandler(webView, elementInfo)
			}
			
			open func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
				multiHandler(webView, previewingViewController)
			}
			
			open func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
				return singleHandler(webView, elementInfo, previewActions)
			}
		#else
			open func webView(_ webView: WKWebView, runOpenPanelWith parameters: WebView.WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
				multiHandler(webView, parameters, frame, completionHandler)
			}
		#endif
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: WebViewBinding {
	public typealias WebViewName<V> = BindingName<V, WebView.Binding, Binding>
	private typealias B = WebView.Binding
	private static func name<V>(_ source: @escaping (V) -> WebView.Binding) -> WebViewName<V> {
		return WebViewName<V>(source: source, downcast: Binding.webViewBinding)
	}
}
public extension BindingName where Binding: WebViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: WebViewName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var allowsAirPlayForMediaPlayback: WebViewName<Constant<Bool>> { return .name(B.allowsAirPlayForMediaPlayback) }
	static var allowsInlineMediaPlayback: WebViewName<Constant<Bool>> { return .name(B.allowsInlineMediaPlayback) }
	static var allowsPictureInPictureForMediaPlayback: WebViewName<Constant<Bool>> { return .name(B.allowsPictureInPictureForMediaPlayback) }
	static var applicationNameForUserAgent: WebViewName<Constant<String?>> { return .name(B.applicationNameForUserAgent) }
	static var dataDetectorTypes: WebViewName<Constant<WebView.WKDataDetectorTypes>> { return .name(B.dataDetectorTypes) }
	static var ignoresViewportScaleLimits: WebViewName<Constant<Bool>> { return .name(B.ignoresViewportScaleLimits) }
	static var javaScriptCanOpenWindowsAutomatically: WebViewName<Constant<Bool>> { return .name(B.javaScriptCanOpenWindowsAutomatically) }
	static var javaScriptEnabled: WebViewName<Constant<Bool>> { return .name(B.javaScriptEnabled) }
	static var mediaTypesRequiringUserActionForPlayback: WebViewName<Constant<WKAudiovisualMediaTypes>> { return .name(B.mediaTypesRequiringUserActionForPlayback) }
	static var minimumFontSize: WebViewName<Constant<CGFloat>> { return .name(B.minimumFontSize) }
	static var processPool: WebViewName<Constant<WKProcessPool>> { return .name(B.processPool) }
	static var selectionGranularity: WebViewName<Constant<WebView.WKSelectionGranularity>> { return .name(B.selectionGranularity) }
	static var suppressesIncrementalRendering: WebViewName<Constant<Bool>> { return .name(B.suppressesIncrementalRendering) }
	static var urlSchemeHandlers: WebViewName<Constant<[String: WKURLSchemeHandler]>> { return .name(B.urlSchemeHandlers) }
	static var userContentController: WebViewName<Constant<WKUserContentController>> { return .name(B.userContentController) }
	
	@available(macOS 10.10, *) @available(iOS, unavailable) static var javaEnabled: WebViewName<Constant<Bool>> { return .name(B.javaEnabled) }
	@available(macOS 10.10, *) @available(iOS, unavailable) static var plugInsEnabled: WebViewName<Constant<Bool>> { return .name(B.plugInsEnabled) }
	@available(macOS 10.10, *) @available(iOS, unavailable) static var tabFocusesLinks: WebViewName<Constant<Bool>> { return .name(B.tabFocusesLinks) }
	@available(macOS 10.12, *) @available(iOS, unavailable) static var userInterfaceDirectionPolicy: WebViewName<Constant<WebView.WKUserInterfaceDirectionPolicy>> { return .name(B.userInterfaceDirectionPolicy) }
	@available(macOS, unavailable) @available(iOS 9, *) static var allowsPictureInPictureMediaPlayback: WebViewName<Constant<Bool>> { return .name(B.allowsPictureInPictureMediaPlayback) }
	@available(macOS, unavailable) @available(iOS 11, *) static var scrollView: WebViewName<Constant<ScrollView>> { return .name(B.scrollView) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var allowsBackForwardNavigationGestures: WebViewName<Dynamic<Bool>> { return .name(B.allowsBackForwardNavigationGestures) }
	
	static var allowsLinkPreview: WebViewName<Dynamic<Bool>> { return .name(B.allowsLinkPreview) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var allowsMagnification: WebViewName<Dynamic<Bool>> { return .name(B.allowsMagnification) }
	static var customUserAgent: WebViewName<Dynamic<String?>> { return .name(B.customUserAgent) }
	@available(macOS 10.13, *) @available(iOS, unavailable) static var magnification: WebViewName<Dynamic<(factor: CGFloat, centeredAt: CGPoint)>> { return .name(B.magnification) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var evaluateJavaScript: WebViewName<Signal<Callback<String, (Any?, Error?)>>> { return .name(B.evaluateJavaScript) }
	static var goBack: WebViewName<Signal<Callback<Void, WKNavigation?>>> { return .name(B.goBack) }
	static var goForward: WebViewName<Signal<Callback<Void, WKNavigation?>>> { return .name(B.goForward) }
	static var goTo: WebViewName<Signal<Callback<WKBackForwardListItem, WKNavigation?>>> { return .name(B.goTo) }
	static var load: WebViewName<Signal<Callback<URLRequest, WKNavigation?>>> { return .name(B.load) }
	static var loadHTMLString: WebViewName<Signal<Callback<(string: String, baseURL: URL?), WKNavigation?>>> { return .name(B.loadHTMLString) }
	static var reload: WebViewName<Signal<Callback<Void, WKNavigation?>>> { return .name(B.reload) }
	static var reloadFromOrigin: WebViewName<Signal<Callback<Void, WKNavigation?>>> { return .name(B.reloadFromOrigin) }
	static var stopLoading: WebViewName<Signal<Void>> { return .name(B.stopLoading) }
	
	static var loadData: WebViewName<Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>> { return .name(B.loadData) }
	static var loadFile: WebViewName<Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>> { return .name(B.loadFile) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var createWebView: WebViewName<(_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?> { return .name(B.createWebView) }
	static var didClose: WebViewName<(WKWebView) -> Void> { return .name(B.didClose) }
	static var didCommit: WebViewName<(WKWebView, WKNavigation) -> Void> { return .name(B.didCommit) }
	static var didStartProvisionalNavigation: WebViewName<(WKWebView, WKNavigation) -> Void> { return .name(B.didStartProvisionalNavigation) }
	static var didReceiveServerRedirectForProvisionalNavigation: WebViewName<(WKWebView, WKNavigation) -> Void> { return .name(B.didReceiveServerRedirectForProvisionalNavigation) }
	static var didFail: WebViewName<(WKWebView, WKNavigation, Error) -> Void> { return .name(B.didFail) }
	static var didFailProvisionalNavigation: WebViewName<(WKWebView, WKNavigation, Error) -> Void> { return .name(B.didFailProvisionalNavigation) }
	static var didFinish: WebViewName<(WKWebView, WKNavigation) -> Void> { return .name(B.didFinish) }
	static var contentProcessDidTerminate: WebViewName<(WKWebView) -> Void> { return .name(B.contentProcessDidTerminate) }
	static var decideActionPolicy: WebViewName<(WKWebView, WKNavigationAction, (WKNavigationActionPolicy) -> Void) -> Void> { return .name(B.decideActionPolicy) }
	static var decideResponsePolicy: WebViewName<(WKWebView, WKNavigationResponse, (WKNavigationActionPolicy) -> Void) -> Void> { return .name(B.decideResponsePolicy) }
	static var didReceiveAuthenticationChallenge: WebViewName<(WKWebView, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void> { return .name(B.didReceiveAuthenticationChallenge) }
	static var runJavaScriptAlertPanel: WebViewName<(WKWebView, String, WKFrameInfo, () -> Void) -> Void> { return .name(B.runJavaScriptAlertPanel) }
	static var runJavaScriptConfirmPanel: WebViewName<(WKWebView, String, WKFrameInfo, (Bool) -> Void) -> Void> { return .name(B.runJavaScriptConfirmPanel) }
	static var runJavaScriptTextInputPanel: WebViewName<(WKWebView, String, String?, WKFrameInfo, (String?) -> Void) -> Void> { return .name(B.runJavaScriptTextInputPanel) }
	
	@available(macOS, unavailable) @available(iOS 10.0, *) static var commitPreviewingViewController: WebViewName<(_ webView: WKWebView, _ previewingViewController: WebView.UIViewController) -> Void> { return .name(B.commitPreviewingViewController) }
	@available(macOS, unavailable) @available(iOS 10.0, *) static var previewingViewController: WebViewName<(_ webView: WKWebView, _ elementInfo: WebView.WKPreviewElementInfo, _ previewActions: [WebView.WKPreviewActionItem]) -> WebView.UIViewController?> { return .name(B.previewingViewController) }
	@available(macOS 10.12, *) @available(iOS, unavailable) static var runOpenPanel: WebViewName<(WKWebView, WebView.WKOpenPanelParameters, WKFrameInfo, ([URL]?) -> Void) -> Void> { return .name(B.runOpenPanel) }
	@available(macOS, unavailable) @available(iOS 10.0, *) static var shouldPreviewElement: WebViewName<(_ webView: WKWebView, _ elementInfo: WebView.WKPreviewElementInfo) -> Bool> { return .name(B.shouldPreviewElement) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol WebViewConvertible: ViewConvertible {
	func wkWebView() -> WebView.Instance
}
extension WebViewConvertible {
	#if os(macOS)
		public func nsView() -> View.Instance { return wkWebView() }
	#else
		public func uiView() -> View.Instance { return wkWebView() }
	#endif
}
extension WKWebView: WebViewConvertible, HasDelegate {
	public func wkWebView() -> WebView.Instance { return self }
	public var delegate: WKNavigationDelegate? {
		get { return navigationDelegate }
		set { navigationDelegate = newValue }
	}
}
public extension WebView {
	func wkWebView() -> WebView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol WebViewBinding: ViewBinding {
	static func webViewBinding(_ binding: WebView.Binding) -> Self
}
public extension WebViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return webViewBinding(.inheritedBinding(binding))
	}
}
public extension WebView.Binding {
	typealias Preparer = WebView.Preparer
	static func webViewBinding(_ binding: WebView.Binding) -> WebView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

