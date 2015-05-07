//
//  CellView.h
//  CopyClever
//
//  Created by Quang Nguyen on 21/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverviewTextField.h"

@interface BasisCellView : NSTableCellView

@property IBOutlet OverviewTextField* overviewTextField;
@property IBOutlet NSTextField* createdDateTextField;
@property IBOutlet NSImageView* clipIconView;
@property IBOutlet NSButton* groupButton;

@end
