#import "AsynchronityAppDelegate.h"


@implementation AsynchronityAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window addSubview:navigationController.view];
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end