#import "Tweet.h"


@interface Tweet ()
- (void)loadAvatarInBackgroundThread;
@end


@implementation Tweet

@synthesize text, avatar, fromUser;

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
		// Synchronous lazy loading
//		NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
//		self.avatar = [UIImage imageWithData:avatarData];
		// Lazy loading in background thread
		[self performSelectorInBackground:@selector(loadAvatarInBackgroundThread) withObject:nil];
		// Lazy loading with operation queue
//		FIXME: Implement me please
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

@end
