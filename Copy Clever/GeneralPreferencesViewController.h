//
//  GeneralPreferencesViewController.h
//  CopyClever
//
//  Created by Quang Nguyen on 14/02/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet NSButton* startAtLoginButton;
@property (weak) IBOutlet NSButton* restoreButton;
@property (weak) IBOutlet NSButton* notificationButton;
@property (weak) IBOutlet NSButton* fontButton;

- (IBAction)launchAtLogInClicked:(NSButton*)sender;
- (IBAction)restoreClicked:(NSButton*)sender;
- (IBAction)notificationButtonClicked:(id)sender;
- (IBAction)useSameFontClicked:(NSButton*)sender;

@end
