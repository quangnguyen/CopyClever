//
//  Copy Clever.h
//  CopyClever
//
//  Created by Quang Nguyen on 2/25/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, SourceApp;

@protocol PasteboardItemProtocol <NSObject>
@optional
- (NSString*)generateOverview;
- (NSString*)mainText;
@end

@interface PasteboardItem : NSManagedObject <PasteboardItemProtocol>

@property (nonatomic, retain) NSDate* createdDate;
@property (nonatomic, retain) NSDate* lastUsedDate;
@property (nonatomic, retain) NSString* hashNumber;
@property (nonatomic, retain) NSString* overview;
@property (nonatomic, retain) NSNumber* isLastUsedItem;
@property (nonatomic, retain) Group* group;
@property (nonatomic, retain) SourceApp* sourceApp;

@end
