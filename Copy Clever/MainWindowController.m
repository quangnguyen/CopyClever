//
//  PanelController.m
//  Pasteboard
//
//  Created by Quang Nguyen on 18/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "MainWindowController.h"
#import "StatusItemView.h"
#import "AppDelegate.h"
#import "Common.h"
#import "GroupMenuController.h"
#import "Group.h"

#pragma mark -

@implementation MainWindowController {
    NSRect mainRect;
}

@synthesize popupMenu = _popupMenu;
@synthesize settingsButton = _settingsButton;
@synthesize popupMenuController = _popupMenuController;
@synthesize tableController = _tableController;
@synthesize isPastePlainText = _isPastePlainText;

#pragma mark -

- (void)keyDown:(NSEvent*)theEvent
{

    if ([theEvent modifierFlags] & NSCommandKeyMask) {
        switch ([theEvent keyCode]) {
        case 0x2b:
            // cmd + "," pressed
            [_popupMenuController clickOnPreferencesItem:nil];
            break;
        case 0xc:
            break;
        }
    }
}

- (IBAction)showPopupMenu:(id)sender
{
    NSRect buttonRect = [_settingsButton frame];
    NSRect frameRelativeToScreen = [[self window] convertRectToScreen:buttonRect];
    NSPoint buttonPoint = frameRelativeToScreen.origin;
    NSPoint popupPoint = NSMakePoint(buttonPoint.x + [_settingsButton bounds].size.width, buttonPoint.y);
    [_popupMenu popUpMenuPositioningItem:nil atLocation:popupPoint inView:nil];
}

- (IBAction)didTapOpenButton:(id)sender
{
    self.changeGroupNameSheetController = [[ChangeGroupNameSheetController alloc] initWithWindowNibName:@"ChangeGroupNameSheetController"];

    [self.window beginSheet:self.changeGroupNameSheetController.window
          completionHandler:^(NSModalResponse returnCode) {
              switch (returnCode) {
              case NSModalResponseOK:
                  NSLog(@"Done button clicked");
                  break;
              case NSModalResponseCancel:
                  NSLog(@"Cancel button clicked");
                  break;

              default:
                  break;
              }

              self.changeGroupNameSheetController = nil;
          }];
}

- (IBAction)togglePlainTextButton:(NSButton*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    if (_plainTextButton.state == NSOnState) {
        _isPastePlainText = YES;
        [defaults setBool:YES forKey:CCPastePlainText];
    }
    else {
        _isPastePlainText = NO;
        [defaults setBool:NO forKey:CCPastePlainText];
    }
}

- (IBAction)showSearchView:(id)sender
{
    if ([_searchButton state] == NSOnState) {
        _searchViewAreaHeightConstraint.constant = 30.f;
        [_searchFieldContainer setHidden:NO];
    }
    else {
        _searchViewAreaHeightConstraint.constant = 0.f;
        [_searchFieldContainer setHidden:YES];
    }
}

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self != nil) {
        _isMainWindowActive = NO;
        // Make a fully skinned panel
        NSWindow* popupWindow = [self window];
        [popupWindow setAcceptsMouseMovedEvents:YES];
        [popupWindow setLevel:NSStatusWindowLevel];
        [popupWindow setOpaque:NO];
    }
    return self;
}

#pragma mark -

- (CGPoint)getTopLeftPointOfWindow
{
    NSWindow* popupWindow = [self window];

    //    CGRect eventFrame = [[[NSApp currentEvent] window] frame];
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    CGRect eventFrame = [[[[appDelegate menuBarController] statusItemView] window] frame];
    CGPoint eventOrigin = eventFrame.origin;
    CGSize eventSize = eventFrame.size;

    CGRect windowFrame = popupWindow.frame;
    CGSize windowSize = windowFrame.size;

    CGPoint windowTopRightPosition = CGPointMake(eventOrigin.x + eventSize.width / 2.f + windowSize.width, eventOrigin.y);
    CGPoint windowTopLeftPosition = CGPointMake(eventOrigin.x + eventSize.width / 2.f, eventOrigin.y - 5);

    if (CGRectContainsPoint([[NSScreen mainScreen] frame], windowTopRightPosition)) {
        return windowTopLeftPosition;
    }
    else {
        CGPoint fixedTopLeftPosition = CGPointMake([[NSScreen mainScreen] frame].origin.x + [[NSScreen mainScreen] frame].size.width - windowSize.width - 5, eventOrigin.y - 5);
        return fixedTopLeftPosition;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    _searchViewAreaHeightConstraint.constant = 0.f;
    [_searchFieldContainer setHidden:YES];

    mainRect = _tableContainerView.frame;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL pastePlainText = [defaults boolForKey:CCPastePlainText];
    if (pastePlainText) {
        [_plainTextButton setState:NSOnState];
        _isPastePlainText = YES;
    }
    else {
        [_plainTextButton setState:NSOffState];
        _isPastePlainText = NO;
    }

    NSInteger colorNumber = [defaults integerForKey:CCInitTagColor];
    [self setGroupControlColor:colorNumber];

    // Put table controller in transponder chain
    NSResponder* aNextResponder = [self nextResponder];
    [self setNextResponder:_tableController];
    [_tableController setNextResponder:aNextResponder];
}

- (void)setGroupControlColor:(NSInteger)colorIndex
{
    switch (colorIndex) {
    case 1:
        [_groupControl setImage:[NSImage imageNamed:@"StarRed12"] forSegment:0];
        break;
    case 2:
        [_groupControl setImage:[NSImage imageNamed:@"StarOrange12"] forSegment:0];
        break;
    case 3:
        [_groupControl setImage:[NSImage imageNamed:@"StarYellow12"] forSegment:0];
        break;
    case 4:
        [_groupControl setImage:[NSImage imageNamed:@"StarGreen12"] forSegment:0];
        break;
    case 5:
        [_groupControl setImage:[NSImage imageNamed:@"StarBlue12"] forSegment:0];
        break;
    case 6:
        [_groupControl setImage:[NSImage imageNamed:@"StarPurple12"] forSegment:0];
        break;
    case 7:
        [_groupControl setImage:[NSImage imageNamed:@"StarGrey12"] forSegment:0];
        break;

    default:
        break;
    }
}

#pragma mark - Public accessor

- (void)toggleMainWindow
{
    if (!_isMainWindowActive) {
        _isMainWindowActive = YES;
        [self openPanel];
    }
    else {
        _isMainWindowActive = NO;
        [self closePanel];
    }
}

- (void)openPanel
{
    NSWindow* popupWindow = [self window];
    CGPoint position = [self getTopLeftPointOfWindow];
    [popupWindow setFrameTopLeftPoint:position];
    [popupWindow makeKeyAndOrderFront:self];
}

- (void)closePanel
{
    [self.window orderOut:nil];
}

#pragma mark - NSWindowDelegate

- (void)windowDidResize:(NSNotification*)notification
{
    NSLog(@"Window did resize");
}

@end
