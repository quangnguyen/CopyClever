//
//  PasteBoardItemController.h
//  Pasteboard
//
//  Created by Quang Nguyen on 15/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasteboardItem.h"

@interface PasteboardController : NSObjectController {
    NSTimer* fetchItemsTimer;
}

@property (strong, nonatomic) NSPasteboard* pasteBoard;
@property (strong, nonatomic) NSDate* lastUpdated;
@property (strong, nonatomic) NSDictionary* storeTypes;
@property NSInteger changesCount;

+ (PasteboardController*)sharedInstance;

- (void)togglePollPasteBoardTimer;
- (BOOL)copyItemToPasteboard:(PasteboardItem*)item;
- (void)putNewestItemToPasteboard;
- (void)showDesktopNotification:(NSString*)message;

@end
