#import "Tweet.h"
#import "LoadAvatarOperation.h"
#import "AsynchronityAppDelegate.h"


@interface Tweet ()
- (void)loadAvatarInBackgroundThread;
- (void)loadAvatarInOperationQueue;
@end


@implementation Tweet

@synthesize text, avatar, avatarURL, fromUser;

- (id)initWithJSONDictionary:(NSDictionary *)theDict {
	[super init];
	self.text = [theDict valueForKey:@"text"];
	self.fromUser = [theDict valueForKey:@"from_user"];
	NSString *avatarURLString = [theDict valueForKey:@"profile_image_url"];
	avatarURL = [[NSURL alloc] initWithString:avatarURLString];
	return self;
}

- (void)dealloc {
	[fromUser release];
	[text release];
	[avatar release];
	[avatarURL release];
	[super dealloc];
}

- (UIImage *)avatar {
	if (!avatar) {
		[self performSelectorInBackground:@selector(loadAvatarInBackgroundThread) withObject:nil];
		// [self loadAvatarInOperationQueue];
	}
	return avatar;
}

- (void)loadAvatarInBackgroundThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
	UIImage *avatarImage = [UIImage imageWithData:avatarData];
	[self performSelectorOnMainThread:@selector(setAvatar:) withObject:avatarImage waitUntilDone:YES];
	[pool release];
}

- (void)loadAvatarInOperationQueue {
	LoadAvatarOperation *loadOperation = [[LoadAvatarOperation alloc] initWithTweet:self];
	NSOperationQueue *queue = [[AsynchronityAppDelegate shared] queue];
	[queue addOperation:loadOperation];
	[loadOperation release];
}

@end
