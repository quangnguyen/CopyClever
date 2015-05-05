//
//  GroupMenuController.h
//  CopyClever
//
//  Created by Quang Nguyen on 2/21/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSInteger const RED;
extern NSInteger const ORANGE;
extern NSInteger const YELLOW;
extern NSInteger const GREEN;
extern NSInteger const BLUE;
extern NSInteger const PURPLE;
extern NSInteger const GREY;
extern NSString* const CCInitTagColor;

@interface GroupMenuController : NSViewController

@property NSString* selectedGroupName;
@property NSString* selectedImageName;

@property (weak) IBOutlet NSSegmentedControl* groupControl;
@property (weak) IBOutlet NSMenu *groupControlMenu;
@property (weak) IBOutlet NSMenuItem *clearGroupMenuItem;

@property (weak) IBOutlet NSMenuItem* redItem;
@property (weak) IBOutlet NSMenuItem* orangeItem;
@property (weak) IBOutlet NSMenuItem* yellowItem;
@property (weak) IBOutlet NSMenuItem* greenItem;
@property (weak) IBOutlet NSMenuItem* blueItem;
@property (weak) IBOutlet NSMenuItem* purpleItem;
@property (weak) IBOutlet NSMenuItem* greyItem;

// Color menu actions
- (IBAction)didClickOnRed:(id)sender;
- (IBAction)didClickOnOrange:(id)sender;
- (IBAction)didClickOnYellow:(id)sender;
- (IBAction)didClickOnGreen:(id)sender;
- (IBAction)didClickOnBlue:(id)sender;
- (IBAction)didClickOnPurple:(id)sender;
- (IBAction)didClickOnGrey:(id)sender;

@end
