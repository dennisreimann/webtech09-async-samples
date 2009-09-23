#import "AsynchronityAppDelegate.h"


@implementation AsynchronityAppDelegate

static AsynchronityAppDelegate *shared;

@synthesize queue;

- (id)init {
    if (shared) {
        [self autorelease];
        return shared;
    }
	[super init];
    queue = [[NSOperationQueue alloc] init];
	queue.maxConcurrentOperationCount = 3;
    shared = self;
    return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window addSubview:navigationController.view];
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[queue release];
	[super dealloc];
}

+ (id)shared; {
    if (!shared) [[AsynchronityAppDelegate alloc] init];
    return shared;
}

@end
