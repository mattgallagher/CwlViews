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

extension BindingParser where Downcast: WebViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, WebKitView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asWebViewBinding() }) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var allowsAirPlayForMediaPlayback: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .allowsAirPlayForMediaPlayback(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var allowsInlineMediaPlayback: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .allowsInlineMediaPlayback(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var allowsPictureInPictureForMediaPlayback: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .allowsPictureInPictureForMediaPlayback(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var applicationNameForUserAgent: BindingParser<Constant<String?>, WebKitView.Binding, Downcast> { return .init(extract: { if case .applicationNameForUserAgent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var ignoresViewportScaleLimits: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .ignoresViewportScaleLimits(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var javaScriptCanOpenWindowsAutomatically: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .javaScriptCanOpenWindowsAutomatically(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var javaScriptEnabled: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .javaScriptEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var mediaTypesRequiringUserActionForPlayback: BindingParser<Constant<WKAudiovisualMediaTypes>, WebKitView.Binding, Downcast> { return .init(extract: { if case .mediaTypesRequiringUserActionForPlayback(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var minimumFontSize: BindingParser<Constant<CGFloat>, WebKitView.Binding, Downcast> { return .init(extract: { if case .minimumFontSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var processPool: BindingParser<Constant<WKProcessPool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .processPool(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var suppressesIncrementalRendering: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .suppressesIncrementalRendering(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var urlSchemeHandlers: BindingParser<Constant<[String: WKURLSchemeHandler]>, WebKitView.Binding, Downcast> { return .init(extract: { if case .urlSchemeHandlers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var userContentController: BindingParser<Constant<WKUserContentController>, WebKitView.Binding, Downcast> { return .init(extract: { if case .userContentController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	
	@available(macOS 10.10, *) @available(iOS, unavailable) public static var javaEnabled: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .javaEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS 10.10, *) @available(iOS, unavailable) public static var plugInsEnabled: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .plugInsEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS 10.10, *) @available(iOS, unavailable) public static var tabFocusesLinks: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .tabFocusesLinks(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS 10.12, *) @available(iOS, unavailable) public static var userInterfaceDirectionPolicy: BindingParser<Constant<WebKitView.WKUserInterfaceDirectionPolicy>, WebKitView.Binding, Downcast> { return .init(extract: { if case .userInterfaceDirectionPolicy(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS, unavailable) @available(iOS 9, *) public static var allowsPictureInPictureMediaPlayback: BindingParser<Constant<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .allowsPictureInPictureMediaPlayback(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS, unavailable) @available(iOS 11, *) public static var scrollView: BindingParser<Constant<ScrollView>, WebKitView.Binding, Downcast> { return .init(extract: { if case .scrollView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS, unavailable) @available(iOS 11, *) public static var dataDetectorTypes: BindingParser<Constant<WebKitView.WKDataDetectorTypes>, WebKitView.Binding, Downcast> { return .init(extract: { if case .dataDetectorTypes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS, unavailable) @available(iOS 11, *) public static var selectionGranularity: BindingParser<Constant<WebKitView.WKSelectionGranularity>, WebKitView.Binding, Downcast> { return .init(extract: { if case .selectionGranularity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var allowsBackForwardNavigationGestures: BindingParser<Dynamic<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .allowsBackForwardNavigationGestures(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var allowsLinkPreview: BindingParser<Dynamic<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .allowsLinkPreview(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var customUserAgent: BindingParser<Dynamic<String?>, WebKitView.Binding, Downcast> { return .init(extract: { if case .customUserAgent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var allowsMagnification: BindingParser<Dynamic<Bool>, WebKitView.Binding, Downcast> { return .init(extract: { if case .allowsMagnification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS 10.13, *) @available(iOS, unavailable) public static var magnification: BindingParser<Dynamic<(factor: CGFloat, centeredAt: CGPoint)>, WebKitView.Binding, Downcast> { return .init(extract: { if case .magnification(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	
	//	2. Signal bindings are performed on the object after construction.
	public static var evaluateJavaScript: BindingParser<Signal<Callback<String, (Any?, Error?)>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .evaluateJavaScript(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var goBack: BindingParser<Signal<Callback<Void, WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .goBack(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var goForward: BindingParser<Signal<Callback<Void, WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .goForward(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var goTo: BindingParser<Signal<Callback<WKBackForwardListItem, WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .goTo(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var load: BindingParser<Signal<Callback<URLRequest, WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .load(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var loadData: BindingParser<Signal<Callback<(data: Data, mimeType: String, baseURL: URL, characterEncodingName: String), WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .loadData(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var loadFile: BindingParser<Signal<Callback<(url: URL, allowingReadAccessTo: URL), WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .loadFile(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var loadHTMLString: BindingParser<Signal<Callback<(string: String, baseURL: URL?), WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .loadHTMLString(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var reload: BindingParser<Signal<Callback<Void, WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .reload(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var reloadFromOrigin: BindingParser<Signal<Callback<Void, WKNavigation?>>, WebKitView.Binding, Downcast> { return .init(extract: { if case .reloadFromOrigin(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var stopLoading: BindingParser<Signal<Void>, WebKitView.Binding, Downcast> { return .init(extract: { if case .stopLoading(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	public static var createWebView: BindingParser<(_ webView: WKWebView, _ with: WKWebViewConfiguration, _ for: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?, WebKitView.Binding, Downcast> { return .init(extract: { if case .createWebView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didClose: BindingParser<(WKWebView) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didClose(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didCommit: BindingParser<(WKWebView, WKNavigation) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didCommit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didStartProvisionalNavigation: BindingParser<(WKWebView, WKNavigation) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didStartProvisionalNavigation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didReceiveServerRedirectForProvisionalNavigation: BindingParser<(WKWebView, WKNavigation) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didReceiveServerRedirectForProvisionalNavigation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didFail: BindingParser<(WKWebView, WKNavigation, Error) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didFail(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didFailProvisionalNavigation: BindingParser<(WKWebView, WKNavigation, Error) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didFailProvisionalNavigation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didFinish: BindingParser<(WKWebView, WKNavigation) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didFinish(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var contentProcessDidTerminate: BindingParser<(WKWebView) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .contentProcessDidTerminate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var decideActionPolicy: BindingParser<(WKWebView, WKNavigationAction, (WKNavigationActionPolicy) -> Void) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .decideActionPolicy(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var decideResponsePolicy: BindingParser<(WKWebView, WKNavigationResponse, (WKNavigationActionPolicy) -> Void) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .decideResponsePolicy(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var didReceiveAuthenticationChallenge: BindingParser<(WKWebView, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .didReceiveAuthenticationChallenge(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var runJavaScriptAlertPanel: BindingParser<(WKWebView, String, WKFrameInfo, () -> Void) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .runJavaScriptAlertPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var runJavaScriptConfirmPanel: BindingParser<(WKWebView, String, WKFrameInfo, (Bool) -> Void) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .runJavaScriptConfirmPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	public static var runJavaScriptTextInputPanel: BindingParser<(WKWebView, String, String?, WKFrameInfo, (String?) -> Void) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .runJavaScriptTextInputPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	
	@available(macOS, unavailable) @available(iOS 10.0, *) public static var commitPreviewingViewController: BindingParser<(_ webView: WKWebView, _ previewingViewController: WebKitView.UIViewController) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .commitPreviewingViewController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS, unavailable) @available(iOS 10.0, *) public static var previewingViewController: BindingParser<(_ webView: WKWebView, _ elementInfo: WebKitView.WKPreviewElementInfo, _ previewActions: [WebKitView.WKPreviewActionItem]) -> WebKitView.UIViewController?, WebKitView.Binding, Downcast> { return .init(extract: { if case .previewingViewController(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS 10.12, *) @available(iOS, unavailable) public static var runOpenPanel: BindingParser<(WKWebView, WebKitView.WKOpenPanelParameters, WKFrameInfo, ([URL]?) -> Void) -> Void, WebKitView.Binding, Downcast> { return .init(extract: { if case .runOpenPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
	@available(macOS, unavailable) @available(iOS 10.0, *) public static var shouldPreviewElement: BindingParser<(_ webView: WKWebView, _ elementInfo: WebKitView.WKPreviewElementInfo) -> Bool, WebKitView.Binding, Downcast> { return .init(extract: { if case .shouldPreviewElement(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWebViewBinding() }) }
}
