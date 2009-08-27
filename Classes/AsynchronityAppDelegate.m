#import "AsynchronityAppDelegate.h"
#import "AuthenticationController.h"
#import "RootViewController.h"


@implementation AsynchronityAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window addSubview:navigationController.view];
	[self authenticate];
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void)authenticate {
	authController = [[AuthenticationController alloc] initWithTarget:self andSelector:@selector(authenticationSucceeded:) andViewController:navigationController];
	[authController authenticate];
}

- (void)authenticationSucceeded:(BOOL)success {
	NSLog(@"Authentication succeeded: %@!", success ? @"YES" : @"NO");
	[authController release];
}

@end