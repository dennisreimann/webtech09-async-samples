#import <UIKit/UIKit.h>


@interface TweetsController : UITableViewController {
	NSMutableArray *tweets;
  @private
	IBOutlet UIBarButtonItem *refreshItem;
	IBOutlet UIActivityIndicatorView *activityView;
	BOOL isLoading;
}

@property (nonatomic, retain) NSMutableArray *tweets;
@property (nonatomic, readwrite) BOOL isLoading;

- (IBAction)loadTweets:(id)sender;

@end