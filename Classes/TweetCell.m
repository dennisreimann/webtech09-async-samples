#import "TweetCell.h"


@implementation TweetCell

@synthesize tweet;

- (void)dealloc {
	[avatarView release];
	[tweetLabel release];
	[usernameLabel release];
  	[tweet release];
    [super dealloc];    
}

- (void)setTweet:(Tweet *)theTweet {
	[theTweet retain];
	[tweet release];
	tweet = theTweet;
	[tweet addObserver:self forKeyPath:@"avatar" options:NSKeyValueObservingOptionNew context:nil];
	avatarView.image = tweet.avatar;
	tweetLabel.text = tweet.text;
	usernameLabel.text = tweet.fromUser;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"avatar"] && tweet.avatar) {
		avatarView.image = tweet.avatar;
	}
}

@end

