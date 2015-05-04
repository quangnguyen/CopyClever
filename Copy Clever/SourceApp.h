//
//  SourceApp.h
//  CopyClever
//
//  Created by Quang Nguyen on 2/25/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PasteboardItem;

@interface SourceApp : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSSet* pasteboardItem;
@end

@interface SourceApp (CoreDataGeneratedAccessors)

- (void)addPasteboardItemObject:(PasteboardItem*)value;
- (void)removePasteboardItemObject:(PasteboardItem*)value;
- (void)addPasteboardItem:(NSSet*)values;
- (void)removePasteboardItem:(NSSet*)values;

@end
