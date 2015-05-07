//
//  TableController.h
//  CopyClever
//
//  Created by Quang Nguyen on 19/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Foundation/Foundation.h>
#import "PasteboardController.h"
#import "CommandActionController.h"
#import "PasteboardItem.h"
#import "TableView.h"
#import "GroupMenuController.h"

extern int const IMAGE_ITEM;
extern int const PLAIN_TEXT_ITEM;
extern int const RICH_TEXT_ITEM;
extern int const PATH_ITEM;

@interface TableController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, QuickLookTableViewDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate> {
    NSPopover* _popover;
}

@property IBOutlet NSArrayController* arrayController;
@property IBOutlet TableView* tableView;
@property IBOutlet NSSearchField* searchField;
@property (weak) IBOutlet NSButton* favoriteButton;
@property (weak) IBOutlet NSButton* deleteButton;
@property (weak) IBOutlet NSButton* quickLookButton;
@property (weak) IBOutlet GroupMenuController* groupMenuController;

- (BOOL)copySelectedItemToPasteboard;
- (void)removeObjectsAtIndexes:(NSIndexSet*)indexes;
- (IBAction)clickOnGroupSegmentButton:(id)sender;
- (IBAction)clickOnGroupButtonInCell:(id)sender;
- (IBAction)clickOnClearGroup:(id)sender;
- (IBAction)clickOnCopyButton:(id)sender;
- (IBAction)clickOnPreviewButton:(id)sender;
- (IBAction)clickOnDeleteButton:(id)sender;

@end
