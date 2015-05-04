//
//  ActionController.m
//  Pasteboard
//
//  Created by Quang Nguyen on 24/07/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "CommandActionController.h"

@implementation CommandActionController

+ (void)pasteCommand
{
    NSString* scriptPath = [[NSBundle mainBundle] pathForResource:@"sendkey" ofType:@"scpt"];
    NSURL* scriptURL = [NSURL fileURLWithPath:scriptPath];
    NSDictionary* errors;
    NSAppleScript* script = [[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&errors];
    [script executeAndReturnError:&errors];
}

@end
