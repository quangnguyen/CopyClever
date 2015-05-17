//
//  AppDelegate.m
//  CopyClever
//
//  Created by Quang Nguyen on 03/09/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "Shortcut.h"
#import "ShortcutPreferencesViewController.h"

@implementation AppDelegate

@synthesize mainWindowController = _mainWindowController;
@synthesize menuBarController = _menuBarController;
@synthesize pasteboardController = _pasteboardController;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    // Initialize application
    [self setUpUserDefaults];
    [self setUpNotification];
    [self setUpMenuBar];
    [self setUpMainWindow];
    [self setUpPasteboardController];
    [self setUpShortCuts];
    [self setUpStuffsOnFirstLaunch];
}

- (void)setUpNotification
{
    // Notification
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)setUpMenuBar
{
    // Install icon into the menu bar
    _menuBarController = [[MenuBarController alloc] init];
}

- (void)setUpMainWindow
{
    _mainWindowController = [[MainWindowController alloc] init];
    // Consider to show main window at launch
    //    [_mainWindowController toggleMainWindow];
}

- (void)setUpUserDefaults
{
    NSMutableDictionary* defaultValues = [[NSMutableDictionary alloc] init];
    //    [defaultValues setValue:NO forKey:CCPastePlainText];
    [defaultValues setValue:[NSNumber numberWithFloat:0.5f] forKey:CCCheckingInterval];
    [defaultValues setValue:[NSNumber numberWithBool:YES] forKey:CCUseSameFont];
    [defaultValues setValue:[NSNumber numberWithBool:NO] forKey:CCLaunched];
    [defaultValues setValue:[NSNumber numberWithBool:NO] forKey:CCShowLeftView];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:defaultValues];
}

- (void)setUpPasteboardController
{
    // Start pasteboard controller
    _pasteboardController = [PasteboardController sharedInstance];
    BOOL restorePasteboard = [[NSUserDefaults standardUserDefaults] boolForKey:CCRestorePasteboard];
    if (restorePasteboard) {
        [_pasteboardController putNewestItemToPasteboard];
    }
}

- (void)setUpShortCuts
{
    // Shortcut
    MASShortcutBinder* shortcutBinder = [MASShortcutBinder sharedBinder];
    [shortcutBinder bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut
                                       toAction:^{
                                           [self toggleWindow:self];
                                       }];
    [shortcutBinder bindShortcutWithDefaultsKey:kShortCutPaste
                                       toAction:^{
                                           [self pasteItemInPasteboard];
                                       }];
}

- (void)setUpStuffsOnFirstLaunch
{
    BOOL isLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:CCLaunched];
    
    if (!isLaunched) {
        NSLog(@"First run");
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:CCLaunched];
        
    }
}

#pragma mark - Actions

- (IBAction)toggleWindow:(id)sender
{
    [_mainWindowController toggleMainWindow];
}

- (void)pasteItemInPasteboard
{
    [CommandActionController pasteCommand];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter*)center shouldPresentNotification:(NSUserNotification*)notification
{
    return YES;
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.cleverstuffs.CopyClever" in the user's Application Support directory.
- (NSURL*)applicationFilesDirectory
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.cleverstuffs.CopyClever"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }

    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"Copy_Clever" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSManagedObjectModel* mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* applicationFilesDirectory = [self applicationFilesDirectory];
    NSError* error = nil;

    NSDictionary* properties = [applicationFilesDirectory resourceValuesForKeys:@[ NSURLIsDirectoryKey ] error:&error];

    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString* failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];

            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];

            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }

    NSURL* url = [applicationFilesDirectory URLByAppendingPathComponent:@"Copy_Clever.storedata"];
    NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    // NSXMLStoreType
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;

    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError* error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    // Deactivate Undo Manager
    [_managedObjectContext setUndoManager:nil];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager*)windowWillReturnUndoManager:(NSWindow*)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError* error = nil;

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication*)sender
{
    // Save changes in the application's managed object context before the application terminates.

    if (!_managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError* error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString* question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString* info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString* quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString* cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];

        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
