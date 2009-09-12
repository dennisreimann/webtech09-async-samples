#import "Tweet.h"


@implementation Tweet

@synthesize text, avatar;

- (id)initWithText:(NSString *)theText andAvatar:(UIImage *)theAvatar {
	[super init];
	self.text = theText;
	self.avatar = theAvatar;
	return self;
}

- (void)dealloc {
	[text release];
	[avatar release];
	[super dealloc];
}

@end
