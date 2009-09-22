#import <UIKit/UIKit.h>


@class TweetCell;

@interface TweetsController : UITableViewController {
	NSMutableArray *tweets;
  @private
	IBOutlet UIBarButtonItem *refreshItem;
	IBOutlet UIActivityIndicatorView *activityView;
	IBOutlet TweetCell *tweetCell;
	BOOL isLoading;
	NSMutableData *receivedData;
}

@property (nonatomic, retain) NSMutableArray *tweets;
@property (nonatomic, readonly) NSURL *connectionURL;
@property (nonatomic, readwrite) BOOL isLoading;

- (IBAction)loadTweets:(id)sender;

@end