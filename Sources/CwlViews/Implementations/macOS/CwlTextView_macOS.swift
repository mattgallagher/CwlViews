//
//  CwlTextView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class TextView: Binder, TextViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}

	public static func scrollEmbedded(type: NSTextView.Type = NSTextView.self, _ bindings: Binding...) -> ScrollView {
		return ScrollView(
			.borderType -- .noBorder,
			.hasVerticalScroller -- true,
			.hasHorizontalScroller -- true,
			.autohidesScrollers -- true,
			.contentView -- ClipView(
				.documentView -- TextView(type: type, bindings: bindings)
			)
		)
	}
}

// MARK: - Binder Part 2: Binding
public extension TextView {
	enum Binding: TextViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case string(Dynamic<String>)
		case backgroundColor(Dynamic<NSColor>)
		case drawsBackground(Dynamic<Bool>)
		case isEditable(Dynamic<Bool>)
		case isSelectable(Dynamic<Bool>)
		case isFieldEditor(Dynamic<Bool>)
		case isRichText(Dynamic<Bool>)
		case importsGraphics(Dynamic<Bool>)
		case usesFontPanel(Dynamic<Bool>)
		case font(Dynamic<NSFont>)
		case alignment(Dynamic<NSTextAlignment>)
		case textColor(Dynamic<NSColor>)
		case baseWritingDirection(Dynamic<NSWritingDirection>)
		case maxSize(Dynamic<NSSize>)
		case minSize(Dynamic<NSSize>)
		case isVerticallyResizable(Dynamic<Bool>)
		case isHorizontallyResizable(Dynamic<Bool>)
		
		case textContainerInset(Dynamic<NSSize>)
		case allowsDocumentBackgroundColorChange(Dynamic<Bool>)
		case allowsUndo(Dynamic<Bool>)
		case defaultParagraphStyle(Dynamic<NSParagraphStyle>)
		case allowsImageEditing(Dynamic<Bool>)
		case isAutomaticQuoteSubstitutionEnabled(Dynamic<Bool>)
		case isAutomaticLinkDetectionEnabled(Dynamic<Bool>)
		case displaysLinkToolTips(Dynamic<Bool>)
		case usesRuler(Dynamic<Bool>)
		case usesInspectorBar(Dynamic<Bool>)
		case selectionGranularity(Dynamic<NSSelectionGranularity>)
		case insertionPointColor(Dynamic<NSColor>)
		case selectedTextAttributes(Dynamic<[NSAttributedString.Key : Any]>)
		case markedTextAttributes(Dynamic<[NSAttributedString.Key : Any]>)
		case linkTextAttributes(Dynamic<[NSAttributedString.Key : Any]>)
		case typingAttributes(Dynamic<[NSAttributedString.Key : Any]>)
		case isContinuousSpellCheckingEnabled(Dynamic<Bool>)
		case isGrammarCheckingEnabled(Dynamic<Bool>)
		case usesFindPanel(Dynamic<Bool>)
		case enabledTextCheckingTypes(Dynamic<NSTextCheckingTypes>)
		case isAutomaticDashSubstitutionEnabled(Dynamic<Bool>)
		case isAutomaticDataDetectionEnabled(Dynamic<Bool>)
		case isAutomaticSpellingCorrectionEnabled(Dynamic<Bool>)
		case isAutomaticTextReplacementEnabled(Dynamic<Bool>)
		case layoutOrientation(Dynamic<NSLayoutManager.TextLayoutOrientation>)
		case usesFindBar(Dynamic<Bool>)
		case isIncrementalSearchingEnabled(Dynamic<Bool>)
		case allowsCharacterPickerTouchBarItem(Dynamic<Bool>)
		case isAutomaticTextCompletionEnabled(Dynamic<Bool>)
		case usesRolloverButtonForSelection(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case selectRange(Signal<NSRange>)
		case selectAll(Signal<Void>)
		case copy(Signal<Void>)
		case cut(Signal<Void>)
		case paste(Signal<Void>)
		case copyFont(Signal<Void>)
		case pasteFont(Signal<Void>)
		case copyRuler(Signal<Void>)
		case pasteRuler(Signal<Void>)
		case delete(Signal<Void>)
		case changeFont(Signal<Void>)
		case alignCenter(Signal<Void>)
		case alignLeft(Signal<Void>)
		case alignRight(Signal<Void>)
		case superscript(Signal<Void>)
		case `subscript`(Signal<Void>)
		case unscript(Signal<Void>)
		case underline(Signal<Void>)
		case checkSpelling(Signal<Void>)
		case showGuessPanel(Signal<Void>)
		case sizeToFit(Signal<Void>)
		case scrollRangeToVisible(Signal<NSRange>)

		case showFindIndicator(Signal<NSRange>)
		case changeDocumentBackgroundColor(Signal<Void>)
		case outline(Signal<Void>)
		case alignJustified(Signal<Void>)
		case changeAttributes(Signal<Void>)
		case useStandardKerning(Signal<Void>)
		case lowerBaseline(Signal<Void>)
		case raiseBaseline(Signal<Void>)
		case turnOffKerning(Signal<Void>)
		case loosenKerning(Signal<Void>)
		case tightenKerning(Signal<Void>)
		case useStandardLigatures(Signal<Void>)
		case turnOffLigatures(Signal<Void>)
		case useAllLigatures(Signal<Void>)
		case clicked(Signal<(Any, Int)>)
		case pasteAsPlainText(Signal<Void>)
		case pasteAsRichText(Signal<Void>)
		case breakUndoCoalescing(Signal<Void>)
		case setSpellingState(Signal<(NSAttributedString.SpellingState, NSRange)>)
		case orderFrontSharingServicePicker(Signal<Void>)
		case startSpeaking(Signal<Void>)
		case stopSpeaking(Signal<Void>)
		case performFindPanelAction(Signal<Void>)
		case orderFrontLinkPanel(Signal<Void>)
		case orderFrontListPanel(Signal<Void>)
		case orderFrontSpacingPanel(Signal<Void>)
		case orderFrontTablePanel(Signal<Void>)
		case orderFrontSubstitutionsPanel(Signal<Void>)
		case complete(Signal<Void>)
		case checkTextInDocument(Signal<Void>)
		case checkTextInSelection(Signal<Void>)
		case checkText(Signal<(NSRange, NSTextCheckingTypes, [NSSpellChecker.OptionKey: Any])>)
		case updateQuickLookPreviewPanel(Signal<Void>)
		case toggleQuickLookPreviewPanel(Signal<Void>)
		case updateCandidates(Signal<Void>)
		case updateTextTouchBarItems(Signal<Void>)
		case updateTouchBarItemIdentifiers(Signal<Void>)

		// 3. Action bindings are triggered by the object after construction.
		case didBeginEditing(SignalInput<NSTextView>)
		case didChange(SignalInput<NSTextView>)
		case didEndEditing(SignalInput<(NSTextView, NSTextMovement?)>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldBeginEditing((NSTextView) -> Bool)
		case shouldEndEditing((NSTextView) -> Bool)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TextView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TextView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = NSTextView
		
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
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TextView.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .shouldBeginEditing(let x): delegate().addSingleHandler1(x, #selector(NSTextViewDelegate.textShouldBeginEditing(_:)))
		case .shouldEndEditing(let x): delegate().addSingleHandler1(x, #selector(NSTextViewDelegate.textShouldEndEditing(_:)))
		default: break
		}
	}

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		// 0. Static bindings are applied at construction and are subsequently immutable.
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .string(let x): return x.apply(instance) { i, v in i.string = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .drawsBackground(let x): return x.apply(instance) { i, v in i.drawsBackground = v }
		case .isEditable(let x): return x.apply(instance) { i, v in i.isEditable = v }
		case .isSelectable(let x): return x.apply(instance) { i, v in i.isSelectable = v }
		case .isFieldEditor(let x): return x.apply(instance) { i, v in i.isFieldEditor = v }
		case .isRichText(let x): return x.apply(instance) { i, v in i.isRichText = v }
		case .importsGraphics(let x): return x.apply(instance) { i, v in i.importsGraphics = v }
		case .usesFontPanel(let x): return x.apply(instance) { i, v in i.usesFontPanel = v }
		case .font(let x): return x.apply(instance) { i, v in i.font = v }
		case .alignment(let x): return x.apply(instance) { i, v in i.alignment = v }
		case .textColor(let x): return x.apply(instance) { i, v in i.textColor = v }
		case .baseWritingDirection(let x): return x.apply(instance) { i, v in i.baseWritingDirection = v }
		case .maxSize(let x): return x.apply(instance) { i, v in i.maxSize = v }
		case .minSize(let x): return x.apply(instance) { i, v in i.minSize = v }
		case .isVerticallyResizable(let x): return x.apply(instance) { i, v in i.isVerticallyResizable = v }
		case .isHorizontallyResizable(let x): return x.apply(instance) { i, v in i.isHorizontallyResizable = v }

		case .textContainerInset(let x): return x.apply(instance) { i, v in i.textContainerInset = v }
		case .allowsDocumentBackgroundColorChange(let x): return x.apply(instance) { i, v in i.allowsDocumentBackgroundColorChange = v }
		case .allowsUndo(let x): return x.apply(instance) { i, v in i.allowsUndo = v }
		case .defaultParagraphStyle(let x): return x.apply(instance) { i, v in i.defaultParagraphStyle = v }
		case .allowsImageEditing(let x): return x.apply(instance) { i, v in i.allowsImageEditing = v }
		case .isAutomaticQuoteSubstitutionEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticQuoteSubstitutionEnabled = v }
		case .isAutomaticLinkDetectionEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticLinkDetectionEnabled = v }
		case .displaysLinkToolTips(let x): return x.apply(instance) { i, v in i.displaysLinkToolTips = v }
		case .usesRuler(let x): return x.apply(instance) { i, v in i.usesRuler = v }
		case .usesInspectorBar(let x): return x.apply(instance) { i, v in i.usesInspectorBar = v }
		case .selectionGranularity(let x): return x.apply(instance) { i, v in i.selectionGranularity = v }
		case .insertionPointColor(let x): return x.apply(instance) { i, v in i.insertionPointColor = v }
		case .selectedTextAttributes(let x): return x.apply(instance) { i, v in i.selectedTextAttributes = v }
		case .markedTextAttributes(let x): return x.apply(instance) { i, v in i.markedTextAttributes = v }
		case .linkTextAttributes(let x): return x.apply(instance) { i, v in i.linkTextAttributes = v }
		case .typingAttributes(let x): return x.apply(instance) { i, v in i.typingAttributes = v }
		case .isContinuousSpellCheckingEnabled(let x): return x.apply(instance) { i, v in i.isContinuousSpellCheckingEnabled = v }
		case .isGrammarCheckingEnabled(let x): return x.apply(instance) { i, v in i.isGrammarCheckingEnabled = v }
		case .usesFindPanel(let x): return x.apply(instance) { i, v in i.usesFindPanel = v }
		case .enabledTextCheckingTypes(let x): return x.apply(instance) { i, v in i.enabledTextCheckingTypes = v }
		case .isAutomaticDashSubstitutionEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticDashSubstitutionEnabled = v }
		case .isAutomaticDataDetectionEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticDataDetectionEnabled = v }
		case .isAutomaticSpellingCorrectionEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticSpellingCorrectionEnabled = v }
		case .isAutomaticTextReplacementEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticTextReplacementEnabled = v }
		case .layoutOrientation(let x): return x.apply(instance) { i, v in i.setLayoutOrientation(v) }
		case .usesFindBar(let x): return x.apply(instance) { i, v in i.usesFindBar = v }
		case .isIncrementalSearchingEnabled(let x): return x.apply(instance) { i, v in i.isIncrementalSearchingEnabled = v }
		case .allowsCharacterPickerTouchBarItem(let x): return x.apply(instance) { i, v in i.allowsCharacterPickerTouchBarItem = v }
		case .isAutomaticTextCompletionEnabled(let x): return x.apply(instance) { i, v in i.isAutomaticTextCompletionEnabled = v }
		case .usesRolloverButtonForSelection(let x): return x.apply(instance) { i, v in i.usesRolloverButtonForSelection = v }
			
		// 2. Signal bindings are performed on the object after construction.
		case .selectRange(let x): return x.apply(instance) { i, v in i.selectedRange = v }
		case .selectAll(let x): return x.apply(instance) { i, v in i.selectAll(nil) }
		case .copy(let x): return x.apply(instance) { i, v in i.copy(nil) }
		case .cut(let x): return x.apply(instance) { i, v in i.cut(nil) }
		case .paste(let x): return x.apply(instance) { i, v in i.paste(nil) }
		case .copyFont(let x): return x.apply(instance) { i, v in i.copyFont(nil) }
		case .pasteFont(let x): return x.apply(instance) { i, v in i.pasteFont(nil) }
		case .copyRuler(let x): return x.apply(instance) { i, v in i.copyRuler(nil) }
		case .pasteRuler(let x): return x.apply(instance) { i, v in i.pasteRuler(nil) }
		case .delete(let x): return x.apply(instance) { i, v in i.delete(nil) }
		case .changeFont(let x): return x.apply(instance) { i, v in i.changeFont(nil) }
		case .alignCenter(let x): return x.apply(instance) { i, v in i.alignCenter(nil) }
		case .alignLeft(let x): return x.apply(instance) { i, v in i.alignLeft(nil) }
		case .alignRight(let x): return x.apply(instance) { i, v in i.alignRight(nil) }
		case .superscript(let x): return x.apply(instance) { i, v in i.superscript(nil) }
		case .subscript(let x): return x.apply(instance) { i, v in i.superscript(nil) }
		case .unscript(let x): return x.apply(instance) { i, v in i.unscript(nil) }
		case .underline(let x): return x.apply(instance) { i, v in i.underline(nil) }
		case .checkSpelling(let x): return x.apply(instance) { i, v in i.checkSpelling(nil) }
		case .showGuessPanel(let x): return x.apply(instance) { i, v in i.showGuessPanel(nil) }
		case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }
		case .scrollRangeToVisible(let x): return x.apply(instance) { i, v in i.scrollRangeToVisible(v) }

		case .showFindIndicator(let x): return x.apply(instance) { i, v in i.showFindIndicator(for: v) }
		case .changeDocumentBackgroundColor(let x): return x.apply(instance) { i, v in i.changeDocumentBackgroundColor(nil) }
		case .outline(let x): return x.apply(instance) { i, v in i.outline(nil) }
		case .alignJustified(let x): return x.apply(instance) { i, v in i.alignJustified(nil) }
		case .changeAttributes(let x): return x.apply(instance) { i, v in i.changeAttributes(nil) }
		case .useStandardKerning(let x): return x.apply(instance) { i, v in i.useStandardKerning(nil) }
		case .lowerBaseline(let x): return x.apply(instance) { i, v in i.lowerBaseline(nil) }
		case .raiseBaseline(let x): return x.apply(instance) { i, v in i.raiseBaseline(nil) }
		case .turnOffKerning(let x): return x.apply(instance) { i, v in i.turnOffKerning(nil) }
		case .loosenKerning(let x): return x.apply(instance) { i, v in i.loosenKerning(nil) }
		case .tightenKerning(let x): return x.apply(instance) { i, v in i.tightenKerning(nil) }
		case .useStandardLigatures(let x): return x.apply(instance) { i, v in i.useStandardLigatures(nil) }
		case .turnOffLigatures(let x): return x.apply(instance) { i, v in i.turnOffLigatures(nil) }
		case .useAllLigatures(let x): return x.apply(instance) { i, v in i.useAllLigatures(nil) }
		case .clicked(let x): return x.apply(instance) { i, v in i.clicked(onLink: v.0, at: v.1) }
		case .pasteAsPlainText(let x): return x.apply(instance) { i, v in i.pasteAsPlainText(nil) }
		case .pasteAsRichText(let x): return x.apply(instance) { i, v in i.pasteAsRichText(nil) }
		case .breakUndoCoalescing(let x): return x.apply(instance) { i, v in i.breakUndoCoalescing() }
		case .setSpellingState(let x): return x.apply(instance) { i, v in i.setSpellingState(v.0.rawValue, range: v.1) }
		case .orderFrontSharingServicePicker(let x): return x.apply(instance) { i, v in i.orderFrontSharingServicePicker(nil) }
		case .startSpeaking(let x): return x.apply(instance) { i, v in i.startSpeaking(nil) }
		case .stopSpeaking(let x): return x.apply(instance) { i, v in i.stopSpeaking(nil) }
		case .performFindPanelAction(let x): return x.apply(instance) { i, v in i.performFindPanelAction(nil) }
		case .orderFrontLinkPanel(let x): return x.apply(instance) { i, v in i.orderFrontLinkPanel(nil) }
		case .orderFrontListPanel(let x): return x.apply(instance) { i, v in i.orderFrontListPanel(nil) }
		case .orderFrontSpacingPanel(let x): return x.apply(instance) { i, v in i.orderFrontSpacingPanel(nil) }
		case .orderFrontTablePanel(let x): return x.apply(instance) { i, v in i.orderFrontTablePanel(nil) }
		case .orderFrontSubstitutionsPanel(let x): return x.apply(instance) { i, v in i.orderFrontSubstitutionsPanel(nil) }
		case .complete(let x): return x.apply(instance) { i, v in i.complete(nil) }
		case .checkTextInDocument(let x): return x.apply(instance) { i, v in i.checkTextInDocument(nil) }
		case .checkTextInSelection(let x): return x.apply(instance) { i, v in i.checkTextInSelection(nil) }
		case .checkText(let x): return x.apply(instance) { i, v in i.checkText(in: v.0, types: v.1, options: v.2) }
		case .updateQuickLookPreviewPanel(let x): return x.apply(instance) { i, v in i.updateQuickLookPreviewPanel() }
		case .toggleQuickLookPreviewPanel(let x): return x.apply(instance) { i, v in i.toggleQuickLookPreviewPanel(nil) }
		case .updateCandidates(let x): return x.apply(instance) { i, v in i.updateCandidates() }
		case .updateTextTouchBarItems(let x): return x.apply(instance) { i, v in i.updateTextTouchBarItems() }
		case .updateTouchBarItemIdentifiers(let x): return x.apply(instance) { i, v in i.updateTouchBarItemIdentifiers() }
			
		// 3. Action bindings are triggered by the object after construction.
		case .didBeginEditing(let x): return Signal.notifications(name: NSTextView.didBeginEditingNotification, object: instance).compactMap { notification -> NSTextView? in notification.object as? NSTextView }.cancellableBind(to: x)
		case .didChange(let x): return Signal.notifications(name: NSTextView.didChangeSelectionNotification, object: instance).compactMap { notification -> NSTextView? in notification.object as? NSTextView }.cancellableBind(to: x)
		case .didEndEditing(let x): return Signal.notifications(name: NSTextView.didEndEditingNotification, object: instance).compactMap { notification -> (NSTextView, NSTextMovement?)? in (notification.object as? NSTextView).map { ($0, notification.userInfo?[NSText.movementUserInfoKey] as? NSTextMovement) } }.cancellableBind(to: x)
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .shouldBeginEditing: return nil
		case .shouldEndEditing: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TextView.Preparer {
	open class Storage: View.Preparer.Storage, NSTextViewDelegate {}
	
	open class Delegate: DynamicDelegate, NSTextViewDelegate {
		open func textShouldBeginEditing(_ textObject: NSText) -> Bool {
			return singleHandler(textObject)
		}
		open func textShouldEndEditing(_ textObject: NSText) -> Bool {
			return singleHandler(textObject)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TextViewBinding {
	public typealias TextViewName<V> = BindingName<V, TextView.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> TextView.Binding) -> TextViewName<V> {
		return TextViewName<V>(source: source, downcast: Binding.textViewBinding)
	}
}
public extension BindingName where Binding: TextViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TextViewName<$2> { return .name(TextView.Binding.$1) }

	// 0. Static bindings are applied at construction and are subsequently immutable.
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var string: TextViewName<Dynamic<String>> { return .name(TextView.Binding.string) }
	static var backgroundColor: TextViewName<Dynamic<NSColor>> { return .name(TextView.Binding.backgroundColor) }
	static var drawsBackground: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.drawsBackground) }
	static var isEditable: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isEditable) }
	static var isSelectable: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isSelectable) }
	static var isFieldEditor: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isFieldEditor) }
	static var isRichText: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isRichText) }
	static var importsGraphics: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.importsGraphics) }
	static var usesFontPanel: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.usesFontPanel) }
	static var font: TextViewName<Dynamic<NSFont>> { return .name(TextView.Binding.font) }
	static var alignment: TextViewName<Dynamic<NSTextAlignment>> { return .name(TextView.Binding.alignment) }
	static var textColor: TextViewName<Dynamic<NSColor>> { return .name(TextView.Binding.textColor) }
	static var baseWritingDirection: TextViewName<Dynamic<NSWritingDirection>> { return .name(TextView.Binding.baseWritingDirection) }
	static var maxSize: TextViewName<Dynamic<NSSize>> { return .name(TextView.Binding.maxSize) }
	static var minSize: TextViewName<Dynamic<NSSize>> { return .name(TextView.Binding.minSize) }
	static var isVerticallyResizable: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isVerticallyResizable) }
	static var isHorizontallyResizable: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isHorizontallyResizable) }

	static var textContainerInset: TextViewName<Dynamic<NSSize>> { return .name(TextView.Binding.textContainerInset) }
	static var allowsDocumentBackgroundColorChange: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.allowsDocumentBackgroundColorChange) }
	static var allowsUndo: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.allowsUndo) }
	static var defaultParagraphStyle: TextViewName<Dynamic<NSParagraphStyle>> { return .name(TextView.Binding.defaultParagraphStyle) }
	static var allowsImageEditing: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.allowsImageEditing) }
	static var isAutomaticQuoteSubstitutionEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isAutomaticQuoteSubstitutionEnabled) }
	static var isAutomaticLinkDetectionEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isAutomaticLinkDetectionEnabled) }
	static var displaysLinkToolTips: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.displaysLinkToolTips) }
	static var usesRuler: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.usesRuler) }
	static var usesInspectorBar: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.usesInspectorBar) }
	static var selectionGranularity: TextViewName<Dynamic<NSSelectionGranularity>> { return .name(TextView.Binding.selectionGranularity) }
	static var insertionPointColor: TextViewName<Dynamic<NSColor>> { return .name(TextView.Binding.insertionPointColor) }
	static var selectedTextAttributes: TextViewName<Dynamic<[NSAttributedString.Key : Any]>> { return .name(TextView.Binding.selectedTextAttributes) }
	static var markedTextAttributes: TextViewName<Dynamic<[NSAttributedString.Key : Any]>> { return .name(TextView.Binding.markedTextAttributes) }
	static var linkTextAttributes: TextViewName<Dynamic<[NSAttributedString.Key : Any]>> { return .name(TextView.Binding.linkTextAttributes) }
	static var typingAttributes: TextViewName<Dynamic<[NSAttributedString.Key : Any]>> { return .name(TextView.Binding.typingAttributes) }
	static var isContinuousSpellCheckingEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isContinuousSpellCheckingEnabled) }
	static var isGrammarCheckingEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isGrammarCheckingEnabled) }
	static var usesFindPanel: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.usesFindPanel) }
	static var enabledTextCheckingTypes: TextViewName<Dynamic<NSTextCheckingTypes>> { return .name(TextView.Binding.enabledTextCheckingTypes) }
	static var isAutomaticDashSubstitutionEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isAutomaticDashSubstitutionEnabled) }
	static var isAutomaticDataDetectionEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isAutomaticDataDetectionEnabled) }
	static var isAutomaticSpellingCorrectionEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isAutomaticSpellingCorrectionEnabled) }
	static var isAutomaticTextReplacementEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isAutomaticTextReplacementEnabled) }
	static var layoutOrientation: TextViewName<Dynamic<NSLayoutManager.TextLayoutOrientation>> { return .name(TextView.Binding.layoutOrientation) }
	static var usesFindBar: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.usesFindBar) }
	static var isIncrementalSearchingEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isIncrementalSearchingEnabled) }
	static var allowsCharacterPickerTouchBarItem: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.allowsCharacterPickerTouchBarItem) }
	static var isAutomaticTextCompletionEnabled: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.isAutomaticTextCompletionEnabled) }
	static var usesRolloverButtonForSelection: TextViewName<Dynamic<Bool>> { return .name(TextView.Binding.usesRolloverButtonForSelection) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var selectRange: TextViewName<Signal<NSRange>> { return .name(TextView.Binding.selectRange) }
	static var selectAll: TextViewName<Signal<Void>> { return .name(TextView.Binding.selectAll) }
	static var copy: TextViewName<Signal<Void>> { return .name(TextView.Binding.copy) }
	static var cut: TextViewName<Signal<Void>> { return .name(TextView.Binding.cut) }
	static var paste: TextViewName<Signal<Void>> { return .name(TextView.Binding.paste) }
	static var copyFont: TextViewName<Signal<Void>> { return .name(TextView.Binding.copyFont) }
	static var pasteFont: TextViewName<Signal<Void>> { return .name(TextView.Binding.pasteFont) }
	static var copyRuler: TextViewName<Signal<Void>> { return .name(TextView.Binding.copyRuler) }
	static var pasteRuler: TextViewName<Signal<Void>> { return .name(TextView.Binding.pasteRuler) }
	static var delete: TextViewName<Signal<Void>> { return .name(TextView.Binding.delete) }
	static var changeFont: TextViewName<Signal<Void>> { return .name(TextView.Binding.changeFont) }
	static var alignCenter: TextViewName<Signal<Void>> { return .name(TextView.Binding.alignCenter) }
	static var alignLeft: TextViewName<Signal<Void>> { return .name(TextView.Binding.alignLeft) }
	static var alignRight: TextViewName<Signal<Void>> { return .name(TextView.Binding.alignRight) }
	static var superscript: TextViewName<Signal<Void>> { return .name(TextView.Binding.superscript) }
	static var `subscript`: TextViewName<Signal<Void>> { return .name(TextView.Binding.`subscript`) }
	static var unscript: TextViewName<Signal<Void>> { return .name(TextView.Binding.unscript) }
	static var underline: TextViewName<Signal<Void>> { return .name(TextView.Binding.underline) }
	static var checkSpelling: TextViewName<Signal<Void>> { return .name(TextView.Binding.checkSpelling) }
	static var showGuessPanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.showGuessPanel) }
	static var sizeToFit: TextViewName<Signal<Void>> { return .name(TextView.Binding.sizeToFit) }
	static var scrollRangeToVisible: TextViewName<Signal<NSRange>> { return .name(TextView.Binding.scrollRangeToVisible) }

	static var showFindIndicator: TextViewName<Signal<NSRange>> { return .name(TextView.Binding.showFindIndicator) }
	static var changeDocumentBackgroundColor: TextViewName<Signal<Void>> { return .name(TextView.Binding.changeDocumentBackgroundColor) }
	static var outline: TextViewName<Signal<Void>> { return .name(TextView.Binding.outline) }
	static var alignJustified: TextViewName<Signal<Void>> { return .name(TextView.Binding.alignJustified) }
	static var changeAttributes: TextViewName<Signal<Void>> { return .name(TextView.Binding.changeAttributes) }
	static var useStandardKerning: TextViewName<Signal<Void>> { return .name(TextView.Binding.useStandardKerning) }
	static var lowerBaseline: TextViewName<Signal<Void>> { return .name(TextView.Binding.lowerBaseline) }
	static var raiseBaseline: TextViewName<Signal<Void>> { return .name(TextView.Binding.raiseBaseline) }
	static var turnOffKerning: TextViewName<Signal<Void>> { return .name(TextView.Binding.turnOffKerning) }
	static var loosenKerning: TextViewName<Signal<Void>> { return .name(TextView.Binding.loosenKerning) }
	static var tightenKerning: TextViewName<Signal<Void>> { return .name(TextView.Binding.tightenKerning) }
	static var useStandardLigatures: TextViewName<Signal<Void>> { return .name(TextView.Binding.useStandardLigatures) }
	static var turnOffLigatures: TextViewName<Signal<Void>> { return .name(TextView.Binding.turnOffLigatures) }
	static var useAllLigatures: TextViewName<Signal<Void>> { return .name(TextView.Binding.useAllLigatures) }
	static var clicked: TextViewName<Signal<(Any, Int)>> { return .name(TextView.Binding.clicked) }
	static var pasteAsPlainText: TextViewName<Signal<Void>> { return .name(TextView.Binding.pasteAsPlainText) }
	static var pasteAsRichText: TextViewName<Signal<Void>> { return .name(TextView.Binding.pasteAsRichText) }
	static var breakUndoCoalescing: TextViewName<Signal<Void>> { return .name(TextView.Binding.breakUndoCoalescing) }
	static var setSpellingState: TextViewName<Signal<(NSAttributedString.SpellingState, NSRange)>> { return .name(TextView.Binding.setSpellingState) }
	static var orderFrontSharingServicePicker: TextViewName<Signal<Void>> { return .name(TextView.Binding.orderFrontSharingServicePicker) }
	static var startSpeaking: TextViewName<Signal<Void>> { return .name(TextView.Binding.startSpeaking) }
	static var stopSpeaking: TextViewName<Signal<Void>> { return .name(TextView.Binding.stopSpeaking) }
	static var performFindPanelAction: TextViewName<Signal<Void>> { return .name(TextView.Binding.performFindPanelAction) }
	static var orderFrontLinkPanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.orderFrontLinkPanel) }
	static var orderFrontListPanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.orderFrontListPanel) }
	static var orderFrontSpacingPanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.orderFrontSpacingPanel) }
	static var orderFrontTablePanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.orderFrontTablePanel) }
	static var orderFrontSubstitutionsPanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.orderFrontSubstitutionsPanel) }
	static var complete: TextViewName<Signal<Void>> { return .name(TextView.Binding.complete) }
	static var checkTextInDocument: TextViewName<Signal<Void>> { return .name(TextView.Binding.checkTextInDocument) }
	static var checkTextInSelection: TextViewName<Signal<Void>> { return .name(TextView.Binding.checkTextInSelection) }
	static var checkText: TextViewName<Signal<(NSRange, NSTextCheckingTypes, [NSSpellChecker.OptionKey: Any])>> { return .name(TextView.Binding.checkText) }
	static var updateQuickLookPreviewPanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.updateQuickLookPreviewPanel) }
	static var toggleQuickLookPreviewPanel: TextViewName<Signal<Void>> { return .name(TextView.Binding.toggleQuickLookPreviewPanel) }
	static var updateCandidates: TextViewName<Signal<Void>> { return .name(TextView.Binding.updateCandidates) }
	static var updateTextTouchBarItems: TextViewName<Signal<Void>> { return .name(TextView.Binding.updateTextTouchBarItems) }
	static var updateTouchBarItemIdentifiers: TextViewName<Signal<Void>> { return .name(TextView.Binding.updateTouchBarItemIdentifiers) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var didBeginEditing: TextViewName<SignalInput<NSTextView>> { return .name(TextView.Binding.didBeginEditing) }
	static var didChange: TextViewName<SignalInput<NSTextView>> { return .name(TextView.Binding.didChange) }
	static var didEndEditing: TextViewName<SignalInput<(NSTextView, NSTextMovement?)>> { return .name(TextView.Binding.didEndEditing) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var shouldBeginEditing: TextViewName<(NSTextView) -> Bool> { return .name(TextView.Binding.shouldBeginEditing) }
	static var shouldEndEditing: TextViewName<(NSTextView) -> Bool> { return .name(TextView.Binding.shouldEndEditing) }
	
	// Composite binding names
	static func font(_ void: Void = ()) -> BindingName<Dynamic<NSFont>, BinderBase.Binding, Binding> {
		return Binding.compositeName(
			value: { (x: Dynamic<NSFont>) -> (Any) -> Lifetime? in
				{ (instance: Any) -> Lifetime? in
					return x.apply(instance as! NSTextView) { (i: NSTextView, v: NSFont) -> Void in
						if (i.textStorage?.length ?? 0) == 0 {
							var attributes = i.typingAttributes
							attributes[NSAttributedString.Key.font] = v
							i.typingAttributes = attributes
						} else {
							i.textStorage?.addAttribute(NSAttributedString.Key.font, value: v, range: NSRange(location: 0, length: i.textStorage?.length ?? 0))
						}
					}
				}
			},
			binding: BinderBase.Binding.adHocFinalize,
			downcast: Binding.binderBaseBinding
		)
	}
	
	static func stringChanged(_ void: Void = ()) -> TextViewName<SignalInput<String>> {
		return Binding.compositeName(
			value: { (input: SignalInput<String>) in Input<NSTextView>().compactMap { $0.string }.bind(to: input) },
			binding: TextView.Binding.didChange,
			downcast: Binding.textViewBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TextViewConvertible: ViewConvertible {
	func nsTextView() -> TextView.Instance
}
extension TextViewConvertible {
	public func nsView() -> View.Instance { return nsTextView() }
}
extension NSTextView: TextViewConvertible, HasDelegate {
	public func nsTextView() -> TextView.Instance { return self }
}
public extension TextView {
	func nsTextView() -> TextView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TextViewBinding: ViewBinding {
	static func textViewBinding(_ binding: TextView.Binding) -> Self
}
public extension TextViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return textViewBinding(.inheritedBinding(binding))
	}
}
public extension TextView.Binding {
	typealias Preparer = TextView.Preparer
	static func textViewBinding(_ binding: TextView.Binding) -> TextView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
