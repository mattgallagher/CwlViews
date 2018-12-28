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
		case configuration(Constant<WKWebViewConfiguration>)

		@available(macOS, unavailable) @available(iOS 11, *)
		case scrollView(Constant<ScrollView>)
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case allowsBackForwardNavigationGestures(Dynamic<Bool>)

		@available(macOS 10.11, *)
		case allowsLinkPreview(Dynamic<Bool>)
		@available(macOS 10.13, *) @available(iOS, unavailable)
		case allowsMagnification(Dynamic<Bool>)
		@available(macOS 10.11, *)
		case customUserAgent(Dynamic<String?>)
		@available(macOS 10.13, *) @available(iOS, unavailable)
		case magnification(Dynamic<(factor: CGFloat, centeredAt: CGPoint)>)
		
		//	2. Signal bindings are performed on the object after construction.
		case evaluateJavaScript(Signal<Callback<String, (Any?, Error?)>>)
		case goBack(Signal<Callback<Void, WKNavigation?>>)
		case goForward(Signal<Callback<Void, WKNavigation?>>)
		case goTo(Signal<Callback<WKBackForwardListItem, WKNavigation?>>)
		case load(Signal<Callback<URLRequest, WKNavigation?>>)
		case loadHTMLString(Signal<Callback<(string: String, baseURL: URL?), WKNavigation?>>)
		case reload(Signal<Callback<Void, WKNavigation?>>)
		case reloadFromOrigin(Signal<Callback<Void, WKNavigation?>>)
		case stopLoading(Signal<Void>)

		@available(macOS 10.11, *) case loadData(Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>)
		@available(macOS 10.11, *) case loadFile(Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>)
		
		//	3. Action bindings are triggered by the object after construction.
		case didCommit(SignalInput<WKNavigation>)
		case didStartProvisionalNavigation(SignalInput<WKNavigation>)
		case didReceiveServerRedirectForProvisionalNavigation(SignalInput<WKNavigation>)
		case didFail(SignalInput<(WKNavigation, Error)>)
		case didFailProvisionalNavigation(SignalInput<(WKNavigation, Error)>)
		case didFinish(SignalInput<WKNavigation>)
		case contentProcessDidTerminate(SignalInput<Void>)
		case decideActionPolicy(SignalInput<Callback<WKNavigationAction, WKNavigationActionPolicy>>)
		case decideResponsePolicy(SignalInput<Callback<WKNavigationResponse, WKNavigationResponsePolicy>>)
		case didReceiveAuthenticationChallenge(SignalInput<Callback<URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?)>>)
		case runJavaScriptAlertPanel(SignalInput<Callback<(message: String, frame: WKFrameInfo), ()>>)
		case runJavaScriptConfirmPanel(SignalInput<Callback<(message: String, frame: WKFrameInfo), Bool>>)
		case runJavaScriptTextInputPanel(SignalInput<Callback<(prompt: String, defaultText: String?, frame: WKFrameInfo), String?>>)
		
		@available(macOS 10.11, iOS 9.0, *)
		case didClose(SignalInput<Void>)
		@available(macOS 10.12, *) @available(iOS, unavailable)
		case runOpenPanel(SignalInput<(parameters: WKOpenPanelParameters, frame: WKFrameInfo, completion: SignalInput<[URL]?>)>)
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case createWebView((_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?)
		
		@available(macOS, unavailable) @available(iOS 10.0, *)
		case commitPreviewingViewController((_ webView: WKWebView, _ previewingViewController: UIViewController) -> Void)
		@available(macOS, unavailable) @available(iOS 10.0, *)
		case previewingViewController((_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo, _ previewActions: [WKPreviewActionItem]) -> UIViewController?)
		@available(macOS, unavailable) @available(iOS 10.0, *)
		case shouldPreviewElement((_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo) -> Bool)
	}

	#if os(macOS)
		typealias UIViewController = ()
		typealias WKPreviewElementInfo = ()
		typealias WKPreviewActionItem = ()
	#else
		typealias UIViewController = UIKit.UIViewController
		typealias WKPreviewElementInfo = WebKit.WKPreviewElementInfo
		typealias WKPreviewActionItem = WebKit.WKPreviewActionItem
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
		
		var configuration: WKWebViewConfiguration?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension WebView.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .configuration(let x): configuration = x.value
		case .didCommit(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:didCommit:)))
		case .didStartProvisionalNavigation(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:)))
		case .didReceiveServerRedirectForProvisionalNavigation(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:)))
		case .didFail(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:didFail:withError:)))
		case .didFailProvisionalNavigation(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:)))
		case .didFinish(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:didFinish:)))
		case .contentProcessDidTerminate(let x):
			if #available(macOS 10.11, *) {
				delegate().addHandler(x, #selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:)))
			}
		case .decideActionPolicy(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView,WKNavigationAction, @escaping (WKNavigationActionPolicy) -> Void) -> Void)?))
		case .decideResponsePolicy(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView, WKNavigationResponse, @escaping (WKNavigationResponsePolicy) -> Void) -> Void)?))
		case .didReceiveAuthenticationChallenge(let x): delegate().addHandler(x, #selector(WKNavigationDelegate.webView(_:didReceive:completionHandler:)))
		case .runJavaScriptAlertPanel(let x): delegate().addHandler(x, #selector(WKUIDelegate.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)))
		case .runJavaScriptConfirmPanel(let x): delegate().addHandler(x, #selector(WKUIDelegate.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)))
		case .runJavaScriptTextInputPanel(let x): delegate().addHandler(x, #selector(WKUIDelegate.webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)))
		case .createWebView(let x): delegate().addHandler(x, #selector(WKUIDelegate.webView(_:createWebViewWith:for:windowFeatures:)))
		case .didClose(let x):
			if #available(macOS 10.11, iOS 9.0, *) {
				delegate().addHandler(x, #selector(WKUIDelegate.webViewDidClose(_:)))
			}
		case .runOpenPanel(let x):
			#if os(macOS)
				if #available(macOS 10.12, *) {
					delegate().addHandler(x, #selector(WKUIDelegate.webView(_:runOpenPanelWith:initiatedByFrame:completionHandler:)))
				}
			#endif
		case .shouldPreviewElement(let x):
			#if os(iOS)
				if #available(iOS 10.0, *) {
					let s = #selector(WKUIDelegate.webView(_:shouldPreviewElement:))
					delegate().addHandler(x, #selector(WKUIDelegate.webView(_:shouldPreviewElement:)))
				}
			#endif
		case .previewingViewController(let x):
			#if os(iOS)
				if #available(iOS 10.0, *) {
					delegate().addHandler(x, #selector(WKUIDelegate.webView(_:previewingViewControllerForElement:defaultActions:)))
				}
			#endif
		case .commitPreviewingViewController(let x):
			#if os(iOS)
				if #available(iOS 10.0, *) {
					delegate().addHandler(x, #selector(WKUIDelegate.webView(_:commitPreviewingViewController:)))
				}
			#endif
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		default: break
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
		case .configuration: return nil
		
		case .scrollView(let x):
			#if os(macOS)
				return nil
			#else
				x.value.applyBindings(to: instance.scrollView)
				return nil
			#endif
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .allowsBackForwardNavigationGestures(let x): return x.apply(instance) { i, v in i.allowsBackForwardNavigationGestures = v }
		
		case .allowsLinkPreview(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					i.allowsLinkPreview = v
				}
			}
		case .allowsMagnification(let x):
			#if os(macOS)
				return x.apply(instance) { i, v in i.allowsMagnification = v }
			#else
				return nil
			#endif
		case .customUserAgent(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					i.customUserAgent = v
				}
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

		case .loadData(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					v.callback.send(value: i.load(v.value.data, mimeType: v.value.mimeType, characterEncodingName: v.value.characterEncodingName, baseURL: v.value.baseURL))
				}
			}
		case .loadFile(let x):
			return x.apply(instance) { i, v in
				if #available(macOS 10.11, *) {
					v.callback.send(value: i.loadFileURL(v.value.url, allowingReadAccessTo: v.value.allowingReadAccessTo))
				}
			}
			
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
			handler(ofType: SignalInput<WKNavigation>.self).send(value: navigation)
		}
		
		open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
			handler(ofType: SignalInput<WKNavigation>.self).send(value: navigation)
		}
		
		open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
			handler(ofType: SignalInput<WKNavigation>.self).send(value: navigation)
		}
		
		open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
			handler(ofType: SignalInput<(WKNavigation, Error)>.self).send(value: (navigation, error))
		}
		
		open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
			handler(ofType: SignalInput<(WKNavigation, Error)>.self).send(value: (navigation, error))
		}
		
		open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			handler(ofType: SignalInput<WKNavigation>.self).send(value: navigation)
		}
		
		open func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}
		
		open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			handler(ofType: SignalInput<Callback<WKNavigationAction, WKNavigationActionPolicy>>.self).send(value: Callback(navigationAction, Input().subscribeWhile(context: .main) { r in decisionHandler(r.value ?? .cancel); return false }))
		}
		
		open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
			handler(ofType: SignalInput<Callback<WKNavigationResponse, WKNavigationResponsePolicy>>.self).send(value: Callback(navigationResponse, Input().subscribeWhile(context: .main) { r in decisionHandler(r.value ?? .cancel); return false }))
		}
		
		open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
			handler(ofType: SignalInput<Callback<URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?)>>.self).send(value: Callback(challenge, Input().subscribeWhile(context: .main) { r in completionHandler(r.value?.0 ?? .cancelAuthenticationChallenge, r.value?.1); return false }))
		}
		
		open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
			handler(ofType: SignalInput<Callback<(message: String, frame: WKFrameInfo), ()>>.self).send(value: Callback((message: message, frame: frame), Input().subscribeWhile(context: .main) { r in completionHandler(); return false }))
		}
		
		open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
			handler(ofType: SignalInput<Callback<(message: String, frame: WKFrameInfo), Bool>>.self).send(value: Callback((message: message, frame: frame), Input().subscribeWhile(context: .main) { r in completionHandler(r.value ?? false); return false }))
		}
		
		open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
			handler(ofType: SignalInput<Callback<(prompt: String, defaultText: String?, frame: WKFrameInfo), String?>>.self).send(value: Callback((prompt: prompt, defaultText: defaultText, frame: frame), Input().subscribeWhile(context: .main) { r in completionHandler(r.value ?? nil); return false }))
		}
		
		open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
			return handler(ofType: ((WKWebView, WKWebViewConfiguration, WKNavigationAction, WKWindowFeatures) -> WKWebView?).self)(webView, configuration, navigationAction, windowFeatures)
		}

		open func webViewDidClose(_ webView: WKWebView) {
			handler(ofType: SignalInput<Void>.self).send(value: ())
		}

		#if os(iOS)
			@available(iOS 10.0, *) open func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
				return handler(ofType: ((WKWebView, WKPreviewElementInfo) -> Bool).self)(webView, elementInfo)
			}
			
			open func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
				handler(ofType: ((WKWebView, UIViewController) -> Void).self)(webView, previewingViewController)
			}
			
			@available(iOS 10.0, *) open func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
				return handler(ofType: ((WKWebView, WKPreviewElementInfo, [WKPreviewActionItem]) -> UIViewController?).self)(webView, elementInfo, previewActions)
			}
		#else
			@available(macOS 10.12, *) open func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
				handler(ofType: SignalInput<(parameters: WKOpenPanelParameters, frame: WKFrameInfo, completion: SignalInput<[URL]?>)>.self).send(value: (parameters: parameters, frame: frame, completion: Input().subscribeWhile(context: .main) { r in completionHandler(r.value ?? nil); return false }))
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
	static var configuration: WebViewName<Constant<WKWebViewConfiguration>> { return .name(B.configuration) }
	
	@available(macOS, unavailable) @available(iOS 11, *)
	static var scrollView: WebViewName<Constant<ScrollView>> { return .name(B.scrollView) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var allowsBackForwardNavigationGestures: WebViewName<Dynamic<Bool>> { return .name(B.allowsBackForwardNavigationGestures) }
	
	@available(macOS 10.11, *)
	static var allowsLinkPreview: WebViewName<Dynamic<Bool>> { return .name(B.allowsLinkPreview) }
	@available(macOS 10.13, *) @available(iOS, unavailable)
	static var allowsMagnification: WebViewName<Dynamic<Bool>> { return .name(B.allowsMagnification) }
	@available(macOS 10.11, *)
	static var customUserAgent: WebViewName<Dynamic<String?>> { return .name(B.customUserAgent) }
	@available(macOS 10.13, *) @available(iOS, unavailable)
	static var magnification: WebViewName<Dynamic<(factor: CGFloat, centeredAt: CGPoint)>> { return .name(B.magnification) }
	
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
	
	@available(macOS 10.11, *) static var loadData: WebViewName<Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>> { return .name(B.loadData) }
	@available(macOS 10.11, *) static var loadFile: WebViewName<Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>> { return .name(B.loadFile) }
	
	//	3. Action bindings are triggered by the object after construction.
	static var didCommit: WebViewName<SignalInput<WKNavigation>> { return .name(B.didCommit) }
	static var didStartProvisionalNavigation: WebViewName<SignalInput<WKNavigation>> { return .name(B.didStartProvisionalNavigation) }
	static var didReceiveServerRedirectForProvisionalNavigation: WebViewName<SignalInput<WKNavigation>> { return .name(B.didReceiveServerRedirectForProvisionalNavigation) }
	static var didFail: WebViewName<SignalInput<(WKNavigation, Error)>> { return .name(B.didFail) }
	static var didFailProvisionalNavigation: WebViewName<SignalInput<(WKNavigation, Error)>> { return .name(B.didFailProvisionalNavigation) }
	static var didFinish: WebViewName<SignalInput<WKNavigation>> { return .name(B.didFinish) }
	static var contentProcessDidTerminate: WebViewName<SignalInput<Void>> { return .name(B.contentProcessDidTerminate) }
	static var decideActionPolicy: WebViewName<SignalInput<Callback<WKNavigationAction, WKNavigationActionPolicy>>> { return .name(B.decideActionPolicy) }
	static var decideResponsePolicy: WebViewName<SignalInput<Callback<WKNavigationResponse, WKNavigationResponsePolicy>>> { return .name(B.decideResponsePolicy) }
	static var didReceiveAuthenticationChallenge: WebViewName<SignalInput<Callback<URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?)>>> { return .name(B.didReceiveAuthenticationChallenge) }
	static var runJavaScriptAlertPanel: WebViewName<SignalInput<Callback<(message: String, frame: WKFrameInfo), ()>>> { return .name(B.runJavaScriptAlertPanel) }
	static var runJavaScriptConfirmPanel: WebViewName<SignalInput<Callback<(message: String, frame: WKFrameInfo), Bool>>> { return .name(B.runJavaScriptConfirmPanel) }
	static var runJavaScriptTextInputPanel: WebViewName<SignalInput<Callback<(prompt: String, defaultText: String?, frame: WKFrameInfo), String?>>> { return .name(B.runJavaScriptTextInputPanel) }
	
	@available(macOS 10.11, iOS 9.0, *)
	static var didClose: WebViewName<SignalInput<Void>> { return .name(B.didClose) }
	@available(macOS 10.12, *) @available(iOS, unavailable)
	static var runOpenPanel: WebViewName<SignalInput<(parameters: WKOpenPanelParameters, frame: WKFrameInfo, completion: SignalInput<[URL]?>)>> { return .name(B.runOpenPanel) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var createWebView: WebViewName<(_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?> { return .name(B.createWebView) }
	
	@available(macOS, unavailable) @available(iOS 10.0, *)
	static var commitPreviewingViewController: WebViewName<(_ webView: WKWebView, _ previewingViewController: WebView.UIViewController) -> Void> { return .name(B.commitPreviewingViewController) }
	@available(macOS, unavailable) @available(iOS 10.0, *)
	static var previewingViewController: WebViewName<(_ webView: WKWebView, _ elementInfo: WebView.WKPreviewElementInfo, _ previewActions: [WebView.WKPreviewActionItem]) -> WebView.UIViewController?> { return .name(B.previewingViewController) }
	@available(macOS, unavailable) @available(iOS 10.0, *)
	static var shouldPreviewElement: WebViewName<(_ webView: WKWebView, _ elementInfo: WebView.WKPreviewElementInfo) -> Bool> { return .name(B.shouldPreviewElement) }
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
	public typealias Preparer = WebView.Preparer
	static func webViewBinding(_ binding: WebView.Binding) -> WebView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
