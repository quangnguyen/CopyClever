//
//  DateUtility.m
//  CopyClever
//
//  Created by Quang Nguyen on 04/05/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (NSString*)convertDateToString:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.doesRelativeDateFormatting = YES;
    formatter.locale = [NSLocale currentLocale];
    formatter.dateStyle = NSDateFormatterShortStyle;
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        formatter.timeStyle = NSDateFormatterShortStyle;
    }
    return [formatter stringFromDate:date];
}

@end
