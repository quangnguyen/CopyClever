//
//  PopupMenuController.h
//  CopyClever
//
//  Created by Quang Nguyen on 29/12/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopupMenuController : NSViewController {
    BOOL isPaused;
}

@property (nonatomic, readonly) NSWindowController* preferencesWindowController;
@property (nonatomic) NSInteger focusedAdvancedControlIndex;
@property IBOutlet NSMenuItem* preferencesItem;
@property IBOutlet NSMenuItem* pauseContinueItem;
@property IBOutlet NSMenuItem* helpItem;
@property IBOutlet NSMenuItem* quitItem;
@property IBOutlet NSMenuItem* aboutItem;

- (IBAction)clickOnPreferencesItem:(id)sender;
- (IBAction)clickOnHelpItem:(id)sender;
- (IBAction)clickOnQuitItem:(id)sender;
- (IBAction)clickOnPauseOrContinueItem:(id)sender;
- (IBAction)clickOnAboutItem:(id)sender;

@end
