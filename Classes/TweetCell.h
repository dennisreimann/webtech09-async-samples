#import <UIKit/UIKit.h>
#import "Tweet.h"


@interface TweetCell : UITableViewCell {
	Tweet *tweet;
  @private
	IBOutlet UIImageView *avatarView;
	IBOutlet UILabel *usernameLabel;
	IBOutlet UILabel *tweetLabel;
}

@property (nonatomic, retain) Tweet *tweet;

@end
