
#import "AdvancedPreferencesViewController.h"
#import "Common.h"
#import "PasteboardController.h"

@implementation AdvancedPreferencesViewController

#pragma mark -

- (id)init
{
    return [super initWithNibName:@"AdvancedPreferencesView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString*)identifier
{
    return @"AdvancedPreferences";
}

- (NSImage*)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString*)toolbarItemLabel
{
    return NSLocalizedString(@"Advanced", @"Toolbar item name for the Advanced preference pane");
}

- (void)awakeFromNib
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    float checkingInterval = [defaults floatForKey:CCCheckingInterval];
    [_checkingIntervalSlider setFloatValue:checkingInterval];
    [_checkingIntervalLabel setStringValue:[NSString stringWithFormat:@"%0.1f sec.", checkingInterval]];
}

- (void)viewDidDisappear
{
}

- (IBAction)changeIntervalSlider:(id)sender
{
    [_checkingIntervalLabel setStringValue:[NSString stringWithFormat:@"%0.1f sec.", [_checkingIntervalSlider floatValue]]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:[_checkingIntervalSlider floatValue] forKey:CCCheckingInterval];
    if ([[PasteboardController sharedInstance] isFetchTimerRunning]) {
        [[PasteboardController sharedInstance] restartPasteboardTimer];
    }
}
@end
