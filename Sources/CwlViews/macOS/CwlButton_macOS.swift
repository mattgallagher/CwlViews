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

public class Button: ConstructingBinder, ButtonConvertible {
	public typealias Instance = NSButton
	public typealias Inherited = Control
	
	public var state: ConstructingBinderState<Instance, Binding>
	public required init(state: ConstructingBinderState<Instance, Binding>) {
		self.state = state
	}
	public static func bindingToInherited(_ binding: Binding) -> Inherited.Binding? {
		if case .inheritedBinding(let s) = binding { return s } else { return nil }
	}
	public func nsButton() -> Instance { return instance() }
	
	public enum Binding: ButtonBinding {
		public typealias EnclosingBinder = Button
		public static func buttonBinding(_ binding: Binding) -> Binding { return binding }
		case inheritedBinding(Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		//	1. Value bindings may be applied at construction and may subsequently change.
		case buttonType(Dynamic<NSButton.ButtonType>)
		case periodicDelay(Dynamic<(delay: Float, interval: Float)>)
		case alternateTitle(Dynamic<String>)
		case attributedTitle(Dynamic<NSAttributedString>)
		case attributedAlternateTitle(Dynamic<NSAttributedString>)
		case title(Dynamic<String>)
		case sound(Dynamic<NSSound?>)
		case isSpringLoaded(Dynamic<Bool>)
		case maxAcceleratorLevel(Dynamic<Int>)
		case image(Dynamic<NSImage?>)
		case alternateImage(Dynamic<NSImage?>)
		case imagePosition(Dynamic<NSControl.ImagePosition>)
		case isBordered(Dynamic<Bool>)
		case isTransparent(Dynamic<Bool>)
		case bezelStyle(Dynamic<NSButton.BezelStyle>)
		case showsBorderOnlyWhileMouseInside(Dynamic<Bool>)
		case allowsMixedState(Dynamic<Bool>)
		case state(Dynamic<NSControl.StateValue>)
		case highlight(Dynamic<Bool>)
		case keyEquivalent(Dynamic<String>)
		case keyEquivalentModifierMask(Dynamic<NSEvent.ModifierFlags>)
		case performKeyEquivalent(Dynamic<NSEvent>)
		@available(macOS 10.12.2, *)
		case bezelColor(Dynamic<NSColor?>)
		@available(macOS 10.12, *)
		case imageHugsTitle(Dynamic<Bool>)
		case imageScaling(Dynamic<NSImageScaling>)

		//	2. Signal bindings are performed on the object after construction.
		case setNextState(Signal<Void>)

		//	3. Action bindings are triggered by the object after construction.

		//	4. Delegate bindings require synchronous evaluation within the object's context.
	}

	public struct Preparer: ConstructingPreparer {
		public typealias EnclosingBinder = Button
		public var linkedPreparer = Inherited.Preparer()
		
		public func constructStorage() -> EnclosingBinder.Storage { return Storage() }
		public func constructInstance(subclass: EnclosingBinder.Instance.Type) -> EnclosingBinder.Instance { return subclass.init() }
		
		public init() {}
		
		public func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
			switch binding {
			case .buttonType(let x): return x.apply(instance, storage) { i, s, v in i.setButtonType(v) }
			case .periodicDelay(let x): return x.apply(instance, storage) { i, s, v in i.setPeriodicDelay(v.delay, interval: v.interval) }
			case .alternateTitle(let x): return x.apply(instance, storage) { i, s, v in i.alternateTitle = v }
			case .attributedTitle(let x): return x.apply(instance, storage) { i, s, v in i.attributedTitle = v }
			case .attributedAlternateTitle(let x): return x.apply(instance, storage) { i, s, v in i.attributedAlternateTitle = v }
			case .title(let x): return x.apply(instance, storage) { i, s, v in i.title = v }
			case .sound(let x): return x.apply(instance, storage) { i, s, v in i.sound = v }
			case .isSpringLoaded(let x): return x.apply(instance, storage) { i, s, v in if #available(macOS 10.10.3, *) { i.isSpringLoaded = v } }
			case .maxAcceleratorLevel(let x): return x.apply(instance, storage) { i, s, v in if #available(macOS 10.10.3, *) { i.maxAcceleratorLevel = v } }
			case .image(let x): return x.apply(instance, storage) { i, s, v in i.image = v }
			case .alternateImage(let x): return x.apply(instance, storage) { i, s, v in i.alternateImage = v }
			case .imagePosition(let x): return x.apply(instance, storage) { i, s, v in i.imagePosition = v }
			case .isBordered(let x): return x.apply(instance, storage) { i, s, v in i.isBordered = v }
			case .isTransparent(let x): return x.apply(instance, storage) { i, s, v in i.isTransparent = v }
			case .bezelStyle(let x): return x.apply(instance, storage) { i, s, v in i.bezelStyle = v }
			case .showsBorderOnlyWhileMouseInside(let x): return x.apply(instance, storage) { i, s, v in i.showsBorderOnlyWhileMouseInside = v }
			case .allowsMixedState(let x): return x.apply(instance, storage) { i, s, v in i.allowsMixedState = v }
			case .state(let x): return x.apply(instance, storage) { i, s, v in i.state = v }
			case .highlight(let x): return x.apply(instance, storage) { i, s, v in i.highlight(v) }
			case .keyEquivalent(let x): return x.apply(instance, storage) { i, s, v in i.keyEquivalent = v }
			case .keyEquivalentModifierMask(let x): return x.apply(instance, storage) { i, s, v in i.keyEquivalentModifierMask = v }
			case .performKeyEquivalent(let x): return x.apply(instance, storage) { i, s, v in i.performKeyEquivalent(with: v) }
			case .setNextState(let x): return x.apply(instance, storage) { i, s, v in i.setNextState() }
			case .bezelColor(let x): return x.apply(instance, storage) { i, s, v in if #available(macOS 10.12.2, *) { i.bezelColor = v } }
			case .imageHugsTitle(let x): return x.apply(instance, storage) { i, s, v in if #available(macOS 10.12, *) { i.imageHugsTitle = v } }
			case .imageScaling(let x): return x.apply(instance, storage) { i, s, v in i.imageScaling = v }
			case .inheritedBinding(let s): return linkedPreparer.applyBinding(s, instance: instance, storage: storage)
			}
		}
	}

	public typealias Storage = Control.Storage
}

extension BindingName where Binding: ButtonBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingName<$2, Binding> { return BindingName<$2, Binding>({ v in .buttonBinding(Button.Binding.$1(v)) }) }

	//	1. Value bindings may be applied at construction and may subsequently change.
	public static var buttonType: BindingName<Dynamic<NSButton.ButtonType>, Binding> { return BindingName<Dynamic<NSButton.ButtonType>, Binding>({ v in .buttonBinding(Button.Binding.buttonType(v)) }) }
	public static var periodicDelay: BindingName<Dynamic<(delay: Float, interval: Float)>, Binding> { return BindingName<Dynamic<(delay: Float, interval: Float)>, Binding>({ v in .buttonBinding(Button.Binding.periodicDelay(v)) }) }
	public static var alternateTitle: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .buttonBinding(Button.Binding.alternateTitle(v)) }) }
	public static var attributedTitle: BindingName<Dynamic<NSAttributedString>, Binding> { return BindingName<Dynamic<NSAttributedString>, Binding>({ v in .buttonBinding(Button.Binding.attributedTitle(v)) }) }
	public static var attributedAlternateTitle: BindingName<Dynamic<NSAttributedString>, Binding> { return BindingName<Dynamic<NSAttributedString>, Binding>({ v in .buttonBinding(Button.Binding.attributedAlternateTitle(v)) }) }
	public static var title: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .buttonBinding(Button.Binding.title(v)) }) }
	public static var sound: BindingName<Dynamic<NSSound?>, Binding> { return BindingName<Dynamic<NSSound?>, Binding>({ v in .buttonBinding(Button.Binding.sound(v)) }) }
	public static var isSpringLoaded: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.isSpringLoaded(v)) }) }
	public static var maxAcceleratorLevel: BindingName<Dynamic<Int>, Binding> { return BindingName<Dynamic<Int>, Binding>({ v in .buttonBinding(Button.Binding.maxAcceleratorLevel(v)) }) }
	public static var image: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .buttonBinding(Button.Binding.image(v)) }) }
	public static var alternateImage: BindingName<Dynamic<NSImage?>, Binding> { return BindingName<Dynamic<NSImage?>, Binding>({ v in .buttonBinding(Button.Binding.alternateImage(v)) }) }
	public static var imagePosition: BindingName<Dynamic<NSControl.ImagePosition>, Binding> { return BindingName<Dynamic<NSControl.ImagePosition>, Binding>({ v in .buttonBinding(Button.Binding.imagePosition(v)) }) }
	public static var isBordered: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.isBordered(v)) }) }
	public static var isTransparent: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.isTransparent(v)) }) }
	public static var bezelStyle: BindingName<Dynamic<NSButton.BezelStyle>, Binding> { return BindingName<Dynamic<NSButton.BezelStyle>, Binding>({ v in .buttonBinding(Button.Binding.bezelStyle(v)) }) }
	public static var showsBorderOnlyWhileMouseInside: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.showsBorderOnlyWhileMouseInside(v)) }) }
	public static var allowsMixedState: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.allowsMixedState(v)) }) }
	public static var state: BindingName<Dynamic<NSControl.StateValue>, Binding> { return BindingName<Dynamic<NSControl.StateValue>, Binding>({ v in .buttonBinding(Button.Binding.state(v)) }) }
	public static var highlight: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.highlight(v)) }) }
	public static var keyEquivalent: BindingName<Dynamic<String>, Binding> { return BindingName<Dynamic<String>, Binding>({ v in .buttonBinding(Button.Binding.keyEquivalent(v)) }) }
	public static var keyEquivalentModifierMask: BindingName<Dynamic<NSEvent.ModifierFlags>, Binding> { return BindingName<Dynamic<NSEvent.ModifierFlags>, Binding>({ v in .buttonBinding(Button.Binding.keyEquivalentModifierMask(v)) }) }
	public static var performKeyEquivalent: BindingName<Dynamic<NSEvent>, Binding> { return BindingName<Dynamic<NSEvent>, Binding>({ v in .buttonBinding(Button.Binding.performKeyEquivalent(v)) }) }
	@available(macOS 10.12.2, *)
	public static var bezelColor: BindingName<Dynamic<NSColor?>, Binding> { return BindingName<Dynamic<NSColor?>, Binding>({ v in .buttonBinding(Button.Binding.bezelColor(v)) }) }
	@available(macOS 10.12, *)
	public static var imageHugsTitle: BindingName<Dynamic<Bool>, Binding> { return BindingName<Dynamic<Bool>, Binding>({ v in .buttonBinding(Button.Binding.imageHugsTitle(v)) }) }
	public static var imageScaling: BindingName<Dynamic<NSImageScaling>, Binding> { return BindingName<Dynamic<NSImageScaling>, Binding>({ v in .buttonBinding(Button.Binding.imageScaling(v)) }) }

	//	2. Signal bindings are performed on the object after construction.
	public static var setNextState: BindingName<Signal<Void>, Binding> { return BindingName<Signal<Void>, Binding>({ v in .buttonBinding(Button.Binding.setNextState(v)) }) }

	//	3. Action bindings are triggered by the object after construction.

	//	4. Delegate bindings require synchronous evaluation within the object's context.
}

public protocol ButtonConvertible: ControlConvertible {
	func nsButton() -> Button.Instance
}
extension ButtonConvertible {
	public func nsControl() -> Control.Instance { return nsButton() }
}
extension Button.Instance: ButtonConvertible {
	public func nsButton() -> Button.Instance { return self }
}

public protocol ButtonBinding: ControlBinding {
	static func buttonBinding(_ binding: Button.Binding) -> Self
}
extension ButtonBinding {
	public static func controlBinding(_ binding: Control.Binding) -> Self {
		return buttonBinding(.inheritedBinding(binding))
	}
}

#endif
