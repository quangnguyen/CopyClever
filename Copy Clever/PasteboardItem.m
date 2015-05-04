//
//  Copy Clever.m
//  CopyClever
//
//  Created by Quang Nguyen on 2/25/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "PasteboardItem.h"
#import "Group.h"
#import "SourceApp.h"

@implementation PasteboardItem

@dynamic createdDate;
@dynamic lastUsedDate;
@dynamic isLastUsedItem;
@dynamic hashNumber;
@dynamic overview;
@dynamic group;
@dynamic sourceApp;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setPrimitiveValue:[NSDate date] forKey:@"createdDate"];
    [self setPrimitiveValue:[NSDate date] forKey:@"lastUsedDate"];
}

@end
