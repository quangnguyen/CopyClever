//
//  ShortcutPreferencesViewController.h
//  Copy Clever
//
//  Created by Quang Nguyen on 14/02/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "MASPreferencesViewController.h"
#import "Shortcut.h"

// Pick a preference key to store the shortcut between launches
static NSString *const kPreferenceGlobalShortcut = @"PreferencesShortcut";
static NSString *const kShortCutPaste = @"ShortCutPaste";

@interface ShortcutPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet MASShortcutView *shortcutOpenView;
@property (weak) IBOutlet MASShortcutView *shortcutPasteView;

@end
