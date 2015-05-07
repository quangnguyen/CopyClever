//
//  ShortcutPreferencesViewController.m
//  Copy Clever
//
//  Created by Quang Nguyen on 14/02/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "ShortcutPreferencesViewController.h"

@implementation ShortcutPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"ShortcutPreferencesView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString*)identifier
{
    return @"ShortcutPreferences";
}

- (NSImage*)toolbarItemImage
{
    return [NSImage imageNamed:@"Keyboard"];
}

- (NSString*)toolbarItemLabel
{
    return NSLocalizedString(@"Keyboard", @"Toolbar item name for the shortcut preference pane");
}

- (void)awakeFromNib
{
    // Associate the shortcut view with user defaults
    [_shortcutOpenView setAssociatedUserDefaultsKey:kPreferenceGlobalShortcut];
    [_shortcutPasteView setAssociatedUserDefaultsKey:kShortCutPaste];
}

- (void)viewDidDisappear
{
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
}

@end
