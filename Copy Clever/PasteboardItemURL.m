//
//  PasteboardItemURL.m
//  CopyClever
//
//  Created by Quang Nguyen on 28/04/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import "PasteboardItemURL.h"

@implementation PasteboardItemURL

@dynamic filenames;
@dynamic url;

- (NSString*)generateOverview
{
    NSString* result;
    if ([self filenames]) {
        int filesCount = 0;
        int foldersCount = 0;
        BOOL isDir = NO;

        for (NSString* path in [self filenames]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
                foldersCount++;
            }
            else {
                filesCount++;
            }
        }

        if (filesCount == 1 && foldersCount == 0) {
            result = [NSString stringWithFormat:@"File, \"%@\"", [[[self filenames] firstObject] lastPathComponent]];
        }
        else if (filesCount == 0 && foldersCount == 1) {
            result = [NSString stringWithFormat:@"Folder, \"%@\"", [[[self filenames] firstObject] lastPathComponent]];
        }
        else if (filesCount > 1 && foldersCount == 0) {
            result = [NSString stringWithFormat:@"%d Files", filesCount];
        }
        else if (filesCount == 0 && foldersCount > 1) {
            result = [NSString stringWithFormat:@"%d Folders", foldersCount];
        }
        else if (filesCount == 1 && foldersCount == 1) {
            result = [NSString stringWithFormat:@"%d File and %d Folder", filesCount, foldersCount];
        }
        else if (filesCount > 1 && foldersCount == 1) {
            result = [NSString stringWithFormat:@"%d Files and %d Folder", filesCount, foldersCount];
        }
        else if (filesCount == 1 && foldersCount > 1) {
            result = [NSString stringWithFormat:@"%d File and %d Folders", filesCount, foldersCount];
        }
        else {
            result = [NSString stringWithFormat:@"%d Files and %d Folders", filesCount, foldersCount];
        }
        return result;
    }
    return @"";
}

- (NSString*)mainText
{
    NSMutableString* result = [NSMutableString string];
    if ([self filenames]) {
        for (NSString* file in [self filenames]) {
            [result appendString:[NSString stringWithFormat:@"%@ \n", file]];
        }
        return result;
    }
    return result;
}

@end
