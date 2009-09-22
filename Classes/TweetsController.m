#import "TweetsController.h"
#import "CJSONDeserializer.h"
#import "Tweet.h"
#import "TweetCell.h"


@interface TweetsController ()
- (NSURL *)connectionURL;
- (id)tweetsFromJSONData:(NSData *)theData;
- (void)loadedTweets:(id)theResult;
- (void)parseTweetsSynchronously;
- (void)parseTweetsWithCallback;
- (void)parseTweetsInBackgroundThread;
- (void)parseTweetsWithOperationQueue;
@end


@implementation TweetsController

@synthesize tweets, isLoading;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadTweets:nil];
}

- (void)dealloc {
	[tweets release];
	[tweetCell release];
	[refreshItem release];
	[activityView release];
	[receivedData release];
    [super dealloc];
}

#pragma mark Actions

- (IBAction)loadTweets:(id)sender {
	if (self.isLoading) return;
	self.isLoading = YES;
	
	//[self parseTweetsSynchronously];
	//[self parseTweetsWithCallback];
	[self performSelectorInBackground:@selector(parseTweetsInBackgroundThread) withObject:nil];
}

- (void)loadedTweets:(id)result {
	self.isLoading = NO;
	if ([result isKindOfClass:[NSError class]]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:[(NSError *)result localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		self.tweets = result;
		[self.tableView reloadData];
	}
}

#pragma mark Various methods for parsing tweets

// This methods loads tweets in a synchronous manner.
// Too bad: Synchronous loading blocks the UI... this approach fails on app
// launch, because all we see is a black screen until the tweets are loaded
// and lazy loading the avatars leads to laggy table view scrolling.
- (void)parseTweetsSynchronously {
	NSData *data = [NSData dataWithContentsOfURL:self.connectionURL];
    id result = [self tweetsFromJSONData:data];
	[self loadedTweets:result];
}

// Here we are using the NSURLConnection delegate methods
// This approach does not block the UI on app launch and reload, but is not
// suitable either, because lazy loading the avatars still does not work.
- (void)parseTweetsWithCallback {
	NSURLRequest *request = [NSURLRequest requestWithURL:self.connectionURL];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) receivedData = [[NSMutableData alloc] init];
}

// Using a background thread reduces the amount of code we have to write,
// because we do not have to implement the callback methods.
// Important: You need to define an autorelease pool for the spawned thread
// and be sure to perform the result handler back on the main thread!
- (void)parseTweetsInBackgroundThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSData *data = [NSData dataWithContentsOfURL:self.connectionURL];
    id result = [self tweetsFromJSONData:data];
	[self performSelectorOnMainThread:@selector(loadedTweets:) withObject:result waitUntilDone:YES];
    [pool release];
}

// FIXME: Implement me please
- (void)parseTweetsWithOperationQueue {

}

#pragma mark NSURLConnection callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
	id result = [self tweetsFromJSONData:receivedData];
	[self loadedTweets:result];
    [receivedData release];
	receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
	[self loadedTweets:error];
    [receivedData release];
	receivedData = nil;
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
	TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
		cell = tweetCell;
	}
	Tweet *tweet = [tweets objectAtIndex:indexPath.row];
	cell.tweet = tweet;
    return cell;
}

#pragma mark Helpers

- (NSURL *)connectionURL {
	return [NSURL URLWithString:@"http://search.twitter.com/search.json?q=iphone&rpp=50"];
}
	
- (void)setIsLoading:(BOOL)loading {
	isLoading = loading;
	if (isLoading) {
		// Replace the reload button with an activity indicator
		UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];
		self.navigationItem.rightBarButtonItem = activityItem;
		[activityItem release];
	} else {
		// Show the reload button again
		self.navigationItem.rightBarButtonItem = refreshItem;
	}
}

- (id)tweetsFromJSONData:(NSData *)data {
	NSError *parseError = nil;
	NSDictionary *tweetsDict = [[CJSONDeserializer deserializer] deserialize:data error:&parseError];
    NSMutableArray *tweetsArray = [NSMutableArray array];
    for (NSDictionary *tweetDict in [tweetsDict valueForKey:@"results"]) {
		Tweet *tweet = [[Tweet alloc] initWithJSONDictionary:tweetDict];
		[tweetsArray addObject:tweet];
    }
	return parseError ? (id)parseError : (id)tweetsArray;
}

@end