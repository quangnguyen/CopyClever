//
//  PanelController.h
//  Pasteboard
//
//  Created by Quang Nguyen on 18/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusItemView.h"
#import "PopupMenuController.h"
#import "GroupMenuController.h"
#import "TableController.h"
#import "ChangeGroupNameSheetController.h"

@interface MainWindowController : NSWindowController <NSWindowDelegate> {
    BOOL _isMainWindowActive;
}

@property (nonatomic) IBOutlet PopupMenuController* popupMenuController;
@property (nonatomic) IBOutlet GroupMenuController* groupMenuController;
@property (nonatomic) IBOutlet TableController* tableController;
@property (nonatomic) IBOutlet NSMenu* popupMenu;
@property (nonatomic) IBOutlet NSButton* settingsButton;
@property (weak) IBOutlet NSSegmentedControl* groupControl;
@property (weak) IBOutlet NSButton* plainTextButton;
@property (weak) IBOutlet NSButton* searchButton;
@property (weak) IBOutlet NSLayoutConstraint* searchViewAreaHeightConstraint;
@property (weak) IBOutlet NSSearchField* searchField;
@property (weak) IBOutlet NSView* searchFieldContainer;
@property (weak) IBOutlet NSScrollView* tableContainerView;

@property (strong) ChangeGroupNameSheetController* changeGroupNameSheetController;
@property (nonatomic) BOOL isMainWindowActive;
@property (nonatomic, setter=setPastePlainText:) BOOL isPastePlainText;

- (IBAction)didTapOpenButton:(id)sender;
- (IBAction)showPopupMenu:(id)sender;
- (IBAction)togglePlainTextButton:(NSButton*)sender;
- (IBAction)showSearchView:(id)sender;

- (void)toggleMainWindow;
- (void)setGroupControlColor:(NSInteger)colorIndex;
- (void)openPanel;
- (void)closePanel;

@end