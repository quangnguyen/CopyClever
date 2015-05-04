//
//  PopupCellController.m
//  Copy Clever
//
//  Created by Quang Nguyen on 2/6/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "PopupCellController.h"

@interface PopupCellController ()

@end

@implementation PopupCellController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)closePopover:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClosePopover" object:self];
}
@end
