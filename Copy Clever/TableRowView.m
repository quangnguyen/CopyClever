//
//  CCTableRowView.m
//  CopyClever
//
//  Created by Quang Nguyen on 22/12/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "TableRowView.h"

@implementation TableRowView

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 0, 0);
        [[NSColor colorWithCalibratedRed:0.63 green:0.80 blue:1 alpha:1] setStroke];
        [[NSColor colorWithCalibratedRed:0.63 green:0.80 blue:1 alpha:1] setFill];
        NSBezierPath* selectionPath = [NSBezierPath bezierPathWithRect:selectionRect];
        [selectionPath fill];
        [selectionPath stroke];
    }
}

@end
