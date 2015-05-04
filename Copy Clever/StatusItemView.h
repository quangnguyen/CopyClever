//
//  NewStatusItemView.h
//  Copy Clever
//
//  Created by Quang Nguyen on 1/16/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSView {
    NSStatusItem* _statusItem;
}

@property (nonatomic, strong) NSImage* image;
@property (nonatomic, strong) NSImage* alternateImage;

@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;

- (id)initWithStatusItem:(NSStatusItem*)statusItem;

@end
