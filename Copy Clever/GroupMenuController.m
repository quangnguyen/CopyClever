//
//  GroupMenuController.m
//  CopyClever
//
//  Created by Quang Nguyen on 2/21/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "GroupMenuController.h"

NSInteger const RED = 1;
NSInteger const ORANGE = 2;
NSInteger const YELLOW = 3;
NSInteger const GREEN = 4;
NSInteger const BLUE = 5;
NSInteger const PURPLE = 6;
NSInteger const GREY = 7;
NSString* const CCInitTagColor = @"InitTagColor";

@interface GroupMenuController ()

@end

@implementation GroupMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger colorNumber = [defaults integerForKey:CCInitTagColor];
    [self setColorForFirstSegment:colorNumber];
}

- (void)setColorForFirstSegment:(NSInteger)colorNumber
{
    switch (colorNumber) {
    case 1:
        _selectedImageName = @"StarRed12";
        _selectedGroupName = @"Red";
        break;
    case 2:
        _selectedImageName = @"StarOrange12";
        _selectedGroupName = @"Orange";
        break;
    case 3:
        _selectedImageName = @"StarYellow12";
        _selectedGroupName = @"Yellow";
        break;
    case 4:
        _selectedImageName = @"StarGreen12";
        _selectedGroupName = @"Green";
        break;
    case 5:
        _selectedImageName = @"StarBlue12";
        _selectedGroupName = @"Blue";
        break;
    case 6:
        _selectedImageName = @"StarPurple12";
        _selectedGroupName = @"Purple";
        break;
    case 7:
        _selectedImageName = @"StarGrey12";
        _selectedGroupName = @"Grey";
        break;
    default:
        break;
    }
}

- (IBAction)didClickOnRed:(id)sender
{
    [self setColorForFirstSegment:1];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:RED forKey:CCInitTagColor];
    [_groupControl setImage:[NSImage imageNamed:@"StarRed12"] forSegment:0];
}

- (IBAction)didClickOnOrange:(id)sender
{
    [self setColorForFirstSegment:2];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:ORANGE forKey:CCInitTagColor];
    [_groupControl setImage:[NSImage imageNamed:@"StarOrange12"] forSegment:0];
}

- (IBAction)didClickOnYellow:(id)sender
{
    [self setColorForFirstSegment:3];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:YELLOW forKey:CCInitTagColor];
    [_groupControl setImage:[NSImage imageNamed:@"StarYellow12"] forSegment:0];
}

- (IBAction)didClickOnGreen:(id)sender
{
    [self setColorForFirstSegment:4];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:GREEN forKey:CCInitTagColor];
    [_groupControl setImage:[NSImage imageNamed:@"StarGreen12"] forSegment:0];
}

- (IBAction)didClickOnBlue:(id)sender
{
    [self setColorForFirstSegment:5];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:BLUE forKey:CCInitTagColor];
    [_groupControl setImage:[NSImage imageNamed:@"StarBlue12"] forSegment:0];
}

- (IBAction)didClickOnPurple:(id)sender
{
    [self setColorForFirstSegment:6];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:PURPLE forKey:CCInitTagColor];
    [_groupControl setImage:[NSImage imageNamed:@"StarPurple12"] forSegment:0];
}

- (IBAction)didClickOnGrey:(id)sender
{
    [self setColorForFirstSegment:7];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:GREY forKey:CCInitTagColor];
    [_groupControl setImage:[NSImage imageNamed:@"StarGrey12"] forSegment:0];
}

@end
