//
//  PasteboardItemImage.h
//  CopyClever
//
//  Created by Quang Nguyen on 2/25/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PasteboardItem.h"

@interface PasteboardItemImage : PasteboardItem

@property (nonatomic, retain) id image;

- (NSString*)mainText;

@end
