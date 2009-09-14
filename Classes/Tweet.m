#import "Tweet.h"


@implementation Tweet

@synthesize text, avatar;

- (id)initWithJSONDictionary:(NSDictionary *)theDict {
	[super init];
	self.text = [theDict valueForKey:@"text"];
	// Avatar
	NSDictionary *userDict = [theDict valueForKey:@"user"];
	NSString *avatarURLString = [userDict valueForKey:@"profile_image_url"];
	avatarURL = [[NSURL alloc] initWithString:avatarURLString];
	return self;
}

- (void)dealloc {
	[text release];
	[avatar release];
	[avatarURL release];
	[super dealloc];
}

// Lazy loading
- (UIImage *)avatar {
	if (!avatar) {
		NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
		self.avatar = [UIImage imageWithData:avatarData];
	}
	return avatar;
}


@end
