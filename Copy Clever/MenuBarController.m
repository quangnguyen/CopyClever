//
//  MenubarController.m
//  Pasteboard
//
//  Created by Quang Nguyen on 18/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "MenuBarController.h"
#import "AppDelegate.h"

@implementation MenuBarController

#pragma mark -

- (id)init
{
    self = [super init];
    if (self != nil) {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:_statusItem];
        NSImage* statusItemImageOne = [NSImage imageNamed:@"dogBlack"];
        NSImage* statusItemImageTwo = [NSImage imageNamed:@"dogWhite"];

        BOOL oldBusted = (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9);
        if (!oldBusted) {
            // 10.10 or higher, so setTemplate: is safe
            [statusItemImageOne setTemplate:YES];
            [statusItemImageTwo setTemplate:YES];
        }

        _statusItemView.image = statusItemImageOne;
        _statusItemView.alternateImage = statusItemImageTwo;
        _statusItemView.action = @selector(toggleWindow:);
    }
    return self;
}

- (void)toggleWindow
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [appDelegate toggleWindow:self];
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

@end
