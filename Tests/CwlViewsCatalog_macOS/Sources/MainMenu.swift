//
//  MainMenu.swift
//  CwlViews
//
//  Created by Matt Gallagher on 1/22/17.
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

import CwlViews
import CoreMedia

func mainMenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(.submenu -- applicationMenu()),
			MenuItem(.submenu -- fileMenu()),
			MenuItem(.submenu -- editMenu()),
			MenuItem(.submenu -- formatMenu()),
			MenuItem(.submenu -- viewMenu()),
			MenuItem(.submenu -- windowsMenu()),
			MenuItem(.submenu -- helpMenu()),
		]
	)
}

fileprivate let executableName = (Bundle.main.localizedInfoDictionary?[kCFBundleNameKey as String] as? String) ?? (Bundle.main.localizedInfoDictionary?[kCFBundleExecutableKey as String] as? String) ?? ProcessInfo.processInfo.processName

func applicationMenu() -> Menu {
	return Menu(
		.systemName -- .apple,
		.title -- executableName,
		.items -- [
			MenuItem(
				.title -- String(format: NSLocalizedString("About %@", tableName: "MainMenu", comment: "Application menu item"), executableName),
				.action --> #selector(NSApplication.orderFrontStandardAboutPanel(_:))
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Preferences…", tableName: "MainMenu", comment: "Application menu item"),
				.keyEquivalent -- ","
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Services", tableName: "MainMenu", comment: "Application menu item"),
				.submenu -- Menu(.systemName -- .services)
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- String(format: NSLocalizedString("Hide %@", tableName: "MainMenu", comment: "Application menu item"), executableName),
				.action --> #selector(NSApplication.hide(_:)),
				.keyEquivalent -- "h"
			),
			MenuItem(
				.title -- NSLocalizedString("Hide Others", tableName: "MainMenu", comment: "Application menu item"),
				.action --> #selector(NSApplication.hideOtherApplications(_:)),
				.keyEquivalent -- "h",
				.keyEquivalentModifierMask -- [.option, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Show All", tableName: "MainMenu", comment: "Application menu item"),
				.action --> #selector(NSApplication.unhideAllApplications(_:))
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- String(format: NSLocalizedString("Quit %@", tableName: "MainMenu", comment: "Application menu item"), executableName),
				.action --> #selector(NSApplication.terminate(_:)),
				.keyEquivalent -- "q"
			)
		]
	)
}

func fileMenu() -> Menu {
	return Menu(
		.title -- NSLocalizedString("File", tableName: "MainMenu", comment: "Standard menu title"),
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("New", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSDocumentController.newDocument(_:)),
				.keyEquivalent -- "n"
			),
			MenuItem(
				.title -- NSLocalizedString("Open…", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSDocumentController.openDocument(_:)),
				.keyEquivalent -- "o"
			),
			MenuItem(
				.title -- NSLocalizedString("Open Recent", tableName: "MainMenu", comment: "File menu item"),
				.submenu -- Menu(
					.systemName -- .recentDocuments,
					.items -- [
						MenuItem(
							.title -- NSLocalizedString("Clear Menu", tableName: "MainMenu", comment: "File menu item"),
							.action --> #selector(NSDocumentController.clearRecentDocuments(_:))
						)
					]
				)
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Close", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSWindow.performClose(_:)),
				.keyEquivalent -- "w"
			),
			MenuItem(
				.title -- NSLocalizedString("Save…", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSDocument.save(_:)),
				.keyEquivalent -- "s"
			),
			MenuItem(
				.title -- NSLocalizedString("Save As…", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSDocument.saveAs(_:)),
				.keyEquivalent -- "s",
				.keyEquivalentModifierMask -- [.shift, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Revert to Saved", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSDocument.revertToSaved(_:)),
				.keyEquivalent -- "r"
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Page Setup…", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSDocument.runPageLayout(_:)),
				.keyEquivalent -- "p",
				.keyEquivalentModifierMask -- [.shift, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Print…", tableName: "MainMenu", comment: "File menu item"),
				.action --> #selector(NSDocument.printDocument),
				.keyEquivalent -- "p"
			)
		]
	)
}

func editMenu() -> Menu {
	return Menu(
		.title -- NSLocalizedString("Edit", tableName: "MainMenu", comment: "Standard menu title"),
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Undo", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> Selector(("undo:")),
				.keyEquivalent -- "z"
			),
			MenuItem(
				.title -- NSLocalizedString("Redo", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> Selector(("redo:")),
				.keyEquivalent -- "Z",
				.keyEquivalentModifierMask -- [.shift, .command]
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Cut", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> #selector(NSText.cut(_:)),
				.keyEquivalent -- "x"
			),
			MenuItem(
				.title -- NSLocalizedString("Copy", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> #selector(NSText.copy(_:)),
				.keyEquivalent -- "c"
			),
			MenuItem(
				.title -- NSLocalizedString("Paste", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> #selector(NSText.paste(_:)),
				.keyEquivalent -- "v"
			),
			MenuItem(
				.title -- NSLocalizedString("Paste and Match Style", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> #selector(NSTextView.pasteAsPlainText(_:)),
				.keyEquivalent -- "v",
				.keyEquivalentModifierMask -- [.shift, .option, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Delete", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> #selector(NSText.delete(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Select All", tableName: "MainMenu", comment: "Edit menu item"),
				.action --> #selector(NSText.selectAll(_:)),
				.keyEquivalent -- "a"
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Find", tableName: "MainMenu", comment: "Edit menu item"),
				.submenu -- findSubmenu()
			),
			MenuItem(
				.title -- NSLocalizedString("Spelling and Grammar", tableName: "MainMenu", comment: "Edit menu item"),
				.submenu -- spellingAndGrammarSubmenu()
			),
			MenuItem(
				.title -- NSLocalizedString("Substitutions", tableName: "MainMenu", comment: "Edit menu item"),
				.submenu -- substitutionsSubmenu()
			),
			MenuItem(
				.title -- NSLocalizedString("Transformations", tableName: "MainMenu", comment: "Edit menu item"),
				.submenu -- transformationsSubmenu()
			),
			MenuItem(
				.title -- NSLocalizedString("Speech", tableName: "MainMenu", comment: "Edit menu item"),
				.submenu -- speechSubmenu() 
			)
		]
	)
}

func formatMenu() -> Menu {
	return Menu(
		.title -- NSLocalizedString("Format", tableName: "MainMenu", comment: "Standard menu title"),
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Font", tableName: "MainMenu", comment: "Format menu item"),
				.submenu -- fontSubmenu()
			),
			MenuItem(
				.title -- NSLocalizedString("Text", tableName: "MainMenu", comment: "Format menu item"),
				.submenu -- textSubmenu()
			)
		]
	)
}

func viewMenu() -> Menu {
	return Menu(
		.title -- NSLocalizedString("View", tableName: "MainMenu", comment: "Standard menu title"),
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Show Toolbar", tableName: "MainMenu", comment: "View menu item"),
				.action --> #selector(NSWindow.toggleToolbarShown(_:)),
				.keyEquivalent -- "t",
				.keyEquivalentModifierMask -- [.option, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Customize Toolbar…", tableName: "MainMenu", comment: "View menu item"),
				.action --> #selector(NSWindow.runToolbarCustomizationPalette(_:))
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Show Sidebar", tableName: "MainMenu", comment: "View menu item"),
				.action --> NSSelectorFromString("toggleSourceList:"),
				.keyEquivalent -- "s",
				.keyEquivalentModifierMask -- [.control, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Enter Full Screen", tableName: "MainMenu", comment: "View menu item"),
				.action --> #selector(NSWindow.toggleFullScreen(_:)),
				.keyEquivalent -- "f",
				.keyEquivalentModifierMask -- [.control, .command]
			)
		]
	)
}

func windowsMenu() -> Menu {
	return Menu(
		.systemName -- .windows,
		.title -- NSLocalizedString("Window", tableName: "MainMenu", comment: "Standard menu title"),
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Minimize", tableName: "MainMenu", comment: "Window menu item"),
				.action --> #selector(NSWindow.performMiniaturize(_:)),
				.keyEquivalent -- "m"
			),
			MenuItem(
				.title -- NSLocalizedString("Zoom", tableName: "MainMenu", comment: "Window menu item"),
				.action --> #selector(NSWindow.performZoom(_:))
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Bring All to Front", tableName: "MainMenu", comment: "Window menu item"),
				.action --> #selector(NSApplication.arrangeInFront(_:)),
				.keyEquivalent -- "s",
				.keyEquivalentModifierMask -- [.control, .command]
			)
		]
	)
}

func helpMenu() -> Menu {
	return Menu(
		.systemName -- .help,
		.title -- NSLocalizedString("Help", tableName: "MainMenu", comment: "Standard menu title"),
		.items -- [
			MenuItem(
				.title -- String(format: NSLocalizedString("%@ Help", tableName: "MainMenu", comment: "Help menu item"), executableName),
				.action --> #selector(NSApplication.showHelp(_:)),
				.keyEquivalent -- "?"
			)
		]
	)
}

func findSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Find…", tableName: "MainMenu", comment: "Find menu item"),
				.action --> #selector(NSTextView.performFindPanelAction(_:)),
				.keyEquivalent -- "f",
				.tag -- 1
			),
			MenuItem(
				.title -- NSLocalizedString("Find and Replace…", tableName: "MainMenu", comment: "Find menu item"),
				.action --> #selector(NSTextView.performFindPanelAction(_:)),
				.keyEquivalent -- "f",
				.keyEquivalentModifierMask -- [.option, .command],
				.tag -- 12
			),
			MenuItem(
				.title -- NSLocalizedString("Find Next", tableName: "MainMenu", comment: "Find menu item"),
				.action --> #selector(NSTextView.performFindPanelAction(_:)),
				.keyEquivalent -- "g",
				.tag -- 2
			),
			MenuItem(
				.title -- NSLocalizedString("Find Previous", tableName: "MainMenu", comment: "Find menu item"),
				.action --> #selector(NSTextView.performFindPanelAction(_:)),
				.keyEquivalent -- "g",
				.keyEquivalentModifierMask -- [.shift, .command],
				.tag -- 3
			),
			MenuItem(
				.title -- NSLocalizedString("Use Selection for Find", tableName: "MainMenu", comment: "Find menu item"),
				.action --> #selector(NSTextView.performFindPanelAction(_:)),
				.keyEquivalent -- "e",
				.tag -- 7
			),
			MenuItem(
				.title -- NSLocalizedString("Jump to Selection", tableName: "MainMenu", comment: "Find menu item"),
				.action --> #selector(NSResponder.centerSelectionInVisibleArea(_:)),
				.keyEquivalent -- "j"
			)
		]
	)
}

func spellingAndGrammarSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Show Spelling and Grammar", tableName: "MainMenu", comment: "Spelling menu item"),
				.action --> #selector(NSText.showGuessPanel(_:)),
				.keyEquivalent -- ":"
			),
			MenuItem(
				.title -- NSLocalizedString("Check Document Now", tableName: "MainMenu", comment: "Spelling menu item"),
				.action --> #selector(NSText.checkSpelling(_:)),
				.keyEquivalent -- ";"
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Check Spelling While Typing", tableName: "MainMenu", comment: "Spelling menu item"),
				.action --> #selector(NSTextView.toggleContinuousSpellChecking(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Check Grammar With Spelling", tableName: "MainMenu", comment: "Spelling menu item"),
				.action --> #selector(NSTextView.toggleGrammarChecking(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Correct Spelling Automatically", tableName: "MainMenu", comment: "Spelling menu item"),
				.action --> #selector(NSTextView.toggleAutomaticSpellingCorrection(_:))
			)
		]
	)
}

func substitutionsSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Show Substitutions", tableName: "MainMenu", comment: "Substitutions menu item"),
				.action --> #selector(NSTextView.orderFrontSubstitutionsPanel(_:)),
				.keyEquivalent -- ":"
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Smart Copy/Paste", tableName: "MainMenu", comment: "Substitutions menu item"),
				.action --> #selector(NSTextView.toggleSmartInsertDelete(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Smart Quotes", tableName: "MainMenu", comment: "Substitutions menu item"),
				.action --> #selector(NSTextView.toggleAutomaticQuoteSubstitution(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Smart Dashes", tableName: "MainMenu", comment: "Substitutions menu item"),
				.action --> #selector(NSTextView.toggleAutomaticDashSubstitution(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Smart Links", tableName: "MainMenu", comment: "Substitutions menu item"),
				.action --> #selector(NSTextView.toggleAutomaticLinkDetection(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Data Detectors", tableName: "MainMenu", comment: "Substitutions menu item"),
				.action --> #selector(NSTextView.toggleAutomaticDataDetection(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Text Replacement", tableName: "MainMenu", comment: "Substitutions menu item"),
				.action --> #selector(NSTextView.toggleAutomaticTextReplacement(_:))
			)
		]
	)
}

func transformationsSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Make Upper Case", tableName: "MainMenu", comment: "Tubstitutions menu item"),
				.action --> #selector(NSResponder.uppercaseWord(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Make Lower Case", tableName: "MainMenu", comment: "Tubstitutions menu item"),
				.action --> #selector(NSResponder.lowercaseWord(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Capitalize", tableName: "MainMenu", comment: "Tubstitutions menu item"),
				.action --> #selector(NSResponder.capitalizeWord(_:))
			)
		]
	)
}

func speechSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Start Speaking", tableName: "MainMenu", comment: "Speech menu item"),
				.action --> #selector(NSTextView.startSpeaking(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Stop Speaking", tableName: "MainMenu", comment: "Speech menu item"),
				.action --> #selector(NSTextView.stopSpeaking(_:))
			)
		]
	)
}

func fontSubmenu() -> Menu {
	return Menu(
		.systemName -- .font,
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Show Fonts", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSFontManager.orderFrontFontPanel(_:)),
				.keyEquivalent -- "t"
			),
			MenuItem(
				.title -- NSLocalizedString("Bold", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSFontManager.addFontTrait(_:)),
				.keyEquivalent -- "b",
				.tag -- 2
			),
			MenuItem(
				.title -- NSLocalizedString("Italic", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSFontManager.addFontTrait(_:)),
				.keyEquivalent -- "i",
				.tag -- 1
			),
			MenuItem(
				.title -- NSLocalizedString("Underline", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSText.underline(_:)),
				.keyEquivalent -- "u"
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Bigger", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSFontManager.modifyFont(_:)),
				.keyEquivalent -- "+",
				.tag -- 3
			),
			MenuItem(
				.title -- NSLocalizedString("Smaller", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSFontManager.modifyFont(_:)),
				.keyEquivalent -- "-",
				.tag -- 4
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Kern", tableName: "MainMenu", comment: "Font menu item"),
				.submenu -- kernSubmenu()
			),
			MenuItem(
				.title -- NSLocalizedString("Ligatures", tableName: "MainMenu", comment: "Font menu item"),
				.submenu -- ligaturesSubmenu()
			),
			MenuItem(
				.title -- NSLocalizedString("Baseline", tableName: "MainMenu", comment: "Font menu item"),
				.submenu -- baselineSubmenu()
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Show Colors", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSApplication.orderFrontColorPanel(_:)),
				.keyEquivalent -- "c",
				.keyEquivalentModifierMask -- [.shift, .command]
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Copy Style", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSText.copyFont(_:)),
				.keyEquivalent -- "c",
				.keyEquivalentModifierMask -- [.option, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Paste Style", tableName: "MainMenu", comment: "Font menu item"),
				.action --> #selector(NSText.pasteFont(_:)),
				.keyEquivalent -- "v",
				.keyEquivalentModifierMask -- [.option, .command]
			)
		]
	)
}

func textSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Align Left", tableName: "MainMenu", comment: "Text menu item"),
				.action --> #selector(NSText.alignLeft(_:)),
				.keyEquivalent -- "{"
			),
			MenuItem(
				.title -- NSLocalizedString("Center", tableName: "MainMenu", comment: "Text menu item"),
				.action --> #selector(NSText.alignCenter(_:)),
				.keyEquivalent -- "|"
			),
			MenuItem(
				.title -- NSLocalizedString("Justify", tableName: "MainMenu", comment: "Text menu item"),
				.action --> #selector(NSTextView.alignJustified(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Align Right", tableName: "MainMenu", comment: "Text menu item"),
				.action --> #selector(NSText.alignLeft(_:)),
				.keyEquivalent -- "}"
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Writing Direction", tableName: "MainMenu", comment: "Text menu item"),
				.submenu -- writingDirectionSubmenu()
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Show Ruler", tableName: "MainMenu", comment: "Text menu item"),
				.action --> #selector(NSText.toggleRuler(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Copy Ruler", tableName: "MainMenu", comment: "Text menu item"),
				.action --> #selector(NSText.copyRuler(_:)),
				.keyEquivalent -- "c",
				.keyEquivalentModifierMask -- [.control, .command]
			),
			MenuItem(
				.title -- NSLocalizedString("Paste Ruler", tableName: "MainMenu", comment: "Text menu item"),
				.action --> #selector(NSText.pasteRuler(_:)),
				.keyEquivalent -- "v",
				.keyEquivalentModifierMask -- [.control, .command]
			)
		]
	)
}

func kernSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Use Default", tableName: "MainMenu", comment: "Kern menu item"),
				.action --> #selector(NSTextView.useStandardKerning(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Use None", tableName: "MainMenu", comment: "Kern menu item"),
				.action --> #selector(NSTextView.turnOffKerning(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Tighten", tableName: "MainMenu", comment: "Kern menu item"),
				.action --> #selector(NSTextView.tightenKerning(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Loosen", tableName: "MainMenu", comment: "Kern menu item"),
				.action --> #selector(NSTextView.loosenKerning(_:))
			)
		]
	)
}

func ligaturesSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Use Default", tableName: "MainMenu", comment: "Ligatures menu item"),
				.action --> #selector(NSTextView.useStandardLigatures(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Use None", tableName: "MainMenu", comment: "Ligatures menu item"),
				.action --> #selector(NSTextView.turnOffLigatures(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Use All", tableName: "MainMenu", comment: "Ligatures menu item"),
				.action --> #selector(NSTextView.useAllLigatures(_:))
			)
		]
	)
}

func baselineSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Use Default", tableName: "MainMenu", comment: "Baseline menu item"),
				.action --> #selector(NSTextView.unscript(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Superscript", tableName: "MainMenu", comment: "Baseline menu item"),
				.action --> #selector(NSTextView.superscript(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Subscript", tableName: "MainMenu", comment: "Baseline menu item"),
				.action --> #selector(NSTextView.subscript(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Raise", tableName: "MainMenu", comment: "Baseline menu item"),
				.action --> #selector(NSTextView.raiseBaseline(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("Lower", tableName: "MainMenu", comment: "Baseline menu item"),
				.action --> #selector(NSTextView.lowerBaseline(_:))
			)
		]
	)
}

func writingDirectionSubmenu() -> Menu {
	return Menu(
		.items -- [
			MenuItem(
				.title -- NSLocalizedString("Paragraph", tableName: "MainMenu", comment: "Writing direction menu item"),
				.isEnabled -- false
			),
			MenuItem(
				.title -- NSLocalizedString("\tDefault", tableName: "MainMenu", comment: "Writing direction menu item"),
				.action --> #selector(NSResponder.makeBaseWritingDirectionNatural(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("\tLeft to Right", tableName: "MainMenu", comment: "Writing direction menu item"),
				.action --> #selector(NSResponder.makeBaseWritingDirectionLeftToRight(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("\tRight to Left", tableName: "MainMenu", comment: "Writing direction menu item"),
				.action --> #selector(NSResponder.makeBaseWritingDirectionRightToLeft(_:))
			),
			NSMenuItem.separator(),
			MenuItem(
				.title -- NSLocalizedString("Selection", tableName: "MainMenu", comment: "Writing direction menu item"),
				.isEnabled -- false
			),
			MenuItem(
				.title -- NSLocalizedString("\tDefault", tableName: "MainMenu", comment: "Writing direction menu item"),
				.action --> #selector(NSResponder.makeTextWritingDirectionNatural(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("\tLeft to Right", tableName: "MainMenu", comment: "Writing direction menu item"),
				.action --> #selector(NSResponder.makeTextWritingDirectionLeftToRight(_:))
			),
			MenuItem(
				.title -- NSLocalizedString("\tRight to Left", tableName: "MainMenu", comment: "Writing direction menu item"),
				.action --> #selector(NSResponder.makeTextWritingDirectionRightToLeft(_:))
			)
		]
	)
}
