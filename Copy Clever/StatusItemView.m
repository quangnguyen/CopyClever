//
//  NewStatusItemView.m
//  Copy Clever
//
//  Created by Quang Nguyen on 1/16/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "StatusItemView.h"

@interface StatusItemView () {
    BOOL _darkThemeColors;
}

@property (readonly) BOOL isDrawsOnDarkBackground;

@end

@implementation StatusItemView

- (id)initWithStatusItem:(NSStatusItem*)statusItem
{
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);

    self = [super initWithFrame:itemRect];

    if (self) {
        _statusItem = statusItem;
        [_statusItem setView:self];
    }

    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.

    BOOL darkThemeColors = NO;

    if ([NSAppearance class]) {
        id appearance = [NSAppearance currentAppearance];
        darkThemeColors = [appearance respondsToSelector:@selector(name)] && [[appearance valueForKey:@"name"] isEqualToString:@"NSAppearanceNameVibrantDark"];
    }

    if (darkThemeColors != _darkThemeColors) {
        _darkThemeColors = darkThemeColors;
    }

    NSImage* image = _darkThemeColors ? _alternateImage : _image;

    if (image) {
        CGFloat width = image.size.width + 12;

        [image drawAtPoint:NSMakePoint(lround((width - image.size.width) / 2), lround((self.frame.size.height - image.size.height) / 2)) fromRect:NSMakeRect(0, 0, width, image.size.height) operation:NSCompositeSourceOver fraction:1.0];

        [self setFrameSize:NSMakeSize(width, self.frame.size.height)];
    }
}

- (void)mouseDown:(NSEvent*)theEvent
{
    [NSApp sendAction:self.action to:self.target from:self];
}

@end
