//
//  PasteboardItemURL.h
//  CopyClever
//
//  Created by Quang Nguyen on 28/04/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PasteboardItem.h"

@interface PasteboardItemURL : PasteboardItem

@property (nonatomic, retain) id filenames;
@property (nonatomic, retain) id url;

@end
