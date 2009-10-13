#import "LoadAvatarOperation.h"


@implementation LoadAvatarOperation

@synthesize tweet;

- (id)initWithTweet:(Tweet*)theTweet {
    [super init];
    self.tweet = theTweet;
    return self;
}

- (void)dealloc {
    [tweet release];
    [super dealloc];
}

- (void)main {
	if (self.isCancelled) return;
	NSData *avatarData = [NSData dataWithContentsOfURL:tweet.avatarURL];
	UIImage *avatarImage = [UIImage imageWithData:avatarData];
	[tweet performSelectorOnMainThread:@selector(setAvatar:) withObject:avatarImage waitUntilDone:YES];
}

@end
