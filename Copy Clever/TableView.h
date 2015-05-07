//
//  TableView.h
//  CopyClever
//
//  Created by Quang Nguyen on 19/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol QuickLookTableViewDelegate <NSObject>

@required
- (void)didPressSpaceBarForTableView:(NSTableView*)tableView;

@end

@interface TableView : NSTableView

@property (nonatomic) NSInteger rightClickedRow;
@property (nonatomic, weak) IBOutlet id<QuickLookTableViewDelegate> quickLookDelegate;

@end
