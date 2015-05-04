//
//  PasteboardItemText.m
//  CopyClever
//
//  Created by Quang Nguyen on 2/25/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "PasteboardItemText.h"

@implementation PasteboardItemText

@dynamic rtfdData;
@dynamic rtfData;
@dynamic stringValue;

- (NSNumber*)charCount
{
    NSNumber* result = [NSNumber numberWithInteger:[[self stringValue] length]];
    return result;
}

- (NSString*)generateOverview
{
    NSString* result;
    if ([self charCount] > 0) {
        if ([self rtfdData]) {
            result = [NSString stringWithFormat:@"RTFD Data, %@ characters", [self charCount]];
        }
        else if ([self rtfData]) {
            result = [NSString stringWithFormat:@"RTF Data, %@ characters", [self charCount]];
        }
        else if ([self stringValue]) {
            result = [NSString stringWithFormat:@"Plain Text, %@ characters", [self charCount]];
        }
        return result;
    }
    return @"";
}

- (NSString*)mainText
{
    return [self stringValue];
}

@end
