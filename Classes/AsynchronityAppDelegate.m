//
//  AsynchronityAppDelegate.m
//  Asynchronity
//
//  Created by Dennis Blöte on 25.08.09.
//  Copyright Dennis Blöte 2009. All rights reserved.
//

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

