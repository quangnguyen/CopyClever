//
//  CCSegmentedCell.m
//  CopyClever
//
//  Created by Quang Nguyen on 2/21/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "SegmentedCell.h"

@implementation SegmentedCell

- (SEL)action
{
    if ([self menuForSegment:[self selectedSegment]]) {
        return nil;
    }
    else {
        return [super action];
    }
}

@end
