//
// This is a sample Advanced preference pane
//

#import "MASPreferencesViewController.h"

@interface AdvancedPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (weak) IBOutlet NSTextField* checkingIntervalLabel;
@property (weak) IBOutlet NSSlider* checkingIntervalSlider;

- (IBAction)changeIntervalSlider:(id)sender;

@end
