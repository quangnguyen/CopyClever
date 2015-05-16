//
//  ChangeGroupNameSheetController.m
//  CopyClever
//
//  Created by Quang Nguyen on 21/04/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "ChangeGroupNameSheetController.h"

@interface ChangeGroupNameSheetController ()

@end

@implementation ChangeGroupNameSheetController

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)didTapCancelButton:(id)sender
{
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)didTapDoneButton:(id)sender
{
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}

@end
