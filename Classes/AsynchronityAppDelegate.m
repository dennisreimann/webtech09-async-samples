//
//  AsynchronityAppDelegate.m
//  Asynchronity
//
//  Created by Dennis Blöte on 25.08.09.
//  Copyright Dennis Blöte 2009. All rights reserved.
//

#import "AsynchronityAppDelegate.h"
#import "RootViewController.h"


@implementation AsynchronityAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

