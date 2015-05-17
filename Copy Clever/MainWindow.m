//
//  MainWindow.m
//  CopyClever
//
//  Created by Quang Nguyen on 27/04/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "MainWindow.h"
#import "Common.h"

@implementation MainWindow
{
    NSUserDefaults* userDefaults;
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

-(void)awakeFromNib{
    userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL showLeftView = [userDefaults boolForKey:CCShowLeftView];
    
    if (showLeftView) {
        [_toggleLeftViewButton setState:NSOnState];
    } else {
        [_toggleLeftViewButton setState:NSOffState];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLeftViewCollapsedNotification:)
                                                 name:@"LeftViewDidResize"
                                               object:nil];
}

- (IBAction)toggleLeftView:(id)sender {
    [_splitView toggleLeftSubView];
}

- (void)handleLeftViewCollapsedNotification:(NSNotification*)notification
{
    BOOL isCollapsed = [[notification object] isLeftViewCollapsed];
    if (isCollapsed) {
        _toggleLeftViewButton.state = NSOffState;
    } else {
        _toggleLeftViewButton.state = NSOnState;
    }
    
}

@end
