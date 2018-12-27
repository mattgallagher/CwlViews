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

public class Window: Binder, WindowConvertible {
	public typealias Instance = NSWindow
	public typealias Inherited = BaseBinder
	
	public var state: BinderState<Instance, Binding>
	public required init(state: BinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsWindow() -> Instance { return instance() }
	
	enum Binding: WindowBinding {
		public typealias EnclosingBinder = Window
		public typealias Inherited = BaseBinder.Binding
		public static func windowBinding(_ binding: Window.Binding) -> Window.Binding { return binding }
		case inheritedBinding(Inherited)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Static styles are applied at construction and are subsequently immutable.
		case contentView(Constant<View>)
		case deferCreation(Constant<Bool>)

		// 1. Value bindings may be applied at construction and may subsequently change.
		case acceptsMouseMovedEvents(Dynamic<Bool>)
		case allowsConcurrentViewDrawing(Dynamic<Bool>)
		case allowsToolTipsWhenApplicationIsInactive(Dynamic<Bool>)
		case alphaValue(Dynamic<CGFloat>)
		case animationBehavior(Dynamic<NSWindow.AnimationBehavior>)
		case isAutodisplay(Dynamic<Bool>)
		case autorecalculatesKeyViewLoop(Dynamic<Bool>)
		case backingType(Dynamic<NSWindow.BackingStoreType>)
		case canBecomeVisibleWithoutLogin(Dynamic<Bool>)
		case canHide(Dynamic<Bool>)
		case collectionBehavior(Dynamic<NSWindow.CollectionBehavior>)
		case colorSpace(Dynamic<NSColorSpace>)
		case contentMinSize(Dynamic<NSSize>)
		case contentMaxSize(Dynamic<NSSize>)
		@available(macOS 10.11, *)
		case minFullScreenContentSize(Dynamic<NSSize>)
		@available(macOS 10.11, *)
		case maxFullScreenContentSize(Dynamic<NSSize>)
		case contentAspectRatio(Dynamic<NSSize>)
		case contentResizeIncrements(Dynamic<NSSize>)
		case contentWidth(Dynamic<WindowSize>)
		case contentHeight(Dynamic<WindowSize>)
		case depthLimit(Dynamic<NSWindow.Depth?>)
		case displaysWhenScreenProfileChanges(Dynamic<Bool>)
		case isDocumentEdited(Dynamic<Bool>)
		case isExcludedFromWindowsMenu(Dynamic<Bool>)
		case frameAutosaveName(Dynamic<NSWindow.FrameAutosaveName>)
		case frameHorizontal(Dynamic<WindowPlacement>)
		case frameVertical(Dynamic<WindowPlacement>)
		case hasShadow(Dynamic<Bool>)
		case hidesOnDeactivate(Dynamic<Bool>)
		case ignoresMouseEvents(Dynamic<Bool>)
		case key(Dynamic<Bool>)
		case level(Dynamic<NSWindow.Level>)
		case main(Dynamic<Bool>)
		case miniwindowImage(Dynamic<NSImage?>)
		case miniwindowTitle(Dynamic<String>)
		case isMovable(Dynamic<Bool>)
		case isMovableByWindowBackground(Dynamic<Bool>)
		case isOneShot(Dynamic<Bool>)
		case isOpaque(Dynamic<Bool>)
		case order(Dynamic<WindowOrder>)
		case preferredBackingLocation(Dynamic<NSWindow.BackingLocation>)
		case preservesContentDuringLiveResize(Dynamic<Bool>)
		case preventsApplicationTerminationWhenModal(Dynamic<Bool>)
		case representedURL(Dynamic<URL?>)
		case resizeStyle(Dynamic<WindowResizeStyle>)
		case isRestorable(Dynamic<Bool>)
		case restorationClass(Dynamic<NSWindowRestoration.Type>)
		case screen(Dynamic<NSScreen?>)
		case sharingType(Dynamic<NSWindow.SharingType>)
		case styleMask(Dynamic<NSWindow.StyleMask>)
		case title(Dynamic<String>)
		case toolbar(Dynamic<ToolbarConvertible>)

		// 2. Signal bindings are performed on the object after construction.
		case close(Signal<WindowCloseBehavior>)
		case deminiaturize(Signal<Void>)
		case display(Signal<Bool>)
		case invalidateShadow(Signal<Void>)
		case miniaturize(Signal<Bool>)
		case printWindow(Signal<Void>)
		case recalculateKeyViewLoop(Signal<Void>)
		case runToolbarCustomizationPalette(Signal<Void>)
		case selectNextKeyView(Signal<Void>)
		case selectPreviousKeyView(Signal<Void>)
		case toggleFullScreen(Signal<Void>)
		case toggleToolbarShown(Signal<Void>)
		case zoom(Signal<Bool>)
		case sheet(Signal<Callback<NSWindow, NSApplication.ModalResponse>>)
		case criticalSheet(Signal<Callback<NSWindow, NSApplication.ModalResponse>>)
		case presentError(Signal<Callback<Error, Bool>>)
		
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

	struct Preparer: BinderEmbedderConstructor {
		public typealias EnclosingBinder = Window
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance {
			let width = contentWidthInitial ?? WindowSize(constant: Preparer.defaultWindowSize.width)
			let height = contentHeightInitial ?? WindowSize(constant: Preparer.defaultWindowSize.height)
			let screen = screenInitial ?? NSScreen.screens.first
			let styleMask = styleMaskInitial ?? [.titled, .resizable, .closable, .miniaturizable]
			let backingType = backingTypeInitial ?? .buffered
			
			// Apply the ContentSize binding
			var contentSize = width.applyWidthToContentSize(NSZeroSize, onScreen: screen, windowClass: subclass, styleMask: styleMask)
			contentSize = height.applyHeightToContentSize(contentSize, onScreen: screen, windowClass: subclass, styleMask: styleMask)
			
			var frameRect = subclass.frameRect(forContentRect: NSRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height), styleMask: styleMask)
			frameRect.origin.y = screen.map { $0.visibleFrame.origin.y + $0.visibleFrame.size.height - frameRect.size.height } ?? 0
			
			let cr = subclass.contentRect(forFrameRect: frameRect, styleMask: styleMask)
			
			// Create the window
			let w = subclass.init(contentRect: cr, styleMask: styleMask, backing: backingType, defer: deferCreation, screen: screen)
			w.isReleasedWhenClosed = false
			
			// To be consistent with setting ".Screen", constrain the window to the screen.
			if let scr = screen {
				let r = w.constrainFrameRect(w.frame, to:scr)
				w.setFrameOrigin(r.origin)
			}
			return w
		}
		
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
		
		// InitialSubsequent styles and other special handling
		var deferCreation = true

		var key: Dynamic<Bool>? = nil
		var main: Dynamic<Bool>? = nil
		var order: Dynamic<WindowOrder>? = nil

		var frameAutosaveName: Dynamic<String>? = nil
		var backingType = InitialSubsequent<NSWindow.BackingStoreType>()
		var backingTypeInitial: NSWindow.BackingStoreType? = nil
		var screen = InitialSubsequent<NSScreen?>()
		var screenInitial: NSScreen?? = nil
		var frameHorizontal: Dynamic<WindowPlacement>? = nil
		var frameVertical: Dynamic<WindowPlacement>? = nil
		var contentWidth = InitialSubsequent<WindowSize>()
		var contentWidthInitial: WindowSize? = nil
		var contentHeight = InitialSubsequent<WindowSize>()
		var contentHeightInitial: WindowSize? = nil
		var styleMask = InitialSubsequent<NSWindow.StyleMask>()
		var styleMaskInitial: NSWindow.StyleMask? = nil
		
		public static var defaultWindowSize: NSSize { return NSSize(width: 400, height: 400) }

		mutating func prepareBinding(_ binding: Binding) {
			switch binding {
			case .deferCreation(let x): deferCreation = x.value
			case .backingType(let x):
				backingType = x.initialSubsequent()
				backingTypeInitial = backingType.initial()
			case .key(let x): key = x
			case .order(let x): order = x
			case .main(let x): main = x
			case .frameAutosaveName(let x): frameAutosaveName = x
			case .frameHorizontal(let x): frameHorizontal = x
			case .frameVertical(let x): frameVertical = x
			case .contentWidth(let x):
				contentWidth = x.initialSubsequent()
				contentWidthInitial = contentWidth.initial()
			case .contentHeight(let x):
				contentHeight = x.initialSubsequent()
				contentHeightInitial = contentHeight.initial()
			case .screen(let x):
				screen = x.initialSubsequent()
				screenInitial = screen.initial()
			case .styleMask(let x):
				styleMask = x.initialSubsequent()
				styleMaskInitial = styleMask.initial()
			case .willResize(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowWillResize(_:to:)))
			case .willUseStandardFrame(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowWillUseStandardFrame(_:defaultFrame:)))
			case .shouldZoom(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowShouldZoom(_:toFrame:)))
			case .willUseFullScreenContentSize(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:willUseFullScreenContentSize:)))
			case .willUseFullScreenPresentationOptions(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:willUseFullScreenPresentationOptions:)))
			case .shouldClose(let x): delegate().addHandler(x, #selector(NSWindowDelegate.windowShouldClose(_:)))
			case .shouldPopUpDocumentPathMenu(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:shouldPopUpDocumentPathMenu:)))
			case .willResizeForVersionBrowser(let x): delegate().addHandler(x, #selector(NSWindowDelegate.window(_:willResizeForVersionBrowserWithMaxPreferredSize:maxAllowedSize:)))
			case .inheritedBinding(let preceeding): inherited.prepareBinding(preceeding)
			default: break
			}
		}

		public func prepareInstance(_ instance: Instance, storage: Storage) {
			precondition(instance.delegate == nil, "Conflicting delegate applied to instance")
			storage.dynamicDelegate = possibleDelegate
			if storage.inUse {
				instance.delegate = storage
			}

			linkedPreparer.prepareInstance(instance, storage: storage)
		}

		func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .contentView(let x):
				if let cv = instance.contentView {
					x.value.applyBindings(to: cv)
				}
				return nil
			case .backingType: return backingType.resume()?.apply(instance) { i, v in i.backingType = v }
			case .frameHorizontal: return nil
			case .frameVertical: return nil
			case .contentWidth: return contentWidth.resume()?.apply(instance) { i, v in i.setContentSize(v.applyWidthToContentSize(i.contentView!.frame.size, onScreen: i.screen, windowClass: type(of: i), styleMask: i.styleMask)) }
			case .contentHeight: return contentHeight.resume()?.apply(instance) { i, v in i.setContentSize(v.applyHeightToContentSize(i.contentView!.frame.size, onScreen: i.screen, windowClass: type(of: i), styleMask: i.styleMask)) }
			case .deferCreation:
				return nil
			case .key: return nil
			case .level(let x): return x.apply(instance) { i, v in i.level = v }
			case .main: return nil
			case .order: return nil
			case .screen:
				return screen.subsequent.flatMap { $0.apply(instance) { i, v in
					let r = i.constrainFrameRect(i.frame, to:v)
					i.setFrameOrigin(r.origin)
				} }
			case .styleMask: return styleMask.subsequent.flatMap { $0.apply(instance) { i, v in i.styleMask = v } }
			case .title(let x): return x.apply(instance) { i, v in i.title = v }
			case .frameAutosaveName: return nil
			case .alphaValue(let x): return x.apply(instance) { i, v in i.alphaValue = v }
			case .colorSpace(let x): return x.apply(instance) { i, v in i.colorSpace = v }
			case .canHide(let x): return x.apply(instance) { i, v in i.canHide = v }
			case .hidesOnDeactivate(let x): return x.apply(instance) { i, v in i.hidesOnDeactivate = v }
			case .collectionBehavior(let x): return x.apply(instance) { i, v in i.collectionBehavior = v }
			case .isOpaque(let x): return x.apply(instance) { i, v in i.isOpaque = v }
				
			case .contentMinSize(let x): return x.apply(instance) { i, v in i.contentMinSize = v }
			case .contentMaxSize(let x): return x.apply(instance) { i, v in i.contentMaxSize = v }
			case .minFullScreenContentSize(let x):
				return x.apply(instance) { i, v in
					if #available(macOS 10.11, *) {
						i.minFullScreenContentSize = v
					}
				}
			case .maxFullScreenContentSize(let x):
				return x.apply(instance) { i, v in
					if #available(macOS 10.11, *) {
						i.maxFullScreenContentSize = v
					}
				}
			case .contentAspectRatio(let x): return x.apply(instance) { i, v in i.contentAspectRatio = v }
			case .contentResizeIncrements(let x): return x.apply(instance) { i, v in i.contentResizeIncrements = v }
				
				
			case .hasShadow(let x): return x.apply(instance) { i, v in i.hasShadow = v }
			case .preventsApplicationTerminationWhenModal(let x): return x.apply(instance) { i, v in i.preventsApplicationTerminationWhenModal = v }
			case .canBecomeVisibleWithoutLogin(let x): return x.apply(instance) { i, v in i.canBecomeVisibleWithoutLogin = v }
			case .sharingType(let x): return x.apply(instance) { i, v in i.sharingType = v }
			case .preferredBackingLocation(let x): return x.apply(instance) { i, v in i.preferredBackingLocation = v }
			case .isOneShot(let x): return x.apply(instance) { i, v in i.isOneShot = v }
			case .depthLimit(let x):
				return x.apply(instance) { i, v in
					if let v = v {
						i.depthLimit = v
					} else {
						i.setDynamicDepthLimit(true)
					}
				}
			case .resizeStyle(let x):
				return x.apply(instance) { i, v in
					switch v {
					case .increment(let s):
						i.resizeIncrements = s
					case .contentAspect(let s):
						i.contentAspectRatio = s
					}
				}
			case .preservesContentDuringLiveResize(let x): return x.apply(instance) { i, v in i.preservesContentDuringLiveResize = v }
			case .isExcludedFromWindowsMenu(let x): return x.apply(instance) { i, v in i.isExcludedFromWindowsMenu = v }
			case .allowsToolTipsWhenApplicationIsInactive(let x): return x.apply(instance) { i, v in i.allowsToolTipsWhenApplicationIsInactive = v }
			case .autorecalculatesKeyViewLoop(let x): return x.apply(instance) { i, v in i.autorecalculatesKeyViewLoop = v }
			case .acceptsMouseMovedEvents(let x): return x.apply(instance) { i, v in i.acceptsMouseMovedEvents = v }
			case .ignoresMouseEvents(let x): return x.apply(instance) { i, v in i.ignoresMouseEvents = v }
			case .isRestorable(let x): return x.apply(instance) { i, v in i.isRestorable = v }
			case .restorationClass(let x):
				return x.apply(instance) { i, v in
					i.restorationClass = v
				}
			case .isAutodisplay(let x): return x.apply(instance) { i, v in i.isAutodisplay = v }
			case .allowsConcurrentViewDrawing(let x): return x.apply(instance) { i, v in i.allowsConcurrentViewDrawing = v }
			case .animationBehavior(let x): return x.apply(instance) { i, v in i.animationBehavior = v }
			case .isDocumentEdited(let x): return x.apply(instance) { i, v in i.isDocumentEdited = v }
			case .representedURL(let x): return x.apply(instance) { i, v in i.representedURL = v }
			case .displaysWhenScreenProfileChanges(let x): return x.apply(instance) { i, v in i.displaysWhenScreenProfileChanges = v }
			case .isMovableByWindowBackground(let x): return x.apply(instance) { i, v in i.isMovableByWindowBackground = v }
			case .isMovable(let x): return x.apply(instance) { i, v in i.isMovable = v }
			case .miniwindowImage(let x): return x.apply(instance) { i, v in i.miniwindowImage = v }
			case .miniwindowTitle(let x): return x.apply(instance) { i, v in i.miniwindowTitle = v }
			case .willResize: return nil
			case .willUseStandardFrame: return nil
			case .shouldZoom: return nil
			case .willUseFullScreenContentSize: return nil
			case .willUseFullScreenPresentationOptions: return nil
			case .shouldClose: return nil
			case .shouldPopUpDocumentPathMenu: return nil
			case .willResizeForVersionBrowser: return nil
			case .sheet(let x):
				return x.apply(instance) { i, v in
					i.beginSheet(v.value) { r in _ = v.callback.send(value: r) }
				}
			case .criticalSheet(let x):
				return x.apply(instance) { i, v in
					i.beginCriticalSheet(v.value) { r in _ = v.callback.send(value: r) }
				}
			case .presentError(let x):
				return x.apply(instance) { i, v in
					let ptr = Unmanaged.passRetained(v.callback).toOpaque()
					let sel = #selector(Window.Storage.didPresentError(recovered:contextInfo:))
					i.presentError(v.value, modalFor: i, delegate: s, didPresent: sel, contextInfo: ptr)
				}
			case .close(let x):
				return x.apply(instance) { i, v in
					switch v {
					case .dismiss:
						if i.isSheet {
							i.sheetParent?.endSheet(i)
						} else if NSApplication.shared.modalWindow == i {
							NSApplication.shared.stopModal()
						} else {
							i.close()
						}
					case .perform:
						if i.isSheet {
							i.sheetParent?.endSheet(i)
						} else if NSApplication.shared.modalWindow == i {
							NSApplication.shared.stopModal()
						} else {
							i.performClose(nil)
						}
					case .stopModal(let c):
						if i.isSheet {
							i.sheetParent?.endSheet(i, returnCode: c)
						} else if NSApplication.shared.modalWindow == i {
							NSApplication.shared.stopModal(withCode: c)
						} else {
							i.close()
						}
					}
				}
			case .zoom(let x):
				return x.apply(instance) { i, v in
					if v {
						i.performZoom(nil)
					} else {
						i.zoom(nil)
					}
				}
			case .toggleFullScreen(let x): return x.apply(instance) { i, v in i.toggleFullScreen(nil) }
			case .toggleToolbarShown(let x): return x.apply(instance) { i, v in i.toggleToolbarShown(nil) }
			case .invalidateShadow(let x): return x.apply(instance) { i, v in i.invalidateShadow() }
			case .runToolbarCustomizationPalette(let x): return x.apply(instance) { i, v in i.runToolbarCustomizationPalette(nil) }
			case .recalculateKeyViewLoop(let x): return x.apply(instance) { i, v in i.recalculateKeyViewLoop() }
			case .display(let x):
				return x.apply(instance) { i, v in
					if v {
						i.displayIfNeeded()
					} else {
						i.display()
					}
				}
			case .miniaturize(let x):
				return x.apply(instance) { i, v in
					if v {
						i.performMiniaturize(nil)
					} else {
						i.miniaturize(nil)
					}
				}
			case .deminiaturize(let x): return x.apply(instance) { i, v in i.deminiaturize(nil) }
			case .printWindow(let x): return x.apply(instance) { i, v in i.printWindow(nil) }
			case .selectNextKeyView(let x): return x.apply(instance) { i, v in i.selectNextKeyView(nil) }
			case .selectPreviousKeyView(let x): return x.apply(instance) { i, v in i.selectPreviousKeyView(nil) }
			case .didBecomeKey(let x):
				return Signal.notifications(name: NSWindow.didBecomeKeyNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didBecomeMain(let x):
				return Signal.notifications(name: NSWindow.didBecomeMainNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didChangeBackingProperties(let x):
				return Signal.notifications(name: NSWindow.didChangeBackingPropertiesNotification, object: instance).map { n in
					let cs = n.userInfo.flatMap { $0[NSWindow.oldColorSpaceUserInfoKey] as? NSColorSpace }
					let sf = n.userInfo.flatMap { ($0[NSWindow.oldScaleFactorUserInfoKey] as? NSNumber).map { CGFloat($0.doubleValue) } }
					return (oldColorSpace: cs, oldScaleFactor: sf )
					}.cancellableBind(to: x)
			case .didChangeOcclusionState(let x):
				return Signal.notifications(name: NSWindow.didChangeOcclusionStateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didChangeScreen(let x):
				return Signal.notifications(name: NSWindow.didChangeScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didChangeScreenProfile(let x):
				return Signal.notifications(name: NSWindow.didChangeScreenProfileNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didDeminiaturize(let x):
				return Signal.notifications(name: NSWindow.didDeminiaturizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didEndSheet(let x):
				return Signal.notifications(name: NSWindow.didEndSheetNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didEndLiveResize(let x):
				return Signal.notifications(name: NSWindow.didEndLiveResizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didExpose(let x):
				return Signal.notifications(name: NSWindow.didExposeNotification, object: instance).compactMap { (n: Notification) -> NSRect? in return (n.userInfo?["NSExposedRect"] as? NSValue)?.rectValue ?? nil }.cancellableBind(to: x)
			case .didEnterFullScreen(let x):
				return Signal.notifications(name: NSWindow.didEnterFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didEnterVersionBrowser(let x):
				return Signal.notifications(name: NSWindow.didEnterVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didExitFullScreen(let x):
				return Signal.notifications(name: NSWindow.didExitFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didExitVersionBrowser(let x):
				return Signal.notifications(name: NSWindow.didExitVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didMiniaturize(let x):
				return Signal.notifications(name: NSWindow.didMiniaturizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didMove(let x):
				return Signal.notifications(name: NSWindow.didMoveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didResignKey(let x):
				return Signal.notifications(name: NSWindow.didResignKeyNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didResignMain(let x):
				return Signal.notifications(name: NSWindow.didResignMainNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didResize(let x):
				return Signal.notifications(name: NSWindow.didResizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .didUpdate(let x):
				return Signal.notifications(name: NSWindow.didUpdateNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willBeginSheet(let x):
				return Signal.notifications(name: NSWindow.willBeginSheetNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willClose(let x):
				return Signal.notifications(name: NSWindow.willCloseNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willMiniaturize(let x):
				return Signal.notifications(name: NSWindow.willMiniaturizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willMove(let x):
				return Signal.notifications(name: NSWindow.willMoveNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willStartLiveResize(let x):
				return Signal.notifications(name: NSWindow.willStartLiveResizeNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willEnterFullScreen(let x):
				return Signal.notifications(name: NSWindow.willEnterFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willExitFullScreen(let x):
				return Signal.notifications(name: NSWindow.willExitFullScreenNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willEnterVersionBrowser(let x):
				return Signal.notifications(name: NSWindow.willEnterVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .willExitVersionBrowser(let x):
				return Signal.notifications(name: NSWindow.willExitVersionBrowserNotification, object: instance).map { n in return () }.cancellableBind(to: x)
			case .toolbar(let x): return x.apply(instance) { i, v in i.toolbar = v.nsToolbar() }
			case .inheritedBinding(let s):
				return inherited.applyBinding(s, instance: instance, storage: storage)
			}
		}

		public func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
			let lifetime = linkedPreparer.finalizeInstance(instance, storage: storage)
			
			// Apply frame placement
			instance.layoutIfNeeded()
			let h = frameHorizontal?.apply(instance) { i, v in i.setFrameOrigin(v.applyFrameHorizontal(i.screen, frameRect: i.frame)) }
			let v = frameVertical?.apply(instance) { i, v in i.setFrameOrigin(v.applyFrameVertical(i.screen, frameRect: i.frame)) }
			let a = frameAutosaveName?.apply(instance) { i, v in i.setFrameAutosaveName(v) }
			
			var captureOrder = order?.initialSubsequent()
			var captureKey = key?.initialSubsequent()
			var captureMain = main?.initialSubsequent()

			// Apply captured variables that need to be applied after all other properties on construction
			switch (captureOrder?.initial() ?? .front) {
			case .front where captureKey?.initial() == true: instance.makeKeyAndOrderFront(nil)
			case .front: fallthrough
			case .back: WindowOrder.back.applyToWindow(instance)
			case .out: break
			}
			if (captureMain?.initial() ?? true) == true {
				instance.makeMain()
			}

			let o = captureOrder?.resume()?.apply(instance) { i, v in v.applyToWindow(i) }
			let k = captureKey?.resume()?.apply(instance) { i, v in
				if v {
					i.makeKey()
				} else {
					i.resignKey()
				}
			}
			let m = captureMain?.resume()?.apply(instance) { i, v in
				if v {
					i.makeMain()
				} else {
					i.resignMain()
				}
			}

			return AggregateLifetime(lifetimes: [lifetime, o, k, m, h, v, a].compactMap { $0 })
		}
	}

	open class Storage: View.Storage, NSWindowDelegate {
		@objc func didPresentError(recovered: Bool, contextInfo: UnsafeMutableRawPointer?) {
			if let ptr = contextInfo {
				Unmanaged<SignalInput<Bool>>.fromOpaque(ptr).takeRetainedValue().send(value: recovered)
			}
		}
	}

	open class Delegate: DynamicDelegate, NSWindowDelegate {
		public required override init() {
			super.init()
		}
		
		open func windowWillResize(_ window: NSWindow, to toSize: NSSize) -> NSSize {
			return handler(ofType: ((NSWindow, NSSize) -> NSSize).self)(window, toSize)
		}
		
		open func windowWillUseStandardFrame(_ window: NSWindow, defaultFrame: NSRect) -> NSRect {
			return handler(ofType: ((NSWindow, NSRect) -> NSRect).self)(window, defaultFrame)
		}
		
		open func windowShouldZoom(_ window: NSWindow, toFrame: NSRect) -> Bool {
			return handler(ofType: ((NSWindow, NSRect) -> Bool).self)(window, toFrame)
		}
		
		open func window(_ window: NSWindow, willUseFullScreenContentSize param: NSSize) -> NSSize {
			return handler(ofType: ((NSWindow, NSSize) -> NSSize).self)(window, param)
		}
		
		open func window(_ window: NSWindow, willUseFullScreenPresentationOptions param: NSApplication.PresentationOptions) -> NSApplication.PresentationOptions {
			return handler(ofType: ((NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions).self)(window, param)
		}
		
		open func windowShouldClose(_ window: NSWindow) -> Bool {
			return handler(ofType: ((NSWindow) -> Bool).self)(window)
		}
		
		open func window(_ window: NSWindow, shouldPopUpDocumentPathMenu param: NSMenu) -> Bool {
			return handler(ofType: ((NSWindow, NSMenu) -> Bool).self)(window, param)
		}
		
		open func window(_ window: NSWindow, willResizeForVersionBrowserWithMaxPreferredSize: NSSize, maxAllowedSize: NSSize) -> NSSize {
			return handler(ofType: ((_ window: NSWindow, _ maxPreferredSize: NSSize, _ maxAllowedSize: NSSize) -> NSSize).self)(window, willResizeForVersionBrowserWithMaxPreferredSize, maxAllowedSize)
		}
	}
}

extension BindingName where Binding: WindowBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .windowBinding(Window.Binding.$1(v)) }) }
	
	//	0. Static styles are applied at construction and are subsequently immutable.
	public static var contentView: BindingName<Constant<View>, Binding> { return BindingName<Constant<View>, Binding>({ v in .windowBinding(Window.Binding.contentView(v)) }) }
	public static var deferCreation: BindingName<Constant<Bool>, Binding> { return BindingName<Constant<Bool>, Binding>({ v in .windowBinding(Window.Binding.deferCreation(v)) }) }

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var acceptsMouseMovedEvents: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.acceptsMouseMovedEvents(v)) }) }
	public static var allowsConcurrentViewDrawing: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.allowsConcurrentViewDrawing(v)) }) }
	public static var allowsToolTipsWhenApplicationIsInactive: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.allowsToolTipsWhenApplicationIsInactive(v)) }) }
	public static var alphaValue: BindingName<Dynamic<CGFloat>, Binding> { return BindingName<Dynamic<CGFloat>, Binding>({ v in .windowBinding(Window.Binding.alphaValue(v)) }) }
	public static var animationBehavior: BindingName<Dynamic<NSWindow.AnimationBehavior>, Binding> { return BindingName<Dynamic<NSWindow.AnimationBehavior>, Binding>({ v in .windowBinding(Window.Binding.animationBehavior(v)) }) }
	public static var isAutodisplay: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isAutodisplay(v)) }) }
	public static var autorecalculatesKeyViewLoop: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.autorecalculatesKeyViewLoop(v)) }) }
	public static var backingType: BindingName<Dynamic<NSWindow.BackingStoreType>, Binding> { return BindingName<Dynamic<NSWindow.BackingStoreType>, Binding>({ v in .windowBinding(Window.Binding.backingType(v)) }) }
	public static var canBecomeVisibleWithoutLogin: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.canBecomeVisibleWithoutLogin(v)) }) }
	public static var canHide: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.canHide(v)) }) }
	public static var collectionBehavior: BindingName<Dynamic<NSWindow.CollectionBehavior>, Binding> { return BindingName<Dynamic<NSWindow.CollectionBehavior>, Binding>({ v in .windowBinding(Window.Binding.collectionBehavior(v)) }) }
	public static var colorSpace: BindingName<Dynamic<NSColorSpace>, Binding> { return BindingName<Dynamic<NSColorSpace>, Binding>({ v in .windowBinding(Window.Binding.colorSpace(v)) }) }
	public static var contentMinSize: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .windowBinding(Window.Binding.contentMinSize(v)) }) }
	public static var contentMaxSize: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .windowBinding(Window.Binding.contentMaxSize(v)) }) }
	@available(macOS 10.11, *)
	public static var minFullScreenContentSize: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .windowBinding(Window.Binding.minFullScreenContentSize(v)) }) }
	@available(macOS 10.11, *)
	public static var maxFullScreenContentSize: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .windowBinding(Window.Binding.maxFullScreenContentSize(v)) }) }
	public static var contentAspectRatio: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .windowBinding(Window.Binding.contentAspectRatio(v)) }) }
	public static var contentResizeIncrements: BindingName<Dynamic<NSSize>, Binding> { return BindingName<Dynamic<NSSize>, Binding>({ v in .windowBinding(Window.Binding.contentResizeIncrements(v)) }) }
	
	/// Binding name for the horizonal component of `AppKit.NSWindow.setContentSize(_ size: NSSize)`
	public static var contentWidth: BindingName<Dynamic<WindowSize>, Binding> { return BindingName<Dynamic<WindowSize>, Binding>({ v in .windowBinding(Window.Binding.contentWidth(v)) }) }
	public static var contentHeight: BindingName<Dynamic<WindowSize>, Binding> { return BindingName<Dynamic<WindowSize>, Binding>({ v in .windowBinding(Window.Binding.contentHeight(v)) }) }
	public static var depthLimit: BindingName<Dynamic<NSWindow.Depth?>, Binding> { return BindingName<Dynamic<NSWindow.Depth?>, Binding>({ v in .windowBinding(Window.Binding.depthLimit(v)) }) }
	public static var displaysWhenScreenProfileChanges: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.displaysWhenScreenProfileChanges(v)) }) }
	public static var isDocumentEdited: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isDocumentEdited(v)) }) }
	public static var isExcludedFromWindowsMenu: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isExcludedFromWindowsMenu(v)) }) }
	public static var frameAutosaveName: BindingName<Dynamic<NSWindow.FrameAutosaveName>, Binding> { return BindingName<Dynamic<NSWindow.FrameAutosaveName>, Binding>({ v in .windowBinding(Window.Binding.frameAutosaveName(v)) }) }
	public static var frameHorizontal: BindingName<Dynamic<WindowPlacement>, Binding> { return BindingName<Dynamic<WindowPlacement>, Binding>({ v in .windowBinding(Window.Binding.frameHorizontal(v)) }) }
	public static var frameVertical: BindingName<Dynamic<WindowPlacement>, Binding> { return BindingName<Dynamic<WindowPlacement>, Binding>({ v in .windowBinding(Window.Binding.frameVertical(v)) }) }
	public static var hasShadow: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.hasShadow(v)) }) }
	public static var hidesOnDeactivate: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.hidesOnDeactivate(v)) }) }
	public static var ignoresMouseEvents: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.ignoresMouseEvents(v)) }) }
	public static var key: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.key(v)) }) }
	public static var level: BindingName<Dynamic<NSWindow.Level>, Binding> { return BindingName<Dynamic<NSWindow.Level>, Binding>({ v in .windowBinding(Window.Binding.level(v)) }) }
	public static var main: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.main(v)) }) }
	public static var miniwindowImage: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .windowBinding(Window.Binding.miniwindowImage(v)) }) }
	public static var miniwindowTitle: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .windowBinding(Window.Binding.miniwindowTitle(v)) }) }
	public static var isMovable: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isMovable(v)) }) }
	public static var isMovableByWindowBackground: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isMovableByWindowBackground(v)) }) }
	public static var isOneShot: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isOneShot(v)) }) }
	public static var isOpaque: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isOpaque(v)) }) }
	public static var order: BindingName<Dynamic<WindowOrder>, Binding> { return BindingName<Dynamic<WindowOrder>, Binding>({ v in .windowBinding(Window.Binding.order(v)) }) }
	public static var preferredBackingLocation: BindingName<Dynamic<NSWindow.BackingLocation>, Binding> { return BindingName<Dynamic<NSWindow.BackingLocation>, Binding>({ v in .windowBinding(Window.Binding.preferredBackingLocation(v)) }) }
	public static var preservesContentDuringLiveResize: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.preservesContentDuringLiveResize(v)) }) }
	public static var preventsApplicationTerminationWhenModal: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.preventsApplicationTerminationWhenModal(v)) }) }
	public static var representedURL: BindingName<Dynamic<URL?>, Binding> { return BindingName<Dynamic<URL?>, Binding>({ v in .windowBinding(Window.Binding.representedURL(v)) }) }
	public static var resizeStyle: BindingName<Dynamic<WindowResizeStyle>, Binding> { return BindingName<Dynamic<WindowResizeStyle>, Binding>({ v in .windowBinding(Window.Binding.resizeStyle(v)) }) }
	public static var isRestorable: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .windowBinding(Window.Binding.isRestorable(v)) }) }
	public static var restorationClass: BindingName<Dynamic<NSWindowRestoration.Type>, Binding> { return BindingName<Dynamic<NSWindowRestoration.Type>, Binding>({ v in .windowBinding(Window.Binding.restorationClass(v)) }) }
	public static var screen: BindingName<Dynamic<NSScreen?>, Binding> { return BindingName<Dynamic<NSScreen?>, Binding>({ v in .windowBinding(Window.Binding.screen(v)) }) }
	public static var sharingType: BindingName<Dynamic<NSWindow.SharingType>, Binding> { return BindingName<Dynamic<NSWindow.SharingType>, Binding>({ v in .windowBinding(Window.Binding.sharingType(v)) }) }
	public static var styleMask: BindingName<Dynamic<NSWindow.StyleMask>, Binding> { return BindingName<Dynamic<NSWindow.StyleMask>, Binding>({ v in .windowBinding(Window.Binding.styleMask(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .windowBinding(Window.Binding.title(v)) }) }
	public static var toolbar: BindingName<Dynamic<ToolbarConvertible>, Binding> { return BindingName<Dynamic<ToolbarConvertible>, Binding>({ v in .windowBinding(Window.Binding.toolbar(v)) }) }

	// 2. Signal bindings are performed on the object after construction.
	public static var close: BindingName<Signal<WindowCloseBehavior>, Binding> { return BindingName<Signal<WindowCloseBehavior>, Binding>({ v in .windowBinding(Window.Binding.close(v)) }) }
	public static var deminiaturize: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.deminiaturize(v)) }) }
	public static var display: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .windowBinding(Window.Binding.display(v)) }) }
	public static var invalidateShadow: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.invalidateShadow(v)) }) }
	public static var miniaturize: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .windowBinding(Window.Binding.miniaturize(v)) }) }
	public static var printWindow: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.printWindow(v)) }) }
	public static var recalculateKeyViewLoop: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.recalculateKeyViewLoop(v)) }) }
	public static var runToolbarCustomizationPalette: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.runToolbarCustomizationPalette(v)) }) }
	public static var selectNextKeyView: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.selectNextKeyView(v)) }) }
	public static var selectPreviousKeyView: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.selectPreviousKeyView(v)) }) }
	public static var toggleFullScreen: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.toggleFullScreen(v)) }) }
	public static var toggleToolbarShown: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .windowBinding(Window.Binding.toggleToolbarShown(v)) }) }
	public static var zoom: BindingName<Signal<Bool>, Binding> { return BindingName<Signal<Bool>, Binding>({ v in .windowBinding(Window.Binding.zoom(v)) }) }
	public static var sheet: BindingName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>, Binding> { return BindingName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>, Binding>({ v in .windowBinding(Window.Binding.sheet(v)) }) }
	public static var criticalSheet: BindingName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>, Binding> { return BindingName<Signal<Callback<NSWindow, NSApplication.ModalResponse>>, Binding>({ v in .windowBinding(Window.Binding.criticalSheet(v)) }) }
	public static var presentError: BindingName<Signal<Callback<Error, Bool>>, Binding> { return BindingName<Signal<Callback<Error, Bool>>, Binding>({ v in .windowBinding(Window.Binding.presentError(v)) }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBecomeKey: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didBecomeKey(v)) }) }
	public static var didBecomeMain: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didBecomeMain(v)) }) }
	public static var didChangeBackingProperties: BindingName<SignalInput<(oldColorSpace: NSColorSpace?, oldScaleFactor: CGFloat?)>, Binding> { return BindingName<SignalInput<(oldColorSpace: NSColorSpace?, oldScaleFactor: CGFloat?)>, Binding>({ v in .windowBinding(Window.Binding.didChangeBackingProperties(v)) }) }
	public static var didChangeOcclusionState: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didChangeOcclusionState(v)) }) }
	public static var didChangeScreen: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didChangeScreen(v)) }) }
	public static var didChangeScreenProfile: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didChangeScreenProfile(v)) }) }
	public static var didDeminiaturize: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didDeminiaturize(v)) }) }
	public static var didEndLiveResize: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didEndLiveResize(v)) }) }
	public static var didEndSheet: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didEndSheet(v)) }) }
	public static var didEnterFullScreen: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didEnterFullScreen(v)) }) }
	public static var didEnterVersionBrowser: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didEnterVersionBrowser(v)) }) }
	public static var didExitFullScreen: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didExitFullScreen(v)) }) }
	public static var didExitVersionBrowser: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didExitVersionBrowser(v)) }) }
	public static var didExpose: BindingName<SignalInput<NSRect>, Binding> { return BindingName<SignalInput<NSRect>, Binding>({ v in .windowBinding(Window.Binding.didExpose(v)) }) }
	public static var didMiniaturize: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didMiniaturize(v)) }) }
	public static var didMove: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didMove(v)) }) }
	public static var didResignKey: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didResignKey(v)) }) }
	public static var didResignMain: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didResignMain(v)) }) }
	public static var didResize: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didResize(v)) }) }
	public static var didUpdate: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.didUpdate(v)) }) }
	public static var willBeginSheet: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willBeginSheet(v)) }) }
	public static var willClose: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willClose(v)) }) }
	public static var willEnterFullScreen: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willEnterFullScreen(v)) }) }
	public static var willEnterVersionBrowser: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willEnterVersionBrowser(v)) }) }
	public static var willExitFullScreen: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willExitFullScreen(v)) }) }
	public static var willExitVersionBrowser: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willExitVersionBrowser(v)) }) }
	public static var willMiniaturize: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willMiniaturize(v)) }) }
	public static var willMove: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willMove(v)) }) }
	public static var willStartLiveResize: BindingName<SignalInput<Void>, Binding> { return BindingName<SignalInput<Void>, Binding>({ v in .windowBinding(Window.Binding.willStartLiveResize(v)) }) }

	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var shouldClose: BindingName<(NSWindow) -> Bool, Binding> { return BindingName<(NSWindow) -> Bool, Binding>({ v in .windowBinding(Window.Binding.shouldClose(v)) }) }
	public static var shouldPopUpDocumentPathMenu: BindingName<(NSWindow, NSMenu) -> Bool, Binding> { return BindingName<(NSWindow, NSMenu) -> Bool, Binding>({ v in .windowBinding(Window.Binding.shouldPopUpDocumentPathMenu(v)) }) }
	public static var shouldZoom: BindingName<(NSWindow, NSRect) -> Bool, Binding> { return BindingName<(NSWindow, NSRect) -> Bool, Binding>({ v in .windowBinding(Window.Binding.shouldZoom(v)) }) }
	public static var willResize: BindingName<(NSWindow, NSSize) -> NSSize, Binding> { return BindingName<(NSWindow, NSSize) -> NSSize, Binding>({ v in .windowBinding(Window.Binding.willResize(v)) }) }
	public static var willResizeForVersionBrowser: BindingName<(_ window: NSWindow, _ maxPreferredSize: NSSize, _ maxAllowedSize: NSSize) -> NSSize, Binding> { return BindingName<(_ window: NSWindow, _ maxPreferredSize: NSSize, _ maxAllowedSize: NSSize) -> NSSize, Binding>({ v in .windowBinding(Window.Binding.willResizeForVersionBrowser(v)) }) }
	public static var willUseFullScreenContentSize: BindingName<(NSWindow, NSSize) -> NSSize, Binding> { return BindingName<(NSWindow, NSSize) -> NSSize, Binding>({ v in .windowBinding(Window.Binding.willUseFullScreenContentSize(v)) }) }
	public static var willUseFullScreenPresentationOptions: BindingName<(NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions, Binding> { return BindingName<(NSWindow, NSApplication.PresentationOptions) -> NSApplication.PresentationOptions, Binding>({ v in .windowBinding(Window.Binding.willUseFullScreenPresentationOptions(v)) }) }
	public static var willUseStandardFrame: BindingName<(NSWindow, NSRect) -> NSRect, Binding> { return BindingName<(NSWindow, NSRect) -> NSRect, Binding>({ v in .windowBinding(Window.Binding.willUseStandardFrame(v)) }) }
}

public protocol WindowConvertible {
	func nsWindow() -> Window.Instance
}
extension Window.Instance: WindowConvertible {
	public func nsWindow() -> Window.Instance { return self }
}

public protocol WindowBinding: BaseBinding {
	static func windowBinding(_ binding: Window.Binding) -> Self
}

extension WindowBinding {
	public static func baseBinding(_ binding: BaseBinder.Binding) -> Self {
		return windowBinding(.inheritedBinding(binding))
	}
}

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
