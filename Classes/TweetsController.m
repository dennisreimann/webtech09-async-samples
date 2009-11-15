#import "TweetsController.h"
#import "CJSONDeserializer.h"
#import "Tweet.h"
#import "TweetCell.h"


@interface TweetsController ()
@property (nonatomic, readonly) NSURL *connectionURL;
@property (nonatomic, readwrite) BOOL isLoading;

- (NSURL *)connectionURL;
- (id)tweetsFromJSONData:(NSData *)theData;
- (void)loadedTweets:(id)theResult;
- (void)parseTweetsSynchronously;
- (void)parseTweetsWithCallback;
- (void)parseTweetsInBackgroundThread;
@end


@implementation TweetsController

@synthesize tweets, isLoading;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Tweets";
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























#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TweetCell";
	TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
		cell = tweetCell;
	}
	Tweet *tweet = [tweets objectAtIndex:indexPath.row];
	cell.tweet = tweet;
    return cell;
}























#pragma mark Loading Tweets

- (NSURL *)connectionURL {
	return [NSURL URLWithString:@"http://search.twitter.com/search.json?q=iphone&rpp=100"];
}

- (IBAction)loadTweets:(id)sender {
	if (self.isLoading) return;
	self.isLoading = YES;
	// -------------------------------------------
	// Different approaches for parsing the tweets
	// -------------------------------------------
	[self parseTweetsSynchronously];
	//[self parseTweetsWithCallback];
	//[self performSelectorInBackground:@selector(parseTweetsInBackgroundThread) withObject:nil];
}

// Toggles the reload button and activity indicator
- (void)setIsLoading:(BOOL)loading {
	isLoading = loading;
	if (isLoading) {
		UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];
		self.navigationItem.rightBarButtonItem = activityItem;
		[activityItem release];
	} else {
		self.navigationItem.rightBarButtonItem = refreshItem;
	}
}

// Converts the JSON response to Tweet objects
- (id)tweetsFromJSONData:(NSData *)data {
	NSError *parseError = nil;
	NSDictionary *tweetsDict = [[CJSONDeserializer deserializer] deserialize:data error:&parseError];
    NSMutableArray *tweetsArray = [NSMutableArray array];
    for (NSDictionary *tweetDict in [tweetsDict valueForKey:@"results"]) {
		Tweet *tweet = [[Tweet alloc] initWithJSONDictionary:tweetDict];
		[tweetsArray addObject:tweet];
		[tweet release];
    }
	return parseError ? (id)parseError : (id)tweetsArray;
}

// Displays the tweets or shows an error alert
- (void)loadedTweets:(id)result {
	self.isLoading = NO;
	if (![result isKindOfClass:[NSError class]]) {
		self.tweets = result;
		[self.tableView reloadData];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:[(NSError *)result localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}































#pragma mark 1. Approach: Synchronous approach

- (void)parseTweetsSynchronously {
	NSData *data = [NSData dataWithContentsOfURL:self.connectionURL];
    id result = [self tweetsFromJSONData:data];
	[self loadedTweets:result];
}





























#pragma mark 2. Approach: Callback approach

- (void)parseTweetsWithCallback {
	NSURLRequest *request = [NSURLRequest requestWithURL:self.connectionURL];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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





























#pragma mark 3. Approach: Background thread

- (void)parseTweetsInBackgroundThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSData *data = [NSData dataWithContentsOfURL:self.connectionURL];
    id result = [self tweetsFromJSONData:data];
	[self performSelectorOnMainThread:@selector(loadedTweets:) withObject:result waitUntilDone:YES];
    [pool release];
}
























@end