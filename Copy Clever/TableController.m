//
//  TableController.m
//  CopyClever
//
//  Created by Quang Nguyen on 19/08/14.
//  Copyright (c) 2014 Quang Nguyen. All rights reserved.
//

#import "TableController.h"
#import "ImageCellView.h"
#import "TextCellView.h"
#import "AppDelegate.h"
#import "TableRowView.h"
#import "PopupCellController.h"
#import "Group.h"
#import "PasteboardItemImage.h"
#import "PasteboardItemText.h"
#import "PasteboardItemURL.h"
#import "DateUtility.h"
#import "Common.h"

int const IMAGE_ITEM = 1;
int const TEXT_ITEM = 2;
int const URL_ITEM = 3;

@implementation TableController {
    NSPredicate* _searchPredicate;
    NSInteger popoverRow;
    NSManagedObjectContext* _context;
    NSUserDefaults* _userDefaults;
}

@synthesize tableView = _tableView;
@synthesize searchField = _searchField;
@synthesize arrayController = _arrayController;

#pragma mark Init

- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        popoverRow = -1;

        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        _context = [appDelegate managedObjectContext];

        _arrayController = [[NSArrayController alloc] init];
        [_arrayController setAvoidsEmptySelection:NO];
        [_arrayController setAutomaticallyPreparesContent:YES];
        [_arrayController setAlwaysUsesMultipleValuesMarker:YES];
        [_arrayController setManagedObjectContext:_context];
        [_arrayController setEntityName:@"PasteboardItem"];
        [_arrayController fetch:self];
        [_arrayController addObserver:self forKeyPath:@"arrangedObjects" options:NSKeyValueObservingOptionNew context:nil];
        
        NSSortDescriptor* sorter = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
        NSArray* descriptors = @[ sorter ];
        [_arrayController setSortDescriptors:descriptors];

        [[PasteboardController sharedInstance] addObserver:self forKeyPath:@"lastUpdated" options:NSKeyValueObservingOptionNew context:nil];
        _searchPredicate = [NSPredicate predicateWithFormat:@"mainText contains[cd] $value or overview contains[cd] $value"];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeOverview:)
                                                     name:@"OverviewNotification"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(closePopover:)
                                                     name:@"ClosePopover"
                                                   object:nil];

        id clipView = [[_tableView enclosingScrollView] contentView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(boundsChangeNotificationHandler:)
                                                     name:NSViewBoundsDidChangeNotification
                                                   object:clipView];
    }
    return self;
}

#pragma mark Callbacks

- (void)boundsChangeNotificationHandler:(NSNotification*)aNotification
{
    if ([aNotification object] == [[_tableView enclosingScrollView] contentView]) {
        if (![self isRowVisible:popoverRow]) {
            [_popover close];
            popoverRow = -1;
        }
    }
}

- (void)closePopover:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"ClosePopover"]) {
        [_popover close];
        popoverRow = -1;
    }
}

- (void)changeOverview:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"OverviewNotification"]) {
        NSString* newOverview = [[notification object] stringValue];
        OverviewTextField* overviewTextField = [notification object];
        BasisCellView* cellView = (BasisCellView*)[overviewTextField superview];
        NSInteger clickedRowNumber = [_tableView rowForView:cellView];
        PasteboardItem* item = [self objectAtIndex:clickedRowNumber];
        [item setOverview:newOverview];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"arrangedObjects"]) {
        [_tableView reloadData];
    }
    else if ([keyPath isEqualToString:@"lastUpdated"]) {
        NSLog(@"Received Update Notification");
    }
}

#pragma mark Items

- (id)objectAtIndex:(NSInteger)index
{
    if (index < [[_arrayController arrangedObjects] count]) {
        return [[_arrayController arrangedObjects] objectAtIndex:index];
    }
    else {
        return nil;
    }
}

- (NSArray*)objectsOfIndexes:(NSIndexSet*)indexSet
{
    return [[_arrayController arrangedObjects] objectsAtIndexes:indexSet];
}

- (BOOL)isRowVisible:(NSInteger)row
{
    CGRect cellRect = [_tableView rectOfRow:row];
    BOOL completelyVisible = CGRectContainsRect(_tableView.visibleRect, cellRect);
    return completelyVisible;
}

#pragma mark Setting up table view

- (NSInteger)numberOfRowsInTableView:(NSTableView*)tableView
{
    NSUInteger rowCount = [[_arrayController arrangedObjects] count];
    return rowCount;
}

- (NSTableRowView*)tableView:(NSTableView*)tableView rowViewForRow:(NSInteger)row
{
    static NSString* const kRowIdentifier = @"RowView";
    TableRowView* rowView = [tableView makeViewWithIdentifier:kRowIdentifier owner:self];
    if (!rowView) {
        rowView = [[TableRowView alloc] initWithFrame:NSZeroRect];
        rowView.identifier = kRowIdentifier;
    }
    return rowView;
}

- (void)setUpClipOfCellView:(BasisCellView*)cellView forPasteboardItem:(PasteboardItem*)pasteboardItem
{
    [cellView.clipIconView setImage:nil];
    if ([[pasteboardItem isLastUsedItem] boolValue]) {
        [cellView.clipIconView setImage:[NSImage imageNamed:@"PaperClipSmall"]];
    }
}

- (void)setUpGroupOfCellView:(BasisCellView*)cellView forPasteboardItem:(PasteboardItem*)pasteboardItem
{
    Group* group = [pasteboardItem valueForKey:@"group"];
    if (group) {
        [cellView.groupButton setImage:[NSImage imageNamed:[group image]]];
    }
    else {
        [cellView.groupButton setImage:[NSImage imageNamed:@"StarEmpty"]];
    }
}

- (void)setUpSourceAppImageOfCellView:(BasisCellView*)cellView forPasteboardItem:(PasteboardItem*)pasteboardItem
{
    [cellView.imageView setImage:[[pasteboardItem valueForKey:@"sourceApp"] valueForKey:@"image"]];
}

- (void)setUpCommonThingsOfCellView:(BasisCellView*)cellView forPasteboardItem:(PasteboardItem*)pasteboardItem
{
    [cellView.overviewTextField setStringValue:[pasteboardItem overview]];
    [cellView.createdDateTextField setStringValue:[DateUtility convertDateToString:[pasteboardItem createdDate]]];

    if ([pasteboardItem isKindOfClass:[PasteboardItemImage class]] || [pasteboardItem isKindOfClass:[PasteboardItemURL class]]) {
        [cellView.textField setStringValue:[pasteboardItem mainText]];
    }
    else if ([pasteboardItem isKindOfClass:[PasteboardItemText class]]) {
        if (![(PasteboardItemText*)pasteboardItem rtfData] && ![(PasteboardItemText*)pasteboardItem rtfdData]) {
            [cellView.textField setStringValue:[pasteboardItem mainText]];
        }
    }
    [self setUpClipOfCellView:cellView forPasteboardItem:pasteboardItem];
    [self setUpGroupOfCellView:cellView forPasteboardItem:pasteboardItem];
    [self setUpSourceAppImageOfCellView:cellView forPasteboardItem:pasteboardItem];
}

- (void)setUpImageCellView:(ImageCellView*)imageCellView forPasteboardItemImage:(PasteboardItemImage*)pasteboardItemImage
{
    [imageCellView.contentImageView setImageScaling:NSScaleProportionally];
    [imageCellView.contentImageView setImageAlignment:NSImageAlignTopRight];
    [imageCellView.contentImageView setImage:pasteboardItemImage.image];
}

- (void)setUpTextCellView:(TextCellView*)textCellView forPasteboardItemURL:(PasteboardItemURL*)pasteboardItemURL
{
    // If item is a path of one file then show the icon of it.
    if ([[pasteboardItemURL filenames] count] == 1) {
        NSString* path = [[pasteboardItemURL filenames] firstObject];
        BOOL isFolder;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isFolder];
        
        if (!isFolder) {
            NSString* fileType = [path pathExtension];
            if (![fileType isEqualToString:@""]) {
                NSImage* fileIcon = [[NSWorkspace sharedWorkspace] iconForFileType:fileType];
                [textCellView.imageView setImage:fileIcon];
            }
        }
    }
}

//TODO: Handle RTFD
- (void)setUpTextCellView:(TextCellView*)textCellView forPasteboardItemText:(PasteboardItemText*)pasteboardItemText
{
    if ([pasteboardItemText rtfdData]) {
        NSLog(@"RTFD");
    }
    else if ([pasteboardItemText rtfData]) {
        NSMutableAttributedString* rtfString = [[NSMutableAttributedString alloc] initWithRTF:[pasteboardItemText rtfData] documentAttributes:nil];
        BOOL resizeFont = [_userDefaults boolForKey:CCUseSameFont];
        if (resizeFont) {
            NSFont* font = [NSFont systemFontOfSize:11.0];
            NSRange range = NSMakeRange(0, rtfString.length);
            [rtfString addAttribute:NSFontAttributeName value:font range:range];
        }
        
        if (rtfString) {
            [textCellView.textField setAttributedStringValue:rtfString];
        }
    }
}

- (NSView*)tableView:(NSTableView*)tableView viewForTableColumn:(NSTableColumn*)tableColumn row:(NSInteger)row
{
    NSString* identifier = [tableColumn identifier];
    if ([identifier isEqualToString:@"Main"]) {
        PasteboardItem* pbItem = [self objectAtIndex:row];
        BOOL isImageCell = [pbItem isKindOfClass:[PasteboardItemImage class]];

        if (isImageCell) {
            ImageCellView* cellView = [tableView makeViewWithIdentifier:@"CellWithImageContent" owner:self];
            [self setUpCommonThingsOfCellView:cellView forPasteboardItem:pbItem];
            [self setUpImageCellView:cellView forPasteboardItemImage:(PasteboardItemImage*)pbItem];
            return cellView;
        }
        else {
            TextCellView* cellView = [tableView makeViewWithIdentifier:@"CellWithTextContent" owner:self];
            [self setUpCommonThingsOfCellView:cellView forPasteboardItem:pbItem];
            if ([pbItem isKindOfClass:[PasteboardItemURL class]]) {
                [self setUpTextCellView:cellView forPasteboardItemURL:(PasteboardItemURL*)pbItem];
            }
            else if ([pbItem isKindOfClass:[PasteboardItemText class]]) {
                [self setUpTextCellView:cellView forPasteboardItemText:(PasteboardItemText*)pbItem];
            }
            return cellView;
        }
    }
    return nil;
}

#pragma mark Pasteboard manager

- (BOOL)copySelectedItemToPasteboard
{
    BOOL result = NO;
    NSIndexSet* indexes = [_tableView selectedRowIndexes];
    if (indexes.count == 1) {
        PasteboardItem* movedItem = [self objectAtIndex:[indexes firstIndex]];
        [PasteboardController sharedInstance].changesCount = [[NSPasteboard generalPasteboard] changeCount] + 2;
        result = [[PasteboardController sharedInstance] copyItemToPasteboard:movedItem];

        if (result) {
            [_tableView reloadData];
        }
    }
    return result;
}

- (void)removeObjectsAtIndexes:(NSIndexSet*)indexes
{
    [_arrayController removeObjectsAtArrangedObjectIndexes:indexes];
    [_deleteButton setEnabled:NO];
    [_quickLookButton setEnabled:NO];
    [[_groupMenuController clearGroupMenuItem] setEnabled:NO];
}

#pragma Quick View

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel*)panel
{
    return [[(PasteboardItemURL*)[self objectAtIndex:[_tableView selectedRow]] filenames] count];
}

- (id<QLPreviewItem>)previewPanel:(QLPreviewPanel*)panel previewItemAtIndex:(NSInteger)index
{
    NSString* path = [(PasteboardItemURL*)[self objectAtIndex:[_tableView selectedRow]] filenames][index];
    NSURL* url = [NSURL fileURLWithPath:path];
    return url;
}

- (BOOL)previewPanel:(QLPreviewPanel*)panel handleEvent:(NSEvent*)event
{
    if ([event type] == NSKeyDown) {
        [_tableView keyDown:event];
        return YES;
    }
    return NO;
}

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel*)panel
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel*)panel
{
    panel.dataSource = self;
    panel.delegate = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel*)panel
{
    panel.dataSource = nil;
    panel.delegate = nil;
}

#pragma mark Actions

- (IBAction)clickOnGroupButtonInCell:(id)sender
{
    BasisCellView* cellView = (BasisCellView*)[sender superview];
    if (cellView && [_groupMenuController selectedGroupName]) {
        NSString* groupImageName = [_groupMenuController selectedImageName];
        Group* group = [_groupMenuController fetchOrCreateGroupWithImageName:groupImageName];
        NSInteger row = [_tableView rowForView:cellView];
        PasteboardItem* item = [self objectAtIndex:row];
        [group addPasteboardItemObject:item];
        [_tableView reloadData];
    }
}

- (void)clickOnGroupSegmentButton:(id)sender {
    NSArray* arrayOfSelectedObjects = [_arrayController selectedObjects];
    if (arrayOfSelectedObjects.count > 0) {
        NSString* groupImageName = [_groupMenuController selectedImageName];
        Group* group = [_groupMenuController fetchOrCreateGroupWithImageName:groupImageName];
        NSSet* setOfItems = [NSSet setWithArray:arrayOfSelectedObjects];
        [group addPasteboardItem:setOfItems];
        [_tableView reloadData];
    }
    
}

- (IBAction)clickOnClearGroup:(id)sender
{
    NSArray* arrayOfSelectedObjects = [_arrayController selectedObjects];
    if (arrayOfSelectedObjects.count > 0) {
        for (PasteboardItem* item in arrayOfSelectedObjects) {
            [item setGroup:nil];
        }
        [_tableView reloadData];
    }
}

- (IBAction)clickOnCopyButton:(id)sender
{
    [self copySelectedItemToPasteboard];
}

- (IBAction)clickOnDeleteButton:(id)sender
{
    [self removeObjectsAtIndexes:[_tableView selectedRowIndexes]];
}

- (IBAction)clickOnPreviewButton:(id)sender
{
    NSInteger clickedRow = [_tableView selectedRow];
    popoverRow = clickedRow;

    switch ([self kindOfPasteboardItemAtRow:clickedRow]) {
    case URL_ITEM:
        [self showOrClosePreviewPanelOfRow:clickedRow];
        break;

    default:
        [self showPopupContentOfRow:clickedRow];
        break;
    }
}

#pragma mark Popup Views

- (void)didPressSpaceBarForTableView:(NSTableView*)tableView
{
    NSInteger selectedRow = [tableView selectedRow];

    if ([self kindOfPasteboardItemAtRow:selectedRow] == URL_ITEM) {
        [self showOrClosePreviewPanelOfRow:selectedRow];
    }
    else {
        popoverRow = selectedRow;
        [self showPopupContentOfRow:popoverRow];
    }
}

- (void)showOrClosePreviewPanelOfRow:(NSInteger)row
{
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        if (row == popoverRow) {
            [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
        }
        else {
            [[QLPreviewPanel sharedPreviewPanel] reloadData];
            popoverRow = row;
        }
    }
    else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
        [[QLPreviewPanel sharedPreviewPanel] reloadData];
    }
}

- (void)showPopupContentOfRow:(NSInteger)row
{
    BasisCellView* cellViewOfButton = [_tableView viewAtColumn:0 row:row makeIfNecessary:NO];
    NSView* displayView = [self makePopupViewOfRow:row];
    if (_popover) {
        [_popover close];
    }
    [self showPopupWithContentView:displayView atCellView:cellViewOfButton];
}

- (void)showPopupWithContentView:(NSView*)contentView atCellView:(NSTableCellView*)cellView
{
    if (contentView) {
        PopupCellController* controller = nil;
        _popover = [[NSPopover alloc] init];
        if (_popover.contentViewController && [_popover.contentViewController isKindOfClass:[PopupCellController class]]) {
            controller = (PopupCellController*)_popover.contentViewController;
        }
        else {
            controller = [[PopupCellController alloc] initWithNibName:NSStringFromClass([PopupCellController class]) bundle:nil];
            _popover.contentViewController = controller;
        }
        _popover.behavior = NSPopoverBehaviorApplicationDefined;

        if ([contentView isKindOfClass:[NSImageView class]]) {
            CGRect newFrame = controller.view.frame;
            double verticalOffset = newFrame.size.height - controller.contentView.frame.size.height;
            double minimumWidth = controller.doneButton.frame.size.width;
            if (contentView.frame.size.width > minimumWidth) {
                newFrame.size.width = contentView.frame.size.width;
            }
            else {
                newFrame.size.width = minimumWidth;
            }
            newFrame.size.height = contentView.frame.size.height + verticalOffset;
            [controller.view setFrame:newFrame];
            [controller.contentView addSubview:contentView];
        }
        else {
            [controller.view addSubview:contentView];
        }
        [_popover showRelativeToRect:cellView.frame ofView:cellView preferredEdge:NSMinXEdge];
    }
}

- (NSView*)makePopupViewOfRow:(NSInteger)row
{
    NSView* displayView;
    NSInteger kindOfItem = [self kindOfPasteboardItemAtRow:row];

    if (kindOfItem == TEXT_ITEM) {
        displayView = [self makeTextViewInPopupOfRow:row];
    }
    else if (kindOfItem == IMAGE_ITEM) {
        displayView = [self makeImageViewInPopupOfRow:row];
    }
    return displayView;
}

- (NSScrollView*)makeTextViewInPopupOfRow:(NSInteger)row
{
    NSRect frameRect = NSMakeRect(5, 40, 590, 405);
    NSScrollView* scrollView = [[NSScrollView alloc] initWithFrame:frameRect];
    [scrollView setDrawsBackground:NO];
    [scrollView setBorderType:NSBezelBorder];
    NSSize contentSize = [scrollView contentSize];
    NSTextView* textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];

    PasteboardItemText* pbItem = [self objectAtIndex:row];
    NSAttributedString* rtfString = [[NSAttributedString alloc] initWithRTF:[pbItem rtfData] documentAttributes:nil];

    [textView setEditable:YES];
    if (rtfString) {
        [[textView textStorage] setAttributedString:rtfString];
    }
    else if ([pbItem stringValue]) {
        [textView insertText:[pbItem stringValue]];
    }
    [textView setEditable:NO];
    [textView setBackgroundColor:[NSColor colorWithDeviceWhite:1 alpha:0.8f]];
    [scrollView setDocumentView:textView];
    return scrollView;
}

- (NSImageView*)makeImageViewInPopupOfRow:(NSInteger)row
{
    PasteboardItemImage* pbItem = [self objectAtIndex:row];
    NSImage* image = [pbItem image];
    NSSize imageSize = image.size;

    while (imageSize.height > 1200 || imageSize.width > 900) {
        imageSize.height = imageSize.height * 0.95;
        imageSize.width = imageSize.width * 0.95;
    }

    NSRect frameRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);
    NSImageView* imageView = [[NSImageView alloc] initWithFrame:frameRect];

    [imageView setImage:image];
    return imageView;
}

- (NSInteger)kindOfPasteboardItemAtRow:(NSInteger)row
{
    if (row >= 0) {
        PasteboardItem* item = [self objectAtIndex:row];
        if ([item isKindOfClass:[PasteboardItemText class]]) {
            return TEXT_ITEM;
        }
        else if ([item isKindOfClass:[PasteboardItemImage class]]) {
            return IMAGE_ITEM;
        }
        else if ([item isKindOfClass:[PasteboardItemURL class]]) {
            return URL_ITEM;
        }
    }
    return NSNotFound;
}

#pragma mark Callbacks

- (void)tableViewSelectionDidChange:(NSNotification*)notification
{
    [_deleteButton setEnabled:YES];
    [_quickLookButton setEnabled:[[_tableView selectedRowIndexes] count] == 1];
    [[_groupMenuController clearGroupMenuItem] setEnabled:YES];
}

- (void)controlTextDidChange:(NSNotification*)notification
{
    NSString* stringOnSearchField = [_searchField stringValue];
    if ([stringOnSearchField length] > 0) {
        NSDictionary* dictionary = @{ @"value" : stringOnSearchField };
        NSPredicate* predicate = [_searchPredicate predicateWithSubstitutionVariables:dictionary];
        [_arrayController setFilterPredicate:predicate];
    }
    else {
        [_arrayController setFilterPredicate:nil];
    }
    [_tableView reloadData];
}

- (void)controlTextDidEndEditing:(NSNotification*)notification
{
    NSString* stringOnSearchField = [_searchField stringValue];
    if (stringOnSearchField.length == 0) {
        [_arrayController setFilterPredicate:nil];
    }
}

@end
