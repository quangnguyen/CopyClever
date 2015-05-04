//
//  PopupCellController.h
//  Copy Clever
//
//  Created by Quang Nguyen on 2/6/15.
//  Copyright (c) 2015 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PopupCellController : NSViewController

@property (weak) IBOutlet NSView* contentView;
@property (weak) IBOutlet NSButton* doneButton;

- (IBAction)closePopover:(id)sender;

@end
