
#import "GeneralPreferencesViewController.h"
#import <ServiceManagement/ServiceManagement.h>
#import "MASPreferencesWindowController.h"

@implementation GeneralPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

- (IBAction)launchAtLogInClicked:(NSButton *)sender {
    if (!SMLoginItemSetEnabled((__bridge CFStringRef)@"cleverstuffs.CopyCleverHelper", (BOOL)[sender state])) {
        NSLog(@"Issue while click on start at login button");
    } else {
        NSLog(@"State changed of start at login");
    }
}

- (IBAction)restoreClicked:(NSButton *)sender {
    
}

- (IBAction)notificationButtonClicked:(id)sender {
    
}

-(void)awakeFromNib {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL startAtLoginState = [defaults boolForKey:CCStartAtLogin];
    BOOL restorePasteboardState = [defaults boolForKey:CCRestorePasteboard];
    BOOL notificationState = [defaults boolForKey:CCNotificationCenter];
    
    if (startAtLoginState) {
        [_startAtLoginButton setState:NSOnState];
    }
    
    if (restorePasteboardState) {
        [_restoreButton setState:NSOnState];
    }

    if (notificationState) {
        [_notificationButton setState:NSOnState];
    }
    
}

-(void)viewDidDisappear {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[_startAtLoginButton state] forKey:CCStartAtLogin];
    [defaults setBool:[_restoreButton state] forKey:CCRestorePasteboard];
    [defaults setBool:[_notificationButton state] forKey:CCNotificationCenter];
}

@end
