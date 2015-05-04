//
//  PasteboardItemImage.m
//  CopyClever
//
//  Created by Quang Nguyen on 2/25/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "PasteboardItemImage.h"

@implementation PasteboardItemImage

@dynamic image;

- (NSString*)mainText
{
    NSMutableString* result = [NSMutableString string];
    if ([self image]) {
        NSNumberFormatter* formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [result appendString:[NSString stringWithFormat:@"TIFF: %@ bytes \n", [formatter stringFromNumber:[NSNumber numberWithUnsignedLong:[[[self image] TIFFRepresentation] length]]]]];

        NSBitmapImageRep* bitmapRep = [[[self image] representations] firstObject];
        NSData* dataPNG = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
        [result appendString:[NSString stringWithFormat:@"PNG: %@ bytes \n", [formatter stringFromNumber:[NSNumber numberWithUnsignedLong:[dataPNG length]]]]];
        NSData* dataJPG = [bitmapRep representationUsingType:NSJPEGFileType properties:nil];
        [result appendString:[NSString stringWithFormat:@"JPEG: %@ bytes", [formatter stringFromNumber:[NSNumber numberWithUnsignedLong:[dataJPG length]]]]];
    }

    return result;
}

- (NSString*)generateOverview
{
    NSMutableString* result = [NSMutableString string];
    [result appendString:@"Image Data: "];
    [result appendString:[NSString stringWithFormat:@"%d × %d px", (int)[[self image] size].width, (int)[[self image] size].height]];
    return result;
}

@end
