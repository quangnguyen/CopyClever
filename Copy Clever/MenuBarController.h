//
//  MenubarController.h
//  CopyClever
//
//  Created by Quang Nguyen on 18/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "StatusItemView.h"

@interface MenuBarController : NSObject

@property (nonatomic, strong) NSStatusItem* statusItem;
@property (nonatomic, strong) StatusItemView* statusItemView;

@end
