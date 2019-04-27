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
		case deferCreation(Constant<Bool>)
		case initialFirstResponderTag(Constant<Int>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case acceptsMouseMovedEvents(Dynamic<Bool>)
		case allowsConcurrentViewDrawing(Dynamic<Bool>)
		case allowsToolTipsWhenApplicationIsInactive(Dynamic<Bool>)
		case alphaValue(Dynamic<CGFloat>)
		case animationBehavior(Dynamic<NSWindow.AnimationBehavior>)
		case appearance(Dynamic<NSAppearance?>)
		case autorecalculatesKeyViewLoop(Dynamic<Bool>)
		case backingType(Dynamic<NSWindow.BackingStoreType>)
		case canBecomeVisibleWithoutLogin(Dynamic<Bool>)
		case canHide(Dynamic<Bool>)
		case collectionBehavior(Dynamic<NSWindow.CollectionBehavior>)
		case colorSpace(Dynamic<NSColorSpace>)
		case contentAspectRatio(Dynamic<NSSize>)
		case contentHeight(Dynamic<WindowDimension>)
		case contentMaxSize(Dynamic<NSSize>)
		case contentMinSize(Dynamic<NSSize>)
		case contentResizeIncrements(Dynamic<NSSize>)
		case contentRelativity(Dynamic<WindowDimension.Relativity>)
		case contentView(Dynamic<ViewConvertible>)
		case contentWidth(Dynamic<WindowDimension>)
		case depthLimit(Dynamic<NSWindow.Depth?>)
		case displaysWhenScreenProfileChanges(Dynamic<Bool>)
		case frameAutosaveName(Dynamic<NSWindow.FrameAutosaveName>)
		case frameHorizontal(Dynamic<WindowDimension>)
		case frameVertical(Dynamic<WindowDimension>)
		case hasShadow(Dynamic<Bool>)
		case hidesOnDeactivate(Dynamic<Bool>)
		case ignoresMouseEvents(Dynamic<Bool>)
		case isDocumentEdited(Dynamic<Bool>)
		case isExcludedFromWindowsMenu(Dynamic<Bool>)
		case isMovable(Dynamic<Bool>)
		case isMovableByWindowBackground(Dynamic<Bool>)
		case isOpaque(Dynamic<Bool>)
		case isRestorable(Dynamic<Bool>)
		case key(Dynamic<Bool>)
		case level(Dynamic<NSWindow.Level>)
		case main(Dynamic<Bool>)
		case maxFullScreenContentSize(Dynamic<NSSize>)
		case minFullScreenContentSize(Dynamic<NSSize>)
		case miniwindowImage(Dynamic<NSImage?>)
		case miniwindowTitle(Dynamic<String>)
		case order(Dynamic<WindowOrder>)
		case preservesContentDuringLiveResize(Dynamic<Bool>)
		case preventsApplicationTerminationWhenModal(Dynamic<Bool>)
		case representedURL(Dynamic<URL?>)
		case resizeStyle(Dynamic<WindowResizeStyle>)
		case restorationClass(Dynamic<NSWindowRestoration.Type>)
		case screen(Dynamic<NSScreen?>)
		case sharingType(Dynamic<NSWindow.SharingType>)
		case styleMask(Dynamic<NSWindow.StyleMask>)
		case title(Dynamic<String>)
		case titlebarAppearsTransparent(Dynamic<Bool>)
		case titleVisibility(Dynamic<NSWindow.TitleVisibility>)
		case toolbar(Dynamic<ToolbarConvertible>)

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
		case effectiveAppearanceName(SignalInput<NSAppearance.Name>)
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
		var initialFirstResponder: Int? = nil
		
		var contentWidth = InitialSubsequent<WindowDimension>()
		var contentHeight = InitialSubsequent<WindowDimension>()
		var windowSizeRelativity = InitialSubsequent<WindowDimension.Relativity>()
		var screen = InitialSubsequent<NSScreen?>()
		var styleMask = InitialSubsequent<NSWindow.StyleMask>()
		var backingType = InitialSubsequent<NSWindow.BackingStoreType>()
		
		var contentView: Dynamic<ViewConvertible>? = nil
		var frameAutosaveName: Dynamic<String>? = nil
		var frameHorizontal: Dynamic<WindowDimension>? = nil
		var frameVertical: Dynamic<WindowDimension>? = nil
		var key: Dynamic<Bool>? = nil
		var main: Dynamic<Bool>? = nil
		var order: Dynamic<WindowOrder>? = nil
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Window.Preparer {
	func constructInstance(type: NSWindow.Type, parameters: Void) -> NSWindow {
		let width = contentWidth.initial ?? WindowDimension(constant: WindowDimension.fallbackWindowSize)
		let height = contentHeight.initial ?? WindowDimension(constant: WindowDimension.fallbackWindowSize)
		let relativity = windowSizeRelativity.initial ?? .independent
		let screen = self.screen.initial ?? NSScreen.screens.first
		let styleMask = self.styleMask.initial ?? [.titled, .resizable, .closable, .miniaturizable]
		let backingType = self.backingType.initial ?? .buffered
		
		// Apply the ContentSize binding
		let contentSize = WindowDimension.contentSize(width: width, height: height, relativity: relativity, onScreen: screen, windowClass: type, styleMask: styleMask)
		
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
		case .contentView(let x): contentView = x
		case .deferCreation(let x): deferCreation = x.value
		case .frameAutosaveName(let x): frameAutosaveName = x
		case .frameHorizontal(let x): frameHorizontal = x
		case .frameVertical(let x): frameVertical = x
		case .key(let x): key = x
		case .initialFirstResponderTag(let x): initialFirstResponder = x.value
		case .main(let x): main = x
		case .order(let x): order = x
		case .screen(let x): screen = x.initialSubsequent()
		case .shouldClose(let x): delegate().addSingleHandler1(x, #selector(NSWindowDelegate.windowShouldClose(_:)))
		case .shouldPopUpDocumentPathMenu(let x): delegate().addSingleHandler2(x, #selector(NSWindowDelegate.window(_:shouldPopUpDocumentPathMenu:)))
		case .shouldZoom(let x): delegate().addSingleHandler2(x, #selector(NSWindowDelegate.windowShouldZoom(_:toFrame:)))
		case .styleMask(let x): styleMask = x.initialSubsequent()
		case .willResize(let x): delegate().addSingleHandler2(x, #selector(NSWindowDelegate.windowWillResize(_:to:)))
		case .willResizeForVersionBrowser(let x): delegate().addSingleHandler3(x, #selector(NSWindowDelegate.window(_:willResizeForVersionBrowserWithMaxPreferredSize:maxAllowedSize:)))
		case .willUseFullScreenContentSize(let x): delegate().addSingleHandler2(x, #selector(NSWindowDelegate.window(_:willUseFullScreenContentSize:)))
		case .willUseFullScreenPresentationOptions(let x): delegate().addSingleHandler2(x, #selector(NSWindowDelegate.window(_:willUseFullScreenPresentationOptions:)))
		case .willUseStandardFrame(let x): delegate().addSingleHandler2(x, #selector(NSWindowDelegate.windowWillUseStandardFrame(_:defaultFrame:)))
		default: break
		}
	}
	
	func prepareInstance(_ instance: NSWindow, storage: Window.Preparer.Storage) {
		inheritedPrepareInstance(instance, storage: storage)
		
		if let relativity = windowSizeRelativity.initial {
			storage.windowSizeRelativity = relativity
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let s): return inherited.applyBinding(s, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .deferCreation: return nil

		// 1. Value bindings may be applied at construction and may subsequently change.
		case .acceptsMouseMovedEvents(let x): return x.apply(instance) { i, v in i.acceptsMouseMovedEvents = v }
		case .allowsConcurrentViewDrawing(let x): return x.apply(instance) { i, v in i.allowsConcurrentViewDrawing = v }
		case .allowsToolTipsWhenApplicationIsInactive(let x): return x.apply(instance) { i, v in i.allowsToolTipsWhenApplicationIsInactive = v }
		case .alphaValue(let x): return x.apply(instance) { i, v in i.alphaValue = v }
		case .animationBehavior(let x): return x.apply(instance) { i, v in i.animationBehavior = v }
		case .appearance(let x): return x.apply(instance) { i, v in i.appearance = v }
		case .autorecalculatesKeyViewLoop(let x): return x.apply(instance) { i, v in i.autorecalculatesKeyViewLoop = v }
		case .backingType: return backingType.resume()?.apply(instance) { i, v in i.backingType = v }
		case .canBecomeVisibleWithoutLogin(let x): return x.apply(instance) { i, v in i.canBecomeVisibleWithoutLogin = v }
		case .canHide(let x): return x.apply(instance) { i, v in i.canHide = v }
		case .collectionBehavior(let x): return x.apply(instance) { i, v in i.collectionBehavior = v }
		case .colorSpace(let x): return x.apply(instance) { i, v in i.colorSpace = v }
		case .contentAspectRatio(let x): return x.apply(instance) { i, v in i.contentAspectRatio = v }
		case .contentHeight: return contentHeight.resume()?.apply(instance, storage) { i, s, v in
			let widthSize = WindowDimension(ratio: 0, constant: i.contentView!.frame.size.width)
			i.setContentSize(WindowDimension.contentSize(width: widthSize, height: v, relativity: s.windowSizeRelativity, onScreen: i.screen, windowClass: type(of: i), styleMask: i.styleMask))
		}
		case .contentMaxSize(let x): return x.apply(instance) { i, v in i.contentMaxSize = v }
		case .contentMinSize(let x): return x.apply(instance) { i, v in i.contentMinSize = v }
		case .contentRelativity(let x): return x.apply(instance, storage) { i, s, v in
			let widthSize = WindowDimension(ratio: 0, constant: i.contentView!.frame.size.width)
			let heightSize = WindowDimension(ratio: 0, constant: i.contentView!.frame.size.height)
			s.windowSizeRelativity = v
			i.setContentSize(WindowDimension.contentSize(width: widthSize, height: heightSize, relativity: s.windowSizeRelativity, onScreen: i.screen, windowClass: type(of: i), styleMask: i.styleMask))
		}
		case .contentResizeIncrements(let x): return x.apply(instance) { i, v in i.contentResizeIncrements = v }
		case .contentView: return nil
		case .contentWidth: return contentWidth.resume()?.apply(instance, storage) { i, s, v in
			let heightSize = WindowDimension(ratio: 0, constant: i.contentView!.frame.size.height)
			i.setContentSize(WindowDimension.contentSize(width: v, height: heightSize, relativity: s.windowSizeRelativity, onScreen: i.screen, windowClass: type(of: i), styleMask: i.styleMask))
		}
		case .depthLimit(let x): return x.apply(instance) { i, v in v.map { i.depthLimit = $0 } ?? i.setDynamicDepthLimit(true) }
		case .displaysWhenScreenProfileChanges(let x): return x.apply(instance) { i, v in i.displaysWhenScreenProfileChanges = v }
		case .frameAutosaveName: return nil
		case .frameHorizontal: return nil
		case .frameVertical: return nil
		case .hasShadow(let x): return x.apply(instance) { i, v in i.hasShadow = v }
		case .hidesOnDeactivate(let x): return x.apply(instance) { i, v in i.hidesOnDeactivate = v }
		case .ignoresMouseEvents(let x): return x.apply(instance) { i, v in i.ignoresMouseEvents = v }
		case .isDocumentEdited(let x): return x.apply(instance) { i, v in i.isDocumentEdited = v }
		case .isExcludedFromWindowsMenu(let x): return x.apply(instance) { i, v in i.isExcludedFromWindowsMenu = v }
		case .isMovable(let x): return x.apply(instance) { i, v in i.isMovable = v }
		case .isMovableByWindowBackground(let x): return x.apply(instance) { i, v in i.isMovableByWindowBackground = v }
		case .isOpaque(let x): return x.apply(instance) { i, v in i.isOpaque = v }
		case .isRestorable(let x): return x.apply(instance) { i, v in i.isRestorable = v }
		case .initialFirstResponderTag: return nil
		case .key: return nil
		case .level(let x): return x.apply(instance) { i, v in i.level = v }
		case .main: return nil
		case .minFullScreenContentSize(let x): return x.apply(instance) { i, v in i.minFullScreenContentSize = v }
		case .miniwindowImage(let x): return x.apply(instance) { i, v in i.miniwindowImage = v }
		case .miniwindowTitle(let x): return x.apply(instance) { i, v in i.miniwindowTitle = v }
		case .maxFullScreenContentSize(let x): return x.apply(instance) { i, v in i.maxFullScreenContentSize = v }
		case .order: return nil
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
			return screen.apply(instance) { i, v in
				let r = i.constrainFrameRect(i.frame, to:v)
				i.setFrameOrigin(r.origin)
			}
		case .sharingType(let x): return x.apply(instance) { i, v in i.sharingType = v }
		case .styleMask: return styleMask.apply(instance) { i, v in i.styleMask = v }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }
		case .titlebarAppearsTransparent(let x): return x.apply(instance) { i, v in i.titlebarAppearsTransparent = v }
		case .titleVisibility(let x): return x.apply(instance) { i, v in i.titleVisibility = v }
		case .toolbar(let x): return x.apply(instance) { i, v in i.toolbar = v.nsToolbar() }
		
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
		case .effectiveAppearanceName(let x):
			return instance.observe(\.effectiveAppearance, options: [.initial, .new]) { instance, change in
				if let value = change.newValue {
					x.send(value: value.name)
				}
			}
		case .didBecomeKey(let x): return Signal.notifications(name: NSWindow.didBecomeKeyNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didBecomeMain(let x): return Signal.notifications(name: NSWindow.didBecomeMainNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didChangeBackingProperties(let x):
			return Signal.notifications(name: NSWindow.didChangeBackingPropertiesNotification, object: instance).map { n in
				let cs = n.userInfo.flatMap { $0[NSWindow.oldColorSpaceUserInfoKey] as? NSColorSpace }
				let sf = n.userInfo.flatMap { ($0[NSWindow.oldScaleFactorUserInfoKey] as? NSNumber).map { CGFloat($0.doubleValue) } }
				return (oldColorSpace: cs, oldScaleFactor: sf )
			}.cancellableBind(to: x)
		case .didChangeOcclusionState(let x): return Signal.notifications(name: NSWindow.didChangeOcclusionStateNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didChangeScreen(let x): return Signal.notifications(name: NSWindow.didChangeScreenNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didChangeScreenProfile(let x): return Signal.notifications(name: NSWindow.didChangeScreenProfileNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didDeminiaturize(let x): return Signal.notifications(name: NSWindow.didDeminiaturizeNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didEndLiveResize(let x): return Signal.notifications(name: NSWindow.didEndLiveResizeNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didEndSheet(let x): return Signal.notifications(name: NSWindow.didEndSheetNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didEnterFullScreen(let x): return Signal.notifications(name: NSWindow.didEnterFullScreenNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didEnterVersionBrowser(let x): return Signal.notifications(name: NSWindow.didEnterVersionBrowserNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didExitFullScreen(let x): return Signal.notifications(name: NSWindow.didExitFullScreenNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didExitVersionBrowser(let x): return Signal.notifications(name: NSWindow.didExitVersionBrowserNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didExpose(let x): return Signal.notifications(name: NSWindow.didExposeNotification, object: instance).compactMap { (n: Notification) -> NSRect? in return (n.userInfo?["NSExposedRect"] as? NSValue)?.rectValue ?? nil }.cancellableBind(to: x)
		case .didMiniaturize(let x): return Signal.notifications(name: NSWindow.didMiniaturizeNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didMove(let x): return Signal.notifications(name: NSWindow.didMoveNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didResignKey(let x): return Signal.notifications(name: NSWindow.didResignKeyNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didResignMain(let x): return Signal.notifications(name: NSWindow.didResignMainNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didResize(let x): return Signal.notifications(name: NSWindow.didResizeNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .didUpdate(let x): return Signal.notifications(name: NSWindow.didUpdateNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willBeginSheet(let x): return Signal.notifications(name: NSWindow.willBeginSheetNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willClose(let x): return Signal.notifications(name: NSWindow.willCloseNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willEnterFullScreen(let x): return Signal.notifications(name: NSWindow.willEnterFullScreenNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willEnterVersionBrowser(let x): return Signal.notifications(name: NSWindow.willEnterVersionBrowserNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willExitFullScreen(let x): return Signal.notifications(name: NSWindow.willExitFullScreenNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willExitVersionBrowser(let x): return Signal.notifications(name: NSWindow.willExitVersionBrowserNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willMiniaturize(let x): return Signal.notifications(name: NSWindow.willMiniaturizeNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willMove(let x): return Signal.notifications(name: NSWindow.willMoveNotification, object: instance).map { n in () }.cancellableBind(to: x)
		case .willStartLiveResize(let x): return Signal.notifications(name: NSWindow.willStartLiveResizeNotification, object: instance).map { n in () }.cancellableBind(to: x)

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
		
		// Apply the autosave size
		let originalFrame = instance.frame
		lifetimes += frameAutosaveName?.apply(instance) { i, v in
			i.setFrameAutosaveName(v)
		}
		
		// The window's content size is now correct, so we can add and layout content.
		// NOTE: this must be done *after* the content size is established, otherwise some container-dependent layout will be done incorrectly.
		lifetimes += contentView?.apply(instance) { i, v in
			i.contentView = v.nsView()
		}
		instance.layoutIfNeeded()
		if let initialFirstResponder = initialFirstResponder {
			instance.initialFirstResponder = instance.contentView?.viewWithTag(initialFirstResponder)
		}
		
		// With content laid out, we can place the frame. NOTE: if autolayout has already placed the frame, respect that placement.
		var skipInitialPlacementIfAutosavePlacementOccurred = instance.frame != originalFrame
		lifetimes += frameHorizontal?.apply(instance) { i, v in
			if !skipInitialPlacementIfAutosavePlacementOccurred {
				i.setFrameOrigin(v.applyFrameHorizontal(i.screen, frameRect: i.frame))
			}
		}
		lifetimes += frameVertical?.apply(instance) { i, v in
			if !skipInitialPlacementIfAutosavePlacementOccurred {
				i.setFrameOrigin(v.applyFrameVertical(i.screen, frameRect: i.frame))
			}
		}
		skipInitialPlacementIfAutosavePlacementOccurred = false
		
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
		
		lifetimes += inheritedFinalizedInstance(instance, storage: storage)
		
		return lifetimes.isEmpty ? nil : AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Window.Preparer {
	open class Storage: View.Preparer.Storage, NSWindowDelegate {
		var windowSizeRelativity: WindowDimension.Relativity = .independent
		@objc func didPresentError(recovered: Bool, contextInfo: UnsafeMutableRawPointer?) {
			if let ptr = contextInfo {
				Unmanaged<SignalInput<Bool>>.fromOpaque(ptr).takeRetainedValue().send(value: recovered)
			}
		}
	}

	open class Delegate: DynamicDelegate, NSWindowDelegate {
		open func windowWillResize(_ window: NSWindow, to toSize: NSSize) -> NSSize {
			return singleHandler(window, toSize)
		}
		
		open func windowWillUseStandardFrame(_ window: NSWindow, defaultFrame: NSRect) -> NSRect {
			return singleHandler(window, defaultFrame)
		}
		
		open func windowShouldZoom(_ window: NSWindow, toFrame: NSRect) -> Bool {
			return singleHandler(window, toFrame)
		}
		
		open func window(_ window: NSWindow, willUseFullScreenContentSize param: NSSize) -> NSSize {
			return singleHandler(window, param)
		}
		
		open func window(_ window: NSWindow, willUseFullScreenPresentationOptions param: NSApplication.PresentationOptions) -> NSApplication.PresentationOptions {
			return singleHandler(window, param)
		}
		
		open func windowShouldClose(_ window: NSWindow) -> Bool {
			return singleHandler(window)
		}
		
		open func window(_ window: NSWindow, shouldPopUpDocumentPathMenu param: NSMenu) -> Bool {
			return singleHandler(window, param)
		}
		
		open func window(_ window: NSWindow, willResizeForVersionBrowserWithMaxPreferredSize: NSSize, maxAllowedSize: NSSize) -> NSSize {
			return singleHandler(window, willResizeForVersionBrowserWithMaxPreferredSize, maxAllowedSize)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: WindowBinding {
	public typealias WindowName<V> = BindingName<V, Window.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> Window.Binding) -> WindowName<V> {
		return WindowName<V>(source: source, downcast: Binding.windowBinding)
	}
}
public extension BindingName where Binding: WindowBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: WindowName<$2> { return .name(Window.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Static styles are applied at construction and are subsequently immutable.
	static var deferCreation: WindowName<Constant<Bool>> { return .name(Window.Binding.deferCreation) }
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var acceptsMouseMovedEvents: WindowName<Dynamic<Bool>> { return .name(Window.Binding.acceptsMouseMovedEvents) }
	static var allowsConcurrentViewDrawing: WindowName<Dynamic<Bool>> { return .name(Window.Binding.allowsConcurrentViewDrawing) }
	static var allowsToolTipsWhenApplicationIsInactive: WindowName<Dynamic<Bool>> { return .name(Window.Binding.allowsToolTipsWhenApplicationIsInactive) }
	static var alphaValue: WindowName<Dynamic<CGFloat>> { return .name(Window.Binding.alphaValue) }
	static var animationBehavior: WindowName<Dynamic<NSWindow.AnimationBehavior>> { return .name(Window.Binding.animationBehavior) }
	static var appearance: WindowName<Dynamic<NSAppearance?>> { return .name(Window.Binding.appearance) }
	static var autorecalculatesKeyViewLoop: WindowName<Dynamic<Bool>> { return .name(Window.Binding.autorecalculatesKeyViewLoop) }
	static var backingType: WindowName<Dynamic<NSWindow.BackingStoreType>> { return .name(Window.Binding.backingType) }
	static var canBecomeVisibleWithoutLogin: WindowName<Dynamic<Bool>> { return .name(Window.Binding.canBecomeVisibleWithoutLogin) }
	static var canHide: WindowName<Dynamic<Bool>> { return .name(Window.Binding.canHide) }
	static var collectionBehavior: WindowName<Dynamic<NSWindow.CollectionBehavior>> { return .name(Window.Binding.collectionBehavior) }
	static var colorSpace: WindowName<Dynamic<NSColorSpace>> { return .name(Window.Binding.colorSpace) }
	static var contentAspectRatio: WindowName<Dynamic<NSSize>> { return .name(Window.Binding.contentAspectRatio) }
	static var contentHeight: WindowName<Dynamic<WindowDimension>> { return .name(Window.Binding.contentHeight) }
	static var contentMaxSize: WindowName<Dynamic<NSSize>> { return .name(Window.Binding.contentMaxSize) }
	static var contentMinSize: WindowName<Dynamic<NSSize>> { return .name(Window.Binding.contentMinSize) }
	static var contentResizeIncrements: WindowName<Dynamic<NSSize>> { return .name(Window.Binding.contentResizeIncrements) }
	static var contentRelativity: WindowName<Dynamic<WindowDimension.Relativity>> { return .name(Window.Binding.contentRelativity) }
	static var contentView: WindowName<Dynamic<ViewConvertible>> { return .name(Window.Binding.contentView) }
	static var contentWidth: WindowName<Dynamic<WindowDimension>> { return .name(Window.Binding.contentWidth) }
	static var depthLimit: WindowName<Dynamic<NSWindow.Depth?>> { return .name(Window.Binding.depthLimit) }
	static var displaysWhenScreenProfileChanges: WindowName<Dynamic<Bool>> { return .name(Window.Binding.displaysWhenScreenProfileChanges) }
	static var frameAutosaveName: WindowName<Dynamic<NSWindow.FrameAutosaveName>> { return .name(Window.Binding.frameAutosaveName) }
	static var frameHorizontal: WindowName<Dynamic<WindowDimension>> { return .name(Window.Binding.frameHorizontal) }
	static var frameVertical: WindowName<Dynamic<WindowDimension>> { return .name(Window.Binding.frameVertical) }
	static var hasShadow: WindowName<Dynamic<Bool>> { return .name(Window.Binding.hasShadow) }
	static var hidesOnDeactivate: WindowName<Dynamic<Bool>> { return .name(Window.Binding.hidesOnDeactivate) }
	static var ignoresMouseEvents: WindowName<Dynamic<Bool>> { return .name(Window.Binding.ignoresMouseEvents) }
	static var isDocumentEdited: WindowName<Dynamic<Bool>> { return .name(Window.Binding.isDocumentEdited) }
	static var isExcludedFromWindowsMenu: WindowName<Dynamic<Bool>> { return .name(Window.Binding.isExcludedFromWindowsMenu) }
	static var isMovable: WindowName<Dynamic<Bool>> { return .name(Window.Binding.isMovable) }
	static var isMovableByWindowBackground: WindowName<Dynamic<Bool>> { return .name(Window.Binding.isMovableByWindowBackground) }
	static var isOpaque: WindowName<Dynamic<Bool>> { return .name(Window.Binding.isOpaque) }
	static var isRestorable: WindowName<Dynamic<Bool>> { return .name(Window.Binding.isRestorable) }
	static var key: WindowName<Dynamic<Bool>> { return .name(Window.Binding.key) }
	static var level: WindowName<Dynamic<NSWindow.Level>> { return .name(Window.Binding.level) }
	static var main: WindowName<Dynamic<Bool>> { return .name(Window.Binding.main) }
	static var maxFullScreenContentSize: WindowName<Dynamic<NSSize>> { return .name(Window.Binding.maxFullScreenContentSize) }
	static var minFullScreenContentSize: WindowName<Dynamic<NSSize>> { return .name(Window.Binding.minFullScreenContentSize) }
	static var miniwindowImage: WindowName<Dynamic<NSImage?>> { return .name(Window.Binding.miniwindowImage) }
	static var miniwindowTitle: WindowName<Dynamic<String>> { return .name(Window.Binding.miniwindowTitle) }
	static var order: WindowName<Dynamic<WindowOrder>> { return .name(Window.Binding.order) }
	static var preservesContentDuringLiveResize: WindowName<Dynamic<Bool>> { return .name(Window.Binding.preservesContentDuringLiveResize) }
	static var preventsApplicationTerminationWhenModal: WindowName<Dynamic<Bool>> { return .name(Window.Binding.preventsApplicationTerminationWhenModal) }
	static var representedURL: WindowName<Dynamic<URL?>> { return .name(Window.Binding.representedURL) }
	static var resizeStyle: WindowName<Dynamic<WindowResizeStyle>> { return .name(Window.Binding.resizeStyle) }
	static var restorationClass: WindowName<Dynamic<NSWindowRestoration.Type>> { return .name(Window.Binding.restorationClass) }
	static var screen: WindowName<Dynamic<NSScreen?>> { return .name(Window.Binding.screen) }
	static var sharingType: WindowName<Dynamic<NSWindow.SharingType>> { return .name(Window.Binding.sharingType) }
	static var styleMask: WindowName<Dynamic<NSWindow.StyleMask>> { return .name(Window.Binding.styleMask) }
	static var title: WindowName<Dynamic<String>> { return .name(Window.Binding.title) }
	static var titlebarAppearsTransparent: WindowName<Dynamic<Bool>> { return .name(Window.Binding.titlebarAppearsTransparent) }
	static var titleVisibility: WindowName<Dynamic<NSWindow.TitleVisibility>> { return .name(Window.Binding.titleVisibility) }
	static var toolbar: WindowName<Dynamic<ToolbarConvertible>> { return .name(Window.Binding.toolbar) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var close: WindowName<Signal<WindowCloseBehavior>> { return .name(Window.Binding.close) }
	static var criticalSheet: WindowName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>> { return .name(Window.Binding.criticalSheet) }
	static var deminiaturize: WindowName<Signal<Void>> { return .name(Window.Binding.deminiaturize) }
	static var display: WindowName<Signal<Bool>> { return .name(Window.Binding.display) }
	static var invalidateShadow: WindowName<Signal<Void>> { return .name(Window.Binding.invalidateShadow) }
	static var miniaturize: WindowName<Signal<Bool>> { return .name(Window.Binding.miniaturize) }
	static var presentError: WindowName<Signal<Callback<Error, Bool>>> { return .name(Window.Binding.presentError) }
	static var printWindow: WindowName<Signal<Void>> { return .name(Window.Binding.printWindow) }
	static var recalculateKeyViewLoop: WindowName<Signal<Void>> { return .name(Window.Binding.recalculateKeyViewLoop) }
	static var runToolbarCustomizationPalette: WindowName<Signal<Void>> { return .name(Window.Binding.runToolbarCustomizationPalette) }
	static var selectNextKeyView: WindowName<Signal<Void>> { return .name(Window.Binding.selectNextKeyView) }
	static var selectPreviousKeyView: WindowName<Signal<Void>> { return .name(Window.Binding.selectPreviousKeyView) }
	static var sheet: WindowName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>> { return .name(Window.Binding.sheet) }
	static var toggleFullScreen: WindowName<Signal<Void>> { return .name(Window.Binding.toggleFullScreen) }
	static var toggleToolbarShown: WindowName<Signal<Void>> { return .name(Window.Binding.toggleToolbarShown) }
	static var zoom: WindowName<Signal<Bool>> { return .name(Window.Binding.zoom) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var effectiveAppearanceName: WindowName<SignalInput<NSAppearance.Name>> { return .name(Window.Binding.effectiveAppearanceName) }
	static var didBecomeKey: WindowName<SignalInput<Void>> { return .name(Window.Binding.didBecomeKey) }
	static var didBecomeMain: WindowName<SignalInput<Void>> { return .name(Window.Binding.didBecomeMain) }
	static var didChangeBackingProperties: WindowName<SignalInput<(oldColorSpace: NSColorSpace?, oldScaleFactor: CGFloat?)>> { return .name(Window.Binding.didChangeBackingProperties) }
	static var didChangeOcclusionState: WindowName<SignalInput<Void>> { return .name(Window.Binding.didChangeOcclusionState) }
	static var didChangeScreen: WindowName<SignalInput<Void>> { return .name(Window.Binding.didChangeScreen) }
	static var didChangeScreenProfile: WindowName<SignalInput<Void>> { return .name(Window.Binding.didChangeScreenProfile) }
	static var didDeminiaturize: WindowName<SignalInput<Void>> { return .name(Window.Binding.didDeminiaturize) }
	static var didEndLiveResize: WindowName<SignalInput<Void>> { return .name(Window.Binding.didEndLiveResize) }
	static var didEndSheet: WindowName<SignalInput<Void>> { return .name(Window.Binding.didEndSheet) }
	static var didEnterFullScreen: WindowName<SignalInput<Void>> { return .name(Window.Binding.didEnterFullScreen) }
	static var didEnterVersionBrowser: WindowName<SignalInput<Void>> { return .name(Window.Binding.didEnterVersionBrowser) }
	static var didExitFullScreen: WindowName<SignalInput<Void>> { return .name(Window.Binding.didExitFullScreen) }
	static var didExitVersionBrowser: WindowName<SignalInput<Void>> { return .name(Window.Binding.didExitVersionBrowser) }
	static var didExpose: WindowName<SignalInput<NSRect>> { return .name(Window.Binding.didExpose) }
	static var didMiniaturize: WindowName<SignalInput<Void>> { return .name(Window.Binding.didMiniaturize) }
	static var didMove: WindowName<SignalInput<Void>> { return .name(Window.Binding.didMove) }
	static var didResignKey: WindowName<SignalInput<Void>> { return .name(Window.Binding.didResignKey) }
	static var didResignMain: WindowName<SignalInput<Void>> { return .name(Window.Binding.didResignMain) }
	static var didResize: WindowName<SignalInput<Void>> { return .name(Window.Binding.didResize) }
	static var didUpdate: WindowName<SignalInput<Void>> { return .name(Window.Binding.didUpdate) }
	static var willBeginSheet: WindowName<SignalInput<Void>> { return .name(Window.Binding.willBeginSheet) }
	static var willClose: WindowName<SignalInput<Void>> { return .name(Window.Binding.willClose) }
	static var willEnterFullScreen: WindowName<SignalInput<Void>> { return .name(Window.Binding.willEnterFullScreen) }
	static var willEnterVersionBrowser: WindowName<SignalInput<Void>> { return .name(Window.Binding.willEnterVersionBrowser) }
	static var willExitFullScreen: WindowName<SignalInput<Void>> { return .name(Window.Binding.willExitFullScreen) }
	static var willExitVersionBrowser: WindowName<SignalInput<Void>> { return .name(Window.Binding.willExitVersionBrowser) }
	static var willMiniaturize: WindowName<SignalInput<Void>> { return .name(Window.Binding.willMiniaturize) }
	static var willMove: WindowName<SignalInput<Void>> { return .name(Window.Binding.willMove) }
	static var willStartLiveResize: WindowName<SignalInput<Void>> { return .name(Window.Binding.willStartLiveResize) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var shouldClose: WindowName<(NSWindow) -> Bool> { return .name(Window.Binding.shouldClose) }
	static var shouldPopUpDocumentPathMenu: WindowName<(NSWindow, NSMenu) -> Bool> { return .name(Window.Binding.shouldPopUpDocumentPathMenu) }
	static var shouldZoom: WindowName<(NSWindow, NSRect) -> Bool> { return .name(Window.Binding.shouldZoom) }
	static var willResize: WindowName<(NSWindow, NSSize) -> NSSize> { return .name(Window.Binding.willResize) }
	static var willResizeForVersionBrowser: WindowName<(_ window: NSWindow, _ maxPreferredSize: NSSize, _ maxAllowedSize: NSSize) -> NSSize> { return .name(Window.Binding.willResizeForVersionBrowser) }
	static var willUseFullScreenContentSize: WindowName<(NSWindow, NSSize) -> NSSize> { return .name(Window.Binding.willUseFullScreenContentSize) }
	static var willUseFullScreenPresentationOptions: WindowName<(NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions> { return .name(Window.Binding.willUseFullScreenPresentationOptions) }
	static var willUseStandardFrame: WindowName<(NSWindow, NSRect) -> NSRect> { return .name(Window.Binding.willUseStandardFrame) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol WindowConvertible {
	func nsWindow() -> Window.Instance
}
extension NSWindow: WindowConvertible, DefaultConstructable, HasDelegate {
	public func nsWindow() -> Window.Instance { return self }
}
public extension Window {
	func nsWindow() -> Window.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol WindowBinding: BinderBaseBinding {
	static func windowBinding(_ binding: Window.Binding) -> Self
	func asWindowBinding() -> Window.Binding?
}
public extension WindowBinding {
	static func binderBaseBinding(_ binding: BinderBase.Binding) -> Self {
		return windowBinding(.inheritedBinding(binding))
	}
}
public extension WindowBinding where Preparer.Inherited.Binding: WindowBinding {
	func asWindowBinding() -> Window.Binding? {
		return asInheritedBinding()?.asWindowBinding()
	}
}
public extension Window.Binding {
	typealias Preparer = Window.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asWindowBinding() -> Window.Binding? { return self }
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

public struct WindowDimension: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Double
	public typealias IntegerLiteralType = Int

	public enum Relativity {
		case independent
		case widthRelativeToHeight
		case heightRelativeToWidth
	}
	
	public let ratio: CGFloat
	public let constant: CGFloat
	
	public init(integerLiteral value: Int) {
		self.init(constant: CGFloat(value))
	}

	public init(floatLiteral value: Double) {
		self.ratio = 0
		self.constant = CGFloat(value)
	}
	
	public init(ratio: CGFloat = 0, constant: CGFloat = 0) {
		self.ratio = ratio
		self.constant = constant
	}
	
	public static func ratio(_ ratio: CGFloat = 0, constant: CGFloat = 0) -> WindowDimension {
		return WindowDimension(ratio: ratio, constant: constant)
	}
	
	public static let fallbackWindowSize: CGFloat = 400
	
	public static func contentSize<W: NSWindow>(width widthSize: WindowDimension, height heightSize: WindowDimension, relativity: Relativity, onScreen: NSScreen?, windowClass: W.Type, styleMask: NSWindow.StyleMask) -> NSSize {
		let width: CGFloat
		let height: CGFloat
		switch relativity {
		case .widthRelativeToHeight:
			if heightSize.ratio != 0, let s = onScreen {
				let screenFrame = windowClass.contentRect(forFrameRect: s.visibleFrame, styleMask: styleMask)
				height = heightSize.ratio * screenFrame.height + heightSize.constant
			} else {
				height = heightSize.constant
			}
			width = widthSize.ratio * height + widthSize.constant
		case .heightRelativeToWidth:
			if widthSize.ratio != 0, let s = onScreen {
				let screenFrame = windowClass.contentRect(forFrameRect: s.visibleFrame, styleMask: styleMask)
				width = widthSize.ratio * screenFrame.height + widthSize.constant
			} else {
				width = widthSize.constant
			}
			height = heightSize.ratio * width + heightSize.constant
		case .independent:
			if (widthSize.ratio != 0 || heightSize.ratio != 0), let s = onScreen {
				let screenFrame = windowClass.contentRect(forFrameRect: s.visibleFrame, styleMask: styleMask)
				width = widthSize.ratio * screenFrame.height + widthSize.constant
				height = heightSize.ratio * screenFrame.height + heightSize.constant
			} else {
				width = widthSize.constant
				height = heightSize.constant
			}
		}
		return NSSize(width: width, height: height)
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

extension NSWindow: Lifetime {
	public static var titleBarHeight: CGFloat {
		return NSWindow.frameRect(forContentRect: .zero, styleMask: [.titled]).height
	}
	
	public static var integratedToolbarHeight: CGFloat {
		return 24 + 8 + 8 // is there a smarter way to calculate this?
	}
	
	public func cancel() {
		return nsWindow().close()
	}
}

#endif
