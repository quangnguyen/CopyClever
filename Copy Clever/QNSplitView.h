//
//  QNSplitView.h
//  CopyClever
//
//  Created by Quang Nguyen on 16/05/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QNSplitView : NSSplitView <NSSplitViewDelegate>

- (void)toggleLeftSubView;
- (BOOL)isLeftViewCollapsed;

@end
