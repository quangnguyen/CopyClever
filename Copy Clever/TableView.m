//
//  TableView.m
//  Pasteboard
//
//  Created by Quang Nguyen on 19/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "TableView.h"
#import "TableController.h"

@implementation TableView

- (void)awakeFromNib
{
    [self setDoubleAction:@selector(doubleClick:)];
    _rightClickedRow = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:@"DisplayFontNotification"
                                               object:nil];
}

- (void)drawGridInClipRect:(NSRect)clipRect
{
    NSRect lastRowRect = [self rectOfRow:[self numberOfRows] - 1];
    NSRect myClipRect = NSMakeRect(0, 0, lastRowRect.size.width, NSMaxY(lastRowRect));
    NSRect finalClipRect = NSIntersectionRect(clipRect, myClipRect);
    [super drawGridInClipRect:finalClipRect];
}

- (NSMenu*)menuForEvent:(NSEvent*)event
{
    NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:mousePoint];

    if (row == -1) {
        return nil;
    }

    _rightClickedRow = row;
    return [super menuForEvent:event];
}

- (void)keyDown:(NSEvent*)theEvent
{
    TableController* controller = (TableController*)self.delegate;

    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if (key == NSDeleteCharacter) {
        if ([self selectedRow] == -1) {
            NSBeep();
        }
        else {
            NSIndexSet* indexes = [self selectedRowIndexes];
            [controller removeObjectsAtIndexes:indexes];
        }
    }
    else if (key == ' ') {
        if ([self selectedRow] == -1) {
            NSBeep();
        }
        else {
            [[self quickLookDelegate] didPressSpaceBarForTableView:self];
        }
    }

    [super keyDown:theEvent];
}

- (void)doubleClick:(id)object
{
    TableController* controller = (TableController*)self.delegate;
    BOOL isOK = [controller copySelectedItemToPasteboard];
    if (isOK) {
        [[NSApplication sharedApplication] hide:nil];
        [CommandActionController pasteCommand];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSApplication sharedApplication] unhide:nil];
        });
        //        [[NSApplication sharedApplication] unhide:nil];
    }
}

@end
