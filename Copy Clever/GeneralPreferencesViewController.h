//
// This is a sample General preference pane
//

#import "MASPreferencesViewController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet NSButton *startAtLoginButton;
@property (weak) IBOutlet NSButton *restoreButton;
@property (weak) IBOutlet NSButton *notificationButton;



- (IBAction)launchAtLogInClicked:(NSButton *)sender;
- (IBAction)restoreClicked:(NSButton *)sender;
- (IBAction)notificationButtonClicked:(id)sender;


@end
