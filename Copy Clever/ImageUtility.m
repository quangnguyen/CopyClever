//
//  ImageUtility.m
//  CopyClever
//
//  Created by Quang Nguyen on 04/05/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "ImageUtility.h"

@implementation ImageUtility

+ (NSImage*)scaleImageTo60px60px:(NSImage*)image
{
    NSImage* scaledImage = [[NSImage alloc] initWithSize:NSMakeSize(60, 60)];
    NSSize originalSize = [image size];
    NSRect fromRect = NSMakeRect(0, 0, originalSize.width, originalSize.height);
    [scaledImage lockFocus];
    [image drawInRect:NSMakeRect(0, 0, 60, 60) fromRect:fromRect operation:NSCompositeCopy fraction:1.0f];
    [scaledImage unlockFocus];
    return scaledImage;
}

@end
