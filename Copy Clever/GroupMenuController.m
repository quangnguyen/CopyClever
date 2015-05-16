//
//  GroupMenuController.m
//  CopyClever
//
//  Created by Quang Nguyen on 2/21/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "GroupMenuController.h"
#import "AppDelegate.h"

NSInteger const RED = 1;
NSInteger const ORANGE = 2;
NSInteger const YELLOW = 3;
NSInteger const GREEN = 4;
NSInteger const BLUE = 5;
NSInteger const PURPLE = 6;
NSInteger const GREY = 7;
NSString* const CCInitGroupColor = @"InitGroupColor";
NSString* const CCInitGroupName = @"InitGroupName";

@implementation GroupMenuController {
    NSUserDefaults* _userDefaults;
    NSManagedObjectContext* _context;
}

- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        _context = [appDelegate managedObjectContext];
    }
    return self;
}

- (void)awakeFromNib
{
    NSInteger groupColor = [_userDefaults integerForKey:CCInitGroupColor];
    NSString *groupName = [_userDefaults stringForKey:CCInitGroupName];
    [self setSelectedImageNameWithColorNumber:groupColor];
    [self setSelectedGroupName:groupName];
    [self setOnStateForSelectedMenuItem:groupColor];
    
    [self setUpRedItemTitle];
    [self setUpOrangeItemTitle];
    [self setUpYellowItemTitle];
    [self setUpGreenItemTitle];
    [self setUpBlueItemTitle];
    [self setUpPurpleItemTitle];
    [self setUpGreyItemTitle];
}

- (void)setSelectedImageNameWithColorNumber:(NSInteger)colorNumber
{
    switch (colorNumber) {
    case RED:
        _selectedImageName = @"StarRed12";
        break;
    case ORANGE:
        _selectedImageName = @"StarOrange12";
        break;
    case YELLOW:
        _selectedImageName = @"StarYellow12";
        break;
    case GREEN:
        _selectedImageName = @"StarGreen12";
        break;
    case BLUE:
        _selectedImageName = @"StarBlue12";
        break;
    case PURPLE:
        _selectedImageName = @"StarPurple12";
        break;
    case GREY:
        _selectedImageName = @"StarGrey12";
        break;
    default:
        break;
    }
}

- (void)setOnStateForSelectedMenuItem:(NSInteger)colorNumber
{
    switch (colorNumber) {
        case RED:
            _redItem.state = NSOnState;
            break;
        case ORANGE:
            _orangeItem.state = NSOnState;
            break;
        case YELLOW:
            _yellowItem.state = NSOnState;
            break;
        case GREEN:
            _greenItem.state = NSOnState;
            break;
        case BLUE:
            _blueItem.state = NSOnState;
            break;
        case PURPLE:
            _purpleItem.state = NSOnState;
            break;
        case GREY:
            _greenItem.state = NSOnState;
            break;
        default:
            break;
    }
}

- (Group *)persistGroupWithGroupImageName:(NSString *)groupImageName
{
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:_context];
    [group setValue:groupImageName forKeyPath:@"image"];
    NSError* saveError;
    [_context save:&saveError];
    return group;
}

- (NSArray*)fetchGroupWithGroupImageName:(NSString *)groupImageName
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"image = %@", groupImageName]];
    [request setFetchLimit:1];
    NSError* fetchError;
    NSArray* result = [_context executeFetchRequest:request error:&fetchError];
    return result;
}

- (Group*)fetchOrCreateGroupWithImageName:(NSString *)groupImageName
{
    NSArray *result = [self fetchGroupWithGroupImageName:groupImageName];
    Group* group;
    if ([result count] == 0) {
        group = [self persistGroupWithGroupImageName:groupImageName];
    }
    else {
        group = [result firstObject];
    }
    return group;
}

- (void)setUpRedItemTitle
{
    Group *redGroup = [self fetchOrCreateGroupWithImageName:@"StarRed12"];
    NSString *redGroupName = [redGroup name];
    if (redGroupName) {
        [_redItem setTitle:redGroupName];
    }
}

- (void)setUpOrangeItemTitle
{
    Group *orangeGroup = [self fetchOrCreateGroupWithImageName:@"StarOrange12"];
    NSString *orangeGroupName = [orangeGroup name];
    if (orangeGroupName) {
        [_orangeItem setTitle:orangeGroupName];
    }
}

- (void)setUpYellowItemTitle
{
    Group *yellowGroup = [self fetchOrCreateGroupWithImageName:@"StarYellow12"];
    NSString *yellowGroupName = [yellowGroup name];
    if (yellowGroupName) {
        [_yellowItem setTitle:yellowGroupName];
    }
}

- (void)setUpGreenItemTitle
{
    Group *greenGroup = [self fetchOrCreateGroupWithImageName:@"StarGreen12"];
    NSString *greenGroupName = [greenGroup name];
    if (greenGroupName) {
        [_greenItem setTitle:greenGroupName];
    }
}

- (void)setUpBlueItemTitle
{
    Group *blueGroup = [self fetchOrCreateGroupWithImageName:@"StarBlue12"];
    NSString *blueGroupName = [blueGroup name];
    if (blueGroupName) {
        [_blueItem setTitle:blueGroupName];
    }
}

- (void)setUpPurpleItemTitle
{
    Group *purpleGroup = [self fetchOrCreateGroupWithImageName:@"StarPurple12"];
    NSString *purpleGroupName = [purpleGroup name];
    if (purpleGroupName) {
        [_purpleItem setTitle:purpleGroupName];
    }
}

- (void)setUpGreyItemTitle
{
    Group *greyGroup = [self fetchOrCreateGroupWithImageName:@"StarGrey12"];
    NSString *greyGroupName = [greyGroup name];
    if (greyGroupName) {
        [_greyItem setTitle:greyGroupName];
    }
}

- (IBAction)didClickOnRed:(NSMenuItem*)sender
{
    [self setSelectedImageNameWithColorNumber:RED];
    [self setSelectedGroupName:[sender title]];
    [self toggleMenuItemsWhenClickedOnItem:sender];
    [_userDefaults setInteger:RED forKey:CCInitGroupColor];
    [_userDefaults setValue:[sender title] forKey:CCInitGroupName];
    [_groupControl setImage:[NSImage imageNamed:@"StarRed12"] forSegment:0];
}

- (IBAction)didClickOnOrange:(NSMenuItem*)sender
{
    [self setSelectedImageNameWithColorNumber:ORANGE];
    [self setSelectedGroupName:[sender title]];
    [self toggleMenuItemsWhenClickedOnItem:sender];
    [_userDefaults setInteger:ORANGE forKey:CCInitGroupColor];
    [_userDefaults setValue:[sender title] forKey:CCInitGroupName];
    [_groupControl setImage:[NSImage imageNamed:@"StarOrange12"] forSegment:0];
}

- (IBAction)didClickOnYellow:(NSMenuItem*)sender
{
    [self setSelectedImageNameWithColorNumber:YELLOW];
    [self setSelectedGroupName:[sender title]];
    [self toggleMenuItemsWhenClickedOnItem:sender];
    [_userDefaults setInteger:YELLOW forKey:CCInitGroupColor];
    [_userDefaults setValue:[sender title] forKey:CCInitGroupName];
    [_groupControl setImage:[NSImage imageNamed:@"StarYellow12"] forSegment:0];
}

- (IBAction)didClickOnGreen:(NSMenuItem*)sender
{
    [self setSelectedImageNameWithColorNumber:GREEN];
    [self setSelectedGroupName:[sender title]];
    [self toggleMenuItemsWhenClickedOnItem:sender];
    [_userDefaults setInteger:GREEN forKey:CCInitGroupColor];
    [_userDefaults setValue:[sender title] forKey:CCInitGroupName];
    [_groupControl setImage:[NSImage imageNamed:@"StarGreen12"] forSegment:0];
}

- (IBAction)didClickOnBlue:(NSMenuItem*)sender
{
    [self setSelectedImageNameWithColorNumber:BLUE];
    [self setSelectedGroupName:[sender title]];
    [self toggleMenuItemsWhenClickedOnItem:sender];
    [_userDefaults setInteger:BLUE forKey:CCInitGroupColor];
    [_userDefaults setValue:[sender title] forKey:CCInitGroupName];
    [_groupControl setImage:[NSImage imageNamed:@"StarBlue12"] forSegment:0];
}

- (IBAction)didClickOnPurple:(NSMenuItem*)sender
{
    [self setSelectedImageNameWithColorNumber:PURPLE];
    [self setSelectedGroupName:[sender title]];
    [self toggleMenuItemsWhenClickedOnItem:sender];
    [_userDefaults setInteger:PURPLE forKey:CCInitGroupColor];
    [_userDefaults setValue:[sender title] forKey:CCInitGroupName];
    [_groupControl setImage:[NSImage imageNamed:@"StarPurple12"] forSegment:0];
}

- (IBAction)didClickOnGrey:(NSMenuItem*)sender
{
    [self setSelectedImageNameWithColorNumber:GREY];
    [self setSelectedGroupName:[sender title]];
    [self toggleMenuItemsWhenClickedOnItem:sender];
    [_userDefaults setInteger:GREY forKey:CCInitGroupColor];
    [_userDefaults setValue:[sender title] forKey:CCInitGroupName];
    [_groupControl setImage:[NSImage imageNamed:@"StarGrey12"] forSegment:0];
}

- (void)toggleMenuItemsWhenClickedOnItem:(NSMenuItem*)menuItem
{
    NSArray *itemArray = [[menuItem menu] itemArray];
    for (NSMenuItem *item in itemArray) {
        item.state = (item == menuItem) ? NSOnState : NSOffState;
    }
}
















@end
