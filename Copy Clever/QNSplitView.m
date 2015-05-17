//
//  QNSplitView.m
//  CopyClever
//
//  Created by Quang Nguyen on 16/05/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "QNSplitView.h"
#import "Common.h"

@implementation QNSplitView {
    CGFloat leftViewWidth;
    NSView* leftView;
    NSUserDefaults* userDefaults;
}

- (void)awakeFromNib
{
    self.delegate = self;
    leftView = [[self subviews] objectAtIndex:0];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL showLeftView = [userDefaults boolForKey:CCShowLeftView];
    if (!showLeftView) {
        [self toggleLeftSubView];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

#pragma mark Delegate methods


- (NSColor*)dividerColor
{
    return [NSColor lightGrayColor];
}

-(BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    return YES;
}

- (CGFloat)splitView:(NSSplitView*)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return 130;
}

- (CGFloat)splitView:(NSSplitView*)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return 300;
}

- (BOOL)splitView:(NSSplitView*)splitView canCollapseSubview:(NSView*)subview
{
    if ([self.subviews objectAtIndex:0] == subview) {
        return YES;
    }
    return NO;
}

- (BOOL)isLeftViewCollapsed
{
    return [self isSubviewCollapsed:leftView];
}

-(void)splitViewDidResizeSubviews:(NSNotification *)notification
{
    leftViewWidth = [leftView frame].size.width;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftViewDidResize" object:self];
}

- (void)toggleLeftSubView
{
    [self adjustSubviews];
    if ([self isSubviewCollapsed:leftView])
        [self openLeftView];
    else
        [self hideLeftView];
}

- (void)openLeftView
{
    [self setPosition:leftViewWidth ofDividerAtIndex:0];
    [userDefaults setBool:YES forKey:CCShowLeftView];
}

- (void)hideLeftView
{
    [self setPosition:[self minPossiblePositionOfDividerAtIndex:0] ofDividerAtIndex:0];
    [userDefaults setBool:NO forKey:CCShowLeftView];
}

@end
