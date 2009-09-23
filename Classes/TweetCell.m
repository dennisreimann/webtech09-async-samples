#import "TweetCell.h"


#define kAvatarPath @"avatar"

@implementation TweetCell

@synthesize tweet;

- (void)dealloc {
	[tweet removeObserver:self forKeyPath:kAvatarPath];
  	[tweet release];
	[avatarView release];
	[tweetLabel release];
	[usernameLabel release];
    [super dealloc];    
}

- (void)setTweet:(Tweet *)theTweet {
	[theTweet retain];
	[tweet release];
	tweet = theTweet;
	[tweet addObserver:self forKeyPath:kAvatarPath options:NSKeyValueObservingOptionNew context:nil];
	avatarView.image = tweet.avatar;
	tweetLabel.text = tweet.text;
	usernameLabel.text = tweet.fromUser;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kAvatarPath] && tweet.avatar) {
		avatarView.image = tweet.avatar;
	}
}

@end

