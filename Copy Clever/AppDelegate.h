//
//  AppDelegate.h
//  Copy Clever
//
//  Created by Quang Nguyen on 03/09/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenuBarController.h"
#import "MainWindowController.h"
#import "PasteboardController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) MenuBarController* menuBarController;
@property (nonatomic, strong) MainWindowController* mainWindowController;
@property (strong) PasteboardController* pasteboardController;

- (IBAction)toggleWindow:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
