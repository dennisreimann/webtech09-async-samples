#import "TweetsController.h"
#import "CJSONDeserializer.h"
#import "Tweet.h"


@interface TweetsController ()
- (id)tweetsFromJSONData:(NSData *)theData;
- (void)loadedTweets:(id)theResult;
- (void)parseTweetsSynchronously;
- (void)parseTweetsInBackgroundThread;
@end


@implementation TweetsController

@synthesize tweets, isLoading;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadTweets:nil];
}

- (void)dealloc {
    [super dealloc];
	[tweets release];
	[refreshItem release];
	[activityView release];
}

#pragma mark Actions

- (IBAction)loadTweets:(id)sender {
	if (self.isLoading) return;
	self.isLoading = YES;
	[self parseTweetsSynchronously];
	//[self performSelectorInBackground:@selector(parseTweetsInBackgroundThread) withObject:nil];
}

- (void)parseTweetsSynchronously {   
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/public_timeline.json"];
	NSData *data = [NSData dataWithContentsOfURL:url];
    id result = [self tweetsFromJSONData:data];
	[self loadedTweets:result];
}

- (void)parseTweetsInBackgroundThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/public_timeline.json"];
	NSData *data = [NSData dataWithContentsOfURL:url];
    id result = [self tweetsFromJSONData:data];
	[self performSelectorOnMainThread:@selector(loadedTweets:) withObject:result waitUntilDone:YES];
    [pool release];
}

- (void)loadedTweets:(id)theResult {
	self.isLoading = NO;
	if ([theResult isKindOfClass:[NSError class]]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:[(NSError *)theResult localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		self.tweets = theResult;
		[self.tableView reloadData];
	}
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	Tweet *tweet = [tweets objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:14.0];
	cell.textLabel.text = tweet.text;
	cell.imageView.image = tweet.avatar;
    return cell;
}

#pragma mark Helpers

- (void)setIsLoading:(BOOL)loading {
	isLoading = loading;
	if (isLoading) {
		// Add an activity indicator to the navigation bar
		UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];
		self.navigationItem.rightBarButtonItem = activityItem;
		[activityItem release];
	} else {
		self.navigationItem.rightBarButtonItem = refreshItem;
	}
	
}

- (id)tweetsFromJSONData:(NSData *)theData {
	NSError *parseError = nil;
	NSDictionary *tweetsDict = [[CJSONDeserializer deserializer] deserialize:theData error:&parseError];
    NSMutableArray *tweetsArray = [NSMutableArray array];
    for (NSDictionary *tweetDict in tweetsDict) {
		NSString *text = [tweetDict valueForKey:@"text"];
		NSDictionary *userDict = [tweetDict valueForKey:@"user"];
		NSString *avatarURLString = [userDict valueForKey:@"profile_image_url"];
		NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
		NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
		UIImage *avatar = [UIImage imageWithData:avatarData];
		Tweet *tweet = [[Tweet alloc] initWithText:text andAvatar:avatar];
		[tweetsArray addObject:tweet];
    }
	return parseError ? (id)parseError : (id)tweetsArray;
}

@end