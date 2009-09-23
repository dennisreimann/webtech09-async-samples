#import <UIKit/UIKit.h>
#import "Tweet.h"


@interface LoadAvatarOperation : NSOperation {
	Tweet *tweet;
}

@property(retain) Tweet *tweet;

- (id)initWithTweet:(Tweet*)theTweet;

@end