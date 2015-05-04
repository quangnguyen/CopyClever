//
//  PasteBoardItemController.m
//  Pasteboard
//
//  Created by Quang Nguyen on 15/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "PasteboardController.h"
#import "AppDelegate.h"
#import "MASPreferencesWindowController.h"
#import "SourceApp.h"
#import "ImageUtility.h"
#import "PasteboardItemImage.h"
#include "PasteboardItemText.h"
#include "PasteboardItemURL.h"

static PasteboardController* sharedInstance;

@implementation PasteboardController {
    NSUserDefaults* defaults;
    NSManagedObjectContext* _context;
}

@synthesize lastUpdated = _lastUpdated;
@synthesize pasteBoard = _pasteBoard;
@synthesize storeTypes = _storeTypes;

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        [self setStoreTypes:[defaults objectForKey:CCStoreTypesKey]];
        _pasteBoard = [NSPasteboard generalPasteboard];
        _changesCount = (int)[_pasteBoard changeCount];

        BOOL isPaused = [defaults boolForKey:CCPaused];
        if (!isPaused) {
            [self togglePollPasteBoardTimer];
        }

        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        _context = [appDelegate managedObjectContext];
    }
    return self;
}

+ (PasteboardController*)sharedInstance
{
    @synchronized(self)
    {
        if (!sharedInstance) {
            sharedInstance = [[PasteboardController alloc] init];
        }
        return sharedInstance;
    }
}

- (void)togglePollPasteBoardTimer
{
    if (fetchItemsTimer == nil) {
        _changesCount = (int)[_pasteBoard changeCount];
        fetchItemsTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                           target:self
                                                         selector:@selector(synchronizeWithPasteboard)
                                                         userInfo:nil
                                                          repeats:YES];
    }
    else {
        [fetchItemsTimer invalidate];
        fetchItemsTimer = nil;
    }
}

#pragma mark - Notifications

- (void)showDesktopNotification:(NSString*)message
{
    NSUserNotification* notification = [[NSUserNotification alloc] init];
    notification.title = @"Copy Clever!";
    notification.informativeText = message;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

#pragma mark -

- (NSArray*)fetchItemsWithEntityName:(NSString*)entityName andPredicate:(NSPredicate*)predicate
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setPredicate:predicate];
    NSError* error;
    return [_context executeFetchRequest:request error:&error];
}

- (SourceApp*)persistRunningApp
{
    NSRunningApplication* runningSourceApp = [[NSWorkspace sharedWorkspace] frontmostApplication];
    NSString* appName = [runningSourceApp localizedName];

    NSImage* sourceImage = [runningSourceApp icon];
    NSImage* scaledImage = [ImageUtility scaleImageTo60px60px:sourceImage];

    SourceApp* sourceApp = [NSEntityDescription insertNewObjectForEntityForName:@"SourceApp" inManagedObjectContext:_context];
    [sourceApp setValue:appName forKey:@"name"];
    [sourceApp setValue:scaledImage forKey:@"image"];

    NSError* error;
    [_context save:&error];
    return sourceApp;
}

- (void)bindItemToSourceApp:(PasteboardItem*)pbItem
{
    NSRunningApplication* runningSourceApp = [[NSWorkspace sharedWorkspace] frontmostApplication];
    NSString* appName = [runningSourceApp localizedName];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name = %@", appName];
    NSArray* apps = [self fetchItemsWithEntityName:@"SourceApp" andPredicate:predicate];

    SourceApp* srcApp;

    if (apps.count == 0) {
        srcApp = [self persistRunningApp];
    }
    else {
        srcApp = apps[0];
    }

    [pbItem setValue:srcApp forKey:@"sourceApp"];
    [self updateLastItemTimestamp];
}

- (void)updateLastItemTimestamp
{
    NSDate* now = [[NSDate alloc] init];
    self.lastUpdated = now;
}

#pragma mark - Synchronization and recording

- (void)synchronizeWithPasteboard
{
    if (_changesCount < [_pasteBoard changeCount]) {
        [self saveNewItemFromPasteBoard:_pasteBoard];
        _changesCount = [_pasteBoard changeCount];
    }
}

//TODO: Make possible to chose types of items to record
- (BOOL)isTypeToStore:(NSString*)type
{
    //	NSDictionary *typeDict = [PasteboardItem availableTypeDictionary];
    //	return [[_storeTypes objectForKey:[typeDict objectForKey:type]] boolValue];
    return YES;
}

- (NSArray*)makeTypesFromPasteboard:(NSPasteboard*)pasteboard
{
    NSMutableArray* result = [NSMutableArray array];
    NSArray* allOfPasteboardDataTypes = [pasteboard types];

    for (NSString* dataType in allOfPasteboardDataTypes) {
        if (![self isTypeToStore:dataType]) {
            continue;
        }
        else {
            [result addObject:dataType];
        }
    }

    return result;
}

- (NSArray*)makeTypesFromItem:(PasteboardItem*)item
{
    NSMutableArray* result = [NSMutableArray array];

    if ([item isKindOfClass:[PasteboardItemImage class]]) {
        [result addObject:NSPasteboardTypeTIFF];
    }
    else if ([item isKindOfClass:[PasteboardItemText class]]) {
        if ([(PasteboardItemText*)item rtfdData]) {
            [result addObject:NSPasteboardTypeRTFD];
        }

        if ([(PasteboardItemText*)item rtfData]) {
            [result addObject:NSPasteboardTypeRTF];
        }

        if ([(PasteboardItemText*)item stringValue]) {
            [result addObject:NSPasteboardTypeString];
        }
    }
    else if ([item isKindOfClass:[PasteboardItemURL class]]) {
        if ([(PasteboardItemURL*)item filenames]) {
            [result addObject:NSFilenamesPboardType];
        }

        if ([(PasteboardItemURL*)item url]) {
            [result addObject:NSURLPboardType];
        }
    }

    return result;
}

- (NSString*)hashOfString:(NSString*)string
{
    NSUInteger hash = [string hash];
    NSString* result = [NSString stringWithFormat:@"%li", hash];
    return result;
}

- (NSString*)hashOfImage:(NSImage*)image
{
    NSInteger hash = [[image TIFFRepresentation] hash];
    NSString* result = [NSString stringWithFormat:@"%li", hash];
    return result;
}

- (void)pushNotificationWithStatusFlag:(BOOL)statusFlag
{
    BOOL notificationState = [defaults boolForKey:CCNotificationCenter];
    if (statusFlag) {
        if (notificationState) {
            [self showDesktopNotification:@"A new item was recorded"];
        }
    }
    else {
        if (notificationState) {
            [self showDesktopNotification:@"Recording a item was unsuccessful"];
        }
    }
}

- (BOOL)isItemPersisted:(NSString*)hashString
{
    NSError* error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"PasteboardItem"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"hashNumber = %@", hashString]];
    NSUInteger count = [_context countForFetchRequest:request error:&error];
    return count > 0;
}

- (BOOL)makeItemAsLastUsed:(PasteboardItem*)item
{
    NSError* error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"PasteboardItem"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isLastUsedItem = YES"]];

    NSArray* result = [_context executeFetchRequest:request error:&error];
    for (PasteboardItem* pbItem in result) {
        [pbItem setIsLastUsedItem:@NO];
    }

    [item setIsLastUsedItem:@YES];
    NSError* saveError = nil;
    [item.managedObjectContext save:&saveError];

    return !(error || saveError);
}

- (void)saveImageItem:(NSPasteboard*)pasteBoard
{
    NSImage* image = [[NSImage alloc] initWithPasteboard:pasteBoard];
    NSString* hashString = [self hashOfImage:image];

    if (![self isItemPersisted:hashString]) {
        BOOL isOK = [self saveImageItem:pasteBoard withHashString:hashString];
        [self pushNotificationWithStatusFlag:isOK];
    }
}

- (BOOL)saveImageItem:(NSPasteboard*)pasteBoard withHashString:(NSString*)hashString
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"PasteboardItemImage" inManagedObjectContext:_context];
    PasteboardItemImage* newPbItem = [[PasteboardItemImage alloc] initWithEntity:entity insertIntoManagedObjectContext:_context];

    [newPbItem setImage:[[NSImage alloc] initWithPasteboard:pasteBoard]];
    [newPbItem setHashNumber:hashString];
    [newPbItem setOverview:[newPbItem generateOverview]];
    [self makeItemAsLastUsed:newPbItem];
    [self bindItemToSourceApp:newPbItem];
    NSError* error;
    [_context save:&error];
    return error == nil;
}

- (void)saveTextItem:(NSPasteboard*)pasteBoard
{
    NSData* rtfdData = [pasteBoard dataForType:NSPasteboardTypeRTFD];
    NSInteger rtfdHashNumber = [rtfdData hash];
    NSString* rtfdHashString = [@(rtfdHashNumber) stringValue];

    NSData* rtfData = [pasteBoard dataForType:NSPasteboardTypeRTF];
    NSInteger rtfHashNumber = [rtfData hash];
    NSString* rtfHashString = [@(rtfHashNumber) stringValue];

    NSString* string = [pasteBoard stringForType:NSPasteboardTypeString];
    NSString* plainTextHashString = [self hashOfString:string];

    NSMutableString* totalHashString = [NSMutableString new];
    [totalHashString appendString:rtfdHashString];
    [totalHashString appendString:rtfHashString];
    [totalHashString appendString:plainTextHashString];

    if (![self isItemPersisted:totalHashString]) {
        BOOL isOK = [self saveTextItem:pasteBoard withHashString:totalHashString];
        [self pushNotificationWithStatusFlag:isOK];
    }
}

- (BOOL)saveTextItem:(NSPasteboard*)pasteBoard withHashString:(NSString*)hashString
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"PasteboardItemText" inManagedObjectContext:_context];
    PasteboardItemText* newPbItem = [[PasteboardItemText alloc] initWithEntity:entity insertIntoManagedObjectContext:_context];

    [newPbItem setStringValue:[pasteBoard stringForType:NSPasteboardTypeString]];
    [newPbItem setRtfData:[pasteBoard dataForType:NSPasteboardTypeRTFD]];
    [newPbItem setRtfData:[pasteBoard dataForType:NSPasteboardTypeRTF]];
    [newPbItem setHashNumber:hashString];
    [newPbItem setOverview:[newPbItem generateOverview]];
    [self makeItemAsLastUsed:newPbItem];
    [self bindItemToSourceApp:newPbItem];
    NSError* error;
    [_context save:&error];

    return error == nil;
}

- (void)saveURLItem:(NSPasteboard*)pasteBoard
{
    NSArray* fileNames = [pasteBoard propertyListForType:NSFilenamesPboardType];
    NSUInteger hashNumber = [fileNames hash];
    NSString* hashString = [NSString stringWithFormat:@"%ld", hashNumber];

    BOOL isOK = [self saveURLItem:pasteBoard withHashString:hashString];
    [self pushNotificationWithStatusFlag:isOK];
}

- (BOOL)saveURLItem:(NSPasteboard*)pasteBoard withHashString:(NSString*)hashString
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"PasteboardItemURL" inManagedObjectContext:_context];
    PasteboardItemURL* newPbItem = [[PasteboardItemURL alloc] initWithEntity:entity insertIntoManagedObjectContext:_context];

    [newPbItem setFilenames:[pasteBoard propertyListForType:NSFilenamesPboardType]];
    [newPbItem setUrl:[pasteBoard propertyListForType:NSURLPboardType]];
    [newPbItem setHashNumber:hashString];
    [newPbItem setOverview:[newPbItem generateOverview]];
    [self makeItemAsLastUsed:newPbItem];
    [self bindItemToSourceApp:newPbItem];
    NSError* error;
    [_context save:&error];

    return error == nil;
}

- (void)saveNewItemFromPasteBoard:(NSPasteboard*)pasteBoard
{
    NSString* type = [pasteBoard availableTypeFromArray:[PasteboardController availableTypes]];
    if ([type isEqualToString:NSPasteboardTypeTIFF]) {
        [self saveImageItem:pasteBoard];
    }
    else if ([type isEqualToString:NSURLPboardType]) {
        [self saveURLItem:pasteBoard];
    }
    else if ([type isEqualToString:NSPasteboardTypeRTFD] || [type isEqualToString:NSPasteboardTypeRTF] || [type isEqualToString:NSPasteboardTypeString]) {
        [self saveTextItem:pasteBoard];
    }
}

//TODO: Make this possible to choose storing types
+ (NSArray*)availableTypes
{
    return @[ NSURLPboardType,
        //            NSFilenamesPboardType,
        NSPasteboardTypeRTFD,
        NSPasteboardTypeRTF,
        //            NSPasteboardTypePDF,
        NSPasteboardTypeString,
        NSPasteboardTypeTIFF ];
}

- (BOOL)copyItemToPasteboard:(PasteboardItem*)item
{
    [self makeItemAsLastUsed:item];
    NSArray* types = [self makeTypesFromItem:item];

    // Clear content of pasteboard increase changeCount + 1
    [_pasteBoard clearContents];
    [_pasteBoard declareTypes:types owner:self];

    BOOL result = NO;
    BOOL pastePlainText = [defaults boolForKey:CCPastePlainText];

    if ([item isKindOfClass:[PasteboardItemImage class]]) {
        NSImage* image = [(PasteboardItemImage*)item image];
        if (image) {
            result = [_pasteBoard setData:[image TIFFRepresentation] forType:NSPasteboardTypeTIFF];
        }
        return result;
    }
    else if ([item isKindOfClass:[PasteboardItemURL class]]) {
        for (NSString* pbType in types) {
            if ([pbType isEqualToString:NSFilenamesPboardType]) {
                NSArray* fileNames = [(PasteboardItemURL*)item filenames];
                result = [_pasteBoard setPropertyList:fileNames forType:NSFilenamesPboardType];
            }
            else if ([pbType isEqualToString:NSURLPboardType]) {
                NSArray* url = [(PasteboardItemURL*)item url];
                result = [_pasteBoard setPropertyList:url forType:NSURLPboardType];
            }
        }
        return result;
    }
    else if ([item isKindOfClass:[PasteboardItemText class]]) {
        if (pastePlainText) {
            for (NSString* pbType in types) {
                if ([pbType isEqualToString:NSPasteboardTypeString]) {
                    result = [_pasteBoard setString:[(PasteboardItemText*)item stringValue] forType:NSPasteboardTypeString];
                }
            }
            return result;
        }
        else {
            for (NSString* pbType in types) {
                if ([pbType isEqualToString:NSPasteboardTypeString]) {
                    result = [_pasteBoard setString:[(PasteboardItemText*)item stringValue] forType:NSPasteboardTypeString];
                }
                else if ([pbType isEqualToString:NSPasteboardTypeRTFD]) {
                    NSData* rtfData = [(PasteboardItemText*)item rtfData];
                    result = [_pasteBoard setData:rtfData forType:NSPasteboardTypeRTFD];
                }
                else if ([pbType isEqualToString:NSPasteboardTypeRTF]) {
                    NSData* rtfData = [(PasteboardItemText*)item rtfData];
                    result = [_pasteBoard setData:rtfData forType:NSPasteboardTypeRTF];
                }
            }
            return result;
        }
    }

    return result;
}

- (void)putNewestItemToPasteboard
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PasteboardItem"];
    [request setFetchLimit:1];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *results = [_context executeFetchRequest:request error:NULL];
    if (results.count > 0) {
        _changesCount = [[NSPasteboard generalPasteboard] changeCount] + 2;
        PasteboardItem* newestItem = [results firstObject];
        [self copyItemToPasteboard:newestItem];
    }
}

- (BOOL)isNewApp:(NSString*)appName
{
    return YES;
}

@end
