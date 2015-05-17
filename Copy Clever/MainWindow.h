//
//  MainWindow.h
//  CopyClever
//
//  Created by Quang Nguyen on 27/04/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QNSplitView.h"

@interface MainWindow : NSWindow

@property (weak) IBOutlet QNSplitView *splitView;
@property (weak) IBOutlet NSButton *toggleLeftViewButton;

- (IBAction)toggleLeftView:(id)sender;
@end
