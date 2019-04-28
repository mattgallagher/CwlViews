# CwlViews

A series of wrappers around the AppKit/UIKit views that adapt them into a declaratively constructed, reactive signal driven framework.

CwlViews requires Swift 5 or newer and targets macOS 10.13 or iOS 11 or newer.

## Usage

There are a number of ways that CwlViews can be included in a project. 

For quickly starting new projects, the "Xcode templates with embedded inclusion" approach is often simplest – it installs Xcode project templates that embed the required CwlViews files directly into newly created CwlViews apps or CwlViews playgrounds. The biggest downside to this approach is that cleaning and rebuilding your project requires rebuilding the CwlViews files too.

For inclusion in existing projects or to keep CwlViews in a separate framework (for compilation performance and dependency management advantages) then use one of the "Manual framework inclusion", "Carthage" or "CocoaPods" approaches.

### Xcode templates with embedded inclusion

1. Clone or download the CwlViews repository to your computer.
2. Using Terminal, `cd` to the `Scripts` directory in the CwlViews repository.
3. Run `./install_cwlviews_templates.swift`
4. Open Xcode and from the "File" menu, select "New" &rarr; "Project..."
5. Choose iOS or macOS as desired from the tabs at the top.
6. From the "Application" section, select "CwlViews".

The project template includes some sample code and includes the contents of the CwlViews framework in the "Dependencies" folder. Since these files are directly included in the application, you do not need to use `import` statements at the top of your Swift files to use them.

### Manual framework inclusion

1. In a subdirectory of your project's directory, run `git clone https://github.com/mattgallagher/CwlViews.git`
2. Drag the "CwlViews.xcodeproj" file from the Finder into your own project's file tree in Xcode
3. Click on your project in the file tree to access project settings and click on the target to which you want to add CwlViews.
5. Click on the "Build Phases" tab
6. Add a "Target dependency" for CwlViews_iOS or CwlViews_macOS (depending on whether your target builds for iOS or Mac)
7. If you don't already have a "Copy Files" build phase with a "Destination: Frameworks", add one using the "+" in the top left of the tab.
8. Add the "CwlViews.framework", "CwlSignal.framework" and "CwlUtils.framework" to the "Copy Files, Destination: Frameworks" step. NOTE: there may be multiple "CwlViews.framework" files in the list, including one for macOS and one for iOS. You should select the "CwlViews.framework" that appears *above* the corresponding CwlViews macOS or iOS testing target.
9. In Swift files where you want to use CwlViews, CwlSignal or CwlUtils code, simply write `import CwlViews` at the top (all three frameworks will be imported by this single statement).

Adding the "CwlViews.xcodeproj" file to your project's file tree will also add all of its schemes to your scheme list in Xcode. You can hide these from your scheme list from the menubar by selecting "Product" &rarr; "Scheme" &rarr; "Manage Schemes" (or typing Command-Shift-,) and unselecting the checkboxes in the "Show" column next to the CwlViews, CwlSignal and CwlUtils scheme names.

### Carthage

Add the following line to your Cartfile:

    git "https://github.com/mattgallagher/CwlViews.git" "master"

Follow the remaining steps that Carthage requires to fetch and build dependencies. You will need to add the "CwlViews.framework", "CwlSignal.framework" and "CwlUtils.framework" to the copy frameworks phase of your target.

### CocoaPods

Add the following lines to your target in your "Podfile":

    pod 'CwlViews', '~> 0.1.0'
    pod 'CwlSignal', '~> 2.2.0'
    pod 'CwlUtils', '~> 2.2.0'

