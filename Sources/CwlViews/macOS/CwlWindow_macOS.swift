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

// MARK: - Binder Part 1: Binder
public class Window: Binder, WindowConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Window {
	enum Binding: WindowBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case contentView(Constant<View>)
		case deferCreation(Constant<Bool>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case acceptsMouseMovedEvents(Dynamic<Bool>)
		case allowsConcurrentViewDrawing(Dynamic<Bool>)
		case allowsToolTipsWhenApplicationIsInactive(Dynamic<Bool>)
		case alphaValue(Dynamic<CGFloat>)
		case animationBehavior(Dynamic<NSWindow.AnimationBehavior>)
		case autorecalculatesKeyViewLoop(Dynamic<Bool>)
		case backingType(Dynamic<NSWindow.BackingStoreType>)
		case canBecomeVisibleWithoutLogin(Dynamic<Bool>)
		case canHide(Dynamic<Bool>)
		case collectionBehavior(Dynamic<NSWindow.CollectionBehavior>)
		case colorSpace(Dynamic<NSColorSpace>)
		case contentAspectRatio(Dynamic<NSSize>)
		case contentHeight(Dynamic<WindowSize>)
		case contentMaxSize(Dynamic<NSSize>)
		case contentMinSize(Dynamic<NSSize>)
		case contentResizeIncrements(Dynamic<NSSize>)
		case contentWidth(Dynamic<WindowSize>)
		case depthLimit(Dynamic<NSWindow.Depth?>)
		case displaysWhenScreenProfileChanges(Dynamic<Bool>)
		case frameAutosaveName(Dynamic<NSWindow.FrameAutosaveName>)
		case frameHorizontal(Dynamic<WindowPlacement>)
		case frameVertical(Dynamic<WindowPlacement>)
		case hasShadow(Dynamic<Bool>)
		case hidesOnDeactivate(Dynamic<Bool>)
		case ignoresMouseEvents(Dynamic<Bool>)
		case isAutodisplay(Dynamic<Bool>)
		case isDocumentEdited(Dynamic<Bool>)
		case isExcludedFromWindowsMenu(Dynamic<Bool>)
		case isMovable(Dynamic<Bool>)
		case isMovableByWindowBackground(Dynamic<Bool>)
		case isOneShot(Dynamic<Bool>)
		case isOpaque(Dynamic<Bool>)
		case isRestorable(Dynamic<Bool>)
		case key(Dynamic<Bool>)
		case level(Dynamic<NSWindow.Level>)
		case main(Dynamic<Bool>)
		case miniwindowImage(Dynamic<NSImage?>)
		case miniwindowTitle(Dynamic<String>)
		case order(Dynamic<WindowOrder>)
		case preferredBackingLocation(Dynamic<NSWindow.BackingLocation>)
		case preservesContentDuringLiveResize(Dynamic<Bool>)
		case preventsApplicationTerminationWhenModal(Dynamic<Bool>)
		case representedURL(Dynamic<URL?>)
		case resizeStyle(Dynamic<WindowResizeStyle>)
		case restorationClass(Dynamic<NSWindowRestoration.Type>)
		case screen(Dynamic<NSScreen?>)
		case sharingType(Dynamic<NSWindow.SharingType>)
		case styleMask(Dynamic<NSWindow.StyleMask>)
		case title(Dynamic<String>)
		case toolbar(Dynamic<ToolbarConvertible>)

		@available(macOS 10.11, *) case minFullScreenContentSize(Dynamic<NSSize>)
		@available(macOS 10.11, *) case maxFullScreenContentSize(Dynamic<NSSize>)

		// 2. Signal bindings are performed on the object after construction.
		case close(Signal<WindowCloseBehavior>)
		case criticalSheet(Signal<Callback<NSWindow, NSApplication.ModalResponse>>)
		case deminiaturize(Signal<Void>)
		case display(Signal<Bool>)
		case invalidateShadow(Signal<Void>)
		case miniaturize(Signal<Bool>)
		case presentError(Signal<Callback<Error, Bool>>)
		case printWindow(Signal<Void>)
		case recalculateKeyViewLoop(Signal<Void>)
		case runToolbarCustomizationPalette(Signal<Void>)
		case selectNextKeyView(Signal<Void>)
		case selectPreviousKeyView(Signal<Void>)
		case sheet(Signal<Callback<NSWindow, NSApplication.ModalResponse>>)
		case toggleFullScreen(Signal<Void>)
		case toggleToolbarShown(Signal<Void>)
		case zoom(Signal<Bool>)
		
		// 3. Action bindings are triggered by the object after construction.
		case didBecomeKey(SignalInput<Void>)
		case didBecomeMain(SignalInput<Void>)
		case didChangeBackingProperties(SignalInput<(oldColorSpace: NSColorSpace?, oldScaleFactor: CGFloat?)>)
		case didChangeOcclusionState(SignalInput<Void>)
		case didChangeScreen(SignalInput<Void>)
		case didChangeScreenProfile(SignalInput<Void>)
		case didDeminiaturize(SignalInput<Void>)
		case didEndLiveResize(SignalInput<Void>)
		case didEndSheet(SignalInput<Void>)
		case didEnterFullScreen(SignalInput<Void>)
		case didEnterVersionBrowser(SignalInput<Void>)
		case didExitFullScreen(SignalInput<Void>)
		case didExitVersionBrowser(SignalInput<Void>)
		case didExpose(SignalInput<NSRect>)
		case didMiniaturize(SignalInput<Void>)
		case didMove(SignalInput<Void>)
		case didResignKey(SignalInput<Void>)
		case didResignMain(SignalInput<Void>)
		case didResize(SignalInput<Void>)
		case didUpdate(SignalInput<Void>)
		case willBeginSheet(SignalInput<Void>)
		case willClose(SignalInput<Void>)
		case willEnterFullScreen(SignalInput<Void>)
		case willEnterVersionBrowser(SignalInput<Void>)
		case willExitFullScreen(SignalInput<Void>)
		case willExitVersionBrowser(SignalInput<Void>)
		case willMiniaturize(SignalInput<Void>)
		case willMove(SignalInput<Void>)
		case willStartLiveResize(SignalInput<Void>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldClose((NSWindow) -> Bool)
		case shouldPopUpDocumentPathMenu((NSWindow, NSMenu) -> Bool)
		case shouldZoom((NSWindow, NSRect) -> Bool)
		case willResize((NSWindow, NSSize) -> NSSize)
		case willResizeForVersionBrowser((_ window: NSWindow, _ maxPreferredSize: NSSize, _ maxAllowedSize: NSSize) -> NSSize)
		case willUseFullScreenContentSize((NSWindow, NSSize) -> NSSize)
		case willUseFullScreenPresentationOptions((NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions)
		case willUseStandardFrame((NSWindow, NSRect) -> NSRect)
	}
}

// MARK: - Binder Part 3: Preparer
public extension Window {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = Window.Binding
		public typealias Inherited = BinderBase
		public typealias Instance = NSWindow
		
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

		var deferCreation: Bool? = nil
		
		var contentWidth = InitialSubsequent<WindowSize>()
		var contentHeight = InitialSubsequent<WindowSize>()
		var screen = InitialSubsequent<NSScreen?>()
		var styleMask = InitialSubsequent<NSWindow.StyleMask>()
		var backingType = InitialSubsequent<NSWindow.BackingStoreType>()
		
		var frameAutosaveName: Dynamic<String>? = nil
		var frameHorizontal: Dynamic<WindowPlacement>? = nil
		var frameVertical: Dynamic<WindowPlacement>? = nil
		var key: Dynamic<Bool>? = nil
		var main: Dynamic<Bool>? = nil
		var order: Dynamic<WindowOrder>? = nil
		
		static let defaultWindowSize = NSSize(width: 400, height: 400)
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Window.Preparer {
	public func constructInstance(type: NSWindow.Type, parameters: Void) -> NSWindow {
		let width = contentWidth.initial ?? WindowSize(constant: Window.Preparer.defaultWindowSize.width)
		let height = contentHeight.initial ?? WindowSize(constant: Window.Preparer.defaultWindowSize.height)
		let screen = self.screen.initial ?? NSScreen.screens.first
		let styleMask = self.styleMask.initial ?? [.titled, .resizable, .closable, .miniaturizable]
		let backingType = self.backingType.initial ?? .buffered
		
		// Apply the ContentSize binding
		var contentSize = width.applyWidthToContentSize(NSZeroSize, onScreen: screen, windowClass: type, styleMask: styleMask)
		contentSize = height.applyHeightToContentSize(contentSize, onScreen: screen, windowClass: type, styleMask: styleMask)
		
		var frameRect = type.frameRect(forContentRect: NSRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height), styleMask: styleMask)
		frameRect.origin.y = screen.map { $0.visibleFrame.origin.y + $0.visibleFrame.size.height - frameRect.size.height } ?? 0
		
		let cr = type.contentRect(forFrameRect: frameRect, styleMask: styleMask)
		
		// Create the window
		let w = type.init(contentRect: cr, styleMask: styleMask, backing: backingType, defer: deferCreation ?? true, screen: screen)
		w.isReleasedWhenClosed = false
		
		// To be consistent with setting ".Screen", constrain the window to the screen.
		if let scr = screen {
			let r = w.constrainFrameRect(w.frame, to:scr)
			w.setFrameOrigin(r.origin)
		}
		return w
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
		
		case .backingType(let x): backingType = x.initialSubsequent()
		case .contentHeight(let x): contentHeight = x.initialSubsequent()
		case .contentWidth(let x): contentWidth = x.initialSubsequent()
		case .deferCreation(let x): deferCreation = x.value
		case .frameAutosaveName(let x): frameAutosaveName = x
		case .frameHorizontal(let x): frameHorizontal = x
		case .frameVertical(let x): frameVertical = x
		case .key(let x): key = x
		case .main(let x): main = x
		case .order(let x): order = x
		case .screen(let x): screen = x.initialSubsequent()
		case .shouldClose(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowShouldClose(_:)))
		case .shouldPopUpDocumentPathMenu(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:shouldPopUpDocumentPathMenu:)))
		case .shouldZoom(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowShouldZoom(_:toFrame:)))
		case .styleMask(let x): styleMask = x.initialSubsequent()
		case .willResize(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowWillResize(_:to:)))
		case .willResizeForVersionBrowser(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:willResizeForVersionBrowserWithMaxPreferredSize:maxAllowedSize:)))
		case .willUseFullScreenContentSize(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:willUseFullScreenContentSize:)))
		case .willUseFullScreenPresentationOptions(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:willUseFullScreenPresentationOptions:)))
		case .willUseStandardFrame(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowWillUseStandardFrame(_:defaultFrame:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let s): return inherited.applyBinding(s, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .contentView(let x):
			if let cv = instance.contentView {
				x.value.apply(to: cv)
			}
			return nil
		case .deferCreation: return nil

		// 1. Value bindings may be applied at construction and may subsequently change.
		case .acceptsMouseMovedEvents(let x): return x.apply(instance) { i, v in i.acceptsMouseMovedEvents = v }
		case .allowsConcurrentViewDrawing(let x): return x.apply(instance) { i, v in i.allowsConcurrentViewDrawing = v }
		case .allowsToolTipsWhenApplicationIsInactive(let x): return x.apply(instance) { i, v in i.allowsToolTipsWhenApplicationIsInactive = v }
		case .alphaValue(let x): return x.apply(instance) { i, v in i.alphaValue = v }
		case .animationBehavior(let x): return x.apply(instance) { i, v in i.animationBehavior = v }
		case .autorecalculatesKeyViewLoop(let x): return x.apply(instance) { i, v in i.autorecalculatesKeyViewLoop = v }
		case .backingType: return backingType.resume()?.apply(instance) { i, v in i.backingType = v }
		case .canBecomeVisibleWithoutLogin(let x): return x.apply(instance) { i, v in i.canBecomeVisibleWithoutLogin = v }
		case .canHide(let x): return x.apply(instance) { i, v in i.canHide = v }
		case .collectionBehavior(let x): return x.apply(instance) { i, v in i.collectionBehavior = v }
		case .colorSpace(let x): return x.apply(instance) { i, v in i.colorSpace = v }
		case .contentAspectRatio(let x): return x.apply(instance) { i, v in i.contentAspectRatio = v }
		case .contentHeight: return contentHeight.resume()?.apply(instance) { i, v in i.setContentSize(v.applyHeightToContentSize(i.contentView!.frame.size, onScreen: i.screen, windowClass: type(of: i), styleMask: i.styleMask)) }
		case .contentMaxSize(let x): return x.apply(instance) { i, v in i.contentMaxSize = v }
		case .contentMinSize(let x): return x.apply(instance) { i, v in i.contentMinSize = v }
		case .contentResizeIncrements(let x): return x.apply(instance) { i, v in i.contentResizeIncrements = v }
		case .contentWidth: return contentWidth.resume()?.apply(instance) { i, v in i.setContentSize(v.applyWidthToContentSize(i.contentView!.frame.size, onScreen: i.screen, windowClass: type(of: i), styleMask: i.styleMask)) }
		case .depthLimit(let x): return x.apply(instance) { i, v in v.map { i.depthLimit = $0 } ?? i.setDynamicDepthLimit(true) }
		case .displaysWhenScreenProfileChanges(let x): return x.apply(instance) { i, v in i.displaysWhenScreenProfileChanges = v }
		case .frameAutosaveName: return nil
		case .frameHorizontal: return nil
		case .frameVertical: return nil
		case .hasShadow(let x): return x.apply(instance) { i, v in i.hasShadow = v }
		case .hidesOnDeactivate(let x): return x.apply(instance) { i, v in i.hidesOnDeactivate = v }
		case .ignoresMouseEvents(let x): return x.apply(instance) { i, v in i.ignoresMouseEvents = v }
		case .isAutodisplay(let x): return x.apply(instance) { i, v in i.isAutodisplay = v }
		case .isDocumentEdited(let x): return x.apply(instance) { i, v in i.isDocumentEdited = v }
		case .isExcludedFromWindowsMenu(let x): return x.apply(instance) { i, v in i.isExcludedFromWindowsMenu = v }
		case .isMovable(let x): return x.apply(instance) { i, v in i.isMovable = v }
		case .isMovableByWindowBackground(let x): return x.apply(instance) { i, v in i.isMovableByWindowBackground = v }
		case .isOneShot(let x): return x.apply(instance) { i, v in i.isOneShot = v }
		case .isOpaque(let x): return x.apply(instance) { i, v in i.isOpaque = v }
		case .isRestorable(let x): return x.apply(instance) { i, v in i.isRestorable = v }
		case .key: return nil
		case .level(let x): return x.apply(instance) { i, v in i.level = v }
		case .main: return nil
		case .miniwindowImage(let x): return x.apply(instance) { i, v in i.miniwindowImage = v }
		case .miniwindowTitle(let x): return x.apply(instance) { i, v in i.miniwindowTitle = v }
		case .order: return nil
		case .preferredBackingLocation(let x): return x.apply(instance) { i, v in i.preferredBackingLocation = v }
		case .preservesContentDuringLiveResize(let x): return x.apply(instance) { i, v in i.preservesContentDuringLiveResize = v }
		case .preventsApplicationTerminationWhenModal(let x): return x.apply(instance) { i, v in i.preventsApplicationTerminationWhenModal = v }
		case .representedURL(let x): return x.apply(instance) { i, v in i.representedURL = v }
		case .resizeStyle(let x):
			return x.apply(instance) { i, v in
				switch v {
				case .increment(let s):
					i.resizeIncrements = s
				case .contentAspect(let s):
					i.contentAspectRatio = s
				}
			}
		case .restorationClass(let x): return x.apply(instance) { i, v in i.restorationClass = v }
		case .screen:
			return screen.resume().flatMap { $0.apply(instance) { i, v in
				let r = i.constrainFrameRect(i.frame, to:v)
				i.setFrameOrigin(r.origin)
			} }
		case .sharingType(let x): return x.apply(instance) { i, v in i.sharingType = v }
		case .styleMask: return styleMask.resume().flatMap { $0.apply(instance) { i, v in i.styleMask = v } }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .toolbar(let x): return x.apply(instance) { i, v in i.toolbar = v.nsToolbar() }

		case .minFullScreenContentSize(let x):
			guard #available(macOS 10.11, *) else { return }
			return x.apply(instance) { i, v in i.minFullScreenContentSize = v }
		case .maxFullScreenContentSize(let x):
			guard #available(macOS 10.11, *) else { return }
			return x.apply(instance) { i, v in i.maxFullScreenContentSize = v }
		
		// 2. Signal bindings are performed on the object after construction.
		case .close(let x):
			return x.apply(instance) { i, v in
				switch v {
				case .stopModal(let c):
					if i.isSheet {
						i.sheetParent?.endSheet(i, returnCode: c)
					} else if NSApplication.shared.modalWindow == i {
						NSApplication.shared.stopModal(withCode: c)
					} else {
						i.close()
					}
				case _ where i.isSheet: i.sheetParent?.endSheet(i)
				case _ where NSApplication.shared.modalWindow == i: NSApplication.shared.stopModal()
				case .perform: i.performClose(nil)
				case .dismiss: i.close()
				}
			}
		case .criticalSheet(let x): return x.apply(instance) { i, v in i.beginCriticalSheet(v.value) { r in _ = v.callback.send(value: r) } }
		case .deminiaturize(let x): return x.apply(instance) { i, v in i.deminiaturize(nil) }
		case .display(let x): return x.apply(instance) { i, v in v ? i.displayIfNeeded() : i.display() }
		case .invalidateShadow(let x): return x.apply(instance) { i, v in i.invalidateShadow() }
		case .miniaturize(let x): return x.apply(instance) { i, v in v ? i.performMiniaturize(nil) : i.miniaturize(nil) }
		case .presentError(let x):
			return x.apply(instance, storage) { i, s, v in
				let ptr = Unmanaged.passRetained(v.callback).toOpaque()
				let sel = #selector(Window.Preparer.Storage.didPresentError(recovered:contextInfo:))
				i.presentError(v.value, modalFor: i, delegate: s, didPresent: sel, contextInfo: ptr)
			}
		case .printWindow(let x): return x.apply(instance) { i, v in i.printWindow(nil) }
		case .recalculateKeyViewLoop(let x): return x.apply(instance) { i, v in i.recalculateKeyViewLoop() }
		case .runToolbarCustomizationPalette(let x): return x.apply(instance) { i, v in i.runToolbarCustomizationPalette(nil) }
		case .selectNextKeyView(let x): return x.apply(instance) { i, v in i.selectNextKeyView(nil) }
		case .selectPreviousKeyView(let x): return x.apply(instance) { i, v in i.selectPreviousKeyView(nil) }
		case .sheet(let x): return x.apply(instance) { i, v in i.beginSheet(v.value) { r in _ = v.callback.send(value: r) } }
		case .toggleFullScreen(let x): return x.apply(instance) { i, v in i.toggleFullScreen(nil) }
		case .toggleToolbarShown(let x): return x.apply(instance) { i, v in i.toggleToolbarShown(nil) }
		case .zoom(let x): return x.apply(instance) { i, v in v ? i.performZoom(nil) : i.zoom(nil) }
			
		// 3. Action bindings are triggered by the object after construction.
		case .didBecomeKey(let x): return Signal.notifications(name: NSWindow.didBecomeKeyNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didBecomeMain(let x): return Signal.notifications(name: NSWindow.didBecomeMainNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didChangeBackingProperties(let x):
			return Signal.notifications(name: NSWindow.didChangeBackingPropertiesNotification, object: instance).map { n in
				let cs = n.userInfo.flatMap { $0[NSWindow.oldColorSpaceUserInfoKey] as? NSColorSpace }
				let sf = n.userInfo.flatMap { ($0[NSWindow.oldScaleFactorUserInfoKey] as? NSNumber).map { CGFloat($0.doubleValue) } }
				return (oldColorSpace: cs, oldScaleFactor: sf )
			}.cancellableBind(to: x)
		case .didChangeOcclusionState(let x): return Signal.notifications(name: NSWindow.didChangeOcclusionStateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didChangeScreen(let x): return Signal.notifications(name: NSWindow.didChangeScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didChangeScreenProfile(let x): return Signal.notifications(name: NSWindow.didChangeScreenProfileNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didDeminiaturize(let x): return Signal.notifications(name: NSWindow.didDeminiaturizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didEndLiveResize(let x): return Signal.notifications(name: NSWindow.didEndLiveResizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didEndSheet(let x): return Signal.notifications(name: NSWindow.didEndSheetNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didEnterFullScreen(let x): return Signal.notifications(name: NSWindow.didEnterFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didEnterVersionBrowser(let x): return Signal.notifications(name: NSWindow.didEnterVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didExitFullScreen(let x): return Signal.notifications(name: NSWindow.didExitFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didExitVersionBrowser(let x): return Signal.notifications(name: NSWindow.didExitVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didExpose(let x): return Signal.notifications(name: NSWindow.didExposeNotification, object: instance).compactMap { (n: Notification) -> NSRect? in return (n.userInfo?["NSExposedRect"] as? NSValue)?.rectValue ?? nil }.cancellableBind(to: x)
		case .didMiniaturize(let x): return Signal.notifications(name: NSWindow.didMiniaturizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didMove(let x): return Signal.notifications(name: NSWindow.didMoveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didResignKey(let x): return Signal.notifications(name: NSWindow.didResignKeyNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didResignMain(let x): return Signal.notifications(name: NSWindow.didResignMainNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didResize(let x): return Signal.notifications(name: NSWindow.didResizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .didUpdate(let x): return Signal.notifications(name: NSWindow.didUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willBeginSheet(let x): return Signal.notifications(name: NSWindow.willBeginSheetNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willClose(let x): return Signal.notifications(name: NSWindow.willCloseNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willEnterFullScreen(let x): return Signal.notifications(name: NSWindow.willEnterFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willEnterVersionBrowser(let x): return Signal.notifications(name: NSWindow.willEnterVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willExitFullScreen(let x): return Signal.notifications(name: NSWindow.willExitFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willExitVersionBrowser(let x): return Signal.notifications(name: NSWindow.willExitVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willMiniaturize(let x): return Signal.notifications(name: NSWindow.willMiniaturizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willMove(let x): return Signal.notifications(name: NSWindow.willMoveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
		case .willStartLiveResize(let x): return Signal.notifications(name: NSWindow.willStartLiveResizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .shouldClose: return nil
		case .shouldPopUpDocumentPathMenu: return nil
		case .shouldZoom: return nil
		case .willResize: return nil
		case .willResizeForVersionBrowser: return nil
		case .willUseFullScreenContentSize: return nil
		case .willUseFullScreenPresentationOptions: return nil
		case .willUseStandardFrame: return nil
		}
	}

	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		var lifetimes = [Lifetime]()
		lifetimes += inheritedFinalizedInstance(instance, storage: storage)
		
		// Layout the content
		instance.layoutIfNeeded()
		
		// Following content layout, attempt to place the window on screen
		lifetimes += frameHorizontal?.apply(instance) { i, v in
			i.setFrameOrigin(v.applyFrameHorizontal(i.screen, frameRect: i.frame))
		}
		lifetimes += frameVertical?.apply(instance) { i, v in
			i.setFrameOrigin(v.applyFrameVertical(i.screen, frameRect: i.frame))
		}
		lifetimes += frameAutosaveName?.apply(instance) { i, v in
			i.setFrameAutosaveName(v)
		}
		
		// Set intial order, key and main after everything else
		let captureOrder = order?.initialSubsequent()
		let captureKey = key?.initialSubsequent()
		let captureMain = main?.initialSubsequent()
		switch (captureOrder?.initial ?? .front) {
		case .front where captureKey?.initial == true: instance.makeKeyAndOrderFront(nil)
		case .front: fallthrough
		case .back: WindowOrder.back.applyToWindow(instance)
		case .out: break
		}
		if (captureMain?.initial ?? true) == true {
			instance.makeMain()
		}
		
		// Resume order, key and main
		lifetimes += captureOrder?.resume()?.apply(instance) { i, v in v.applyToWindow(i) }
		lifetimes += captureKey?.resume()?.apply(instance) { i, v in v ? i.makeKey() : i.resignKey() }
		lifetimes += captureMain?.resume()?.apply(instance) { i, v in v ? i.makeMain() : i.resignMain() }
		
		return AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Window.Preparer {
	open class Storage: View.Preparer.Storage, NSWindowDelegate {
		@objc func didPresentError(recovered: Bool, contextInfo: UnsafeMutableRawPointer?) {
			if let ptr = contextInfo {
				Unmanaged<SignalInput<Bool>>.fromOpaque(ptr).takeRetainedValue().send(value: recovered)
			}
		}
	}

	open class Delegate: DynamicDelegate, NSWindowDelegate {
		open func windowWillResize(_ window: NSWindow, to toSize: NSSize) -> NSSize {
			return handler(ofType: ((NSWindow, NSSize) -> NSSize).self)!(window, toSize)
		}
		
		open func windowWillUseStandardFrame(_ window: NSWindow, defaultFrame: NSRect) -> NSRect {
			return handler(ofType: ((NSWindow, NSRect) -> NSRect).self)!(window, defaultFrame)
		}
		
		open func windowShouldZoom(_ window: NSWindow, toFrame: NSRect) -> Bool {
			return handler(ofType: ((NSWindow, NSRect) -> Bool).self)!(window, toFrame)
		}
		
		open func window(_ window: NSWindow, willUseFullScreenContentSize param: NSSize) -> NSSize {
			return handler(ofType: ((NSWindow, NSSize) -> NSSize).self)!(window, param)
		}
		
		open func window(_ window: NSWindow, willUseFullScreenPresentationOptions param: NSApplication.PresentationOptions) -> NSApplication.PresentationOptions {
			return handler(ofType: ((NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions).self)!(window, param)
		}
		
		open func windowShouldClose(_ window: NSWindow) -> Bool {
			return handler(ofType: ((NSWindow) -> Bool).self)!(window)
		}
		
		open func window(_ window: NSWindow, shouldPopUpDocumentPathMenu param: NSMenu) -> Bool {
			return handler(ofType: ((NSWindow, NSMenu) -> Bool).self)!(window, param)
		}
		
		open func window(_ window: NSWindow, willResizeForVersionBrowserWithMaxPreferredSize: NSSize, maxAllowedSize: NSSize) -> NSSize {
			return handler(ofType: ((NSWindow, NSSize, NSSize) -> NSSize).self)!(window, willResizeForVersionBrowserWithMaxPreferredSize, maxAllowedSize)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: WindowBinding {
	public typealias WindowName<V> = BindingName<V, Window.Binding, Binding>
	private typealias B = Window.Binding
	private static func name<V>(_ source: @escaping (V) -> Window.Binding) -> WindowName<V> {
		return WindowName<V>(source: source, downcast: Binding.windowBinding)
	}
}
public extension BindingName where Binding: WindowBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: WindowName<$2> { return .name(B.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Static styles are applied at construction and are subsequently immutable.
	static var contentView: WindowName<Constant<View>> { return .name(B.contentView) }
	static var deferCreation: WindowName<Constant<Bool>> { return .name(B.deferCreation) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var acceptsMouseMovedEvents: WindowName<Dynamic<Bool>> { return .name(B.acceptsMouseMovedEvents) }
	static var allowsConcurrentViewDrawing: WindowName<Dynamic<Bool>> { return .name(B.allowsConcurrentViewDrawing) }
	static var allowsToolTipsWhenApplicationIsInactive: WindowName<Dynamic<Bool>> { return .name(B.allowsToolTipsWhenApplicationIsInactive) }
	static var alphaValue: WindowName<Dynamic<CGFloat>> { return .name(B.alphaValue) }
	static var animationBehavior: WindowName<Dynamic<NSWindow.AnimationBehavior>> { return .name(B.animationBehavior) }
	static var autorecalculatesKeyViewLoop: WindowName<Dynamic<Bool>> { return .name(B.autorecalculatesKeyViewLoop) }
	static var backingType: WindowName<Dynamic<NSWindow.BackingStoreType>> { return .name(B.backingType) }
	static var canBecomeVisibleWithoutLogin: WindowName<Dynamic<Bool>> { return .name(B.canBecomeVisibleWithoutLogin) }
	static var canHide: WindowName<Dynamic<Bool>> { return .name(B.canHide) }
	static var collectionBehavior: WindowName<Dynamic<NSWindow.CollectionBehavior>> { return .name(B.collectionBehavior) }
	static var colorSpace: WindowName<Dynamic<NSColorSpace>> { return .name(B.colorSpace) }
	static var contentAspectRatio: WindowName<Dynamic<NSSize>> { return .name(B.contentAspectRatio) }
	static var contentHeight: WindowName<Dynamic<WindowSize>> { return .name(B.contentHeight) }
	static var contentMaxSize: WindowName<Dynamic<NSSize>> { return .name(B.contentMaxSize) }
	static var contentMinSize: WindowName<Dynamic<NSSize>> { return .name(B.contentMinSize) }
	static var contentResizeIncrements: WindowName<Dynamic<NSSize>> { return .name(B.contentResizeIncrements) }
	static var contentWidth: WindowName<Dynamic<WindowSize>> { return .name(B.contentWidth) }
	static var depthLimit: WindowName<Dynamic<NSWindow.Depth?>> { return .name(B.depthLimit) }
	static var displaysWhenScreenProfileChanges: WindowName<Dynamic<Bool>> { return .name(B.displaysWhenScreenProfileChanges) }
	static var frameAutosaveName: WindowName<Dynamic<NSWindow.FrameAutosaveName>> { return .name(B.frameAutosaveName) }
	static var frameHorizontal: WindowName<Dynamic<WindowPlacement>> { return .name(B.frameHorizontal) }
	static var frameVertical: WindowName<Dynamic<WindowPlacement>> { return .name(B.frameVertical) }
	static var hasShadow: WindowName<Dynamic<Bool>> { return .name(B.hasShadow) }
	static var hidesOnDeactivate: WindowName<Dynamic<Bool>> { return .name(B.hidesOnDeactivate) }
	static var ignoresMouseEvents: WindowName<Dynamic<Bool>> { return .name(B.ignoresMouseEvents) }
	static var isAutodisplay: WindowName<Dynamic<Bool>> { return .name(B.isAutodisplay) }
	static var isDocumentEdited: WindowName<Dynamic<Bool>> { return .name(B.isDocumentEdited) }
	static var isExcludedFromWindowsMenu: WindowName<Dynamic<Bool>> { return .name(B.isExcludedFromWindowsMenu) }
	static var isMovable: WindowName<Dynamic<Bool>> { return .name(B.isMovable) }
	static var isMovableByWindowBackground: WindowName<Dynamic<Bool>> { return .name(B.isMovableByWindowBackground) }
	static var isOneShot: WindowName<Dynamic<Bool>> { return .name(B.isOneShot) }
	static var isOpaque: WindowName<Dynamic<Bool>> { return .name(B.isOpaque) }
	static var isRestorable: WindowName<Dynamic<Bool>> { return .name(B.isRestorable) }
	static var key: WindowName<Dynamic<Bool>> { return .name(B.key) }
	static var level: WindowName<Dynamic<NSWindow.Level>> { return .name(B.level) }
	static var main: WindowName<Dynamic<Bool>> { return .name(B.main) }
	static var miniwindowImage: WindowName<Dynamic<NSImage?>> { return .name(B.miniwindowImage) }
	static var miniwindowTitle: WindowName<Dynamic<String>> { return .name(B.miniwindowTitle) }
	static var order: WindowName<Dynamic<WindowOrder>> { return .name(B.order) }
	static var preferredBackingLocation: WindowName<Dynamic<NSWindow.BackingLocation>> { return .name(B.preferredBackingLocation) }
	static var preservesContentDuringLiveResize: WindowName<Dynamic<Bool>> { return .name(B.preservesContentDuringLiveResize) }
	static var preventsApplicationTerminationWhenModal: WindowName<Dynamic<Bool>> { return .name(B.preventsApplicationTerminationWhenModal) }
	static var representedURL: WindowName<Dynamic<URL?>> { return .name(B.representedURL) }
	static var resizeStyle: WindowName<Dynamic<WindowResizeStyle>> { return .name(B.resizeStyle) }
	static var restorationClass: WindowName<Dynamic<NSWindowRestoration.Type>> { return .name(B.restorationClass) }
	static var screen: WindowName<Dynamic<NSScreen?>> { return .name(B.screen) }
	static var sharingType: WindowName<Dynamic<NSWindow.SharingType>> { return .name(B.sharingType) }
	static var styleMask: WindowName<Dynamic<NSWindow.StyleMask>> { return .name(B.styleMask) }
	static var title: WindowName<Dynamic<String>> { return .name(B.title) }
	static var toolbar: WindowName<Dynamic<ToolbarConvertible>> { return .name(B.toolbar) }
	
	@available(macOS 10.11, *) static var minFullScreenContentSize: WindowName<Dynamic<NSSize>> { return .name(B.minFullScreenContentSize) }
	@available(macOS 10.11, *) static var maxFullScreenContentSize: WindowName<Dynamic<NSSize>> { return .name(B.maxFullScreenContentSize) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var close: WindowName<Signal<WindowCloseBehavior>> { return .name(B.close) }
	static var criticalSheet: WindowName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>> { return .name(B.criticalSheet) }
	static var deminiaturize: WindowName<Signal<Void>> { return .name(B.deminiaturize) }
	static var display: WindowName<Signal<Bool>> { return .name(B.display) }
	static var invalidateShadow: WindowName<Signal<Void>> { return .name(B.invalidateShadow) }
	static var miniaturize: WindowName<Signal<Bool>> { return .name(B.miniaturize) }
	static var presentError: WindowName<Signal<Callback<Error, Bool>>> { return .name(B.presentError) }
	static var printWindow: WindowName<Signal<Void>> { return .name(B.printWindow) }
	static var recalculateKeyViewLoop: WindowName<Signal<Void>> { return .name(B.recalculateKeyViewLoop) }
	static var runToolbarCustomizationPalette: WindowName<Signal<Void>> { return .name(B.runToolbarCustomizationPalette) }
	static var selectNextKeyView: WindowName<Signal<Void>> { return .name(B.selectNextKeyView) }
	static var selectPreviousKeyView: WindowName<Signal<Void>> { return .name(B.selectPreviousKeyView) }
	static var sheet: WindowName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>> { return .name(B.sheet) }
	static var toggleFullScreen: WindowName<Signal<Void>> { return .name(B.toggleFullScreen) }
	static var toggleToolbarShown: WindowName<Signal<Void>> { return .name(B.toggleToolbarShown) }
	static var zoom: WindowName<Signal<Bool>> { return .name(B.zoom) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didBecomeKey: WindowName<SignalInput<Void>> { return .name(B.didBecomeKey) }
	static var didBecomeMain: WindowName<SignalInput<Void>> { return .name(B.didBecomeMain) }
	static var didChangeBackingProperties: WindowName<SignalInput<(oldColorSpace: NSColorSpace?, oldScaleFactor: CGFloat?)>> { return .name(B.didChangeBackingProperties) }
	static var didChangeOcclusionState: WindowName<SignalInput<Void>> { return .name(B.didChangeOcclusionState) }
	static var didChangeScreen: WindowName<SignalInput<Void>> { return .name(B.didChangeScreen) }
	static var didChangeScreenProfile: WindowName<SignalInput<Void>> { return .name(B.didChangeScreenProfile) }
	static var didDeminiaturize: WindowName<SignalInput<Void>> { return .name(B.didDeminiaturize) }
	static var didEndLiveResize: WindowName<SignalInput<Void>> { return .name(B.didEndLiveResize) }
	static var didEndSheet: WindowName<SignalInput<Void>> { return .name(B.didEndSheet) }
	static var didEnterFullScreen: WindowName<SignalInput<Void>> { return .name(B.didEnterFullScreen) }
	static var didEnterVersionBrowser: WindowName<SignalInput<Void>> { return .name(B.didEnterVersionBrowser) }
	static var didExitFullScreen: WindowName<SignalInput<Void>> { return .name(B.didExitFullScreen) }
	static var didExitVersionBrowser: WindowName<SignalInput<Void>> { return .name(B.didExitVersionBrowser) }
	static var didExpose: WindowName<SignalInput<NSRect>> { return .name(B.didExpose) }
	static var didMiniaturize: WindowName<SignalInput<Void>> { return .name(B.didMiniaturize) }
	static var didMove: WindowName<SignalInput<Void>> { return .name(B.didMove) }
	static var didResignKey: WindowName<SignalInput<Void>> { return .name(B.didResignKey) }
	static var didResignMain: WindowName<SignalInput<Void>> { return .name(B.didResignMain) }
	static var didResize: WindowName<SignalInput<Void>> { return .name(B.didResize) }
	static var didUpdate: WindowName<SignalInput<Void>> { return .name(B.didUpdate) }
	static var willBeginSheet: WindowName<SignalInput<Void>> { return .name(B.willBeginSheet) }
	static var willClose: WindowName<SignalInput<Void>> { return .name(B.willClose) }
	static var willEnterFullScreen: WindowName<SignalInput<Void>> { return .name(B.willEnterFullScreen) }
	static var willEnterVersionBrowser: WindowName<SignalInput<Void>> { return .name(B.willEnterVersionBrowser) }
	static var willExitFullScreen: WindowName<SignalInput<Void>> { return .name(B.willExitFullScreen) }
	static var willExitVersionBrowser: WindowName<SignalInput<Void>> { return .name(B.willExitVersionBrowser) }
	static var willMiniaturize: WindowName<SignalInput<Void>> { return .name(B.willMiniaturize) }
	static var willMove: WindowName<SignalInput<Void>> { return .name(B.willMove) }
	static var willStartLiveResize: WindowName<SignalInput<Void>> { return .name(B.willStartLiveResize) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var shouldClose: WindowName<(NSWindow) -> Bool> { return .name(B.shouldClose) }
	static var shouldPopUpDocumentPathMenu: WindowName<(NSWindow, NSMenu) -> Bool> { return .name(B.shouldPopUpDocumentPathMenu) }
	static var shouldZoom: WindowName<(NSWindow, NSRect) -> Bool> { return .name(B.shouldZoom) }
	static var willResize: WindowName<(NSWindow, NSSize) -> NSSize> { return .name(B.willResize) }
	static var willResizeForVersionBrowser: WindowName<(_ window: NSWindow, _ maxPreferredSize: NSSize, _ maxAllowedSize: NSSize) -> NSSize> { return .name(B.willResizeForVersionBrowser) }
	static var willUseFullScreenContentSize: WindowName<(NSWindow, NSSize) -> NSSize> { return .name(B.willUseFullScreenContentSize) }
	static var willUseFullScreenPresentationOptions: WindowName<(NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions> { return .name(B.willUseFullScreenPresentationOptions) }
	static var willUseStandardFrame: WindowName<(NSWindow, NSRect) -> NSRect> { return .name(B.willUseStandardFrame) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol WindowConvertible {
	func nsWindow() -> Window.Instance
}
extension NSWindow: WindowConvertible, DefaultConstructable, HasDelegate {
	public func nsWindow() -> Window.Instance { return self }
}
public extension Window {
	public func nsWindow() -> Window.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol WindowBinding: BinderBaseBinding {
	static func windowBinding(_ binding: Window.Binding) -> Self
}
public extension WindowBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return windowBinding(.inheritedBinding(binding))
	}
}
public extension Window.Binding {
	public typealias Preparer = Window.Preparer
	static func windowBinding(_ binding: Window.Binding) -> Window.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public enum WindowCloseBehavior {
	case dismiss
	case perform
	case stopModal(NSApplication.ModalResponse)
}

public enum WindowOrder {
	case front
	case back
	case out
	
	public func applyToWindow(_ window: NSWindow) {
		switch self {
		case .front: window.orderFront(nil)
		case .back: window.orderBack(nil)
		case .out: window.orderOut(nil)
		}
	}
}

public enum WindowResizeStyle {
	case increment(NSSize)
	case contentAspect(NSSize)
	
	public static func normal() -> WindowResizeStyle {
		return .increment(NSSize(width: 1.0, height: 1.0))
	}
}

public struct WindowPlacement: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
	public let ratio: CGFloat
	public let constant: CGFloat
	
	public init(integerLiteral value: Int) {
		self.init(floatLiteral: Double(value))
	}

	public init(floatLiteral value: Double) {
		if value < 0 {
			self.init(ratio: 1, constant: CGFloat(value))
		} else {
			self.init(ratio: 0, constant: CGFloat(value))
		}
	}
	
	public init(ratio: CGFloat = 0, constant: CGFloat = 0) {
		self.ratio = ratio
		self.constant = constant
	}
	
	public static func screenRatio(_ ratio: CGFloat, constant: CGFloat = 0) -> WindowPlacement {
		return WindowPlacement(ratio: ratio, constant: constant)
	}

	fileprivate func applyFrameValue(frameLength: CGFloat, screenAvailable: CGFloat) -> CGFloat {
		let space = screenAvailable - frameLength
		if space > 0 {
			return space * ratio + constant
		} else {
			return 0
		}
	}
	
	public func applyFrameVertical(_ screen: NSScreen?, frameRect: NSRect) -> NSPoint {
		guard let visible = screen?.visibleFrame else {
			return frameRect.origin
		}
		
		let offset = applyFrameValue(frameLength: frameRect.size.height, screenAvailable: visible.size.height)
		let y = visible.origin.y + visible.size.height - frameRect.size.height - offset
		return NSPoint(x: frameRect.origin.x, y: y)
	}
	
	public func applyFrameHorizontal(_ screen: NSScreen?, frameRect: NSRect) -> NSPoint {
		guard let visible = screen?.visibleFrame else {
			return frameRect.origin
		}
		
		let offset = applyFrameValue(frameLength: frameRect.size.width, screenAvailable: visible.size.width)
		let x = visible.origin.x + offset
		return NSPoint(x: x, y: frameRect.origin.y)
	}
}

public enum WindowSizeAnchor {
	case aspect
	case screen
}

public struct WindowSize: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Double
	public typealias IntegerLiteralType = Int
	
	public let anchor: WindowSizeAnchor
	public let ratio: CGFloat
	public let constant: CGFloat
	
	public init(integerLiteral value: Int) {
		self.init(floatLiteral: Double(value))
	}

	public init(floatLiteral value: Double) {
		self.anchor = .screen
		self.ratio = 0
		self.constant = CGFloat(value)
	}
	
	public init(anchor: WindowSizeAnchor = .screen, ratio: CGFloat = 0, constant: CGFloat = 0) {
		self.anchor = anchor
		self.ratio = ratio
		self.constant = constant
	}
	
	public static func aspectRatio(ratio: CGFloat = 1, constant: CGFloat = 0) -> WindowSize {
		return WindowSize(anchor: .aspect, ratio: ratio, constant: constant)
	}
	
	public static func screenRatio(_ ratio: CGFloat = 0, constant: CGFloat = 0) -> WindowSize {
		return WindowSize(anchor: .screen, ratio: ratio, constant: constant)
	}
	
	public func applyWidthToContentSize<W: NSWindow>(_ contentSize: NSSize, onScreen: NSScreen?, windowClass: W.Type, styleMask: NSWindow.StyleMask) -> NSSize {
		let resultSize: NSSize
		switch self.anchor {
		case .aspect:
			resultSize = NSSize(width: ratio * contentSize.height + constant, height: contentSize.height)
		case .screen:
			if let s = onScreen {
				let frame = windowClass.contentRect(forFrameRect: s.visibleFrame, styleMask: styleMask)
				resultSize = NSSize(width: ratio * frame.width + constant, height: contentSize.height)
			} else {
				resultSize = contentSize
			}
		}
		return resultSize
	}
	
	public func applyHeightToContentSize<W: NSWindow>(_ contentSize: NSSize, onScreen: NSScreen?, windowClass: W.Type, styleMask: NSWindow.StyleMask) -> NSSize {
		let resultSize: NSSize
		switch self.anchor {
		case .aspect:
			resultSize = NSSize(width: contentSize.width, height: ratio * contentSize.width + constant)
		case .screen:
			if let s = onScreen {
				let frame = windowClass.contentRect(forFrameRect: s.visibleFrame, styleMask: styleMask)
				resultSize = NSSize(width: contentSize.width, height: ratio * frame.height + constant)
			} else {
				resultSize = contentSize
			}
		}
		return resultSize
	}
}

extension NSWindow: Lifetime {
	public func cancel() {
		return nsWindow().close()
	}
}

#endif
