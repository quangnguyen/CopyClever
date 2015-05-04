//
//  PasteboardItemText.h
//  CopyClever
//
//  Created by Quang Nguyen on 2/25/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PasteboardItem.h"

@interface PasteboardItemText : PasteboardItem

@property (nonatomic, retain) NSData* rtfdData;
@property (nonatomic, retain) NSData* rtfData;
@property (nonatomic, retain) NSString* stringValue;

@end
