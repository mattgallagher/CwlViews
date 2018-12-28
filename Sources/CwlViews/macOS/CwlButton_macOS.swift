//
//  CwlButton_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 5/11/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class Button: Binder, ButtonConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Button {
	enum Binding: ButtonBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case allowsMixedState(Dynamic<Bool>)
		case alternateImage(Dynamic<NSImage?>)
		case alternateTitle(Dynamic<String>)
		case attributedAlternateTitle(Dynamic<NSAttributedString>)
		case attributedTitle(Dynamic<NSAttributedString>)
		case bezelStyle(Dynamic<NSButton.BezelStyle>)
		case buttonType(Dynamic<NSButton.ButtonType>)
		case highlight(Dynamic<Bool>)
		case image(Dynamic<NSImage?>)
		case imagePosition(Dynamic<NSControl.ImagePosition>)
		case imageScaling(Dynamic<NSImageScaling>)
		case isBordered(Dynamic<Bool>)
		case isSpringLoaded(Dynamic<Bool>)
		case isTransparent(Dynamic<Bool>)
		case keyEquivalent(Dynamic<String>)
		case keyEquivalentModifierMask(Dynamic<NSEvent.ModifierFlags>)
		case maxAcceleratorLevel(Dynamic<Int>)
		case performKeyEquivalent(Dynamic<NSEvent>)
		case periodicDelay(Dynamic<(delay: Float, interval: Float)>)
		case showsBorderOnlyWhileMouseInside(Dynamic<Bool>)
		case sound(Dynamic<NSSound?>)
		case state(Dynamic<NSControl.StateValue>)
		case title(Dynamic<String>)
		@available(macOS 10.12.2, *) case bezelColor(Dynamic<NSColor?>)
		@available(macOS 10.12, *) case imageHugsTitle(Dynamic<Bool>)

		//	2. Signal bindings are performed on the object after construction.
		case setNextState(Signal<Void>)

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension Button {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Button.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSButton
		
		public var inherited = Inherited()
		public init() {}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}
		
// MARK: - Binder Part 4: Preparer overrides
public extension Button.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case .allowsMixedState(let x): return x.apply(instance) { i, v in i.allowsMixedState = v }
		case .alternateImage(let x): return x.apply(instance) { i, v in i.alternateImage = v }
		case .alternateTitle(let x): return x.apply(instance) { i, v in i.alternateTitle = v }
		case .attributedAlternateTitle(let x): return x.apply(instance) { i, v in i.attributedAlternateTitle = v }
		case .attributedTitle(let x): return x.apply(instance) { i, v in i.attributedTitle = v }
		case .bezelStyle(let x): return x.apply(instance) { i, v in i.bezelStyle = v }
		case .buttonType(let x): return x.apply(instance) { i, v in i.setButtonType(v) }
		case .highlight(let x): return x.apply(instance) { i, v in i.highlight(v) }
		case .image(let x): return x.apply(instance) { i, v in i.image = v }
		case .imagePosition(let x): return x.apply(instance) { i, v in i.imagePosition = v }
		case .imageScaling(let x): return x.apply(instance) { i, v in i.imageScaling = v }
		case .isBordered(let x): return x.apply(instance) { i, v in i.isBordered = v }
		case .isSpringLoaded(let x): return x.apply(instance) { i, v in if #available(macOS 10.10.3, *) { i.isSpringLoaded = v } }
		case .isTransparent(let x): return x.apply(instance) { i, v in i.isTransparent = v }
		case .keyEquivalent(let x): return x.apply(instance) { i, v in i.keyEquivalent = v }
		case .keyEquivalentModifierMask(let x): return x.apply(instance) { i, v in i.keyEquivalentModifierMask = v }
		case .maxAcceleratorLevel(let x): return x.apply(instance) { i, v in if #available(macOS 10.10.3, *) { i.maxAcceleratorLevel = v } }
		case .performKeyEquivalent(let x): return x.apply(instance) { i, v in i.performKeyEquivalent(with: v) }
		case .periodicDelay(let x): return x.apply(instance) { i, v in i.setPeriodicDelay(v.delay, interval: v.interval) }
		case .showsBorderOnlyWhileMouseInside(let x): return x.apply(instance) { i, v in i.showsBorderOnlyWhileMouseInside = v }
		case .sound(let x): return x.apply(instance) { i, v in i.sound = v }
		case .state(let x): return x.apply(instance) { i, v in i.state = v }
		case .title(let x): return x.apply(instance) { i, v in i.title = v }

		case .bezelColor(let x): return x.apply(instance) { i, v in if #available(macOS 10.12.2, *) { i.bezelColor = v } }
		case .imageHugsTitle(let x): return x.apply(instance) { i, v in if #available(macOS 10.12, *) { i.imageHugsTitle = v } }

		//	2. Signal bindings are performed on the object after construction.
		case .setNextState(let x): return x.apply(instance) { i, v in i.setNextState() }

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Button.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ButtonBinding {
	public typealias ButtonName<V> = BindingName<V, Button.Binding, Binding>
	private typealias B = Button.Binding
	private static func name<V>(_ source: @escaping (V) -> Button.Binding) -> ButtonName<V> {
		return ButtonName<V>(source: source, downcast: Binding.buttonBinding)
	}
}
public extension BindingName where Binding: ButtonBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ButtonName<$2> { return .name(B.$1) }

	//	0. Static bindings are applied at construction and are subsequently immutable.
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var allowsMixedState: ButtonName<Dynamic<Bool>> { return .name(B.allowsMixedState) }
	static var alternateImage: ButtonName<Dynamic<NSImage?>> { return .name(B.alternateImage) }
	static var alternateTitle: ButtonName<Dynamic<String>> { return .name(B.alternateTitle) }
	static var attributedAlternateTitle: ButtonName<Dynamic<NSAttributedString>> { return .name(B.attributedAlternateTitle) }
	static var attributedTitle: ButtonName<Dynamic<NSAttributedString>> { return .name(B.attributedTitle) }
	static var bezelStyle: ButtonName<Dynamic<NSButton.BezelStyle>> { return .name(B.bezelStyle) }
	static var buttonType: ButtonName<Dynamic<NSButton.ButtonType>> { return .name(B.buttonType) }
	static var highlight: ButtonName<Dynamic<Bool>> { return .name(B.highlight) }
	static var image: ButtonName<Dynamic<NSImage?>> { return .name(B.image) }
	static var imagePosition: ButtonName<Dynamic<NSControl.ImagePosition>> { return .name(B.imagePosition) }
	static var imageScaling: ButtonName<Dynamic<NSImageScaling>> { return .name(B.imageScaling) }
	static var isBordered: ButtonName<Dynamic<Bool>> { return .name(B.isBordered) }
	static var isSpringLoaded: ButtonName<Dynamic<Bool>> { return .name(B.isSpringLoaded) }
	static var isTransparent: ButtonName<Dynamic<Bool>> { return .name(B.isTransparent) }
	static var keyEquivalent: ButtonName<Dynamic<String>> { return .name(B.keyEquivalent) }
	static var keyEquivalentModifierMask: ButtonName<Dynamic<NSEvent.ModifierFlags>> { return .name(B.keyEquivalentModifierMask) }
	static var maxAcceleratorLevel: ButtonName<Dynamic<Int>> { return .name(B.maxAcceleratorLevel) }
	static var performKeyEquivalent: ButtonName<Dynamic<NSEvent>> { return .name(B.performKeyEquivalent) }
	static var periodicDelay: ButtonName<Dynamic<(delay: Float, interval: Float)>> { return .name(B.periodicDelay) }
	static var showsBorderOnlyWhileMouseInside: ButtonName<Dynamic<Bool>> { return .name(B.showsBorderOnlyWhileMouseInside) }
	static var sound: ButtonName<Dynamic<NSSound?>> { return .name(B.sound) }
	static var state: ButtonName<Dynamic<NSControl.StateValue>> { return .name(B.state) }
	static var title: ButtonName<Dynamic<String>> { return .name(B.title) }
	@available(macOS 10.12.2, *) static var bezelColor: ButtonName<Dynamic<NSColor?>> { return .name(B.bezelColor) }
	@available(macOS 10.12, *) static var imageHugsTitle: ButtonName<Dynamic<Bool>> { return .name(B.imageHugsTitle) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var setNextState: ButtonName<Signal<Void>> { return .name(B.setNextState) }
	
	//	3. Action bindings are triggered by the object after construction.
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ButtonConvertible: ControlConvertible {
	func nsButton() -> Button.Instance
}
extension ButtonConvertible {
	public func nsControl() -> Control.Instance { return nsButton() }
}
extension NSButton: ButtonConvertible {
	public func nsButton() -> Button.Instance { return self }
}
public extension Button {
	func nsButton() -> Button.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ButtonBinding: ControlBinding {
	static func buttonBinding(_ binding: Button.Binding) -> Self
}
public extension ButtonBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return buttonBinding(.inheritedBinding(binding))
	}
}
public extension Button.Binding {
	public typealias Preparer = Button.Preparer
	static func buttonBinding(_ binding: Button.Binding) -> Button.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
