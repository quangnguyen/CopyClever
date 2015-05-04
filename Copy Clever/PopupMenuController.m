//
//  PopupMenuController.m
//  Copy Clever
//
//  Created by Quang Nguyen on 29/12/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "PopupMenuController.h"
#import "MASPreferencesWindowController.h"
#import "GeneralPreferencesViewController.h"
#import "ShortcutPreferencesViewController.h"
#import "AdvancedPreferencesViewController.h"
#import "PasteboardController.h"

@implementation PopupMenuController

@synthesize preferencesItem = _preferencesItem;
@synthesize pauseContinueItem = _pauseContinueItem;
@synthesize helpItem = _helpItem;
@synthesize aboutItem = _aboutItem;
@synthesize quitItem = _quitItem;
@synthesize preferencesWindowController = _preferencesWindowController;

- (void)awakeFromNib
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    isPaused = [defaults boolForKey:CCPaused];
    if (isPaused) {
        [_pauseContinueItem setImage:[NSImage imageNamed:@"play"]];
        [_pauseContinueItem setTitle:NSLocalizedString(@"StartRecord", nil)];
    }
    else {
        [_pauseContinueItem setImage:[NSImage imageNamed:@"stop"]];
        [_pauseContinueItem setTitle:NSLocalizedString(@"StopRecord", nil)];
    }
    [_aboutItem setTitle:NSLocalizedString(@"About", nil)];
    [_preferencesItem setTitle:NSLocalizedString(@"Preferences", nil)];
    [_quitItem setTitle:NSLocalizedString(@"Quit", nil)];
    [_helpItem setTitle:NSLocalizedString(@"Help", nil)];
    
}

- (NSWindowController*)preferencesWindowController
{
    if (_preferencesWindowController == nil) {
        NSViewController* generalViewController = [[GeneralPreferencesViewController alloc] init];
        NSViewController* advancedViewController = [[AdvancedPreferencesViewController alloc] init];
        NSViewController* shortcutViewController = [[ShortcutPreferencesViewController alloc] init];

        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        NSArray* controllers = @[ generalViewController, shortcutViewController, advancedViewController, [NSNull null] ];

        NSString* title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
}

NSString* const kFocusedAdvancedControlIndex = @"FocusedAdvancedControlIndex";

- (NSInteger)focusedAdvancedControlIndex
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFocusedAdvancedControlIndex];
}

- (void)setFocusedAdvancedControlIndex:(NSInteger)focusedAdvancedControlIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:focusedAdvancedControlIndex forKey:kFocusedAdvancedControlIndex];
}

- (IBAction)clickOnPreferencesItem:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
    // Now put the preferences window on top
    [NSApp activateIgnoringOtherApps:YES];
    [[self.preferencesWindowController window] makeKeyAndOrderFront:self];
}

- (IBAction)clickOnHelpItem:(id)sender
{
    
}

-(void)clickOnAboutItem:(id)sender
{
    
}
- (IBAction)clickOnQuitItem:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)clickOnPauseOrContinueItem:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    if (isPaused) {
        [defaults setBool:NO forKey:CCPaused];
        [_pauseContinueItem setTitle:NSLocalizedString(@"StopRecord", nil)];
        [_pauseContinueItem setImage:[NSImage imageNamed:@"stop"]];
        isPaused = NO;
    }
    else {
        [defaults setBool:YES forKey:CCPaused];
        [_pauseContinueItem setTitle:NSLocalizedString(@"StartRecord", nil)];
        [_pauseContinueItem setImage:[NSImage imageNamed:@"play"]];
        isPaused = YES;
    }
    [[PasteboardController sharedInstance] togglePollPasteBoardTimer];
}

@end
