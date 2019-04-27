//
//  CwlTextView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(macOS)

extension BindingParser where Downcast: TextViewBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TextView.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTextViewBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var string: BindingParser<Dynamic<String>, TextView.Binding, Downcast> { return .init(extract: { if case .string(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var backgroundColor: BindingParser<Dynamic<NSColor>, TextView.Binding, Downcast> { return .init(extract: { if case .backgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var drawsBackground: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .drawsBackground(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isEditable: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isEditable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isSelectable: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isSelectable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isFieldEditor: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isFieldEditor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isRichText: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isRichText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var importsGraphics: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .importsGraphics(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var usesFontPanel: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .usesFontPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var font: BindingParser<Dynamic<NSFont>, TextView.Binding, Downcast> { return .init(extract: { if case .font(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var alignment: BindingParser<Dynamic<NSTextAlignment>, TextView.Binding, Downcast> { return .init(extract: { if case .alignment(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var textColor: BindingParser<Dynamic<NSColor>, TextView.Binding, Downcast> { return .init(extract: { if case .textColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var baseWritingDirection: BindingParser<Dynamic<NSWritingDirection>, TextView.Binding, Downcast> { return .init(extract: { if case .baseWritingDirection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var maxSize: BindingParser<Dynamic<NSSize>, TextView.Binding, Downcast> { return .init(extract: { if case .maxSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var minSize: BindingParser<Dynamic<NSSize>, TextView.Binding, Downcast> { return .init(extract: { if case .minSize(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isVerticallyResizable: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isVerticallyResizable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isHorizontallyResizable: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isHorizontallyResizable(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	public static var textContainerInset: BindingParser<Dynamic<NSSize>, TextView.Binding, Downcast> { return .init(extract: { if case .textContainerInset(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var allowsDocumentBackgroundColorChange: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .allowsDocumentBackgroundColorChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var allowsUndo: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .allowsUndo(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var defaultParagraphStyle: BindingParser<Dynamic<NSParagraphStyle>, TextView.Binding, Downcast> { return .init(extract: { if case .defaultParagraphStyle(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var allowsImageEditing: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .allowsImageEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isAutomaticQuoteSubstitutionEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isAutomaticQuoteSubstitutionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isAutomaticLinkDetectionEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isAutomaticLinkDetectionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var displaysLinkToolTips: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .displaysLinkToolTips(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var usesRuler: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .usesRuler(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var usesInspectorBar: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .usesInspectorBar(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var selectionGranularity: BindingParser<Dynamic<NSSelectionGranularity>, TextView.Binding, Downcast> { return .init(extract: { if case .selectionGranularity(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var insertionPointColor: BindingParser<Dynamic<NSColor>, TextView.Binding, Downcast> { return .init(extract: { if case .insertionPointColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var selectedTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key : Any]>, TextView.Binding, Downcast> { return .init(extract: { if case .selectedTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var markedTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key : Any]>, TextView.Binding, Downcast> { return .init(extract: { if case .markedTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var linkTextAttributes: BindingParser<Dynamic<[NSAttributedString.Key : Any]>, TextView.Binding, Downcast> { return .init(extract: { if case .linkTextAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var typingAttributes: BindingParser<Dynamic<[NSAttributedString.Key : Any]>, TextView.Binding, Downcast> { return .init(extract: { if case .typingAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isContinuousSpellCheckingEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isContinuousSpellCheckingEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isGrammarCheckingEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isGrammarCheckingEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var usesFindPanel: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .usesFindPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var enabledTextCheckingTypes: BindingParser<Dynamic<NSTextCheckingTypes>, TextView.Binding, Downcast> { return .init(extract: { if case .enabledTextCheckingTypes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isAutomaticDashSubstitutionEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isAutomaticDashSubstitutionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isAutomaticDataDetectionEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isAutomaticDataDetectionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isAutomaticSpellingCorrectionEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isAutomaticSpellingCorrectionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isAutomaticTextReplacementEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isAutomaticTextReplacementEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var layoutOrientation: BindingParser<Dynamic<NSLayoutManager.TextLayoutOrientation>, TextView.Binding, Downcast> { return .init(extract: { if case .layoutOrientation(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var usesFindBar: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .usesFindBar(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isIncrementalSearchingEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isIncrementalSearchingEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var allowsCharacterPickerTouchBarItem: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .allowsCharacterPickerTouchBarItem(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var isAutomaticTextCompletionEnabled: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .isAutomaticTextCompletionEnabled(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var usesRolloverButtonForSelection: BindingParser<Dynamic<Bool>, TextView.Binding, Downcast> { return .init(extract: { if case .usesRolloverButtonForSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	public static var selectRange: BindingParser<Signal<NSRange>, TextView.Binding, Downcast> { return .init(extract: { if case .selectRange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var selectAll: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .selectAll(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var copy: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .copy(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var cut: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .cut(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var paste: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .paste(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var copyFont: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .copyFont(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var pasteFont: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .pasteFont(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var copyRuler: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .copyRuler(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var pasteRuler: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .pasteRuler(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var delete: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .delete(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var changeFont: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .changeFont(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var alignCenter: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .alignCenter(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var alignLeft: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .alignLeft(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var alignRight: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .alignRight(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var superscript: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .superscript(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var `subscript`: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .`subscript`(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var unscript: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .unscript(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var underline: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .underline(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var checkSpelling: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .checkSpelling(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var showGuessPanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .showGuessPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var sizeToFit: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .sizeToFit(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var scrollRangeToVisible: BindingParser<Signal<NSRange>, TextView.Binding, Downcast> { return .init(extract: { if case .scrollRangeToVisible(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	public static var showFindIndicator: BindingParser<Signal<NSRange>, TextView.Binding, Downcast> { return .init(extract: { if case .showFindIndicator(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var changeDocumentBackgroundColor: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .changeDocumentBackgroundColor(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var outline: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .outline(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var alignJustified: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .alignJustified(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var changeAttributes: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .changeAttributes(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var useStandardKerning: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .useStandardKerning(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var lowerBaseline: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .lowerBaseline(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var raiseBaseline: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .raiseBaseline(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var turnOffKerning: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .turnOffKerning(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var loosenKerning: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .loosenKerning(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var tightenKerning: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .tightenKerning(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var useStandardLigatures: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .useStandardLigatures(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var turnOffLigatures: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .turnOffLigatures(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var useAllLigatures: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .useAllLigatures(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var clicked: BindingParser<Signal<(Any, Int)>, TextView.Binding, Downcast> { return .init(extract: { if case .clicked(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var pasteAsPlainText: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .pasteAsPlainText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var pasteAsRichText: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .pasteAsRichText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var breakUndoCoalescing: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .breakUndoCoalescing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var setSpellingState: BindingParser<Signal<(NSAttributedString.SpellingState, NSRange)>, TextView.Binding, Downcast> { return .init(extract: { if case .setSpellingState(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var orderFrontSharingServicePicker: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .orderFrontSharingServicePicker(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var startSpeaking: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .startSpeaking(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var stopSpeaking: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .stopSpeaking(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var performFindPanelAction: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .performFindPanelAction(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var orderFrontLinkPanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .orderFrontLinkPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var orderFrontListPanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .orderFrontListPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var orderFrontSpacingPanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .orderFrontSpacingPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var orderFrontTablePanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .orderFrontTablePanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var orderFrontSubstitutionsPanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .orderFrontSubstitutionsPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var complete: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .complete(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var checkTextInDocument: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .checkTextInDocument(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var checkTextInSelection: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .checkTextInSelection(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var checkText: BindingParser<Signal<(NSRange, NSTextCheckingTypes, [NSSpellChecker.OptionKey: Any])>, TextView.Binding, Downcast> { return .init(extract: { if case .checkText(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var updateQuickLookPreviewPanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .updateQuickLookPreviewPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var toggleQuickLookPreviewPanel: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .toggleQuickLookPreviewPanel(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var updateCandidates: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .updateCandidates(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var updateTextTouchBarItems: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .updateTextTouchBarItems(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var updateTouchBarItemIdentifiers: BindingParser<Signal<Void>, TextView.Binding, Downcast> { return .init(extract: { if case .updateTouchBarItemIdentifiers(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	// 3. Action bindings are triggered by the object after construction.
	public static var didBeginEditing: BindingParser<SignalInput<NSTextView>, TextView.Binding, Downcast> { return .init(extract: { if case .didBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var didChange: BindingParser<SignalInput<NSTextView>, TextView.Binding, Downcast> { return .init(extract: { if case .didChange(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var didEndEditing: BindingParser<SignalInput<(NSTextView, NSTextMovement?)>, TextView.Binding, Downcast> { return .init(extract: { if case .didEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	public static var shouldBeginEditing: BindingParser<(NSTextView) -> Bool, TextView.Binding, Downcast> { return .init(extract: { if case .shouldBeginEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
	public static var shouldEndEditing: BindingParser<(NSTextView) -> Bool, TextView.Binding, Downcast> { return .init(extract: { if case .shouldEndEditing(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTextViewBinding() }) }
}

#endif
