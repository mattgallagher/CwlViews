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

public class WebView: ConstructingBinder, WebViewConvertible {
	public typealias Instance = WKWebView
	public typealias Inherited = View
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func wkWebView() -> Instance { return instance() }
	
	public enum Binding: WebViewBinding {
		public typealias EnclosingBinder = WebView
		public static func webViewBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case configuration(Constant<WKWebViewConfiguration>)
		#if os(iOS)
			case scrollView(Constant<ScrollView>)
		#else
			@available(*, unavailable)
			case scrollView(())
		#endif
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		@available(macOS 10.11, *)
		case customUserAgent(Dynamic<String?>)
		#if os(macOS)
			case allowsMagnification(Dynamic<Bool>)
			case magnification(Dynamic<(factor: CGFloat, centeredAt: CGPoint)>)
		#else
			@available(*, unavailable)
			case allowsMagnification(())
			@available(*, unavailable)
			case magnification(())
		#endif
		case allowsBackForwardNavigationGestures(Dynamic<Bool>)
		@available(macOS 10.11, *)
		case allowsLinkPreview(Dynamic<Bool>)
		
		//	2. Signal bindings are performed on the object after construction.
		case load(Signal<Callback<URLRequest, WKNavigation?>>)
		@available(macOS 10.11, *)
		case loadFile(Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>)
		case loadHTMLString(Signal<Callback<(string: String, baseURL: URL?), WKNavigation?>>)
		@available(macOS 10.11, *)
		case loadData(Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>)
		case reload(Signal<Callback<Void, WKNavigation?>>)
		case reloadFromOrigin(Signal<Callback<Void, WKNavigation?>>)
		case goBack(Signal<Callback<Void, WKNavigation?>>)
		case goForward(Signal<Callback<Void, WKNavigation?>>)
		case goTo(Signal<Callback<WKBackForwardListItem, WKNavigation?>>)
		case stopLoading(Signal<Void>)
		case evaluateJavaScript(Signal<Callback<String, (Any?, Error?)>>)
		
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
		#if os(macOS)
			@available(macOS 10.12, *)
			case runOpenPanel(SignalInput<(parameters: WKOpenPanelParameters, frame: WKFrameInfo, completion: SignalInput<[URL]?>)>)
		#else
			@available(*, unavailable)
			case runOpenPanel(())
		#endif
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case createWebView((_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?)
		#if os(iOS)
			@available(iOS 10.0, *)
			case shouldPreviewElement((_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo) -> Bool)
			@available(iOS 10.0, *)
			case previewingViewController((_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo, _ previewActions: [WKPreviewActionItem]) -> UIViewController?)
			@available(iOS 10.0, *)
			case commitPreviewingViewController((_ webView: WKWebView, _ previewingViewController: UIViewController) -> Void)
		#else
			@available(*, unavailable)
			case shouldPreviewElement(())
			@available(*, unavailable)
			case previewingViewController(())
			@available(*, unavailable)
			case commitPreviewingViewController(())
		#endif
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = WebView
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init(frame: .zero, configuration: configuration ?? WKWebViewConfiguration()) }
		
		public init() {
			self.init(delegateClass: Delegate.self)
		}
		public init<Value>(delegateClass: Value.Type) where Value: Delegate {
			self.delegateClass = delegateClass
		}
		public let delegateClass: Delegate.Type
		var possibleDelegate: Delegate? = nil
		mutating func delegate() -> Delegate {
			if let d = possibleDelegate {
				return d
			} else {
				let d = delegateClass.init()
				possibleDelegate = d
				return d
			}
		}
		
		var configuration: WKWebViewConfiguration?
		
		public mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .configuration(let x): configuration = x.value
			case .didCommit(let x):
				let s = #selector(WKNavigationDelegate.webView(_:didCommit:))
				delegate().addSelector(s).didCommit = x
			case .didStartProvisionalNavigation(let x):
				let s = #selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:))
				delegate().addSelector(s).didStartProvisionalNavigation = x
			case .didReceiveServerRedirectForProvisionalNavigation(let x):
				let s = #selector(WKNavigationDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:))
				delegate().addSelector(s).didReceiveServerRedirectForProvisionalNavigation = x
			case .didFail(let x):
				let s = #selector(WKNavigationDelegate.webView(_:didFail:withError:))
				delegate().addSelector(s).didFail = x
			case .didFailProvisionalNavigation(let x):
				let s = #selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:))
				delegate().addSelector(s).didFailProvisionalNavigation = x
			case .didFinish(let x):
				let s = #selector(WKNavigationDelegate.webView(_:didFinish:))
				delegate().addSelector(s).didFinish = x
			case .contentProcessDidTerminate(let x):
				if #available(macOS 10.11, *) {
					let s = #selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:))
					delegate().addSelector(s).contentProcessDidTerminate = x
				}
			case .decideActionPolicy(let x):
				let s = #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView,WKNavigationAction, @escaping (WKNavigationActionPolicy) -> Void) -> Void)?)
				delegate().addSelector(s).decideActionPolicy = x
			case .decideResponsePolicy(let x):
				let s = #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView, WKNavigationResponse, @escaping (WKNavigationResponsePolicy) -> Void) -> Void)?)
				delegate().addSelector(s).decideResponsePolicy = x
			case .didReceiveAuthenticationChallenge(let x):
				let s = #selector(WKNavigationDelegate.webView(_:didReceive:completionHandler:))
				delegate().addSelector(s).didReceiveAuthenticationChallenge = x
			case .runJavaScriptAlertPanel(let x):
				let s = #selector(WKUIDelegate.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:))
				delegate().addSelector(s).runJavaScriptAlertPanel = x
			case .runJavaScriptConfirmPanel(let x):
				let s = #selector(WKUIDelegate.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:))
				delegate().addSelector(s).runJavaScriptConfirmPanel = x
			case .runJavaScriptTextInputPanel(let x):
				let s = #selector(WKUIDelegate.webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:))
				delegate().addSelector(s).runJavaScriptTextInputPanel = x
			case .createWebView(let x):
				let s = #selector(WKUIDelegate.webView(_:createWebViewWith:for:windowFeatures:))
				delegate().addSelector(s).createWebView = x
			case .didClose(let x):
				if #available(macOS 10.11, iOS 9.0, *) {
					let s = #selector(WKUIDelegate.webViewDidClose(_:))
					delegate().addSelector(s).didClose = x
				}
			case .runOpenPanel(let x):
				#if os(macOS)
					if #available(macOS 10.12, *) {
						let s = #selector(WKUIDelegate.webView(_:runOpenPanelWith:initiatedByFrame:completionHandler:))
						delegate().addSelector(s).runOpenPanel = x
					}
				#endif
			case .shouldPreviewElement(let x):
				#if os(iOS)
					if #available(iOS 10.0, *) {
						let s = #selector(WKUIDelegate.webView(_:shouldPreviewElement:))
						delegate().addSelector(s).shouldPreviewElement = x
					}
				#endif
			case .previewingViewController(let x):
				#if os(iOS)
					if #available(iOS 10.0, *) {
						let s = #selector(WKUIDelegate.webView(_:previewingViewControllerForElement:defaultActions:))
						delegate().addSelector(s).previewingViewController = x
					}
				#endif
			case .commitPreviewingViewController(let x):
				#if os(iOS)
					if #available(iOS 10.0, *) {
						let s = #selector(WKUIDelegate.webView(_:commitPreviewingViewController:))
						delegate().addSelector(s).commitPreviewingViewController = x
					}
				#endif
			case .inheritedBinding(let x): linkedPreparer.prepareBinding(x)
			default: break
			}
		}
		
		public mutating func prepareInstance(_ instance: Instance, storage: Storage) {
			if possibleDelegate != nil {
				precondition(instance.navigationDelegate == nil && instance.uiDelegate == nil, "Conflicting delegate applied to instance")
				storage.dynamicDelegate = possibleDelegate
				instance.navigationDelegate = storage
				instance.uiDelegate = storage
			}
			
			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .configuration: return nil
			case .scrollView(let x):
				#if os(macOS)
					return nil
				#else
					x.value.applyBindings(to: instance.scrollView)
					return nil
				#endif
			case .customUserAgent(let x):
				return x.apply(instance, storage) { i, s, v in
					if #available(macOS 10.11, *) {
						i.customUserAgent = v
					}
				}
			case .allowsMagnification(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.allowsMagnification = v }
				#else
					return nil
				#endif
			case .magnification(let x):
				#if os(macOS)
					return x.apply(instance, storage) { i, s, v in i.setMagnification(v.factor, centeredAt: v.centeredAt) }
				#else
					return nil
				#endif
			case .allowsBackForwardNavigationGestures(let x): return x.apply(instance, storage) { i, s, v in i.allowsBackForwardNavigationGestures = v }
			case .allowsLinkPreview(let x):
				return x.apply(instance, storage) { i, s, v in
					if #available(macOS 10.11, *) {
						i.allowsLinkPreview = v
					}
				}
			case .load(let x):
				return x.apply(instance, storage) { i, s, v in
					let n = i.load(v.value)
					v.callback?.send(value: n)
				}
			case .loadFile(let x):
				return x.apply(instance, storage) { i, s, v in
					if #available(macOS 10.11, *) {
						let n = i.loadFileURL(v.value.url, allowingReadAccessTo: v.value.allowingReadAccessTo)
						v.callback?.send(value: n)
					}
				}
			case .loadHTMLString(let x):
				return x.apply(instance, storage) { i, s, v in
					let n = i.loadHTMLString(v.value.string, baseURL: v.value.baseURL)
					v.callback?.send(value: n)
				}
			case .loadData(let x):
				return x.apply(instance, storage) { i, s, v in
					if #available(macOS 10.11, *) {
						let n = i.load(v.value.data, mimeType: v.value.mimeType, characterEncodingName: v.value.characterEncodingName, baseURL: v.value.baseURL)
						v.callback?.send(value: n)
					}
				}
			case .reload(let x):
				return x.apply(instance, storage) { i, s, v in
					let n = i.reload()
					v.callback?.send(value: n)
				}
			case .reloadFromOrigin(let x):
				return x.apply(instance, storage) { i, s, v in
					let n = i.reloadFromOrigin()
					v.callback?.send(value: n)
				}
			case .goBack(let x):
				return x.apply(instance, storage) { i, s, v in
					let n = i.goBack()
					v.callback?.send(value: n)
				}
			case .goForward(let x):
				return x.apply(instance, storage) { i, s, v in
					let n = i.goForward()
					v.callback?.send(value: n)
				}
			case .goTo(let x):
				return x.apply(instance, storage) { i, s, v in
					let n = i.go(to: v.value)
					v.callback?.send(value: n)
				}
			case .stopLoading(let x):
				return x.apply(instance, storage) { i, s, v in i.stopLoading() }
			case .evaluateJavaScript(let x):
				return x.apply(instance, storage) { i, s, v in
					i.evaluateJavaScript(v.value) { (output, error) in
						v.callback?.send(value: (output, error))
					}
				}
				
			case .didCommit: return nil
			case .didStartProvisionalNavigation: return nil
			case .didReceiveServerRedirectForProvisionalNavigation: return nil
			case .didFail: return nil
			case .didFailProvisionalNavigation: return nil
			case .didFinish: return nil
			case .contentProcessDidTerminate: return nil
			case .decideActionPolicy: return nil
			case .decideResponsePolicy: return nil
			case .didReceiveAuthenticationChallenge: return nil
			case .runJavaScriptAlertPanel: return nil
			case .runJavaScriptConfirmPanel: return nil
			case .runJavaScriptTextInputPanel: return nil
			case .didClose: return nil
			case .runOpenPanel: return nil
			case .createWebView: return nil
			case .shouldPreviewElement: return nil
			case .previewingViewController: return nil
			case .commitPreviewingViewController: return nil
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	open class Storage: View.Storage, WKUIDelegate, WKNavigationDelegate {}

	open class Delegate: DynamicDelegate, WKUIDelegate, WKNavigationDelegate {
		public required override init() {
			super.init()
		}
		
		open var didCommit: SignalInput<WKNavigation>?
		open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
			didCommit!.send(value: navigation)
		}
		
		open var didStartProvisionalNavigation: SignalInput<WKNavigation>?
		open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
			didStartProvisionalNavigation!.send(value: navigation)
		}
		
		open var didReceiveServerRedirectForProvisionalNavigation: SignalInput<WKNavigation>?
		open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
			didReceiveServerRedirectForProvisionalNavigation!.send(value: navigation)
		}
		
		open var didFail: SignalInput<(WKNavigation, Error)>?
		open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
			didFail!.send(value: (navigation, error))
		}
		
		open var didFailProvisionalNavigation: SignalInput<(WKNavigation, Error)>?
		open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
			didFailProvisionalNavigation!.send(value: (navigation, error))
		}
		
		open var didFinish: SignalInput<WKNavigation>?
		open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			didFinish!.send(value: navigation)
		}
		
		open var contentProcessDidTerminate: SignalInput<Void>?
		open func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
			contentProcessDidTerminate!.send(value: ())
		}
		
		open var decideActionPolicy: SignalInput<Callback<WKNavigationAction, WKNavigationActionPolicy>>?
		open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			decideActionPolicy!.send(value: Callback(navigationAction, Input().subscribeWhile(context: .main) { r in decisionHandler(r.value ?? .cancel); return false }))
		}
		
		open var decideResponsePolicy: SignalInput<Callback<WKNavigationResponse, WKNavigationResponsePolicy>>?
		open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
			decideResponsePolicy!.send(value: Callback(navigationResponse, Input().subscribeWhile(context: .main) { r in decisionHandler(r.value ?? .cancel); return false }))
		}
		
		open var didReceiveAuthenticationChallenge: SignalInput<Callback<URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?)>>?
		open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
			didReceiveAuthenticationChallenge!.send(value: Callback(challenge, Input().subscribeWhile(context: .main) { r in completionHandler(r.value?.0 ?? .cancelAuthenticationChallenge, r.value?.1); return false }))
		}
		
		open var runJavaScriptAlertPanel: SignalInput<Callback<(message: String, frame: WKFrameInfo), ()>>?
		open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
			runJavaScriptAlertPanel!.send(value: Callback((message: message, frame: frame), Input().subscribeWhile(context: .main) { r in completionHandler(); return false }))
		}
		
		open var runJavaScriptConfirmPanel: SignalInput<Callback<(message: String, frame: WKFrameInfo), Bool>>?
		open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
			runJavaScriptConfirmPanel!.send(value: Callback((message: message, frame: frame), Input().subscribeWhile(context: .main) { r in completionHandler(r.value ?? false); return false }))
		}
		
		open var runJavaScriptTextInputPanel: SignalInput<Callback<(prompt: String, defaultText: String?, frame: WKFrameInfo), String?>>?
		open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
			runJavaScriptTextInputPanel!.send(value: Callback((prompt: prompt, defaultText: defaultText, frame: frame), Input().subscribeWhile(context: .main) { r in completionHandler(r.value ?? nil); return false }))
		}
		
		open var createWebView: ((_ webView: WKWebView, _ configuration: WKWebViewConfiguration, _ navigationAction: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?)?
		open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
			return createWebView!(webView, configuration, navigationAction, windowFeatures)
		}

		open var didClose: SignalInput<Void>?
		open func webViewDidClose(_ webView: WKWebView) {
			didClose!.send(value: ())
		}

		#if os(iOS)
			open var shouldPreviewElement: Any?
			@available(iOS 10.0, *)
			open func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
				return (shouldPreviewElement as! (_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo) -> Bool)(webView, elementInfo)
			}
			
			open var commitPreviewingViewController: ((_ webView: WKWebView, _ previewingViewController: UIViewController) -> Void)?
			open func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
				commitPreviewingViewController!(webView, previewingViewController)
			}
			
			open var previewingViewController: Any?
			@available(iOS 10.0, *)
			open func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
				return (previewingViewController as! (_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo, _ previewActions: [WKPreviewActionItem]) -> UIViewController?)(webView, elementInfo, previewActions)
			}
		#else
			open var runOpenPanel: Any?
			@available(macOS 10.12, *)
			open func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
				(runOpenPanel as! SignalInput<(parameters: WKOpenPanelParameters, frame: WKFrameInfo, completion: SignalInput<[URL]?>)>).send(value: (parameters: parameters, frame: frame, completion: Input().subscribeWhile(context: .main) { r in completionHandler(r.value ?? nil); return false }))
			}
		#endif
	}
}

extension BindingName where Binding: WebViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .webViewBinding(WebView.Binding.$1(v)) }) }

	public static var configuration: BindingName<Constant<WKWebViewConfiguration>, Binding> { return BindingName<Constant<WKWebViewConfiguration>, Binding>({ v in .webViewBinding(WebView.Binding.configuration(v)) }) }
	
	#if os(iOS)
		public static var scrollView: BindingName<Constant<ScrollView>, Binding> { return BindingName<Constant<ScrollView>, Binding>({ v in .webViewBinding(WebView.Binding.scrollView(v)) }) }
	#endif
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	@available(macOS 10.11, *)
	public static var customUserAgent: BindingName<Dynamic<String?>, Binding> { return BindingName<Dynamic<String?>, Binding>({ v in .webViewBinding(WebView.Binding.customUserAgent(v)) }) }
	
	#if os(macOS)
		public static var allowsMagnification: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .webViewBinding(WebView.Binding.allowsMagnification(v)) }) }
		public static var magnification: BindingName<Dynamic<(factor: CGFloat, centeredAt: CGPoint)>, Binding> { return BindingName<Dynamic<(factor: CGFloat, centeredAt: CGPoint)>, Binding>({ v in .webViewBinding(WebView.Binding.magnification(v)) }) }
	#endif
	
	public static var allowsBackForwardNavigationGestures: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .webViewBinding(WebView.Binding.allowsBackForwardNavigationGestures(v)) }) }
	@available(macOS 10.11, *)
	public static var allowsLinkPreview: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .webViewBinding(WebView.Binding.allowsLinkPreview(v)) }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var load: BindingName<Signal<Callback<URLRequest, WKNavigation?>>, Binding> { return BindingName<Signal<Callback<URLRequest, WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.load(v)) }) }
	@available(macOS 10.11, *)
	public static var loadFile: BindingName<Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>, Binding> { return BindingName<Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.loadFile(v)) }) }
	public static var loadHTMLString: BindingName<Signal<Callback<(string: String, baseURL: URL?), WKNavigation?>>, Binding> { return BindingName<Signal<Callback<(string: String, baseURL: URL?), WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.loadHTMLString(v)) }) }
	@available(macOS 10.11, *)
	public static var loadData: BindingName<Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>, Binding> { return BindingName<Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.loadData(v)) }) }
	public static var reload: BindingName<Signal<Callback<Void, WKNavigation?>>, Binding> { return BindingName<Signal<Callback<Void, WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.reload(v)) }) }
	public static var reloadFromOrigin: BindingName<Signal<Callback<Void, WKNavigation?>>, Binding> { return BindingName<Signal<Callback<Void, WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.reloadFromOrigin(v)) }) }
	public static var goBack: BindingName<Signal<Callback<Void, WKNavigation?>>, Binding> { return BindingName<Signal<Callback<Void, WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.goBack(v)) }) }
	public static var goForward: BindingName<Signal<Callback<Void, WKNavigation?>>, Binding> { return BindingName<Signal<Callback<Void, WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.goForward(v)) }) }
	public static var goTo: BindingName<Signal<Callback<WKBackForwardListItem, WKNavigation?>>, Binding> { return BindingName<Signal<Callback<WKBackForwardListItem, WKNavigation?>>, Binding>({ v in .webViewBinding(WebView.Binding.goTo(v)) }) }
	public static var stopLoading: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .webViewBinding(WebView.Binding.stopLoading(v)) }) }
	public static var evaluateJavaScript: BindingName<Signal<Callback<String, (Any?, Error?)>>, Binding> { return BindingName<Signal<Callback<String, (Any?, Error?)>>, Binding>({ v in .webViewBinding(WebView.Binding.evaluateJavaScript(v)) }) }
	
	//	3. Action bindings are triggered by the object after construction.
	public static var didCommit: BindingName<SignalInput<WKNavigation>, Binding> { return BindingName<SignalInput<WKNavigation>, Binding>({ v in .webViewBinding(WebView.Binding.didCommit(v)) }) }
	public static var didStartProvisionalNavigation: BindingName<SignalInput<WKNavigation>, Binding> { return BindingName<SignalInput<WKNavigation>, Binding>({ v in .webViewBinding(WebView.Binding.didStartProvisionalNavigation(v)) }) }
	public static var didReceiveServerRedirectForProvisionalNavigation: BindingName<SignalInput<WKNavigation>, Binding> { return BindingName<SignalInput<WKNavigation>, Binding>({ v in .webViewBinding(WebView.Binding.didReceiveServerRedirectForProvisionalNavigation(v)) }) }
	public static var didFail: BindingName<SignalInput<(WKNavigation, Error)>, Binding> { return BindingName<SignalInput<(WKNavigation, Error)>, Binding>({ v in .webViewBinding(WebView.Binding.didFail(v)) }) }
	public static var didFailProvisionalNavigation: BindingName<SignalInput<(WKNavigation, Error)>, Binding> { return BindingName<SignalInput<(WKNavigation, Error)>, Binding>({ v in .webViewBinding(WebView.Binding.didFailProvisionalNavigation(v)) }) }
	public static var didFinish: BindingName<SignalInput<WKNavigation>, Binding> { return BindingName<SignalInput<WKNavigation>, Binding>({ v in .webViewBinding(WebView.Binding.didFinish(v)) }) }
	public static var contentProcessDidTerminate: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .webViewBinding(WebView.Binding.contentProcessDidTerminate(v)) }) }
	public static var decideActionPolicy: BindingName<SignalInput<Callback<WKNavigationAction, WKNavigationActionPolicy>>, Binding> { return BindingName<SignalInput<Callback<WKNavigationAction, WKNavigationActionPolicy>>, Binding>({ v in .webViewBinding(WebView.Binding.decideActionPolicy(v)) }) }
	public static var decideResponsePolicy: BindingName<SignalInput<Callback<WKNavigationResponse, WKNavigationResponsePolicy>>, Binding> { return BindingName<SignalInput<Callback<WKNavigationResponse, WKNavigationResponsePolicy>>, Binding>({ v in .webViewBinding(WebView.Binding.decideResponsePolicy(v)) }) }
	public static var didReceiveAuthenticationChallenge: BindingName<SignalInput<Callback<URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?)>>, Binding> { return BindingName<SignalInput<Callback<URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?)>>, Binding>({ v in .webViewBinding(WebView.Binding.didReceiveAuthenticationChallenge(v)) }) }
	public static var runJavaScriptAlertPanel: BindingName<SignalInput<Callback<(message: String, frame: WKFrameInfo), ()>>, Binding> { return BindingName<SignalInput<Callback<(message: String, frame: WKFrameInfo), ()>>, Binding>({ v in .webViewBinding(WebView.Binding.runJavaScriptAlertPanel(v)) }) }
	public static var runJavaScriptConfirmPanel: BindingName<SignalInput<Callback<(message: String, frame: WKFrameInfo), Bool>>, Binding> { return BindingName<SignalInput<Callback<(message: String, frame: WKFrameInfo), Bool>>, Binding>({ v in .webViewBinding(WebView.Binding.runJavaScriptConfirmPanel(v)) }) }
	public static var runJavaScriptTextInputPanel: BindingName<SignalInput<Callback<(prompt: String, defaultText: String?, frame: WKFrameInfo), String?>>, Binding> { return BindingName<SignalInput<Callback<(prompt: String, defaultText: String?, frame: WKFrameInfo), String?>>, Binding>({ v in .webViewBinding(WebView.Binding.runJavaScriptTextInputPanel(v)) }) }
	@available(macOS 10.11, iOS 9.0, *)
	public static var didClose: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .webViewBinding(WebView.Binding.didClose(v)) }) }
	
	#if os(macOS)
		@available(macOS 10.12, *)
		public static var runOpenPanel: BindingName<SignalInput<(parameters: WKOpenPanelParameters, frame: WKFrameInfo, completion: SignalInput<[URL]?>)>, Binding> { return BindingName<SignalInput<(parameters: WKOpenPanelParameters, frame: WKFrameInfo, completion: SignalInput<[URL]?>)>, Binding>({ v in .webViewBinding(WebView.Binding.runOpenPanel(v)) }) }
	#endif
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var createWebView: BindingName<(_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?, Binding> { return BindingName<(_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?, Binding>({ v in .webViewBinding(WebView.Binding.createWebView(v)) }) }
	
	#if os(iOS)
		@available(iOS 10.0, *)
		public static var shouldPreviewElement: BindingName<(_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo) -> Bool, Binding> { return BindingName<(_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo) -> Bool, Binding>({ v in .webViewBinding(WebView.Binding.shouldPreviewElement(v)) }) }
		@available(iOS 10.0, *)
		public static var previewingViewController: BindingName<(_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo, _ previewActions: [WKPreviewActionItem]) -> UIViewController?, Binding> { return BindingName<(_ webView: WKWebView, _ elementInfo: WKPreviewElementInfo, _ previewActions: [WKPreviewActionItem]) -> UIViewController?, Binding>({ v in .webViewBinding(WebView.Binding.previewingViewController(v)) }) }
		@available(iOS 10.0, *)
		public static var commitPreviewingViewController: BindingName<(_ webView: WKWebView, _ previewingViewController: UIViewController) -> Void, Binding> { return BindingName<(_ webView: WKWebView, _ previewingViewController: UIViewController) -> Void, Binding>({ v in .webViewBinding(WebView.Binding.commitPreviewingViewController(v)) }) }
	#endif
}

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
extension WKWebView: WebViewConvertible {
	public func wkWebView() -> WebView.Instance { return self }
}

public protocol WebViewBinding: ViewBinding {
	static func webViewBinding(_ binding: WebView.Binding) -> Self
}
extension WebViewBinding {
	public static func viewBinding(_ binding: View.Binding) -> Self {
		return webViewBinding(.inheritedBinding(binding))
	}
}
