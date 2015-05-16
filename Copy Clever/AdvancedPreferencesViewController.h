//
//  AdvancedPreferencesViewController.h
//  CopyClever
//
//  Created by Quang Nguyen on 14/02/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface AdvancedPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet NSTextField* checkingIntervalLabel;
@property (weak) IBOutlet NSSlider* checkingIntervalSlider;

- (IBAction)changeIntervalSlider:(id)sender;
- (IBAction)resetUserDefaults:(id)sender;


@end
