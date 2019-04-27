//
//  CwlWindow_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/30/16.
//  Copyright © 2016 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

#if os(macOS)

extension BindingParser where Downcast: WindowBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, Window.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asWindowBinding() }) }
		
	//	0. Static bindings are applied at construction and are subsequently immutable.
	public static var deferCreation: BindingParser<Constant<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .deferCreation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var initialFirstResponderTag: BindingParser<Constant<Int>, Window.Binding, Downcast> { return .init(extract: { if case .initialFirstResponderTag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var acceptsMouseMovedEvents: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .acceptsMouseMovedEvents(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var allowsConcurrentViewDrawing: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .allowsConcurrentViewDrawing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var allowsToolTipsWhenApplicationIsInactive: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .allowsToolTipsWhenApplicationIsInactive(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var alphaValue: BindingParser<Dynamic<CGFloat>, Window.Binding, Downcast> { return .init(extract: { if case .alphaValue(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var animationBehavior: BindingParser<Dynamic<NSWindow.AnimationBehavior>, Window.Binding, Downcast> { return .init(extract: { if case .animationBehavior(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var appearance: BindingParser<Dynamic<NSAppearance?>, Window.Binding, Downcast> { return .init(extract: { if case .appearance(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var autorecalculatesKeyViewLoop: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .autorecalculatesKeyViewLoop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var backingType: BindingParser<Dynamic<NSWindow.BackingStoreType>, Window.Binding, Downcast> { return .init(extract: { if case .backingType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var canBecomeVisibleWithoutLogin: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .canBecomeVisibleWithoutLogin(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var canHide: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .canHide(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var collectionBehavior: BindingParser<Dynamic<NSWindow.CollectionBehavior>, Window.Binding, Downcast> { return .init(extract: { if case .collectionBehavior(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var colorSpace: BindingParser<Dynamic<NSColorSpace>, Window.Binding, Downcast> { return .init(extract: { if case .colorSpace(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentAspectRatio: BindingParser<Dynamic<NSSize>, Window.Binding, Downcast> { return .init(extract: { if case .contentAspectRatio(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentHeight: BindingParser<Dynamic<WindowDimension>, Window.Binding, Downcast> { return .init(extract: { if case .contentHeight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentMaxSize: BindingParser<Dynamic<NSSize>, Window.Binding, Downcast> { return .init(extract: { if case .contentMaxSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentMinSize: BindingParser<Dynamic<NSSize>, Window.Binding, Downcast> { return .init(extract: { if case .contentMinSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentResizeIncrements: BindingParser<Dynamic<NSSize>, Window.Binding, Downcast> { return .init(extract: { if case .contentResizeIncrements(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentRelativity: BindingParser<Dynamic<WindowDimension.Relativity>, Window.Binding, Downcast> { return .init(extract: { if case .contentRelativity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentView: BindingParser<Dynamic<ViewConvertible>, Window.Binding, Downcast> { return .init(extract: { if case .contentView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var contentWidth: BindingParser<Dynamic<WindowDimension>, Window.Binding, Downcast> { return .init(extract: { if case .contentWidth(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var depthLimit: BindingParser<Dynamic<NSWindow.Depth?>, Window.Binding, Downcast> { return .init(extract: { if case .depthLimit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var displaysWhenScreenProfileChanges: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .displaysWhenScreenProfileChanges(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var frameAutosaveName: BindingParser<Dynamic<NSWindow.FrameAutosaveName>, Window.Binding, Downcast> { return .init(extract: { if case .frameAutosaveName(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var frameHorizontal: BindingParser<Dynamic<WindowDimension>, Window.Binding, Downcast> { return .init(extract: { if case .frameHorizontal(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var frameVertical: BindingParser<Dynamic<WindowDimension>, Window.Binding, Downcast> { return .init(extract: { if case .frameVertical(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var hasShadow: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .hasShadow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var hidesOnDeactivate: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .hidesOnDeactivate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var ignoresMouseEvents: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .ignoresMouseEvents(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var isDocumentEdited: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .isDocumentEdited(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var isExcludedFromWindowsMenu: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .isExcludedFromWindowsMenu(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var isMovable: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .isMovable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var isMovableByWindowBackground: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .isMovableByWindowBackground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var isOpaque: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .isOpaque(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var isRestorable: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .isRestorable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var key: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .key(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var level: BindingParser<Dynamic<NSWindow.Level>, Window.Binding, Downcast> { return .init(extract: { if case .level(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var main: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .main(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var maxFullScreenContentSize: BindingParser<Dynamic<NSSize>, Window.Binding, Downcast> { return .init(extract: { if case .maxFullScreenContentSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var minFullScreenContentSize: BindingParser<Dynamic<NSSize>, Window.Binding, Downcast> { return .init(extract: { if case .minFullScreenContentSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var miniwindowImage: BindingParser<Dynamic<NSImage?>, Window.Binding, Downcast> { return .init(extract: { if case .miniwindowImage(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var miniwindowTitle: BindingParser<Dynamic<String>, Window.Binding, Downcast> { return .init(extract: { if case .miniwindowTitle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var order: BindingParser<Dynamic<WindowOrder>, Window.Binding, Downcast> { return .init(extract: { if case .order(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var preservesContentDuringLiveResize: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .preservesContentDuringLiveResize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var preventsApplicationTerminationWhenModal: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .preventsApplicationTerminationWhenModal(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var representedURL: BindingParser<Dynamic<URL?>, Window.Binding, Downcast> { return .init(extract: { if case .representedURL(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var resizeStyle: BindingParser<Dynamic<WindowResizeStyle>, Window.Binding, Downcast> { return .init(extract: { if case .resizeStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var restorationClass: BindingParser<Dynamic<NSWindowRestoration.Type>, Window.Binding, Downcast> { return .init(extract: { if case .restorationClass(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var screen: BindingParser<Dynamic<NSScreen?>, Window.Binding, Downcast> { return .init(extract: { if case .screen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var sharingType: BindingParser<Dynamic<NSWindow.SharingType>, Window.Binding, Downcast> { return .init(extract: { if case .sharingType(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var styleMask: BindingParser<Dynamic<NSWindow.StyleMask>, Window.Binding, Downcast> { return .init(extract: { if case .styleMask(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var title: BindingParser<Dynamic<String>, Window.Binding, Downcast> { return .init(extract: { if case .title(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var titlebarAppearsTransparent: BindingParser<Dynamic<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .titlebarAppearsTransparent(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var titleVisibility: BindingParser<Dynamic<NSWindow.TitleVisibility>, Window.Binding, Downcast> { return .init(extract: { if case .titleVisibility(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var toolbar: BindingParser<Dynamic<ToolbarConvertible>, Window.Binding, Downcast> { return .init(extract: { if case .toolbar(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var close: BindingParser<Signal<WindowCloseBehavior>, Window.Binding, Downcast> { return .init(extract: { if case .close(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var criticalSheet: BindingParser<Signal<Callback<NSWindow, NSApplication.ModalResponse>>, Window.Binding, Downcast> { return .init(extract: { if case .criticalSheet(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var deminiaturize: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .deminiaturize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var display: BindingParser<Signal<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .display(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var invalidateShadow: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .invalidateShadow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var miniaturize: BindingParser<Signal<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .miniaturize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var presentError: BindingParser<Signal<Callback<Error, Bool>>, Window.Binding, Downcast> { return .init(extract: { if case .presentError(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var printWindow: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .printWindow(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var recalculateKeyViewLoop: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .recalculateKeyViewLoop(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var runToolbarCustomizationPalette: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .runToolbarCustomizationPalette(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var selectNextKeyView: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .selectNextKeyView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var selectPreviousKeyView: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .selectPreviousKeyView(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var sheet: BindingParser<Signal<Callback<NSWindow, NSApplication.ModalResponse>>, Window.Binding, Downcast> { return .init(extract: { if case .sheet(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var toggleFullScreen: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .toggleFullScreen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var toggleToolbarShown: BindingParser<Signal<Void>, Window.Binding, Downcast> { return .init(extract: { if case .toggleToolbarShown(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var zoom: BindingParser<Signal<Bool>, Window.Binding, Downcast> { return .init(extract: { if case .zoom(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var effectiveAppearanceName: BindingParser<SignalInput<NSAppearance.Name>, Window.Binding, Downcast> { return .init(extract: { if case .effectiveAppearanceName(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didBecomeKey: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didBecomeKey(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didBecomeMain: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didBecomeMain(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didChangeBackingProperties: BindingParser<SignalInput<(oldColorSpace: NSColorSpace?, oldScaleFactor: CGFloat?)>, Window.Binding, Downcast> { return .init(extract: { if case .didChangeBackingProperties(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didChangeOcclusionState: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didChangeOcclusionState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didChangeScreen: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didChangeScreen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didChangeScreenProfile: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didChangeScreenProfile(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didDeminiaturize: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didDeminiaturize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didEndLiveResize: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didEndLiveResize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didEndSheet: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didEndSheet(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didEnterFullScreen: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didEnterFullScreen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didEnterVersionBrowser: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didEnterVersionBrowser(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didExitFullScreen: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didExitFullScreen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didExitVersionBrowser: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didExitVersionBrowser(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didExpose: BindingParser<SignalInput<NSRect>, Window.Binding, Downcast> { return .init(extract: { if case .didExpose(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didMiniaturize: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didMiniaturize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didMove: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didMove(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didResignKey: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didResignKey(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didResignMain: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didResignMain(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didResize: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didResize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var didUpdate: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .didUpdate(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willBeginSheet: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willBeginSheet(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willClose: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willClose(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willEnterFullScreen: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willEnterFullScreen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willEnterVersionBrowser: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willEnterVersionBrowser(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willExitFullScreen: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willExitFullScreen(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willExitVersionBrowser: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willExitVersionBrowser(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willMiniaturize: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willMiniaturize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willMove: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willMove(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willStartLiveResize: BindingParser<SignalInput<Void>, Window.Binding, Downcast> { return .init(extract: { if case .willStartLiveResize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var shouldClose: BindingParser<(NSWindow) -> Bool, Window.Binding, Downcast> { return .init(extract: { if case .shouldClose(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var shouldPopUpDocumentPathMenu: BindingParser<(NSWindow, NSMenu) -> Bool, Window.Binding, Downcast> { return .init(extract: { if case .shouldPopUpDocumentPathMenu(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var shouldZoom: BindingParser<(NSWindow, NSRect) -> Bool, Window.Binding, Downcast> { return .init(extract: { if case .shouldZoom(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willResize: BindingParser<(NSWindow, NSSize) -> NSSize, Window.Binding, Downcast> { return .init(extract: { if case .willResize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willResizeForVersionBrowser: BindingParser<(_ window: NSWindow, _ maxPreferredSize: NSSize, _ maxAllowedSize: NSSize) -> NSSize, Window.Binding, Downcast> { return .init(extract: { if case .willResizeForVersionBrowser(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willUseFullScreenContentSize: BindingParser<(NSWindow, NSSize) -> NSSize, Window.Binding, Downcast> { return .init(extract: { if case .willUseFullScreenContentSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willUseFullScreenPresentationOptions: BindingParser<(NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions, Window.Binding, Downcast> { return .init(extract: { if case .willUseFullScreenPresentationOptions(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
	public static var willUseStandardFrame: BindingParser<(NSWindow, NSRect) -> NSRect, Window.Binding, Downcast> { return .init(extract: { if case .willUseStandardFrame(let x) = $0 { return x } else { return nil } }, upcast: { $0.asWindowBinding() }) }
}

#endif
