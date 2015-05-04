//
//  OverviewTextField.m
//  Copy Clever
//
//  Created by Quang Nguyen on 06/01/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "OverviewTextField.h"

@implementation OverviewTextField

- (void)textDidEndEditing:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OverviewNotification" object:self];
}

@end
